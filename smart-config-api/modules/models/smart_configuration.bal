// Copyright (c) 2022, WSO2 LLC. (http://www.wso2.com). All Rights Reserved.

// This software is the property of WSO2 LLC. and its suppliers, if any.
// Dissemination of any information or reproduction of any material contained
// herein is strictly forbidden, unless permitted by WSO2 in accordance with
// the WSO2 Software License available at: https://wso2.com/licenses/eula/3.2
// For specific language governing the permissions and limitations under
// this license, please see the license as well as any agreement you’ve
// entered into with WSO2 governing the purchase of this software and any
// associated services.


# Smart configuration record
# + issuer - Smart configuration issuer  
# + jwks_uri - Smart configuration jwks_uri  
# + authorization_endpoint - Smart configuration authorization_endpoint  
# + grant_types_supported - Smart configuration grant_type_supported  
# + token_endpoint - Smart configuration token_endpoint  
# + token_endpoint_auth_methods_supported - Smart configuration token_endpoint_auth_methods_supported  
# + registration_endpoint - Smart configuration registration_endpoint  
# + scopes_supported - Smart configuration scopes_supported  
# + response_types_supported - Smart configuration response_type_supported  
# + management_endpoint - Smart configuration management_endpoint  
# + introspection_endpoint - Smart configuration introspection_endpoint  
# + revocation_endpoint - Smart configuration revocation_endpoint  
# + capabilities - Smart configuration capabilities  
# + code_challenge_methods_supported - Smart configuration code_challenge_methods_supported
public type SmartConfiguration record {
    string issuer?;
    string jwks_uri?;
    string authorization_endpoint;
    string[] grant_types_supported;
    string token_endpoint;
    string[] token_endpoint_auth_methods_supported?;
    string registration_endpoint?;
    string[] scopes_supported?;
    string[] response_types_supported?;
    string management_endpoint?;
    string introspection_endpoint?;
    string revocation_endpoint?;
    string[] capabilities;
    string[] code_challenge_methods_supported;
};
