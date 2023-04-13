********************************
********* REGRESSIONS **********
********************************

* make analysis on mayoral and presidential elections togetther
cap drop drought_spi
gen drought_spi = -zscore_rain24 // positive values of SPI represent droughts
replace drought_spi = 0  if drought_spi <0 // positive values of SPI represent droughts
su drought_spi,d
gen drought_spi2 = drought_spi*drought_spi
label variable drought_spi "SPI"
label variable drought_spi2 "SPI Squared"


cap drop drought_spei
gen drought_spei = -zscore_SPEI24 // positive values of SPEI represent droughts
replace drought_spei = 0  if drought_spei <0 // positive values of SPI represent droughts
su drought_spei,d
gen drought_spei2 = drought_spei*drought_spei
label variable drought_spei "SPEI"
label variable drought_spei2 "SPEI Squared"

*** Keep relevant sample size:
reghdfe share_gdp_agriculture ///
drought_spi /// 
, cluster(cod_mun) absorb(i.year i.cod_mun) 
keep if e(sample)==1
count // 

* have both municipality FE and year FE:
reghdfe share_gdp_agriculture ///
drought_spi /// 
, cluster(cod_mun) absorb(i.year i.cod_mun) 

global rmse_score : di %9.5fc `e(rmse)' 
di "Root mean squared error = $rmse_score"


outreg2	using "$outdir/regressions/_robustness_checkable_diff_spei_spi_agricultural_production.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(drought_* )  /*
	*/	nocons	/*
	*/	addstat("Root mean squared error", $rmse_score )	 /*
	*/	addtext(Year FE,  Yes , Municipality FE, Yes  ) /*
	*/	tex(fragment) /*
	*/	replace 
	
* have both municipality FE and year FE:
reghdfe share_gdp_agriculture ///
drought_spei /// 
, cluster(cod_mun) absorb(i.year i.cod_mun) 

global rmse_score : di %9.5fc `e(rmse)' 
di "Root mean squared error = $rmse_score"


outreg2	using "$outdir/regressions/_robustness_checkable_diff_spei_spi_agricultural_production.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(drought_* )  /*
	*/	nocons	/*
	*/	addstat("Root mean squared error", $rmse_score )	 /*
	*/	addtext(Year FE,  Yes , Municipality FE, Yes  ) /*
	*/	tex(fragment) /*
	*/	 


* have both municipality FE and year FE:
reghdfe share_gdp_agriculture ///
drought_spi drought_spi2 /// 
, cluster(cod_mun) absorb(i.year i.cod_mun) 

global rmse_score : di %9.5fc `e(rmse)' 
di "Root mean squared error = $rmse_score"


outreg2	using "$outdir/regressions/_robustness_checkable_diff_spei_spi_agricultural_production.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(drought_* )  /*
	*/	nocons	/*
	*/	addstat("Root mean squared error", $rmse_score )	 /*
	*/	addtext(Year FE,  Yes , Municipality FE, Yes  ) /*
	*/	tex(fragment) /*
	*/	 
			
* have both municipality FE and year FE:
reghdfe share_gdp_agriculture ///
drought_spei drought_spei2 /// 
, cluster(cod_mun) absorb(i.year i.cod_mun) 

global rmse_score : di %9.5fc `e(rmse)' 
di "Root mean squared error = $rmse_score"


outreg2	using "$outdir/regressions/_robustness_checkable_diff_spei_spi_agricultural_production.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(drought_* )  /*
	*/	nocons	/*
	*/	addstat("Root mean squared error", $rmse_score )	 /*
	*/	addtext(Year FE,  Yes , Municipality FE, Yes  ) /*
	*/	tex(fragment) /*
	*/	 

* have both municipality FE and year FE:
reghdfe share_gdp_agriculture ///
drought_spi  /// 
drought_spei  /// 
, cluster(cod_mun) absorb(i.year i.cod_mun) 

global rmse_score : di %9.5fc `e(rmse)' 
di "Root mean squared error = $rmse_score"


outreg2	using "$outdir/regressions/_robustness_checkable_diff_spei_spi_agricultural_production.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(drought_* )  /*
	*/	nocons	/*
	*/	addstat("Root mean squared error", $rmse_score )	 /*
	*/	addtext(Year FE,  Yes , Municipality FE, Yes  ) /*
	*/	tex(fragment) /*
	*/		
	
* have both municipality FE and year FE:
reghdfe share_gdp_agriculture ///
drought_spi drought_spi2 /// 
drought_spei drought_spei2 /// 
, cluster(cod_mun) absorb(i.year i.cod_mun) 

global rmse_score : di %9.5fc `e(rmse)' 
di "Root mean squared error = $rmse_score"


outreg2	using "$outdir/regressions/_robustness_checkable_diff_spei_spi_agricultural_production.tex", /*
	*/	title("") /*	
	*/	level(95) /*
	*/	dec(3) /*
	*/	fmt(fc) /*
	*/ 	stats(coef ci) 	/* coef se ci ci_low ci_high
	*/	label /*
	*/		/* depvar
	*/	keep(drought_* )  /*
	*/	nocons	/*
	*/	addstat("Root mean squared error", $rmse_score )	 /*
	*/	addtext(Year FE,  Yes , Municipality FE, Yes  ) /*
	*/	tex(fragment) /*
	*/	 