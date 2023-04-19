

* cleaning data
use "$tmp\crucensus.dta", clear

* editing variables for merge
gen cod_ibge = cod_mun

cap tostring cod_ibge, replace
sort cod_ibge year
merge 1:n cod_ibge year using "$inpdir_s2id/s2id_all.dta", force
cap drop if _merge==2

* collapse at municipality and year level
by cod_ibge year, sort: egen iten1 = max(chuva)
by cod_ibge year, sort: replace chuva = iten1
cap drop iten1 

by cod_ibge year, sort: egen iten1 = max(seca)
by cod_ibge year, sort: replace seca = iten1
cap drop iten1 

by cod_ibge year, sort: egen iten1 = max(outros)
by cod_ibge year, sort: replace outros = iten1
cap drop iten1 

by cod_ibge year, sort: egen iten1 = max(todos)
by cod_ibge year, sort: replace todos = iten1
cap drop iten1 

/*
isid cod_ibge year
duplicates report cod_ibge year, tag
*/
duplicates drop cod_ibge year, force

* generate variable depicting state of emergency
sort cod_ibge year
gen state_of_emergency = 1 if seca ==1
replace state_of_emergency = 0 if seca ~=1
label variable state_of_emergency "State of emergency because of drought"

* generate variable depicting one year lag of state of emergency 
sort cod_ibge year
by cod_ibge, sort: gen state_of_emergency_lag1 = 1 if seca[_n-1] ==1 & year[_n] == year[_n-1] + 1
replace state_of_emergency_lag1 = 0 if state_of_emergency_lag ~=1
label variable state_of_emergency_lag1 "State of emergency because of drought (t-1)"

* drop _merge 
cap drop if _merge== 2
cap drop _merge
cap drop data_decreto data_portaria numero_decreto numero_portaria numero_dario_da_uniao rito chuva seca outros todos

* save temporary file
save "$tmp\crucensuss2id.dta", replace	
