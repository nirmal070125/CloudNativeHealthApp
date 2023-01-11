# FHIR Capability Statement API Template

## Template Overview
This API template provides implementation of FHIR Metadata API. This implements 
[capabilities](https://www.hl7.org/fhir/http.html#capabilities) interaction, which is used to retrieve capability 
statement describing the server's current operational functionality by FHIR client applications. 

This FHIR server interaction returns Capability Statement ([CapabilityStatement](http://hl7.org/fhir/StructureDefinition/CapabilityStatement) 
FHIR resource) that specifies which resource types and interactions are supported by the FHIR server


|                       |                                                    |
|-----------------------|----------------------------------------------------|
| Ballerina Language    | Swan Lake 2201.2.3                                 |
| FHIR                  | R4                                                 |
| Implementation Guide  | http://hl7.org/fhir/                               |
| Profile | http://hl7.org/fhir/StructureDefinition/CapabilityStatement      |
| Documentation | https://www.hl7.org/fhir/capabilitystatement.html          |


## Usage

This section focuses on how to use this template to implement, configure and deploy FHIR Metadata API of a FHIR server:

### Prerequisites
1. Install [Ballerina](https://ballerina.io/learn/install-ballerina/set-up-ballerina/) 2201.1.2 (Swan Lake Update 1) or later

### Setup and run in VM or Developer Machine

1) Create an API project from this template
   ```
   bal new -t wso2healthcare/healthcare.fhir.r4.api.metadata <PROJECT_NAME>
   ```
2) Update deployed FHIR resource data in `/resources/resources.json`

3) Perform necessary updates in [configurations](#configurations).

4) Run by executing command: `bal run` in your terminal to run this package. 

5) Invoke `<BASE_URL>/fhir/r4/metadata/`
   1) Invoke from localhost : `http://localhost:9090/fhir/r4/metadata/`

### Setup and deploy on [Choreo](https://wso2.com/choreo/)
1) Create an API project from this template
   ```
   bal new -t wso2healthcare/healthcare.fhir.r4.api.metadata <PROJECT_NAME>
   ```
2) Update deployed FHIR resource data in `/resources/resources.json`

3) Perform necessary updates in [configurations](#configurations).

4) Create GitHub repository and push created source to relevant branch

5) Follow instructions to [connect project repository to Choreo](https://wso2.com/choreo/docs/tutorials/connect-your-existing-ballerina-project-to-choreo/)

6) Deploy API by following [instructions to deploy](https://wso2.com/choreo/docs/tutorials/create-your-first-rest-api/#step-2-deploy)
 and [test](https://wso2.com/choreo/docs/tutorials/create-your-first-rest-api/#step-2-deploy)

7) Invoke `<BASE_URL>/fhir/r4/metadata/`

    `https://<HOSTNAME>/<TENANT_CONTEXT>/fhir/r4/metadata/`

## Configurations

Following configurations can be configured in `Config.toml` or Choreo configurable editor

| Configuration                | Description                                         |
|------------------------------|-----------------------------------------------------|
| `version`                    | Business version of the capability statement        |
| `name`                       | Name for this capability statement (computer friendly) |
| `title`                      | Name for this capability statement (human friendly) |
| `status`                     | `draft` / `active` / `retired` / `unknown`          |
| `experimental`               | For testing purposes, not real usage                |
| `date`                       | Date last changed                                   |
| `kind`                       | `instance` / `capability` / `requirements`          |
| `fhir_version`               | FHIR Version the system supports                    |
| `format`                     | formats supported (`json`)       |
| `patch_format`               | Patch formats supported                             |
| `implementation_url`         | Base URL for the installation                       |
| `implementation_description` | Describes this specific instance                    |
| `interactions`               | The that operations are supported                   |
| `security_cors`              | CORS Headers availability                           |
| `token_url`                  | OAUTH2 access token url                             |
| `revoke_url`                 | OAUTH2 access revoke url                            |
| `authorize_url`              | OAUTH2 access authorize url                         |
