	j	_min_caml_start
min_caml_create_array:
	addi	$s1, $a0, 0
	addi	$a0, $gp, 0
create_array_loop:
	bne	$s1, $zero, create_array_cont
	jr	$ra
create_array_cont:
	sw	$a1, 0($gp)
	addi	$s1, $s1, -1
	addi	$gp, $gp, 4
	j	create_array_loop
min_caml_create_float_array:
	addi	$s1, $a0, 0
	addi	$a0, $gp, 0
create_float_array_loop:
	bne	$s1, $zero, create_float_array_cont
	jr	$ra
create_float_array_cont:
	swc1	$f0, 0($gp)
	addi	$s1, $s1, -1
	addi	$gp, $gp, 4
	j	create_float_array_loop
kernel_sin:
	lui	$s1, 15914
	ori	$s1, $s1, 43692
	mtc1	$s1, $f1
	mul.s	$f1, $f1, $f0
	mul.s	$f1, $f1, $f0
	mul.s	$f1, $f1, $f0
	sub.s	$f1, $f0, $f1
	lui	$s1, 15368
	ori	$s1, $s1, 34406
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	add.s	$f1, $f1, $f2
	lui	$s1, 14669
	ori	$s1, $s1, 25781
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f0, $f2, $f0
	sub.s	$f0, $f1, $f0
	jr	$ra
kernel_cos:
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	lui	$s1, 16128
	ori	$s1, $s1, 0
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	sub.s	$f1, $f1, $f2
	lui	$s1, 15658
	ori	$s1, $s1, 42889
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	add.s	$f1, $f1, $f2
	lui	$s1, 15027
	ori	$s1, $s1, 33023
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f0, $f2, $f0
	sub.s	$f0, $f1, $f0
	jr	$ra
minus_sin:
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	sub.s	$f0, $fzero, $f0
	lahi	$ra, tmp.sin_148
	lalo	$ra, tmp.sin_148
min_caml_sin:
	c.lt.s	$s0, $f0, $fzero
	bne	$s0, $zero, minus_sin
	lui	$s1, 16457
	ori	$s1, $s1, 4059
	mtc1	$s1, $f1
	c.lt.s	$s0, $f0, $f1
	beq	$s0, $zero, bne_else.sin_145
	lui	$s1, 16329
	ori	$s1, $s1, 4059
	mtc1	$s1, $f2
	c.lt.s	$s0, $f0, $f2
	beq	$s0, $zero, bne_else.sin_146
	lui	$s1, 16201
	ori	$s1, $s1, 4059
	mtc1	$s1, $f1
	c.lt.s	$s0, $f1, $f0
	beq	$s0, $zero, bne_else.sin_147
	lui	$s1, 16329
	ori	$s1, $s1, 4059
	mtc1	$s1, $f1
	sub.s	$f0, $f1, $f0
	j	kernel_cos
bne_else.sin_147:
	j	kernel_sin
bne_else.sin_146:
	sub.s	$f0, $f1, $f0
	j	min_caml_sin
	bne_else.sin_145:
	sub.s	$f0, $f0, $f1
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	lahi	$ra, tmp.sin_148
	lalo	$ra, tmp.sin_148
	j	min_caml_sin
tmp.sin_148:
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	sub.s	$f0, $fzero, $f0
	jr	$ra
minus_cos:
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	sub.s	$f0, $fzero, $f0
	lahi	$ra, tmp.cos_137
	lalo	$ra, tmp.cos_137
min_caml_cos:
	c.lt.s	$s0, $f0, $fzero
	bne	$s0, $zero, minus_cos
	lui	$s1, 16457
	ori	$s1, $s1, 4059
	mtc1	$s1, $f1
	c.lt.s	$s0, $f0, $f1
	beq	$s0, $zero, bne_else.cos_134
	lui	$s1, 16329
	ori	$s1, $s1, 4059
	mtc1	$s1, $f2
	c.lt.s	$s0, $f0, $f2
	beq	$s0, $zero, bne_else.cos_135
	lui	$s1, 16201
	ori	$s1, $s1, 4059
	mtc1	$s1, $f1
	c.lt.s	$s0, $f1, $f0
	beq	$s0, $zero, bne_else.cos_136
	lui	$s1, 16329
	ori	$s1, $s1, 4059
	mtc1	$s1, $f1
	sub.s	$f0, $f1, $f0
	j	kernel_sin
bne_else.cos_136:
	j	kernel_cos
bne_else.cos_135:
	sub.s	$f0, $f1, $f0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	lahi	$ra, tmp.cos_137
	lalo	$ra, tmp.cos_137
	j	min_caml_cos
tmp.cos_137:
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	sub.s	$f0, $fzero, $f0
	jr	$ra
bne_else.cos_134:
	sub.s	$f0, $f0, $f1
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	lahi	$ra, tmp.cos_137
	lalo	$ra, tmp.cos_137
	j	min_caml_cos
