
		AREA morse_code, DATA, READONLY
Morse_Code	DCB "A", "J", "S", "2"
			DCB	"B", "K", "T", "3"
			DCB	"C", "L", "U", "4"
			DCB	"D", "M", "V", "5"
			DCB	"E", "N", "W", "6"
			DCB	"F", "O", "X", "7"
			DCB	"G", "P", "Y", "8"
			DCB	"H", "Q", "Z", "9"
			DCB	"I", "R", "1", "0"
			
Morse_Value	DCD 0xFFFFFF01, 0xFFFF0111, 0xFFFFF000, 0xFFF00111
			DCD	0xFFFF1000, 0xFFFFF101, 0xFFFFFFF1, 0xFFF00011
			DCD	0xFFFF1010, 0xFFFF0100, 0xFFFFF001, 0xFFF00001
			DCD	0xFFFFF100, 0xFFFFFF11, 0xFFFF0001, 0xFFF00000
			DCD	0xFFFFFFF0, 0xFFFFFF10, 0xFFFFF011, 0xFFF10000
			DCD	0xFFFF0010, 0xFFFFF111, 0xFFFF1001, 0xFFF11000
			DCD	0xFFFFF110, 0xFFFF0110, 0xFFFF1011, 0xFFF11100
			DCD	0xFFFF0000, 0xFFFF1101, 0xFFFF1100, 0xFFF11110
			DCD	0xFFFFFF00, 0xFFFFF010, 0xFFF01111, 0xFFF11111
		
		AREA asm_functions, CODE, READONLY
vett_input			RN	R0						;morse code vector to convert
vett_input_length 	RN	R1						;length of the vector to convert
vett_output 		RN	R2						;ASCII output vector
vett_output_length	RN	R3						;length of the output vector
change_symbol		RN	R4						;the value representing the change of symbol in the input vector
space 				RN	R5						;the value representing the space in the input vector
sentence_end		RN	R6						;the value representing the end of the sentence in the input vector
i					RN	R7
value				RN	R8
translation			RN	R10
j					RN	R11						;index for vett_output

                
translate_morse	PROC
				EXPORT  translate_morse
				MOV   R12, sp
				STMFD sp!,{R4-R8,R10-R11,lr}				
				
				LDR   R4, [R12]						
				LDR   R5, [R12,#4]
				LDR   R6, [R12, #8]
				
				
				MOV i, #0								;i = 0
				MOV j, #0								;j = 0
				MOV translation, #0xFFFFFFFF			;translation is register containg 0 and 1 translated from value
loop
				CMP i, vett_input_length				;if(i >= vett_input_length) goto exit
				BHS exit
				
				LDRB value, [vett_input, i]				;value = vet_input[i]
				ADD i, #1		
				
check_0				
				CMP value, #0x30						;if(value.equal("0") == 1) only shift
				LSLEQ translation, #4
				BEQ loop
check_1			
				CMP value, #0x31						;if(value.equal("1") == 1) shift and insert 1
				LSLEQ translation, #4
				EOREQ translation, #0x1					;last 4 bits are 0001
				BEQ loop
check_change
				CMP value, change_symbol				;if(value.equal("2") == 1) translate and push it into vett_output
				BLEQ translator
				MOVEQ translation, #0xFFFFFFFF
				BEQ loop
check_space				
				CMP value, space						;if(value.equal("3") == 1) insert into vett_out a space
				BLEQ translator
				MOVEQ translation, #0xFFFFFFFF
				MOVEQ value, #0x20
				STREQ value, [vett_output, j]			;vett_output[j] = " "
				ADDEQ j, #1
				BEQ loop
check_end		
				CMP value, sentence_end					;if(value.equal("4") == 1) goto exit
				BLEQ translator
				BEQ exit
				
				B loop
exit				
				MOV vett_output_length, j
				SUB R0, j, #1							;RES
				
				LDMFD sp!,{R4-R8,R10-R11,pc}
				BX lr
				ENDP

translator		PROC
				STMFD sp!,{R0-R10,lr}
				
				LDR vett_input, =Morse_Value
				MOV i, #0
				MOV vett_input_length, #36
loop_translate	
				CMP i, vett_input_length				;if(i >= vett_input_length) goto exit
				BHS exit_loop
				
				LDR value, [vett_input, i, LSL #2]		;val = vett_input[i]	in Morse_Value
				
				CMP translation, value					;if(vett_input[i] == translation) translation = Morse_Code[i]
				ADDNE i, #1								;i++ if not equal
				BNE loop_translate
				
				LDR vett_input, =Morse_Code
				LDRB translation, [vett_input, i]		;translation = vett_input[i]	in Morse_Code
				
				STRB translation, [vett_output, j]		;vett_output[j] = translation
				ADD j, #1								;j++
				
exit_loop		
				LDMFD sp!,{R0-R10,pc}
				BX lr
				ENDP
	
				END

;int translate_morse(char* vett_input, 			R0
;					int vett_input_lenght, 		R1
;					char[] vett_output, 		R2
;					int vett_output_lenght, 	R3
;					char change_symbol, 		R4
;					char space, 				R5
;					char sentence_end);			R6
