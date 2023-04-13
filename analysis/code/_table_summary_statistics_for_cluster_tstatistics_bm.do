/* REFERENCE
MacKinnon, James G. / Nielsen, Morten Ørregaard / Webb, Matthew D. 
Cluster-robust inference: A guide to empirical practice 
2022  Journal of Econometrics 
*/

**** OPTIMAL BANDWIDTH: Calonico, Cattaneo and Titiunik (2014b).	
rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1~=., all
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party

dis $CCT_party 
// $CCT_party = 0.117

keep if ( mv_bm_party_P1 <= $CCT_party &   mv_bm_party_P1 >= -$CCT_party) & relief_mv_bm!=.
count // 3,027

*** dummy variables
	cap drop d_year_*
	qui tab year, gen(d_year_)
	cap drop d_munic_*
	qui tab cod_mun, gen(d_munic_)

*** Keep relevant sample size:
reghdfe relief_mv_bm ///
alg_mv_bm_party mv_bm_party_P1 a_mv_bm_party_P1 ///
moderate severe ///
moderate_aligned severe_aligned ///
, cluster(cod_mun) absorb(cod_mun year)

keep if e(sample)==1
count // 1,507

/* package necessary to install:
ssc install boottest
*/

/*
The following example shows how to do so for: the wild cluster
bootstrap WCR (clustering by state); the wild bootstrap WR
clustering by state (MacKinnon and Webb, 2018); and multi-way
clustered by state and year.
*/


* For key regressions report measures of cluster level influence, leverage,
*and the effective number of clusters, shortly available with summclust
*summclust depvar, yvar(varname) xvar(varlist) cluster(varname) 

