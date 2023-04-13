/* data and variables */

* make sure there is output folder
cap mkdir "$outdir\descriptive_statistics"

* preserve
preserve
keep if mv_bm_party_P1 !=.
/*
tab year
*/
gen drought=-SPEI24_mv_bm // positive values of SPEI represent droughts
drop if drought==.
gen low=(drought<0)
gen moderate=(drought<= 1 & drought>=0)
gen severe =(drought>1)
gen low_aligned=(low==1 & alg_mv_bm_party==1)
gen low_notaligned=(low==1 & alg_mv_bm_party==0)
gen moderate_aligned=(moderate==1 & alg_mv_bm_party==1)
gen moderate_notaligned=(moderate==1 & alg_mv_bm_party==0)
gen severe_aligned=(severe==1 & alg_mv_bm_party==1)
gen severe_notaligned=(severe==1 & alg_mv_bm_party==0)
gen muni_aligned = (alg_mv_bm_party==1)
gen muni_notaligned = (alg_mv_bm_party==0)
gen margin_of_victory = mv_bm_party_P1
gen aid_relief =(relief_mv_bm==1)

* Label variables
label variable drought "Standardized Precipitation Evapotranspiration Index (SPEI)"
label variable low "Municipalities in low drought"
label variable moderate "Municipalities in moderate drought"
label variable severe "Municipalities in severe drought"
label variable muni_aligned "Municipalities aligned"
label variable muni_notaligned "Municipalities non-aligned"
label variable low_aligned "Municipalities aligned and low drought"
label variable low_notaligned "Municipalities non-aligned and low drought"
label variable moderate_aligned  "Municipalities aligned and moderate drought"
label variable moderate_notaligned "Municipalities non-aligned and moderate drought"
label variable severe_aligned  "Municipalities aligned and severe drought"
label variable severe_notaligned "Municipalities non-aligned and severe drought"
label variable margin_of_victory "Margin of victory"
label variable aid_relief "Aid relief for drought"

eststo mayor : quietly estpost summarize ///
     drought low moderate severe muni_aligned muni_notaligned low_aligned low_notaligned moderate_aligned moderate_notaligned severe_aligned severe_notaligned margin_of_victory aid_relief   

* restore

	
eststo diff_mayor: estpost tabstat ///
    muni_aligned muni_notaligned low moderate severe low_aligned low_notaligned moderate_aligned moderate_notaligned severe_aligned severe_notaligned ///
	, statistics(count sum) by(aid_relief) 
	

restore

	/*
eststo diff: quietly estpost ttest ///
    low_aligned low_notaligned moderate_aligned moderate_notaligned severe_aligned severe_notaligned mv_bm_party_P1, by(relief_mv_bm) unequal
	*/

* preserve
preserve
keep if mv_bp_party_P1 !=.
/*
tab year
*/
gen drought=-SPEI24_mv_bp // positive values of SPEI represent droughts
drop if drought==.
gen low=(drought<0)
gen moderate=(drought<= 1 & drought>=0)
gen severe =(drought>1)
gen low_aligned=(low==1 & alg_mv_bp_party==1)
gen low_notaligned=(low==1 & alg_mv_bp_party==0)
gen moderate_aligned=(moderate==1 & alg_mv_bp_party==1)
gen moderate_notaligned=(moderate==1 & alg_mv_bp_party==0)
gen severe_aligned=(severe==1 & alg_mv_bp_party==1)
gen severe_notaligned=(severe==1 & alg_mv_bp_party==0)
gen muni_aligned = (alg_mv_bp_party==1)
gen muni_notaligned = (alg_mv_bp_party==0)
gen margin_of_victory = mv_bp_party_P1
gen aid_relief =(relief_mv_bp==1)

* Label variables
label variable drought "Standardized Precipitation Evapotranspiration Index (SPEI)"
label variable low "Municipalities in low drought"
label variable moderate "Municipalities in moderate drought"
label variable severe "Municipalities in severe drought"
label variable muni_aligned "Municipalities aligned"
label variable muni_notaligned "Municipalities non-aligned"
label variable low_aligned "Municipalities aligned and low drought"
label variable low_notaligned "Municipalities non-aligned and low drought"
label variable moderate_aligned  "Municipalities aligned and moderate drought"
label variable moderate_notaligned "Municipalities non-aligned and moderate drought"
label variable severe_aligned  "Municipalities aligned and severe drought"
label variable severe_notaligned "Municipalities non-aligned and severe drought"
label variable margin_of_victory "Margin of victory"
label variable aid_relief "Aid relief for drought"

eststo president: quietly estpost summarize ///
     drought low moderate severe muni_aligned muni_notaligned low_aligned low_notaligned moderate_aligned moderate_notaligned severe_aligned severe_notaligned margin_of_victory aid_relief   

eststo diff_president: estpost tabstat ///
    muni_aligned muni_notaligned low moderate severe low_aligned low_notaligned moderate_aligned moderate_notaligned severe_aligned severe_notaligned ///
	, statistics(count sum) by(aid_relief) 
	
* restore
restore

*eststo diff: quietly estpost ttest ///

* local notes
local ttitle "Descriptive Statistics"
local tnotes "Note"
	
#delim ;    
	esttab mayor president using "$outdir\descriptive_statistics\table_descriptive_statistics.tex",		
		cells("mean(fmt(3)) sd(fmt(3)) min(fmt(3)) max(fmt(3))")
		label
		prehead(
			"\begin{table}[H]"
			"\centering"
			"\label{tabledescriptivestatistics}"
			"\scalebox{0.75}{"
			"\begin{threeparttable}"
			"\caption{`ttitle'}"		
			"\begin{tabular}{l*{@span}{r}}"
			"\midrule \midrule"			
    		)
		postfoot(
			"\bottomrule"
			"\end{tabular}"		
			"\begin{tablenotes}"
			"\item \scriptsize{`tnotes'}"
			"\end{tablenotes}"
			"\end{threeparttable}"
			"}"
			"\end{table}"
    		)
    		replace
		;
#delim cr


#delim ;    
	esttab diff_mayor diff_president using "$outdir\descriptive_statistics\table_descriptive_statistics_diff.tex",		
		cells("low" "moderate")
		label
    		replace
		;
#delim cr
