////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Analysis for: Drought-reliefs and Partisanship ///  
/// Boffa-Cavalcanti-Fons-Rosen-Piolatto (Oxford Bulletin of Economics and Statistics) 
////////////////////////////////////////////////////////////////////////////////////////////////////////////

clear all
discard
set more off
capture log close
version 16.1

* set path of folder
* for instance:
global ROOT "C:/Users/DELL/Documents/GitHub/Drought-reliefs-and-Partisanship"

* make sure there are output folders
global inpdir				"$ROOT/build/output"
global outdir				"$ROOT/analysis/output"
global codedir    			"$ROOT/analysis/code"
global tmp					"$ROOT/analysis/tmp"

cap mkdir "$tmp"
cap mkdir "$outdir"
cap mkdir "$outdir/graphs"
cap mkdir "$outdir/descriptive_statistics"
cap mkdir "$outdir/regressions"

*******************************************************************************
* install packages for replication
*******************************************************************************
/*
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/") // for reghdfe
net describe st0366, from(http://www.stata-journal.com/software/sj14-4)
net install st0366, replace // for rdbwselect
ssc install boottest
*/

*******************************************************************************
* install packages for replication - MANNUALLY
*******************************************************************************
// User-Written SSC Package 01
// Comment: make sure to have "DCdensity.ado". 
// Put this file in your ado directory.  
// To find out where this is, issue-sysdir- at the Stata prompt. 
// link for "DCdensity" command: https://github.com/iphone7725/DCdensity

// User-Written SSC Package 02
// Comment: make sure to have "summclust.ado". //
// Put this file in your ado directory.  
// To find out where this is, issue-sysdir- at the Stata prompt. 
// link for "summclust" command: https://github.com/mattdwebb/summclust

********************************
*** CALL DATABASE			 ***
********************************
use "$inpdir/main_database.dta", clear

**************************************************************
*** Results referring to the section:
*** 3.1 Our variables 
**************************************************************

* Table 1: Descriptive Statistics

	preserve
	do "$codedir/_table_descriptive_analysis.do"
	restore	

**************************************************************
*** Results referring to the section:
*** 3.2 Estimation strategy and results    
**************************************************************

* Figure 2: Regression Discontinuity Design
	
	* before municial elections: plot 1
	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_graph_rdd_bm_drought_ignored.do"
	restore
	
	* before presidential elections: plot 2
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_graph_rdd_bp_drought_ignored.do"
	restore
	
	* combine the two graphs: plot 1 + plot 2
	grc1leg "$tmp\_graph_rdd_bm_drought_ignored.gph" "$tmp\_graph_rdd_bp_drought_ignored.gph",	/*
	*/ 	title("") 	/*
	*/ 	cols(1) 	/*
	*/ 	  /* legendfrom("$tmp\_graph_rdd_bm_drought_ignored")
	*/ 	ycommon 	/* ycommon
	*/ 	xcommon 	/* xcommon
	*/	graphregion(fcolor(white)) 	/*
	*/	saving("$tmp\_graph_rdd_drought_ignored.gph", replace) 
	
	graph use "$tmp\_graph_rdd_drought_ignored.gph"
	graph export "$outdir\graphs\_graph_rdd_drought_ignored.png", replace
	graph export "$outdir\graphs\_graph_rdd_drought_ignored.eps", as(eps) replace

* Figure 3: Share of municipalities that obtained aid-relief: difference between aligned and non-aligned municipalities

	* before municial elections: plot 1
	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_graph_ratio_bm.do"
	restore

	* before presidential elections: plot 2
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_graph_ratio_bp.do"
	restore
	
	* combine the two graphs: plot 1 + plot 2
	graph combine "$tmp\_graph_ratio_bm" "$tmp\_graph_ratio_bp",	/*
	*/ 	title("") 	/*
	*/ 	cols(2) 	/*
	*/ 	ycommon 	/* ycommon
	*/	graphregion(fcolor(white)) 	/*
	*/	saving("$tmp\_graph_ratio.gph", replace) 
	
	graph use "$tmp\_graph_ratio.gph"
	graph export "$outdir\graphs\_graph_ratio.png", replace	
	graph export "$outdir\graphs\_graph_ratio.eps", as(eps) replace

	
