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
	daddi r1, r0, 472		; indice i = r1 = 472 = (8 byte * 60 posizioni - 8 byte) 	indice decrescente
	daddi r2, r0, 0			; indice j = r2 = 0 										indice crescente
	daddi r3, r0, 112		; indice k = r3 = 112 = (8 byte * 15 posizioni - 8 byte) 	indice decrescente	
	daddi r4, r0, 112		; indice m = r4 = 112 = (8 byte * 15 posizioni - 8 byte) 	indice crescente
	
	
	loop:
		slt r5, r3, r2		; if(j > k) goto out
		bne r5, r0, out		; if(r5 == 1) goto out
		
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
		;;;;;;;;;;;;;;;;;;;
		
		; secondo unroll
		l.d f15, v1(r3)		; f15 = v1[k]
		l.d f16, v2(r3)		; f16 = v2[k]
		l.d f17, v3(r3)		; f17 = v3[k]
		l.d f18, v4(r3)		; f18 = v4[k]
		
		;;;;;;;;;;;;;
		mul.d f6, f4, f1	; f6 = v4[i] * v1[i]
		mul.d f13, f11, f8	; f13 = v4[j] * v1[j]
		
		mul.d f5, f5, f3	; f5 = (v1[i] + v2[i]) * v3[i]
		mul.d f12, f12, f10	; f12 = (v1[j] + v2[j]) * v3[j]
		;;;;;;;;;;;;;;;;;;
		
		; terzo unroll
		l.d f22, v1(r4)		; f22 = v1[m]
		l.d f23, v2(r4)		; f23 = v2[m]
		l.d f24, v3(r4)		; f24 = v3[m]
		l.d f25, v4(r4)		; f25 = v4[m]
		
		; unroll
		add.d f19, f15, f16	; f19 = v1[k] + v2[k]
		add.d f26, f22, f23	; f26 = v1[m] + v2[m]
		
		;;;;;;;;;;;;;;;;;
		add.d f5, f5, f4	; f5 = ((v1[i] + v2[i]) * v3[i]) + v4[i]
		add.d f12, f12, f11	; f12 = ((v1[j] + v2[j]) * v3[j]) + v4[j]
		
		add.d f7, f2, f3	; f7 = v2[i] + v3[i]
		add.d f14, f9, f10	; f14 = v2[j] + v3[j]
		
		div.d f6, f5, f6	; f6 = v5[i] / (v4[i] * v1[i])
		;;;;;;;;;;;;;;;
		
		
		; unroll
		mul.d f20, f18, f15	; f20 = v4[k] * v1[k]
		mul.d f27, f25, f22	; f27 = v4[m] * v1[m]
		
		mul.d f19, f19, f17	; f19 = (v1[k] + v2[k]) * v3[k]
		mul.d f26, f26, f24	; f26 = (v1[m] + v2[m]) * v3[m]
		
		add.d f21, f16, f17	; f21 = v2[k] + v3[k]
		add.d f28, f23, f24	; f28 = v2[m] + v3[m]
		
		add.d f19, f19, f18	; f19 = ((v1[k] + v2[k]) * v3[k]) + v4[k]
		add.d f26, f26, f25	; f26 = ((v1[m] + v2[m]) * v3[m]) + v4[m]
		
		
		;;;;;;;;;;;;;
		mul.d f7, f6, f7	; f7 = v6[i] * (v2[i] + v3[i])
		s.d f5, v5(r1)		; v5[i] = f5
		s.d f12, v5(r2)		; v5[j] = f12
		mul.d f14, f13, f14	; f14 = v6[j] * (v2[j] + v3[j])
		
		div.d f13, f12, f13	; f13 = v5[j] / (v4[j] * v1[j])
		
		s.d f6, v6(r1)		; v6[i] = f6
		s.d f7, v7(r1)		; v7[i] = f7
		
		daddi r1, r1, -8	; i--
		;;;;;;;;;;;;;
		
		; unroll
		div.d f20, f19, f20	; f20 = v5[k] / (v4[k] * v1[k])
		
		;;;;;;;;;;;;;
		s.d f13, v6(r2)		; v6[j] = f13
		s.d f14, v7(r2)		; v7[j] = f14
		
		daddi r2, r2, 8		; j++
		;;;;;;;;;;;;;
		
		; unroll
		div.d f27, f26, f27	; f27 = v5[m] / (v4[m] * v1[m])
		
		mul.d f21, f20, f21	; f21 = v6[k] * (v2[k] + v3[k])
		
		s.d f19, v5(r3)		; v5[k] = f19
		s.d f26, v5(r4)		; v5[m] = f26
		s.d f20, v6(r3)		; v6[k] = f20
		s.d f21, v7(r3)		; v7[k] = f21
		daddi r3, r3, -8	; k--
		
		mul.d f28, f27, f28	; f28 = v6[m] * (v2[m] + v3[m])
		
		s.d f27, v6(r4)		; v6[m] = f27
		s.d f28, v7(r4)		; v7[m] = f28
		
		j loop
		
	out:
		daddi r4, r4, 8		; m++			considerando il branch deloy slot attivo, 
							;				altrimenti ci sarebbe stata una nop e l'incremento del contatore sarebbe stato nel loop
		halt