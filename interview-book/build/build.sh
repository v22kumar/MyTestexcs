#!/bin/bash
# Build the book: main.tex -> build/book.pdf
# requires: texlive (pdflatex; latexmk used if available), poppler-utils (pdfinfo)
# Run from anywhere:  bash build/build.sh
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p build/chapters   # \include writes per-chapter .aux files here

if command -v latexmk >/dev/null 2>&1; then
  latexmk -pdf -interaction=nonstopmode -halt-on-error \
          -output-directory=build main.tex
else
  # two passes for TOC / cross-references
  pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build main.tex
  pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build main.tex
fi

mv -f build/main.pdf build/book.pdf
echo "Pages: $(pdfinfo build/book.pdf | grep Pages)"
