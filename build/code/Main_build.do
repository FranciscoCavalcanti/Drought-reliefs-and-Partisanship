////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Build data for: Drought-reliefs and Partisanship ///  
/// Boffa-Cavalcanti-Fons-Rosen-Piolatto (Oxford Bulletin of Economics and Statistics) 
////////////////////////////////////////////////////////////////////////////////////////////////////////////

clear all
discard
set more off
capture log close
version 16.1

* set path of folder
* for instance:
global ROOT "C:/Users/DELL/Documents/GitHub/Drought-reliefs-and-Partisanship"

* make sure to set all macro globals
global inpdir				"${ROOT}/data"
global outdir				"${ROOT}/build/output"
global codedir    			"${ROOT}/build/code"
global tmp					"${ROOT}/build/tmp"

global inpdir_census		"${ROOT}/build/input/census"  
global inpdir_s2id			"${ROOT}/build/input/s2id"  
global inpdir_munic			"${ROOT}/build/input/municipalities_details"  
global inpdir_tse			"${ROOT}/build/input/tse"
global inpdir_cru			"${ROOT}/build/input/cru"

/* Make sure folders exist */
capture mkdir "${tmp}"
capture mkdir "${outdir}"

* Creating dataset
	do "$codedir/_do_cru.do"
	do "$codedir/_do_census.do"	
	do "$codedir/_do_s2id.do"
	do "$codedir/_do_muni_detail.do"
	do "$codedir/_do_tse.do"
	do "$codedir/_building_variables.do"
	
* Saving dataset
save "$outdir/main_database.dta", replace 

* delete temporary files

cd  "${tmp}/"
local datafiles: dir "${tmp}/" files "*.dta"
foreach datafile of local datafiles {
        rm `datafile'
}

* clear all

clear

