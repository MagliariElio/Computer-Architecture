.data
	v1: .double 0.471, 0.511, 0.909, 0.457,	0.591, 0.546, 0.645, 0.716
		.double 0.977, 0.122, 0.163, 0.823,	0.441, 0.499, 0.609, 0.663	
		.double 0.076, 0.339, 0.970, 0.832, 0.441, 0.096, 0.171, 0.482 
		.double 0.510, 0.260, 0.848, 0.952, 0.499, 0.726, 0.959, 0.675 
		.double 0.197, 0.513, 0.622, 0.429, 0.872, 0.779, 0.354, 0.845 
		.double 0.202, 0.875, 0.013, 0.431, 0.277, 0.734, 0.632, 0.339 
		.double 0.730, 0.764, 0.375, 0.212,	0.531, 0.584, 0.067, 0.705 
		.double 0.548, 0.854, 0.589, 0.291
	
	v2: .double 0.471, 0.511, 0.909, 0.457,	0.591, 0.546, 0.645, 0.716
		.double 0.977, 0.122, 0.163, 0.823,	0.441, 0.499, 0.609, 0.663	
		.double 0.076, 0.339, 0.970, 0.832, 0.441, 0.096, 0.171, 0.482 
		.double 0.510, 0.260, 0.848, 0.952, 0.499, 0.726, 0.959, 0.675 
		.double 0.197, 0.513, 0.622, 0.429, 0.872, 0.779, 0.354, 0.845 
		.double 0.202, 0.875, 0.013, 0.431, 0.277, 0.734, 0.632, 0.339 
		.double 0.730, 0.764, 0.375, 0.212,	0.531, 0.584, 0.067, 0.705 
		.double 0.548, 0.854, 0.589, 0.291
		
	v3: .double 0.471, 0.511, 0.909, 0.457,	0.591, 0.546, 0.645, 0.716
		.double 0.977, 0.122, 0.163, 0.823,	0.441, 0.499, 0.609, 0.663
		.double 0.076, 0.339, 0.970, 0.832, 0.441, 0.096, 0.171, 0.482
		.double 0.510, 0.260, 0.848, 0.952, 0.499, 0.726, 0.959, 0.675
		.double 0.197, 0.513, 0.622, 0.429, 0.872, 0.779, 0.354, 0.845
		.double 0.202, 0.875, 0.013, 0.431, 0.277, 0.734, 0.632, 0.339
		.double 0.730, 0.764, 0.375, 0.212,	0.531, 0.584, 0.067, 0.705
		.double 0.548, 0.854, 0.589, 0.291
		
	v4: .double 0.471, 0.511, 0.909, 0.457,	0.591, 0.546, 0.645, 0.716
		.double 0.977, 0.122, 0.163, 0.823,	0.441, 0.499, 0.609, 0.663	
		.double 0.076, 0.339, 0.970, 0.832, 0.441, 0.096, 0.171, 0.482 
		.double 0.510, 0.260, 0.848, 0.952, 0.499, 0.726, 0.959, 0.675 
		.double 0.197, 0.513, 0.622, 0.429, 0.872, 0.779, 0.354, 0.845 
		.double 0.202, 0.875, 0.013, 0.431, 0.277, 0.734, 0.632, 0.339 
		.double 0.730, 0.764, 0.375, 0.212,	0.531, 0.584, 0.067, 0.705 
		.double 0.548, 0.854, 0.589, 0.291
	
		
	v5: .space 480	
	v6: .space 480
	v7: .space 480
	
.text

MAIN:
	daddi r1, r0, 472		; indice i = r1 = 480 = (8 byte * 60 posizioni) indice decrescente
	daddi r2, r0, 0			; indice j = r2 = 0 (indice crescente)
	
	; unrollo il loop replicandolo due volte ed eseguo un
	; register renaming per rendere il secondo corpo indipendente
	; dall'uso dei stessi registri
	
	loop:
		slt r3, r1, r2		; if(i < j) goto out
		bne r3, r0, out		; if(r3 == 1) goto out
		
		l.d f1, v1(r1)		; f1 = v1[i]
		l.d f2, v2(r1)		; f2 = v2[i]
		l.d f3, v3(r1)		; f3 = v3[i]
		l.d f4, v4(r1)		; f4 = v4[i]
		
		l.d f8, v1(r2)		; f8 = v1[j]
		l.d f9, v2(r2)		; f9 = v2[j]
		l.d f10, v3(r2)		; f10 = v3[j]
		l.d f11, v4(r2)		; f11 = v4[j]
		
		add.d f5, f1, f2	; f5 = v1[i] + v2[i]
		add.d f12, f8, f9	; f12 = v1[j] + v2[j]
		
		mul.d f6, f4, f1	; f6 = v4[i] * v1[i]
		mul.d f13, f11, f8	; f13 = v4[j] * v1[j]
		
		mul.d f5, f5, f3	; f5 = (v1[i] + v2[i]) * v3[i]
		mul.d f12, f12, f10	; f12 = (v1[j] + v2[j]) * v3[j]
		
		add.d f7, f2, f3	; f7 = v2[i] + v3[i]
		add.d f14, f9, f10	; f14 = v2[j] + v3[j]
		
		add.d f5, f5, f4	; f5 = ((v1[i] + v2[i]) * v3[i]) + v4[i]
		add.d f12, f12, f11	; f12 = ((v1[j] + v2[j]) * v3[j]) + v4[j]
		
		s.d f5, v5(r1)		; v5[i] = f5
		s.d f12, v5(r2)		; v5[j] = f12
		
		
		; operazioni molto lente a causa delle dipendenze tra dato e 
		; dell'intervallo di ripetizione molto alto per l'operazione di divisione
		
		div.d f6, f5, f6	; f6 = v5[i] / (v4[i] * v1[i])									; spostare la div dopo s.d f5
		mul.d f7, f6, f7	; f7 = v6[i] * (v2[i] + v3[i])
		
		div.d f13, f12, f13	; f13 = v5[j] / (v4[j] * v1[j])
		mul.d f14, f13, f14	; f14 = v6[j] * (v2[j] + v3[j])
		
		s.d f6, v6(r1)		; v6[i] = f6
		s.d f7, v7(r1)		; v7[i] = f7
		
		daddi r1, r1, -8	; i--
		
		s.d f13, v6(r2)		; v6[j] = f13
		s.d f14, v7(r2)		; v7[j] = f14
		
		daddi r2, r2, 8		; j++
		
		j loop
		
	out:
		nop
		halt