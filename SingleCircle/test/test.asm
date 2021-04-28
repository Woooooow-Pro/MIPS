main:   addi    $t0, $0, 5
        addi    $t1, $0, 12
        addi    $t2, $t1, -9
        ori     $t3, $t0, 2
        andi    $t4, $t0, 7
        addi    $t5, $0, -7
        sub     $t0, $t3, $t2
        add     $t1, $t3, $t2
        or      $t2, $t0, $t2
        and     $t3, $t0, $t3
        sll     $t0, $t0, 2
        srl     $t2, $t2, 2
        sra     $t5, $t5, 1
        beq     $t0, $t3, end
        slt     $t0, $t0, $t1
        bne     $t0, $t1, around
        addi    $t5, $t5, 3
around: sw      $t5, 70($t1)
        lw      $t0, 80($0)
        j jump
        andi    $t1, $t1, 0
jump:   addi    $t1, $0, 96
        jr      $t1
        addi    $t5, $t5, 5
end:    sw      $t5, 84($0)