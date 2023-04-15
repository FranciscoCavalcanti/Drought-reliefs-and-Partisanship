**********************************						
*	McCracry Test
**********************************

* make sure there is output folder
cap mkdir "$outdir\graphs"

****************************
* presidential elections
****************************
DCdensity mv_bp_party_P1, breakpoint(0) generate(Xj3 Yj3 r03 fhat3 se_fhat3)

local mc_full=round(r(theta),.001)
local mc_full : display %9.3fc `mc_full'

local mcse_full=round(r(se),.001)
local mcse_full : display %9.3fc `mcse_full'

gen fhat3_95low=fhat3-1.96*se_fhat3
gen fhat3_95high=1.96*se_fhat3+fhat3

* set scheme
set scheme s1mono

twoway (scatter Yj3 Xj3  if Xj3 > -0.5 & Xj3 < 0.5 )  (line fhat3 r03  if r03 > -0.5 & r03 < 0 , lcolor(black) ) /*
	*/	(line fhat3 r03  if r03 > 0 & r03 < 0.5 , lcolor(black))    /*
	*/	(line  fhat3_95low r03  if r03 > -0.5 & r03 < 0, lpattern(dash)  lcolor(black) ) /*
	*/	(line fhat3_95low r03  if r03 > =0 & r03 <0.5 , lpattern(dash) lcolor(black) )    /*
	*/	(line fhat3_95high r03  if r03 > -0.5 & r03 < 0, lpattern(dash)  lcolor(black) ) /*
	*/	(line fhat3_95high r03  if r03 >= 0 & r03 < 0.5, xline(0) lpattern(dash)  lcolor(black)), /*
	*/ 	title("Presidential elections", size(Small)) /*
	*/ 	subtitle("") /*	
	*/	graphregion(color(white)) 	/*
	*/ 	xlabel(#4) 	/*
	*/ 	legend(on order(- "McCrary: `mc_full'" "s.e.:`mcse_full'") ring(0) pos(11) justification(center) size(small) ) 	/*
	*/  saving("$tmp\iten1.gph", replace) 	

drop fhat3_95low fhat3_95high Yj3 Xj3 r03 fhat3 se_fhat3

****************************
* mayoral elections
****************************
DCdensity mv_bm_party_P1, breakpoint(0) generate(Xj3 Yj3 r03 fhat3 se_fhat3)

local mc_full=round(r(theta),.001)
local mc_full : display %9.3fc `mc_full'

local mcse_full=round(r(se),.001)
local mcse_full : display %9.3fc `mcse_full'

gen fhat3_95low=fhat3-1.96*se_fhat3
gen fhat3_95high=1.96*se_fhat3+fhat3

* set scheme
set scheme s1mono

twoway (scatter Yj3 Xj3  if Xj3 > -0.5 & Xj3 < 0.5 )  (line fhat3 r03  if r03 > -0.5 & r03 < 0 , lcolor(black) ) /*
	*/	(line fhat3 r03  if r03 > 0 & r03 < 0.5 , lcolor(black))    /*
	*/	(line  fhat3_95low r03  if r03 > -0.5 & r03 < 0, lpattern(dash)  lcolor(black) ) /*
	*/	(line fhat3_95low r03  if r03 > =0 & r03 <0.5 , lpattern(dash) lcolor(black) )    /*
	*/	(line fhat3_95high r03  if r03 > -0.5 & r03 < 0, lpattern(dash)  lcolor(black) ) /*
	*/	(line fhat3_95high r03  if r03 >= 0 & r03 < 0.5, xline(0) lpattern(dash)  lcolor(black)), /*
	*/ 	title("Mayoral elections", size(Small)) /*
	*/ 	subtitle("") /*	
	*/	graphregion(color(white)) 	/*
	*/ 	xlabel(#4) 	/*
	*/ 	legend(on order(- "McCrary: `mc_full'" "s.e.:`mcse_full'") ring(0) pos(11) justification(center) size(small) ) 	/*
	*/  saving("$tmp\iten2.gph", replace) 	

drop fhat3_95low fhat3_95high Yj3 Xj3 r03 fhat3 se_fhat3
	
********************************************************	
* Combing graphs with the same legend
********************************************************	
graph combine "$tmp\iten1.gph" "$tmp\iten2.gph", 	/*
	*/ 		/* legendfrom("$tmp\iten1") 
	*/ 	title("McCrary Density Test", size(Small)) 	/*
	*/ 	cols(2) 	/*
	*/ 	ycommon 	/* ycommon
	*/	graphregion(fcolor(white)) 	/*
	*/ 	subtitle("Previous margin of victory of candidate for mayor in the president's coalition", size(Small) ) 	/* subtitle("")
	*/ 	 	/* note("Source: TSE")
	*/	
	
				* save graph 
graph save Graph "$tmp\_mccrary_test.gph", replace
graph use "$tmp\_mccrary_test.gph"
graph export "$outdir\graphs\_mccrary_test.png", replace	
graph export "$outdir\graphs\_mccrary_test.eps", as(eps) replace
erase "$tmp\_mccrary_test.gph"
