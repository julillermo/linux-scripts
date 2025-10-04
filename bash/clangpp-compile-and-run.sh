#!/bin/bash

# Author: TulioG
# Version: 1.0.0
# Last Update Date: 2025-10-04


# ===== Usage =====
# ./clangpp-compile-and-run.sh ./first_cpp.cpp
# ./clangpp-compile-and-run.sh ./first_cpp.cpp some_output_name


# ===== Todo =====
# The process of creating this script did not feel ergonomic. I might want
#   to recreate it in python (also as an opportunity to practice Python).


# ===== About =====
# Original intention was to create a script that would compile the current
#   .cpp source code into an executable with a known name marker
#   (ex. <rest-of-file-name>-run) and then execute it immediately after.

# This takes inspiration from the VSCode "coderunner" extension, where,
#   if you see the command that it's calling, you'll see that runs the
#   same general idea. However, I prefered if I had the ability to to this
#   in any open terminal instead of outputting to the "output" tab/window
#   of VSCode



# ===== USE-CASE =====
# Compile a sinlge .cpp source file and output a file with an easy to
#   specify name in .gitignore then run it immediately after.


# ===== Script Proper =====
if [[ $# -lt 1 ]]; then
  echo "Usage: $(basename "$0") <input_file_path> (required) <output_file_path> (optional)"
  exit 1
fi

CURRENT_DIR=$(pwd)
INPUT_FILE_PATH="${CURRENT_DIR}/${1}"
INPUT_FILE_NO_EXT="${INPUT_FILE_PATH%.*}"
OPUTPUT_FILE_PATH="${CURRENT_DIR}/${2}"

if [[ -z "$OPUTPUT_FILE_PATH" ]]; then
  OPUTPUT_FILE_PATH="${INPUT_FILE_NO_EXT}_executable"
else
  OPUTPUT_FILE_PATH="${CURRENT_DIR}/$2"
fi

clang++ $INPUT_FILE_PATH -o $OPUTPUT_FILE_PATH && $OPUTPUT_FILE_PATH
