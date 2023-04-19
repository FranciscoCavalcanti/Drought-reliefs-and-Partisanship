********************************
********* REGRESSIONS **********
********************************

**** OPTIMAL BANDWIDTH: Calonico, Cattaneo and Titiunik (2014b).	
rdbwselect relief_mv_bp mv_bp_party_P1 if mv_bp_party_P1~=., all
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party

dis $CCT_party 

keep if ( mv_bp_party_P1 <= $CCT_party &   mv_bp_party_P1 >= -$CCT_party) & relief_mv_bp!=.
count // 


*** Keep relevant sample size:
reghdfe relief_mv_bp ///
alg_mv_bp_party mv_bp_party_P1 a_mv_bp_party_P1 ///
moderate severe ///
moderate_aligned severe_aligned ///
, cluster(cod_mun) absorb(cod_mun year)

keep if e(sample)==1
count // 

***********************************************************
*** TABLE												***
***********************************************************

* (1) add controls: mv_bp_party_P1 a_mv_bp_party_P1 
reg relief_mv_bp ///
mv_bp_party_P1 a_mv_bp_party_P1 ///
low_alt_aligned low_alt_notaligned ///
mod_alt_aligned mod_alt_notaligned ///
sev_alt_aligned sev_alt_notaligned ///
, cluster(cod_mun) nocons

	test low_alt_aligned=low_alt_notaligned //  
	
	local Fstatistics_low = r(F)
	local Fstatistics_low : display %9.3fc `Fstatistics_low'
	di "F statistic = `Fstatistics_low'"
	
	local two_sided_pvalue_low = r(p)
	local two_sided_pvalue_low : display %9.3fc `two_sided_pvalue_low'
	di "two-sided p-value = `two_sided_pvalue_low'"
	
	test mod_alt_aligned=mod_alt_notaligned // 
	
	local Fstatistics_mod_alt = r(F)
	local Fstatistics_mod_alt : display %9.3fc `Fstatistics_mod_alt'
	di "F statistic = `Fstatistics_mod_alt'"
	
	local two_sided_pvalue_mod_alt = r(p)
	local two_sided_pvalue_mod_alt : display %9.3fc `two_sided_pvalue_mod_alt'
	di "two-sided p-value = `two_sided_pvalue_mod_alt'"
	
	test sev_alt_aligned=sev_alt_notaligned //  
	
	local Fstatistics_sev_alt = r(F)
	local Fstatistics_sev_alt : display %9.3fc `Fstatistics_sev_alt'
	di "F statistic = `Fstatistics_sev_alt'"
	
	local two_sided_pvalue_sev_alt = r(p)
	local two_sided_pvalue_sev_alt : display %9.3fc `two_sided_pvalue_sev_alt'
	di "two-sided p-value = `two_sided_pvalue_sev_alt'"

