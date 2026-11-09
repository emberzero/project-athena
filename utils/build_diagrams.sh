#!/bin/bash
# Compile lecture diagrams written in Typst to self-contained SVG.
#
#   Curriculum/<Module>/lectures/diagrams/<name>.typ   ->   .../lectures/images/<name>.svg
#
#   ./build_diagrams.sh                 build every diagram
#   ./build_diagrams.sh "Module 06"     only matching paths
#
# Lectures reference the built file relatively: ![Alt](images/<name>.svg)
# Run this after changing a diagram source; the SVGs are committed.

set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"
FILTER="${1:-}"

export TYPST_FONT_PATHS="${TYPST_FONT_PATHS:-$ROOT/athena-fonts/fonts}"

# Usable text width on the A4 lecture page (595pt paper - 2x 2.4cm margins).
MAX_WIDTH_PT=459

built=0
failed=0
wide=0

while IFS= read -r src; do
  if [ -n "$FILTER" ] && [[ "$src" != *"$FILTER"* ]]; then
    continue
  fi
  # .../lectures/diagrams/foo.typ -> .../lectures/images/foo.svg
  outdir="$(dirname "$(dirname "$src")")/images"
  name="$(basename "$src" .typ)"
  mkdir -p "$outdir"

  if typst compile "$src" "$outdir/$name.svg" --root "$ROOT" --format svg \
      2>/tmp/diagram-build-err.$$; then
    # The lecture page gives a diagram 459pt of text width. A wider one is
    # scaled down, shrinking its 9pt labels until they are unreadable, so
    # flag it rather than let it ship looking broken.
    w=$(sed -n 's/.*width="\([0-9.]*\)pt".*/\1/p' "$outdir/$name.svg" | head -1)
    if [ -n "$w" ] && [ "${w%%.*}" -gt "$MAX_WIDTH_PT" ] 2>/dev/null; then
      echo "  WIDE  $outdir/$name.svg (${w}pt > ${MAX_WIDTH_PT}pt: will be shrunk on the page)" >&2
      wide=$((wide + 1))
    else
      echo "  ok    $outdir/$name.svg"
    fi
    built=$((built + 1))
  else
    echo "  FAIL  $src" >&2
    sed 's/^/        /' /tmp/diagram-build-err.$$ >&2
    failed=$((failed + 1))
  fi
  rm -f /tmp/diagram-build-err.$$
done < <(find Curriculum -type f -path "*/lectures/diagrams/*.typ" | sort)

echo
echo "$built diagram(s) built"
if [ "$wide" -gt 0 ]; then
  echo "$wide diagram(s) exceed ${MAX_WIDTH_PT}pt and will be shrunk on the page." >&2
  echo "Narrow them: fewer columns, shorter labels, or stack the rows." >&2
fi
if [ "$failed" -gt 0 ]; then
  echo "$failed diagram(s) failed" >&2
  exit 1
fi
