
clear

set more off

* generate an id to every ground station data set
use "$inpdir_cru\_droughts_shortrun_by_cycle_1yr.dta", clear

* save as temporary file
save "$tmp\cru.dta", replace
