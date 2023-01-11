// Copyright (c) 2022, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.

// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein is strictly forbidden, unless permitted by WSO2 in accordance with
// the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
// For specific language governing the permissions and limitations under
// this license, please see the license as well as any agreement you’ve
// entered into with WSO2 governing the purchase of this software and any
// associated services.

import healthcare.fhir.r4.api.smartconfiguration.handlers;
import healthcare.fhir.r4.api.smartconfiguration.constants;
import healthcare.fhir.r4.api.smartconfiguration.models;

configurable models:SmartConfiguration smart_configuration = ?;

# The generator class for the Smart Configuration
public class SmartConfigurationGenerator {
    handlers:LogHandler logHandler;
    handlers:IssueHandler issueHandler;

    public isolated function init() {
        self.issueHandler = new("SmartConfigurationGenerator");
        self.logHandler = new("SmartConfigurationGenerator");
        self.logHandler.Debug("Generating smart configuration initialized");
    }

    # Generator function for Smart Configuration
    # + return - smart configuration as a json or an error
    public isolated function generate() returns models:SmartConfiguration|error {
        self.logHandler.Debug("Generating smart configuration started");

        models:SmartConfiguration|error smartConfig = {
            ...smart_configuration
        };
            
        if smartConfig is error {
            self.issueHandler.addServiceError(createServiceError(constants:ERROR, constants:VALUE, smartConfig));
        }
        
        self.logHandler.Debug("Completed generating smart configuration");
        return smartConfig;
    }
}
