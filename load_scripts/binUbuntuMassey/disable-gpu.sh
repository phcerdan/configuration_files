#!/bin/bash
sudo rmmod nvidia_modeset &> /dev/null
sudo rmmod nvidia &> /dev/null
sudo tee /proc/acpi/bbswitch <<< OFF > /dev/null
if (cat /proc/acpi/bbswitch | grep OFF > /dev/null); then
    echo "The nVidia GPU has been turned off."
else
    echo "Failed to turn off the nvidia gpu"
fi
