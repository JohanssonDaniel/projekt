	
	load	row(0),gr0
	current = maxcol-2
	cmp 	current,-1
	BEQ		loadnextrow
	move	gr0,gr1
	and		gr1,maxrow-k //Maska ut näst sista
	bne		notzero
	current = current -1
NOTZERO:
	move	gr0,gr2
	and		gr2,maxrow-1	//Maska ut sista
	cmp 	gr0,gr2
	beq		sumrows
SUMROWS:
	add		gr1,gr2
	
		
