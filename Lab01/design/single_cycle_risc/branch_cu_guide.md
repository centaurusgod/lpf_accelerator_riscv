# Guidelines on Branch Control Unit Design

## Things to Consider

When designing the branch control unit, the following ALU flags are critical:

- **Zero Flag**
- **Carry Out**
- **Sign Flag**
- **Overflow Flag**

These flags are used to handle signed and unsigned number comparisons. Below, we explore why these flags are chosen and how they are used for branch control.

For branch instructions, subtraction is performed between two numbers to decide the operation:

---

## Case: `beq` and `bne` Instructions

These are the most straightforward cases, where the **Zero Flag** is used to determine whether two numbers are equal or not.

$$A - B = A + \text{2's complement of } B$$

### Logic

- **`beq` (branch if equal):** If `Zero Flag = 1`, the ALU result is `0`, meaning the two numbers are equal. The branch is taken.
- **`bne` (branch if not equal):** If `Zero Flag = 0`, the ALU result is not `0`, meaning the two numbers are not equal. The branch is taken.

### Example

For simplicity, consider 4-bit numbers:

| A | B | A (bin) | 2's comp B | BEQ | BNE | ALU result | C | Z |
|---|---|---------|------------|-----|-----|------------|---|---|
| 0 | 0 | 0000    | 0000       |  1  |  0  | 0 0000     | 0 | 1 |
| 0 | 1 | 0000    | 1111       |  0  |  1  | 1 1111     | 1 | 0 |
| 1 | 0 | 0001    | 0000       |  0  |  1  | 0 0001     | 0 | 0 |
| 1 | 1 | 0001    | 1111       |  1  |  0  | 0 0000     | 0 | 1 |
| 2 | 3 | 0010    | 1101       |  0  |  1  | 1 1111     | 1 | 0 |
| 3 | 2 | 0011    | 1110       |  0  |  1  | 0 0001     | 0 | 0 |
| 4 | 4 | 0100    | 1100       |  1  |  0  | 0 0000     | 0 | 1 |
| 5 | 6 | 0101    | 1010       |  0  |  1  | 1 1111     | 1 | 0 |
| 6 | 5 | 0110    | 1011       |  0  |  1  | 0 0001     | 0 | 0 |
| 7 | 7 | 0111    | 1001       |  1  |  0  | 0 0000     | 0 | 1 |

From the table, we can conclude:

- `beq = 1` if and only if `Zero Flag = 1`.
- `bne = 1` if and only if `Zero Flag = 0`.

---

## Case: `blt` and `bge` Instructions

### Why Carry and Zero Flags Are Not Needed
- **Signed Comparisons:** `blt` (branch if less than) and `bge` (branch if greater or equal) operate on signed numbers.
- **Sign (S) and Overflow (V) Flags:** These flags fully determine the relationship between two signed numbers after subtraction.
- **Carry (C) Flag Irrelevance:** The Carry flag is only relevant for unsigned arithmetic (e.g., `bltu` and `bgeu`).
- **Conclusion:** The S and V flags alone are sufficient to determine the branch decision for `blt` and `bge`. Checking C and Z flags is unnecessary.

Range for signed numbers in $n$ bits: $[-2^{n-1},\ 2^{n-1}-1]$

In signed representation, the MSB represents the sign:
- MSB = 1 → Negative number
- MSB = 0 → Positive number

In 4 bits, the range is $[-8,\ 7]$.

### Understanding Overflow Cases

1. When two positive numbers are added and the result is negative, it is an overflow.
2. When two negative numbers are added and the result is positive, it is an overflow.

To derive `blt` and `bge`, let's perform subtraction between pairs: $[+A, +B]$, $[-A, -B]$, $[+A, -B]$, $[-A, +B]$.

We know when `bge` and `blt` must be true, and we check the corresponding flags to verify that they match our expectations.

Overflow is calculated as follows:
- If the signs of A and B are the same, but the sign of the result is different, then overflow has occurred.
$$\text{Overflow} = (A[31] == B[31]) \land (Result[31] \neq A[31])$$

| A  | B  | A (bin) | 2's comp B | bge | blt | ALU result | C | Z | S | V(Overflow) |
|----|----|---------|------------|-----|-----|------------|---|---|---|---|
| +3 | +5 | 0011    | 1011       |  0  |  1  | 1 1110     | 1 | 0 | 1 | 0 |
| +6 | +2 | 0110    | 1110       |  1  |  0  | 1 0100     | 1 | 0 | 0 | 0 |
| +7 | −3 | 0111    | 0011       |  1  |  0  | 0 1010     | 0 | 0 | 1 | 1 |
| −8 | +1 | 1000    | 1111       |  0  |  1  | 0 0111     | 0 | 0 | 0 | 1 |
| −4 | −4 | 1100    | 0100       |  1  |  0  | 1 0000     | 1 | 1 | 0 | 0 |
| +2 | −2 | 0010    | 0010       |  1  |  0  | 0 0100     | 0 | 0 | 0 | 0 |
| −3 | +4 | 1101    | 1100       |  0  |  1  | 1 1001     | 1 | 0 | 1 | 0 |

### K-map for `blt = 1`

| S \ V | 0 | 1 |
|-------|---|---|
| 0     | 0 | 1 |
| 1     | 1 | 0 |

$$\text{blt} = S \cdot \overline{V} + \overline{S} \cdot V = S \oplus V$$

### K-map for `bge = 1`

| S \ V | 0 | 1 |
|-------|---|---|
| 0     | 1 | 0 |
| 1     | 0 | 1 |

$$\text{bge} = S \cdot V + \overline{S} \cdot \overline{V} = \overline{S \oplus V}$$

---

## Case: `bltu` and `bgeu` Instructions

For unsigned numbers, the **Carry Out** flag is used to decide the branch.

### Verification

Subtraction is performed between pairs of unsigned numbers to confirm this.

### Example 1

| Case | A | B | A (bin) | 2's comp B | ALU Result | C | Z |
|------|---|---|---------|------------|------------|---|---|
| A = B | 5 | 5 | 0101 | 1011 | 1 0000 | 1 | 1 |
| A < B | 4 | 5 | 0100 | 1011 | 0 1111 | 0 | 0 |
| A > B | 5 | 4 | 0101 | 1100 | 1 0001 | 1 | 0 |

### Example 2

| Case | A | B | A (bin) | 2's comp B | ALU Result | C | Z |
|------|---|---|---------|------------|------------|---|---|
| A = B | 8 | 8 | 1000 | 1000 | 1 0000 | 1 | 1 |
| A > B | 8 | 6 | 1000 | 1010 | 1 0010 | 1 | 0 |
| A < B | 6 | 8 | 0110 | 1000 | 0 1110 | 0 | 0 |

### Conclusion

| Condition | ALU Result | Zero Flag | Carry Out |
|-----------|------------|-----------|-----------|
| A = B     | 0          | 1         | 1         |
| A < B     | Non-zero   | 0         | 0         |
| A > B     | Non-zero   | 0         | 1         |

### Summary

- When $A \geq B$: Carry Out $= 1$
- When $A < B$: Carry Out $= 0$

For `bltu` and `bgeu`, the Zero Flag is not needed because Carry Out alone suffices:

$$\text{bltu} = \overline{C}$$

$$\text{bgeu} = C$$