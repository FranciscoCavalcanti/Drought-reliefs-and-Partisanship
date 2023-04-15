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
	cap drop mean_relief_low_bin mean_relief_moderate_bin mean_relief_severe_bin
	by vote_bins, sort : egen float mean_relief_low_bin = mean(relief_mv_bm) if vote_bins~=. & alg_mv_bm_party~=. & low ==1
	by vote_bins, sort : egen float mean_relief_moderate_bin = mean(relief_mv_bm) if vote_bins~=. & alg_mv_bm_party~=.  & moderate ==1
	by vote_bins, sort : egen float mean_relief_severe_bin = mean(relief_mv_bm) if vote_bins~=. & alg_mv_bm_party~=.  & severe ==1
	
	****************
	* Implement regressions
	****************
	
	* RDD in low drought
	reg relief_mv_bm low_aligned mv_bm_party_P1 a_mv_bm_party_P1 if low==1,r // not significant
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[low_aligned]*low_aligned	/*
	*/	+_b[mv_bm_party_P1]*mv_bm_party_P1	/*
	*/	+_b[a_mv_bm_party_P1]*a_mv_bm_party_P1	/*	
	*/	if vote_bins ~=.  & low==1
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	* RDD in moderate drought
	reg relief_mv_bm moderate_aligned mv_bm_party_P1 a_mv_bm_party_P1 if moderate==1,r // significant
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values2
	ge fitted_values2 =_b[_cons] + _b[moderate_aligned]*moderate_aligned	/*
	*/	+_b[mv_bm_party_P1]*mv_bm_party_P1	/*
	*/	+_b[a_mv_bm_party_P1]*a_mv_bm_party_P1	/*	
	*/	if vote_bins ~=. & moderate==1
	
	cap drop lb2 ub2
	generate lb2 = fitted_values2 - invnormal(0.975)*error
	generate ub2 = fitted_values2 + invnormal(0.975)*error
	cap drop error yhat

	* RDD in severe drought
	reg relief_mv_bm severe_aligned mv_bm_party_P1 a_mv_bm_party_P1 if severe==1,r // not significant
	predict yhat
	predict error, stdp

	* fitted values
	cap drop fitted_values3
	ge fitted_values3 =_b[_cons] + _b[severe_aligned]*severe_aligned	/*
	*/	+_b[mv_bm_party_P1]*mv_bm_party_P1	/*
	*/	+_b[a_mv_bm_party_P1]*a_mv_bm_party_P1	/*	
	*/	if vote_bins ~=. & severe==1
	
	cap drop lb3 ub3
	generate lb3 = fitted_values3 - invnormal(0.975)*error
	generate ub3 = fitted_values3 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bm_party	
	
	twoway (scatter mean_relief_low_bin vote_bins if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_relief_low_bin vote_bins if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Low drought") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#8, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\potential_rdd_graph_01.gph", replace) 

	* save graph 
	graph use "$tmp\potential_rdd_graph_01.gph"
	graph export "$outdir\graphs\_graph_rdd_bm_low.png", replace		
		
	twoway (scatter mean_relief_moderate_bin vote_bins if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party  & moderate==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values2 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party & moderate==1, lpattern(solid) lcolor(black))	/*
		*/(line lb2 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party  & moderate==1, lpattern(dash_dot) lcolor(black))	/*	
		*/(line fitted_values2 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party   & moderate==1, lpattern(solid) lcolor(black))	/*	
		*/(scatter mean_relief_moderate_bin vote_bins if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party  & moderate==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line lb2 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party   & moderate==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub2 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party  & moderate==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub2 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party   & moderate==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Moderate drought") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#8, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\potential_rdd_graph_02.gph", replace) 

	* save graph 
	graph use "$tmp\potential_rdd_graph_02.gph"
	graph export "$outdir\graphs\_graph_rdd_bm_moderate.png", replace			
		
		
	twoway (scatter mean_relief_severe_bin vote_bins if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party  & severe==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values3 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party & severe==1, lpattern(solid) lcolor(black))	/*
		*/(line lb3 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party  & severe==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_relief_severe_bin vote_bins if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party  & severe==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values3 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party   & severe==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb3 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party   & severe==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub3 mv_bm_party_P1 if mv_bm_party_P1 <= 0.0   &   mv_bm_party_P1 >= -$CCT_party  & severe==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub3 mv_bm_party_P1 if mv_bm_party_P1 > 0.0   &   mv_bm_party_P1 <= $CCT_party   & severe==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Severe drought") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#8, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\potential_rdd_graph_03.gph", replace) 

	* save graph 
	graph use "$tmp\potential_rdd_graph_03.gph"
	graph export "$outdir\graphs\_graph_rdd_bm_severe.png", replace	
		
		
	* Combing graphs with the same legend
	graph combine  "$tmp\potential_rdd_graph_01" "$tmp\potential_rdd_graph_02" "$tmp\potential_rdd_graph_03",  	/*
		*/ 		/* legendfrom("$tmp\potential_rdd_graph_01") 
		*/ 	subtitle("During two years before mayoral elections") 	/*
		*/	graphregion(fcolor(white)) 	/*	
		*/ 	xcommon 	/* subtitle("Amazônia Legal vs. Resto do Brasil")
		*/ 	ycommon	/* 
		*/ 	cols(3) 	/*
		*/ 	 	/* note("Fonte: PNAD Contínua 2019")
		*/
	
	* save graph 
	graph save Graph "$tmp\_graph_rdd_bm.gph", replace
	graph use "$tmp\_graph_rdd_bm.gph"
	graph export "$outdir\graphs\_graph_rdd_bm.png", replace	
	graph export "$outdir\graphs\_graph_rdd_bm.tif", as(tif) replace