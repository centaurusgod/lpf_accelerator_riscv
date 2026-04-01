import re
import argparse
import subprocess
import os
import tempfile

# Ignore these keywords (not module instantiations)
VERILOG_KEYWORDS = {
    "if", "for", "while", "assign", "always", "case",
    "begin", "end", "else", "initial"
}


def clean_verilog(content):
    # Remove comments
    content = re.sub(r'//.*', '', content)
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
    return content


def extract_instantiations(content):
    # Match: module_name instance_name (
    matches = re.findall(r'\b(\w+)\s+\w+\s*\(', content)

    modules = set()
    for m in matches:
        if m not in VERILOG_KEYWORDS:
            modules.add(m)

    return modules


def resolve_modules(file_path, visited):
    """
    Recursively find all module dependencies
    """
    if file_path in visited:
        return set()

    visited.add(file_path)

    if not os.path.exists(file_path):
        print(f"Warning: {file_path} not found.")
        return set()

    with open(file_path, 'r') as f:
        content = clean_verilog(f.read())

    found_modules = extract_instantiations(content)

    all_modules = set(found_modules)

    for module in found_modules:
        sub_file = f"{module}.v"
        sub_modules = resolve_modules(sub_file, visited)
        all_modules.update(sub_modules)

    return all_modules


def build_and_run(top_file, modules):
    source_files = [top_file]

    for mod in modules:
        filename = f"{mod}.v"
        if os.path.exists(filename):
            source_files.append(filename)
        else:
            print(f"Warning: {filename} not found, skipping.")

    output_file = tempfile.NamedTemporaryFile(delete=False, suffix=".vvp").name

    compile_cmd = ["iverilog", "-o", output_file] + source_files

    print("\nCompiling with:")
    print(" ".join(compile_cmd))

    subprocess.run(compile_cmd, check=True)

    print("\nRunning simulation:\n")
    subprocess.run(["vvp", output_file], check=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input", required=True, help="Top-level Verilog file")
    args = parser.parse_args()

    visited = set()
    modules = resolve_modules(args.input, visited)

    print(f"Top file: {args.input}")
    print(f"All detected modules: {modules}")

    build_and_run(args.input, modules)


if __name__ == "__main__":
    main()