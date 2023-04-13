********************************
*** GENERATION OF VARIABLES ***
********************************
 
*** Generate a dummy account for the fact that negative values are non-drought for the 50-75 percentiles
cap drop low_alt mod_alt sev_alt
gen low_alt=(drought<0.00)
tab low_alt
gen mod_alt=(drought<= 1.5 & drought>=0.00)
tab mod_alt
gen sev_alt =(drought>1.5)
tab sev_alt

assert low_alt+mod_alt+sev_alt==1 

***********************************************************
*** Regenerate baseline result in a better way visually ***
***********************************************************

*** Generate vars:
gen low_alt_aligned=(low_alt==1 & alg_mv_bp_party==1)
gen low_alt_notaligned=(low_alt==1 & alg_mv_bp_party==0)

gen mod_alt_aligned=(mod_alt==1 & alg_mv_bp_party==1)
gen mod_alt_notaligned=(mod_alt==1 & alg_mv_bp_party==0)

gen sev_alt_aligned=(sev_alt==1 & alg_mv_bp_party==1)
gen sev_alt_notaligned=(sev_alt==1 & alg_mv_bp_party==0)

* Label variables
label variable low_alt_aligned "Aligned and low drought"
label variable low_alt_notaligned "Non-aligned and low drought"

label variable mod_alt_aligned  "Aligned and moderate drought"
label variable mod_alt_notaligned "Non-aligned and moderate drought"

label variable sev_alt_aligned  "Aligned and severe drought"
label variable sev_alt_notaligned "Non-aligned and severe drought"

label variable mv_bp_party_P1 "Margin of victory"
