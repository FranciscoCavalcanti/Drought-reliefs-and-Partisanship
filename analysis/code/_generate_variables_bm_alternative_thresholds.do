********************************
*** GENERATION OF VARIABLES ***
********************************

*** Generate a dummy account for the fact that negative values are non-drought for the 50-75 percentiles
cap drop low_alt mod_alt1 mod_alt2 sev_alt1 sev_alt2
gen low_alt=(drought<0)
tab low_alt
gen mod_alt1=(drought<= 0.5 & drought>=0)
tab mod_alt1
gen mod_alt2=(drought<= 1 & drought>0.5)
tab mod_alt2
gen sev_alt1 =(drought<= 2 & drought>1)
tab sev_alt1
gen sev_alt2 =(drought>2)
tab sev_alt2

assert low_alt+mod_alt1+mod_alt2+sev_alt1+sev_alt2==1 

***********************************************************
*** Regenerate baseline result in a better way visually ***
***********************************************************

*** Generate vars:
gen low_alt_aligned=(low_alt==1 & alg_mv_bm_party==1)
gen low_alt_notaligned=(low_alt==1 & alg_mv_bm_party==0)

gen mod_alt1_aligned=(mod_alt1==1 & alg_mv_bm_party==1)
gen mod_alt1_notaligned=(mod_alt1==1 & alg_mv_bm_party==0)

gen mod_alt2_aligned=(mod_alt2==1 & alg_mv_bm_party==1)
gen mod_alt2_notaligned=(mod_alt2==1 & alg_mv_bm_party==0)

gen sev_alt1_aligned=(sev_alt1==1 & alg_mv_bm_party==1)
gen sev_alt1_notaligned=(sev_alt1==1 & alg_mv_bm_party==0)

gen sev_alt2_aligned=(sev_alt2==1 & alg_mv_bm_party==1)
gen sev_alt2_notaligned=(sev_alt2==1 & alg_mv_bm_party==0)

* Label variables
label variable low_alt_aligned "Aligned and low drought"
label variable low_alt_notaligned "Non-aligned and low drought"

label variable mod_alt1_aligned  "Aligned and little moderate drought"
label variable mod_alt1_notaligned "Non-aligned and little moderate drought"

label variable mod_alt2_aligned  "Aligned and quite moderate drought"
label variable mod_alt2_notaligned "Non-aligned and quite moderate drought"

label variable sev_alt1_aligned  "Aligned and little severe drought"
label variable sev_alt1_notaligned "Non-aligned and little severe drought"

label variable sev_alt2_aligned  "Aligned and quite severe drought"
label variable sev_alt2_notaligned "Non-aligned and quite severe drought"

label variable mv_bm_party_P1 "Margin of victory"