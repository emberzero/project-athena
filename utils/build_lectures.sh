#!/bin/bash
# Render curriculum lectures to branded PDFs using utils/lecture-template.typ.
#
#   ./build_lectures.sh                       all lectures -> out/lectures/
#   ./build_lectures.sh "Module 02"           only matching paths
#   OUT=/tmp/pdfs ./build_lectures.sh         choose the output directory
#
# CI does the same thing through the Nix flake; this is for working locally.

set -euo pipefail

cd "$(dirname "$0")/.."
ROOT="$(pwd)"

OUT="${OUT:-$ROOT/out/lectures}"
FILTER="${1:-}"

# Berkeley Mono lives in the athena-fonts submodule; Libertinus Serif ships with Typst.
export TYPST_FONT_PATHS="${TYPST_FONT_PATHS:-$ROOT/athena-fonts/fonts}"

if [ ! -d "$ROOT/athena-fonts/fonts" ]; then
  echo "warning: athena-fonts submodule is empty, headings will fall back to another font." >&2
  echo "         run: git submodule update --init --recursive" >&2
fi

mkdir -p "$OUT"
built=0
failed=0

while IFS= read -r file; do
  if [ -n "$FILTER" ] && [[ "$file" != *"$FILTER"* ]]; then
    continue
  fi
  name="$(basename "$file" .md)"
  module="$(echo "$file" | sed -E 's|Curriculum/(Module [0-9]+).*|\1|' | tr -d ' ')"
  target="$OUT/${module}_${name}.pdf"

  if typst compile "$ROOT/utils/lecture-template.typ" "$target" \
      --root "$ROOT" --input md="$file" 2>/tmp/lecture-build-err.$$; then
    echo "  ok    $target"
    built=$((built + 1))
  else
    echo "  FAIL  $file" >&2
    sed 's/^/        /' /tmp/lecture-build-err.$$ >&2
    failed=$((failed + 1))
  fi
  rm -f /tmp/lecture-build-err.$$
done < <(find Curriculum -type f -path "*/lectures/*.md" | sort)

echo
echo "$built PDF(s) in $OUT"
if [ "$failed" -gt 0 ]; then
  echo "$failed lecture(s) failed to build" >&2
  exit 1
fi
