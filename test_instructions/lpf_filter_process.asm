-- If 
--  mmio low pass filter address
-- x0

-- start data address
addi x2, x0, 2

-- start store data address 65000th location
lui  x6, 0x10
addi x6, x6, -536

-- count 30000
lui  x3, 0x7
addi x3, x3, 1328

-- count decrementer register x7
addi x7, x0, 1

-- process 30,000 samples of 16 bit pcm audio
READ_AUDIO: 
lh x4, 0(x2)
sh x4, 0(x0); x4->[x0]=lpf_x_in

-- load the lpf_output back
lh x5, 0(x0); lpf_y_out -> x5

-- store the output back to memory
sh x5, 0(x6); x5->[x6]


-- increment start data mem address by 2 as we load half word
addi x2, x2, 2
-- increment store data mem address by 2
addi x6, x6, 2

-- decrement the count
sub x3, x3, x7; could have used 1 less reg by adding 2's compl lol

bne x3, x0, READ_AUDIO
