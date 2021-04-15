# Single-Clycle CPU

alu_op | operation
-| -
000 | add
001 | sub
010 | and
011 | or
1XX | func

**instruct** | **operation** | **func** | branch | jump | reg_we | reg_write_addr | reg_write_data | alu_src | mem_we | alu_op
-| -| -| -| -| -| -| -| -| -| -
**R Type**| 6'b00_0000 | 6'bXX_XXXX | 00 | 00 | 1 | 1 | 0 | 0 | 0 | 111
  lw     | 6'b10_0011 | 6'bXX_XXXX | 00 | 00 | 1 | 0 | 1 | 1 | 0 | 000
  sw     | 6'b10_1011 | 6'bXX_XXXX | 00 | 00 | 0 | X | X | 1 | 1 | 000
  beq    | 6'b00_0100 | 6'bXX_XXXX | 10 | 00 | 0 | X | X | 0 | 0 | 001
  bnq    | 6'b00_0101 | 6'bXX_XXXX | 01 | 00 | 0 | X | X | 0 | 0 | 001
  addi   | 6'b00_1000 | 6'bXX_XXXX | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 000
  andi   | 6'b00_1100 | 6'bXX_XXXX | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 010
  ori    | 6'b00_1101 | 6'bXX_XXXX | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 001
  sll    | 6'b00_0000 | 6'b00_0000 | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 011
  srl    | 6'b00_0000 | 6'b00_0010 | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 100
  sll    | 6'b00_0000 | 6'b00_0011 | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 101
   j     | 6'b00_0010 | 6'bXX_XXXX | XX | 01 | 0 | X | X | X | 0 | XXX
  jr     | 6'b00_0000 | 6'b00_1000 | XX | 10 | 0 | X | X | X | 0 | XXX
