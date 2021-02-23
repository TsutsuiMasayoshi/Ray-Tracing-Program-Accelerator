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
	bne	$s1, $zero, create_flaot_array_cont
	jr	$ra
create_array_cont:
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
xor.1977:
	bne	$a0, $zero, bne_else.5656
	add	$a0, $a1, $zero
	jr	$ra
bne_else.5656:
	bne	$a1, $zero, bne_else.5657
	addi	$a0, $zero, 1
	jr	$ra
bne_else.5657:
	addi	$a0, $zero, 0
	jr	$ra
fsqr.1980:
	mul.s	$f0, $f0, $f0
	jr	$ra
fhalf.1982:
	lui	$s1, 16384
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	div.s	$f0, $f0, $f1
	jr	$ra
o_texturetype.1984:
	lw	$a0, 0($a0)
	jr	$ra
o_form.1986:
	lw	$a0, 4($a0)
	jr	$ra
o_reflectiontype.1988:
	lw	$a0, 8($a0)
	jr	$ra
o_isinvert.1990:
	lw	$a0, 24($a0)
	jr	$ra
o_isrot.1992:
	lw	$a0, 12($a0)
	jr	$ra
o_param_a.1994:
	lw	$a0, 16($a0)
	lwc1	$f0, 0($a0)
	jr	$ra
o_param_b.1996:
	lw	$a0, 16($a0)
	lwc1	$f0, 8($a0)
	jr	$ra
o_param_c.1998:
	lw	$a0, 16($a0)
	lwc1	$f0, 16($a0)
	jr	$ra
o_param_x.2000:
	lw	$a0, 20($a0)
	lwc1	$f0, 0($a0)
	jr	$ra
o_param_y.2002:
	lw	$a0, 20($a0)
	lwc1	$f0, 8($a0)
	jr	$ra
o_param_z.2004:
	lw	$a0, 20($a0)
	lwc1	$f0, 16($a0)
	jr	$ra
o_diffuse.2006:
	lw	$a0, 28($a0)
	lwc1	$f0, 0($a0)
	jr	$ra
o_hilight.2008:
	lw	$a0, 28($a0)
	lwc1	$f0, 8($a0)
	jr	$ra
o_color_red.2010:
	lw	$a0, 32($a0)
	lwc1	$f0, 0($a0)
	jr	$ra
o_color_green.2012:
	lw	$a0, 32($a0)
	lwc1	$f0, 8($a0)
	jr	$ra
o_color_blue.2014:
	lw	$a0, 32($a0)
	lwc1	$f0, 16($a0)
	jr	$ra
o_param_r1.2016:
	lw	$a0, 36($a0)
	lwc1	$f0, 0($a0)
	jr	$ra
o_param_r2.2018:
	lw	$a0, 36($a0)
	lwc1	$f0, 8($a0)
	jr	$ra
o_param_r3.2020:
	lw	$a0, 36($a0)
	lwc1	$f0, 16($a0)
	jr	$ra
