*** RDD graph style
*** Method: 
**** 1) Select sample in bandwidth CCT
**** 2) Regression Discontinuy Design
**** 3) Plot graph 
***** x-axis =  margin of victory of candidate of mayor in the same party as the incumbent president
***** y-axis =  observables
***** bins = average of dependnt variable (y) of group of municipalities in the same range of "margin of victory" 


	*** Restrict the sample to the RDD cases:
	drop if relief_mv_bp==. // Drop when our dependent variable is missing
 	rdbwselect relief_mv_bp mv_bp_party_P1 if mv_bp_party_P1 != . , all
	macro drop CCT_party
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party
	display $CCT_party
	
	keep if ( mv_bp_party_P1 <= $CCT_party &   mv_bp_party_P1 >= -$CCT_party)
 
	*******************************
	**	Build bins for margin of victory
	*******************************
	
	cap drop vote_bins
	gen vote_bins=.

	* bins in the left side of graph
	forvalues bot = -1(0.025)0 {
		local top = `bot' + 0.025
		replace vote_bins=(`bot'+`top')/2 if mv_bp_party_P1>`bot' & mv_bp_party_P1<=`top' & alg_mv_bp_party==0 
	}


	* bins in the right side of graph
	forvalues bot = 0(0.025)1 {
	local top = `bot' + 0.025
	replace vote_bins=(`bot'+`top')/2 if mv_bp_party_P1>=`bot' & mv_bp_party_P1<`top' & alg_mv_bp_party==1
	}
	
	* local average by bins	
	cap drop log_populacao
	gen log_populacao = log(populacao)
	by vote_bins, sort : egen float mean_drought_bin = mean(drought) if vote_bins~=. & alg_mv_bp_party~=.
	by vote_bins, sort : egen float mean_taxa_rural_bin = mean(taxa_rural) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_water_bin = mean(taxa_water) if vote_bins~=. & alg_mv_bp_party~=.
	by vote_bins, sort : egen float mean_taxa_television_bin = mean(taxa_television) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_radio_bin = mean(taxa_radio) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_energy_bin = mean(taxa_energy) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_log_populacao_bin = mean(log_populacao) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_renda_media_bin = mean(renda_media) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_escolaridade_media_bin = mean(escolaridade_media) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_jovem_bin = mean(taxa_jovem) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_maior_bin = mean(taxa_maior) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_agricultura_bin = mean(taxa_agricultura) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_industria_bin = mean(taxa_industria) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_comercio_bin = mean(taxa_comercio) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_transporte_bin = mean(taxa_transporte) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_servico_bin = mean(taxa_servico) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_adm_publica_bin = mean(taxa_adm_publica) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_ocupacao_bin = mean(taxa_ocupacao) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_graduado_bin = mean(taxa_graduado) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_pobreza_bin = mean(taxa_pobreza) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_miseria_bin = mean(taxa_miseria) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_race_bin = mean(taxa_race) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_gender_bin = mean(taxa_gender) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_evangelical_bin = mean(taxa_evangelical) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_taxa_high_school_bin = mean(taxa_high_school) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_distance_river_bin = mean(distance_river) if vote_bins~=. & alg_mv_bp_party~=. 
	by vote_bins, sort : egen float mean_share_gdp_agriculture_bin = mean(share_gdp_agriculture) if vote_bins~=. & alg_mv_bp_party~=.
	
	****************
	* Implement regressions
	****************
	
	* RDD in low drought
	reg taxa_rural alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r //  
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_rural_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_rural_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of rural households") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_rural.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg drought alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_drought_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash) lcolor(black))	/*
		*/(scatter mean_drought_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("SPEI") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_drought.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_water alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_water_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_water_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of water") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_water.gph", replace) 
		
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_television alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_television_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_television_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of television") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_television.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_radio alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_radio_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_radio_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of radio") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_radio.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_energy alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_energy_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_energy_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of energy") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_energy.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg log_populacao alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_log_populacao_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_log_populacao_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Population") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_log_populacao.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg renda_media alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_renda_media_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_renda_media_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Average income") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_renda_media.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg escolaridade_media alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_escolaridade_media_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_escolaridade_media_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Average schooling") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_escolaridade_media.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_jovem alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_jovem_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_jovem_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of young people") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_jovem.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_maior alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_maior_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_maior_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of old people") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_maior.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_agricultura alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_agricultura_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_agricultura_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of agriculture") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_agricultura.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_industria alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_industria_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_industria_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of industry") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_industria.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_comercio alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_comercio_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_comercio_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of commerce") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_comercio.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_transporte alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_transporte_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_transporte_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of transport") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_transporte.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_servico alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_servico_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_servico_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of service") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_servico.gph", replace) 
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_adm_publica alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_adm_publica_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_adm_publica_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of public administration") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_adm_publica.gph", replace)  
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_ocupacao alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_ocupacao_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_ocupacao_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of occupation") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_ocupacao.gph", replace)  
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_graduado alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_graduado_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_graduado_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of graduated") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_graduado.gph", replace)  
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_pobreza alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_pobreza_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_pobreza_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of poverty") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_pobreza.gph", replace)  
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_race alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_race_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_race_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of black people") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_race.gph", replace)  
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_gender alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_gender_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_gender_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of women") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_gender.gph", replace)  
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_evangelical alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_evangelical_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_evangelical_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of evangelical") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_evangelical.gph", replace)  
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg taxa_high_school alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_taxa_high_school_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_taxa_high_school_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of high school") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_taxa_high_school.gph", replace)  
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg distance_river alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_distance_river_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_distance_river_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Distance from river") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_distance_river.gph", replace)  		
		
		
	****************
	* Implement regressions
	****************
	
	* RDD 
	reg share_gdp_agriculture alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1,r // 
	predict yhat
	predict error, stdp	
	
	* fitted values
	cap drop fitted_values1
	ge fitted_values1 =_b[_cons] + _b[alg_mv_bp_party]*alg_mv_bp_party	/*
	*/	+_b[mv_bp_party_P1]*mv_bp_party_P1	/*
	*/	+_b[a_mv_bp_party_P1]*a_mv_bp_party_P1	/*	
	*/	if vote_bins ~=.
	
	cap drop lb1 ub1
	generate lb1 = fitted_values1 - invnormal(0.975)*error
	generate ub1 = fitted_values1 + invnormal(0.975)*error
	cap drop error yhat
	
	****************
	* Implement RDD graphs
	****************
	set scheme  s1mono  
	cap sort mv_bp_party_P1	
	
	twoway (scatter mean_share_gdp_agriculture_bin vote_bins if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, xline(0) color(blue) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party & low==1, lpattern(solid) lcolor(black))	/*
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(scatter mean_share_gdp_agriculture_bin vote_bins if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party  & low==1, xline(0) color(red) msymbol(circle_hollow)) /*
		*/(line fitted_values1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(solid) lcolor(black))	/*				
		*/(line lb1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 <= 0.0   &   mv_bp_party_P1 >= -$CCT_party  & low==1, lpattern(dash_dot) lcolor(black))	/*
		*/(line ub1 mv_bp_party_P1 if mv_bp_party_P1 > 0.0   &   mv_bp_party_P1 <= $CCT_party   & low==1, lpattern(dash_dot) lcolor(black))	/*	
		*/ , /*
		*/ 	title("") 	/*
		*/ 	subtitle("Share of agriculture GDP") 	/*
		*/ 	ytitle("") /*
		*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks
		*/	ylabel(#4, labsize(small)) 	/*
		*/ 	xtitle("margin of victory")	/*
		*/	xlabel(#6,  labsize(small)) 	/*
		*/	xscale( range( -0.15 0.15 ) )	/* how x axis looks
		*/ 	legend(off order(1 2 3) cols(3) label(1 "Local average") label(2 "Fitted values") label(3 "C.I 95%"))	/*
		*/ 	saving("$tmp\_rdd_bp_share_gdp_agriculture.gph", replace)  		
		
		
	* Combing graphs with the same legend
	graph combine  "$tmp\_rdd_bp_drought" "$tmp\_rdd_bp_log_populacao" "$tmp\_rdd_bp_taxa_agricultura"  	/*
		*/ "$tmp\_rdd_bp_taxa_rural" "$tmp\_rdd_bp_taxa_pobreza" "$tmp\_rdd_bp_distance_river"	/*
		*/ "$tmp\_rdd_bp_escolaridade_media" "$tmp\_rdd_bp_taxa_race" "$tmp\_rdd_bp_taxa_gender",	/*
		*/ 		/* legendfrom("$tmp\potential_rdd_graph_01") 
		*/ 	subtitle("Before presidential elections") 	/*
		*/	graphregion(fcolor(white)) 	/*	
		*/ 	xcommon 	/* subtitle("Amazônia Legal vs. Resto do Brasil")
		*/ 	 	/* 
		*/ 	cols(3) 	/*
		*/ 	 	/* note("Fonte: PNAD Contínua 2019")
		*/
	
	* save graph 
	graph save Graph "$tmp\_graph_rdd_bp_balance_observables.gph", replace
	graph use "$tmp\_graph_rdd_bp_balance_observables.gph"
	graph export "$outdir\graphs\_graph_rdd_bp_balance_observables.png", replace
	graph export "$outdir\graphs\_graph_rdd_bp_balance_observables.eps", as(eps) replace

