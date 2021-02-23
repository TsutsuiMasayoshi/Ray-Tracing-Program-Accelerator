	flui	$f0, 16403
	fori	$f0, $f0, 13107
	swc1	$f0, 10003($zero)
	flui	$f0, 16281
	fori	$f0, $f0, 39322
	swc1	$f0, 10002($zero)
	flui	$f0, 16256
	fori	$f0, $f0, 0
	swc1	$f0, 10001($zero)
	flui	$f0, 16673
	fori	$f0, $f0, 39322
	swc1	$f0, 10000($zero)
	j	_min_caml_start
min_caml_create_array:
	addi	$s0, $a0, 0
	addi	$a0, $gp, 0
create_array_loop:
	bne	$s0, $zero, create_array_cont
	jr	$ra
create_array_cont:
	sw	$a1, 0($gp)
	addi	$s0, $s0, -1
	addi	$gp, $gp, 1
	j	create_array_loop
min_caml_create_float_array:
	addi	$s0, $a0, 0
	addi	$a0, $gp, 0
create_float_array_loop:
	bne	$s0, $zero, create_float_array_cont
	jr	$ra
create_float_array_cont:
	swc1	$f0, 0($gp)
	addi	$s0, $s0, -1
	addi	$gp, $gp, 1
	j	create_float_array_loop
fib.297:
	lwc1	$f1, 10001($zero)
	c.lt.s	$s0, $f1, $f0
	beq	$s0, $zero, bne_else.823
	lwc1	$f1, 10002($zero)
	sub.s	$f1, $f0, $f1
	swc1	$f0, 0($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 6($sp)
	addi	$sp, $sp, 7
	jal	fib.297
	addi	$sp, $sp, -7
	lw	$ra, 6($sp)
	lwc1	$f1, 10003($zero)
	lwc1	$f2, 0($sp)
	sub.s	$f1, $f2, $f1
	swc1	$f0, 2($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 8($sp)
	addi	$sp, $sp, 9
	jal	fib.297
	addi	$sp, $sp, -9
	lw	$ra, 8($sp)
	lwc1	$f1, 2($sp)
	add.s	$f0, $f1, $f0
	jr	$ra
bne_else.823:
	jr	$ra
_min_caml_start:
	lui	$sp, 1
	lui	$gp, 3
	lwc1	$f0, 10000($zero)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 5
	jal	fib.297
	addi	$sp, $sp, -5
	lw	$ra, 4($sp)
last:
	j	last