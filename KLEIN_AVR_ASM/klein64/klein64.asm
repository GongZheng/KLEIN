
;*******************klein64**********************
;;;develop on atmega16  with avr studio
;;;*****************interface********************
;;;"round_key: .BYTE 10" store the key
;;;"state: .BYTE 8" store the plaintext
;;;"cipher: .BYTE 8" store the ciphertext
;;;change the procedures "encrypt_input" or "decrypt_input" to assign different key and plaintext
;;;call the procedures "encrypt" or "decrypte" directly to encrypt or decrypt the message 



.INCLUDE "M16DEF.INC"
.ORG $0000 
RJMP RESET           
.ORG $0013           
 
RESET: 
LDI R16,LOW(RAMEND)  ;RAMEND=$04KL5F
OUT SPL,R16 
LDI R16,HIGH(RAMEND) 
OUT SPH,R16


 
encrypt:
ldi r18,$0c  ;12 rounds
ldi r19,$01  ;first round
rcall encrypt_input
encrypt_start:
rcall add_round_key
rcall key_schedule
rcall substitute_sbox
rcall rotatenibbles
rcall mixnibbles
inc r19
dec r18
brne encrypt_start

;xored by the whitenning key, output the ciphertext;
ldi r27,high(round_key) ;round_key->x
ldi r26,low(round_key) 
ldi r29,high(cipher); cipher->y
ldi r28,low(cipher)
ldi r31,high(state); state->z
ldi r30,low(state)

ld  r16,x+             ;cipher[0] = state[0] ^ round_key[0];
ld  r17,z+
eor r16,r17
st y+,r16
ld  r16,x+             ;cipher[1] = state[1] ^ round_key[1];
ld  r17,z+
eor r16,r17
st y+,r16
ld  r16,x+             ;cipher[2] = state[2] ^ round_key[2];
ld  r17,z+
eor r16,r17
st y+,r16
ld  r16,x+             ;cipher[3] = state[3] ^ round_key[3];
ld  r17,z+
eor r16,r17
st y+,r16
ld  r16,x+             ;cipher[4] = state[4] ^ round_key[4];
ld  r17,z+
eor r16,r17
st y+,r16
ld  r16,x+             ;cipher[5] = state[5] ^ round_key[5];
ld  r17,z+
eor r16,r17
st y+,r16
ld  r16,x+             ;cipher[6] = state[6] ^ round_key[6];
ld  r17,z+
eor r16,r17
st y+,r16
ld  r16,x+             ;cipher[7] = state[7] ^ round_key[7];
ld  r17,z+
eor r16,r17
st y,r16
ret




decrypt:
ldi r18,$0c  ;16 rounds
ldi r19,$01  ;first round
rcall decrypt_input
key_expansion:
rcall key_schedule
inc r19
dec r18
brne key_expansion

;xored by the whitenning key
ldi r27,high(round_key) ;round_key->x
ldi r26,low(round_key) 
ldi r29,high(cipher); cipher->y
ldi r28,low(cipher)
ldi r31,high(state); state->z
ldi r30,low(state)
ld  r16,x+             ;state[0] = cipher[0] ^ round_key[0];
ldd r17,y+0
eor r16,r17
st z+,r16
ld  r16,x+             ;state[1] = cipher[1] ^ round_key[1];
ldd  r17,y+1
eor r16,r17
st z+,r16
ld  r16,x+             ;state[2] = cipher[2] ^ round_key[2];
ldd  r17,y+2
eor r16,r17
st z+,r16
ld  r16,x+             ;state[3] = cipher[3] ^ round_key[3];
ldd  r17,y+3
eor r16,r17
st z+,r16
ld  r16,x+             ;state[4] = cipher[4] ^ round_key[4];
ldd  r17,y+4
eor r16,r17
st z+,r16
ld  r16,x+             ;state[5] = cipher[5] ^ round_key[5];
ldd  r17,y+5
eor r16,r17
st z+,r16
ld  r16,x+             ;state[6] = cipher[6] ^ round_key[6];
ldd  r17,y+6
eor r16,r17
st z+,r16
ld  r16,x+             ;state[7] = cipher[7] ^ round_key[7];
ldd  r17,y+7
eor r16,r17
st z,r16