* Figure 4: Kernel plots of the likelihood of receiving transfers

	* before municial elections: plot 1
	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_graph_kernel_bm.do"
	restore

	* before presidential elections: plot 2
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_graph_kernel_bp.do"
	restore
	
	* combine the two graphs: plot 1 + plot 2
	grc1leg "$tmp\_graph_kernel_bm.gph" "$tmp\_graph_kernel_bp.gph",	/*
	*/ 	title("") 	/*
	*/ 	cols(2) 	/*
	*/ 	ycommon 	/* ycommon
	*/ 	legendfrom("$tmp\_graph_kernel_bm.gph") 	/* ycommon
	*/	graphregion(fcolor(white)) 	/*
	*/	saving("$tmp\_graph_kernel.gph", replace) 
	
	graph use "$tmp\_graph_kernel.gph"
	graph export "$outdir\graphs\_graph_kernel.png", replace	
	graph export "$outdir\graphs\_graph_kernel.eps", as(eps) replace
	graph export "$outdir\graphs\_graph_kernel.pdf", as(pdf) replace


* Figure 5: Alignment impact on obtaining aid relief for SPEI ranges

	* before municial elections: plot 1
	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_graph_range_spei_bm.do"
	restore

	* before presidential elections: plot 2
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_graph_range_spei_bp.do"
	restore
	
	* combine the two graphs: plot 1 + plot 2
	graph combine "$tmp\_graph_range_spei_bm.gph" "$tmp\_graph_range_spei_bp.gph",	/*
	*/ 	title("") 	/*
	*/ 	cols(1) 	/*
	*/ 	ycommon 	/* ycommon
	*/	graphregion(fcolor(white)) 	/*
	*/	saving("$tmp\_graph_range_spei.gph", replace) 
	
	graph use "$tmp\_graph_range_spei.gph"
	graph export "$outdir\graphs\_graph_range_spei.png", replace	
	graph export "$outdir\graphs\_graph_range_spei.eps", as(eps) replace


* Table 2: Impact of alignment on the assignment of aid relief

	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_table_regression_bm.do"
	restore	
	
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_table_regression_bp.do"
	restore	
	
* Figure 6: Regression Discontinuity Design by Aridity Levels.

	* before municial elections: plot 1
	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_graph_rdd_bm.do"
	restore
	
	* before presidential elections: plot 2
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_graph_rdd_bp.do"
	restore
	
	* combine the two graphs: plot 1 + plot 2
	graph combine "$tmp\_graph_rdd_bm.gph" "$tmp\_graph_rdd_bp.gph",	/*
	*/ 	title("") 	/*
	*/ 	cols(1) 	/*
	*/ 	 /* legendfrom("$tmp\_graph_rdd_bm")
	*/ 	ycommon 	/* ycommon
	*/ 	xcommon 	/* xcommon
	*/	graphregion(fcolor(white)) 	/*
	*/	saving("$tmp\_graph_rdd.gph", replace) 
	
	graph use "$tmp\_graph_rdd.gph"
	graph export "$outdir\graphs\_graph_rdd.png", replace
	graph export "$outdir\graphs\_graph_rdd.eps", as(eps) replace

	

**************************************************************
*** Online Appendix
**************************************************************

**************************************************************
*** Results referring to the section:
*** 1 Assignment of aid relief
**************************************************************

* Figure OA1: Total number of state of emergency declarations because of drought
* IN R

**************************************************************
*** 2 RDD Validity
**************************************************************

* Figure OA2: McCrary Density Test
	preserve
	do "$codedir/_mcrary_test.do"
	restore	


* Figure OA3: Graphs of observables against the forcing variable before mayoral elections
* before municial elections: plot 1
	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_graph_rdd_bm_balance_observables.do"
	restore
	
* Figure OA4: Graphs of observables against the forcing variable before presidential election
	* before presidential elections: plot 2
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_graph_rdd_bp_balance_observables.do"
	restore

**************************************************************
*** Results referring to the section:
*** 3 The Standard Precipitation Index (SPI)
**************************************************************

* Figure OA5: Share of municipalities that obtained aid-relief: difference between aligned and non-aligned municipalities.

	* before municial elections: plot 1
	preserve
	do "$codedir/_generate_variables_bm_spi.do"
	do "$codedir/_graph_ratio_bm_spi.do"
	restore

	* before presidential elections: plot 2
	preserve
	do "$codedir/_generate_variables_bp_spi.do"
	do "$codedir/_graph_ratio_bp_spi.do"
	restore
	
	* combine the two graphs: plot 1 + plot 2
	graph combine "$tmp\_graph_ratio_bm_spi" "$tmp\_graph_ratio_bp_spi",	/*
	*/ 	title("") 	/*
	*/ 	cols(2) 	/*
	*/ 	ycommon 	/* ycommon
	*/	graphregion(fcolor(white)) 	/*
	*/	saving("$tmp\_graph_ratio_spi.gph", replace) 
	
	graph use "$tmp\_graph_ratio_spi.gph"
	graph export "$outdir\graphs\_graph_ratio_spi.png", replace
	graph export "$outdir\graphs\_graph_ratio_spi.eps", as(eps) replace		
	
	
