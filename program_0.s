.data
	a:	.byte -48, -47, -96, -45, -44, -39, -36, -35 
		.byte -33, -32, -28, -27, -24, -23, -22, -20 
		.byte -19, -18, -14, -13, -11, -9, -7, -3 
		.byte -1, 0, 1, 3, 4, 9, 10, 11 
		.byte 12, 13, 14, 15, 17, 18, 19, 20 
		.byte 23, 24, 31, 36, 39, 40, 41, 43 
		.byte 45, 48
		
	b:	.byte 1, 5, -6, 8, 9, 12, 14, 15 
		.byte 17, 19, 21, 23, 24, 27, 28, 29
		.byte 31, 34, 35, 36, 41, 43, 45, 46 
		.byte 48, 50, 52, 54, 57, 62, 63, 66 
		.byte 69, 70, 71, 73, 74, 75, 77, 79 
		.byte 81, 82, 87, 89, 90, 91, 95, 97 
		.byte 98, 100
	
	c:	.space 50
	
	max: .byte 0
	min: .byte 0

.text

MAIN:
		daddi	r2, r0, 50			; r2 = 50
		
		daddi 	r1, r0, 0			; r1 = i = 0

		lb 	r5, max(r0)				; default valore massimo = 0, verra' cambiato nel primo ciclo
		lb	r6, min(r0)				; default valore minimo = 0, verra' cambiato nel primo ciclo

	loop:
		slt 	r3, r1, r2			; if(i < len) goto out
		beq 	r3, r0, out			; if(i == 0) goto out
		
		; inserimento nell'array c
		lb		r3, a(r1)			; r3 = a[i]
		lb		r4, b(r1)			; r4 = b[i]
		dadd 	r3, r3, r4			; r3 = a[i] + b[i]
		sb		r3, c(r1)			; c[i] = a[i] + b[i]
		
		; ricerca massimo
		slt 	r4, r5, r3			; if(max < c[i]) max = c[i]
		beq		r4, r0, min			; if(r4 == 0) goto min
		dadd 	r5, r3, r0			; else max = c[i]

		; ricerca minimo
		min:
			slt		r4, r3, r6				; if(c[i] < min) goto count_loop
			beq 	r4, r0, count_loop		; if(r4 == 0) goto count_loop
			dadd 	r6, r3, r0				; else min = c[i]
		
		; incremento indice
		count_loop:
			daddi	r1, r1, 1		; i += 1
			j loop

	out:
		sb r5, max(r0)
		sb r6, min(r0)
		halt