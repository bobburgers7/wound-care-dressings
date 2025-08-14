#!/bin/bash

# Image optimization script for Typst wound care guide
# Resizes images to optimal dimensions for 60pt x 40pt display
# Uses ImageMagick to create smaller, web-optimized versions

# Configuration
SOURCE_DIR="images"
OUTPUT_DIR="images-optimized"
TARGET_WIDTH=120  # 60pt * 2 for retina/high-DPI displays
TARGET_HEIGHT=80  # 40pt * 2 for retina/high-DPI displays
QUALITY=85        # JPEG quality (85 is good balance of size vs quality)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🖼️  Wound Care Image Optimizer${NC}"
echo -e "Source: ${SOURCE_DIR}"
echo -e "Output: ${OUTPUT_DIR}"
echo -e "Target size: ${TARGET_WIDTH}x${TARGET_HEIGHT}px (60pt x 40pt @ 2x)"
echo ""

# Check if ImageMagick is installed
if ! command -v magick &> /dev/null && ! command -v convert &> /dev/null; then
    echo -e "${RED}❌ ImageMagick not found!${NC}"
    echo "Please install ImageMagick:"
    echo "  macOS: brew install imagemagick"
    echo "  Ubuntu: sudo apt-get install imagemagick"
    exit 1
fi

# Use 'magick' command if available (ImageMagick 7+), otherwise 'convert' (ImageMagick 6)
if command -v magick &> /dev/null; then
    MAGICK_CMD="magick"
else
    MAGICK_CMD="convert"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}❌ Source directory '$SOURCE_DIR' not found!${NC}"
    exit 1
fi

# Initialize counters
processed=0
skipped=0
errors=0

echo -e "${YELLOW}Processing images...${NC}"

# Process each image file
for img in "$SOURCE_DIR"/*; do
    # Skip if no files match the pattern
    [ ! -f "$img" ] && continue
    
    # Check if it's an image file
    ext="${img##*.}"
    ext_lower=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    case "$ext_lower" in
        jpg|jpeg|png|gif|bmp|tiff|webp)
            # Continue processing
            ;;
        *)
            # Skip non-image files
            continue
            ;;
    esac
    
    # Get filename without path
    filename=$(basename "$img")
    # Get filename without extension
    name="${filename%.*}"
    
    # Set output format (convert everything to JPG for consistency and smaller size)
    # Exception: keep PNG for images that might need transparency
    if [ "$ext_lower" = "png" ]; then
        output_file="$OUTPUT_DIR/${name}.png"
        output_format="PNG"
    else
        output_file="$OUTPUT_DIR/${name}.jpg"
        output_format="JPEG"
    fi
    
    # Skip if output file already exists and is newer than source
    if [ -f "$output_file" ] && [ "$output_file" -nt "$img" ]; then
        echo -e "⏭️  Skipping $filename (already optimized)"
        ((skipped++))
        continue
    fi
    
    echo -n "🔄 Processing $filename -> $(basename "$output_file")... "
    
    # Get original image dimensions
    if command -v identify &> /dev/null; then
        original_size=$(identify -format "%wx%h" "$img" 2>/dev/null)
        original_filesize=$(du -h "$img" | cut -f1)
    else
        original_size="unknown"
        original_filesize="unknown"
    fi
    
    # Optimize the image
    if [ "$output_format" = "PNG" ]; then
        # For PNG files (preserve transparency if present)
        $MAGICK_CMD "$img" \
            -resize "${TARGET_WIDTH}x${TARGET_HEIGHT}^" \
            -gravity center \
            -extent "${TARGET_WIDTH}x${TARGET_HEIGHT}" \
            -strip \
            -define png:compression-level=9 \
            "$output_file" 2>/dev/null
    else
        # For JPEG files (better compression)
        $MAGICK_CMD "$img" \
            -resize "${TARGET_WIDTH}x${TARGET_HEIGHT}^" \
            -gravity center \
            -extent "${TARGET_WIDTH}x${TARGET_HEIGHT}" \
            -strip \
            -quality $QUALITY \
            -sampling-factor 4:2:0 \
            -colorspace sRGB \
            "$output_file" 2>/dev/null
    fi
    
    if [ $? -eq 0 ]; then
        # Get new file size
        if [ -f "$output_file" ]; then
            new_filesize=$(du -h "$output_file" | cut -f1)
            echo -e "${GREEN}✅ ${original_size} (${original_filesize}) -> ${TARGET_WIDTH}x${TARGET_HEIGHT} (${new_filesize})${NC}"
            ((processed++))
        else
            echo -e "${RED}❌ Failed${NC}"
            ((errors++))
        fi
    else
        echo -e "${RED}❌ ImageMagick error${NC}"
        ((errors++))
    fi
done

echo ""
echo -e "${GREEN}📊 Summary:${NC}"
echo -e "   ✅ Processed: $processed images"
echo -e "   ⏭️  Skipped: $skipped images"
echo -e "   ❌ Errors: $errors images"

if [ $processed -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}📝 Next steps:${NC}"
    echo "1. Update your Typst document to use optimized images:"
    echo "   Change: data-file: \"wound-care-data-catalog-only.json\""
    echo "   To:     data-file: \"wound-care-data-catalog-optimized.json\""
    echo ""
    echo "2. Create optimized JSON file:"
    echo "   Run: cp wound-care-data-catalog-only.json wound-care-data-catalog-optimized.json"
    echo "   Then replace 'images/' with 'images-optimized/' in the new file"
    echo ""
    echo -e "${GREEN}🎉 Optimization complete! Your PDF should be much smaller now.${NC}"
fi