ldi r18,$0c  ;12 rounds
ldi r19,$00  ;first round
inverse_rounds:
rcall inverse_mixnibbles
rcall substitute_sbox
rcall reverse_round_key
rcall add_round_key
inc r19
dec r18
brne inverse_rounds
ret

decrypt_input:
;initialize the key 
ldi r27,high(round_key) ;round_key->x
ldi r26,low(round_key) 
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x,r16
ret

encrypt_input:
;initialize the key 
ldi r27,high(round_key) ;round_key->x
ldi r26,low(round_key) 
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x+,r16
ldi r16,$00
st  x,r16
;initialize the state
ldi r27,high(state) ;state->x
ldi r26,low(state) 
ldi r16,$0ff
st  x+,r16
ldi r16,$0ff
st  x+,r16
ldi r16,$0ff
st  x+,r16
ldi r16,$0ff
st  x+,r16
ldi r16,$0ff
st  x+,r16
ldi r16,$0ff
st  x+,r16
ldi r16,$0ff
st  x+,r16
ldi r16,$0ff
st  x,r16
ret

add_round_key:
ldi r27,high(round_key) ;round_key->x
ldi r26,low(round_key) 
ldi r31,high(state)      ;state->z
ldi r30,low(state)
ld r2,x+            ;state[0] = state[0] ^ round_key[0];
ld r3,z
eor r2,r3
st  z+,r2
ld r2,x+            ;state[1] = state[1] ^ round_key[1];
ld r3,z
eor r2,r3
st  z+,r2
ld r2,x+            ;state[2] = state[2] ^ round_key[2];
ld r3,z
eor r2,r3
st  z+,r2
ld r2,x+            ;state[3] = state[3] ^ round_key[3];
ld r3,z
eor r2,r3
st  z+,r2
ld r2,x+            ;state[4] = state[4] ^ round_key[4];
ld r3,z
eor r2,r3
st  z+,r2
ld r2,x+            ;state[5] = state[5] ^ round_key[5];
ld r3,z
eor r2,r3
st  z+,r2
ld r2,x+            ;state[6] = state[6] ^ round_key[6];
ld r3,z
eor r2,r3
st  z+,r2
ld r2,x+            ;state[7] = state[7] ^ round_key[7];
ld r3,z
eor r2,r3
st  z,r2
ret


key_schedule:
ldi r27,high(round_key) ;round_key->x
ldi r26,low(round_key) 
ldi r29,high(temp_state); temp_state->y
ldi r28,low(temp_state)

ld  r16,x+        		;temp_state[0] = round_key[0]
st  y+,r16
ld  r16,x+				;temp_state[1] = round_key[1]
st  y+,r16
ld  r16,x+				;temp_state[2] = round_key[2]
st  y+,r16
ld  r16,x+				;temp_state[3] = round_key[3]
st  y+,r16
ld  r16,x				;temp_state[4] = round_key[4]
st  y,r16

ldi r27,high(round_key) ;round_key->x
ldi r26,low(round_key) 
ldi r29,high(round_key) ;round_key->y
ldi r28,low(round_key)

ldd r16,y+5             ;round_key[0] = round_key[5]
st	x+,r16
ldd r16,y+6				;round_key[1] = round_key[6]
st  x+,r16
ldd r16,y+7				;round_key[2] = round_key[7] ^ i
eor r16,r19
st  x+,r16 
ldd r16,y+4				;round_key[3] = round_key[4]
st  x,r16

ldi r27,high(temp_state);temp_state->x
ldi r26,low(temp_state)
inc r26 
ldi r29,high(round_key) ;round_key->y
ldi r28,low(round_key)

ld  r16,x+             ;round_key[4] = temp_state[1] ^ round_key[5]
ldd r17,y+5
eor r16,r17
std y+4,r16

ld  r16,x+			   ;round_key[5] = sbox8[temp_state[2] ^ round_key[6]];
ldd r17,y+6
eor r16,r17
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
std y+5,r16

