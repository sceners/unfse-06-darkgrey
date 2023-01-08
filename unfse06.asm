; FSE v0.6 *unpacker* (c) DarkGrey // Delirium Tremens Group
;-
		model	tiny
		.code
		.startup
		.386
		jumps
;-
		call	beg
		call	ip_check
		call	read_cod
;-
		mov	di, offset buffer
		add	di, [ip]
		push	di
		mov	si, di
		mov	cx, 0fffh
fuck:
		mov	al, 075h
		repne	scasb
		jcxz	p_errs
		cmp	byte ptr ds:[di], 10h
		jb	fuck
		push	cx
		push	di
		xor	al, al
		mov	cx, 9
		repne	scasb
		pop	di
		jcxz	fuck1
		jmp	next3
fuck1:
		pop	cx
		jmp	fuck
next3:
		pop	cx
		mov	bp, di
		xor	ax, ax
		mov	al, byte ptr ds:[bp]
		not	al
		sub	di, ax
		mov	ds:[tmp], di
		mov	byte ptr ds:[bp-1], 0c3h
		mov	bx, bp
		pop	bp
		mov	byte ptr ds:[bp], 90h
		mov	di, [ip]
		mov	cx, 200h
		cld
		mov	si, offset buffer
		add	si, di
		mov	[temp], di
		repne	movsb
		call	bp
;-
		mov	sp, [tmp]
@@0:
		call	sp
		jnz	@@0
;-
		mov	sp, 0fffeh
		sti
		cld
;-
		mov	di, [temp]
		mov	si, di
		mov	al, 08bh
		mov	cx, 0ffffh
@@2:
		repne	scasb
		jcxz	p_errs
		cmp	dword ptr ds:[di], 0246c7ech
		jne	@@2
		mov	ax, [di+4]
		mov	[axval], ax
		mov	[dxval], ax
;-
		mov	di, [temp]
		mov	si, di
		mov	al, 1eh
		mov	cx, 0ffffh
@@3:
		repne	scasb
		jcxz	p_errs
		mov	si, di
		cmp	dword ptr ds:[di], 08ec88c06h
		jne	@@3
		add	si, 8
		lodsw
		mov	bx, ax
		inc	si
		lodsw
		mov	cx, ax
		mov	ax, bx
		pusha
		call	read_cod
		popa
		mov	di, offset buffer
		mov	si, di
@@13a:
		lodsb
		xor	al, ah
		stosb
		add	al, cl
		ror	al, 1
		mov	ah, al
		xor	ah, cl
		loop	@@13A
;-
		sub	di, 100h
		mov	si, di
		mov	al, 8ch
		mov	cx, 100h
@@10:
		repne	scasb
		jcxz	p_errs
		cmp	dword ptr ds:[di], 08ed98ec9h
		jne	@@10
		add	di, 6
		mov	dx, [di]
		add	di, 22
		mov	bp, [di]
		add	bp, offset buffer
;-
		mov	si, offset buffer
		mov	di, si
@@104b:
		lodsb
		add	dh, al
		xor	al, dl
		rol	dx, 03
		stosb
		cmp	si, bp
		jne	@@104B
;-
		xor	al, al
		mov	di, offset buffer
		mov	si, di
		mov	cx, [tempsz]
@@11:
		repne	scasb
		jcxz	p_errs
		cmp	dword ptr ds:[di], 00170012h
		jne	@@11
		cmp	dword ptr ds:[di+4], 001a000eh
		jne	@@11
		add	di, 8
		mov	si, di
		push	si
		mov	bp, di
		sub	bp, offset buffer
		mov	cx, 399h
@@12:
		lodsb
		inc	bp
		xor	ax, bp
		stosb
		loop	@@12
;-
		pop	di
		add	di, 8
		push	di
		mov	di, [di]
		add	di, offset buffer
		mov	si, di
		mov	cx, 15h
@@13:
		lodsb
		add	al, 5ah
		stosb
		loop	@@13
;-
		pop	di
		add	di, 22
		mov	cx, [di]
		mov	ah, 082h
		mov	si, offset buffer
		mov	di, si
cry2:
		lodsb
		xor	al, ah
		stosb
		add	al, cl
		ror	al, 1
		mov	ah, al
		xor	ah, cl
		loop	cry2
