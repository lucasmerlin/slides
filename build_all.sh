#!/bin/bash

# Prepare the output directory
output_dir="dist"
rm -r "$output_dir"
mkdir -p "$output_dir"

# Initialize the index.html file
index_file="$output_dir/index.html"
echo "<!DOCTYPE html>" > "$index_file"
echo "<html>" >> "$index_file"
echo "<head>" >> "$index_file"
echo "  <title>Slides Index</title>" >> "$index_file"
echo "  <style>body { font-family: Arial, sans-serif; }</style>" >> "$index_file"
echo "</head>" >> "$index_file"
echo "<body>" >> "$index_file"
echo "  <h1>Slides Index</h1>" >> "$index_file"
echo "  <ul>" >> "$index_file"

# Loop through each subdirectory in slides
for dir in slides/*; do
  if [ -d "$dir" ]; then
    # Look for a .md file with the same name as the subdirectory
    base_name=$(basename "$dir")
    md_file="$dir/$base_name.md"

    if [ -f "$md_file" ]; then
      # Run the build command for the matching .md file
      bun run build "$md_file" --out "../../$output_dir/$base_name" --base "/slides/$base_name"

      # Add a link to the index.html
      echo "    <li><a href=\"$base_name/\">$base_name</a></li>" >> "$index_file"
    else
      echo "Warning: No $base_name.md found in $dir. Skipping."
    fi
  fi
done

# Close the index.html file
echo "  </ul>" >> "$index_file"
echo "</body>" >> "$index_file"
echo "</html>" >> "$index_file"

echo "Build completed. See $index_file for the index."
