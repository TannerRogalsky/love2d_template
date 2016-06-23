#!/bin/bash
folder="levels"

for filename in $folder/*.tmx; do
  base="$folder/$(basename "$filename" .tmx)"
  /Applications/Tiled.app/Contents/MacOS/Tiled --export-map "$base".tmx "$base".lua
  echo "$base.tmx -> $base.lua"
done
