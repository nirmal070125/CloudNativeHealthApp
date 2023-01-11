//  Copyright (c) 2022 WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
//
//This software is the property of WSO2 LLC. and its suppliers, if any.
//Dissemination of any information or reproduction of any material contained
//herein is strictly forbidden, unless permitted by WSO2 in accordance with
//the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
//For specific language governing the permissions and limitations under
//this license, please see the license as well as any agreement you’ve
//entered into with WSO2 governing the purchase of this software and any associated services.

import ballerina/http;
import wso2healthcare/healthcare.clients.fhirr4;

configurable string base = ?;
configurable string tokenUrl = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string[] scopes = ?;
configurable string domain = ?;


fhirr4:FHIRConnectorConfig cernerConfig = {
    baseURL: base,
    mimeType: fhirr4:FHIR_JSON
};

http:OAuth2ClientCredentialsGrantConfig cernerOauth = {
    tokenUrl: tokenUrl,
    clientId: clientId,
    clientSecret: clientSecret,
    scopes: scopes
};

http:ClientConfiguration cernerClientConfig = {
    auth: cernerOauth
};

final fhirr4:FHIRConnector fhirConnectorObj = check new (cernerConfig, cernerClientConfig);

@http:ServiceConfig{
    interceptors: [new urlRewriteInterceptor(base, domain)]
}
service http:Service /fhir/r4 on new http:Listener(9090) {
    
    // Get resource by ID
    isolated resource function get [string resType]/[string id]() returns http:Response {
        
        fhirr4:FHIRResponse|fhirr4:FHIRError fhirResponse = fhirConnectorObj->getById(resType, id);
        return handleResponse(fhirResponse);
    }

    // Create a resource
    isolated resource function post [string resType](@http:Payload json|xml resPayload) returns http:Response {
        
        string rtype;
        do {
            rtype = check extractResourceType(resPayload);
        } on fail error e {
            return handleError("Error occured while extracting the resource type.");
        }
        if (rtype != resType) {
            return handleError("Request payload mismatch with requested resource.");
        }
        fhirr4:FHIRResponse|fhirr4:FHIRError fhirResponse = fhirConnectorObj->create(resPayload);
        return handleResponse(fhirResponse);
    }

    // Patch a resource
    isolated resource function patch [string resType]/[string id](http:Request request, @http:Payload json|xml resPayload) returns http:Response {
        
        fhirr4:PatchContentType patchType;
        do {
            patchType = <fhirr4:PatchContentType>request.getContentType();
        } on fail error e {
            return handleError("Unsupported Patch Content Type");
        }
        fhirr4:FHIRResponse|fhirr4:FHIRError fhirResponse = fhirConnectorObj->patch(resType, id, resPayload, patchContentType = patchType);
        return handleResponse(fhirResponse);
    }

    // Delete a resource
    isolated resource function delete [string resType]/[string id]() returns http:Response {
        
        fhirr4:FHIRResponse|fhirr4:FHIRError fhirResponse = fhirConnectorObj->delete(resType, id);
        return handleResponse(fhirResponse);
    }

    // Update a resource
    isolated resource function put [string resType](@http:Payload json|xml resPayload) returns http:Response {
        
        string rtype;
        do {
            rtype = check extractResourceType(resPayload);
        } on fail error e {
            return handleError("Error occured while extracting the resource type.");
        }
        if (rtype != resType) {
            return handleError("Request payload mismatch with requested resource.");
        }
        fhirr4:FHIRResponse|fhirr4:FHIRError fhirResponse = fhirConnectorObj->update(resPayload);
        return handleResponse(fhirResponse);
    }

    // Get metadata
    isolated resource function get metadata(http:Request r) returns http:Response {
        
        fhirr4:FHIRResponse|fhirr4:FHIRError fhirResponse = fhirConnectorObj->getConformance();
        return handleResponse(fhirResponse);
    }

    // Search through a resource type
    isolated resource function get [string resType](http:Request request) returns http:Response {
        
        fhirr4:FHIRResponse|fhirr4:FHIRError fhirResponse = fhirConnectorObj->search(resType, request.getQueryParams());
        return handleResponse(fhirResponse);
    
    }

    isolated resource function 'default [string... paths](http:Request req) returns http:Response {
        return handleError("Unsupported");
    }
}

isolated function handleResponse(fhirr4:FHIRResponse|fhirr4:FHIRError fhirResponse) returns http:Response {
    http:Response finalResponse = new();
        if (fhirResponse is fhirr4:FHIRResponse) {
            finalResponse.statusCode = fhirResponse.httpStatusCode;
            finalResponse.setPayload(fhirResponse.'resource);
            string contentType = fhirResponse.serverResponseHeaders.get("Content-Type");
            error? contentTypeResult = finalResponse.setContentType(contentType);
            if contentTypeResult is error {
                finalResponse.setPayload(getOperationOutcome("Error occured when constructing the response payload"));
                finalResponse.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;
            }
        } else {
            if (fhirResponse is fhirr4:FHIRServerError) {
                finalResponse.statusCode = fhirResponse.detail().httpStatusCode;
                string contentType = fhirResponse.detail().serverResponseHeaders.get("Content-Type");
                error? contentTypeResult = finalResponse.setContentType(contentType);
                if contentTypeResult is error {
                    finalResponse.setPayload(getOperationOutcome("Error occured when constructing the response payload"));
                    finalResponse.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;
                }
                finalResponse.setPayload(fhirResponse.detail().'resource);
            } else {
                finalResponse.setPayload(getOperationOutcome(fhirResponse.detail().toString()));
                finalResponse.statusCode = http:STATUS_INTERNAL_SERVER_ERROR;
            }
        }
        return finalResponse;
}

isolated function handleError(string msg, int statusCode = http:STATUS_INTERNAL_SERVER_ERROR) returns http:Response {
    http:Response finalResponse = new();
    finalResponse.setPayload(getOperationOutcome(msg));
    finalResponse.statusCode = statusCode;
    return finalResponse;
}

// todo: remove these once fhir base is released
isolated function getOperationOutcome(string detail) returns json {

    return {
        "resourceType": "OperationOutcome",
        "issue": [
            {
                "severity": "error",
                "code": "error",
                "details": {
                    "text": detail
                }
            }
        ]
    };
}
