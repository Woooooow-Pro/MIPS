# Multi-Clycle CPU

S0: Fetch[0]  
instr_or_data = 0 -> instr  
alu_src_a = 00 -> instr  
alu_src_b = 001 -> 4  
alu_op = 000 -> add  
pc_src = 00 --> pc + 4
instr_reg_we = 1  
pc_write = 1

S1: Decode[1]  
alu_src_a = 00 -> PC[31:28]  
alu_src_b = 011 -> imm  
alu_op = 000 -> add  

S2: Jump[2]  
pc_src = 10  
pc_write = 1

S3: LWorSW[2]  
alu_src_a = 01 -> src1  
alu_src_b = 010 -> imm
alu_op = 000 -> add

S4: LWMemRead[3]  
instr_or_data = 1 -> data  

S5: SWMemWrite[3]  
instr_or_data = 1 -> data  
mem_we = 1

S6: LWRegWrite[4]  
reg_write_addr = 0 -> pc[20:16]  
reg_write_data = 1 -> mem_data  
reg_we = 1

S7: Beq[2]  
alu_src_a = 01 -> src1  
alu_src_b = 000 -> src2
alu_op = 000 -> add  
pc_src = 01 -> label  
branch = 10

S8: Bne[2]  
alu_src_a = 01 -> src1  
alu_src_b = 000 -> src2
alu_op = 000 -> add  
pc_src = 01 -> label  
branch = 01

S9: Addi[2]  
alu_src_a = 01 -> src1  
alu_src_b = 010 -> imm  
alu_op = 000 -> add

S10: Andi[2]  
alu_src_a = 01 -> src1  
alu_src_b = 010 -> imm  
alu_op = 010 -> and

S11: Ori[2]  
alu_src_a = 01 -> src1  
alu_src_b = 010 -> imm  
alu_op = 011 -> or

S12: Jr[2]  
pc_src = 11 -> src_a  
pc_write = 1


S13: ShiftLL[2]  
alu_src_a = 10 -> src2  
alu_src_b = 100 -> shift_imm  
alu_op = 100 -> sll

S14: ShiftRL[2]  
alu_src_a = 10 -> src2  
alu_src_b = 100 -> shift_imm  
alu_op = 101 -> srl

S15: ShiftRA[2]  
alu_src_a = 10 -> src2  
alu_src_b = 100 -> shift_imm  
alu_op = 110 -> sra

S16: RType[2]  
alu_src_a = 01 -> src1  
alu_src_b = 000 -> src2  
alu_op = 111 -> use func

S17: AluWriteBack[3]  
reg_write_addr = 1 -> instr[15:11]  
reg_write_data = 0 -> alu result  
reg_we = 1

```plantuml
state "S0: Fetch" as S0
state "S1: Decode" as S1
state "S2: Jump" as S2
state "S3: LWorSW" as S3
state "S4: LWMemRead" as S4
state "S5: SWMemWrite" as S5
state "S6: LWRegWrite" as S6
state "S7: Beq" as S7
state "S8: Bne" as S8
state "S9: Addi" as S9
state "S10: Andi" as S10
state "S11: Ori" as S11
state "S12: Jr" as S12
state "S13: ShiftLL" as S13
state "S14: ShiftRL" as S14
state "S15: ShiftRA" as S15
state "S16: RType" as S16
state "S17: AluWriteBack" as S17
state "S00: nextFetch" as S00

S0 -> S1
S1 -> S2
' S2 ---> S0
S1 -> S12: Op = R-Type and func = jr
S1 --> S3: Op = sw or lw
S3 --> S4: Op = lw
S3 --> S5: Op = sw
S4 --> S6


S1 --> S7: Op = beq
S1 --> S8: Op = bne
S1 --> S9: Op = addi
S1 --> S10: Op = andi
S1 --> S11: Op = ori
S1 --> S13: Op = R-Type and func = sll
S1 --> S14: Op = R-Type and func = srl
S1 --> S15: Op = R-Type and func = sra
S1 --> S16: Op = R-Type
S9 --> S17
S10 --> S17
S11 --> S17

' R-Type
S13 --> S17
S14 --> S17
S15 --> S17
S16 --> S17

S6 --> S00
S5 --> S00
S7 --> S00
S8 --> S00
S17 --> S00
```

output  logic   [1:0]branch,
    output  logic   [1:0]alu_src_a,
    output  logic   [2:0]alu_src_b,
    output  logic   [1:0]pc_src,
    output  logic   instr_or_data,
    output  logic   instr_reg_we,
    output  logic   pc_write,
    output  logic   reg_we,
    output  logic   reg_write_addr,
    output  logic   reg_write_data,
    output  logic   mem_we,
    output  logic   [2:0]alu_op

| **state ** | branch | alu_src_a | alu_src_b | pc_src | instr_or_data | instr_reg_we | pc_write | reg_we | reg_write_addr | reg_write_data | mem_we | alu_op |
| ---------- | ------ | --------- | --------- | ------ | ------------- | ------------ | -------- | ------ | -------------- | -------------- | ------ | ------ |
| **Fetch** | 00 | 00 | 001 | 00 | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 000 |
| **Decode** | 00 | 00 | 011 | 00 | 0 |0 | 0 | 0 | 0 | 0 | 0 | 000 |
| **Jr** | 00 | 00 | 000 | 11 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 000 |
| **Jump** | 00 | 00 | 000 | 10 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 000 |
| **Beq** | 10 | 01 | 000 | 01 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 000 |
| **Bne** | 01 | 01 | 000 | 01 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 000 |
| **LWorSW** | 00 | 01 | 010 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 000 |
| **LWMemRead** | 00 | 00 | 000 | 00 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 000 |
| **SWMemRead** | 00 | 00 | 000 | 00 | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 000 |
| **LWRegWrite** | 00 | 00 | 000 | 00 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 000 |
| **Addi** | 00 | 01 | 010 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 000 |
| **Andi** | 00 | 01 | 010 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 010 |
| **Ori** | 00 | 01 | 010 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 011 |
| **ShiftLL** | 00 | 10 | 100 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 100 |
| **ShiftRL** | 00 | 10 | 100 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 101 |
| **ShiftRA** | 00 | 10 | 100 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 110 |
| **RType** | 00 | 01 | 000 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 111 |
| **AluWriteBack** | 00 | 00 | 000 | 00 | 0 | 0 | 0 | 1 | 1 | 0 | 0 | 000 |

