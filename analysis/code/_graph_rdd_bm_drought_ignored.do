*** RDD graph style
*** Method: 
**** 1) Select sample in bandwidth CCT
**** 2) Regression Discontinuy Design
**** 3) Plot graph 
***** x-axis =  margin of victory of candidate of mayor in the same party as the incumbent president
***** y-axis =  probability of getting aid relief
***** bins = average of dependnt variable (y) of group of municipalities in the same range of "margin of victory" 


	*** Restrict the sample to the RDD cases:
	drop if relief_mv_bm==. // Drop when our dependent variable is missing
	rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1 != . , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	keep if ( mv_bm_party_P1 <= $CCT_party &   mv_bm_party_P1 >= -$CCT_party)
	
	*******************************
	**	Build bins for margin of victory
	*******************************
	
	cap drop vote_bins
	gen vote_bins=.

	* bins in the left side of graph
	forvalues bot = -1(0.025)0 {
		local top = `bot' + 0.025
		replace vote_bins=(`bot'+`top')/2 if mv_bm_party_P1>`bot' & mv_bm_party_P1<=`top' & alg_mv_bm_party==0 
	}


	* bins in the right side of graph
	forvalues bot = 0(0.025)1 {
	local top = `bot' + 0.025
	replace vote_bins=(`bot'+`top')/2 if mv_bm_party_P1>=`bot' & mv_bm_party_P1<`top' & alg_mv_bm_party==1
	}
	
	* local average by bins
	cap drop mean_relief
	by vote_bins, sort : egen float mean_relief = mean(relief_mv_bm) if vote_bins~=. & alg_mv_bm_party~=.
	
	****************
	* Implement regressions
	****************
	
	* RDD in low drought
	reg relief_mv_bm alg_mv_bm_party mv_bm_party_P1 a_mv_bm_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bm_party]*alg_mv_bm_party	/*
	*/	+_b[mv_bm_party_P1]*mv_bm_party_P1	/*
	*/	+_b[a_mv_bm_party_P1]*a_mv_bm_party_P1	/*	
	*/	if vote_bins ~=. 
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bm_party	
	
	twoway (scatter mean_relief vote_bins if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_relief vote_bins if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("During two years before mayoral elections") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range(0.0 0.35) lstyle(none) )	/* how y axis looks
		*/	ylabel(#8, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_graph_rdd_bm_drought_ignored.gph", replace) 
