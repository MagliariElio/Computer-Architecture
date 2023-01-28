



				AREA my_area, CODE, READONLY

				EXPORT  check_square
x		RN		R0		;argument to check and result
y		RN		R1		;argument to check
r		RN		R2		;argument to check					
					
check_square
				STMFD sp!, {r4-r8, r10-r11, lr}				
				
				MUL x, x, x				;x = x*x
				MLA x, y, y, x			;x = y*y + x^2
				MUL r, r, r				;r = r*r
				
				CMP x, r
				MOVHI x, #0x0
				MOVLS x, #0x1
				
				LDMFD sp!, {r4-r8, r10-r11, pc}
                END