0x_______0    addi x2, x0, 100     // x2 = 100 (limit)
0x_______4    addi x1, x0, 0       // x1 = 0 (i)

0x_______8 loop:
0x_______8    addi x1, x1, 1       // i++

0x_______C    beq  x1, x2, end     // if i == 100 → exit

0x_______10   beq  x0, x0, loop    // unconditional jump

0x_______14   nop
0x_______18   nop

int i =0;
while(i < 100){
    i++;
}