ld  r16,x			   ;round_key[5] = sbox8[temp_state[2] ^ round_key[6]];
ldd r17,y+7
eor r16,r17
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
std y+6,r16

ldi r31,high(temp_state);temp_state->z
ldi r30,low(temp_state)

ldd r16,z+0				;round_key[7] = temp_state[0] ^ temp_state[4];
ldd r17,z+4
eor r16,r17
std y+7,r16
ret
 
reverse_round_key:
ldi r29,high(round_key) ;round_key->y
ldi r28,low(round_key) 
ldi r27,high(temp_state); temp_state->x
ldi r26,low(temp_state)

inc r26
inc r26
inc r26
inc r26
ldd r16,y+4     		    ;temp_state[4] = round_key[4]
st   x+,r16
ldd  r16,y+5				;temp_state[5] = round_key[5]
st  x+,r16
ldd  r16,y+6				;temp_state[6] = round_key[6]
st  x+,r16
ldd  r16,y+7				;temp_state[7] = round_key[7]
st  x,r16


ldi r29,high(round_key) ;round_key->y
ldi r28,low(round_key)
ldd r16,y+3             ;round_key[4] = round_key[3]
std	y+4,r16
ldd r16,y+0		     	;round_key[5] = round_key[0]
std y+5,r16
ldd r16,y+1		   	    ;round_key[6] = round_key[1]
std y+6,r16
ldd r16,y+2			    ;round_key[7] = round_key[2] ^ (round-i)
ldi r17,$0c
sub r17,r19
eor r16,r17
std  y+7,r16 

ldi r27,high(temp_state);temp_state->x
ldi r26,low(temp_state)
ldi r29,high(round_key) ;round_key->y
ldi r28,low(round_key)
inc r26
inc r26
inc r26
inc r26
ld  r16,x+             ;round_key[1] = temp_state[4] ^ round_key[5]
ldd r17,y+5
eor r16,r17
std y+1,r16
ld  r16,x+			   ;round_key[2] = sbox8[temp_state[5] ]^ round_key[6];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
ldd r17,y+6
eor r16,r17
std y+2,r16
ld  r16,x+			   ;round_key[3] = sbox8[temp_state[6] ]^ round_key[7];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
ldd r17,y+7
eor r16,r17
std y+3,r16
ld  r16,x+             ;round_key[0] = temp_state[7] ^ round_key[4]
ldd r17,y+4
eor r16,r17
st  y,r16
ret





substitute_sbox:
ldi r27,high(state)      ;state->x
ldi r26,low(state)

