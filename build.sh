#!/bin/bash
set -e
cd "$(dirname "$0")"
Rscript -e 'rmarkdown::render("JupiterProbe.Rmd", quiet=TRUE)'
UD=$(mktemp -d /tmp/jupiter-chrome-XXXX)
CHROME="${CHROME:-}"
if [ -z "$CHROME" ]; then
  if [ -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then
    CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  else
    CHROME=$(command -v google-chrome || command -v chromium || true)
  fi
fi
"$CHROME" --headless=new --no-sandbox --disable-gpu --user-data-dir="$UD" --run-all-compositor-stages-before-draw --virtual-time-budget=25000 --no-pdf-header-footer --print-to-pdf=JupiterProbe.pdf "file://$PWD/JupiterProbe.html" 2>/dev/null || true
rm -rf "$UD"
pdfinfo JupiterProbe.pdf | egrep "Pages|Page size"
rm -rf pages && mkdir pages && pdftoppm -r 96 -png JupiterProbe.pdf pages/p
montage pages/p-*.png -tile 5x -geometry 454x256+4+4 -background gray25 JupiterProbe_contact.png
