

* cleaning data

use "$tmp\crucensuss2idmunidetail.dta", clear

* editing variables for merge

gen year_of_election = 1996 if year == 1996
replace year_of_election = 1998 if year == 1998
replace year_of_election = 2000 if year == 2000
replace year_of_election = 2002 if year == 2002
replace year_of_election = 2004 if year == 2004
replace year_of_election = 2006 if year == 2006
replace year_of_election = 2008 if year == 2008
replace year_of_election = 2010 if year == 2010
replace year_of_election = 2012 if year == 2012
replace year_of_election = 2014 if year == 2014
replace year_of_election = 2016 if year == 2016
replace year_of_election = 2018 if year == 2018
replace year_of_election = 2020 if year == 2020

* merge tse mayors
merge n:1 cod_tse year_of_election using "$inpdir_tse/tse_mayor.dta", force
drop if _merge== 2
drop _merge

* save temporary file
save "$tmp\crucensuss2idmunidetailtse.dta", replace	
