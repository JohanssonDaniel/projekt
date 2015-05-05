
	MOVE.W	#$2202,A0	; A0 = 0010
;--------------------------------------------------------------
;	###########     MOVE LEFT     ##############
;-------------------------------------------------------------
	MOVE.W	#$0,D7
START:	
	MOVE.W	#$0F00,D0	;COLCTR = D0  D0 = 0F00
	
	
NEXTCURRENT:
	MOVE.W	#$0000,D4	;FLAG FOR MOVBIT
	MOVE.W	A0,D1		;D1 = CURRENTREG,      D1= 0010
	AND.W	D0,D1		; 0F00*0010 = 0000     D1= 0000
	CMP.W	#$0000,D1
	BNE	NEIGHBOUR	; IF D1 != 0000 THEN GO TO NEIGHBOUR
	LSR.W	#$04,D0		; 0F00 = 00F0, COLCTR(D0) = 00F0
	CMP.W	#$0000,D0	; CHECK IF COLCTR IS OUTSIDE
	BEQ	NEXTROW
	BRA	NEXTCURRENT

NEIGHBOUR:
	MOVE.W	A0,D2		;D2 = NEIGHBOURREG,	D2= 0010
	; KANSKE L�GGA TILL EN "IFSATS"
	CMP.W	#$0001,D4	;IF D4 == 1 THEN STILLMOVING
	BEQ	STILLMOVING
	MOVE.W	D0,D3		; D3 = COLCTR TEMP,     D3= 00F0
STILLMOVING:
	MOVE.W	#$0000,D4
	LSL.W	#$04,D3		; D3 = 0F00
	AND.W	D3,D2		; 0F00*0010 = 0000,     D2= 0000
	CMP.W	#$0000,D2
	BEQ	MOVEBIT
	MOVE.W	A0,D1		; CURRENTREG
	LSR.W	#$04,D3
	AND.W	D3,D1		; 0010*00F0 = 0010
	LSR.W	#$04,D2
	CMP.W	D6,D3		; FIX, PREVENTING MERGE 1120 = 4000, INSTEAD 1120=2200
	BEQ	NEXTCURRENT
	CMP.W	D1,D2
	BEQ	MERGE
	LSR.W	#$04,D0
	BRA	NEXTCURRENT

MOVEBIT:
	MOVE.W	A0,D2
	MOVE.W	D3,D5
	LSR.W	#$04,D5
	AND.W	D5,D2
	SUB.W	D2,A0
	LSL.W	#$04,D2
	ADD.W	D2,A0
	MOVE.W	#$0001,D4	;FLAG FOR MOVING
	; CMP COLCTR MED 4
	CMP.W	#$F000,D3
	BEQ	NEXTCURRENT
	BRA 	NEIGHBOUR

MERGE:	
	SUB.W	D1,A0
	LSL.W	#$04,D1
	SUB.W	D1,A0

	MOVE.W	D3,D6		;adderar 1
	AND.W	#$1111,D6	;adderar 1
	LSL.W	#$04,D6		;adderar 1
	ADD.W	D6,D1		;adderar 1
	
	ADD	D1,A0
	MOVE.W	D3,D6		;FIX PREVENTING WRONGS TYP OF MERGE
	BRA	NEXTCURRENT
	
NEXTROW
	CMP	#$04,D7
	BEQ	FINISH
	MOVE.W	A1,A0
	BRA	START
FINISH