;-
		mov	di, offset buffer
		mov	si, di
		mov	al, 8eh
		mov	cx, [tempsz]
@@16:
		repne	scasb
		cmp	dword ptr ds:[di], 33c08ed8h
		jne	@@16
		cmp	dword ptr ds:[di+4], 8be88ec0h
		jne	@@16
		mov	cx, word ptr ds:[di+12]
;-
		mov	di, offset buffer
		mov	si, di
@@33:
		lodsw
		xor	ax, 0ca5ah
		rol	ax, 1
		stosw
		loop	@@33
;-
		mov	di, offset buffer
		mov	si, di
		mov	al, 89h
		mov	cx, [tempsz]
@@35:
		repne	scasb
		jcxz	p_errs
		cmp	dword ptr ds:[di], 0e900b82eh
		jne	@@35
;-
		add	di, 9
		mov	si, di
		mov	cx, 12ch
@@34:
		lodsb
		not	al
		stosb
		loop	@@34
;-
		mov	di, offset buffer
		mov	si, di
		mov	al, 08eh
		mov	cx, [tempsz]
@@37:
		repne	scasb
		jcxz	p_errs
		cmp	dword ptr ds:[di], 033da8ec2h
		jne	@@37
		add	di, 14
		mov	si, di
		mov	di, offset @@631
@@36:
		lodsb
		cmp	al, 0e2h
		je	test2
		stosb
		jmp	@@36
test2:
;-
		mov	ah, 3ch
		mov	dx, offset fn
		xor	cx, cx
		int	21h
		jc	errs
		mov	[hw], ax
;-
		mov	ax, 4200h
		mov	dx, 660h+170h-100h
		xor	cx, cx
		mov	bx, [hr]
		int	21h
		jc	errs
		call	check
;-
@@39:
		call	read
		jc	next1
		call	enc
		call	writef
		jmp	@@39
;-
read:
		mov	ebp, [tounpb]
		sub	ebp, 100h
		js	ent
;-
		sub	[tounpb], 100h
;-
		mov	ah, 3fh
		mov	dx, offset buffer
		mov	bx, [hr]
		mov	cx, 0100h
		int	21h
		clc
		ret
;-
ent:
		stc
		ret
;-
next1:
		call	check
		mov	eax, [tounpb]
		xor	edx, edx
		mov	ebp, 512
		div	ebp
		or	dx, dx
		jz	overf
		inc	ax
overf:
;-
		mov	[pc], ax
		mov	[pcl], dx
;-
		mov	ax, 4200h
		mov	bx, [hw]
		xor	dx, dx
		xor	cx, cx
		int	21h
		jc	errs
;-
		mov	ah, 40h
		mov	dx, offset fucking_header
		mov	cx, 6
		int	21h
		jc	errs
;-
		mov	ax, 4200h
		mov	dx, 0ah
		xor	cx, cx
		mov	bx, [hw]
		int	21h
		jc	errs
;-
		mov	ah, 40h
		mov	bx, [hw]
		mov	dx, offset mem
		mov	cx, 4
		int	21h
		jc	errs
;-
		mov	ax, 4200h
		mov	dx, 012h
		xor	cx, cx
		mov	bx, [hw]
		int	21h
		jc	errs
;-
		mov	ah, 40h
		mov	bx, [hw]
		mov	dx, offset zero
		mov	cx, 2
		int	21h
		jc	errs
;-
		mov	ax, 4200h
		mov	dx, 01ah
		xor	cx, cx
		mov	bx, [hw]
		int	21h
		jc	errs
;-
		mov	ah, 40h
		mov	bx, [hw]
		mov	dx, offset zero
		mov	cx, 2
		int	21h
		jc	errs

;-
		jmp	result
;-
;-
enc:
		mov	di, offset buffer
		mov	si, di
		mov	cx, 100h
		mov	ax, [axval]
		mov	dx, [dxval]
@@632:
		call	@@631
		loop	@@632
		ret
;-
@@631:
		db	60 dup (0c3h)
;-
writef:
		mov	ah, 40h
		mov	cx, 100h
		mov	dx, offset buffer
		mov	bx, [hw]
		int	21h
		jc	errs
		ret
;-
wrt:
		mov	ah, 3ch
		mov	dx, offset fn
		xor	cx, cx
		int	21h
		jc	errs
