	***************************
	** 1) Generate range of Standardised Precpitation Index
	***************************
	
	cap drop spi_range
	gen spi_range= ""
	
	replace spi_range = "<-1.2"	if  drought < -1.2			
	replace spi_range = "-1.2" if drought >= -1.2 & drought < -1.0		
	replace spi_range = "-1.0"	if drought >= -1.0 & drought < -0.8		
	replace spi_range = "-0.8" if drought >= -0.8 & drought < -0.6		
	replace spi_range = "-0.6" if drought >= -0.6 & drought < -0.4		
	replace spi_range = "-0.4" if drought >= -0.4 & drought < -0.2		
	replace spi_range = "-0.2" if drought >= -0.2 & drought < 0.0		
	replace spi_range = "0.0" if drought >= 0.0 & drought < 0.2		
	replace spi_range = "0.2" if drought >= 0.2 & drought < 0.4		
	replace spi_range = "0.4" if drought >= 0.4 & drought < 0.6		
	replace spi_range = "0.6" if drought >= 0.6 & drought < 0.8		
	replace spi_range = "0.8" if drought >= 0.8 & drought < 1.0		
	replace spi_range = "1.0" if drought >= 1.0 & drought < 1.2		
	replace spi_range = ">1.2" if drought >= 1.2 

	***************************
	** 2) Regressions by SPI range 
	***************************
	
	cap drop iten8
	cap gen iten8 = alg_mv_bm_party
	label variable iten8 "<-1.2"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "<-1.2" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten8 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "<-1.2", rob
	estimates store q8
	
	cap drop iten9
	cap gen iten9 = alg_mv_bm_party
	label variable iten9 "-1.2"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "-1.2" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten9 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "-1.2", rob
	estimates store q9
	
	cap drop iten10
	cap gen iten10 = alg_mv_bm_party
	label variable iten10 "-1.0"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "-1.0" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten10 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "-1.0", rob
	estimates store q10
	
	cap drop iten11
	cap gen iten11 = alg_mv_bm_party
	label variable iten11 "-0.8"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "-0.8" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten11 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "-0.8", rob
	estimates store q11
	
	cap drop iten12
	cap gen iten12 = alg_mv_bm_party
	label variable iten12 "-0.6"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "-0.6" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten12 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "-0.6", rob
	estimates store q12
	
	cap drop iten13
	cap gen iten13 = alg_mv_bm_party
	label variable iten13 "-0.4"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "-0.4" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten13 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "-0.4", rob
	estimates store q13
	
	cap drop iten14
	cap gen iten14 = alg_mv_bm_party
	label variable iten14 "-0.2"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "-0.2" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	
	reg relief_mv_bm ///
	iten14 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "-0.2", rob
	estimates store q14
	
	cap drop iten15
	cap gen iten15 = alg_mv_bm_party
	label variable iten15 "0.0"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "0.0" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten15 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "0.0" , rob
	estimates store q15
	
	cap drop iten16
	cap gen iten16 = alg_mv_bm_party
	label variable iten16 "0.2"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "0.2" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten16 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "0.2" , rob
	estimates store q16
	
	cap drop iten17
	cap gen iten17 = alg_mv_bm_party
	label variable iten17 "0.4"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "0.4" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten17 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "0.4" , rob
	estimates store q17
	
	cap drop iten18
	cap gen iten18 = alg_mv_bm_party
	label variable iten18 "0.6"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "0.6" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten18 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "0.6" , rob
	estimates store q18
	
	cap drop iten19
	cap gen iten19 = alg_mv_bm_party
	label variable iten19 "0.8"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "0.8" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten19 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "0.8" , rob
	estimates store q19
	
	cap drop iten20
	cap gen iten20 = alg_mv_bm_party
	label variable iten20 "1.0"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == "1.0" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten20 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == "1.0" , rob
	estimates store q20
	
	cap drop iten21
	cap gen iten21 = alg_mv_bm_party
	label variable iten21 ">1.2"
	
	* calculate bandwidth
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . & spi_range == ">1.2" , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	reg relief_mv_bm ///
	iten21 mv_bm_party_P1 a_mv_bm_party_P1 ///
	if spi_range == ">1.2" , rob
	estimates store q21
	


***************************
	** Implement graph
	***************************
	set scheme  s1mono  
	
	coefplot q8 q9 q10 q11 q12 q13 q14 q15 q16 q17 q18 q19 q20 q21 /*
		*/ 	, 	/*
		*/ 	title("")	/*
		*/ 	keep(iten* , size(tiny)) 	/*
		*/ 	vertical 	/*
		*/	subtitle("During two years before mayoral elections")	/*
		*/	msymbol(circle_hollow) 	/*
		*/ 	mcolor(red) 	/*
		*/	graphregion(fcolor(white)) 	/*
		*/ 	 /*  label() label( 1 "<-1.6" 2 "-1.6" , size(small))
		*/      	/* pstyle()
		*/ 		/* offset()   
		*/ 	  	/* citop
		*/ 	ciopts( recast(rcap) color(blue)  lpattern(dash_dot) lwidth(medium ) )   	/*
		*/	xtitle("") 	/*
		*/	xlabel(, labsize(small) angle(45))	/*	 xlabel(, grid )
		*/	xline(7.5, lpattern(shortdash) lwidth(medium) lcolor(black))	/* add horizontal lines at specified x values
		*/	ytitle("Coeff. of alignmemnt in RDD")	/*	
		*/	yline(0.00, lpattern(shortdash) lwidth(medium) lcolor(black))	/* add horizontal lines at specified y values
		*/	ylabel(#10, grid labsize(small)) 	/*
		*/	yscale(axis(1) range(-0.2 0.3) lstyle(none) )	/* how y axis looks	
		*/	legend(off) /*  legend(row(1) size(small)  symxsize(*0.2) ) legend explaining what means what		
		*/	note("")	/*
		*/   /*  recast(bar)
		*/   /*    recast(connected)
		*/ 		/*  
		*/ 	  	/*
		*/ 	saving("$tmp\_graph_range_spi_bm.gph", replace) 