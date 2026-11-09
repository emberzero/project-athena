#!/bin/bash

cd ../Curriculum
printf "# Table of Contents\n\n" > SUMMARY.md
echo "* [Welcome](../README.md)" >> SUMMARY.md

find . -mindepth 1 -maxdepth 1 -type d -exec bash -c '
  if [ -f "$1/introduction.md" ]; then
    echo "$1 $(echo "$1" | tr -dc "0-9")"
  fi
' _ {} \; | sort -k2n | while read d; do
  d=${d% *}
  echo "" >> SUMMARY.md
  printf "## %s\n\n" "${d##*/}" >> SUMMARY.md
  echo "* [Introduction]($(echo "$d" | sed 's/ /%20/g')/introduction.md)" >> SUMMARY.md
  if [ -d "$d/lectures" ]; then
    echo "* Lectures" >> SUMMARY.md
    for lecture_file in "$d/lectures/"*.md; do
      lecture_title=$(head -n 1 "$lecture_file" | cut -c 3-)
      echo "  * [$lecture_title]($(echo "$d" | sed 's/ /%20/g')/lectures/$(basename "$lecture_file"))" >> SUMMARY.md
    done
  fi
done
