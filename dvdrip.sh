#!/bin/bash

DVD="/dev/sr0"
OUTDIR="/run/media/tomcatmi/Data/dvd"

while true; do
  # Prompt the user for the output filename and modify it as necessary
  read -p "Enter a filename for the DVD image: " filename
  if [[ "$filename" != *.iso ]]; then
    filename="$filename.iso"
  fi

  # Check if the output file already exists
  if [ -e "$OUTDIR/$filename" ]; then
    read -p "The file $filename already exists. Do you want to overwrite it? (y/n): " overwrite
    if [[ "$overwrite" == [yY] ]]; then
      break
    fi
  else
    break
  fi
done

# Copy the contents of the DVD to the specified file in the OUTDIR directory
dd if="$DVD" of="$OUTDIR/$filename" bs=2048 conv=sync,notrunc
