********************************
********* REGRESSIONS **********
********************************
 
**** OPTIMAL BANDWIDTH: Calonico, Cattaneo and Titiunik (2014b).	
rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1~=., all
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party

dis $CCT_party 
// $CCT_party = 0.117

keep if ( mv_bm_party_P1 <= $CCT_party &   mv_bm_party_P1 >= -$CCT_party) & relief_mv_bm!=.
count // 3,027

*** Keep relevant sample size:
reghdfe relief_mv_bm ///
alg_mv_bm_party mv_bm_party_P1 a_mv_bm_party_P1 ///
moderate severe ///
moderate_aligned severe_aligned ///
, cluster(cod_mun) absorb(cod_mun year)

keep if e(sample)==1
 
***********************************************************
*** TABLE												***
***********************************************************

* (1) add controls: mv_bm_party_P1 a_mv_bm_party_P1 --> ALERT: THIS IS OUR FIRST REGRESSION!!!!
reg relief_mv_bm ///
mv_bm_party_P1 a_mv_bm_party_P1 ///
low_aligned low_notaligned ///
moderate_aligned moderate_notaligned ///
severe_aligned severe_notaligned ///
, cluster(cod_mun) nocons

	test low_aligned=low_notaligned // Prob > F =    0.2406
	
	local Fstatistics_low = r(F)
	local Fstatistics_low : display %9.3fc `Fstatistics_low'
	di "F statistic = `Fstatistics_low'"
	
	local two_sided_pvalue_low = r(p)
	local two_sided_pvalue_low : display %9.3fc `two_sided_pvalue_low'
	di "two-sided p-value = `two_sided_pvalue_low'"
	
	test moderate_aligned=moderate_notaligned // Prob > F =    0.0005
	
	local Fstatistics_moderate = r(F)
	local Fstatistics_moderate : display %9.3fc `Fstatistics_moderate'
	di "F statistic = `Fstatistics_moderate'"
	
	local two_sided_pvalue_moderate = r(p)
	local two_sided_pvalue_moderate : display %9.3fc `two_sided_pvalue_moderate'
	di "two-sided p-value = `two_sided_pvalue_moderate'"
	
	test severe_aligned=severe_notaligned // Prob > F =    0.2489
	
	local Fstatistics_severe = r(F)
	local Fstatistics_severe : display %9.3fc `Fstatistics_severe'
	di "F statistic = `Fstatistics_severe'"
	
	local two_sided_pvalue_severe = r(p)
	local two_sided_pvalue_severe : display %9.3fc `two_sided_pvalue_severe'
	di "two-sided p-value = `two_sided_pvalue_severe'"

outreg2	using "$outdir/regressions/_table_regression_mv_bm.tex", /*
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
	*/	addtext(Polynomial order, 1, Bandwidith, $CCT_party , Procedure, CTT, Year FE, No, Municipality FE, No ) /*
	*/	tex(fragment) /*
	*/	replace



* (2) have only year FE: (now it drops one variable, so we impose that it drops 'low_notaligned')
cap drop d_year_*
tab year, gen(d_year_)
reg relief_mv_bm ///
mv_bm_party_P1 a_mv_bm_party_P1 ///
low_aligned /*low_notaligned*/ ///
moderate_aligned moderate_notaligned ///
severe_aligned severe_notaligned ///
d_year_* ///
, cluster(cod_mun) nocons

	test low_aligned=0 // ALERT, NEW TEST!! Prob > F =    0.8359
	
	local Fstatistics_low = r(F)
	local Fstatistics_low : display %9.3fc `Fstatistics_low'
	di "F statistic = `Fstatistics_low'"
	
	local two_sided_pvalue_low = r(p)
	local two_sided_pvalue_low : display %9.3fc `two_sided_pvalue_low'
	di "two-sided p-value = `two_sided_pvalue_low'"
	
	test moderate_aligned=moderate_notaligned // Prob > F =    0.0117
	
	local Fstatistics_moderate = r(F)
	local Fstatistics_moderate : display %9.3fc `Fstatistics_moderate'
	di "F statistic = `Fstatistics_moderate'"
	
	local two_sided_pvalue_moderate = r(p)
	local two_sided_pvalue_moderate : display %9.3fc `two_sided_pvalue_moderate'
	di "two-sided p-value = `two_sided_pvalue_moderate'"
	
	test severe_aligned=severe_notaligned // Prob > F =    0.5839
	
	local Fstatistics_severe = r(F)
	local Fstatistics_severe : display %9.3fc `Fstatistics_severe'
	di "F statistic = `Fstatistics_severe'"
	
	local two_sided_pvalue_severe = r(p)
	local two_sided_pvalue_severe : display %9.3fc `two_sided_pvalue_severe'
	di "two-sided p-value = `two_sided_pvalue_severe'"

