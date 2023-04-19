

* cleaning data
use "$tmp\crucensuss2id.dta", clear
gen muncoddv = cod_ibge
tostring muncoddv, replace
merge n:n muncoddv using "$inpdir_munic/brazilian_municipalities.dta", force

* generate variable depicting micro region
gen micro_region = microcod
destring micro_region, replace 
label variable micro_region "Micro region"
label variable uf "State"

* drop _merge 
drop if _merge== 2
drop _merge

* merge distance from river
destring cod_ibge, replace
merge n:1 cod_ibge using "$inpdir_munic/distance_river.dta", force
drop if _merge== 2
drop _merge

* merge gini from census 2000
merge n:1 cod_ibge using "$inpdir_munic/gini_census_2000.dta", force
drop if _merge== 2
drop _merge

* merge media radio
gen id_munic_7 = cod_ibge
destring id_munic_7, replace
merge n:1 id_munic_7 using "$inpdir_munic/media_radio_munic_2006.dta", force
drop if _merge== 2
drop _merge
label variable rdiocomunitriaexistncia "Local radio"
label variable jornalimpressolocalexistncia "Local newspaper"

* merge gdp
cap destring cod_mun, replace
merge 1:1 cod_mun year using "$inpdir_munic/share_gdp_agriculture.dta", force
drop if _merge== 2
drop _merge

* merge pam
cap destring cod_ibge, replace
merge 1:1 cod_ibge year using "$inpdir_munic/pam_agricultural_production_fisher_index.dta", force
drop if _merge== 2
drop _merge

* save temporary file
save "$tmp\crucensuss2idmunidetail.dta", replace	