* Figure OA6: Alignment impact on obtaining aid relief for SPI ranges.

	* before municial elections: plot 1
	preserve
	do "$codedir/_generate_variables_bm_spi.do"
	do "$codedir/_graph_range_spi_bm.do"
	restore

	* before presidential elections: plot 2
	preserve
	do "$codedir/_generate_variables_bp_spi.do"
	do "$codedir/_graph_range_spi_bp.do"
	restore
	
	* combine the two graphs: plot 1 + plot 2
	graph combine "$tmp\_graph_range_spi_bm.gph" "$tmp\_graph_range_spi_bp.gph",	/*
	*/ 	title("") 	/*
	*/ 	cols(1) 	/*
	*/ 	ycommon 	/* ycommon
	*/	graphregion(fcolor(white)) 	/*
	*/	saving("$tmp\_graph_range_spi.gph", replace) 
	
	graph use "$tmp\_graph_range_spi.gph"
	graph export "$outdir\graphs\_graph_range_spi.png", replace	
	graph export "$outdir\graphs\_graph_range_spi.eps", as(eps) replace		

	
	
* Table OA1: Number of observations assigned to each aridity category based on SPI or SPEI

	preserve
	do "$codedir/_generate_variables_bm_spi_spei.do"
	do "$codedir/_robustness_check_diff_spei_spi_categories_bm.do"
	restore
	
	preserve
	do "$codedir/_generate_variables_bp_spi_spei.do"
	do "$codedir/_robustness_check_diff_spei_spi_categories_bp.do"
	restore


* Table OA2: Impact of alignment on the assignment of aid relief

	* before municial elections:
	preserve
	do "$codedir/_generate_variables_bm_spi.do"
	do "$codedir/_table_regression_bm_spi.do"
	restore
	
	* before presidential elections:
	preserve
	do "$codedir/_generate_variables_bp_spi.do"
	do "$codedir/_table_regression_bp_spi.do"
	restore


* Table OA3: Impact of drought indexes on the assignment of aid relief and agricultural production
		
	preserve
	do "$codedir/_robustness_check_table_diff_spei_spi_agricultural_production.do"
	restore


* Figure OA7: Evolution of SPEI and SPI over the century.

	* in /build/8_cru/code/Preamble.do

**************************************************************
*** Results referring to the section:
*** 4 Alternative SPEI thresholds
**************************************************************

* Table OA4: Impact of alignment on the assignment of aid relief (5 levels of aridity)

	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_generate_variables_bm_alternative_thresholds.do"
	do "$codedir/_table_regression_bm_alternative_thresholds.do"
	restore
	
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_generate_variables_bp_alternative_thresholds.do"
	do "$codedir/_table_regression_bp_alternative_thresholds.do"
	restore

* Table OA5: Impact of alignment on the assignment of aid relief*

	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_generate_variables_bm_alternative_ranges.do"
	do "$codedir/_table_regression_bm_alternative_ranges.do"
	restore
	
	
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_generate_variables_bp_alternative_ranges.do"
	do "$codedir/_table_regression_bp_alternative_ranges.do"
	restore

**************************************************************
*** Results referring to the section:
*** 5 Data Clustering
**************************************************************

* Table OA6: Summary statistics for cluster heterogeneity
	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_table_summary_statistics_for_cluster_heterogeneity_bm.do"
	restore
	
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_table_summary_statistics_for_cluster_heterogeneity_bp.do"
	restore
	

* Table OA7: Difference in the probability of getting aid-relief across aligned and misaligned municipalities: 
	* t-statistics and p-values for alternative clustering

	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_table_summary_statistics_for_cluster_tstatistics_bm.do"
	restore
	
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_table_summary_statistics_for_cluster_tstatistics_bp.do"
	restore
	
**************************************************************
*** Results referring to the section:
*** 6 Validity for non-close elections
**************************************************************

* Table OA8: Impact of alignment on the assignment of aid relief
	
	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_table_regression_bm_away_cutoff.do"
	restore
	
	
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_table_regression_bp_away_cutoff.do"
	restore	

**************************************************************
*** Results referring to the section:
*** 7 Urban versus Rural Municipalities
**************************************************************

	* Table OA9: Impact on assignment of aid relief: urban vs rura
	
	preserve
	do "$codedir/_generate_variables_bm.do"
	do "$codedir/_table_regression_bm_rural_urban.do"
	restore
	
	preserve
	do "$codedir/_generate_variables_bp.do"
	do "$codedir/_table_regression_bp_rural_urban.do"
	restore

