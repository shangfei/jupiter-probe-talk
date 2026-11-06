#!/bin/bash
set -e
cd "$(dirname "$0")"
Rscript -e 'rmarkdown::render("JupiterProbe.Rmd", quiet=TRUE)'
timeout 150 google-chrome --headless=new --no-sandbox --disable-gpu --run-all-compositor-stages-before-draw --virtual-time-budget=20000 --no-pdf-header-footer --print-to-pdf=JupiterProbe.pdf "file://$PWD/JupiterProbe.html" 2>/dev/null
pdfinfo JupiterProbe.pdf | egrep "Pages|Page size"
rm -rf pages && mkdir pages && pdftoppm -r 96 -png JupiterProbe.pdf pages/p
montage pages/p-*.png -tile 5x -geometry 454x256+4+4 -background gray25 JupiterProbe_contact.png
