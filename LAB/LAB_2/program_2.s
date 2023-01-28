.data
	ifmap: .byte 0, 0, 0, 0, 0, 1, 2, 3, 0, 0, 4, 5, 6, 0, 0, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0
	kernel: .byte 0, -1, -1, 0, 2, 1, 1, 0, 4
	ofmap: .space 9
	
	
	; assunzione: dimensione del kernel sempre minore o uguale a quella dell'ifmap

.code

MAIN:
	daddi r2, r0, 5					; r2 = nuumero righe ifmap
	daddi r3, r0, 5					; r3 = numero colonne ifmap
	
	daddi r4, r0, 3					; r4 = numero righe kernel
	daddi r5, r0, 3					; r5 = numero colonne kernel
	
	dadd r1, r0, r0					; r1 = indice i di spostamento in ifmap
	
	dsub r6, r2, r4					; r6 = righe ifmap - righe kernel
	dsub r7, r3, r5					; r7 = colonne ifmap - colonne kernel
	daddi r6, r6, 1					; r6 += 1
	daddi r7, r7, 1					; r7 += 1
	dmul r6, r6, r7					; r6 = (righe ifmap - righe kernel + 1) * (colonne ifmap - colonne kernel + 1) = numero sottomatrici
	
	daddi r7, r0, 0					; r7 = 1 = indice per contare il numero di sottomatrici
	dsub r10, r2, r4				; r10 = numero righe ifmap - numero righe kernel
	
	loop:
		slt r8, r7, r6				; if(j >= numero sottomatrici) goto out
		beq r8, r0, out				; if(r8 == 1) goto out
		
		; loop unrolling (rappresenta le prossime tre sottomatrice sulla stessa riga)
			jal CALCOLA
			daddi r1, r1, 1			; i++
			sb r20, ofmap(r7)		; ofmap[j] = valore
			daddi r7, r7, 1			; j++
		
			jal CALCOLA
			daddi r1, r1, 1			; i++
			sb r20, ofmap(r7)		; ofmap[j] = valore
			daddi r7, r7, 1			; j++
			
			jal CALCOLA
			daddi r1, r1, 1			; i++
			sb r20, ofmap(r7)		; ofmap[j] = valore
			daddi r7, r7, 1			; j++
		
		
		dadd r1, r1, r10			; i += r10
		j loop
	
	out:
		halt

	
CALCOLA:
	dadd r9, r0, r0							; j = 0 = indice per il kernel
	dadd r11, r0, r0						; r11 = contatore righe in ifmap
	dadd r12, r0, r1						; i = index ifmap passato dal chiamante
	dadd r20, r0, r0						; valore = 0 = valore da inserire in ofmap
	
	while:
		slt r13, r11, r4					; if(contatore righe ifmap >= numero righe kernel) goto out_calcola
		beq r13, r0, calcola_out			; if(r13 == 1) goto out_calcola
		
		; loop unrolling (calcolo sulle prossime 3 colonne sulla stessa riga)
			lb r14, ifmap(r12)				; r14 = ifmap[i]
			lb r15, kernel(r9)				; r15 = kernel(j)
			dmul r16, r14, r15				; r16 = ifmap[i] * kernel[j]
			daddi r12, r12, 1				; i++
			daddi r9, r9, 1					; j++
			dadd r20, r20, r16				; r20 += ifmap[i] * kernel[j]
		
			lb r14, ifmap(r12)				; r14 = ifmap[i]
			lb r15, kernel(r9)				; r15 = kernel(j)
			dmul r16, r14, r15				; r16 = ifmap[i] * kernel[j]
			daddi r12, r12, 1				; i++
			daddi r9, r9, 1					; j++
			dadd r20, r20, r16				; r20 += ifmap[i] * kernel[j]
		
			lb r14, ifmap(r12)				; r14 = ifmap[i]
			lb r15, kernel(r9)				; r15 = kernel(j)
			dmul r16, r14, r15				; r16 = ifmap[i] * kernel[j]
			daddi r12, r12, 1				; i++
			daddi r9, r9, 1					; j++
			dadd r20, r20, r16				; r20 += ifmap[i] * kernel[j]
		
		daddi r11, r11, 1					; contatore righe += 1
		dadd r12, r12, r10					; i += offset
		j while
	
	calcola_out:
		jr r31