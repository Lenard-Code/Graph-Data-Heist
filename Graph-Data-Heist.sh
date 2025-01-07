#!/bin/bash

# Function to print ASCII art and disclaimer
print_ascii_art() {
    echo " ___ ___  _____      ____  ____    ____  ____  __ __      __ __    ___  ____ _____ ______ "
    echo " |   |   |/ ___/     /    ||    \  /    ||    \|  |  |    |  |  |  /  _]|    / ___/|      |"
    echo " | _   _ (   \_     |   __||  D  )|  o  ||  o  )  |  |    |  |  | /  [_  |  (   \_ |      |"
    echo " |  \_/  |\__  |    |  |  ||    / |     ||   _/|  _  |    |  _  ||    _] |  |\__  ||_|  |_|"
    echo " |   |   |/  \ |    |  |_ ||    \ |  _  ||  |  |  |  |    |  |  ||   [_  |  |/  \ |  |  |  "
    echo " |   |   |\    |    |     ||  .  \|  |  ||  |  |  |  |    |  |  ||     | |  |\    |  |  |  "
    echo " |___|___| \___|    |___,_||__|\_||__|__||__|  |__|__|    |__|__||_____||____|\___|  |__|  "
    echo "                                                                                           "
    echo "DISCLAIMER: This script is for educational purposes only."
    echo "Ensure you use this information and any scripts legally and ethically."
    echo ""
}

# Print ASCII art and disclaimer
print_ascii_art

# Define the base URL and headers
base_url="https://graph.microsoft.com/v1.0"
authorization_header="Authorization: Bearer {ADD-BEAER-TOKEN}"

# Define the output files
output_files=("users.json" "groups.json" "applications.json" "directory_roles.json" "service_principals.json" "organization.json")

# Define the queries
queries=(
  "$base_url/users?\$select=displayName,userPrincipalName,businessPhones,officeLocation,city,mail,jobTitle,preferredLanguage,givenName,surname,accountEnabled,assignedLicenses,createdDateTime,department,employeeId,identities,onPremisesDistinguishedName,onPremisesDomainName,onPremisesImmutableId,onPremisesLastSyncDateTime,onPremisesSecurityIdentifier,onPremisesSyncEnabled,proxyAddresses,state,streetAddress,usageLocation,userType"
  "$base_url/groups?\$select=id,displayName,description,mail,mailEnabled,mailNickname,securityEnabled,visibility,groupTypes,createdDateTime,renewedDateTime,resourceProvisioningOptions,resourceBehaviorOptions,owners,createdOnBehalfOf,groupLifecyclePolicy,assignedLicenses,licenseProcessingState"
  "$base_url/applications?\$select=id,displayName,appId,createdDateTime,identifierUris,publisherDomain,signInAudience,appRoles"
  "$base_url/directoryRoles"
  "$base_url/servicePrincipals?\$select=id,appId,displayName,servicePrincipalType,accountEnabled,createdDateTime"
  "$base_url/organization"
)

# Function to make a request and save the response
make_request() {
  local url=$1
  local output_file=$2
  local response=$(curl -s -H "$authorization_header" -H "Content-Type: application/json" "$url")
  echo "$response" > "$output_file"
}

# Loop through the queries and make requests
for i in "${!queries[@]}"; do
  make_request "${queries[$i]}" "${output_files[$i]}"
done

echo "Data heist complete. Results are saved in the respective files."
