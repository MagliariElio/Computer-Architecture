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
	; software pipelining + register renaming + 2 loop unrolling

	daddi r1, r0, 472		; indice i = r1 = 480 = (8 byte * 60 posizioni - 8 byte)	indice decrescente
	daddi r2, r0, 464		; indice j = i-1 = 472-8 = 464								indice decrescente
	daddi r3, r0, 456		; indice m = i-2 = 472-16 = 456								indice decrescente
	
	daddi r4, r0, 112		; indice u = 112											indice crescente
	daddi r8, r0, 112		; indice v = 112											indice decrescente
	
	daddi r5, r0, 0			; indice l = 0												indice crescente
	daddi r6, r0, 8			; indice r = l+1											indice crescente
	daddi r7, r0, 16		; indice s = l+2											indice crescente
	
	l.d f1, v1(r1)		; f1 = v1[i]
	l.d f2, v2(r1)		; f2 = v2[i]
	l.d f3, v3(r1)		; f3 = v3[i]
	l.d f4, v4(r1)		; f4 = v4[i]
	
	l.d f8, v1(r5)		; f1 = v1[l]
	l.d f9, v2(r5)		; f2 = v2[l]
	l.d f10, v3(r5)		; f3 = v3[l]
	l.d f11, v4(r5)		; f4 = v4[l]
	
	
	add.d f5, f1, f2	; f5 = v1[i] + v2[i]
	add.d f12, f8, f9	; f12 = v1[j] + v2[j]
	;;;;;;;;;;;;;;;;;;;
	
	; secondo unroll
	l.d f15, v1(r8)		; f15 = v1[v]
	l.d f16, v2(r8)		; f16 = v2[v]
	l.d f17, v3(r8)		; f17 = v3[v]
	l.d f18, v4(r8)		; f18 = v4[v]
	
	;;;;;;;;;;;;;
	mul.d f6, f4, f1	; f6 = v4[i] * v1[i]
	mul.d f13, f11, f8	; f13 = v4[j] * v1[j]
	
	mul.d f5, f5, f3	; f5 = (v1[i] + v2[i]) * v3[i]
	mul.d f12, f12, f10	; f12 = (v1[j] + v2[j]) * v3[j]
	;;;;;;;;;;;;;;;;;;
	
	; terzo unroll
	l.d f22, v1(r4)		; f22 = v1[u]
	l.d f23, v2(r4)		; f23 = v2[u]
	l.d f24, v3(r4)		; f24 = v3[u]
	l.d f25, v4(r4)		; f25 = v4[u]
	
	; unroll
	add.d f19, f15, f16	; f19 = v1[v] + v2[v]
	add.d f26, f22, f23	; f26 = v1[u] + v2[u]
	
	;;;;;;;;;;;;;;;;;
	add.d f5, f5, f4	; f5 = ((v1[i] + v2[i]) * v3[i]) + v4[i]
	add.d f12, f12, f11	; f12 = ((v1[j] + v2[j]) * v3[j]) + v4[j]
	
	add.d f7, f2, f3	; f7 = v2[i] + v3[i]
	add.d f14, f9, f10	; f14 = v2[j] + v3[j]
	
	div.d f6, f5, f6	; f6 = v5[i] / (v4[i] * v1[i])
	;;;;;;;;;;;;;;;
	
	
	; unroll
	mul.d f20, f18, f15	; f20 = v4[v] * v1[v]
	mul.d f27, f25, f22	; f27 = v4[u] * v1[u]
	
	mul.d f19, f19, f17	; f19 = (v1[v] + v2[v]) * v3[v]
	mul.d f26, f26, f24	; f26 = (v1[u] + v2[u]) * v3[u]
	
	add.d f21, f16, f17	; f21 = v2[v] + v3[v]
	add.d f28, f23, f24	; f28 = v2[u] + v3[u]
	
	add.d f19, f19, f18	; f19 = ((v1[v] + v2[v]) * v3[v]) + v4[v]
	add.d f26, f26, f25	; f26 = ((v1[u] + v2[u]) * v3[u]) + v4[u]
	
	
	;;;;;;;;;;;;;
	mul.d f7, f6, f7	; f7 = v6[i] * (v2[i] + v3[i])
	mul.d f14, f13, f14	; f14 = v6[j] * (v2[j] + v3[j])
	
	div.d f13, f12, f13	; f13 = v5[j] / (v4[j] * v1[j])
	
	; unroll
	div.d f20, f19, f20	; f20 = v5[v] / (v4[v] * v1[v])
	
	s.d f19, v5(r8)		; v5[v] = f19
	s.d f20, v6(r8)		; v6[v] = f20
	s.d f21, v7(r8)		; v7[v] = f21
	s.d f26, v5(r4)		; v5[u] = f26
	
	div.d f27, f26, f27	; f27 = v5[u] / (v4[u] * v1[u])
	
	mul.d f21, f20, f21	; f21 = v6[v] * (v2[v] + v3[v])
	mul.d f28, f27, f28	; f28 = v6[u] * (v2[u] + v3[u])
	
	s.d f27, v6(r4)		; v6[u] = f27
	s.d f28, v7(r4)		; v7[u] = f28
	
	daddi r4, r4, 8		; u++
	daddi r8, r8, -8	; v--
	
	l.d f1, v1(r2)		; f1 = v1[i-1]
	l.d f2, v2(r2)		; f2 = v2[i-1]
	l.d f3, v3(r2)		; f3 = v3[i-1]
	l.d f4, v4(r2)		; f4 = v4[i-1]
	
	l.d f8, v1(r6)		; f8 = v1[l+1]
	l.d f9, v2(r6)		; f9 = v2[l+1]
	l.d f10, v3(r6)		; f10 = v3[l+1]
	l.d f11, v4(r6)		; f11 = v4[l+1]
	
	
	;add.d f5, f1, f2	; f5 = v1[i] + v2[i]
	;add.d f12, f8, f9	; f12 = v1[l] + v2[l]
	
	;mul.d f6, f4, f1	; f6 = v4[i-1] * v1[i-1]	
	;mul.d f13, f11, f8	; f13 = v4[l+1] * v1[l+1]
	;mul.d f5, f5, f3	; f5 = (v1[i-1] + v2[i-1]) * v3[i-1]
	;mul.d f12, f12, f10	; f12 = (v1[l+1] + v2[l+1]) * v3[l+1]
	
	;add.d f7, f2, f3	; f7 = v2[i-1] + v3[i-1]
	;add.d f14, f9, f10	; f14 = v2[l+1] + v3[l+1]
	
	;add.d f5, f5, f4	; f5 = ((v1[i-1] + v2[i-1]) * v3[i-1]) + v4[i-1]
	;add.d f12, f12, f11	; f12 = ((v1[l+1] + v2[l+1]) * v3[l+1]) + v4[l+1]
	
	;div.d f6, f5, f6	; f6 = v5[i-1] / (v4[i-1] * v1[i-1])
	
	;l.d f1, v1(r2)		; f1 = v1[i-1]
	;l.d f2, v2(r2)		; f2 = v2[i-1]
	;l.d f3, v3(r2)		; f3 = v3[i-1]
	;l.d f4, v4(r2)		; f4 = v4[i-1]
	
	;l.d f8, v1(r6)		; f1 = v1[l+1]
	;l.d f9, v2(r6)		; f2 = v2[l+1]
	;l.d f10, v3(r6)		; f3 = v3[l+1]
	;l.d f11, v4(r6)		; f4 = v4[l+1]
	
	;mul.d f7, f6, f7	; f7 = v6[i-1] * (v2[i-1] + v3[i-1])
	;div.d f13, f12, f13	; f13 = v5[l+1] / (v4[l+1] * v1[l+1])
	;mul.d f14, f13, f14	; f14 = v6[l+1] * (v2[l+1] + v3[l+1])
	
	loop:
		slt r9, r5, r8		; if(l < v) goto out
		beq r9, r0, out		; if(r9 == 1) goto out
		
		s.d f5, v5(r1)		; v5[i] = f5
		s.d f6, v6(r1)		; v6[i] = f6
		s.d f7, v7(r1)		; v7[i] = f7
		
		s.d f12, v5(r5)		; v5[l] = f12
		s.d f13, v6(r5)		; v6[l] = f13
		s.d f14, v7(r5)		; v7[l] = f14
		
		add.d f5, f1, f2	; f5 = v1[i] + v2[i]
		add.d f12, f8, f9	; f12 = v1[j] + v2[j]
		;;;;;;;;;;;;;;;;;;;
		
		; secondo unloop
		l.d f15, v1(r8)		; f15 = v1[v]
		l.d f16, v2(r8)		; f16 = v2[v]
		l.d f17, v3(r8)		; f17 = v3[v]
		l.d f18, v4(r8)		; f18 = v4[v]
		
		;;;;;;;;;;;;;
		mul.d f6, f4, f1	; f6 = v4[i] * v1[i]
		mul.d f13, f11, f8	; f13 = v4[j] * v1[j]
		
		mul.d f5, f5, f3	; f5 = (v1[i] + v2[i]) * v3[i]
		mul.d f12, f12, f10	; f12 = (v1[j] + v2[j]) * v3[j]
		;;;;;;;;;;;;;;;;;;
		
		; terzo unloop
		l.d f22, v1(r4)		; f22 = v1[u]
		l.d f23, v2(r4)		; f23 = v2[u]
		l.d f24, v3(r4)		; f24 = v3[u]
		l.d f25, v4(r4)		; f25 = v4[u]
		
		; unroll
		add.d f19, f15, f16	; f19 = v1[v] + v2[v]
		add.d f26, f22, f23	; f26 = v1[u] + v2[u]
		
		;;;;;;;;;;;;;;;;;
		add.d f5, f5, f4	; f5 = ((v1[i] + v2[i]) * v3[i]) + v4[i]
		add.d f12, f12, f11	; f12 = ((v1[j] + v2[j]) * v3[j]) + v4[j]
		
		add.d f7, f2, f3	; f7 = v2[i] + v3[i]
		add.d f14, f9, f10	; f14 = v2[j] + v3[j]
		
		div.d f6, f5, f6	; f6 = v5[i] / (v4[i] * v1[i])
		;;;;;;;;;;;;;;;
		
		
		; unroll
		mul.d f20, f18, f15	; f20 = v4[v] * v1[v]
		mul.d f27, f25, f22	; f27 = v4[u] * v1[u]
		
		mul.d f19, f19, f17	; f19 = (v1[v] + v2[v]) * v3[v]
		mul.d f26, f26, f24	; f26 = (v1[u] + v2[u]) * v3[u]
		
		add.d f21, f16, f17	; f21 = v2[v] + v3[v]
		add.d f28, f23, f24	; f28 = v2[u] + v3[u]
		
		add.d f19, f19, f18	; f19 = ((v1[v] + v2[v]) * v3[v]) + v4[v]
		add.d f26, f26, f25	; f26 = ((v1[u] + v2[u]) * v3[u]) + v4[u]
		
		
		;;;;;;;;;;;;;
		mul.d f7, f6, f7	; f7 = v6[i] * (v2[i] + v3[i])
		mul.d f14, f13, f14	; f14 = v6[j] * (v2[j] + v3[j])
		
		div.d f13, f12, f13	; f13 = v5[j] / (v4[j] * v1[j])
		
		; unroll
		div.d f20, f19, f20	; f20 = v5[v] / (v4[v] * v1[v])
	
		s.d f19, v5(r8)		; v5[v] = f19
		s.d f20, v6(r8)		; v6[v] = f20
		s.d f21, v7(r8)		; v7[v] = f21
		s.d f26, v5(r4)		; v5[u] = f26
		
		div.d f27, f26, f27	; f27 = v5[u] / (v4[u] * v1[u])
		
		mul.d f21, f20, f21	; f21 = v6[v] * (v2[v] + v3[v])
		mul.d f28, f27, f28	; f28 = v6[u] * (v2[u] + v3[u])
		
		s.d f27, v6(r4)		; v6[u] = f27
		s.d f28, v7(r4)		; v7[u] = f28
	
		daddi r4, r4, 8		; u++
		daddi r8, r8, -8	; v--
	
		daddi r3, r3, -8	; m--
		daddi r7, r7, 8		; s++
		
		daddi r1, r1, -8	; i--
		daddi r2, r2, -8	; j--
		daddi r5, r5, 8		; l++
		daddi r6, r6, 8		; r++
	
		j loop
		
	out:
		halt