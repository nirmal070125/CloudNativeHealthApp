//  Copyright (c) 2022 WSO2 LLC. (http://www.wso2.com). All Rights Reserved.
//
//This software is the property of WSO2 LLC. and its suppliers, if any.
//Dissemination of any information or reproduction of any material contained
//herein is strictly forbidden, unless permitted by WSO2 in accordance with
//the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
//For specific language governing the permissions and limitations under
//this license, please see the license as well as any agreement you’ve
//entered into with WSO2 governing the purchase of this software and any associated services.

// todo: move this to fhir base once it's released
import ballerina/regex;
import ballerina/http;

public isolated service class urlRewriteInterceptor {
    *http:ResponseInterceptor;
    private final string 'source;
    private final string target;

    public function init (string 'source, string target) {
        self.'source = 'source;
        self.target = target;
    }

    isolated remote function interceptResponse(http:RequestContext ctx, http:Response res) returns http:NextService|error? {
        string contentType = res.getContentType();
        if (contentType.includes("application/fhir+xml")) {
            xml payload = check res.getXmlPayload();
            string xmlString = payload.toString();
            string replaceAll = regex:replaceAll(xmlString, self.'source, self.target);
            xml afterReplace = check xml:fromString(replaceAll);
            res.setXmlPayload(afterReplace);
        } else if (contentType.includes("application/fhir+json")) {
            string textPayload = check res.getTextPayload();
            string replaceAll = regex:replaceAll(textPayload, self.'source, self.target);
            json afterReplace = check replaceAll.fromJsonString();
            res.setJsonPayload(afterReplace);
        }
        return ctx.next();
    }
}
