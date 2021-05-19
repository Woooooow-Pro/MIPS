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
state "S18: AluWriteBackImm" as S18
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
S9 --> S18
S10 --> S18
S11 --> S18

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
S18 --> S00
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

| **state** | branch | alu_src_a | alu_src_b | pc_src | instr_or_data | instr_reg_we | pc_write | reg_we | reg_write_addr | reg_write_data | mem_we | alu_op |
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
| **LWRegWrite** | 00 | 00 | 000 | 00 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 000 |
| **Addi** | 00 | 01 | 010 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 000 |
| **Andi** | 00 | 01 | 010 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 010 |
| **Ori** | 00 | 01 | 010 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 011 |
| **ShiftLL** | 00 | 10 | 100 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 100 |
| **ShiftRL** | 00 | 10 | 100 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 101 |
| **ShiftRA** | 00 | 10 | 100 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 110 |
| **RType** | 00 | 01 | 000 | 00 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 111 |
| **AluWriteBack** | 00 | 00 | 000 | 00 | 0 | 0 | 0 | 1 | 1 | 0 | 0 | 000 |
| **AluWriteBackImm** | 00 | 00 | 000 | 00 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 000 |



```asm
main:   addi    $t0, $0, 5      ; initialize $t0 = 5            20080005
        addi    $t1, $0, 12     ; initialize $t1 = 12           2009000c
        addi    $t2, $t1, -9    ; initialize $t2 = 3            212afff7
        ori     $t3, $t0, 2     ; initialize $t3 = 7            350b0002
        andi    $t4, $t0, 7     ; initialize $t4 = 5            310c0007
        addi    $t5, $0, -7     ; initialize $t5 = -7           200dfff9
        sub     $t0, $t3, $t2   ; set $t0 = $t3 - $t2 = 4       016a4022
        add     $t1, $t3, $t2   ; set $t1 = $t3 + $t2 = 10      016a4820
        or      $t2, $t0, $t2   ; set $t2 = $t1 | $t2 = 7       010a5025
        and     $t3, $t0, $t3   ; set $t3 = $t1 & $t3 = 4       010b5824
        sll     $t0, $t0, 2     ; set $t0 = $t0 << 2 = 16       00084080
        srl     $t2, $t2, 2     ; set $t2 = $t2 >> 2 = 1        000a5082
        sra     $t5, $t5, 1     ; set $t5 = $t5 >>> 1 = -3      000d6843
        beq     $t0, $t3, end   ; shouldn't be taken            110b0007
        slt     $t0, $t0, $t1   ; set $t0 = $t0 < $t1 = 0       0109402a
        bne     $t0, $t1, around; should be taken               15090001
        addi    $t5, $t5, 3     ; should not happen             21ad0003

around: sw      $t5, 70($t1)    ; mem[512] = -3                 ad2d01f6
        lw      $t0, 512($0)    ; $t0 = mem[512] = -3           8c080200
        jal jump                ; jump to jump, $ra = pc + 4    0c000016
        andi    $t1, $t1, 0     ; should not happen             31290000

jump:   addi    $t1, $0, 96     ; set $t1 = end                 20090064
        jr      $t1             ; jump to end                   01200008
        addi    $t5, $t5, 5     ; shouldn't taken               21ad0005

end:    sw      $t5, 516($0)    ; mem[516] = $2 = -3            ac0d0204
```