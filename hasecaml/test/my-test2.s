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
min_caml_sin:
	lui	$s1, 16576
	mtc1	$s1, $f30
	add.s	$f29, $f0, $fzero
	mul.s	$f29, $f29, $f0
	mul.s	$f29, $f29, $f0
	div.s	$f29, $f29, $f30
	sub.s	$f0, $f0, $f29
	jr	$ra
min_caml_cos:
	lui	$s1, 16256
	mtc1	$s1, $f30
	lui	$s1, 16128
	mtc1	$s1, $f29
	add.s	$f0, $f0, $f0
	mul.s	$f0, $f0, $f29
	sub.s	$f0, $f30, $f0
	jr	$ra
min_caml_atan:
	lui	$s1, 16448
	mtc1	$s1, $f30
	add.s	$f29, $f0, $fzero
	mul.s	$f29, $f29, $f0
	mul.s	$f29, $f29, $f0
	div.s	$f29, $f29, $f30
	sub.s	$f0, $f0, $f29
	jr	$ra
min_caml_abs_float:
	c.lt.s	$s0, $f0, $fzero
	bne	$s0, $zero, minus
	jr	$ra
minus:
	sub.s	$f0, $fzero, $f0
	jr	$ra
_min_caml_start:
	addi	$sp, $sp, 4096
	addi	$gp, $gp, 8192
	addi	$a0, $zero, 1
	addi	$a1, $zero, 0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_create_array
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_create_float_array
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a1, $zero, 60
	addi	$a2, $zero, 0
	addi	$a3, $zero, 0
	addi	$t0, $zero, 0
	addi	$t1, $zero, 0
	addi	$t2, $zero, 0
	add	$t3, $gp, $zero
	addi	$gp, $gp, 48
	sw	$a0, 40($t3)
	sw	$a0, 36($t3)
	sw	$a0, 32($t3)
	sw	$a0, 28($t3)
	sw	$t2, 24($t3)
	sw	$a0, 20($t3)
	sw	$a0, 16($t3)
	sw	$t1, 12($t3)
	sw	$t0, 8($t3)
	sw	$a3, 4($t3)
	sw	$a2, 0($t3)
	add	$a0, $t3, $zero
	add	$s6, $zero, $a1
	add	$a1, $zero, $a0
	add	$a0, $zero, $s6
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_create_array
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_create_float_array
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_create_float_array
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_create_float_array
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 1
	lui	$s1, 17279
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_create_float_array
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 50
	addi	$a1, $zero, 1
	addi	$a2, $zero, -1
	sw	$a0, 0($sp)
	add	$a0, $zero, $a1
	add	$a1, $zero, $a2
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_create_array
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	add	$a1, $a0, $zero
	lw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_create_array
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a1, $zero, 1
	addi	$a2, $zero, 1
	lw	$a0, 0($a0)
	sw	$a1, 4($sp)
	add	$a1, $zero, $a0
	add	$a0, $zero, $a2
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	add	$a1, $a0, $zero
	lw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 1
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 1
	addi	$a1, $zero, 0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 1
	lui	$s1, 20078
	ori	$s1, $s1, 27432
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 1
	addi	$a1, $zero, 0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 2
	addi	$a1, $zero, 0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 2
	addi	$a1, $zero, 0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 1
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	add	$a1, $a0, $zero
	addi	$a0, $zero, 0
	sw	$a1, 8($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a1, $zero, 0
	add	$a2, $gp, $zero
	addi	$gp, $gp, 8
	sw	$a0, 4($a2)
	lw	$a0, 8($sp)
	sw	$a0, 0($a2)
	add	$a0, $a2, $zero
	add	$s6, $zero, $a1
	add	$a1, $zero, $a0
	add	$a0, $zero, $s6
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	add	$a1, $a0, $zero
	addi	$a0, $zero, 5
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a0, $zero, 0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_create_float_array
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$a1, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$a0, 12($sp)
	add	$a0, $zero, $a1
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_create_float_array
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	addi	$a0, $zero, 60
	lw	$a1, 12($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_create_array
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	addi	$a0, $zero, 0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_create_float_array
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	add	$a1, $a0, $zero
	addi	$a0, $zero, 0
	sw	$a1, 16($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_create_array
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	add	$a1, $gp, $zero
	addi	$gp, $gp, 8
	sw	$a0, 4($a1)
	lw	$a0, 16($sp)
	sw	$a0, 0($a1)
	add	$a0, $a1, $zero
	addi	$a1, $zero, 180
	addi	$a2, $zero, 0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	add	$a3, $gp, $zero
	addi	$gp, $gp, 16
	swc1	$f0, 8($a3)
	sw	$a0, 4($a3)
	sw	$a2, 0($a3)
	add	$a0, $a3, $zero
	add	$s6, $zero, $a1
	add	$a1, $zero, $a0
	add	$a0, $zero, $s6
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_create_array
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	addi	$a0, $zero, 1
	addi	$a1, $zero, 0
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_create_array
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	addi	$a0, $zero, 0
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_print
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