ld r16,x               ;state[0] = sbox8[state[0]];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
st x+,r16
ld r16,x               ;state[1] = sbox8[state[1]];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
st x+,r16
ld r16,x               ;state[2] = sbox8[state[2]];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
st x+,r16
ld r16,x               ;state[3] = sbox8[state[3]];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
st x+,r16
ld r16,x               ;state[4] = sbox8[state[4]];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
st x+,r16
ld r16,x               ;state[5 = sbox8[state[5]];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
st x+,r16
ld r16,x               ;state[6] = sbox8[state[6]];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
st x+,r16
ld r16,x               ;state[7] = sbox8[state[7]];
ldi r31,high(sbox<<1)
mov r30,r16
lpm r16,z
st x,r16
ret

rotatenibbles:
LDI R27,HIGH(temp_state)       ;temp_state->x
LDI R26,LOW(temp_state)
LDI R29,HIGH(state)            ;state->y
LDI R28,LOW(state)

LDD R16,Y+2                    ;temp_state[0] = state[2];
ST X+,R16 
LDD R16,Y+3                    ;temp_state[1] = state[3];
ST X+,R16 
LDD R16,Y+4                    ;temp_state[2] = state[4];
ST X+,R16 
LDD R16,Y+5                    ;temp_state[3] = state[5];
ST X+,R16 
LDD R16,Y+6                    ;temp_state[4] = state[6];
ST X+,R16 
LDD R16,Y+7                    ;temp_state[5] = state[7];
ST X+,R16 
LDD R16,Y+0                    ;temp_state[6] = state[0];
ST X+,R16 
LDD R16,Y+1                    ;temp_state[7] = state[1];
ST X,R16 
ret

mixnibbles:
ldi r27,high(state)                 ;state->x
ldi r26,low(state)  
ldi r29,high(temp_state)            ;temp_state->y
ldi r28,low(temp_state)
ldd r16,y+0	                ; u = temp_state[0] ^ temp_state[1] ^ temp_state[2] ^ temp_state[3];
ldd r17,y+1
eor r16,r17
ldd r17,y+2
eor r16,r17
ldd r17,y+3
eor r16,r17
ldd r14,y+0	                ;v = temp_state[0] ^ temp_state[1];          
ldd r15,y+1
eor r14,r15
ldi r31,high(multiply2<<1) ;v = multiply2[v];
mov r30,r14
lpm r14,z
ldd r12,y+0                ;state[0] = temp_state[0] ^ v ^ u;
eor r14,r12
eor r14,r16
st  x+,r14
ldd r14,y+1	                ;v = temp_state[1] ^ temp_state[2];          
ldd r15,y+2
eor r14,r15
ldi r31,high(multiply2<<1) ;v = multiply2[v];
mov r30,r14
lpm r14,z
ldd r12,y+1                ;state[1] = temp_state[1] ^ v ^ u;
eor r14,r12
eor r14,r16
st x+,r14
ldd r14,y+2	                ;v = temp_state[2] ^ temp_state[3];          
ldd r15,y+3
eor r14,r15
ldi r31,high(multiply2<<1) ;v = multiply2[v];
mov r30,r14
lpm r14,z
ldd r12,y+2                ;state[2] = temp_state[2] ^ v ^ u;
eor r14,r12
eor r14,r16
st x+,r14
ldd r14,y+3	                ;v = temp_state[3] ^ temp_state[0];          
ldd r15,y+0
eor r14,r15
ldi r31,high(multiply2<<1) ;v = multiply2[v];
mov r30,r14
lpm r14,z
ldd r12,y+3                ;state[3] = temp_state[3] ^ v ^ u;
eor r14,r12
eor r14,r16
st x+,r14
ldd r16,y+4	                ; u = temp_state[4] ^ temp_state[5] ^ temp_state[6] ^ temp_state[7];
ldd r17,y+5
eor r16,r17
ldd r17,y+6
eor r16,r17
ldd r17,y+7
eor r16,r17
ldd r14,y+4	                ;v = temp_state[4] ^ temp_state[5];          
ldd r15,y+5
eor r14,r15
ldi r31,high(multiply2<<1) ;v = multiply2[v];
mov r30,r14
lpm r14,z
ldd r12,y+4                ;state[4] = temp_state[4] ^ v ^ u;
eor r14,r12
eor r14,r16
st x+,r14
ldd r14,y+5	                ;v = temp_state[5] ^ temp_state[6];          
ldd r15,y+6
eor r14,r15
ldi r31,high(multiply2<<1) ;v = multiply2[v];
mov r30,r14
lpm r14,z
ldd r12,y+5                ;state[5] = temp_state[5] ^ v ^ u;
eor r14,r12
eor r14,r16
st x+,r14
ldd r14,y+6	                ;v = temp_state[6] ^ temp_state[7];          
ldd r15,y+7
eor r14,r15
ldi r31,high(multiply2<<1) ;v = multiply2[v];
mov r30,r14
lpm r14,z
ldd r12,y+6                ;state[6] = temp_state[6] ^ v ^ u;
eor r14,r12
eor r14,r16
st x+,r14
ldd r14,y+7	                ;v = temp_state[7] ^ temp_state[4];          
ldd r15,y+4
eor r14,r15
ldi r31,high(multiply2<<1) ;v = multiply2[v];
mov r30,r14
lpm r14,z
ldd r12,y+7                ;state[7] = temp_state[7] ^ v ^ u;
eor r14,r12
eor r14,r16
st x,r14
ret

inverse_mixnibbles:
ldi r27,high(temp_state)       ;temp_state->x
ldi r26,low(temp_state)
ldi r29,high(state)            ;state->y
ldi r28,low(state)
ldd r16,y+0                    ;temp_state[0] = state[0];
st  x+,R16 
ldd r16,y+1                    ;temp_state[1] = state[1];
st  x+,r16 
ldd r16,y+2                    ;temp_state[2] = state[2];
st  x+,r16 
ldd r16,y+3                    ;temp_state[3] = state[3];
st  x+,r16 
ldd r16,y+4                    ;temp_state[4] = state[4];
st  x+,r16 
ldd r16,y+5                    ;temp_state[5] = state[5];
st  x+,r16 
ldd r16,y+6                    ;temp_state[6] = state[6];
st  x+,r16 
ldd r16,y+7                    ;temp_state[7] = state[7];
st  x,r16 
ldi r27,high(temp_state)       ;temp_state->x
ldi r26,low(temp_state)
ld  r16,x+
ld  r10,x+                   ;u1 = multiply2[multiply2[temp_state[0] ^ temp_state[2]]];
ld  r17,x+
eor r16,r17 
ldi r31,high(multiply2<<1)   
mov r30,r16
lpm r14,z                    
ldi r31,high(multiply2<<1)
mov r30,r14
lpm r14,z                      ;u1=r14
ldi r27,high(temp_state)       ;temp_state->x
ldi r26,low(temp_state)
ld r10,x+
ld r16,x+
ld r11,x+                    ;v 1= multiply2[multiply2[temp_state[1] ^ temp_state[3]]];
ld r17,x+
eor r16,r17 
ldi r31,high(multiply2<<1)   
mov r30,r16
lpm r15,z
ldi r31,high(multiply2<<1)
mov r30,r15
lpm r15,z	                  ;v1=r15
ld r16,x+
ld r10,x+                    ;u2 = multiply2[multiply2[temp_state[4] ^ temp_state[6]]];
ld r17,x+
eor r16,r17 
ldi r31,high(multiply2<<1)   
mov r30,r16
lpm r12,z
ldi r31,high(multiply2<<1)
mov r30,r12
lpm r12,z                      ;u2=r12
mov r16,r10                    ;v2 = multiply2[multiply2[temp_state[5] ^ temp_state[7]]];
ld  r17,x+
eor r16,r17 
ldi r31,high(multiply2<<1)   
mov r30,r16
lpm r13,z
ldi r31,high(multiply2<<1)
mov r30,r13
lpm r13,z	                    ;v2=r13
ldi r27,high(temp_state)       ;temp_state->x
ldi r26,low(temp_state)
ld  r16,x                   ;temp_state[0] = temp_state[0] ^ u1;
eor r16,r14
st  x+,r16
ld r16,x                    ;temp_state[1] = temp_state[1] ^ v1;
eor r16,r15
st x+,r16
ld r16,x                    ;temp_state[2] = temp_state[2] ^ u1;
eor r16,r14
st x+,r16
ld r16,x                    ;temp_state[3] = temp_state[3] ^ v1;
eor r16,r15
st  x+,r16
ld r16,x                   ;temp_state[4] = temp_state[4] ^ u2;
eor r16,r12
st x+,r16
ld r16,x                   ;temp_state[5] = temp_state[5] ^ v2;
eor r16,r13
st x+,r16
ld r16,x                   ;temp_state[6] = temp_state[6] ^ u2;
eor r16,r12
st x+,r16
ld r16,x                  ;temp_state[7] = temp_state[7] ^ v2;
eor r16,r13
st x,r16
ldi r27,high(temp_state)       ;temp_state->x
ldi r26,low(temp_state)
ld r14,x+                  ; u = temp_state[0] ^ temp_state[1] ^ temp_state[2] ^ temp_state[3];
ld r15,x+
eor r14,r15
ld r15,x+
eor r14,r15
ld r15,x+
eor r14,r15                 ;u=r14
ldi r27,high(temp_state)       ;temp_state->x
ldi r26,low(temp_state)
ld r12,x+                  ;v = temp_state[0] ^ temp_state[1];
ld r13,x+
eor r12,r13
ldi r31,high(multiply2<<1)   ;v = multiply2[v];
mov r30,r12
lpm r12,z                     ;v=r12
ldi r27,high(temp_state)       ;temp_state->x
ldi r26,low(temp_state)
ld r16,x+                   ;state[2] = temp_state[0] ^ v ^ u;
eor r16,r12
eor r16,r14
std y+2,r16
ld r12,x+                   ;v = temp_state[1] ^ temp_state[2];
ld r13,x
eor r12,r13
ldi r31,high(multiply2<<1)   ;v = multiply2[v];
mov r30,r12
lpm r12,z
dec r26
ld  r16,x                   ; state[3] = temp_state[1] ^ v ^ u;
eor r16,r12 
eor r16,r14
std y+3,r16
inc r26
ld  r12,x+                     ;v = temp_state[2] ^ temp_state[3];
ld  r13,x
eor r13,r12                    ;r13=v r12=temp_state[2]
ldi r31,high(multiply2<<1)     ;v = multiply2[v];
mov r30,r13
lpm r13,z
mov r16,r12                  ;state[4] = temp_state[2] ^ v ^ u;
eor r16,r13
eor r16,r14
std y+4,r16      
ld   r12,x                     ;v = temp_state[3] ^ temp_state[0];
ldi r27,high(temp_state)       ;temp_state->x
ldi r26,low(temp_state)
ld  r13,x+
eor r12,r13
ldi r31,high(multiply2<<1)    ;v = multiply2[v];
mov r30,r12
lpm r12,z
ld  r16,x+
ld  r16,x+
ld  r16,x+                   ;state[5] = temp_state[3] ^ v ^ u;
eor r16,r12
eor r16,r14
std y+5,r16
ld r14,x+                    ; u = temp_state[4] ^ temp_state[5] ^ temp_state[6] ^ temp_state[7];
ld r15,x+
ld r8,x+
ld r9,x+
mov r10,r14
mov r11,r15
mov r12,r8
mov r13,r9
eor r14,r15                 ;v1 = temp_state[4] ^ temp_state[5]   r14
eor r15,r12                 ;v2 = temp_state[5] ^ temp_state[6]   r15
eor r8,r9                   ;v3 = temp_state[6] ^ temp_state[7]    r8
mov r9,r14
eor r9,r8                   ;u=r9
ldi r31,high(multiply2<<1)    ;v = multiply2[v];
mov r30,r14
lpm r14,z
mov r16,r10                   ;state[6] = temp_state[4] ^ v1 ^ u;
eor r16,r14
eor r16,r9
std y+6,r16
ldi r31,high(multiply2<<1)   ;v = multiply2[v];
mov r30,r15
lpm r15,z
mov r16,r11                   ;state[7] = temp_state[5] ^ v2 ^ u;
eor r16,r15
eor r16,r9
std y+7,r16
ldi r31,high(multiply2<<1)   ;v = multiply2[v];
mov r30,r8
lpm r16,z                  
eor r16,r12                    ;state[0] = temp_state[6] ^ v3 ^ u;
eor r16,r9
std y+0,r16     
mov r16,r10                  ;v 4= temp_state[7] ^ temp_state[4];
eor r16,r13
ldi r31,high(multiply2<<1)   ;v = multiply2[v];
mov r30,r16
lpm r16,z               
eor r16,r13               ;state[1] = temp_state[7] ^ v4 ^ u;
eor r16,r9
std y+1,r16
ret


.ORG $600

sbox:
.db $77,$74,$7a,$79,$71,$7f,$7b,$70,$7c,$73,$72,$76,$78,$7e,$7d,$75
.db $47,$44,$4A,$49,$41,$4F,$4B,$40,$4C,$43,$42,$46,$48,$4E,$4D,$45
.db $A7,$A4,$AA,$A9,$A1,$AF,$AB,$A0,$AC,$A3,$A2,$A6,$A8,$AE,$AD,$A5
.db $97,$94,$9A,$99,$91,$9F,$9B,$90,$9C,$93,$92,$96,$98,$9E,$9D,$95
.db $17,$14,$1A,$19,$11,$1F,$1B,$10,$1C,$13,$12,$16,$18,$1E,$1D,$15
.db $F7,$F4,$FA,$F9,$F1,$FF,$FB,$F0,$FC,$F3,$F2,$F6,$F8,$FE,$FD,$F5
.db $B7,$B4,$BA,$B9,$B1,$BF,$BB,$B0,$BC,$B3,$B2,$B6,$B8,$BE,$BD,$B5
.db $07,$04,$0A,$09,$01,$0F,$0B,$00,$0C,$03,$02,$06,$08,$0E,$0D,$05
.db $C7,$C4,$CA,$C9,$C1,$CF,$CB,$C0,$CC,$C3,$C2,$C6,$C8,$CE,$CD,$C5
.db $37,$34,$3A,$39,$31,$3F,$3B,$30,$3C,$33,$32,$36,$38,$3E,$3D,$35
.db $27,$24,$2A,$29,$21,$2F,$2B,$20,$2C,$23,$22,$26,$28,$2E,$2D,$25
.db $67,$64,$6A,$69,$61,$6F,$6B,$60,$6C,$63,$62,$66,$68,$6E,$6D,$65
.db $87,$84,$8A,$89,$81,$8F,$8B,$80,$8C,$83,$82,$86,$88,$8E,$8D,$85
.db $E7,$E4,$EA,$E9,$E1,$EF,$EB,$E0,$EC,$E3,$E2,$E6,$E8,$EE,$ED,$E5
.db $D7,$D4,$DA,$D9,$D1,$DF,$DB,$D0,$DC,$D3,$D2,$D6,$D8,$DE,$DD,$D5
.db $57,$54,$5A,$59,$51,$5F,$5B,$50,$5C,$53,$52,$56,$58,$5E,$5D,$55


multiply2:
.db $00,$02,$04,$06,$08,$0a,$0c,$0e,$10,$12,$14,$16,$18,$1a,$1c,$1e
.db $20,$22,$24,$26,$28,$2a,$2c,$2e,$30,$32,$34,$36,$38,$3a,$3c,$3e
.db $40,$42,$44,$46,$48,$4a,$4c,$4e,$50,$52,$54,$56,$58,$5a,$5c,$5e
.db $60,$62,$64,$66,$68,$6a,$6c,$6e,$70,$72,$74,$76,$78,$7a,$7c,$7e
.db $80,$82,$84,$86,$88,$8a,$8c,$8e,$90,$92,$94,$96,$98,$9a,$9c,$9e
.db	$a0,$a2,$a4,$a6,$a8,$aa,$ac,$ae,$b0,$b2,$b4,$b6,$b8,$ba,$bc,$be
.db $c0,$c2,$c4,$c6,$c8,$ca,$cc,$ce,$d0,$d2,$d4,$d6,$d8,$da,$dc,$de
.db $e0,$e2,$e4,$e6,$e8,$ea,$ec,$ee,$f0,$f2,$f4,$f6,$f8,$fa,$fc,$fe
.db $1b,$19,$1f,$1d,$13,$11,$17,$15,$0b,$09,$0f,$0d,$03,$01,$07,$05
.db $3b,$39,$3f,$3d,$33,$31,$37,$35,$2b,$29,$2f,$2d,$23,$21,$27,$25
.db $5b,$59,$5f,$5d,$53,$51,$57,$55,$4b,$49,$4f,$4d,$43,$41,$47,$45
.db $7b,$79,$7f,$7d,$73,$71,$77,$75,$6b,$69,$6f,$6d,$63,$61,$67,$65
.db $9b,$99,$9f,$9d,$93,$91,$97,$95,$8b,$89,$8f,$8d,$83,$81,$87,$85
.db $bb,$b9,$bf,$bd,$b3,$b1,$b7,$b5,$ab,$a9,$af,$ad,$a3,$a1,$a7,$a5
.db $db,$d9,$df,$dd,$d3,$d1,$d7,$d5,$cb,$c9,$cf,$cd,$c3,$c1,$c7,$c5
.db $fb,$f9,$ff,$fd,$f3,$f1,$f7,$f5,$eb,$e9,$ef,$ed,$e3,$e1,$e7,$e5



.DSEG
round_key: .BYTE 8
temp_state: .BYTE 8
state: .BYTE 8
cipher: .BYTE 8



