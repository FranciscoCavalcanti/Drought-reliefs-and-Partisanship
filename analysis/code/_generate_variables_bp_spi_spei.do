********************************
*** GENERATION OF VARIABLES ***
********************************

* variable SPI24_mv_bp represents the SPI (Standardized Precipitation Index (SPI)) during the two years preceding a mayoral election
* negative values of SPI represens droughts
* let's manipulate this variable in order to positive values represent droughts, for better interpretation of results

gen drought_spi= -SPI24_mv_bp // positive values of SPI represent droughts

gen drought_spei= -SPEI24_mv_bp // positive values of SPEI represent droughts

*** Generate a dummy account for the fact that negative values are non-drought for the 50-75 percentiles
gen low_spi=(drought_spi<0)
tab low_spi
gen moderate_spi=(drought_spi<= 1 & drought_spi>=0)
tab moderate_spi
gen severe_spi =(drought_spi>1)
tab severe_spi
assert moderate_spi+severe_spi+low_spi==1 

gen low_spei=(drought_spei<0)
tab low_spei
gen moderate_spei=(drought_spei<= 1 & drought_spei>=0)
tab moderate_spei
gen severe_spei =(drought_spei>1)
tab severe_spei
assert moderate_spei+severe_spei+low_spei==1 

***********************************************************
*** Regenerate baseline result in a better way visually ***
***********************************************************

*** Generate vars:
gen low_spi_aligned=(low_spi==1 & alg_mv_bp_party==1)
gen low_spi_notaligned=(low_spi==1 & alg_mv_bp_party==0)

gen moderate_spi_aligned=(moderate_spi==1 & alg_mv_bp_party==1)
gen moderate_spi_notaligned=(moderate_spi==1 & alg_mv_bp_party==0)

gen severe_spi_aligned=(severe_spi==1 & alg_mv_bp_party==1)
gen severe_spi_notaligned=(severe_spi==1 & alg_mv_bp_party==0)

gen low_spei_aligned=(low_spei==1 & alg_mv_bp_party==1)
gen low_spei_notaligned=(low_spei==1 & alg_mv_bp_party==0)

gen moderate_spei_aligned=(moderate_spei==1 & alg_mv_bp_party==1)
gen moderate_spei_notaligned=(moderate_spei==1 & alg_mv_bp_party==0)

gen severe_spei_aligned=(severe_spei==1 & alg_mv_bp_party==1)
gen severe_spei_notaligned=(severe_spei==1 & alg_mv_bp_party==0)

* Label variables
label variable mv_bp_party_P1 "Margin of victory"

label variable low_spi_aligned "Aligned and low drought (SPI)"
label variable low_spi_notaligned "Non-aligned and low drought (SPI)"
label variable moderate_spi_aligned  "Aligned and moderate drought (SPI)"
label variable moderate_spi_notaligned "Non-aligned and moderate drought (SPI)"
label variable severe_spi_aligned  "Aligned and severe drought (SPI)"
label variable severe_spi_notaligned "Non-aligned and severe drought (SPI)"

label variable low_spei_aligned "Aligned and low drought (SPEI)"
label variable low_spei_notaligned "Non-aligned and low drought (SPEI)"
label variable moderate_spei_aligned  "Aligned and moderate drought (SPEI)"
label variable moderate_spei_notaligned "Non-aligned and moderate drought (SPEI)"
label variable severe_spei_aligned  "Aligned and severe drought (SPEI)"
label variable severe_spei_notaligned "Non-aligned and severe drought (SPEI)"

