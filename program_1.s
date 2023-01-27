.data	
	a:	.byte 32, 31, 29, 28, 27, 26, 1, 30 
		.byte 1, 26, 27, 28, 29, 31, 32
	
	result: .byte 0
	
.text

MAIN:
		daddi	r3, r0, 15				; r3 = 15
		daddi 	r4, r0, 2				; r4 = 2
		
		dadd 	r1, r0, r0				; r1 = i = 0
		daddi 	r2, r3, -1				; r2 = j = len - 1
		
		ddiv 	r3, r3, r4				; r3 = len / 2
		
	loop:
		beq 	r1, r3, out_true		; if(i == 0) goto out_true
		
		lb		r4, a(r1)				; r4 = a[i]
		lb		r5, a(r2)				; r5 = a[j]
		
		daddi	r1, r1, 1				; i += 1
		bne 	r4, r5, out_false		; if(a[i] != a[j]) goto out_false
		
		daddi	r2, r2, -1				; j -= 1
		j loop
		
	out_true:
		daddui 	r4, r0, 1				; true, l'array e' palindromo
		j out
	
	out_false:
		dadd 	r4, r0, r0				; false, l'array non e' palindromo
	
	out:
		sb r4, result(r0)
		halt