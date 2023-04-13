********************************
*** OPTIMAL BANWIDTH FOR RDD ***
********************************

**** OPTIMAL BANDWIDTH: Calonico, Cattaneo and Titiunik (2014b).	
rdbwselect relief_mv_bp mv_bp_party_P1 if mv_bp_party_P1~=., all
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party

dis $CCT_party 

keep if ( mv_bp_party_P1 <= $CCT_party &   mv_bp_party_P1 >= -$CCT_party) & relief_mv_bp!=.

*** Explore further the range drought and decompose it: [Quantiles]
cap drop drought_quantile
gen drought_quantile=.
	forvalues j=-1.4(0.2)2.6 {
	local k=`j'+0.2
	dis `j' " and " `k'
	count if drought>`j' & drought<=`k'
	replace drought_quantile=`j' if drought>`j' & drought<=`k'
	}
tab drought_quantile	
replace drought_quantile=-1.6 if drought<-1.4
replace drought_quantile=2.6 if drought>2.6

* (1) For each quantile-alignment combination, find probability of getting relief: ('ratio' variable below)
gen one=1
bys drought_quantile alg_mv_bp_party: egen denom=sum(one)
drop one
gen one=(relief_mv_bp==1)
bys drought_quantile alg_mv_bp_party: egen num=sum(one)
drop one
gen ratio=num/denom
drop num denom

* Generate separate variables for ratio_aligned and ratio_notaligned, so that we can later take the difference:
gen temp=ratio if alg_mv_bp_party==1
bys drought_quantile: egen ratio_aligned=max(temp)
drop temp
gen temp=ratio if alg_mv_bp_party==0
bys drought_quantile: egen ratio_notaligned=max(temp)
drop temp
* Generate the difference between these probabilities:
gen diff_ratio=ratio_aligned-ratio_notaligned

preserve
keep drought_quantile diff_ratio
duplicates drop 
count // 22
set scheme  s1mono  

twoway (scatter diff_ratio drought_quantile if drought_quantile <-0.2 , mcolor(blue) msymbol(diamond_hollow)) || (scatter diff_ratio drought_quantile if drought_quantile >=-0.2 & drought_quantile <=1 , mcolor(black) msymbol(circle_hollow) ) || (scatter diff_ratio drought_quantile if drought_quantile >1 , mcolor(red) msymbol(triangle_hollow) ) /*
		*/ , yline(0) xline(-0.1, lpattern(shortdash)) 	/*
		*/ 	xline(1.1, lpattern(shortdash)) /*
	*/ 	title("") 	/*
	*/ 	subtitle("During two years before presidential elections") 	/*
	*/ 	ytitle("") /*
	*/	yscale(axis(1) range() lstyle(none) )	/* how y axis looks	
	*/	ylabel(#8, labsize(small)) 	/*
	*/ 	xtitle("Standardised Precipitation Evapotranspiration Index")	/*
	*/	xlabel(, labsize(small) angle(0))	/*	 xlabel(, grid )
	*/ 	legend(off order(1 2 3) cols(1) label()  )	/*
	*/ 	saving("$tmp\_graph_ratio_bp.gph", replace)
	
restore
	