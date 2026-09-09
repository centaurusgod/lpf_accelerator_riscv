# I created this script so, I donot have to specify the input files to compile in verilog.
# This script will automatically detect all the modules instantiated in the top-level Verilog file and compile them together.

import argparse
import os
import re
import subprocess
import tempfile

# Ignore these keywords (not module instantiations)
VERILOG_KEYWORDS = {
    "module",
    "endmodule",
    "if",
    "for",
    "while",
    "assign",
    "always",
    "case",
    "begin",
    "end",
    "else",
    "initial",
}


def clean_verilog(content):
    # Remove comments
    content = re.sub(r"//.*", "", content)
    content = re.sub(r"/\*.*?\*/", "", content, flags=re.DOTALL)
    return content


def extract_instantiations(content):
    # Match: module_name instance_name (
    matches = re.findall(r"\b(\w+)\s+\w+\s*\(", content)

    modules = set()
    for m in matches:
        if m not in VERILOG_KEYWORDS:
            modules.add(m)

    return modules


def find_module_file(module, module_directories):
    """Find a Verilog module source file in the configured directories."""
    for directory in module_directories:
        filename = os.path.join(directory, f"{module}.v")
        if os.path.exists(filename):
            return filename
    return None


def resolve_modules(file_path, module_directories, visited):
    """
    Recursively find all module dependencies
    """
    if file_path in visited:
        return set()

    visited.add(file_path)

    if not os.path.exists(file_path):
        print(f"Warning: {file_path} not found.")
        return set()

    with open(file_path, "r") as f:
        content = clean_verilog(f.read())

    found_modules = extract_instantiations(content)

    all_modules = set(found_modules)

    for module in found_modules:
        sub_file = find_module_file(module, module_directories)
        if sub_file is None:
            continue
        sub_modules = resolve_modules(sub_file, module_directories, visited)
        all_modules.update(sub_modules)

    return all_modules


def build_and_run(top_file, modules, module_directories):
    source_files = [top_file]

    for mod in modules:
        filename = find_module_file(mod, module_directories)
        if filename is not None:
            source_files.append(filename)
        else:
            print(
                f"Warning: {mod}.v not found in configured module directories, skipping."
            )

    output_file = tempfile.NamedTemporaryFile(delete=False, suffix=".vvp").name

    compile_cmd = ["iverilog", "-o", output_file] + source_files

    print("\nCompiling with:")
    print(" ".join(compile_cmd))

    subprocess.run(compile_cmd, check=True)

    print("\nRunning simulation:\n")
    subprocess.run(["vvp", output_file], check=True)


def main():
    project_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    default_module_directory = os.path.join(project_root, "single_cycle_risc")

    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-i", "--input", required=True, help="Input Verilog test bench file"
    )
    parser.add_argument(
        "-d",
        "--directory",
        action="append",
        dest="module_directories",
        default=None,
        help=(
            "Directory to search for Verilog modules; may be specified more than once "
            f"(default: {default_module_directory})"
        ),
    )
    args = parser.parse_args()

    top_file = os.path.abspath(args.input)
    module_directories = [
        os.path.abspath(directory)
        for directory in (args.module_directories or [default_module_directory])
    ]

    visited = set()
    modules = resolve_modules(top_file, module_directories, visited)

    print(f"Top file: {top_file}")
    print(f"Module directories: {module_directories}")
    print(f"All detected modules: {modules}")

    build_and_run(top_file, modules, module_directories)


if __name__ == "__main__":
    main()
