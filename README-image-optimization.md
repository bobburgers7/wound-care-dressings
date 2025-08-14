# Image Optimization for Wound Care Guide

This directory contains scripts to optimize images for smaller PDF file sizes while maintaining quality for the Typst document.

## What it does

The optimization script:
- Resizes all images to 120x80 pixels (2x the display size of 60pt x 40pt)
- Converts most images to JPEG with 85% quality for optimal size/quality balance
- Keeps PNG format for images that might need transparency
- Strips metadata to reduce file size
- Preserves originals in the `images/` directory

## Requirements

Install ImageMagick:
```bash
# macOS
brew install imagemagick

# Ubuntu/Debian
sudo apt-get install imagemagick

# Windows (via chocolatey)
choco install imagemagick
```

## Usage

### 1. Optimize Images
```bash
./optimize-images.sh
```

This creates optimized images in the `images-optimized/` directory.

### 2. Create Optimized JSON
```bash
./create-optimized-json.sh
```

This creates `wound-care-data-catalog-optimized.json` with updated image paths.

### 3. Update Typst Document
Edit `main.typ` and change:
```typst
#wound-care-guide(
  config-file: "wound-care-config.yaml",
  data-file: "wound-care-data-catalog-only.json"  // OLD
)
```

To:
```typst
#wound-care-guide(
  config-file: "wound-care-config.yaml",
  data-file: "wound-care-data-catalog-optimized.json"  // NEW
)
```

## Expected Results

- **Image file sizes**: Reduced by 70-90%
- **PDF file size**: Significantly smaller (exact reduction depends on image content)
- **Image quality**: Optimized for 60pt x 40pt display size in print
- **Performance**: Faster PDF generation and smaller file for distribution

## File Structure

```
├── images/                          # Original images (preserved)
├── images-optimized/                # Optimized images (generated)
├── wound-care-data-catalog-only.json      # Original JSON
├── wound-care-data-catalog-optimized.json # Optimized JSON (generated)
├── optimize-images.sh               # Main optimization script
├── create-optimized-json.sh         # JSON creation helper
└── README-image-optimization.md     # This file
```

## Notes

- The optimization script only processes images that have changed
- Re-run `./optimize-images.sh` whenever you add or update images
- Original images are never modified
- The 120x80px size provides crisp display even on high-DPI screens