kernel_atan:
	lui	$s1, 16042
	ori	$s1, $s1, 43679
	mtc1	$s1, $f1
	mul.s	$f1, $f1, $f0
	mul.s	$f1, $f1, $f0
	mul.s	$f1, $f1, $f0
	sub.s	$f1, $f0, $f1
	lui	$s1, 15948
	ori	$s1, $s1, 52429
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	add.s	$f1, $f1, $f2
	lui	$s1, 15890
	ori	$s1, $s1, 18725
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	sub.s	$f1, $f1, $f2
	lui	$s1, 15843
	ori	$s1, $s1, 36408
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	add.s	$f1, $f1, $f2
	lui	$s1, 15799
	ori	$s1, $s1, 54894
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	sub.s	$f1, $f1, $f2
	lui	$s1, 15733
	ori	$s1, $s1, 59333
	mtc1	$s1, $f2
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f2, $f2, $f0
	mul.s	$f0, $f2, $f0
	add.s	$f0, $f1, $f0
	jr	$ra
min_caml_atan:
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$s0, $f0, $f1
	beq	$s0, $zero, bne_else_atan.165
	sub.s	$f0, $fzero, $f0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_atan
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	sub.s	$f0, $fzero, $f0
	jr	$ra
bne_else_atan.165:
	lui	$s1, 16096
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$s0, $f0, $f1
	beq	$s0, $zero, bne_else_atan.166
	j	kernel_atan
bne_else_atan.166:
	lui	$s1, 16412
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$s0, $f0, $f1
	beq	$s0, $zero, bne_else_atan.167
	lui	$s1, 16201
	ori	$s1, $s1, 4059
	mtc1	$s1, $f1
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f2
	sub.s	$f2, $f0, $f2
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f3
	add.s	$f0, $f0, $f3
	div.s	$f0, $f2, $f0
	swc1	$f1, 0($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	kernel_atan
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lwc1	$f1, 0($sp)
	add.s	$f0, $f1, $f0
	jr	$ra
bne_else_atan.167:
	lui	$s1, 16329
	ori	$s1, $s1, 4059
	mtc1	$s1, $f1
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f2
	div.s	$f0, $f2, $f0
	swc1	$f1, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	kernel_atan
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	sub.s	$f0, $f1, $f0
	jr	$ra
min_caml_fabs:
	c.lt.s	$s0, $f0, $fzero
	bne	$s0, $zero, minus
	jr	$ra
minus:
	sub.s	$f0, $fzero, $f0
	jr	$ra
dbl.38:
	add.s	$f0, $f0, $f0
	jr	$ra
iloop.54:
	bne	$a0, $zero, bne_else.112
	addi	$a0, $zero, 1
	outi	$a0
	jr	$ra
bne_else.112:
	sub.s	$f2, $f2, $f3
	add.s	$f2, $f2, $f4
	swc1	$f4, 0($sp)
	sw	$a0, 8($sp)
	swc1	$f2, 16($sp)
	swc1	$f5, 24($sp)
	swc1	$f1, 32($sp)
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	dbl.38
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lwc1	$f1, 32($sp)
	mul.s	$f0, $f0, $f1
	lwc1	$f5, 24($sp)
	add.s	$f1, $f0, $f5
	lwc1	$f0, 16($sp)
	mul.s	$f2, $f0, $f0
	mul.s	$f3, $f1, $f1
	add.s	$f4, $f2, $f3
	lui	$s1, 16512
	ori	$s1, $s1, 0
	mtc1	$s1, $f6
	c.lt.s	$s0, $f6, $f4
	beq	$s0, $zero, bne_else.114
	addi	$a0, $zero, 0
	outi	$a0
	jr	$ra
bne_else.114:
	lw	$a0, 8($sp)
	addi	$a0, $a0, -1
	lwc1	$f4, 0($sp)
	j	iloop.54
xloop.44:
	slti	$s0, $a0, 400
	beq	$s0, $zero, bne_else.115
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	itof	$f0, $a0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	dbl.38
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lui	$s1, 17352
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	div.s	$f0, $f0, $f1
	lui	$s1, 16320
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	sub.s	$f0, $f0, $f1
	lw	$a0, 4($sp)
	swc1	$f0, 8($sp)
	itof	$f0, $a0
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	dbl.38
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lui	$s1, 17352
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	div.s	$f0, $f0, $f1
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	sub.s	$f5, $f0, $f1
	addi	$a0, $zero, 1000
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f2
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f3
	lwc1	$f4, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	iloop.54
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	lw	$a1, 4($sp)
	j	xloop.44
bne_else.115:
	jr	$ra
yloop.40:
	slti	$s0, $a0, 400
	beq	$s0, $zero, bne_else.117
	addi	$a1, $zero, 0
	sw	$a0, 0($sp)
	add	$s6, $zero, $a1
	add	$a1, $zero, $a0
	add	$a0, $zero, $s6
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	xloop.44
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	j	yloop.40
bne_else.117:
	jr	$ra
_min_caml_start:
	lui	$sp, 1
	lui	$gp, 3
	addi	$a0, $zero, 0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	yloop.40
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
