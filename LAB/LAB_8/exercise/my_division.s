

				AREA my_area_division, CODE, READONLY
	
                EXPORT  my_division
my_division
				STMFD sp!, {r4-r7, lr}
				
				LDR R0, [R0]
				LDR R1, [R1]
				
				IMPORT __aeabi_fdiv
				BL __aeabi_fdiv
				
				LDMFD sp!, {r4-r7, pc}
                END