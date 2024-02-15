
#!/bin/bash

python3 -m pip install --upgrade pip

# Install gdown if not already installed
pip install gdown

# Find the device identifier of the SD card
sd_card=$(diskutil list | grep "external, physical" | grep -oE "/dev/disk[0-9]+" | tail -n1)

if [ -z "$sd_card" ]; then
    echo "No SD card found. Please insert the SD card and try again."
    exit 1
fi

# Unmount the SD card if it's mounted
diskutil unmountDisk $sd_card

# Download the zipped Raspberry Pi OS image from Google Drive using gdown
gdown --id 18OkIMezUSt2ta0J_XOSWB61OsGidvkPS -O ~/Downloads/test_rpi2.zip && echo "Download complete"

# Extract the contents of the zip file without including macOS metadata
unzip -q -d ~/Downloads/test_rpi2/ ~/Downloads/test_rpi2.zip

# Point to the rpi_test.img file after extraction
img_file=~/Downloads/test_rpi2/test_rpi2.img

if [ ! -f "$img_file" ]; then
    echo "No .img file found in the extracted folder. Please check the zip file contents."
    exit 1
fi

# Write the image to the SD card using dd
sudo dd bs=4m if="$img_file" of=$sd_card conv=sync status=progress

# Eject the SD card
diskutil eject $sd_card
