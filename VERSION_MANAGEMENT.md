# Version Management System

## Overview
This project uses semantic versioning and automated date management for the wound care guide documents.

## Version Numbering
- **Major (X.0.0)**: Breaking changes, complete restructuring
- **Minor (0.X.0)**: New features, new sections, significant content additions  
- **Patch (0.0.X)**: Bug fixes, small corrections, image updates

## Usage

### Update Version and Date
```bash
# Update version and add changelog entry
./update-version.sh "0.3.0" "Added new antimicrobial section"

# Just update date (keeps current version)
./update-version.sh

# Update version without changelog
./update-version.sh "0.2.1"
```

### Manual Updates
You can also manually edit:
- `wound-care-config.yaml` - Update version and date
- `CHANGELOG.md` - Add entries manually

## Current Version System
- Version and date are stored in `wound-care-config.yaml`
- Both `main.typ` and `product-grid.typ` read from this config
- Changes are automatically reflected in PDF footers
- Changelog tracks all significant changes

## Best Practices
1. **Always update version** when making content changes
2. **Add meaningful changelog entries** for significant changes
3. **Use patch versions** (0.2.1, 0.2.2) for small fixes
4. **Use minor versions** (0.3.0, 0.4.0) for new features
5. **Consider major version** (1.0.0) for first clinical release

## Examples
```bash
# Bug fix
./update-version.sh "0.2.1" "Fixed image paths for hydrogel products"

# New feature  
./update-version.sh "0.3.0" "Added pediatric wound care section"

# Major release
./update-version.sh "1.0.0" "First clinical release - approved for hospital use"
```