
clear

set more off

* generate an id to every ground station data set
* use "$inpdir7_delaware\delaware.dta", clear
use "$inpdir7_delaware\_droughts_shortrun_by_cycle_1yr.dta", clear
merge 1:1 cod_mun year using "$inpdir7_delaware\_droughts_longrun_by_cycle_2yrs.dta"
drop _merge

* save as temporary file

save "$tmp\delaware.dta", replace
