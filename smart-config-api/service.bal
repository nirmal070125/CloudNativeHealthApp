// Copyright (c) 2022, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.

// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein is strictly forbidden, unless permitted by WSO2 in accordance with
// the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
// For specific language governing the permissions and limitations under
// this license, please see the license as well as any agreement you’ve
// entered into with WSO2 governing the purchase of this software and any
// associated services.

import healthcare.fhir.r4.api.smartconfiguration.constants;
import healthcare.fhir.r4.api.smartconfiguration.handlers;
import healthcare.fhir.r4.api.smartconfiguration.models;
import ballerina/time;
import ballerina/http;

SmartConfigurationGenerator smartConfigurationGenerator = new();
final readonly & models:SmartConfiguration smartConfiguration = check smartConfigurationGenerator.generate().cloneReadOnly();

service class ServiceErrorInterceptor {
    *http:ResponseErrorInterceptor;
    remote function interceptResponseError(error err) returns http:InternalServerError {
        handlers:IssueHandler issueHandler = new("Service");
        issueHandler.addServiceError(createServiceError(constants:FATAL, constants:PROCESSING, err, constants:INTERNAL_SERVER_ERROR));
        return handleServiceErrors(issueHandler);
    }
}

# The service representing well known API
# Bound to port defined by configs
# Service response error interceptor
ServiceErrorInterceptor serviceErrorInterceptor = new();

# The service representing well known API
# Bound to port defined by configs
@http:ServiceConfig{
   interceptors: [serviceErrorInterceptor]
}
service / on new http:Listener(9090) {

    # The authorization endpoints accepted by a FHIR resource server are exposed as a Well-Known Uniform Resource Identifiers (URIs) (RFC5785) JSON document.
    # Reference: https://build.fhir.org/ig/HL7/smart-app-launch/conformance.html#using-well-known
    # + return - Smart configuration
    resource isolated function get fhir/r4/\.well\-known/smart\-configuration() returns json|http:InternalServerError {
        handlers:IssueHandler issueHandler = new("Service");
        handlers:LogHandler logHandler = new("Service");

        json|error response = smartConfiguration.toJson();

        if response is json {
            logHandler.Debug("Smart configuration served at " + time:utcNow()[0].toString());
            return response;
        } else {
            issueHandler.addServiceError(createServiceError(constants:FATAL, constants:PROCESSING, response, constants:INTERNAL_SERVER_ERROR));
            return handleServiceErrors(issueHandler);
        }
    }
}
