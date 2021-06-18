# MIPS-CPU

本项目是复旦大学计算机科学技术学院计算机体系结构实验课程作业. 基于老师给的部分代码以及《*数字设计和计算机体系结构* 》分别实现了单周期, 多周期以及流水线版本的 MIPS 处理器, 具体实现功能如下 (实现细节过多这里就不展开了, 具体请参考之前的实验报告)



1. 指令集

    ```txt
    add $rd, $rs, $rt   # [rd] = [rs] + [rt]
    sub $rd, $rs, $rt   # [rd] = [rs] - [rt]
    and $rd, $rs, $rt   # [rd] = [rs] & [rt]
    or $rd, $rs, $rt    # [rd] = [rs] | [rt]
    slt $rd, $rs, $rt   # [rd] = [rs] < [rt] ? 1 : 0
    sll $rd, $rt, shamt # [rd] = [rt] << shamt
    srl $rd, $rt, shamt # [rd] = [rt] >> shamt
    sra $rd, $rt, shamt # [rd] = [rt] >>> shamt
    addi $rt, $rs, imm  # [rt] = [rs] + SignImm
    andi $rt, $rs, imm  # [rt] = [rs] & ZeroImm
    ori $rt, $rs, imm   # [rt] = [rs] | ZeroImm
    slti $rt, $rs, imm  # [rt] = [rs] < SignImm ? 1 : 0
    lw $rt, imm($rs)    # [rt] = [Address]
    sw $rt, imm($rs)    # [Address] = [rt]
    j label             # PC = JTA
    jal label           # [ra] = PC + 4, PC = JTA
    jr $rs              # PC = [rs]
    beq $rs, $rt, label # if ([rs] == [rt]) PC = BTA
    bne $rs, $rt, label # if ([rs] != [rt]) PC = BTA
    nop                 # No operation
    ```
    
	*单周期流水线实现了除 `jal` 指令的其余所有指令*, 多周期和流水线实现了全部指令.

2. 实现简易 I/O

3. 代码重构 (主要是流水线代码的重构, 单周期和多周期 MIPS 也有部分更改)

4. Pipeline-MIPS 增加**动态分支预测**功能 (即增加 Branch Predict Buffer, 具体参考 Pipeline 的实验报告)

5. 解决了 `sra` 算数右移失败问题, 即在 ALU 单元中将原先算数右移语句替换成如下语句即可

    ```verilog
    3'b101:   result_o = $signed(a_i) >>> b_i;  // 5: sra
    ```