normalize_vector.2022:
	lwc1	$f0, 0($a0)
	sw	$a1, 0($sp)
	sw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	fsqr.1980
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lw	$a0, 4($sp)
	lwc1	$f1, 8($a0)
	swc1	$f0, 8($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	fsqr.1980
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	add.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	lwc1	$f1, 16($a0)
	swc1	$f0, 16($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	fsqr.1980
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lwc1	$f1, 16($sp)
	add.s	$f0, $f1, $f0
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_sqrt
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 0($sp)
	bne	$a0, $zero, beq_else.5658
	j	beq_cont.5659
beq_else.5658:
	sub.s	$f0, $fzero, $f0
beq_cont.5659:
	lw	$a0, 4($sp)
	lwc1	$f1, 0($a0)
	div.s	$f1, $f1, $f0
	swc1	$f1, 0($a0)
	lwc1	$f1, 8($a0)
	div.s	$f1, $f1, $f0
	swc1	$f1, 8($a0)
	lwc1	$f1, 16($a0)
	div.s	$f0, $f1, $f0
	swc1	$f0, 16($a0)
	jr	$ra
sgn.2025:
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5661
	lui	$s1, 140737488338816
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	jr	$ra
bne_else.5661:
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	jr	$ra
rad.2027:
	lui	$s1, 15502
	ori	$s1, $s1, 64053
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	jr	$ra
read_environ.2029:
	lahi	$a0, min_caml_screen
	lalo	$a0, min_caml_screen
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_read_float
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lw	$a0, 0($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_screen
	lalo	$a0, min_caml_screen
	sw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_read_float
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lw	$a0, 4($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_screen
	lalo	$a0, min_caml_screen
	sw	$a0, 8($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_read_float
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lw	$a0, 8($sp)
	swc1	$f0, 16($a0)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_read_float
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	rad.2027
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lahi	$a0, min_caml_cos_v
	lalo	$a0, min_caml_cos_v
	swc1	$f0, 16($sp)
	sw	$a0, 24($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_cos
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 24($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_sin_v
	lalo	$a0, min_caml_sin_v
	lwc1	$f0, 16($sp)
	sw	$a0, 28($sp)
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	min_caml_sin
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lw	$a0, 28($sp)
	swc1	$f0, 0($a0)
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	min_caml_read_float
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	rad.2027
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lahi	$a0, min_caml_cos_v
	lalo	$a0, min_caml_cos_v
	swc1	$f0, 32($sp)
	sw	$a0, 40($sp)
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	min_caml_cos
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lw	$a0, 40($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_sin_v
	lalo	$a0, min_caml_sin_v
	lwc1	$f0, 32($sp)
	sw	$a0, 44($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_sin
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a0, 44($sp)
	swc1	$f0, 8($a0)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_read_float
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_read_float
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	rad.2027
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	swc1	$f0, 48($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	min_caml_sin
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lahi	$a0, min_caml_light
	lalo	$a0, min_caml_light
	sub.s	$f0, $fzero, $f0
	swc1	$f0, 8($a0)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	min_caml_read_float
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	rad.2027
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lwc1	$f1, 48($sp)
	swc1	$f0, 56($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	min_caml_cos
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	lwc1	$f1, 56($sp)
	swc1	$f0, 64($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	min_caml_sin
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lahi	$a0, min_caml_light
	lalo	$a0, min_caml_light
	lwc1	$f1, 64($sp)
	mul.s	$f0, $f1, $f0
	swc1	$f0, 0($a0)
	lwc1	$f0, 56($sp)
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	min_caml_cos
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lahi	$a0, min_caml_light
	lalo	$a0, min_caml_light
	lwc1	$f1, 64($sp)
	mul.s	$f0, $f1, $f0
	swc1	$f0, 16($a0)
	lahi	$a0, min_caml_beam
	lalo	$a0, min_caml_beam
	sw	$a0, 72($sp)
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	min_caml_read_float
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lw	$a0, 72($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_vp
	lalo	$a0, min_caml_vp
	lahi	$a1, min_caml_cos_v
	lalo	$a1, min_caml_cos_v
	lwc1	$f0, 0($a1)
	lahi	$a1, min_caml_sin_v
	lalo	$a1, min_caml_sin_v
	lwc1	$f1, 8($a1)
	mul.s	$f0, $f0, $f1
	lui	$s1, 140737488339784
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_vp
	lalo	$a0, min_caml_vp
	lahi	$a1, min_caml_sin_v
	lalo	$a1, min_caml_sin_v
	lwc1	$f0, 0($a1)
	sub.s	$f0, $fzero, $f0
	lui	$s1, 140737488339784
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_vp
	lalo	$a0, min_caml_vp
	lahi	$a1, min_caml_cos_v
	lalo	$a1, min_caml_cos_v
	lwc1	$f0, 0($a1)
	lahi	$a1, min_caml_cos_v
	lalo	$a1, min_caml_cos_v
	lwc1	$f1, 8($a1)
	mul.s	$f0, $f0, $f1
	lui	$s1, 140737488339784
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	swc1	$f0, 16($a0)
	lahi	$a0, min_caml_view
	lalo	$a0, min_caml_view
	lahi	$a1, min_caml_vp
	lalo	$a1, min_caml_vp
	lwc1	$f0, 0($a1)
	lahi	$a1, min_caml_screen
	lalo	$a1, min_caml_screen
	lwc1	$f1, 0($a1)
	add.s	$f0, $f0, $f1
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_view
	lalo	$a0, min_caml_view
	lahi	$a1, min_caml_vp
	lalo	$a1, min_caml_vp
	lwc1	$f0, 8($a1)
	lahi	$a1, min_caml_screen
	lalo	$a1, min_caml_screen
	lwc1	$f1, 8($a1)
	add.s	$f0, $f0, $f1
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_view
	lalo	$a0, min_caml_view
	lahi	$a1, min_caml_vp
	lalo	$a1, min_caml_vp
	lwc1	$f0, 16($a1)
	lahi	$a1, min_caml_screen
	lalo	$a1, min_caml_screen
	lwc1	$f1, 16($a1)
	add.s	$f0, $f0, $f1
	swc1	$f0, 16($a0)
	jr	$ra
read_nth_object.2031:
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_read_int
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$s1, $zero, -1
	bne	$a0, $s1, bne_else.5664
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5664:
	sw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_read_int
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	sw	$a0, 8($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	min_caml_read_int
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	sw	$a0, 12($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_read_int
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	addi	$a1, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$a0, 16($sp)
	add	$a0, $zero, $a1
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_create_float_array
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	sw	$a0, 20($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_read_float
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 20($sp)
	swc1	$f0, 0($a0)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_read_float
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 20($sp)
	swc1	$f0, 8($a0)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_read_float
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 20($sp)
	swc1	$f0, 16($a0)
	addi	$a1, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	add	$a0, $zero, $a1
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_create_float_array
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	sw	$a0, 24($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_read_float
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 24($sp)
	swc1	$f0, 0($a0)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_read_float
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 24($sp)
	swc1	$f0, 8($a0)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_read_float
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 24($sp)
	swc1	$f0, 16($a0)
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 32($sp)
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	min_caml_read_float
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lwc1	$f1, 32($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5666
	addi	$a0, $zero, 0
	j	bne_cont.5667
bne_else.5666:
	addi	$a0, $zero, 1
bne_cont.5667:
	addi	$a1, $zero, 2
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$a0, 40($sp)
	add	$a0, $zero, $a1
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	min_caml_create_float_array
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	sw	$a0, 44($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_read_float
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a0, 44($sp)
	swc1	$f0, 0($a0)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_read_float
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a0, 44($sp)
	swc1	$f0, 8($a0)
	addi	$a1, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	add	$a0, $zero, $a1
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_create_float_array
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	sw	$a0, 48($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_read_float
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a0, 48($sp)
	swc1	$f0, 0($a0)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_read_float
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a0, 48($sp)
	swc1	$f0, 8($a0)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_read_float
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a0, 48($sp)
	swc1	$f0, 16($a0)
	addi	$a1, $zero, 3
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	add	$a0, $zero, $a1
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_create_float_array
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a1, 16($sp)
	bne	$a1, $zero, beq_else.5668
	j	beq_cont.5669
beq_else.5668:
	sw	$a0, 52($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	min_caml_read_float
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	rad.2027
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lw	$a0, 52($sp)
	swc1	$f0, 0($a0)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	min_caml_read_float
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	rad.2027
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lw	$a0, 52($sp)
	swc1	$f0, 8($a0)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	min_caml_read_float
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	rad.2027
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lw	$a0, 52($sp)
	swc1	$f0, 16($a0)
beq_cont.5669:
	lw	$a1, 8($sp)
	addi	$s1, $zero, 2
	bne	$a1, $s1, beq_else.5670
	addi	$a2, $zero, 1
	j	beq_cont.5671
beq_else.5670:
	lw	$a2, 40($sp)
beq_cont.5671:
	add	$a3, $gp, $zero
	addi	$gp, $gp, 40
	sw	$a0, 36($a3)
	lw	$t0, 48($sp)
	sw	$t0, 32($a3)
	lw	$t0, 44($sp)
	sw	$t0, 28($a3)
	sw	$a2, 24($a3)
	lw	$a2, 24($sp)
	sw	$a2, 20($a3)
	lw	$a2, 20($sp)
	sw	$a2, 16($a3)
	lw	$t0, 16($sp)
	sw	$t0, 12($a3)
	lw	$t1, 12($sp)
	sw	$t1, 8($a3)
	sw	$a1, 4($a3)
	lw	$t1, 4($sp)
	sw	$t1, 0($a3)
	lahi	$t1, min_caml_objects
	lalo	$t1, min_caml_objects
	lw	$t2, 0($sp)
	sll	$t2, $t2, 2
	add	$s1, $t1, $a3
	sw	$a3, 0($s1)
	sw	$a0, 52($sp)
	addi	$s1, $zero, 3
	bne	$a1, $s1, beq_else.5672
	lwc1	$f0, 0($a2)
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	fcmpu	$s0, $f1, $f0
	bne	$zero, $s0, beq_else.5674
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	j	beq_cont.5675
beq_else.5674:
	swc1	$f0, 56($sp)
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	sgn.2025
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	lwc1	$f1, 56($sp)
	swc1	$f0, 64($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	fsqr.1980
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lwc1	$f1, 64($sp)
	div.s	$f0, $f1, $f0
beq_cont.5675:
	lw	$a0, 20($sp)
	swc1	$f0, 0($a0)
	lwc1	$f0, 8($a0)
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	fcmpu	$s0, $f1, $f0
	bne	$zero, $s0, beq_else.5676
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	j	beq_cont.5677
beq_else.5676:
	swc1	$f0, 72($sp)
	sw	$ra, 84($sp)
	addi	$sp, $sp, 88
	jal	sgn.2025
	addi	$sp, $sp, -88
	lw	$ra, 84($sp)
	lwc1	$f1, 72($sp)
	swc1	$f0, 80($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 92($sp)
	addi	$sp, $sp, 96
	jal	fsqr.1980
	addi	$sp, $sp, -96
	lw	$ra, 92($sp)
	lwc1	$f1, 80($sp)
	div.s	$f0, $f1, $f0
beq_cont.5677:
	lw	$a0, 20($sp)
	swc1	$f0, 8($a0)
	lwc1	$f0, 16($a0)
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	fcmpu	$s0, $f1, $f0
	bne	$zero, $s0, beq_else.5678
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	j	beq_cont.5679
beq_else.5678:
	swc1	$f0, 88($sp)
	sw	$ra, 100($sp)
	addi	$sp, $sp, 104
	jal	sgn.2025
	addi	$sp, $sp, -104
	lw	$ra, 100($sp)
	lwc1	$f1, 88($sp)
	swc1	$f0, 96($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 108($sp)
	addi	$sp, $sp, 112
	jal	fsqr.1980
	addi	$sp, $sp, -112
	lw	$ra, 108($sp)
	lwc1	$f1, 96($sp)
	div.s	$f0, $f1, $f0
beq_cont.5679:
	lw	$a0, 20($sp)
	swc1	$f0, 16($a0)
	j	beq_cont.5673
beq_else.5672:
	addi	$s1, $zero, 2
	bne	$a1, $s1, beq_else.5680
	lw	$a1, 40($sp)
	bne	$a1, $zero, beq_else.5682
	addi	$a1, $zero, 1
	j	beq_cont.5683
beq_else.5682:
	addi	$a1, $zero, 0
beq_cont.5683:
	add	$a0, $zero, $a2
	sw	$ra, 108($sp)
	addi	$sp, $sp, 112
	jal	normalize_vector.2022
	addi	$sp, $sp, -112
	lw	$ra, 108($sp)
	j	beq_cont.5681
beq_else.5680:
beq_cont.5681:
beq_cont.5673:
	lw	$a0, 16($sp)
	bne	$a0, $zero, beq_else.5684
	j	beq_cont.5685
beq_else.5684:
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lw	$a1, 52($sp)
	lwc1	$f0, 0($a1)
	sw	$a0, 104($sp)
	sw	$ra, 108($sp)
	addi	$sp, $sp, 112
	jal	min_caml_cos
	addi	$sp, $sp, -112
	lw	$ra, 108($sp)
	lw	$a0, 104($sp)
	swc1	$f0, 80($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lw	$a1, 52($sp)
	lwc1	$f0, 0($a1)
	sw	$a0, 108($sp)
	sw	$ra, 116($sp)
	addi	$sp, $sp, 120
	jal	min_caml_sin
	addi	$sp, $sp, -120
	lw	$ra, 116($sp)
	lw	$a0, 108($sp)
	swc1	$f0, 88($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lw	$a1, 52($sp)
	lwc1	$f0, 8($a1)
	sw	$a0, 112($sp)
	sw	$ra, 116($sp)
	addi	$sp, $sp, 120
	jal	min_caml_cos
	addi	$sp, $sp, -120
	lw	$ra, 116($sp)
	lw	$a0, 112($sp)
	swc1	$f0, 96($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lw	$a1, 52($sp)
	lwc1	$f0, 8($a1)
	sw	$a0, 116($sp)
	sw	$ra, 124($sp)
	addi	$sp, $sp, 128
	jal	min_caml_sin
	addi	$sp, $sp, -128
	lw	$ra, 124($sp)
	lw	$a0, 116($sp)
	swc1	$f0, 104($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lw	$a1, 52($sp)
	lwc1	$f0, 16($a1)
	sw	$a0, 120($sp)
	sw	$ra, 124($sp)
	addi	$sp, $sp, 128
	jal	min_caml_cos
	addi	$sp, $sp, -128
	lw	$ra, 124($sp)
	lw	$a0, 120($sp)
	swc1	$f0, 112($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lw	$a1, 52($sp)
	lwc1	$f0, 16($a1)
	sw	$a0, 124($sp)
	sw	$ra, 132($sp)
	addi	$sp, $sp, 136
	jal	min_caml_sin
	addi	$sp, $sp, -136
	lw	$ra, 132($sp)
	lw	$a0, 124($sp)
	swc1	$f0, 120($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 96($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 112($a1)
	mul.s	$f0, $f0, $f1
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 88($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 104($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 112($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 80($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f2, 120($a1)
	mul.s	$f1, $f1, $f2
	sub.s	$f0, $f0, $f1
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 80($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 104($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 112($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 88($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f2, 120($a1)
	mul.s	$f1, $f1, $f2
	add.s	$f0, $f0, $f1
	swc1	$f0, 16($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 96($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 120($a1)
	mul.s	$f0, $f0, $f1
	swc1	$f0, 24($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 88($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 104($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 120($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 80($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f2, 112($a1)
	mul.s	$f1, $f1, $f2
	add.s	$f0, $f0, $f1
	swc1	$f0, 32($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 80($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 104($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 120($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 88($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f2, 112($a1)
	mul.s	$f1, $f1, $f2
	sub.s	$f0, $f0, $f1
	swc1	$f0, 40($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 104($a1)
	sub.s	$f0, $fzero, $f0
	swc1	$f0, 48($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 88($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 96($a1)
	mul.s	$f0, $f0, $f1
	swc1	$f0, 56($a0)
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 80($a1)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f1, 96($a1)
	mul.s	$f0, $f0, $f1
	swc1	$f0, 64($a0)
	lw	$a0, 20($sp)
	lwc1	$f0, 0($a0)
	lwc1	$f1, 8($a0)
	lwc1	$f2, 16($a0)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f3, 0($a1)
	swc1	$f2, 128($sp)
	swc1	$f1, 136($sp)
	swc1	$f0, 144($sp)
	add.s	$f0, $fzero, $f3
	sw	$ra, 156($sp)
	addi	$sp, $sp, 160
	jal	fsqr.1980
	addi	$sp, $sp, -160
	lw	$ra, 156($sp)
	lwc1	$f1, 144($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f2, 24($a0)
	swc1	$f0, 152($sp)
	add.s	$f0, $fzero, $f2
	sw	$ra, 164($sp)
	addi	$sp, $sp, 168
	jal	fsqr.1980
	addi	$sp, $sp, -168
	lw	$ra, 164($sp)
	lwc1	$f1, 136($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f2, 152($sp)
	add.s	$f0, $f2, $f0
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f2, 48($a0)
	swc1	$f0, 160($sp)
	add.s	$f0, $fzero, $f2
	sw	$ra, 172($sp)
	addi	$sp, $sp, 176
	jal	fsqr.1980
	addi	$sp, $sp, -176
	lw	$ra, 172($sp)
	lwc1	$f1, 128($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f2, 160($sp)
	add.s	$f0, $f2, $f0
	lw	$a0, 20($sp)
	swc1	$f0, 0($a0)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 8($a1)
	sw	$ra, 172($sp)
	addi	$sp, $sp, 176
	jal	fsqr.1980
	addi	$sp, $sp, -176
	lw	$ra, 172($sp)
	lwc1	$f1, 144($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f2, 32($a0)
	swc1	$f0, 168($sp)
	add.s	$f0, $fzero, $f2
	sw	$ra, 180($sp)
	addi	$sp, $sp, 184
	jal	fsqr.1980
	addi	$sp, $sp, -184
	lw	$ra, 180($sp)
	lwc1	$f1, 136($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f2, 168($sp)
	add.s	$f0, $f2, $f0
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f2, 56($a0)
	swc1	$f0, 176($sp)
	add.s	$f0, $fzero, $f2
	sw	$ra, 188($sp)
	addi	$sp, $sp, 192
	jal	fsqr.1980
	addi	$sp, $sp, -192
	lw	$ra, 188($sp)
	lwc1	$f1, 128($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f2, 176($sp)
	add.s	$f0, $f2, $f0
	lw	$a0, 20($sp)
	swc1	$f0, 8($a0)
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f0, 16($a1)
	sw	$ra, 188($sp)
	addi	$sp, $sp, 192
	jal	fsqr.1980
	addi	$sp, $sp, -192
	lw	$ra, 188($sp)
	lwc1	$f1, 144($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f2, 40($a0)
	swc1	$f0, 184($sp)
	add.s	$f0, $fzero, $f2
	sw	$ra, 196($sp)
	addi	$sp, $sp, 200
	jal	fsqr.1980
	addi	$sp, $sp, -200
	lw	$ra, 196($sp)
	lwc1	$f1, 136($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f2, 184($sp)
	add.s	$f0, $f2, $f0
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f2, 64($a0)
	swc1	$f0, 192($sp)
	add.s	$f0, $fzero, $f2
	sw	$ra, 204($sp)
	addi	$sp, $sp, 208
	jal	fsqr.1980
	addi	$sp, $sp, -208
	lw	$ra, 204($sp)
	lwc1	$f1, 128($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f2, 192($sp)
	add.s	$f0, $f2, $f0
	lw	$a0, 20($sp)
	swc1	$f0, 16($a0)
	lui	$s1, 16384
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f2, 8($a0)
	lwc1	$f3, 144($sp)
	mul.s	$f2, $f3, $f2
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f4, 16($a0)
	mul.s	$f2, $f2, $f4
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f4, 32($a0)
	lwc1	$f5, 136($sp)
	mul.s	$f4, $f5, $f4
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f6, 40($a0)
	mul.s	$f4, $f4, $f6
	add.s	$f2, $f2, $f4
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f4, 56($a0)
	mul.s	$f4, $f1, $f4
	lahi	$a0, min_caml_cs_temp
	lalo	$a0, min_caml_cs_temp
	lwc1	$f6, 64($a0)
	mul.s	$f4, $f4, $f6
	add.s	$f2, $f2, $f4
	mul.s	$f0, $f0, $f2
	lw	$a0, 52($sp)
	swc1	$f0, 0($a0)
	lui	$s1, 16384
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f2, 0($a1)
	mul.s	$f2, $f3, $f2
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f4, 16($a1)
	mul.s	$f2, $f2, $f4
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f4, 24($a1)
	mul.s	$f4, $f5, $f4
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f6, 40($a1)
	mul.s	$f4, $f4, $f6
	add.s	$f2, $f2, $f4
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f4, 48($a1)
	mul.s	$f4, $f1, $f4
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f6, 64($a1)
	mul.s	$f4, $f4, $f6
	add.s	$f2, $f2, $f4
	mul.s	$f0, $f0, $f2
	swc1	$f0, 8($a0)
	lui	$s1, 16384
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f2, 0($a1)
	mul.s	$f2, $f3, $f2
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f3, 8($a1)
	mul.s	$f2, $f2, $f3
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f3, 24($a1)
	mul.s	$f3, $f5, $f3
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f4, 32($a1)
	mul.s	$f3, $f3, $f4
	add.s	$f2, $f2, $f3
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f3, 48($a1)
	mul.s	$f1, $f1, $f3
	lahi	$a1, min_caml_cs_temp
	lalo	$a1, min_caml_cs_temp
	lwc1	$f3, 56($a1)
	mul.s	$f1, $f1, $f3
	add.s	$f1, $f2, $f1
	mul.s	$f0, $f0, $f1
	swc1	$f0, 16($a0)
beq_cont.5685:
	addi	$a0, $zero, 1
	jr	$ra
read_object.2033:
	slti	$s0, $a0, 61
	beq	$zero, $s0, bne_else.5686
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	read_nth_object.2031
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	bne	$a0, $zero, bne_else.5687
	jr	$ra
bne_else.5687:
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	j	read_object.2033
bne_else.5686:
	jr	$ra
read_all_object.2035:
	addi	$a0, $zero, 0
	j	read_object.2033
read_net_item.2037:
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_read_int
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$s1, $zero, -1
	bne	$a0, $s1, bne_else.5690
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	addi	$a1, $zero, -1
	j	min_caml_create_array
bne_else.5690:
	lw	$a1, 0($sp)
	addi	$a2, $a1, 1
	sw	$a0, 4($sp)
	add	$a0, $zero, $a2
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	read_net_item.2037
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lw	$a1, 0($sp)
	sll	$a1, $a1, 2
	lw	$a2, 4($sp)
	add	$s1, $a0, $a2
	sw	$a2, 0($s1)
	jr	$ra
read_or_network.2039:
	addi	$a1, $zero, 0
	sw	$a0, 0($sp)
	add	$a0, $zero, $a1
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	read_net_item.2037
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	add	$a1, $a0, $zero
	lw	$a0, 0($a1)
	addi	$s1, $zero, -1
	bne	$a0, $s1, bne_else.5691
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	j	min_caml_create_array
bne_else.5691:
	lw	$a0, 0($sp)
	addi	$a2, $a0, 1
	sw	$a1, 4($sp)
	add	$a0, $zero, $a2
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	read_or_network.2039
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lw	$a1, 0($sp)
	sll	$a1, $a1, 2
	lw	$a2, 4($sp)
	add	$s1, $a0, $a2
	sw	$a2, 0($s1)
	jr	$ra
read_and_network.2041:
	addi	$a1, $zero, 0
	sw	$a0, 0($sp)
	add	$a0, $zero, $a1
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	read_net_item.2037
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lw	$a1, 0($a0)
	addi	$s1, $zero, -1
	bne	$a1, $s1, bne_else.5692
	jr	$ra
bne_else.5692:
	lahi	$a1, min_caml_and_net
	lalo	$a1, min_caml_and_net
	lw	$a2, 0($sp)
	sll	$a3, $a2, 2
	add	$s1, $a1, $a0
	sw	$a0, 0($s1)
	addi	$a0, $a2, 1
	j	read_and_network.2041
read_parameter.2043:
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	read_environ.2029
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	read_all_object.2035
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	read_and_network.2041
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_or_net
	lalo	$a0, min_caml_or_net
	addi	$a1, $zero, 0
	sw	$a0, 0($sp)
	add	$a0, $zero, $a1
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	read_or_network.2039
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lw	$a1, 0($sp)
	sw	$a0, 0($a1)
	jr	$ra
solver_rect.2045:
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lwc1	$f1, 0($a1)
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	fcmpu	$s0, $f0, $f1
	bne	$zero, $s0, beq_else.5695
	addi	$a0, $zero, 0
	j	beq_cont.5696
beq_else.5695:
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	o_isinvert.1990
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lw	$a1, 4($sp)
	lwc1	$f1, 0($a1)
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5697
	addi	$a2, $zero, 0
	j	bne_cont.5698
bne_else.5697:
	addi	$a2, $zero, 1
bne_cont.5698:
	add	$a1, $zero, $a2
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	xor.1977
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	bne	$a0, $zero, beq_else.5699
	lw	$a0, 0($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	o_param_a.1994
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	sub.s	$f0, $fzero, $f0
	j	beq_cont.5700
beq_else.5699:
	lw	$a0, 0($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	o_param_a.1994
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
beq_cont.5700:
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 0($a0)
	sub.s	$f0, $f0, $f1
	lw	$a0, 4($sp)
	lwc1	$f1, 0($a0)
	div.s	$f0, $f0, $f1
	lw	$a1, 0($sp)
	swc1	$f0, 8($sp)
	add	$a0, $zero, $a1
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_b.1996
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lw	$a0, 4($sp)
	lwc1	$f1, 8($a0)
	lwc1	$f2, 8($sp)
	mul.s	$f1, $f2, $f1
	lahi	$a1, min_caml_solver_w_vec
	lalo	$a1, min_caml_solver_w_vec
	lwc1	$f3, 8($a1)
	add.s	$f1, $f1, $f3
	swc1	$f0, 16($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_abs_float
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lwc1	$f1, 16($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5701
	addi	$a0, $zero, 0
	j	bne_cont.5702
bne_else.5701:
	lw	$a0, 0($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_param_c.1998
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 4($sp)
	lwc1	$f1, 16($a0)
	lwc1	$f2, 8($sp)
	mul.s	$f1, $f2, $f1
	lahi	$a1, min_caml_solver_w_vec
	lalo	$a1, min_caml_solver_w_vec
	lwc1	$f3, 16($a1)
	add.s	$f1, $f1, $f3
	swc1	$f0, 24($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	min_caml_abs_float
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5703
	addi	$a0, $zero, 0
	j	bne_cont.5704
bne_else.5703:
	lahi	$a0, min_caml_solver_dist
	lalo	$a0, min_caml_solver_dist
	lwc1	$f0, 8($sp)
	swc1	$f0, 0($a0)
	addi	$a0, $zero, 1
bne_cont.5704:
bne_cont.5702:
beq_cont.5696:
	bne	$a0, $zero, bne_else.5705
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lw	$a0, 4($sp)
	lwc1	$f1, 8($a0)
	fcmpu	$s0, $f0, $f1
	bne	$zero, $s0, beq_else.5706
	addi	$a0, $zero, 0
	j	beq_cont.5707
beq_else.5706:
	lw	$a1, 0($sp)
	add	$a0, $zero, $a1
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_isinvert.1990
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lw	$a1, 4($sp)
	lwc1	$f1, 8($a1)
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5708
	addi	$a2, $zero, 0
	j	bne_cont.5709
bne_else.5708:
	addi	$a2, $zero, 1
bne_cont.5709:
	add	$a1, $zero, $a2
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	xor.1977
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	bne	$a0, $zero, beq_else.5710
	lw	$a0, 0($sp)
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_b.1996
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	sub.s	$f0, $fzero, $f0
	j	beq_cont.5711
beq_else.5710:
	lw	$a0, 0($sp)
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_b.1996
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
beq_cont.5711:
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 8($a0)
	sub.s	$f0, $f0, $f1
	lw	$a0, 4($sp)
	lwc1	$f1, 8($a0)
	div.s	$f0, $f0, $f1
	lw	$a1, 0($sp)
	swc1	$f0, 32($sp)
	add	$a0, $zero, $a1
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	o_param_c.1998
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lw	$a0, 4($sp)
	lwc1	$f1, 16($a0)
	lwc1	$f2, 32($sp)
	mul.s	$f1, $f2, $f1
	lahi	$a1, min_caml_solver_w_vec
	lalo	$a1, min_caml_solver_w_vec
	lwc1	$f3, 16($a1)
	add.s	$f1, $f1, $f3
	swc1	$f0, 40($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	min_caml_abs_float
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lwc1	$f1, 40($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5712
	addi	$a0, $zero, 0
	j	bne_cont.5713
bne_else.5712:
	lw	$a0, 0($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	o_param_a.1994
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a0, 4($sp)
	lwc1	$f1, 0($a0)
	lwc1	$f2, 32($sp)
	mul.s	$f1, $f2, $f1
	lahi	$a1, min_caml_solver_w_vec
	lalo	$a1, min_caml_solver_w_vec
	lwc1	$f3, 0($a1)
	add.s	$f1, $f1, $f3
	swc1	$f0, 48($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	min_caml_abs_float
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lwc1	$f1, 48($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5714
	addi	$a0, $zero, 0
	j	bne_cont.5715
bne_else.5714:
	lahi	$a0, min_caml_solver_dist
	lalo	$a0, min_caml_solver_dist
	lwc1	$f0, 32($sp)
	swc1	$f0, 0($a0)
	addi	$a0, $zero, 1
bne_cont.5715:
bne_cont.5713:
beq_cont.5707:
	bne	$a0, $zero, bne_else.5716
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lw	$a0, 4($sp)
	lwc1	$f1, 16($a0)
	fcmpu	$s0, $f0, $f1
	bne	$zero, $s0, beq_else.5717
	addi	$a0, $zero, 0
	j	beq_cont.5718
beq_else.5717:
	lw	$a1, 0($sp)
	add	$a0, $zero, $a1
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_isinvert.1990
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lw	$a1, 4($sp)
	lwc1	$f1, 16($a1)
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5719
	addi	$a2, $zero, 0
	j	bne_cont.5720
bne_else.5719:
	addi	$a2, $zero, 1
bne_cont.5720:
	add	$a1, $zero, $a2
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	xor.1977
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	bne	$a0, $zero, beq_else.5721
	lw	$a0, 0($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_param_c.1998
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	sub.s	$f0, $fzero, $f0
	j	beq_cont.5722
beq_else.5721:
	lw	$a0, 0($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_param_c.1998
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
beq_cont.5722:
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 16($a0)
	sub.s	$f0, $f0, $f1
	lw	$a0, 4($sp)
	lwc1	$f1, 16($a0)
	div.s	$f0, $f0, $f1
	lw	$a1, 0($sp)
	swc1	$f0, 56($sp)
	add	$a0, $zero, $a1
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	o_param_a.1994
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	lw	$a0, 4($sp)
	lwc1	$f1, 0($a0)
	lwc1	$f2, 56($sp)
	mul.s	$f1, $f2, $f1
	lahi	$a1, min_caml_solver_w_vec
	lalo	$a1, min_caml_solver_w_vec
	lwc1	$f3, 0($a1)
	add.s	$f1, $f1, $f3
	swc1	$f0, 64($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	min_caml_abs_float
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lwc1	$f1, 64($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5723
	addi	$a0, $zero, 0
	j	bne_cont.5724
bne_else.5723:
	lw	$a0, 0($sp)
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	o_param_b.1996
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lw	$a0, 4($sp)
	lwc1	$f1, 8($a0)
	lwc1	$f2, 56($sp)
	mul.s	$f1, $f2, $f1
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f3, 8($a0)
	add.s	$f1, $f1, $f3
	swc1	$f0, 72($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 84($sp)
	addi	$sp, $sp, 88
	jal	min_caml_abs_float
	addi	$sp, $sp, -88
	lw	$ra, 84($sp)
	lwc1	$f1, 72($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5725
	addi	$a0, $zero, 0
	j	bne_cont.5726
bne_else.5725:
	lahi	$a0, min_caml_solver_dist
	lalo	$a0, min_caml_solver_dist
	lwc1	$f0, 56($sp)
	swc1	$f0, 0($a0)
	addi	$a0, $zero, 1
bne_cont.5726:
bne_cont.5724:
beq_cont.5718:
	bne	$a0, $zero, bne_else.5727
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5727:
	addi	$a0, $zero, 3
	jr	$ra
bne_else.5716:
	addi	$a0, $zero, 2
	jr	$ra
bne_else.5705:
	addi	$a0, $zero, 1
	jr	$ra
solver_surface.2048:
	lwc1	$f0, 0($a1)
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_a.1994
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	mul.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	lwc1	$f1, 8($a0)
	lw	$a1, 0($sp)
	swc1	$f0, 16($sp)
	swc1	$f1, 24($sp)
	add	$a0, $zero, $a1
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_b.1996
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 16($sp)
	add.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	lwc1	$f1, 16($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 32($sp)
	swc1	$f1, 40($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	o_param_c.1998
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lwc1	$f1, 40($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 32($sp)
	add.s	$f0, $f1, $f0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5728
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5728:
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 0($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 48($sp)
	swc1	$f1, 56($sp)
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	o_param_a.1994
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	lwc1	$f1, 56($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 8($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 64($sp)
	swc1	$f1, 72($sp)
	sw	$ra, 84($sp)
	addi	$sp, $sp, 88
	jal	o_param_b.1996
	addi	$sp, $sp, -88
	lw	$ra, 84($sp)
	lwc1	$f1, 72($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 64($sp)
	add.s	$f0, $f1, $f0
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 16($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 80($sp)
	swc1	$f1, 88($sp)
	sw	$ra, 100($sp)
	addi	$sp, $sp, 104
	jal	o_param_c.1998
	addi	$sp, $sp, -104
	lw	$ra, 100($sp)
	lwc1	$f1, 88($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 80($sp)
	add.s	$f0, $f1, $f0
	lwc1	$f1, 48($sp)
	div.s	$f0, $f0, $f1
	lahi	$a0, min_caml_solver_dist
	lalo	$a0, min_caml_solver_dist
	sub.s	$f0, $fzero, $f0
	swc1	$f0, 0($a0)
	addi	$a0, $zero, 1
	jr	$ra
in_prod_sqr_obj.2051:
	lwc1	$f0, 0($a1)
	sw	$a1, 0($sp)
	sw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	fsqr.1980
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lw	$a0, 4($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_a.1994
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	mul.s	$f0, $f1, $f0
	lw	$a0, 0($sp)
	lwc1	$f1, 8($a0)
	swc1	$f0, 16($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	fsqr.1980
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 4($sp)
	swc1	$f0, 24($sp)
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_b.1996
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 16($sp)
	add.s	$f0, $f1, $f0
	lw	$a0, 0($sp)
	lwc1	$f1, 16($a0)
	swc1	$f0, 32($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	fsqr.1980
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lw	$a0, 4($sp)
	swc1	$f0, 40($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	o_param_c.1998
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lwc1	$f1, 40($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 32($sp)
	add.s	$f0, $f1, $f0
	jr	$ra
in_prod_co_objrot.2054:
	lwc1	$f0, 8($a1)
	lwc1	$f1, 16($a1)
	mul.s	$f0, $f0, $f1
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_r1.2016
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	mul.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	lwc1	$f1, 0($a0)
	lwc1	$f2, 16($a0)
	mul.s	$f1, $f1, $f2
	lw	$a1, 0($sp)
	swc1	$f0, 16($sp)
	swc1	$f1, 24($sp)
	add	$a0, $zero, $a1
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_r2.2018
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 16($sp)
	add.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	lwc1	$f1, 0($a0)
	lwc1	$f2, 8($a0)
	mul.s	$f1, $f1, $f2
	lw	$a0, 0($sp)
	swc1	$f0, 32($sp)
	swc1	$f1, 40($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	o_param_r3.2020
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lwc1	$f1, 40($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 32($sp)
	add.s	$f0, $f1, $f0
	jr	$ra
solver2nd_mul_b.2057:
	lahi	$a2, min_caml_solver_w_vec
	lalo	$a2, min_caml_solver_w_vec
	lwc1	$f0, 0($a2)
	lwc1	$f1, 0($a1)
	mul.s	$f0, $f0, $f1
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_a.1994
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 8($a0)
	lw	$a0, 4($sp)
	lwc1	$f2, 8($a0)
	mul.s	$f1, $f1, $f2
	lw	$a1, 0($sp)
	swc1	$f0, 16($sp)
	swc1	$f1, 24($sp)
	add	$a0, $zero, $a1
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_b.1996
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 16($sp)
	add.s	$f0, $f1, $f0
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 16($a0)
	lw	$a0, 4($sp)
	lwc1	$f2, 16($a0)
	mul.s	$f1, $f1, $f2
	lw	$a0, 0($sp)
	swc1	$f0, 32($sp)
	swc1	$f1, 40($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	o_param_c.1998
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lwc1	$f1, 40($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 32($sp)
	add.s	$f0, $f1, $f0
	jr	$ra
solver2nd_rot_b.2060:
	lahi	$a2, min_caml_solver_w_vec
	lalo	$a2, min_caml_solver_w_vec
	lwc1	$f0, 16($a2)
	lwc1	$f1, 8($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a2, min_caml_solver_w_vec
	lalo	$a2, min_caml_solver_w_vec
	lwc1	$f1, 8($a2)
	lwc1	$f2, 16($a1)
	mul.s	$f1, $f1, $f2
	add.s	$f0, $f0, $f1
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_r1.2016
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 0($a0)
	lw	$a0, 4($sp)
	lwc1	$f2, 16($a0)
	mul.s	$f1, $f1, $f2
	lahi	$a1, min_caml_solver_w_vec
	lalo	$a1, min_caml_solver_w_vec
	lwc1	$f2, 16($a1)
	lwc1	$f3, 0($a0)
	mul.s	$f2, $f2, $f3
	add.s	$f1, $f1, $f2
	lw	$a1, 0($sp)
	swc1	$f0, 16($sp)
	swc1	$f1, 24($sp)
	add	$a0, $zero, $a1
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_r2.2018
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 16($sp)
	add.s	$f0, $f1, $f0
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lwc1	$f1, 0($a0)
	lw	$a0, 4($sp)
	lwc1	$f2, 8($a0)
	mul.s	$f1, $f1, $f2
	lahi	$a1, min_caml_solver_w_vec
	lalo	$a1, min_caml_solver_w_vec
	lwc1	$f2, 8($a1)
	lwc1	$f3, 0($a0)
	mul.s	$f2, $f2, $f3
	add.s	$f1, $f1, $f2
	lw	$a0, 0($sp)
	swc1	$f0, 32($sp)
	swc1	$f1, 40($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	o_param_r3.2020
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lwc1	$f1, 40($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 32($sp)
	add.s	$f0, $f1, $f0
	jr	$ra
solver_second.2063:
	sw	$a1, 0($sp)
	sw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	in_prod_sqr_obj.2051
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lw	$a0, 4($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_isrot.1992
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	bne	$a0, $zero, beq_else.5729
	lwc1	$f0, 8($sp)
	j	beq_cont.5730
beq_else.5729:
	lw	$a0, 4($sp)
	lw	$a1, 0($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	in_prod_co_objrot.2054
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	add.s	$f0, $f1, $f0
beq_cont.5730:
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	fcmpu	$s0, $f1, $f0
	bne	$zero, $s0, beq_else.5731
	addi	$a0, $zero, 0
	jr	$ra
beq_else.5731:
	lui	$s1, 16384
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	lw	$a0, 4($sp)
	lw	$a1, 0($sp)
	swc1	$f0, 16($sp)
	swc1	$f1, 24($sp)
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	solver2nd_mul_b.2057
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	mul.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	swc1	$f0, 32($sp)
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	o_isrot.1992
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	bne	$a0, $zero, beq_else.5732
	lwc1	$f0, 32($sp)
	j	beq_cont.5733
beq_else.5732:
	lw	$a0, 4($sp)
	lw	$a1, 0($sp)
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	solver2nd_rot_b.2060
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lwc1	$f1, 32($sp)
	add.s	$f0, $f1, $f0
beq_cont.5733:
	lahi	$a1, min_caml_solver_w_vec
	lalo	$a1, min_caml_solver_w_vec
	lw	$a0, 4($sp)
	swc1	$f0, 40($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	in_prod_sqr_obj.2051
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a0, 4($sp)
	swc1	$f0, 48($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_isrot.1992
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	bne	$a0, $zero, beq_else.5734
	lwc1	$f0, 48($sp)
	j	beq_cont.5735
beq_else.5734:
	lahi	$a1, min_caml_solver_w_vec
	lalo	$a1, min_caml_solver_w_vec
	lw	$a0, 4($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	in_prod_co_objrot.2054
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lwc1	$f1, 48($sp)
	add.s	$f0, $f1, $f0
beq_cont.5735:
	lw	$a0, 4($sp)
	swc1	$f0, 56($sp)
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	o_form.1986
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	addi	$s1, $zero, 3
	bne	$a0, $s1, beq_else.5736
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lwc1	$f1, 56($sp)
	sub.s	$f0, $f1, $f0
	j	beq_cont.5737
beq_else.5736:
	lwc1	$f0, 56($sp)
beq_cont.5737:
	lui	$s1, 16512
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	lwc1	$f2, 16($sp)
	mul.s	$f1, $f1, $f2
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 40($sp)
	swc1	$f0, 64($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	fsqr.1980
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lwc1	$f1, 64($sp)
	sub.s	$f0, $f0, $f1
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5738
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5738:
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	min_caml_sqrt
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lw	$a0, 4($sp)
	swc1	$f0, 72($sp)
	sw	$ra, 84($sp)
	addi	$sp, $sp, 88
	jal	o_isinvert.1990
	addi	$sp, $sp, -88
	lw	$ra, 84($sp)
	bne	$a0, $zero, beq_else.5739
	lwc1	$f0, 72($sp)
	sub.s	$f0, $fzero, $f0
	j	beq_cont.5740
beq_else.5739:
	lwc1	$f0, 72($sp)
beq_cont.5740:
	lahi	$a0, min_caml_solver_dist
	lalo	$a0, min_caml_solver_dist
	lwc1	$f1, 40($sp)
	sub.s	$f0, $f0, $f1
	lui	$s1, 16384
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	div.s	$f0, $f0, $f1
	lwc1	$f1, 16($sp)
	div.s	$f0, $f0, $f1
	swc1	$f0, 0($a0)
	addi	$a0, $zero, 1
	jr	$ra
solver.2066:
	lahi	$a3, min_caml_objects
	lalo	$a3, min_caml_objects
	sll	$a0, $a0, 2
	add	$s1, $a3, $a0
	lw	$a0, 0($s1)
	lahi	$a3, min_caml_solver_w_vec
	lalo	$a3, min_caml_solver_w_vec
	lwc1	$f0, 0($a2)
	sw	$a1, 0($sp)
	sw	$a0, 4($sp)
	sw	$a2, 8($sp)
	sw	$a3, 12($sp)
	swc1	$f0, 16($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_param_x.2000
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lwc1	$f1, 16($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 12($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lw	$a1, 8($sp)
	lwc1	$f0, 8($a1)
	lw	$a2, 4($sp)
	sw	$a0, 24($sp)
	swc1	$f0, 32($sp)
	add	$a0, $zero, $a2
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	o_param_y.2002
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lwc1	$f1, 32($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 24($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_solver_w_vec
	lalo	$a0, min_caml_solver_w_vec
	lw	$a1, 8($sp)
	lwc1	$f0, 16($a1)
	lw	$a1, 4($sp)
	sw	$a0, 40($sp)
	swc1	$f0, 48($sp)
	add	$a0, $zero, $a1
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_param_z.2004
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lwc1	$f1, 48($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 40($sp)
	swc1	$f0, 16($a0)
	lw	$a0, 4($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_form.1986
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	addi	$s1, $zero, 1
	bne	$a0, $s1, bne_else.5743
	lw	$a0, 4($sp)
	lw	$a1, 0($sp)
	j	solver_rect.2045
bne_else.5743:
	addi	$s1, $zero, 2
	bne	$a0, $s1, bne_else.5744
	lw	$a0, 4($sp)
	lw	$a1, 0($sp)
	j	solver_surface.2048
bne_else.5744:
	lw	$a0, 4($sp)
	lw	$a1, 0($sp)
	j	solver_second.2063
is_rect_outside.2070:
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	o_param_a.1994
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_isoutside_q
	lalo	$a0, min_caml_isoutside_q
	lwc1	$f1, 0($a0)
	swc1	$f0, 8($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_abs_float
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5746
	addi	$a0, $zero, 0
	j	bne_cont.5747
bne_else.5746:
	lw	$a0, 0($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_b.1996
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lahi	$a0, min_caml_isoutside_q
	lalo	$a0, min_caml_isoutside_q
	lwc1	$f1, 8($a0)
	swc1	$f0, 16($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	min_caml_abs_float
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lwc1	$f1, 16($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5748
	addi	$a0, $zero, 0
	j	bne_cont.5749
bne_else.5748:
	lw	$a0, 0($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_param_c.1998
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lahi	$a0, min_caml_isoutside_q
	lalo	$a0, min_caml_isoutside_q
	lwc1	$f1, 16($a0)
	swc1	$f0, 24($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	min_caml_abs_float
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5750
	addi	$a0, $zero, 0
	j	bne_cont.5751
bne_else.5750:
	addi	$a0, $zero, 1
bne_cont.5751:
bne_cont.5749:
bne_cont.5747:
	bne	$a0, $zero, bne_else.5752
	lw	$a0, 0($sp)
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_isinvert.1990
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	bne	$a0, $zero, bne_else.5753
	addi	$a0, $zero, 1
	jr	$ra
bne_else.5753:
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5752:
	lw	$a0, 0($sp)
	j	o_isinvert.1990
is_plane_outside.2072:
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	o_param_a.1994
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_isoutside_q
	lalo	$a0, min_caml_isoutside_q
	lwc1	$f1, 0($a0)
	mul.s	$f0, $f0, $f1
	lw	$a0, 0($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_b.1996
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lahi	$a0, min_caml_isoutside_q
	lalo	$a0, min_caml_isoutside_q
	lwc1	$f1, 8($a0)
	mul.s	$f0, $f0, $f1
	lwc1	$f1, 8($sp)
	add.s	$f0, $f1, $f0
	lw	$a0, 0($sp)
	swc1	$f0, 16($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_param_c.1998
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lahi	$a0, min_caml_isoutside_q
	lalo	$a0, min_caml_isoutside_q
	lwc1	$f1, 16($a0)
	mul.s	$f0, $f0, $f1
	lwc1	$f1, 16($sp)
	add.s	$f0, $f1, $f0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5755
	addi	$a0, $zero, 0
	j	bne_cont.5756
bne_else.5755:
	addi	$a0, $zero, 1
bne_cont.5756:
	lw	$a1, 0($sp)
	sw	$a0, 24($sp)
	add	$a0, $zero, $a1
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_isinvert.1990
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a1, 24($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	xor.1977
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	bne	$a0, $zero, bne_else.5757
	addi	$a0, $zero, 1
	jr	$ra
bne_else.5757:
	addi	$a0, $zero, 0
	jr	$ra
is_second_outside.2074:
	lahi	$a1, min_caml_isoutside_q
	lalo	$a1, min_caml_isoutside_q
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	in_prod_sqr_obj.2051
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lw	$a0, 0($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_form.1986
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	addi	$s1, $zero, 3
	bne	$a0, $s1, beq_else.5759
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lwc1	$f1, 8($sp)
	sub.s	$f0, $f1, $f0
	j	beq_cont.5760
beq_else.5759:
	lwc1	$f0, 8($sp)
beq_cont.5760:
	lw	$a0, 0($sp)
	swc1	$f0, 16($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_isrot.1992
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	bne	$a0, $zero, beq_else.5761
	lwc1	$f0, 16($sp)
	j	beq_cont.5762
beq_else.5761:
	lahi	$a1, min_caml_isoutside_q
	lalo	$a1, min_caml_isoutside_q
	lw	$a0, 0($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	in_prod_co_objrot.2054
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lwc1	$f1, 16($sp)
	add.s	$f0, $f1, $f0
beq_cont.5762:
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5763
	addi	$a0, $zero, 0
	j	bne_cont.5764
bne_else.5763:
	addi	$a0, $zero, 1
bne_cont.5764:
	lw	$a1, 0($sp)
	sw	$a0, 24($sp)
	add	$a0, $zero, $a1
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_isinvert.1990
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a1, 24($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	xor.1977
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	bne	$a0, $zero, bne_else.5765
	addi	$a0, $zero, 1
	jr	$ra
bne_else.5765:
	addi	$a0, $zero, 0
	jr	$ra
is_outside.2076:
	lahi	$a1, min_caml_isoutside_q
	lalo	$a1, min_caml_isoutside_q
	lahi	$a2, min_caml_chkinside_p
	lalo	$a2, min_caml_chkinside_p
	lwc1	$f0, 0($a2)
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_x.2000
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_isoutside_q
	lalo	$a0, min_caml_isoutside_q
	lahi	$a1, min_caml_chkinside_p
	lalo	$a1, min_caml_chkinside_p
	lwc1	$f0, 8($a1)
	lw	$a1, 0($sp)
	sw	$a0, 16($sp)
	swc1	$f0, 24($sp)
	add	$a0, $zero, $a1
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_y.2002
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 16($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_isoutside_q
	lalo	$a0, min_caml_isoutside_q
	lahi	$a1, min_caml_chkinside_p
	lalo	$a1, min_caml_chkinside_p
	lwc1	$f0, 16($a1)
	lw	$a1, 0($sp)
	sw	$a0, 32($sp)
	swc1	$f0, 40($sp)
	add	$a0, $zero, $a1
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	o_param_z.2004
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lwc1	$f1, 40($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 32($sp)
	swc1	$f0, 16($a0)
	lw	$a0, 0($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	o_form.1986
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	addi	$s1, $zero, 1
	bne	$a0, $s1, bne_else.5768
	lw	$a0, 0($sp)
	j	is_rect_outside.2070
bne_else.5768:
	addi	$s1, $zero, 2
	bne	$a0, $s1, bne_else.5769
	lw	$a0, 0($sp)
	j	is_plane_outside.2072
bne_else.5769:
	lw	$a0, 0($sp)
	j	is_second_outside.2074
check_all_inside.2078:
	sll	$a2, $a0, 2
	add	$s1, $a1, $a2
	lw	$a2, 0($s1)
	addi	$s1, $zero, -1
	bne	$a2, $s1, bne_else.5770
	addi	$a0, $zero, 1
	jr	$ra
bne_else.5770:
	lahi	$a3, min_caml_objects
	lalo	$a3, min_caml_objects
	sll	$a2, $a2, 2
	add	$s1, $a3, $a2
	lw	$a2, 0($s1)
	sw	$a1, 0($sp)
	sw	$a0, 4($sp)
	add	$a0, $zero, $a2
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	is_outside.2076
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	bne	$a0, $zero, bne_else.5771
	lw	$a0, 4($sp)
	addi	$a0, $a0, 1
	lw	$a1, 0($sp)
	j	check_all_inside.2078
bne_else.5771:
	addi	$a0, $zero, 0
	jr	$ra
shadow_check_and_group.2081:
	sll	$a3, $a0, 2
	add	$s1, $a1, $a3
	lw	$a3, 0($s1)
	addi	$s1, $zero, -1
	bne	$a3, $s1, bne_else.5772
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5772:
	sll	$a3, $a0, 2
	add	$s1, $a1, $a3
	lw	$a3, 0($s1)
	lahi	$t0, min_caml_light
	lalo	$t0, min_caml_light
	sw	$a2, 0($sp)
	sw	$a1, 4($sp)
	sw	$a0, 8($sp)
	sw	$a3, 12($sp)
	add	$a1, $zero, $t0
	add	$a0, $zero, $a3
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	solver.2066
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lahi	$a1, min_caml_solver_dist
	lalo	$a1, min_caml_solver_dist
	lwc1	$f0, 0($a1)
	bne	$a0, $zero, beq_else.5773
	addi	$a0, $zero, 0
	j	beq_cont.5774
beq_else.5773:
	lui	$s1, 140737488338508
	ori	$s1, $s1, 52429
	mtc1	$s1, $f1
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5775
	addi	$a0, $zero, 0
	j	bne_cont.5776
bne_else.5775:
	addi	$a0, $zero, 1
bne_cont.5776:
beq_cont.5774:
	bne	$a0, $zero, bne_else.5777
	lahi	$a0, min_caml_objects
	lalo	$a0, min_caml_objects
	lw	$a1, 12($sp)
	sll	$a1, $a1, 2
	add	$s1, $a0, $a0
	lw	$a0, 0($s1)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_isinvert.1990
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	bne	$a0, $zero, bne_else.5778
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5778:
	lw	$a0, 8($sp)
	addi	$a0, $a0, 1
	lw	$a1, 4($sp)
	lw	$a2, 0($sp)
	j	shadow_check_and_group.2081
bne_else.5777:
	lui	$s1, 15395
	ori	$s1, $s1, 55050
	mtc1	$s1, $f1
	add.s	$f0, $f0, $f1
	lahi	$a0, min_caml_chkinside_p
	lalo	$a0, min_caml_chkinside_p
	lahi	$a1, min_caml_light
	lalo	$a1, min_caml_light
	lwc1	$f1, 0($a1)
	mul.s	$f1, $f1, $f0
	lw	$a1, 0($sp)
	lwc1	$f2, 0($a1)
	add.s	$f1, $f1, $f2
	swc1	$f1, 0($a0)
	lahi	$a0, min_caml_chkinside_p
	lalo	$a0, min_caml_chkinside_p
	lahi	$a2, min_caml_light
	lalo	$a2, min_caml_light
	lwc1	$f1, 8($a2)
	mul.s	$f1, $f1, $f0
	lwc1	$f2, 8($a1)
	add.s	$f1, $f1, $f2
	swc1	$f1, 8($a0)
	lahi	$a0, min_caml_chkinside_p
	lalo	$a0, min_caml_chkinside_p
	lahi	$a2, min_caml_light
	lalo	$a2, min_caml_light
	lwc1	$f1, 16($a2)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 16($a1)
	add.s	$f0, $f0, $f1
	swc1	$f0, 16($a0)
	addi	$a0, $zero, 0
	lw	$a2, 4($sp)
	add	$a1, $zero, $a2
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	check_all_inside.2078
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	bne	$a0, $zero, bne_else.5779
	lw	$a0, 8($sp)
	addi	$a0, $a0, 1
	lw	$a1, 4($sp)
	lw	$a2, 0($sp)
	j	shadow_check_and_group.2081
bne_else.5779:
	addi	$a0, $zero, 1
	jr	$ra
shadow_check_one_or_group.2085:
	sll	$a3, $a0, 2
	add	$s1, $a1, $a3
	lw	$a3, 0($s1)
	addi	$s1, $zero, -1
	bne	$a3, $s1, bne_else.5780
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5780:
	lahi	$t0, min_caml_and_net
	lalo	$t0, min_caml_and_net
	sll	$a3, $a3, 2
	add	$s1, $t0, $a3
	lw	$a3, 0($s1)
	addi	$t0, $zero, 0
	sw	$a2, 0($sp)
	sw	$a1, 4($sp)
	sw	$a0, 8($sp)
	add	$a1, $zero, $a3
	add	$a0, $zero, $t0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	shadow_check_and_group.2081
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	bne	$a0, $zero, bne_else.5781
	lw	$a0, 8($sp)
	addi	$a0, $a0, 1
	lw	$a1, 4($sp)
	lw	$a2, 0($sp)
	j	shadow_check_one_or_group.2085
bne_else.5781:
	addi	$a0, $zero, 1
	jr	$ra
shadow_check_one_or_matrix.2089:
	sll	$a3, $a0, 2
	add	$s1, $a1, $a3
	lw	$a3, 0($s1)
	lw	$t0, 0($a3)
	addi	$s1, $zero, -1
	bne	$t0, $s1, bne_else.5782
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5782:
	addi	$s1, $zero, 99
	bne	$t0, $s1, bne_else.5783
	addi	$t0, $zero, 1
	sw	$a2, 0($sp)
	sw	$a1, 4($sp)
	sw	$a0, 8($sp)
	add	$a1, $zero, $a3
	add	$a0, $zero, $t0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	shadow_check_one_or_group.2085
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	bne	$a0, $zero, bne_else.5784
	lw	$a0, 8($sp)
	addi	$a0, $a0, 1
	lw	$a1, 4($sp)
	lw	$a2, 0($sp)
	j	shadow_check_one_or_matrix.2089
bne_else.5784:
	addi	$a0, $zero, 1
	jr	$ra
bne_else.5783:
	lahi	$t1, min_caml_light
	lalo	$t1, min_caml_light
	sw	$a3, 12($sp)
	sw	$a2, 0($sp)
	sw	$a1, 4($sp)
	sw	$a0, 8($sp)
	add	$a1, $zero, $t1
	add	$a0, $zero, $t0
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	solver.2066
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	bne	$a0, $zero, bne_else.5785
	lw	$a0, 8($sp)
	addi	$a0, $a0, 1
	lw	$a1, 4($sp)
	lw	$a2, 0($sp)
	j	shadow_check_one_or_matrix.2089
bne_else.5785:
	lui	$s1, 140737488338380
	ori	$s1, $s1, 52429
	mtc1	$s1, $f0
	lahi	$a0, min_caml_solver_dist
	lalo	$a0, min_caml_solver_dist
	lwc1	$f1, 0($a0)
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5786
	lw	$a0, 8($sp)
	addi	$a0, $a0, 1
	lw	$a1, 4($sp)
	lw	$a2, 0($sp)
	j	shadow_check_one_or_matrix.2089
bne_else.5786:
	addi	$a0, $zero, 1
	lw	$a1, 12($sp)
	lw	$a2, 0($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	shadow_check_one_or_group.2085
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	bne	$a0, $zero, bne_else.5787
	lw	$a0, 8($sp)
	addi	$a0, $a0, 1
	lw	$a1, 4($sp)
	lw	$a2, 0($sp)
	j	shadow_check_one_or_matrix.2089
bne_else.5787:
	addi	$a0, $zero, 1
	jr	$ra
solve_each_element.2093:
	sll	$a2, $a0, 2
	add	$s1, $a1, $a2
	lw	$a2, 0($s1)
	addi	$s1, $zero, -1
	bne	$a2, $s1, bne_else.5788
	jr	$ra
bne_else.5788:
	lahi	$a3, min_caml_vscan
	lalo	$a3, min_caml_vscan
	lahi	$t0, min_caml_viewpoint
	lalo	$t0, min_caml_viewpoint
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	add	$a1, $zero, $a3
	add	$a0, $zero, $a2
	add	$a2, $zero, $t0
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	solver.2066
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	bne	$a0, $zero, beq_else.5790
	lahi	$a0, min_caml_objects
	lalo	$a0, min_caml_objects
	lw	$a1, 8($sp)
	sll	$a1, $a1, 2
	add	$s1, $a0, $a0
	lw	$a0, 0($s1)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	o_isinvert.1990
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	bne	$a0, $zero, beq_else.5792
	lahi	$a0, min_caml_end_flag
	lalo	$a0, min_caml_end_flag
	addi	$a1, $zero, 1
	sw	$a1, 0($a0)
	j	beq_cont.5793
beq_else.5792:
beq_cont.5793:
	j	beq_cont.5791
beq_else.5790:
	lahi	$a1, min_caml_solver_dist
	lalo	$a1, min_caml_solver_dist
	lwc1	$f0, 0($a1)
	lui	$s1, 140737488338380
	ori	$s1, $s1, 52429
	mtc1	$s1, $f1
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5794
	j	bne_cont.5795
bne_else.5794:
	lahi	$a1, min_caml_tmin
	lalo	$a1, min_caml_tmin
	lwc1	$f1, 0($a1)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5796
	j	bne_cont.5797
bne_else.5796:
	lui	$s1, 15395
	ori	$s1, $s1, 55050
	mtc1	$s1, $f1
	add.s	$f0, $f0, $f1
	lahi	$a1, min_caml_chkinside_p
	lalo	$a1, min_caml_chkinside_p
	lahi	$a2, min_caml_vscan
	lalo	$a2, min_caml_vscan
	lwc1	$f1, 0($a2)
	mul.s	$f1, $f1, $f0
	lahi	$a2, min_caml_viewpoint
	lalo	$a2, min_caml_viewpoint
	lwc1	$f2, 0($a2)
	add.s	$f1, $f1, $f2
	swc1	$f1, 0($a1)
	lahi	$a1, min_caml_chkinside_p
	lalo	$a1, min_caml_chkinside_p
	lahi	$a2, min_caml_vscan
	lalo	$a2, min_caml_vscan
	lwc1	$f1, 8($a2)
	mul.s	$f1, $f1, $f0
	lahi	$a2, min_caml_viewpoint
	lalo	$a2, min_caml_viewpoint
	lwc1	$f2, 8($a2)
	add.s	$f1, $f1, $f2
	swc1	$f1, 8($a1)
	lahi	$a1, min_caml_chkinside_p
	lalo	$a1, min_caml_chkinside_p
	lahi	$a2, min_caml_vscan
	lalo	$a2, min_caml_vscan
	lwc1	$f1, 16($a2)
	mul.s	$f1, $f1, $f0
	lahi	$a2, min_caml_viewpoint
	lalo	$a2, min_caml_viewpoint
	lwc1	$f2, 16($a2)
	add.s	$f1, $f1, $f2
	swc1	$f1, 16($a1)
	addi	$a1, $zero, 0
	lw	$a2, 4($sp)
	sw	$a0, 12($sp)
	swc1	$f0, 16($sp)
	add	$a0, $zero, $a1
	add	$a1, $zero, $a2
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	check_all_inside.2078
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	bne	$a0, $zero, beq_else.5798
	j	beq_cont.5799
beq_else.5798:
	lahi	$a0, min_caml_tmin
	lalo	$a0, min_caml_tmin
	lwc1	$f0, 16($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_crashed_point
	lalo	$a0, min_caml_crashed_point
	lahi	$a1, min_caml_chkinside_p
	lalo	$a1, min_caml_chkinside_p
	lwc1	$f0, 0($a1)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_crashed_point
	lalo	$a0, min_caml_crashed_point
	lahi	$a1, min_caml_chkinside_p
	lalo	$a1, min_caml_chkinside_p
	lwc1	$f0, 8($a1)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_crashed_point
	lalo	$a0, min_caml_crashed_point
	lahi	$a1, min_caml_chkinside_p
	lalo	$a1, min_caml_chkinside_p
	lwc1	$f0, 16($a1)
	swc1	$f0, 16($a0)
	lahi	$a0, min_caml_intsec_rectside
	lalo	$a0, min_caml_intsec_rectside
	lw	$a1, 12($sp)
	sw	$a1, 0($a0)
	lahi	$a0, min_caml_crashed_object
	lalo	$a0, min_caml_crashed_object
	lw	$a1, 8($sp)
	sw	$a1, 0($a0)
beq_cont.5799:
bne_cont.5797:
bne_cont.5795:
beq_cont.5791:
	lahi	$a0, min_caml_end_flag
	lalo	$a0, min_caml_end_flag
	lw	$a0, 0($a0)
	bne	$a0, $zero, bne_else.5800
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	lw	$a1, 4($sp)
	j	solve_each_element.2093
bne_else.5800:
	jr	$ra
solve_one_or_network.2096:
	sll	$a2, $a0, 2
	add	$s1, $a1, $a2
	lw	$a2, 0($s1)
	addi	$s1, $zero, -1
	bne	$a2, $s1, bne_else.5802
	jr	$ra
bne_else.5802:
	lahi	$a3, min_caml_and_net
	lalo	$a3, min_caml_and_net
	sll	$a2, $a2, 2
	add	$s1, $a3, $a2
	lw	$a2, 0($s1)
	lahi	$a3, min_caml_end_flag
	lalo	$a3, min_caml_end_flag
	addi	$t0, $zero, 0
	sw	$t0, 0($a3)
	addi	$a3, $zero, 0
	sw	$a1, 0($sp)
	sw	$a0, 4($sp)
	add	$a1, $zero, $a2
	add	$a0, $zero, $a3
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	solve_each_element.2093
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lw	$a0, 4($sp)
	addi	$a0, $a0, 1
	lw	$a1, 0($sp)
	j	solve_one_or_network.2096
trace_or_matrix.2099:
	sll	$a2, $a0, 2
	add	$s1, $a1, $a2
	lw	$a2, 0($s1)
	lw	$a3, 0($a2)
	addi	$s1, $zero, -1
	bne	$a3, $s1, bne_else.5804
	jr	$ra
bne_else.5804:
	sw	$a1, 0($sp)
	sw	$a0, 4($sp)
	addi	$s1, $zero, 99
	bne	$a3, $s1, beq_else.5806
	addi	$a3, $zero, 1
	add	$a1, $zero, $a2
	add	$a0, $zero, $a3
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	solve_one_or_network.2096
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	j	beq_cont.5807
beq_else.5806:
	lahi	$t0, min_caml_vscan
	lalo	$t0, min_caml_vscan
	lahi	$t1, min_caml_viewpoint
	lalo	$t1, min_caml_viewpoint
	sw	$a2, 8($sp)
	add	$a2, $zero, $t1
	add	$a1, $zero, $t0
	add	$a0, $zero, $a3
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	solver.2066
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	bne	$a0, $zero, beq_else.5808
	j	beq_cont.5809
beq_else.5808:
	lahi	$a0, min_caml_solver_dist
	lalo	$a0, min_caml_solver_dist
	lwc1	$f0, 0($a0)
	lahi	$a0, min_caml_tmin
	lalo	$a0, min_caml_tmin
	lwc1	$f1, 0($a0)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5810
	j	bne_cont.5811
bne_else.5810:
	addi	$a0, $zero, 1
	lw	$a1, 8($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	solve_one_or_network.2096
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
bne_cont.5811:
beq_cont.5809:
beq_cont.5807:
	lw	$a0, 4($sp)
	addi	$a0, $a0, 1
	lw	$a1, 0($sp)
	j	trace_or_matrix.2099
tracer.2102:
	lahi	$a0, min_caml_tmin
	lalo	$a0, min_caml_tmin
	lui	$s1, 20078
	ori	$s1, $s1, 27432
	mtc1	$s1, $f0
	swc1	$f0, 0($a0)
	addi	$a0, $zero, 0
	lahi	$a1, min_caml_or_net
	lalo	$a1, min_caml_or_net
	lw	$a1, 0($a1)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	trace_or_matrix.2099
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_tmin
	lalo	$a0, min_caml_tmin
	lwc1	$f0, 0($a0)
	lui	$s1, 140737488338380
	ori	$s1, $s1, 52429
	mtc1	$s1, $f1
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5812
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5812:
	lui	$s1, 19646
	ori	$s1, $s1, 48160
	mtc1	$s1, $f1
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5813
	addi	$a0, $zero, 0
	jr	$ra
bne_else.5813:
	addi	$a0, $zero, 1
	jr	$ra
get_nvector_rect.2105:
	lahi	$a0, min_caml_intsec_rectside
	lalo	$a0, min_caml_intsec_rectside
	lw	$a0, 0($a0)
	addi	$s1, $zero, 1
	bne	$a0, $s1, bne_else.5814
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lahi	$a1, min_caml_vscan
	lalo	$a1, min_caml_vscan
	lwc1	$f0, 0($a1)
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	sgn.2025
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	sub.s	$f0, $fzero, $f0
	lw	$a0, 0($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 16($a0)
	jr	$ra
bne_else.5814:
	addi	$s1, $zero, 2
	bne	$a0, $s1, bne_else.5816
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lahi	$a1, min_caml_vscan
	lalo	$a1, min_caml_vscan
	lwc1	$f0, 8($a1)
	sw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	sgn.2025
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	sub.s	$f0, $fzero, $f0
	lw	$a0, 4($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 16($a0)
	jr	$ra
bne_else.5816:
	addi	$s1, $zero, 3
	bne	$a0, $s1, bne_else.5818
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lahi	$a1, min_caml_vscan
	lalo	$a1, min_caml_vscan
	lwc1	$f0, 16($a1)
	sw	$a0, 8($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	sgn.2025
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	sub.s	$f0, $fzero, $f0
	lw	$a0, 8($sp)
	swc1	$f0, 16($a0)
	jr	$ra
bne_else.5818:
	jr	$ra
get_nvector_plane.2107:
	lahi	$a1, min_caml_nvector
	lalo	$a1, min_caml_nvector
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	o_param_a.1994
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	sub.s	$f0, $fzero, $f0
	lw	$a0, 4($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lw	$a1, 0($sp)
	sw	$a0, 8($sp)
	add	$a0, $zero, $a1
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	o_param_b.1996
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	sub.s	$f0, $fzero, $f0
	lw	$a0, 8($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lw	$a1, 0($sp)
	sw	$a0, 12($sp)
	add	$a0, $zero, $a1
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_param_c.1998
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	sub.s	$f0, $fzero, $f0
	lw	$a0, 12($sp)
	swc1	$f0, 16($a0)
	jr	$ra
get_nvector_second_norot.2109:
	lahi	$a2, min_caml_nvector
	lalo	$a2, min_caml_nvector
	lwc1	$f0, 0($a1)
	sw	$a1, 0($sp)
	sw	$a2, 4($sp)
	sw	$a0, 8($sp)
	swc1	$f0, 16($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_param_x.2000
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lwc1	$f1, 16($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 8($sp)
	swc1	$f0, 24($sp)
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_a.1994
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	mul.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lw	$a1, 0($sp)
	lwc1	$f0, 8($a1)
	lw	$a2, 8($sp)
	sw	$a0, 32($sp)
	swc1	$f0, 40($sp)
	add	$a0, $zero, $a2
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	o_param_y.2002
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lwc1	$f1, 40($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 8($sp)
	swc1	$f0, 48($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_param_b.1996
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lwc1	$f1, 48($sp)
	mul.s	$f0, $f1, $f0
	lw	$a0, 32($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lw	$a1, 0($sp)
	lwc1	$f0, 16($a1)
	lw	$a1, 8($sp)
	sw	$a0, 56($sp)
	swc1	$f0, 64($sp)
	add	$a0, $zero, $a1
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	o_param_z.2004
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lwc1	$f1, 64($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 8($sp)
	swc1	$f0, 72($sp)
	sw	$ra, 84($sp)
	addi	$sp, $sp, 88
	jal	o_param_c.1998
	addi	$sp, $sp, -88
	lw	$ra, 84($sp)
	lwc1	$f1, 72($sp)
	mul.s	$f0, $f1, $f0
	lw	$a0, 56($sp)
	swc1	$f0, 16($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lw	$a1, 8($sp)
	sw	$a0, 80($sp)
	add	$a0, $zero, $a1
	sw	$ra, 84($sp)
	addi	$sp, $sp, 88
	jal	o_isinvert.1990
	addi	$sp, $sp, -88
	lw	$ra, 84($sp)
	add	$a1, $a0, $zero
	lw	$a0, 80($sp)
	j	normalize_vector.2022
get_nvector_second_rot.2112:
	lahi	$a2, min_caml_nvector_w
	lalo	$a2, min_caml_nvector_w
	lwc1	$f0, 0($a1)
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	swc1	$f0, 16($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_param_x.2000
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lwc1	$f1, 16($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 8($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_nvector_w
	lalo	$a0, min_caml_nvector_w
	lw	$a1, 4($sp)
	lwc1	$f0, 8($a1)
	lw	$a2, 0($sp)
	sw	$a0, 24($sp)
	swc1	$f0, 32($sp)
	add	$a0, $zero, $a2
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	o_param_y.2002
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lwc1	$f1, 32($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 24($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_nvector_w
	lalo	$a0, min_caml_nvector_w
	lw	$a1, 4($sp)
	lwc1	$f0, 16($a1)
	lw	$a1, 0($sp)
	sw	$a0, 40($sp)
	swc1	$f0, 48($sp)
	add	$a0, $zero, $a1
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_param_z.2004
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lwc1	$f1, 48($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 40($sp)
	swc1	$f0, 16($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lahi	$a1, min_caml_nvector_w
	lalo	$a1, min_caml_nvector_w
	lwc1	$f0, 0($a1)
	lw	$a1, 0($sp)
	sw	$a0, 56($sp)
	swc1	$f0, 64($sp)
	add	$a0, $zero, $a1
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	o_param_a.1994
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lwc1	$f1, 64($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_nvector_w
	lalo	$a0, min_caml_nvector_w
	lwc1	$f1, 8($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 72($sp)
	swc1	$f1, 80($sp)
	sw	$ra, 92($sp)
	addi	$sp, $sp, 96
	jal	o_param_r3.2020
	addi	$sp, $sp, -96
	lw	$ra, 92($sp)
	lwc1	$f1, 80($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_nvector_w
	lalo	$a0, min_caml_nvector_w
	lwc1	$f1, 16($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 88($sp)
	swc1	$f1, 96($sp)
	sw	$ra, 108($sp)
	addi	$sp, $sp, 112
	jal	o_param_r2.2018
	addi	$sp, $sp, -112
	lw	$ra, 108($sp)
	lwc1	$f1, 96($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 88($sp)
	add.s	$f0, $f1, $f0
	sw	$ra, 108($sp)
	addi	$sp, $sp, 112
	jal	fhalf.1982
	addi	$sp, $sp, -112
	lw	$ra, 108($sp)
	lwc1	$f1, 72($sp)
	add.s	$f0, $f1, $f0
	lw	$a0, 56($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lahi	$a1, min_caml_nvector_w
	lalo	$a1, min_caml_nvector_w
	lwc1	$f0, 8($a1)
	lw	$a1, 0($sp)
	sw	$a0, 104($sp)
	swc1	$f0, 112($sp)
	add	$a0, $zero, $a1
	sw	$ra, 124($sp)
	addi	$sp, $sp, 128
	jal	o_param_b.1996
	addi	$sp, $sp, -128
	lw	$ra, 124($sp)
	lwc1	$f1, 112($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_nvector_w
	lalo	$a0, min_caml_nvector_w
	lwc1	$f1, 0($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 120($sp)
	swc1	$f1, 128($sp)
	sw	$ra, 140($sp)
	addi	$sp, $sp, 144
	jal	o_param_r3.2020
	addi	$sp, $sp, -144
	lw	$ra, 140($sp)
	lwc1	$f1, 128($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_nvector_w
	lalo	$a0, min_caml_nvector_w
	lwc1	$f1, 16($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 136($sp)
	swc1	$f1, 144($sp)
	sw	$ra, 156($sp)
	addi	$sp, $sp, 160
	jal	o_param_r1.2016
	addi	$sp, $sp, -160
	lw	$ra, 156($sp)
	lwc1	$f1, 144($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 136($sp)
	add.s	$f0, $f1, $f0
	sw	$ra, 156($sp)
	addi	$sp, $sp, 160
	jal	fhalf.1982
	addi	$sp, $sp, -160
	lw	$ra, 156($sp)
	lwc1	$f1, 120($sp)
	add.s	$f0, $f1, $f0
	lw	$a0, 104($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lahi	$a1, min_caml_nvector_w
	lalo	$a1, min_caml_nvector_w
	lwc1	$f0, 16($a1)
	lw	$a1, 0($sp)
	sw	$a0, 152($sp)
	swc1	$f0, 160($sp)
	add	$a0, $zero, $a1
	sw	$ra, 172($sp)
	addi	$sp, $sp, 176
	jal	o_param_c.1998
	addi	$sp, $sp, -176
	lw	$ra, 172($sp)
	lwc1	$f1, 160($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_nvector_w
	lalo	$a0, min_caml_nvector_w
	lwc1	$f1, 0($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 168($sp)
	swc1	$f1, 176($sp)
	sw	$ra, 188($sp)
	addi	$sp, $sp, 192
	jal	o_param_r2.2018
	addi	$sp, $sp, -192
	lw	$ra, 188($sp)
	lwc1	$f1, 176($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_nvector_w
	lalo	$a0, min_caml_nvector_w
	lwc1	$f1, 8($a0)
	lw	$a0, 0($sp)
	swc1	$f0, 184($sp)
	swc1	$f1, 192($sp)
	sw	$ra, 204($sp)
	addi	$sp, $sp, 208
	jal	o_param_r1.2016
	addi	$sp, $sp, -208
	lw	$ra, 204($sp)
	lwc1	$f1, 192($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 184($sp)
	add.s	$f0, $f1, $f0
	sw	$ra, 204($sp)
	addi	$sp, $sp, 208
	jal	fhalf.1982
	addi	$sp, $sp, -208
	lw	$ra, 204($sp)
	lwc1	$f1, 168($sp)
	add.s	$f0, $f1, $f0
	lw	$a0, 152($sp)
	swc1	$f0, 16($a0)
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lw	$a1, 0($sp)
	sw	$a0, 200($sp)
	add	$a0, $zero, $a1
	sw	$ra, 204($sp)
	addi	$sp, $sp, 208
	jal	o_isinvert.1990
	addi	$sp, $sp, -208
	lw	$ra, 204($sp)
	add	$a1, $a0, $zero
	lw	$a0, 200($sp)
	j	normalize_vector.2022
get_nvector.2115:
	sw	$a1, 0($sp)
	sw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	o_form.1986
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	addi	$s1, $zero, 1
	bne	$a0, $s1, bne_else.5831
	j	get_nvector_rect.2105
bne_else.5831:
	addi	$s1, $zero, 2
	bne	$a0, $s1, bne_else.5832
	lw	$a0, 4($sp)
	j	get_nvector_plane.2107
bne_else.5832:
	lw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	o_isrot.1992
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	bne	$a0, $zero, bne_else.5833
	lw	$a0, 4($sp)
	lw	$a1, 0($sp)
	j	get_nvector_second_norot.2109
bne_else.5833:
	lw	$a0, 4($sp)
	lw	$a1, 0($sp)
	j	get_nvector_second_rot.2112
utexture.2118:
	sw	$a1, 0($sp)
	sw	$a0, 4($sp)
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	o_texturetype.1984
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	lahi	$a1, min_caml_texture_color
	lalo	$a1, min_caml_texture_color
	lw	$a2, 4($sp)
	sw	$a0, 8($sp)
	sw	$a1, 12($sp)
	add	$a0, $zero, $a2
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_color_red.2010
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lw	$a0, 12($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_texture_color
	lalo	$a0, min_caml_texture_color
	lw	$a1, 4($sp)
	sw	$a0, 16($sp)
	add	$a0, $zero, $a1
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	o_color_green.2012
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_texture_color
	lalo	$a0, min_caml_texture_color
	lw	$a1, 4($sp)
	sw	$a0, 20($sp)
	add	$a0, $zero, $a1
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	o_color_blue.2014
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lw	$a0, 20($sp)
	swc1	$f0, 16($a0)
	lw	$a0, 8($sp)
	addi	$s1, $zero, 1
	bne	$a0, $s1, bne_else.5834
	lw	$a0, 0($sp)
	lwc1	$f0, 0($a0)
	lw	$a1, 4($sp)
	swc1	$f0, 24($sp)
	add	$a0, $zero, $a1
	sw	$ra, 36($sp)
	addi	$sp, $sp, 40
	jal	o_param_x.2000
	addi	$sp, $sp, -40
	lw	$ra, 36($sp)
	lwc1	$f1, 24($sp)
	sub.s	$f0, $f1, $f0
	lui	$s1, 15692
	ori	$s1, $s1, 52429
	mtc1	$s1, $f1
	mul.s	$f1, $f0, $f1
	swc1	$f0, 32($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	min_caml_floor
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lui	$s1, 16800
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	lui	$s1, 16672
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	lwc1	$f2, 32($sp)
	sub.s	$f0, $f2, $f0
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5835
	addi	$a0, $zero, 0
	j	bne_cont.5836
bne_else.5835:
	addi	$a0, $zero, 1
bne_cont.5836:
	lw	$a1, 0($sp)
	lwc1	$f0, 16($a1)
	lw	$a1, 4($sp)
	sw	$a0, 40($sp)
	swc1	$f0, 48($sp)
	add	$a0, $zero, $a1
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_param_z.2004
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lwc1	$f1, 48($sp)
	sub.s	$f0, $f1, $f0
	lui	$s1, 15692
	ori	$s1, $s1, 52429
	mtc1	$s1, $f1
	mul.s	$f1, $f0, $f1
	swc1	$f0, 56($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	min_caml_floor
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	lui	$s1, 16800
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	lui	$s1, 16672
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	lwc1	$f2, 56($sp)
	sub.s	$f0, $f2, $f0
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5838
	addi	$a0, $zero, 0
	j	bne_cont.5839
bne_else.5838:
	addi	$a0, $zero, 1
bne_cont.5839:
	lahi	$a1, min_caml_texture_color
	lalo	$a1, min_caml_texture_color
	lw	$a2, 40($sp)
	bne	$a2, $zero, beq_else.5840
	bne	$a0, $zero, beq_else.5842
	lui	$s1, 17279
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	j	beq_cont.5843
beq_else.5842:
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
beq_cont.5843:
	j	beq_cont.5841
beq_else.5840:
	bne	$a0, $zero, beq_else.5844
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	j	beq_cont.5845
beq_else.5844:
	lui	$s1, 17279
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
beq_cont.5845:
beq_cont.5841:
	swc1	$f0, 8($a1)
	jr	$ra
bne_else.5834:
	addi	$s1, $zero, 2
	bne	$a0, $s1, bne_else.5847
	lw	$a0, 0($sp)
	lwc1	$f0, 8($a0)
	lui	$s1, 16000
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	min_caml_sin
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	fsqr.1980
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	lahi	$a0, min_caml_texture_color
	lalo	$a0, min_caml_texture_color
	lui	$s1, 17279
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	mul.s	$f1, $f1, $f0
	swc1	$f1, 0($a0)
	lahi	$a0, min_caml_texture_color
	lalo	$a0, min_caml_texture_color
	lui	$s1, 17279
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f2
	sub.s	$f0, $f2, $f0
	mul.s	$f0, $f1, $f0
	swc1	$f0, 8($a0)
	jr	$ra
bne_else.5847:
	addi	$s1, $zero, 3
	bne	$a0, $s1, bne_else.5849
	lw	$a0, 0($sp)
	lwc1	$f0, 0($a0)
	lw	$a1, 4($sp)
	swc1	$f0, 64($sp)
	add	$a0, $zero, $a1
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	o_param_x.2000
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lwc1	$f1, 64($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 0($sp)
	lwc1	$f1, 16($a0)
	lw	$a0, 4($sp)
	swc1	$f0, 72($sp)
	swc1	$f1, 80($sp)
	sw	$ra, 92($sp)
	addi	$sp, $sp, 96
	jal	o_param_z.2004
	addi	$sp, $sp, -96
	lw	$ra, 92($sp)
	lwc1	$f1, 80($sp)
	sub.s	$f0, $f1, $f0
	lwc1	$f1, 72($sp)
	swc1	$f0, 88($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 100($sp)
	addi	$sp, $sp, 104
	jal	fsqr.1980
	addi	$sp, $sp, -104
	lw	$ra, 100($sp)
	lwc1	$f1, 88($sp)
	swc1	$f0, 96($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 108($sp)
	addi	$sp, $sp, 112
	jal	fsqr.1980
	addi	$sp, $sp, -112
	lw	$ra, 108($sp)
	lwc1	$f1, 96($sp)
	add.s	$f0, $f1, $f0
	sw	$ra, 108($sp)
	addi	$sp, $sp, 112
	jal	min_caml_sqrt
	addi	$sp, $sp, -112
	lw	$ra, 108($sp)
	lui	$s1, 16672
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	div.s	$f0, $f0, $f1
	swc1	$f0, 104($sp)
	sw	$ra, 116($sp)
	addi	$sp, $sp, 120
	jal	min_caml_floor
	addi	$sp, $sp, -120
	lw	$ra, 116($sp)
	lwc1	$f1, 104($sp)
	sub.s	$f0, $f1, $f0
	lui	$s1, 16457
	ori	$s1, $s1, 4059
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	sw	$ra, 116($sp)
	addi	$sp, $sp, 120
	jal	min_caml_cos
	addi	$sp, $sp, -120
	lw	$ra, 116($sp)
	sw	$ra, 116($sp)
	addi	$sp, $sp, 120
	jal	fsqr.1980
	addi	$sp, $sp, -120
	lw	$ra, 116($sp)
	lahi	$a0, min_caml_texture_color
	lalo	$a0, min_caml_texture_color
	lui	$s1, 17279
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	mul.s	$f1, $f0, $f1
	swc1	$f1, 8($a0)
	lahi	$a0, min_caml_texture_color
	lalo	$a0, min_caml_texture_color
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	sub.s	$f0, $f1, $f0
	lui	$s1, 17279
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	swc1	$f0, 16($a0)
	jr	$ra
bne_else.5849:
	addi	$s1, $zero, 4
	bne	$a0, $s1, bne_else.5851
	lw	$a0, 0($sp)
	lwc1	$f0, 0($a0)
	lw	$a1, 4($sp)
	swc1	$f0, 112($sp)
	add	$a0, $zero, $a1
	sw	$ra, 124($sp)
	addi	$sp, $sp, 128
	jal	o_param_x.2000
	addi	$sp, $sp, -128
	lw	$ra, 124($sp)
	lwc1	$f1, 112($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	swc1	$f0, 120($sp)
	sw	$ra, 132($sp)
	addi	$sp, $sp, 136
	jal	o_param_a.1994
	addi	$sp, $sp, -136
	lw	$ra, 132($sp)
	sw	$ra, 132($sp)
	addi	$sp, $sp, 136
	jal	min_caml_sqrt
	addi	$sp, $sp, -136
	lw	$ra, 132($sp)
	lwc1	$f1, 120($sp)
	mul.s	$f0, $f1, $f0
	lw	$a0, 0($sp)
	lwc1	$f1, 16($a0)
	lw	$a1, 4($sp)
	swc1	$f0, 128($sp)
	swc1	$f1, 136($sp)
	add	$a0, $zero, $a1
	sw	$ra, 148($sp)
	addi	$sp, $sp, 152
	jal	o_param_z.2004
	addi	$sp, $sp, -152
	lw	$ra, 148($sp)
	lwc1	$f1, 136($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	swc1	$f0, 144($sp)
	sw	$ra, 156($sp)
	addi	$sp, $sp, 160
	jal	o_param_c.1998
	addi	$sp, $sp, -160
	lw	$ra, 156($sp)
	sw	$ra, 156($sp)
	addi	$sp, $sp, 160
	jal	min_caml_sqrt
	addi	$sp, $sp, -160
	lw	$ra, 156($sp)
	lwc1	$f1, 144($sp)
	mul.s	$f0, $f1, $f0
	lwc1	$f1, 128($sp)
	swc1	$f0, 152($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 164($sp)
	addi	$sp, $sp, 168
	jal	fsqr.1980
	addi	$sp, $sp, -168
	lw	$ra, 164($sp)
	lwc1	$f1, 152($sp)
	swc1	$f0, 160($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 172($sp)
	addi	$sp, $sp, 176
	jal	fsqr.1980
	addi	$sp, $sp, -176
	lw	$ra, 172($sp)
	lwc1	$f1, 160($sp)
	add.s	$f0, $f1, $f0
	sw	$ra, 172($sp)
	addi	$sp, $sp, 176
	jal	min_caml_sqrt
	addi	$sp, $sp, -176
	lw	$ra, 172($sp)
	lui	$s1, 14545
	ori	$s1, $s1, 46871
	mtc1	$s1, $f1
	lwc1	$f2, 128($sp)
	swc1	$f0, 168($sp)
	swc1	$f1, 176($sp)
	add.s	$f0, $fzero, $f2
	sw	$ra, 188($sp)
	addi	$sp, $sp, 192
	jal	min_caml_abs_float
	addi	$sp, $sp, -192
	lw	$ra, 188($sp)
	lwc1	$f1, 176($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5852
	lwc1	$f0, 128($sp)
	lwc1	$f1, 152($sp)
	div.s	$f0, $f1, $f0
	sw	$ra, 188($sp)
	addi	$sp, $sp, 192
	jal	min_caml_abs_float
	addi	$sp, $sp, -192
	lw	$ra, 188($sp)
	sw	$ra, 188($sp)
	addi	$sp, $sp, 192
	jal	min_caml_atan
	addi	$sp, $sp, -192
	lw	$ra, 188($sp)
	lui	$s1, 16664
	ori	$s1, $s1, 51691
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	j	bne_cont.5853
bne_else.5852:
	lui	$s1, 16752
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
bne_cont.5853:
	swc1	$f0, 184($sp)
	sw	$ra, 196($sp)
	addi	$sp, $sp, 200
	jal	min_caml_floor
	addi	$sp, $sp, -200
	lw	$ra, 196($sp)
	lwc1	$f1, 184($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 0($sp)
	lwc1	$f2, 8($a0)
	lw	$a0, 4($sp)
	swc1	$f0, 192($sp)
	swc1	$f2, 200($sp)
	sw	$ra, 212($sp)
	addi	$sp, $sp, 216
	jal	o_param_y.2002
	addi	$sp, $sp, -216
	lw	$ra, 212($sp)
	lwc1	$f1, 200($sp)
	sub.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	swc1	$f0, 208($sp)
	sw	$ra, 220($sp)
	addi	$sp, $sp, 224
	jal	o_param_b.1996
	addi	$sp, $sp, -224
	lw	$ra, 220($sp)
	sw	$ra, 220($sp)
	addi	$sp, $sp, 224
	jal	min_caml_sqrt
	addi	$sp, $sp, -224
	lw	$ra, 220($sp)
	lwc1	$f1, 208($sp)
	mul.s	$f0, $f1, $f0
	lui	$s1, 14545
	ori	$s1, $s1, 46871
	mtc1	$s1, $f1
	lwc1	$f2, 184($sp)
	swc1	$f0, 216($sp)
	swc1	$f1, 224($sp)
	add.s	$f0, $fzero, $f2
	sw	$ra, 236($sp)
	addi	$sp, $sp, 240
	jal	min_caml_abs_float
	addi	$sp, $sp, -240
	lw	$ra, 236($sp)
	lwc1	$f1, 224($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5854
	lwc1	$f0, 168($sp)
	lwc1	$f1, 216($sp)
	div.s	$f0, $f1, $f0
	sw	$ra, 236($sp)
	addi	$sp, $sp, 240
	jal	min_caml_abs_float
	addi	$sp, $sp, -240
	lw	$ra, 236($sp)
	sw	$ra, 236($sp)
	addi	$sp, $sp, 240
	jal	min_caml_atan
	addi	$sp, $sp, -240
	lw	$ra, 236($sp)
	lui	$s1, 16664
	ori	$s1, $s1, 51691
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
	j	bne_cont.5855
bne_else.5854:
	lui	$s1, 16752
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
bne_cont.5855:
	swc1	$f0, 232($sp)
	sw	$ra, 244($sp)
	addi	$sp, $sp, 248
	jal	min_caml_floor
	addi	$sp, $sp, -248
	lw	$ra, 244($sp)
	lwc1	$f1, 232($sp)
	sub.s	$f0, $f1, $f0
	lui	$s1, 15897
	ori	$s1, $s1, 39322
	mtc1	$s1, $f1
	lui	$s1, 16128
	ori	$s1, $s1, 0
	mtc1	$s1, $f2
	lwc1	$f3, 192($sp)
	sub.s	$f2, $f2, $f3
	swc1	$f0, 240($sp)
	swc1	$f1, 248($sp)
	add.s	$f0, $fzero, $f2
	sw	$ra, 260($sp)
	addi	$sp, $sp, 264
	jal	fsqr.1980
	addi	$sp, $sp, -264
	lw	$ra, 260($sp)
	lwc1	$f1, 248($sp)
	sub.s	$f0, $f1, $f0
	lui	$s1, 16128
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	lwc1	$f2, 240($sp)
	sub.s	$f1, $f1, $f2
	swc1	$f0, 256($sp)
	add.s	$f0, $fzero, $f1
	sw	$ra, 268($sp)
	addi	$sp, $sp, 272
	jal	fsqr.1980
	addi	$sp, $sp, -272
	lw	$ra, 268($sp)
	lwc1	$f1, 256($sp)
	sub.s	$f0, $f1, $f0
	lahi	$a0, min_caml_texture_color
	lalo	$a0, min_caml_texture_color
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5856
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	j	bne_cont.5857
bne_else.5856:
	lui	$s1, 17492
	ori	$s1, $s1, 32768
	mtc1	$s1, $f1
	mul.s	$f0, $f0, $f1
bne_cont.5857:
	swc1	$f0, 16($a0)
	jr	$ra
bne_else.5851:
	jr	$ra
in_prod.2121:
	lwc1	$f0, 0($a0)
	lwc1	$f1, 0($a1)
	mul.s	$f0, $f0, $f1
	lwc1	$f1, 8($a0)
	lwc1	$f2, 8($a1)
	mul.s	$f1, $f1, $f2
	add.s	$f0, $f0, $f1
	lwc1	$f1, 16($a0)
	lwc1	$f2, 16($a1)
	mul.s	$f1, $f1, $f2
	add.s	$f0, $f0, $f1
	jr	$ra
accumulate_vec_mul.2124:
	lwc1	$f1, 0($a0)
	lwc1	$f2, 0($a1)
	mul.s	$f2, $f0, $f2
	add.s	$f1, $f1, $f2
	swc1	$f1, 0($a0)
	lwc1	$f1, 8($a0)
	lwc1	$f2, 8($a1)
	mul.s	$f2, $f0, $f2
	add.s	$f1, $f1, $f2
	swc1	$f1, 8($a0)
	lwc1	$f1, 16($a0)
	lwc1	$f2, 16($a1)
	mul.s	$f0, $f0, $f2
	add.s	$f0, $f1, $f0
	swc1	$f0, 16($a0)
	jr	$ra
raytracing.2128:
	lahi	$a1, min_caml_viewpoint
	lalo	$a1, min_caml_viewpoint
	lahi	$a2, min_caml_vscan
	lalo	$a2, min_caml_vscan
	swc1	$f0, 0($sp)
	sw	$a0, 8($sp)
	add	$a0, $zero, $a1
	add	$a1, $zero, $a2
	sw	$ra, 12($sp)
	addi	$sp, $sp, 16
	jal	tracer.2102
	addi	$sp, $sp, -16
	lw	$ra, 12($sp)
	sw	$a0, 12($sp)
	bne	$a0, $zero, beq_else.5861
	lw	$a1, 8($sp)
	bne	$a1, $zero, beq_else.5863
	j	beq_cont.5864
beq_else.5863:
	lahi	$a2, min_caml_vscan
	lalo	$a2, min_caml_vscan
	lahi	$a3, min_caml_light
	lalo	$a3, min_caml_light
	add	$a1, $zero, $a3
	add	$a0, $zero, $a2
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	in_prod.2121
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	sub.s	$f0, $fzero, $f0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5865
	j	bne_cont.5866
bne_else.5865:
	swc1	$f0, 16($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	fsqr.1980
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	lwc1	$f1, 16($sp)
	mul.s	$f0, $f0, $f1
	lwc1	$f1, 0($sp)
	mul.s	$f0, $f0, $f1
	lahi	$a0, min_caml_beam
	lalo	$a0, min_caml_beam
	lwc1	$f2, 0($a0)
	mul.s	$f0, $f0, $f2
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lahi	$a1, min_caml_rgb
	lalo	$a1, min_caml_rgb
	lwc1	$f2, 0($a1)
	add.s	$f2, $f2, $f0
	swc1	$f2, 0($a0)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lahi	$a1, min_caml_rgb
	lalo	$a1, min_caml_rgb
	lwc1	$f2, 8($a1)
	add.s	$f2, $f2, $f0
	swc1	$f2, 8($a0)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lahi	$a1, min_caml_rgb
	lalo	$a1, min_caml_rgb
	lwc1	$f2, 16($a1)
	add.s	$f0, $f2, $f0
	swc1	$f0, 16($a0)
bne_cont.5866:
beq_cont.5864:
	j	beq_cont.5862
beq_else.5861:
beq_cont.5862:
	lw	$a0, 12($sp)
	bne	$a0, $zero, bne_else.5867
	jr	$ra
bne_else.5867:
	lahi	$a0, min_caml_objects
	lalo	$a0, min_caml_objects
	lahi	$a1, min_caml_crashed_object
	lalo	$a1, min_caml_crashed_object
	lw	$a1, 0($a1)
	sll	$a1, $a1, 2
	add	$s1, $a0, $a0
	lw	$a0, 0($s1)
	lahi	$a1, min_caml_crashed_point
	lalo	$a1, min_caml_crashed_point
	sw	$a0, 24($sp)
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	get_nvector.2115
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	addi	$a0, $zero, 0
	lahi	$a1, min_caml_or_net
	lalo	$a1, min_caml_or_net
	lw	$a1, 0($a1)
	lahi	$a2, min_caml_crashed_point
	lalo	$a2, min_caml_crashed_point
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	shadow_check_one_or_matrix.2089
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	bne	$a0, $zero, beq_else.5869
	lahi	$a0, min_caml_nvector
	lalo	$a0, min_caml_nvector
	lahi	$a1, min_caml_light
	lalo	$a1, min_caml_light
	sw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jal	in_prod.2121
	addi	$sp, $sp, -32
	lw	$ra, 28($sp)
	sub.s	$f0, $fzero, $f0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5871
	lui	$s1, 15948
	ori	$s1, $s1, 52429
	mtc1	$s1, $f1
	add.s	$f0, $f0, $f1
	j	bne_cont.5872
bne_else.5871:
	lui	$s1, 15948
	ori	$s1, $s1, 52429
	mtc1	$s1, $f0
bne_cont.5872:
	lwc1	$f1, 0($sp)
	mul.s	$f0, $f0, $f1
	lw	$a0, 24($sp)
	swc1	$f0, 32($sp)
	sw	$ra, 44($sp)
	addi	$sp, $sp, 48
	jal	o_diffuse.2006
	addi	$sp, $sp, -48
	lw	$ra, 44($sp)
	lwc1	$f1, 32($sp)
	mul.s	$f0, $f1, $f0
	j	beq_cont.5870
beq_else.5869:
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
beq_cont.5870:
	lahi	$a1, min_caml_crashed_point
	lalo	$a1, min_caml_crashed_point
	lw	$a0, 24($sp)
	swc1	$f0, 40($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	utexture.2118
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lahi	$a1, min_caml_texture_color
	lalo	$a1, min_caml_texture_color
	lwc1	$f0, 40($sp)
	sw	$ra, 52($sp)
	addi	$sp, $sp, 56
	jal	accumulate_vec_mul.2124
	addi	$sp, $sp, -56
	lw	$ra, 52($sp)
	lw	$a0, 8($sp)
	slti	$s0, $a0, 5
	beq	$zero, $s0, bne_else.5874
	lui	$s1, 15820
	ori	$s1, $s1, 52429
	mtc1	$s1, $f0
	lwc1	$f1, 0($sp)
	c.lt.s	$f1, $f0
	beq	$zero, $s0, bne_else.5875
	jr	$ra
bne_else.5875:
	lui	$s1, 140737488338944
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lahi	$a1, min_caml_vscan
	lalo	$a1, min_caml_vscan
	lahi	$a2, min_caml_nvector
	lalo	$a2, min_caml_nvector
	swc1	$f0, 48($sp)
	add	$a0, $zero, $a1
	add	$a1, $zero, $a2
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	in_prod.2121
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lwc1	$f1, 48($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_vscan
	lalo	$a0, min_caml_vscan
	lahi	$a1, min_caml_nvector
	lalo	$a1, min_caml_nvector
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	accumulate_vec_mul.2124
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	lw	$a0, 24($sp)
	sw	$ra, 60($sp)
	addi	$sp, $sp, 64
	jal	o_reflectiontype.1988
	addi	$sp, $sp, -64
	lw	$ra, 60($sp)
	addi	$s1, $zero, 1
	bne	$a0, $s1, bne_else.5877
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lw	$a0, 24($sp)
	swc1	$f0, 56($sp)
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	o_hilight.2008
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	lwc1	$f1, 56($sp)
	fcmpu	$s0, $f1, $f0
	bne	$zero, $s0, beq_else.5878
	jr	$ra
beq_else.5878:
	lahi	$a0, min_caml_vscan
	lalo	$a0, min_caml_vscan
	lahi	$a1, min_caml_light
	lalo	$a1, min_caml_light
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	in_prod.2121
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	sub.s	$f0, $fzero, $f0
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	c.lt.s	$f0, $f1
	beq	$zero, $s0, bne_else.5880
	jr	$ra
bne_else.5880:
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	fsqr.1980
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	sw	$ra, 68($sp)
	addi	$sp, $sp, 72
	jal	fsqr.1980
	addi	$sp, $sp, -72
	lw	$ra, 68($sp)
	lwc1	$f1, 0($sp)
	mul.s	$f0, $f0, $f1
	lwc1	$f1, 40($sp)
	mul.s	$f0, $f0, $f1
	lw	$a0, 24($sp)
	swc1	$f0, 64($sp)
	sw	$ra, 76($sp)
	addi	$sp, $sp, 80
	jal	o_hilight.2008
	addi	$sp, $sp, -80
	lw	$ra, 76($sp)
	lwc1	$f1, 64($sp)
	mul.s	$f0, $f1, $f0
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lahi	$a1, min_caml_rgb
	lalo	$a1, min_caml_rgb
	lwc1	$f1, 0($a1)
	add.s	$f1, $f1, $f0
	swc1	$f1, 0($a0)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lahi	$a1, min_caml_rgb
	lalo	$a1, min_caml_rgb
	lwc1	$f1, 8($a1)
	add.s	$f1, $f1, $f0
	swc1	$f1, 8($a0)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lahi	$a1, min_caml_rgb
	lalo	$a1, min_caml_rgb
	lwc1	$f1, 16($a1)
	add.s	$f0, $f1, $f0
	swc1	$f0, 16($a0)
	jr	$ra
bne_else.5877:
	addi	$s1, $zero, 2
	bne	$a0, $s1, bne_else.5883
	lahi	$a0, min_caml_viewpoint
	lalo	$a0, min_caml_viewpoint
	lahi	$a1, min_caml_crashed_point
	lalo	$a1, min_caml_crashed_point
	lwc1	$f0, 0($a1)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_viewpoint
	lalo	$a0, min_caml_viewpoint
	lahi	$a1, min_caml_crashed_point
	lalo	$a1, min_caml_crashed_point
	lwc1	$f0, 8($a1)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_viewpoint
	lalo	$a0, min_caml_viewpoint
	lahi	$a1, min_caml_crashed_point
	lalo	$a1, min_caml_crashed_point
	lwc1	$f0, 16($a1)
	swc1	$f0, 16($a0)
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	lw	$a0, 24($sp)
	swc1	$f0, 72($sp)
	sw	$ra, 84($sp)
	addi	$sp, $sp, 88
	jal	o_diffuse.2006
	addi	$sp, $sp, -88
	lw	$ra, 84($sp)
	lwc1	$f1, 72($sp)
	sub.s	$f0, $f1, $f0
	lwc1	$f1, 0($sp)
	mul.s	$f0, $f1, $f0
	lw	$a0, 8($sp)
	addi	$a0, $a0, 1
	j	raytracing.2128
bne_else.5883:
	jr	$ra
bne_else.5874:
	jr	$ra
write_rgb.2131:
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lwc1	$f0, 0($a0)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_int_of_float
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	slti	$s0, $a0, 256
	beq	$zero, $s0, bne_else.5886
	j	bne_cont.5887
bne_else.5886:
	addi	$a0, $zero, 255
bne_cont.5887:
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_byte
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lwc1	$f0, 8($a0)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_int_of_float
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	slti	$s0, $a0, 256
	beq	$zero, $s0, bne_else.5888
	j	bne_cont.5889
bne_else.5888:
	addi	$a0, $zero, 255
bne_cont.5889:
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_byte
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lwc1	$f0, 16($a0)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_int_of_float
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	slti	$s0, $a0, 256
	beq	$zero, $s0, bne_else.5890
	j	bne_cont.5891
bne_else.5890:
	addi	$a0, $zero, 255
bne_cont.5891:
	j	min_caml_print_byte
write_ppm_header.2133:
	addi	$a0, $zero, 80
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_byte
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 54
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_byte
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 10
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_byte
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_size
	lalo	$a0, min_caml_size
	lw	$a0, 0($a0)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_int
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 32
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_byte
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_size
	lalo	$a0, min_caml_size
	lw	$a0, 4($a0)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_int
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 10
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_byte
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 255
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_print_int
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	addi	$a0, $zero, 10
	j	min_caml_print_byte
scan_point.2135:
	lahi	$a1, min_caml_size
	lalo	$a1, min_caml_size
	lw	$a1, 0($a1)
	slt	$s0, $a0, $a1
	beq	$zero, $s0, bne_else.5892
	sw	$a0, 0($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_float_of_int
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_scan_offset
	lalo	$a0, min_caml_scan_offset
	lwc1	$f1, 0($a0)
	sub.s	$f0, $f0, $f1
	lahi	$a0, min_caml_scan_d
	lalo	$a0, min_caml_scan_d
	lwc1	$f1, 0($a0)
	mul.s	$f0, $f0, $f1
	lahi	$a0, min_caml_vscan
	lalo	$a0, min_caml_vscan
	lahi	$a1, min_caml_cos_v
	lalo	$a1, min_caml_cos_v
	lwc1	$f1, 8($a1)
	mul.s	$f1, $f0, $f1
	lahi	$a1, min_caml_wscan
	lalo	$a1, min_caml_wscan
	lwc1	$f2, 0($a1)
	add.s	$f1, $f1, $f2
	swc1	$f1, 0($a0)
	lahi	$a0, min_caml_vscan
	lalo	$a0, min_caml_vscan
	lahi	$a1, min_caml_scan_sscany
	lalo	$a1, min_caml_scan_sscany
	lwc1	$f1, 0($a1)
	lahi	$a1, min_caml_cos_v
	lalo	$a1, min_caml_cos_v
	lwc1	$f2, 0($a1)
	mul.s	$f1, $f1, $f2
	lahi	$a1, min_caml_vp
	lalo	$a1, min_caml_vp
	lwc1	$f2, 8($a1)
	sub.s	$f1, $f1, $f2
	swc1	$f1, 8($a0)
	lahi	$a0, min_caml_vscan
	lalo	$a0, min_caml_vscan
	sub.s	$f1, $fzero, $f0
	lahi	$a1, min_caml_sin_v
	lalo	$a1, min_caml_sin_v
	lwc1	$f2, 8($a1)
	mul.s	$f1, $f1, $f2
	lahi	$a1, min_caml_wscan
	lalo	$a1, min_caml_wscan
	lwc1	$f2, 16($a1)
	add.s	$f1, $f1, $f2
	swc1	$f1, 16($a0)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	fsqr.1980
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_scan_met1
	lalo	$a0, min_caml_scan_met1
	lwc1	$f1, 0($a0)
	add.s	$f0, $f0, $f1
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_sqrt
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_vscan
	lalo	$a0, min_caml_vscan
	lahi	$a1, min_caml_vscan
	lalo	$a1, min_caml_vscan
	lwc1	$f1, 0($a1)
	div.s	$f1, $f1, $f0
	swc1	$f1, 0($a0)
	lahi	$a0, min_caml_vscan
	lalo	$a0, min_caml_vscan
	lahi	$a1, min_caml_vscan
	lalo	$a1, min_caml_vscan
	lwc1	$f1, 8($a1)
	div.s	$f1, $f1, $f0
	swc1	$f1, 8($a0)
	lahi	$a0, min_caml_vscan
	lalo	$a0, min_caml_vscan
	lahi	$a1, min_caml_vscan
	lalo	$a1, min_caml_vscan
	lwc1	$f1, 16($a1)
	div.s	$f0, $f1, $f0
	swc1	$f0, 16($a0)
	lahi	$a0, min_caml_viewpoint
	lalo	$a0, min_caml_viewpoint
	lahi	$a1, min_caml_view
	lalo	$a1, min_caml_view
	lwc1	$f0, 0($a1)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_viewpoint
	lalo	$a0, min_caml_viewpoint
	lahi	$a1, min_caml_view
	lalo	$a1, min_caml_view
	lwc1	$f0, 8($a1)
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_viewpoint
	lalo	$a0, min_caml_viewpoint
	lahi	$a1, min_caml_view
	lalo	$a1, min_caml_view
	lwc1	$f0, 16($a1)
	swc1	$f0, 16($a0)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 8($a0)
	lahi	$a0, min_caml_rgb
	lalo	$a0, min_caml_rgb
	lui	$s1, 0
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	swc1	$f0, 16($a0)
	addi	$a0, $zero, 0
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	raytracing.2128
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	write_rgb.2131
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	j	scan_point.2135
bne_else.5892:
	jr	$ra
scan_line.2137:
	lahi	$a1, min_caml_size
	lalo	$a1, min_caml_size
	lw	$a1, 0($a1)
	slt	$s0, $a0, $a1
	beq	$zero, $s0, bne_else.5894
	lahi	$a1, min_caml_scan_sscany
	lalo	$a1, min_caml_scan_sscany
	lahi	$a2, min_caml_scan_offset
	lalo	$a2, min_caml_scan_offset
	lwc1	$f0, 0($a2)
	lui	$s1, 16256
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	sub.s	$f0, $f0, $f1
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	swc1	$f0, 8($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	min_caml_float_of_int
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lwc1	$f1, 8($sp)
	sub.s	$f0, $f1, $f0
	lahi	$a0, min_caml_scan_d
	lalo	$a0, min_caml_scan_d
	lwc1	$f1, 0($a0)
	mul.s	$f0, $f1, $f0
	lw	$a0, 4($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_scan_met1
	lalo	$a0, min_caml_scan_met1
	lahi	$a1, min_caml_scan_sscany
	lalo	$a1, min_caml_scan_sscany
	lwc1	$f0, 0($a1)
	sw	$a0, 16($sp)
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	fsqr.1980
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lui	$s1, 18204
	ori	$s1, $s1, 16384
	mtc1	$s1, $f1
	add.s	$f0, $f0, $f1
	lw	$a0, 16($sp)
	swc1	$f0, 0($a0)
	lahi	$a0, min_caml_scan_sscany
	lalo	$a0, min_caml_scan_sscany
	lwc1	$f0, 0($a0)
	lahi	$a0, min_caml_sin_v
	lalo	$a0, min_caml_sin_v
	lwc1	$f1, 0($a0)
	mul.s	$f0, $f0, $f1
	lahi	$a0, min_caml_wscan
	lalo	$a0, min_caml_wscan
	lahi	$a1, min_caml_sin_v
	lalo	$a1, min_caml_sin_v
	lwc1	$f1, 8($a1)
	mul.s	$f1, $f0, $f1
	lahi	$a1, min_caml_vp
	lalo	$a1, min_caml_vp
	lwc1	$f2, 0($a1)
	sub.s	$f1, $f1, $f2
	swc1	$f1, 0($a0)
	lahi	$a0, min_caml_wscan
	lalo	$a0, min_caml_wscan
	lahi	$a1, min_caml_cos_v
	lalo	$a1, min_caml_cos_v
	lwc1	$f1, 8($a1)
	mul.s	$f0, $f0, $f1
	lahi	$a1, min_caml_vp
	lalo	$a1, min_caml_vp
	lwc1	$f1, 16($a1)
	sub.s	$f0, $f0, $f1
	swc1	$f0, 16($a0)
	addi	$a0, $zero, 0
	sw	$ra, 20($sp)
	addi	$sp, $sp, 24
	jal	scan_point.2135
	addi	$sp, $sp, -24
	lw	$ra, 20($sp)
	lw	$a0, 0($sp)
	addi	$a0, $a0, 1
	j	scan_line.2137
bne_else.5894:
	jr	$ra
scan_start.2139:
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	write_ppm_header.2133
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_size
	lalo	$a0, min_caml_size
	lw	$a0, 0($a0)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	min_caml_float_of_int
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	lahi	$a0, min_caml_scan_d
	lalo	$a0, min_caml_scan_d
	lui	$s1, 17152
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	div.s	$f1, $f1, $f0
	swc1	$f1, 0($a0)
	lahi	$a0, min_caml_scan_offset
	lalo	$a0, min_caml_scan_offset
	lui	$s1, 16384
	ori	$s1, $s1, 0
	mtc1	$s1, $f1
	div.s	$f0, $f0, $f1
	swc1	$f0, 0($a0)
	addi	$a0, $zero, 0
	j	scan_line.2137
rt.2141:
	lahi	$a3, min_caml_size
	lalo	$a3, min_caml_size
	sw	$a0, 0($a3)
	lahi	$a0, min_caml_size
	lalo	$a0, min_caml_size
	sw	$a1, 4($a0)
	lahi	$a0, min_caml_dbg
	lalo	$a0, min_caml_dbg
	sw	$a2, 0($a0)
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	read_parameter.2043
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
	j	scan_start.2139
_min_caml_start:
	addi	$sp, $sp, 4096
	addi	$gp, $gp, 8192
	addi	$a0, $zero, 768
	addi	$a1, $zero, 768
	addi	$a2, $zero, 0
	sw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jal	rt.2141
	addi	$sp, $sp, -8
	lw	$ra, 4($sp)
