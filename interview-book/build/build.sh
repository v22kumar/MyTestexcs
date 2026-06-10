#!/bin/bash
# requires: pandoc, texlive (xelatex)
# Run from the interview-book/ directory:  bash build/build.sh
set -euo pipefail
cd "$(dirname "$0")/.."

pandoc chapters/ch*.md \
  --toc --toc-depth=2 \
  -V geometry:margin=2cm \
  -V fontsize=11pt \
  -V documentclass=report \
  --pdf-engine=xelatex \
  -o build/book.pdf
echo "Pages: $(pdfinfo build/book.pdf | grep Pages)"
