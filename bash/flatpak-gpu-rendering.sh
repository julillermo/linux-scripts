#!/bin/bash

# Author: TulioG
# Version: 1.0.0
# Last Update Date: 2025-05-11


# ===== Usage =====
# ./flatpak-gpu-rendering.sh --status on # to activate
# ./flatpak-gpu-rendering.sh --status off # to deactivate


# ===== Todo =====
# - Directly overwriting the `global` file is crude. Use something that
#   can pinpoint the variable itself (likely 'awk' or regex via Python or TypeScript). 


# ===== About =====
# Script to automatically set the necessary global flatpoak environment
#   variables to allow them to leverage the GPU.

# The idea for this script originated from flatseal's ability to set global
#   variables. Based on the flatseal UI, it supposedly sets the variables
#   in the same file (in generally the same path) specified here.

# The Logic for reading script flags is based on how it's done at my place of work.


# ===== USE-CASE =====
# It would seem that Linux Mint running on Nvidia Performance Mode already
#   enforces the use of the discrete GPU, and this script is likely unnecessary.
# I noticed that some applications had degraded performance or didn't apply hardware
#   acceleration when I ran this script on X11. Based on my testing,
#   this script should only be run for Wayland sessions (tested for both Mint
#   and Fedora)


# ===== Script Proper =====
# Location of the 'global' file that flatpak reads from
GLOBAL_PATH_PATH=$HOME/.local/share/flatpak/overrides/global
OPENGL_CONFIG=$"[Context]
devices=dri

[Environment]
__NV_PRIME_RENDER_OFFLOAD=1
__GLX_VENDOR_LIBRARY_NAME=nvidia"
VULKAN_GLOBAL_CONFIG='VK_ICD_FILENAMES="$NVIDIA_VULKAN_ICD"'
NVIDIA_VULKAN_ICD="/usr/share/vulkan/icd.d/nvidia_icd.x86_64.json" # Common path, verify on your system

while (( "$#" )); do
  case "$1" in
    --status)
      STATUS="$2"
      shift 2
      ;;
    *)
      printf "%s\n" $"Usage: ./flatpak-gpu-rendering
          --status < on | off >
          ex. '/flatpak-gpu-rendering'
      "
      exit 1
  esac
done

if [ -n "$STATUS" ]; then
  if [ "$STATUS" = "on" ]; then
    # Setting OpenGL to use Nvidia

    printf "%s\n" "$OPENGL_CONFIG" > $GLOBAL_PATH_PATH
    echo "Flatpak global OpenGL setings set to Nvidia"

    # If Vulkan is available, set it as a global variable as well.
    if [ -f "$NVIDIA_VULKAN_ICD" ]; then
        printf "%s\n" "$VULKAN_GLOBAL_CONFIG" >> $GLOBAL_PATH_PATH
        printf "%s\n" "Flatpak global Vulkan settings activated"
    fi

    printf "\nVerify the GPU is active using the command: glxinfo | grep 'OpenGL renderer'\n"
    exit 0
  elif [ "$STATUS" = "off" ]; then
    echo "" > $GLOBAL_PATH_PATH
    echo "cleared global flatpak settings"
    exit 0
  fi 
else
  printf "%s\n" $"Usage: ./flatpak-gpu-rendering
          --status < on | off >
          ex. '/flatpak-gpu-rendering'
      "
  exit 1
fi