outreg2	using "$outdir/regressions/_table_regression_mv_bp_alternative_ranges.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(low* mod* sev*)  /*
	*/	nocons	/*
	*/	addstat("(1) F statistics (aligned and low = non-aligned and low):", `Fstatistics_low', 	/*
		*/ 	"(1) \hspace{1mm} P-values", `two_sided_pvalue_low', 	/*
		*/ 	"(2) F statistics (aligned and moderate = non-aligned and moderate):", `Fstatistics_mod_alt', 	/*
		*/ 	"(2) \hspace{1mm} P-values", `two_sided_pvalue_mod_alt', 	/*		
		*/ 	"(3) F statistics (aligned and severe = non-aligned and severe)", `Fstatistics_sev_alt', 	/*	
		*/ 	"(3) \hspace{1mm} P-values", `two_sided_pvalue_sev_alt')	 /*	
	
	*/	addtext(Polynomial order, 1, Bandwidith, $CCT_party , Procedure, CTT, Year FE, No, Municipality FE, No ) /*
	*/	tex(fragment) /*
	*/	replace



* (2) have only year FE: (now it drops one variable, so we impose that it drops 'low_alt_notaligned')
cap drop d_year_*
tab year, gen(d_year_)
reg relief_mv_bp ///
mv_bp_party_P1 a_mv_bp_party_P1 ///
low_alt_aligned /*low_alt_notaligned*/ ///
mod_alt_aligned mod_alt_notaligned ///
sev_alt_aligned sev_alt_notaligned ///
d_year_* ///
, cluster(cod_mun) nocons

	test low_alt_aligned=0 // ALERT, NEW TEST!!
	
	local Fstatistics_low = r(F)
	local Fstatistics_low : display %9.3fc `Fstatistics_low'
	di "F statistic = `Fstatistics_low'"
	
	local two_sided_pvalue_low = r(p)
	local two_sided_pvalue_low : display %9.3fc `two_sided_pvalue_low'
	di "two-sided p-value = `two_sided_pvalue_low'"
	
	test mod_alt_aligned=mod_alt_notaligned // 
	
	local Fstatistics_mod_alt = r(F)
	local Fstatistics_mod_alt : display %9.3fc `Fstatistics_mod_alt'
	di "F statistic = `Fstatistics_mod_alt'"
	
	local two_sided_pvalue_mod_alt = r(p)
	local two_sided_pvalue_mod_alt : display %9.3fc `two_sided_pvalue_mod_alt'
	di "two-sided p-value = `two_sided_pvalue_mod_alt'"	
	
	test sev_alt_aligned=sev_alt_notaligned //  
	
	local Fstatistics_sev_alt = r(F)
	local Fstatistics_sev_alt : display %9.3fc `Fstatistics_sev_alt'
	di "F statistic = `Fstatistics_sev_alt'"
	
	local two_sided_pvalue_sev_alt = r(p)
	local two_sided_pvalue_sev_alt : display %9.3fc `two_sided_pvalue_sev_alt'
	di "two-sided p-value = `two_sided_pvalue_sev_alt'"

outreg2	using "$outdir/regressions/_table_regression_mv_bp_alternative_ranges.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(low* mod* sev*)  /*
	*/	nocons	/*
	*/	addstat("(1) F statistics (aligned and low = non-aligned and low):", `Fstatistics_low', 	/*
		*/ 	"(1) \hspace{1mm} P-values", `two_sided_pvalue_low', 	/*
		*/ 	"(2) F statistics (aligned and moderate = non-aligned and moderate):", `Fstatistics_mod_alt', 	/*
		*/ 	"(2) \hspace{1mm} P-values", `two_sided_pvalue_mod_alt', 	/*	
		*/ 	"(3) F statistics (aligned and severe = non-aligned and severe)", `Fstatistics_sev_alt', 	/*	
		*/ 	"(3) \hspace{1mm} P-values", `two_sided_pvalue_sev_alt')	 /*	
	
	*/	addtext(Polynomial order, 1, Bandwidith, $CCT_party , Procedure, CTT, Year FE, Yes, Municipality FE, No ) /*
	*/	tex(fragment) /*
	*/	 

* (3) have only municipality FE:
set matsize 3000
cap drop d_munic_*
tab cod_mun, gen(d_munic_)
reg relief_mv_bp ///
mv_bp_party_P1 a_mv_bp_party_P1 ///
low_alt_aligned /*low_alt_notaligned*/ ///
mod_alt_aligned mod_alt_notaligned ///
sev_alt_aligned sev_alt_notaligned ///
d_munic_* ///
, cluster(cod_mun) nocons

	test low_alt_aligned=0 // ALERT, NEW TEST!! 
	
	local Fstatistics_low = r(F)
	local Fstatistics_low : display %9.3fc `Fstatistics_low'
	di "F statistic = `Fstatistics_low'"
	
	local two_sided_pvalue_low = r(p)
	local two_sided_pvalue_low : display %9.3fc `two_sided_pvalue_low'
	di "two-sided p-value = `two_sided_pvalue_low'"
	
	test mod_alt_aligned=mod_alt_notaligned // 
	
	local Fstatistics_mod_alt = r(F)
	local Fstatistics_mod_alt : display %9.3fc `Fstatistics_mod_alt'
	di "F statistic = `Fstatistics_mod_alt'"
	
	local two_sided_pvalue_mod_alt = r(p)
	local two_sided_pvalue_mod_alt : display %9.3fc `two_sided_pvalue_mod_alt'
	di "two-sided p-value = `two_sided_pvalue_mod_alt'"	
	
	test sev_alt_aligned=sev_alt_notaligned //  
	
	local Fstatistics_sev_alt = r(F)
	local Fstatistics_sev_alt : display %9.3fc `Fstatistics_sev_alt'
	di "F statistic = `Fstatistics_sev_alt'"
	
	local two_sided_pvalue_sev_alt = r(p)
	local two_sided_pvalue_sev_alt : display %9.3fc `two_sided_pvalue_sev_alt'
	di "two-sided p-value = `two_sided_pvalue_sev_alt'"

outreg2	using "$outdir/regressions/_table_regression_mv_bp_alternative_ranges.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(low* mod* sev*)  /*
	*/	nocons	/*
	*/	addstat("(1) F statistics (aligned and low = non-aligned and low):", `Fstatistics_low', 	/*
		*/ 	"(1) \hspace{1mm} P-values", `two_sided_pvalue_low', 	/*
		*/ 	"(2) F statistics (aligned and moderate = non-aligned and moderate):", `Fstatistics_mod_alt', 	/*
		*/ 	"(2) \hspace{1mm} P-values", `two_sided_pvalue_mod_alt', 	/*
		*/ 	"(3) F statistics (aligned and severe = non-aligned and severe)", `Fstatistics_sev_alt', 	/*	
		*/ 	"(3) \hspace{1mm} P-values", `two_sided_pvalue_sev_alt')	 /*			
	
	*/	addtext(Polynomial order, 1, Bandwidith, $CCT_party , Procedure, CTT, Year FE, No, Municipality FE, Yes ) /*
	*/	tex(fragment) /*
	*/	 

* (4) have both municipality FE and year FE:
reg relief_mv_bp ///
mv_bp_party_P1 a_mv_bp_party_P1 ///
low_alt_aligned /*low_alt_notaligned*/ ///
mod_alt_aligned mod_alt_notaligned ///
sev_alt_aligned sev_alt_notaligned ///
d_year_* d_munic_* ///
, cluster(cod_mun) nocons

	test low_alt_aligned=0 // ALERT, NEW TEST!!  
	
	local Fstatistics_low = r(F)
	local Fstatistics_low : display %9.3fc `Fstatistics_low'
	di "F statistic = `Fstatistics_low'"
	
	local two_sided_pvalue_low = r(p)
	local two_sided_pvalue_low : display %9.3fc `two_sided_pvalue_low'
	di "two-sided p-value = `two_sided_pvalue_low'"
	
	test mod_alt_aligned=mod_alt_notaligned // 
	
	local Fstatistics_mod_alt = r(F)
	local Fstatistics_mod_alt : display %9.3fc `Fstatistics_mod_alt'
	di "F statistic = `Fstatistics_mod_alt'"
	
	local two_sided_pvalue_mod_alt = r(p)
	local two_sided_pvalue_mod_alt : display %9.3fc `two_sided_pvalue_mod_alt'
	di "two-sided p-value = `two_sided_pvalue_mod_alt'"	
	
	test sev_alt_aligned=sev_alt_notaligned //  
	
	local Fstatistics_sev_alt = r(F)
	local Fstatistics_sev_alt : display %9.3fc `Fstatistics_sev_alt'
	di "F statistic = `Fstatistics_sev_alt'"
	
	local two_sided_pvalue_sev_alt = r(p)
	local two_sided_pvalue_sev_alt : display %9.3fc `two_sided_pvalue_sev_alt'
	di "two-sided p-value = `two_sided_pvalue_sev_alt'"

outreg2	using "$outdir/regressions/_table_regression_mv_bp_alternative_ranges.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(low* mod* sev*)  /*
	*/	nocons	/*
	*/	addstat("(1) F statistics (aligned and low = non-aligned and low):", `Fstatistics_low', 	/*
		*/ 	"(1) \hspace{1mm} P-values", `two_sided_pvalue_low', 	/*
		*/ 	"(2) F statistics (aligned and moderate = non-aligned and moderate):", `Fstatistics_mod_alt', 	/*
		*/ 	"(2) \hspace{1mm} P-values", `two_sided_pvalue_mod_alt', 	/*
		*/ 	"(3) F statistics (aligned and severe = non-aligned and severe)", `Fstatistics_sev_alt', 	/*	
		*/ 	"(3) \hspace{1mm} P-values", `two_sided_pvalue_sev_alt')	 /*	
	
	*/	addtext(Polynomial order, 1, Bandwidith, $CCT_party , Procedure, CTT, Year FE, Yes, Municipality FE, Yes ) /*
	*/	tex(fragment) /*
	*/	 

