#!/bin/bash
echo "Generating documentation"

pandoc README.md --css=styles.css -s -o "./docs/index.html" --metadata-file=./docs/metadata.yaml --template=./docs/template.html --highlight-style=breezeDark
