# Graph-Data-Heist
A bash script for fetching comprehensive data from the Microsoft Graph API. It includes detailed information about users, groups, applications, and more, with handling for pagination and a disclaimer for legal and ethical use.

# MS Graph Heist

A bash script for fetching comprehensive data from the Microsoft Graph API. This script retrieves detailed information about users, groups, applications, and more, and handles pagination automatically. It includes a disclaimer for legal and ethical use.

## Features

- Fetch detailed information about users, groups, and applications.
- Handle pagination automatically using `@odata.nextLink`.
- Save results to separate JSON files.

## Disclaimer

This script is for educational purposes only. Ensure you use this information and any scripts legally and ethically.

## Usage

1. **Clone the Repository**
   git clone https://github.com/yourusername/ms-graph-heist.git
   cd ms-graph-heist
   Make the Script Executable
   chmod +x graph_data_heist.sh

## Run the Script
./graph_data_heist.sh
Ensure you replace BEAER Token with your actual bearer token.

## Requirements
curl
jq

## Output
The script will create several JSON files in the same directory, each containing the results of the respective queries:

users.json
groups.json
applications.json
directory_roles.json
service_principals.json
organization.json

## License
This project is licensed under the MIT License. See the LICENSE file for details.
