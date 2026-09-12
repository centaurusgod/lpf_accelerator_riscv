# This script is used for generating RISC-V assembly instruction
# To load 32 bit immediate values into a register using LUI and ADDI instructions.
# Use this instruction provided by this script in https://riscv-simulator-five.vercel.app/ to generate the machine code


def format_hex_imm(value: int) -> str:
    if value >= 0:
        return f"0x{value:x}"
    return f"-0x{abs(value):x}"


def generate_riscv_load_imm(reg: str, val: int) -> list[str]:
    # Handle values that fit in a single sign-extended 12-bit immediate (-2048 to 2047)
    if -2048 <= val <= 2047:
        return [f"addi {reg}, x0, {format_hex_imm(val)}"]

    # Extract lower 12 bits and upper 20 bits
    lower_12 = val & 0xFFF
    upper_20 = (val >> 12) & 0xFFFFF

    # Check if bit 11 of the lower 12 bits is 1 (sign extension flag)
    if lower_12 & 0x800:
        # Sign-extend lower_12 to a negative integer for addi representation
        addi_imm = lower_12 - 0x1000
        # Increment upper_20 to offset the subtraction from sign extension
        upper_20 = (upper_20 + 1) & 0xFFFFF
    else:
        addi_imm = lower_12

    instructions = []
    if upper_20 != 0:
        instructions.append(f"lui {reg}, {format_hex_imm(upper_20)}")
    if addi_imm != 0:
        instructions.append(f"addi {reg}, {reg}, {format_hex_imm(addi_imm)}")

    return instructions


def main():
    user_input = input("Enter register and decimal value (e.g., x4 35000): ").strip()
    if not user_input:
        return

    parts = user_input.split()
    if len(parts) != 2:
        print(
            "Error: Please provide exactly two space-separated inputs (register and value)."
        )
        return

    reg, val_str = parts[0], parts[1]

    try:
        val = int(val_str)
    except ValueError:
        print("Error: Second input must be a valid integer.")
        return

    # Ensure 32-bit bound enforcement
    if not (-2147483648 <= val <= 4294967295):
        print("Error: Value outside 32-bit range.")
        return

    # Treat unsigned 32-bit values > 0x7FFFFFFF as signed equivalents
    if val > 0x7FFFFFFF:
        val -= 0x100000000

    instructions = generate_riscv_load_imm(reg, val)

    print("\nGenerated Assembly:")
    for inst in instructions:
        print(f"  {inst}")


if __name__ == "__main__":
    main()
