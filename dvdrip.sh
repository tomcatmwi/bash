#!/bin/bash

DVD="/dev/sr0"
OUTDIR="/run/media/tomcatmwi/Data/dvd"

# Check if the DVD path exists and is readable
if [ ! -r "$DVD" ]; then
  echo "Error: $DVD is not readable or does not exist."
  exit 1
fi

# Check if the output directory exists and is writable
if [ ! -w "$OUTDIR" ]; then
  echo "Error: $OUTDIR is not writable or does not exist."
  exit 1
fi

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

# Save current time
start_time=$(date +%s)
echo "Starting DVD ripping at $(date +%H:%M:%S)"

# Copy the contents of the DVD to the specified file in the OUTDIR directory
dd if="$DVD" of="$OUTDIR/$filename" bs=2048 conv=sync,notrunc

# Calculate the elapsed time
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
minutes=$((elapsed_time / 60))
seconds=$((elapsed_time % 60))

# Display the elapsed time
echo "Ripping completed in $minutes minutes and $seconds seconds."
echo "Space remaining on target drive: $(df -h $OUTDIR | awk '/dev/ {print $4}')"

eject