| 指令 | **opcode** | **funct** | `jump` | `reg_we` | `sel_reg_write_addr` | `sel_reg_write_data` | `mem_we` | `sel_alu_src_a` | `sel_alu_src_b` | `alu_op` | `branch` | `sel_jal` |
| ---- | ---------- | --------- | ------ | -------- | ---------------- | ---------------- | -------- | ----------- | ----------- | -------- | -------- | ------------ |
| `addi` | 6'b00_1000 | 6'bXX_XXXX | 00 | 1 | 0 | 0 | 0 | 0 | 01 | 000 | 00 | 0 |
| `andi` | 6'b00_1100 | 6'bXX_XXXX | 00 | 1 | 0 | 0 | 0 | 0 | 01 | 010 | 00 | 0 |
|  `ori` | 6'b00_1101 | 6'bXX_XXXX | 00 | 1 | 0 | 0 | 0 | 0 | 01 | 011 | 00 | 0 |
|  `lw`  | 6'b10_0011 | 6'bXX_XXXX | 00 | 1 | 0 | 1 | 0 | 0 | 01 | 000 | 00 | 0 |
|  `sw`  | 6'b10_1011 | 6'bXX_XXXX | 00 | 0 | 0 | 0 | 1 | 0 | 01 | 000 | 00 | 0 |
|  `j`   | 6'b00_0010 | 6'bXX_XXXX | 01 | 0 | 0 | 0 | 0 | 0 | 00 | 000 | 00 | 0 |
|  `jr`  | 6'b00_0000 | 6'b00_1000 | 10 | 0 | 0 | 0 | 0 | 0 | 00 | 000 | 00 | 0 |
|  `jal` | 6'b00_0011 | 6'bXX_XXXX | 01 | 1 | 0 | 0 | 0 | 0 | 00 | 000 | 00 | 1 |
|  `beq` | 6'b00_0100 | 6'bXX_XXXX | 00 | 0 | 0 | 0 | 0 | 0 | 00 | 000 | 01 | 0 |
|  `bne` | 6'b00_0101 | 6'bXX_XXXX | 00 | 0 | 0 | 0 | 0 | 0 | 00 | 000 | 10 | 0 |
|  `sll` | 6'b00_0000 | 6'b00_0000 | 00 | 1 | 1 | 0 | 0 | 1 | 10 | 100 | 00 | 0 |
|  `srl` | 6'b00_0000 | 6'b00_0010 | 00 | 1 | 1 | 0 | 0 | 1 | 10 | 101 | 00 | 0 |
|  `sra` | 6'b00_0000 | 6'b00_0011 | 00 | 1 | 1 | 0 | 0 | 1 | 10 | 110 | 00 | 0 |
| R Type | 6'b00_0000 | 6'bXX_XXXX | 00 | 1 | 1 | 0 | 0 | 0 | 00 | 111 | 00 | 0 |

```txt
add $rd, $rs, $rt # [rd] = [rs] + [rt]
sub $rd, $rs, $rt # [rd] = [rs] - [rt]
and $rd, $rs, $rt # [rd] = [rs] & [rt]
or $rd, $rs, $rt # [rd] = [rs] | [rt]
slt $rd, $rs, $rt # [rd] = [rs] < [rt] ? 1 : 0
sll $rd, $rt, shamt # [rd] = [rt] << shamt
srl $rd, $rt, shamt # [rd] = [rt] >> shamt
sra $rd, $rt, shamt # [rd] = [rt] >>> shamt
addi $rt, $rs, imm # [rt] = [rs] + SignImm
andi $rt, $rs, imm # [rt] = [rs] & ZeroImm
ori $rt, $rs, imm # [rt] = [rs] | ZeroImm
slti $rt, $rs, imm # [rt] = [rs] < SignImm ? 1 : 0
lw $rt, imm($rs) # [rt] = [Address]
sw $rt, imm($rs) # [Address] = [rt]
j label # PC = JTA
jal label # [ra] = PC + 4, PC = JTA
jr $rs # PC = [rs]
beq $rs, $rt, label # if ([rs] == [rt]) PC = BTA
bne $rs, $rt, label # if ([rs] != [rt]) PC = BTA
nop # No operation
```