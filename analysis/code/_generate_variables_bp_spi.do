********************************
*** GENERATION OF VARIABLES ***
********************************
 
* variable SPI24_mv_bp represents the SPI (Standarized Precipitation Index) during the two years preceding a mayoral election
* negative values of SPI represens droughts
* let's manipulate this variable in order to positive values represent droughts, for better interpretation of results

gen drought=-SPI24_mv_bp // positive values of SPI represent droughts
 

*** Generate a dummy account for the fact that negative values are non-drought for the 50-75 percentiles
gen low=(drought<0)
tab low
gen moderate=(drought<= 1 & drought>=0)
tab moderate
gen severe =(drought>1)
tab severe
assert moderate+severe+low==1 
 
***********************************************************
*** Regenerate baseline result in a better way visually ***
***********************************************************

*** Generate vars:
gen low_aligned=(low==1 & alg_mv_bp_party==1)
gen low_notaligned=(low==1 & alg_mv_bp_party==0)

gen moderate_aligned=(moderate==1 & alg_mv_bp_party==1)
gen moderate_notaligned=(moderate==1 & alg_mv_bp_party==0)

gen severe_aligned=(severe==1 & alg_mv_bp_party==1)
gen severe_notaligned=(severe==1 & alg_mv_bp_party==0)

* Label variables
label variable low_aligned "Aligned and low drought"
label variable low_notaligned "Non-aligned and low drought"
label variable moderate_aligned  "Aligned and moderate drought"
label variable moderate_notaligned "Non-aligned and moderate drought"
label variable severe_aligned  "Aligned and severe drought"
label variable severe_notaligned "Non-aligned and severe drought"
label variable mv_bp_party_P1 "Margin of victory"