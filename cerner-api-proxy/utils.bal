//  Copyright (c) 2022 WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
//
//This software is the property of WSO2 LLC. and its suppliers, if any.
//Dissemination of any information or reproduction of any material contained
//herein is strictly forbidden, unless permitted by WSO2 in accordance with
//the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
//For specific language governing the permissions and limitations under
//this license, please see the license as well as any agreement you’ve
//entered into with WSO2 governing the purchase of this software and any associated services.

import ballerina/regex;

type XmlNameSpaceNRoot record {|
    string? namespace;
    string? rootName;
|};

const string XML_ID = "id";

isolated function extractResourceType(json|xml data, boolean extractId = true) returns string|error {
    string? rType = ();
    
    if data is json {
        json|error typeValue = data.resourceType;
        if typeValue is json {
            rType = typeValue.toString();
        } else {
            return error("Error when retrieving resource type");
        }
    } else {
        xml:Element rootElement = <xml:Element>data;
        XmlNameSpaceNRoot xmlValues = extractXmlNamespaceNRoot(rootElement.getName());
        rType = xmlValues.rootName ?: "";
    }
    if rType == () {
        return error("Resource type not found");
    }
    return rType;
}

isolated function extractXmlNamespaceNRoot(string element) returns XmlNameSpaceNRoot {
    XmlNameSpaceNRoot data = {namespace: (), rootName: ()};
    string[] split = regex:split(element, "}");
    if split.length() == 1 {
        data.rootName = split[0];
    } else {
        data.rootName = split[1];
        string namespace = split[0];
        if namespace.startsWith("{") {
            data.namespace = namespace.substring(1);
        }
    }
    return data;
}
