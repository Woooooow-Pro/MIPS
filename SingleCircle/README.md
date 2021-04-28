# Single-Clycle CPU

alu_op | alu_control | operation
-| - | -
000 | 010 | add
001 | 110 | sub
010 | 000 | and
011 | 001 | or
100 | 011 | sll
101 | 100 | srl
110 | 101 | sra
111 | XXX | func

**instruct** | **operation** | **func** | branch | jump | reg_we | reg_write_addr | reg_write_data | alu_src | mem_we | alu_op
-| -| -| -| -| -| -| -| -| -| -
**R Type**| 6'b00_0000 | 6'bXX_XXXX | 00 | 00 | 1 | 1 | 0 | 0 | 0 | 111
  lw     | 6'b10_0011 | 6'bXX_XXXX | 00 | 00 | 1 | 0 | 1 | 1 | 0 | 000
  sw     | 6'b10_1011 | 6'bXX_XXXX | 00 | 00 | 0 | X | X | 1 | 1 | 000
  beq    | 6'b00_0100 | 6'bXX_XXXX | 10 | 00 | 0 | X | X | 0 | 0 | 001
  bne    | 6'b00_0101 | 6'bXX_XXXX | 01 | 00 | 0 | X | X | 0 | 0 | 001
  addi   | 6'b00_1000 | 6'bXX_XXXX | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 000
  andi   | 6'b00_1100 | 6'bXX_XXXX | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 010
  ori    | 6'b00_1101 | 6'bXX_XXXX | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 011
  sll    | 6'b00_0000 | 6'b00_0000 | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 100
  srl    | 6'b00_0000 | 6'b00_0010 | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 101
  sra    | 6'b00_0000 | 6'b00_0011 | 00 | 00 | 1 | 0 | 0 | 1 | 0 | 110
   j     | 6'b00_0010 | 6'bXX_XXXX | XX | 01 | 0 | X | X | X | 0 | XXX
  jr     | 6'b00_0000 | 6'b00_1000 | XX | 10 | 0 | X | X | X | 0 | XXX


## test instructor

1. `bnq` & `andi` & `ori`

```asm
main:   addi    $t0, $0, 5      ; initialize $t0 = 5
        addi    $t1, $0, 12     ; initialize $t1 = 12
        addi    $t2, $t1, -9    ; initialize $t2 = 3
        ori     $t3, $t0, 2     ; initialize $t3 = 7
        andi    $t4, $t0, 7     ; initialize $t4 = 5
        addi    $t5, $0, -7     ; initialize $t5 = -7
        sub     $t0, $t3, $t2   ; set $t0 = $t3 - $t2 = 4
        add     $t1, $t3, $t2   ; set $t1 = $t3 + $t2 = 10
        or      $t2, $t0, $t2   ; set $t2 = $t1 | $t2 = 7
        and     $t3, $t0, $t3   ; set $t3 = $t1 & $t3 = 4
        sll     $t0, $t0, 2     ; set $t0 = $t0 << 2 = 16
        srl     $t2, $t2, 2     ; set $t2 = $t2 >> 2 = 1
        sra     $t5, $t5, 1     ; set $t5 = $t5 >>> 1 = -3
        beq     $t0, $t3, end   ; shouldn't be taken
        slt     $t0, $t0, $t1   ; set $t0 = $t0 < $t1 = 0
        bne     $t0, $t1, around; should be taken
        addi    $t5, $t5, 3     ; should not happen

around: sw      $t5, 70($t1)    ; mem[80] = -3
        lw      $t0, 80($0)     ; $t0 = mem[80] = -3
        j jump                  ; jump to jump
        andi    $t1, $t1, 0     ; should not happen

jump:   addi    $t1, $0, 96     ; set $t1 = end
        jr      $t1             ; jump to end
        addi    $t5, $t5, 5     ; shouldn't taken

end:    sw      $t5, 84($0)     ; mem[84] = $2 = -3


;         addi    $t1, $0, around
; jump:   addi    $t1, $0, end
;         jr      $t1
;         addi    $t5, $t5, 5
```