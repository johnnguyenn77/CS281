0x00000000		0x00000293		addi x5 x0 0
0x00000004		0x00300313		addi x6 x0 3
0x00000008		0x00128293		addi x5 x5 1
0x0000000C		0xFE629EE3		bne x5 x6 -4
0x00000010		0x00030913		addi x18 x6 0
0x00000014		0x00000293		addi x5 x0 0
0x00000018		0x00300313		addi x6 x0 3
0x0000001C		0x00628663		beq x5 x6 12
0x00000020		0x00128293		addi x5 x5 1
0x00000024		0xFF9FF06F		jal x0 -8
0x00000028		0x00030993		addi x19 x6 0
0x0000002C		0x00000293		addi x5 x0 0
0x00000030		0x00300313		addi x6 x0 3
0x00000034		0x0062C663		blt x5 x6 12
0x00000038		0x00128293		addi x5 x5 1
0x0000003C		0xFF9FF06F		jal x0 -8
0x00000040		0x00030A13		addi x20 x6 0
0x00000044		0x00000293		addi x5 x0 0
0x00000048		0x00300313		addi x6 x0 3
0x0000004C		0x00128293		addi x5 x5 1
0x00000050		0xFE535EE3		bge x6 x5 -4
0x00000054		0x00030A93		addi x21 x6 0
0x00000058		0x00000013		addi x0 x0 0