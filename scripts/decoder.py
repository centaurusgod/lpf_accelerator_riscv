import argparse


def get_bits(value, high, low):
    return (value >> low) & ((1 << (high - low + 1)) - 1)


def to_bin(value, width):
    return format(value, f"0{width}b")


# ---------- R TYPE ----------
def decode_r(inst):
    return {
        "funct7": to_bin(get_bits(inst, 31, 25), 7),
        "rs2": to_bin(get_bits(inst, 24, 20), 5),
        "rs1": to_bin(get_bits(inst, 19, 15), 5),
        "funct3": to_bin(get_bits(inst, 14, 12), 3),
        "rd": to_bin(get_bits(inst, 11, 7), 5),
        "opcode": to_bin(get_bits(inst, 6, 0), 7),
    }


# ---------- I TYPE ----------
def decode_i(inst):
    return {
        "imm[11:0]": to_bin(get_bits(inst, 31, 20), 12),
        "rs1": to_bin(get_bits(inst, 19, 15), 5),
        "funct3": to_bin(get_bits(inst, 14, 12), 3),
        "rd": to_bin(get_bits(inst, 11, 7), 5),
        "opcode": to_bin(get_bits(inst, 6, 0), 7),
    }


# ---------- S TYPE ----------
def decode_s(inst):
    return {
        "imm[11:5]": to_bin(get_bits(inst, 31, 25), 7),
        "rs2": to_bin(get_bits(inst, 24, 20), 5),
        "rs1": to_bin(get_bits(inst, 19, 15), 5),
        "funct3": to_bin(get_bits(inst, 14, 12), 3),
        "imm[4:0]": to_bin(get_bits(inst, 11, 7), 5),
        "opcode": to_bin(get_bits(inst, 6, 0), 7),
    }


# ---------- B TYPE ----------
def decode_b(inst):
    return {
        "imm[12]": to_bin(get_bits(inst, 31, 31), 1),
        "imm[10:5]": to_bin(get_bits(inst, 30, 25), 6),
        "rs2": to_bin(get_bits(inst, 24, 20), 5),
        "rs1": to_bin(get_bits(inst, 19, 15), 5),
        "funct3": to_bin(get_bits(inst, 14, 12), 3),
        "imm[4:1]": to_bin(get_bits(inst, 11, 8), 4),
        "imm[11]": to_bin(get_bits(inst, 7, 7), 1),
        "opcode": to_bin(get_bits(inst, 6, 0), 7),
    }


# ---------- U TYPE ----------
def decode_u(inst):
    return {
        "imm[31:12]": to_bin(get_bits(inst, 31, 12), 20),
        "rd": to_bin(get_bits(inst, 11, 7), 5),
        "opcode": to_bin(get_bits(inst, 6, 0), 7),
    }


# ---------- J TYPE ----------
def decode_j(inst):
    return {
        "imm[20]": to_bin(get_bits(inst, 31, 31), 1),
        "imm[10:1]": to_bin(get_bits(inst, 30, 21), 10),
        "imm[11]": to_bin(get_bits(inst, 20, 20), 1),
        "imm[19:12]": to_bin(get_bits(inst, 19, 12), 8),
        "rd": to_bin(get_bits(inst, 11, 7), 5),
        "opcode": to_bin(get_bits(inst, 6, 0), 7),
    }


def main():
    parser = argparse.ArgumentParser(
        description="RISC-V Instruction Decoder (Binary Output)"
    )
    parser.add_argument("hexval", help="32-bit instruction (e.g. 0x00a585b3)")
    parser.add_argument(
        "-t", "--type", required=True, choices=["R", "I", "S", "B", "U", "J"]
    )

    args = parser.parse_args()
    inst = int(args.hexval, 16)

    decode_map = {
        "R": decode_r,
        "I": decode_i,
        "S": decode_s,
        "B": decode_b,
        "U": decode_u,
        "J": decode_j,
    }

    decoded = decode_map[args.type](inst)

    print("\nDecoded Instruction (Binary):")
    for key, value in decoded.items():
        print(f"{key}: {value}")


if __name__ == "__main__":
    main()
