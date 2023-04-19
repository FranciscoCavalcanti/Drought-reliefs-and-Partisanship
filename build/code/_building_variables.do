

* cleaning data

use "$tmp\crucensuss2idmunidetailtse.dta", clear

* the idea is to shape the datafile by election years
* there are two type of elections: mayoral and presidential
* lets define a dummy variable for each type of elections

gen year_of_mayor_election = .
	forvalues i = 1996(4)2016 {
	replace year_of_mayor_election = 1 if year ==`i'
}

label variable year_of_mayor_election "Election year for mayor"

gen year_of_president_election = .
	forvalues i = 1998(4)2018 {
	replace year_of_president_election = 1 if year ==`i'
}

label variable year_of_president_election "Election year for president"

** sum up agricultural production for two years (in ordor to keep data at level of electoral year)
cap drop itten1
sort cod_ibge year
by cod_ibge, sort: gen iiten1 = fisher_index_adjusted[_n] + fisher_index_adjusted[_n-1] if year_of_election~=.
replace fisher_index_adjusted = iiten1
replace fisher_index_adjusted = . if year_of_election==.
cap drop itten*

cap drop itten2
sort cod_ibge year
by cod_ibge, sort: gen itten2 = fisher_index_adjusted_t[_n] + fisher_index_adjusted_t[_n-1] if year_of_election~=.
replace fisher_index_adjusted_t = itten2
replace fisher_index_adjusted_t = . if year_of_election==.
cap drop itten*

cap drop itten3
sort cod_ibge year
by cod_ibge, sort: gen itten3 = fisher_index_adjusted_p[_n] + fisher_index_adjusted_p[_n-1] if year_of_election~=.
replace fisher_index_adjusted_p = itten3
replace fisher_index_adjusted_p = . if year_of_election==.
cap drop itten*

* generate dependent variables

	// bias allocation of aid relief targeted to affect forthcoming mayoral election

sort cod_mun year 
by cod_mun, sort: gen relief_mv_bm = 1 if state_of_emergency[_n+3] == 1 & year_of_mayor_election ==1
by cod_mun, sort: replace relief_mv_bm = 1 if state_of_emergency[_n+4]   == 1 & year_of_mayor_election ==1
by cod_mun, sort: replace relief_mv_bm = 0 if relief_mv_bm ==. & year_of_mayor_election ==1
replace relief_mv_bm =. if year >=2016
label variable relief_mv_bm "Aid relief for drought"
	
	// bias allocation of aid relief targeted to affect forthcoming presidential election

sort cod_mun year 
by cod_mun, sort: gen relief_mv_bp = 1 if state_of_emergency[_n+1] == 1 & year_of_mayor_election ==1
by cod_mun, sort: replace relief_mv_bp = 1 if state_of_emergency[_n+2]   == 1 & year_of_mayor_election ==1
by cod_mun, sort: replace relief_mv_bp = 0 if relief_mv_bp ==. & year_of_mayor_election ==1
replace relief_mv_bp =. if year >=2016
label variable relief_mv_bp "Aid relief for drought"

* generate forcing variables

	*************************************************
	*	there are two types of forcing variables:	*
	*************************************************
	
	*	1) margin of victory of aligned candidates to study the allocation of aid relief for drought
		**	a) targeted to mayoral election
gen mv_bm_party = mv_party_1t
label variable mv_bm_party "Margin of victory of candidate in the president's party"
gen mv_bm_wing = mv_wing_1t

	**	b) targeted to presidential election
gen mv_bp_party = mv_party_2t
label variable mv_bp_party "Margin of victory of candidate in the president's party"
gen mv_bp_wing = mv_wing_2t
		
	*********************************************************
	*	there are two types of alignment effect to study	*
	*********************************************************

	* 1) alignment effect on the probability of getting an aid relief
		**	a) targeted to mayoral election
gen alg_mv_bm_party = elected_president_party_2t
label variable alg_mv_bm_party "Mayor in the same president's party"

		**	b) targeted to presidential election		
gen alg_mv_bp_party = elected_president_party_1t
label variable alg_mv_bp_party "Mayor in the same president's party"
	
* generate weather variables targeted to aid relief (what is the level of drought in order to get aid relief)

	// level of drought that affects allocation of aid relief targeted to affect forthcoming mayoral election

sort cod_mun year 
by cod_mun, sort: gen SPEI24_mv_bm = zscore_SPEI24[_n+4] if year_of_mayor_election ==1
label variable SPEI24_mv_bm "Standardized Precipitation Evapotranspiration Index (SPEI)"
	
	// level of drought that affects allocation of aid relief targeted to affect forthcoming presidential election

sort cod_mun year 
by cod_mun, sort: gen SPEI24_mv_bp = zscore_SPEI24[_n+2] if year_of_mayor_election ==1
label variable SPEI24_mv_bp "Standardized Precipitation Evapotranspiration Index (SPEI)"

* generate weather variables targeted to aid relief (what is the level of drought in order to get aid relief)

	// level of drought that affects allocation of aid relief targeted to affect forthcoming mayoral election

sort cod_mun year 
by cod_mun, sort: gen SPI24_mv_bm = zscore_rain24[_n+4] if year_of_mayor_election ==1
label variable SPI24_mv_bm "Standardized Precipitation Index (SPI)"
	
	// level of drought that affects allocation of aid relief targeted to affect forthcoming presidential election

sort cod_mun year 
by cod_mun, sort: gen SPI24_mv_bp = zscore_rain24[_n+2] if year_of_mayor_election ==1
label variable SPI24_mv_bp "Standardized Precipitation Index (SPI)"

* keep only relevant variables
keep if year_of_election~=.
cap drop if cod_mun == 0
cap drop if cod_mun == .

**************************************************************************************************************

* Definition of variables
	
* forcing variables: previous margin of victory of mayoral election (transfers)
foreach var in mv_bm_party /*
	*/	mv_bp_party {
	* build variables of higher polynomial orders of forcing variable	
	gen `var'_P1 = `var'
	gen `var'_P2 = `var'*`var'
	gen `var'_P3 = `var'*`var'*`var'
	* and build variables of interaction between treatment variable and forcing variable
	gen a_`var'_P1 = alg_`var'*`var'
	gen a_`var'_P2 = alg_`var'*`var'*`var'
	gen a_`var'_P3 = alg_`var'*`var'*`var'*`var'

}

* keep with only relevant variables
keep cod_mun year region micro_region uf zscore_SPEI12 zscore_SPEI24 zscore_rain12 zscore_rain24 taxa_rural taxa_water taxa_television taxa_radio taxa_energy populacao renda_media escolaridade_media taxa_jovem taxa_maior taxa_agricultura taxa_industria taxa_comercio taxa_transporte taxa_servico taxa_adm_publica taxa_ocupacao taxa_graduado taxa_pobreza taxa_miseria taxa_race taxa_gender taxa_evangelical taxa_high_school state_of_emergency state_of_emergency_lag1 distance_river share_gdp_agriculture fisher_index_adjusted relief_mv_bm relief_mv_bp mv_bm_party mv_bp_party alg_mv_bm_party alg_mv_bp_party SPEI24_mv_bm SPEI24_mv_bp SPI24_mv_bm SPI24_mv_bp mv_bm_party_P1 mv_bm_party_P2 mv_bm_party_P3 a_mv_bm_party_P1 a_mv_bm_party_P2 a_mv_bm_party_P3 mv_bp_party_P1 mv_bp_party_P2 mv_bp_party_P3 a_mv_bp_party_P1 a_mv_bp_party_P2 a_mv_bp_party_P3