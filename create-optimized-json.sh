#!/bin/bash

# Helper script to create optimized JSON file with updated image paths
# This updates the image paths to point to the optimized images directory

SOURCE_JSON="wound-care-data-catalog-only.json"
OUTPUT_JSON="wound-care-data-catalog-optimized.json"

echo "🔄 Creating optimized JSON file..."
echo "Source: $SOURCE_JSON"
echo "Output: $OUTPUT_JSON"

# Check if source file exists
if [ ! -f "$SOURCE_JSON" ]; then
    echo "❌ Source file '$SOURCE_JSON' not found!"
    exit 1
fi

# Create the optimized JSON by replacing image paths
sed 's|"images/|"images-optimized/|g' "$SOURCE_JSON" > "$OUTPUT_JSON"

if [ $? -eq 0 ]; then
    echo "✅ Created $OUTPUT_JSON"
    echo ""
    echo "📝 To use optimized images in your Typst document:"
    echo "Change the data-file parameter in main.typ from:"
    echo "  data-file: \"wound-care-data-catalog-only.json\""
    echo "To:"
    echo "  data-file: \"wound-care-data-catalog-optimized.json\""
else
    echo "❌ Failed to create optimized JSON file"
    exit 1
fi