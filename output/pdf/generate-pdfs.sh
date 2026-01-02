#!/bin/bash
# Generate PDFs from markdown research outputs

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT_DIR="$SCRIPT_DIR/../agents"
OUTPUT_DIR="$SCRIPT_DIR"
TEMPLATE="$SCRIPT_DIR/template.typ"

# Function to convert a single file
convert_file() {
    local md_file="$1"
    local basename=$(basename "$md_file" .md)
    local typ_file="$OUTPUT_DIR/${basename}.typ"
    local pdf_file="$OUTPUT_DIR/${basename}.pdf"

    # Extract title from first heading or use filename
    local title=$(grep -m1 "^#\s" "$md_file" | sed 's/^#\s*//' | head -1)
    if [ -z "$title" ]; then
        title="$basename"
    fi

    echo "Converting: $basename"

    # Convert markdown to typst content
    local content=$(pandoc -f markdown -t typst "$md_file" 2>/dev/null)

    # Create typst file with template
    cat > "$typ_file" << EOF
#import "template.typ": report, horizontalrule

#show: report.with(
  title: "$title"
)

$content
EOF

    # Compile to PDF
    typst compile "$typ_file" "$pdf_file" 2>&1

    if [ -f "$pdf_file" ]; then
        echo "  Created: $pdf_file"
        # Clean up intermediate .typ file
        rm -f "$typ_file"
        return 0
    else
        echo "  ERROR: Failed to create $pdf_file"
        return 1
    fi
}

# Process all markdown files (excluding error files)
for md_file in "$INPUT_DIR"/*.md; do
    # Skip files with errors
    if grep -q "Unsupported processor" "$md_file" 2>/dev/null; then
        echo "Skipping (error file): $(basename "$md_file")"
        continue
    fi
    convert_file "$md_file"
done

echo ""
echo "PDF generation complete!"
ls -la "$OUTPUT_DIR"/*.pdf 2>/dev/null