* Employ the wild cluster bootstrap by default, easily done with boottest.

	/*determine number of clusters under alternative*/
	*qui egen temp_indexa = group(`alt1') if temp_uhat !=. 
	*qui summ temp_indexa 
	*global G = r(max)
		
		
* Table 1  

set more off
set seed 98789

*clear all

cap log close
log using "$outdir\descriptive_statistics\_table_summary_statistics_for_cluster_tstatistics_bm.txt", text replace

timer clear 1
timer on 1 

* generate matrix of results
mata: tabone = J(6,21,.)

* name first rows
*mata:tabone[1,2] = "None: HC"
*mata:tabone[1,4] = "Municipality"
*mata:tabone[1,7] = "Microregion"
*mata:tabone[1,10] = "State:"
*mata:tabone[1,13] = "Year"
*mata:tabone[1,16] = "State & year: two-way"
*mata:tabone[1,19] = "Microregion & year: two-way"

* name first rows
*mata:tabone[2,1] = "Diff"
*mata:tabone[2,2] = "t-statistic"
*mata:tabone[2,3] = "P value, N(0, 1)"
*mata:tabone[2,4] = "t-statistic"
*mata:tabone[2,5] = "P value, t(764)"
*mata:tabone[2,6] = "P value, WCR"
*mata:tabone[2,7] = "t-statistic"
*mata:tabone[2,8] = "P value, t(764"
*mata:tabone[2,9] = "P value, WCR"
*mata:tabone[2,10] = "t-statistic"
*mata:tabone[2,11] = "P value, t(764"
*mata:tabone[2,12] = "P value, WCR"
*mata:tabone[2,13] = "t-statistic"
*mata:tabone[2,14] = "P value, t(764"
*mata:tabone[2,15] = "P value, WCR"
*mata:tabone[2,16] = "t-statistic"
*mata:tabone[2,17] = "P value, t(14)"
*mata:tabone[2,18] = "P value, WCR (state)"
*mata:tabone[2,19] = "t-statistic"
*mata:tabone[2,20] = "P value, t(8)"
*mata:tabone[2,21] = "P value, WCR (year)"

******************************************************* 
** Build column of results regarding:
** low_aligned = low_notaligned
******************************************************

	qui reg relief_mv_bm ///
	mv_bm_party_P1 a_mv_bm_party_P1 ///
	low_aligned /*low_notaligned*/ ///
	moderate_aligned moderate_notaligned ///
	severe_aligned severe_notaligned ///
	d_year_* d_munic_* ///
	, robust nocons
	
	* Cluster: None - HC1	
	local beta = _b[low_aligned]
	local beta : display %9.3f `beta'
	mata:tabone[3,1] = `beta'
	
	test low_aligned = 0
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,2] = `t' // t-statistic
		mata:tabone[3,3] = `p' // P value, N(0, 1)
		
	* cod_mun: CV1
	waldtest low_aligned = 0, cluster(cod_mun) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,4] = `t'  // t-statistic
		mata:tabone[3,5] = `p' // P value, t(?)
		
	* cod_mun: CV1
	* WCR
	boottest low_aligned = 0, cluster(cod_mun) noci weight(webb)  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,6] = `p' // P value, WCR		
		
	* micro_region: CV1
	waldtest low_aligned = 0, cluster(micro_region) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,7] = `t'  // t-statistic
		mata:tabone[3,8] = `p' // P value, t(?)
		
	* micro_region: CV1 
	* WCR
	boottest low_aligned = 0, cluster(micro_region) noci  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,9] = `p' // P value, WCR
		
	* uf: CV1
	waldtest low_aligned = 0, cluster(uf) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,10] = `t'  // t-statistic
		mata:tabone[3,11] = `p' // P value, t(?)		
	
	* uf: CV1 
	* WCR
	boottest low_aligned = 0, cluster(uf) noci weight(webb) 
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,12] = `p' // P value, WCR
		
	* year: CV1
	waldtest low_aligned = 0, cluster(year) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,13] = `t'  // t-statistic
		mata:tabone[3,14] = `p' // P value, t(?)		
		
	* year: CV1 
	* WCR	
	boottest low_aligned = 0, cluster(uf) noci weight(webb) 
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,15] = `p'		
	
	* uf and year: two-way CV1
	waldtest low_aligned = 0, cluster(uf year) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,16] = `t'  // t-statistic
		mata:tabone[3,17] = `p' // P value, t(?)
			
	* uf and year: two-way CV1
	* WCR
	boottest low_aligned = 0, cluster(uf year) bootcluster(uf) noci  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,18] = `p' // P value, WCR (year)

	* micro_region and year: two-way CV1
	waldtest low_aligned = 0, cluster(micro_region year) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,19] = `t' // t-statistic
		mata:tabone[3,20] = `p' // P value, t(?)
	
	* micro_region and year: two-way CV1
	** P value, WCR (micro_region)
	boottest low_aligned = 0, cluster(micro_region year) bootcluster(year) noci  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[3,21] = `p' // P value, WCR (micro_region)


******************************************************* 
** Build column of results regarding:
** moderate_aligned = moderate_notaligned
******************************************************
	qui reg relief_mv_bm ///
	mv_bm_party_P1 a_mv_bm_party_P1 ///
	low_aligned /*low_notaligned*/ ///
	moderate_aligned moderate_notaligned ///
	severe_aligned severe_notaligned ///
	d_year_* d_munic_* ///
	, robust nocons
	
	* Cluster: None - HC1	
	local beta = _b[moderate_aligned] - _b[moderate_notaligned]
	local beta : display %9.3f `beta'
	mata:tabone[4,1] = `beta'
	
	test moderate_aligned = moderate_notaligned
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,2] = `t' // t-statistic
		mata:tabone[4,3] = `p' // P value, N(0, 1)
		
	* cod_mun: CV1
	waldtest moderate_aligned = moderate_notaligned, cluster(cod_mun) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,4] = `t'  // t-statistic
		mata:tabone[4,5] = `p' // P value, t(?)
		
	* cod_mun: CV1
	* WCR
	boottest moderate_aligned = moderate_notaligned, cluster(cod_mun) noci weight(webb)  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,6] = `p' // P value, WCR		
		
	* micro_region: CV1
	waldtest moderate_aligned = moderate_notaligned, cluster(micro_region) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,7] = `t'  // t-statistic
		mata:tabone[4,8] = `p' // P value, t(?)
		
	* micro_region: CV1 
	* WCR
	boottest moderate_aligned = moderate_notaligned, cluster(micro_region) noci  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,9] = `p' // P value, WCR
		
	* uf: CV1
	waldtest moderate_aligned = moderate_notaligned, cluster(uf) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,10] = `t'  // t-statistic
		mata:tabone[4,11] = `p' // P value, t(?)		
	
	* uf: CV1 
	* WCR
	boottest moderate_aligned = moderate_notaligned, cluster(uf) noci weight(webb) 
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,12] = `p' // P value, WCR
		
	* year: CV1
	waldtest moderate_aligned = moderate_notaligned, cluster(year) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,13] = `t'  // t-statistic
		mata:tabone[4,14] = `p' // P value, t(?)		
		
	* year: CV1 
	* WCR	
	boottest moderate_aligned = moderate_notaligned, cluster(uf) noci weight(webb) 
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,15] = `p'		
	
	* uf and year: two-way CV1
	waldtest moderate_aligned = moderate_notaligned, cluster(uf year) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,16] = `t'  // t-statistic
		mata:tabone[4,17] = `p' // P value, t(?)
			
	* uf and year: two-way CV1
	* WCR
	boottest moderate_aligned = moderate_notaligned, cluster(uf year) bootcluster(uf) noci  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,18] = `p' // P value, WCR (year)

	* micro_region and year: two-way CV1
	waldtest moderate_aligned = moderate_notaligned, cluster(micro_region year) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,19] = `t' // t-statistic
		mata:tabone[4,20] = `p' // P value, t(?)
	
	* micro_region and year: two-way CV1
	** P value, WCR (micro_region)
	boottest moderate_aligned = moderate_notaligned, cluster(micro_region year) bootcluster(year) noci  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[4,21] = `p' // P value, WCR (micro_region)
		

******************************************************* 
** Build column of results regarding:
** severe_aligned = severe_notaligned
******************************************************
	qui reg relief_mv_bm ///
	mv_bm_party_P1 a_mv_bm_party_P1 ///
	low_aligned /*low_notaligned*/ ///
	moderate_aligned moderate_notaligned ///
	severe_aligned severe_notaligned ///
	d_year_* d_munic_* ///
	, robust nocons
	
	* Cluster: None - HC1	
	local beta = _b[severe_aligned] - _b[severe_notaligned]
	local beta : display %9.3f `beta'
	mata:tabone[5,1] = `beta'
	
	test severe_aligned = severe_notaligned
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,2] = `t' // t-statistic
		mata:tabone[5,3] = `p' // P value, N(0, 1)
		
	* cod_mun: CV1
	waldtest severe_aligned = severe_notaligned, cluster(cod_mun) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,4] = `t'  // t-statistic
		mata:tabone[5,5] = `p' // P value, t(?)
		
	* cod_mun: CV1
	* WCR
	boottest severe_aligned = severe_notaligned, cluster(cod_mun) noci weight(webb)  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,6] = `p' // P value, WCR		
		
	* micro_region: CV1
	waldtest severe_aligned = severe_notaligned, cluster(micro_region) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,7] = `t'  // t-statistic
		mata:tabone[5,8] = `p' // P value, t(?)
		
	* micro_region: CV1 
	* WCR
	boottest severe_aligned = severe_notaligned, cluster(micro_region) noci  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,9] = `p' // P value, WCR
		
	* uf: CV1
	waldtest severe_aligned = severe_notaligned, cluster(uf) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,10] = `t'  // t-statistic
		mata:tabone[5,11] = `p' // P value, t(?)		
	
	* uf: CV1 
	* WCR
	boottest severe_aligned = severe_notaligned, cluster(uf) noci weight(webb) 
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,12] = `p' // P value, WCR
		
	* year: CV1
	waldtest severe_aligned = severe_notaligned, cluster(year) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,13] = `t'  // t-statistic
		mata:tabone[5,14] = `p' // P value, t(?)		
		
	* year: CV1 
	* WCR	
	boottest severe_aligned = severe_notaligned, cluster(uf) noci weight(webb) 
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,15] = `p'		
	
	* uf and year: two-way CV1
	waldtest severe_aligned = severe_notaligned, cluster(uf year) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,16] = `t'  // t-statistic
		mata:tabone[5,17] = `p' // P value, t(?)
			
	* uf and year: two-way CV1
	* WCR
	boottest severe_aligned = severe_notaligned, cluster(uf year) bootcluster(uf) noci  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,18] = `p' // P value, WCR (year)

	* micro_region and year: two-way CV1
	waldtest severe_aligned = severe_notaligned, cluster(micro_region year) noci
	
		local t = sqrt(r(F))
		local t : display %9.3f `t'
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,19] = `t' // t-statistic
		mata:tabone[5,20] = `p' // P value, t(?)
	
	* micro_region and year: two-way CV1
	** P value, WCR (micro_region)
	boottest severe_aligned = severe_notaligned, cluster(micro_region year) bootcluster(year) noci  
	
		local p = r(p)
		local p : display %9.3f `p'
		mata:tabone[5,21] = `p' // P value, WCR (micro_region)		

		
mata: tabone'
/*
after running "mata: tabone'"
one should manually convert the table in the console to a costumize table
*/

cap log close
 
exit
 