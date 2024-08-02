#!/bin/bash

# Set repository information
REPO_OWNER="datalayers-io"
REPO_NAME="grafana-datalayers-datasource"
API_URL="https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases"

# Fetch all release information
ALL_RELEASES=$(curl -s $API_URL)

# Check if a valid release list is found
if [[ $ALL_RELEASES == *"Not Found"* ]]; then
    echo "Releases not found for the $REPO_NAME repository."
    exit 1
fi

# Extract the latest pre-release tag from the release information
LATEST_RELEASE_TAG=$(echo "$ALL_RELEASES" | grep -Eo '"tag_name": "[^"]*' | sed -E 's/"tag_name": "//' | head -n 1)
VERSION=$(echo "$LATEST_RELEASE_TAG" | sed 's/^v//')
if [[ -z "$LATEST_RELEASE_TAG" ]]; then
    echo "No pre-release found for the $REPO_NAME repository."
    exit 1
fi

echo "The latest release tag of $REPO_NAME is: $LATEST_RELEASE_TAG"

curl -L https://github.com/datalayers-io/grafana-datalayers-datasource/releases/download/$LATEST_RELEASE_TAG/datalayersio-datasource-$VERSION.zip --output ./grafana/datalayersio-datasource.zip
unzip ./grafana/datalayersio-datasource.zip -d ./grafana