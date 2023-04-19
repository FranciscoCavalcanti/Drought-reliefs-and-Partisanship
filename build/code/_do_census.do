

* cleaning data
cap use "$tmp\cru.dta", clear

//gen cod_mun = cod_ibge
merge n:1 cod_mun using "$inpdir_census/census2000.dta"

* obs: 3 municipalities did not exist in the 2000 census
** generating a vaiable to indicate those municipalities that did not exist in the 2000 census

gen no_census_data = 1 if _merge==1
replace no_census_data = 0 if no_census_data~=1

label var no_census_data "municipalities did not exist in 2000 census"

* drop _merge 
drop if _merge== 2
drop _merge

* save temporary file

save "$tmp\crucensus.dta", replace	
