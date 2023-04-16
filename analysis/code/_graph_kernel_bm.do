
**** OPTIMAL BANDWIDTH: Calonico, Cattaneo and Titiunik (2014b).	
rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1~=., all
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party

dis $CCT_party 
// $CCT_party = 0.117

keep if ( mv_bm_party_P1 <= $CCT_party &   mv_bm_party_P1 >= -$CCT_party) & relief_mv_bm!=.

*** Kernel graph

set scheme  s1mono  
twoway  (lpolyci relief_mv_bm drought if alg_mv_bm_party == 1 & drought>=-2.0 & drought<=2.0,  yaxis(1) clpattern(shortdash)  acolor(blue%30)  clcolor(blue) fcolor(blue%30) fintensity(inten20) ) || (lpolyci relief_mv_bm drought if alg_mv_bm_party == 0 & drought>=-2.0 & drought<=2.0, clpattern(longdash)  acolor(red%30)  clcolor(red) fcolor(red%30) fintensity(inten20))   /*
	*/ , 	/* yline(0) xline(-0.1, lpattern(shortdash)) 
	*/  /* 	xline(1.1, lpattern(shortdash))
	*/ 	title("") 	/*
	*/	graphregion(color(none)) bgcolor(none) 	/*
	*/ 	subtitle("During two years before mayoral elections") 	/*
	*/ 	ytitle("Likelihood of transfers", size() axis(1)) 	/*
	*/ 		/* ytitle("Density", size() axis(2)) 	
	*/	yscale(axis(1) range(0 0.5) lstyle(none)) /* yscale(axis(1) range() lstyle(none) )
	*/	 	/* ylabel(#8,  axis(2)  labsize())
	*/ 	xtitle("Standardised Precipitation Evapotranspiration Index")	/*
	*/	xlabel(#6,  labsize() angle(0))	/*	 xlabel(, grid ) 
	*/ 	xscale( range(-1.0 2.0) lstyle(none) )	/* how y axis looks	
	*/ 	legend(on order(2 "Aligned" 4 "Nonaligned") cols(2) ) 	/* legend(on order(1  3 ) cols(2) label()  ) 
	*/	 /* legend(on cols(4)  order(1 "Aligned" 3 "Nonaliagned") size(small) forcesize symysize(2pt) symxsize(2pt))
	*/ 	saving("$tmp\_graph_kernel_bm.gph", replace)