;-
		xchg	bx, ax
		mov	ah, 40h
		mov	dx, offset buffer
		mov	cx, [f_s]
		int	21h
		jc	errs
;-
		jmp	ext
;-
check:
		movsx	eax, [b_f_s]
		shl	eax, 16
		mov	ax, [f_s]
		sub	eax, 660h+170h-100h
		movzx	ebp, [tempsz]
		sub	eax, ebp
		mov	[tounpb], eax
		ret
;-
read_cod:
		movsx	eax, [cs_]
		shl	eax, 4
		add	eax, 170h
		mov	dx, ax
		shr	eax, 10h
		mov	cx, ax
;-
		mov	ax, 4200h
		mov	bx, [hr]
		int	21h
		jc	errs
;-
		mov	ah, 3fh
		mov	cx, 0ffffh
		mov	dx, offset buffer
		mov	bx, [hr]
		int	21h
		jc	errs
		mov	[tempsz], ax
;-
		ret
;-
beg:
		mov	dx, offset msg
		call	write
;-
		mov	si, 81h
		lodsb
		cmp	al, 0dh
		je	usage_
;-
		xor	ax, ax
		mov	si, 80h
		lodsb
		add	si, ax
		mov	cl, al
		xchg	si, di
		mov	byte ptr ds:[di], 0
;-
		mov	si, 82h
		mov	dx, si
;-
		mov	dx, offset pf
		call	write
;-
		mov	ah, 40h
		xor	ch, ch
		mov	bx, 1
		mov	dx, 82h
		int	21h
;-
		mov	ax, 3d02h
		mov	dx, 82h
		int	21h
		mov	[hr], ax
		jc	errs
;-
		mov	ax, 4202h
		xor	cx, cx
		xor	dx, dx
		mov	bx, [hr]
		int	21h
		jc	errs
;-
		mov	[f_s], ax
		mov	[b_f_s], dx
;-
		mov	ax, 4200h
		xor	cx, cx
		xor	dx, dx
		mov	bx, [hr]
		int	21h
		jc	errs
;-
		mov	ah, 3fh
		mov	dx, offset buffer
		mov	cx, 2ch
		mov	bx, [hr]
		int	21h
		jc	errs
;-
		mov	di, dx
		cmp	dword ptr ds:[di+20h], 20200a0dh
		jne	not_
		ret
;-
ip_check:
		xor	eax, eax
		mov	si, offset buffer+14h
		lodsw
		mov	[ip], ax
		lodsw
		mov	word ptr [cs_], ax
;-
		shl	eax, 4
;-
		movzx	ecx, word ptr ds:[buffer+8]
		shl	ecx, 4
		add	eax, ecx
;-
		ret
;-
write:
		mov	ah, 09h
		int	21h
		ret
;-
errs:
		mov	dx, offset errs_
		call	write
		jmp	ext
;-
not_:
		mov	dx, offset nt_
		call	write
		jmp	ext
;-
usage_:
		mov	dx, offset usage
		call	write
;-
ext:
		mov	ah, 4ch
		int	21h
;-
p_errs:
		mov	dx, offset p_err
		call	write
		jmp	ext
;-
result:
		mov	dx, offset cm
		call	write
		jmp	ext
;-
;-
msg		db	, 13, 10, 'FSE v0.6 *unpacker* (c) DarkGrey //[DTG]', 13, 10, 13, 10, '$'
usage		db	'Usage: unfse.com packed.exe', 13, 10, '$'
nt_		db	, 13, 10, 'This file is not crypted with FSE v0.6', 13, 10, '$'
pf		db	'Unpacking file: $'
cm		db	, 13, 10, 'Complete ! Result in out.exe...', 13, 10, '$'
errs_		db	'I/O Error !', 13, 10, '$'
p_err		db	, 13, 10, 'Polymorph decoding error !', 13, 10, '$'
fn		db	'out.exe', 0
cs_		dw	0
ip		dw	0
fucking_header	db	'MZ'
pcl		dw	0
pc		dw	0
mem		dd	0ffff0000h
zero		dw	0
temp		dw	0
tempsz		dw	0
f_s		dw	0
b_f_s		dw	0
sh		db	0
hr		dw	0
hw		dw	0
tmp		dw	0
axval		dw	0
dxval		dw	0
tounpb		dd	0
buffer		db	?
                end