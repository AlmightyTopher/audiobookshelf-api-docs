#!/bin/bash

# PDF Generation Script for Audiobookshelf API Documentation
# Generates a print-friendly PDF from the built HTML documentation

set -e  # Exit on error

echo "==================================="
echo "Audiobookshelf API Docs - PDF Generator"
echo "==================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if wkhtmltopdf is installed
if ! command -v wkhtmltopdf &> /dev/null; then
    echo -e "${RED}Error: wkhtmltopdf is not installed${NC}"
    echo ""
    echo "Installation instructions:"
    echo ""
    echo "macOS:"
    echo "  brew install wkhtmltopdf"
    echo ""
    echo "Ubuntu/Debian:"
    echo "  sudo apt-get install wkhtmltopdf"
    echo ""
    echo "CentOS/RHEL:"
    echo "  sudo yum install wkhtmltopdf"
    echo ""
    echo "Or download from: https://wkhtmltopdf.org/downloads.html"
    exit 1
fi

# Build the documentation if needed
if [ ! -f "build/index.html" ]; then
    echo -e "${YELLOW}Build directory not found. Building documentation...${NC}"
    bundle exec middleman build --clean
    echo ""
fi

# Create output directory
mkdir -p build/downloads

# Output file
OUTPUT_FILE="build/downloads/audiobookshelf-api-documentation.pdf"
TEMP_HTML="build/index-print.html"

echo -e "${BLUE}Generating PDF...${NC}"
echo ""

# Generate PDF with optimized settings
wkhtmltopdf \
  --enable-local-file-access \
  --print-media-type \
  --page-size Letter \
  --margin-top 0.75in \
  --margin-right 0.75in \
  --margin-bottom 0.75in \
  --margin-left 0.75in \
  --encoding UTF-8 \
  --no-stop-slow-scripts \
  --javascript-delay 1000 \
  --enable-javascript \
  --footer-center "Page [page] of [toPage]" \
  --footer-font-size 8 \
  --footer-spacing 5 \
  --header-spacing 5 \
  --outline \
  --outline-depth 3 \
  --title "Audiobookshelf API Documentation" \
  --dpi 300 \
  build/index.html \
  "$OUTPUT_FILE"

# Check if PDF was created successfully
if [ -f "$OUTPUT_FILE" ]; then
    FILE_SIZE=$(du -h "$OUTPUT_FILE" | cut -f1)
    echo ""
    echo -e "${GREEN}✓ PDF generated successfully!${NC}"
    echo ""
    echo "Output file: $OUTPUT_FILE"
    echo "File size: $FILE_SIZE"
    echo ""

    # Generate compressed version
    echo -e "${BLUE}Generating compressed version...${NC}"
    COMPRESSED_FILE="build/downloads/audiobookshelf-api-documentation-compressed.pdf"

    if command -v gs &> /dev/null; then
        gs -sDEVICE=pdfwrite \
           -dCompatibilityLevel=1.4 \
           -dPDFSETTINGS=/ebook \
           -dNOPAUSE \
           -dQUIET \
           -dBATCH \
           -sOutputFile="$COMPRESSED_FILE" \
           "$OUTPUT_FILE" 2>/dev/null || true

        if [ -f "$COMPRESSED_FILE" ]; then
            COMPRESSED_SIZE=$(du -h "$COMPRESSED_FILE" | cut -f1)
            echo -e "${GREEN}✓ Compressed PDF generated!${NC}"
            echo "Compressed file: $COMPRESSED_FILE"
            echo "Compressed size: $COMPRESSED_SIZE"
        fi
    else
        echo -e "${YELLOW}Note: Ghostscript not installed. Skipping compression.${NC}"
        echo "Install with: brew install ghostscript (macOS) or apt-get install ghostscript (Linux)"
    fi

    echo ""
    echo -e "${GREEN}Done!${NC}"
    echo ""
    echo "Download links:"
    echo "  Standard:   /downloads/audiobookshelf-api-documentation.pdf"
    echo "  Compressed: /downloads/audiobookshelf-api-documentation-compressed.pdf"
    echo ""
else
    echo -e "${RED}Error: PDF generation failed${NC}"
    exit 1
fi

# Generate metadata file
cat > "build/downloads/metadata.json" <<EOF
{
  "title": "Audiobookshelf API Documentation",
  "version": "2.0.0",
  "generatedAt": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "coverage": "97.8%",
  "endpoints": 135,
  "files": {
    "standard": {
      "filename": "audiobookshelf-api-documentation.pdf",
      "size": "$FILE_SIZE"
    }
  }
}
EOF

echo -e "${GREEN}Metadata file created: build/downloads/metadata.json${NC}"
