********************************
********* REGRESSIONS **********
********************************

**** OPTIMAL BANDWIDTH: Calonico, Cattaneo and Titiunik (2014b).	
rdbwselect relief_mv_bp mv_bp_party_P1 if mv_bp_party_P1~=., all
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party

dis $CCT_party 
// $CCT_party =  

keep if ( mv_bp_party_P1 <= $CCT_party &   mv_bp_party_P1 >= -$CCT_party) & relief_mv_bp!=.
count // 

*** Keep relevant sample size:
reghdfe relief_mv_bp ///
alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1 ///
moderate severe ///
moderate_aligned severe_aligned ///
, cluster(cod_mun) absorb(i.cod_mun i.year) 

keep if e(sample)==1
 
***********************************************************
* Generate variable differentiating between rural and urban municipalities
***********************************************************
cap drop p50
egen p50 = median(taxa_rural)
cap drop rural_sample
gen rural_sample = (taxa_rural >= p50)

***********************************************************
*** TABLE												***
***********************************************************

* Rural sample

* (1) have both municipality FE and year FE:
reghdfe relief_mv_bp ///
mv_bp_party_P1 a_mv_bp_party_P1 ///
low_aligned /*low_notaligned*/ ///
moderate_aligned moderate_notaligned ///
severe_aligned severe_notaligned ///
if rural_sample == 1 /// 
, cluster(cod_mun) absorb(cod_mun year) 

	test low_aligned=0 //  
	
	local Fstatistics_low = r(F)
	local Fstatistics_low : display %9.3fc `Fstatistics_low'
	di "F statistic = `Fstatistics_low'"
	
	local two_sided_pvalue_low = r(p)
	local two_sided_pvalue_low : display %9.3fc `two_sided_pvalue_low'
	di "two-sided p-value = `two_sided_pvalue_low'"
	
	test moderate_aligned=moderate_notaligned // Prob > F =    0.2958
	
	local Fstatistics_moderate = r(F)
	local Fstatistics_moderate : display %9.3fc `Fstatistics_moderate'
	di "F statistic = `Fstatistics_moderate'"
	
	local two_sided_pvalue_moderate = r(p)
	local two_sided_pvalue_moderate : display %9.3fc `two_sided_pvalue_moderate'
	di "two-sided p-value = `two_sided_pvalue_moderate'"
	
	test severe_aligned=severe_notaligned // Prob > F =    0.2422
	
	local Fstatistics_severe = r(F)
	local Fstatistics_severe : display %9.3fc `Fstatistics_severe'
	di "F statistic = `Fstatistics_severe'"
	
	local two_sided_pvalue_severe = r(p)
	local two_sided_pvalue_severe : display %9.3fc `two_sided_pvalue_severe'
	di "two-sided p-value = `two_sided_pvalue_severe'"

outreg2	using "$outdir/regressions/_table_regression_mv_bp_rural_urban.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(low* moderate* severe*)  /*
	*/	nocons	/*
	*/	addstat("(1) F statistics (aligned and low = non-aligned and low):", `Fstatistics_low', 	/*
		*/ 	"(1) \hspace{1mm} P-values", `two_sided_pvalue_low', 	/*
		*/ 	"(2) F statistics (aligned and moderate = non-aligned and moderate):", `Fstatistics_moderate', 	/*
		*/ 	"(2) \hspace{1mm} P-values", `two_sided_pvalue_moderate', 	/*
		*/ 	"(3) F statistics (aligned and severe = non-aligned and severe)", `Fstatistics_severe', 	/*	
		*/ 	"(3) \hspace{1mm} P-values", `two_sided_pvalue_severe')	 /*	
	*/	addtext(Polynomial order, 1, Bandwidith, $CCT_party , Procedure, CTT, Year FE, Yes, Municipality FE, Yes ) /*
	*/	tex(fragment) /*
	*/	replace
	
* Urban sample

* (2) have both municipality FE and year FE:
reghdfe relief_mv_bp ///
mv_bp_party_P1 a_mv_bp_party_P1 ///
low_aligned /*low_notaligned*/ ///
moderate_aligned moderate_notaligned ///
severe_aligned severe_notaligned ///
if rural_sample == 0 /// 
, cluster(cod_mun) absorb(i.cod_mun i.year) 

	test low_aligned=0 //  
	
	local Fstatistics_low = r(F)
	local Fstatistics_low : display %9.3fc `Fstatistics_low'
	di "F statistic = `Fstatistics_low'"
	
	local two_sided_pvalue_low = r(p)
	local two_sided_pvalue_low : display %9.3fc `two_sided_pvalue_low'
	di "two-sided p-value = `two_sided_pvalue_low'"
	
	test moderate_aligned=moderate_notaligned // Prob > F =    0.2958
	
	local Fstatistics_moderate = r(F)
	local Fstatistics_moderate : display %9.3fc `Fstatistics_moderate'
	di "F statistic = `Fstatistics_moderate'"
	
	local two_sided_pvalue_moderate = r(p)
	local two_sided_pvalue_moderate : display %9.3fc `two_sided_pvalue_moderate'
	di "two-sided p-value = `two_sided_pvalue_moderate'"
	
	test severe_aligned=severe_notaligned // Prob > F =    0.2422
	
	local Fstatistics_severe = r(F)
	local Fstatistics_severe : display %9.3fc `Fstatistics_severe'
	di "F statistic = `Fstatistics_severe'"
	
	local two_sided_pvalue_severe = r(p)
	local two_sided_pvalue_severe : display %9.3fc `two_sided_pvalue_severe'
	di "two-sided p-value = `two_sided_pvalue_severe'"

outreg2	using "$outdir/regressions/_table_regression_mv_bp_rural_urban.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(low* moderate* severe*)  /*
	*/	nocons	/*
	*/	addstat("(1) F statistics (aligned and low = non-aligned and low):", `Fstatistics_low', 	/*
		*/ 	"(1) \hspace{1mm} P-values", `two_sided_pvalue_low', 	/*
		*/ 	"(2) F statistics (aligned and moderate = non-aligned and moderate):", `Fstatistics_moderate', 	/*
		*/ 	"(2) \hspace{1mm} P-values", `two_sided_pvalue_moderate', 	/*
		*/ 	"(3) F statistics (aligned and severe = non-aligned and severe)", `Fstatistics_severe', 	/*	
		*/ 	"(3) \hspace{1mm} P-values", `two_sided_pvalue_severe')	 /*	
	*/	addtext(Polynomial order, 1, Bandwidith, $CCT_party , Procedure, CTT, Year FE, Yes, Municipality FE, Yes ) /*
	*/	tex(fragment) /*
	*/	 	

