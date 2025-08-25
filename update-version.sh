#!/bin/bash

# Update version script for wound care guide
# Usage: ./update-version.sh [version] [changelog-entry]
# Example: ./update-version.sh "0.3.0" "Added new compression wrap category"

CONFIG_FILE="wound-care-config.yaml"
CHANGELOG_FILE="CHANGELOG.md"

# Get current date
CURRENT_DATE=$(date +"%Y-%m-%d")
YEAR=$(date +"%Y")
MONTH=$(date +"%-m")  # Remove leading zero
DAY=$(date +"%-d")    # Remove leading zero

# Update date in YAML config
echo "Updating date to: $CURRENT_DATE"
sed -i.bak -E "s/year: [0-9]+/year: $YEAR/" "$CONFIG_FILE"
sed -i.bak -E "s/month: [0-9]+/month: $MONTH/" "$CONFIG_FILE" 
sed -i.bak -E "s/day: [0-9]+/day: $DAY/" "$CONFIG_FILE"

# If version is provided, update it
if [ ! -z "$1" ]; then
    echo "Updating version to: $1"
    sed -i.bak -E "s/version: \"[^\"]+\"/version: \"$1\"/" "$CONFIG_FILE"
    NEW_VERSION="$1"
else
    # Extract current version
    NEW_VERSION=$(grep 'version:' "$CONFIG_FILE" | sed -E 's/.*version: "([^"]+)".*/\1/')
fi

# If changelog entry is provided, add it
if [ ! -z "$2" ]; then
    echo "Adding changelog entry: $2"
    
    # Create changelog if it doesn't exist
    if [ ! -f "$CHANGELOG_FILE" ]; then
        echo "# Wound Care Guide Changelog" > "$CHANGELOG_FILE"
        echo "" >> "$CHANGELOG_FILE"
    fi
    
    # Add new entry at the top
    temp_file=$(mktemp)
    echo "## Version $NEW_VERSION - $CURRENT_DATE" > "$temp_file"
    echo "- $2" >> "$temp_file"
    echo "" >> "$temp_file"
    cat "$CHANGELOG_FILE" >> "$temp_file"
    mv "$temp_file" "$CHANGELOG_FILE"
fi

# Clean up backup files
rm -f "${CONFIG_FILE}.bak"

echo "✅ Updated successfully!"
echo "   Version: $NEW_VERSION"
echo "   Date: $CURRENT_DATE"

if [ ! -z "$2" ]; then
    echo "   Changelog updated with: $2"
fi