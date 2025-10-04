#!/usr/bin/env python3

# Author: TulioG
# Version: 1.0.0
# Last Update Date: 2025-10-05


# ===== Usage =====
# ./clangpp-compile-and-run.py ./first_cpp.cpp
# ./clangpp-compile-and-run.py ./first_cpp.cpp some_output_path


# ===== Todo =====
#


# ===== About =====
# This is a python port of my clangpp-compile-and-run.sh

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
import argparse
import os
import subprocess
import sys


def get_final_output_path(cwd: str, ofp: str | None, ifp: str) -> str:
    return os.path.join(cwd, ifp) if (ofp is None) else os.path.join(cwd, ifp)


def get_final_output_path_marker(ofp: str, file_marker: str | None) -> str:
    file_path, _ = os.path.splitext(ofp)
    return (
        f"{file_path}{file_marker}"
        if file_marker is not None
        else f"{file_path}_executable"
    )


def verify_file_extension(path: str, ext: str | None) -> bool:
    _, file_extension = os.path.splitext(path)
    return True if (file_extension == ext) else False


def verify_file_path(ifp: str) -> None:
    if not verify_file_extension(ifp, ".cpp"):
        print(f"ERROR: input file path {ifp} does not end with a .cpp extension")
        print("exit 1")
        sys.exit(1)
    if not os.path.exists(ifp):
        print(f"ERROR: input file path {ifp} is not a valid file path")
        print("exit 1")
        sys.exit(1)


def main():
    # ===== Retrieve arguments =====
    parser = argparse.ArgumentParser(description="Mix positional and flagged args")
    # Positional arguments
    parser.add_argument(
        "input_file_path",
        help="file path of the source .cpp file to be compiled",
    )
    parser.add_argument(
        "output_file_path",
        help="file path (and filename) of output executable",
        nargs="?",
    )

    # Flagged (optional) arguments
    parser.add_argument("-m", "--file-marker", help="Enable verbose output")

    # ===== Process arguments =====
    current_working_directory: str = os.getcwd()
    args = parser.parse_args()

    input_file_path = os.path.join(current_working_directory, args.input_file_path)
    verify_file_path(input_file_path)

    output_file_path = get_final_output_path(
        current_working_directory, args.output_file_path, args.input_file_path
    )
    output_file_path = get_final_output_path_marker(output_file_path, args.file_marker)
    print("output_file_path =", output_file_path)

    # ===== compile and run =====
    subprocess.run(["clang++", input_file_path, "-o", output_file_path], check=True)
    subprocess.Popen(
        output_file_path,
        shell=False,
        stdin=sys.stdin,
        stdout=sys.stdout,
        stderr=sys.stderr,
        env=os.environ.copy(),
    ).wait()


if __name__ == "__main__":
    main()