outreg2	using "$outdir/regressions/_table_regression_mv_bm.tex", /*
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
	*/	addtext(Polynomial order, 1, Bandwidith, $CCT_party , Procedure, CTT, Year FE, Yes, Municipality FE, No ) /*
	*/	tex(fragment) /*
	*/	 

* (3) have only municipality FE:
set matsize 3000
cap drop d_munic_*
tab cod_mun, gen(d_munic_)
reg relief_mv_bm ///
mv_bm_party_P1 a_mv_bm_party_P1 ///
low_aligned /*low_notaligned*/ ///
moderate_aligned moderate_notaligned ///
severe_aligned severe_notaligned ///
d_munic_* ///
, cluster(cod_mun) nocons

	test low_aligned=0 // Prob > F =    0.6752
	
	local Fstatistics_low = r(F)
	local Fstatistics_low : display %9.3fc `Fstatistics_low'
	di "F statistic = `Fstatistics_low'"
	
	local two_sided_pvalue_low = r(p)
	local two_sided_pvalue_low : display %9.3fc `two_sided_pvalue_low'
	di "two-sided p-value = `two_sided_pvalue_low'"
	
	test moderate_aligned=moderate_notaligned // Prob > F =    0.0511
	
	local Fstatistics_moderate = r(F)
	local Fstatistics_moderate : display %9.3fc `Fstatistics_moderate'
	di "F statistic = `Fstatistics_moderate'"
	
	local two_sided_pvalue_moderate = r(p)
	local two_sided_pvalue_moderate : display %9.3fc `two_sided_pvalue_moderate'
	di "two-sided p-value = `two_sided_pvalue_moderate'"
	
	test severe_aligned=severe_notaligned // Prob > F =    0.1874
	
	local Fstatistics_severe = r(F)
	local Fstatistics_severe : display %9.3fc `Fstatistics_severe'
	di "F statistic = `Fstatistics_severe'"
	
	local two_sided_pvalue_severe = r(p)
	local two_sided_pvalue_severe : display %9.3fc `two_sided_pvalue_severe'
	di "two-sided p-value = `two_sided_pvalue_severe'"

outreg2	using "$outdir/regressions/_table_regression_mv_bm.tex", /*
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
	*/	addtext(Polynomial order, 1, Bandwidith, $CCT_party , Procedure, CTT, Year FE, No, Municipality FE, Yes ) /*
	*/	tex(fragment) /*
	*/	 

* (4) have both municipality FE and year FE:
reg relief_mv_bm ///
mv_bm_party_P1 a_mv_bm_party_P1 ///
low_aligned /*low_notaligned*/ ///
moderate_aligned moderate_notaligned ///
severe_aligned severe_notaligned ///
d_year_* d_munic_* ///
, cluster(cod_mun) nocons

	test low_aligned=0 // Prob > F =    0.6752
	
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

outreg2	using "$outdir/regressions/_table_regression_mv_bm.tex", /*
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

