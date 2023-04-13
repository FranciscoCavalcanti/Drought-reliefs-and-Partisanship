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


* For key regressions rep*and the effective number of clusters, shortly available with summclust
*summclust depvar, yvar(varname) xvar(varlist) cluster(varname) 

* Employ the wild cluster bootstrap by default, easily done with boottest.

	/*determine number of clusters under alternative*/
	*qui egen temp_indexa = group(`alt1') if temp_uhat !=. 
	*qui summ temp_indexa 
	*global G = r(max)
		
		
* Table 3 Summary statistics for cluster heterogeneity

set more off
set seed 98789

*clear all

cap log close
log using "$outdir\descriptive_statistics\_table_summary_statistics_for_cluster_heterogeneity_bm.txt", text replace

timer clear 1
timer on 1 

* generate matrix of results
mata: tabthree = J(6,8,.)

/*determine number of clusters*/
macro drop N_Clusters
qui egen temp_indexa = group(cod_mun)
qui summ temp_indexa 
global N_Clusters = r(max)
cap drop temp_indexa
	
/*one way CV1 and CV3 */
summclust moderate_aligned, ///
yvar(relief_mv_bm) ///
xvar( low_aligned moderate_notaligned severe_aligned severe_notaligned mv_bm_party_P1 a_mv_bm_party_P1) ///
fevar(cod_mun year) ///
cluster(cod_mun) rho(0.5) jack
 	
	mata:tabthree[1,1] = $N_Clusters
	mata:tabthree[1,2] = gstarzero // Effective Number of Clusters: G*(0)
	mata:tabthree[1,3] = clustsum[4,1] // Cluster Variability - mean
	mata:tabthree[1,4] = clustsum[1,1] // Cluster Variability - min
	mata:tabthree[1,5] = clustsum[2,1] // Cluster Variability -  q1
	mata:tabthree[1,6] = clustsum[3,1] // Cluster Variability -  median
	mata:tabthree[1,7] = clustsum[5,1] // Cluster Variability -  q3
	mata:tabthree[1,8] = clustsum[6,1] // Cluster Variability -  max 
	
/*determine number of clusters*/
macro drop N_Clusters
qui egen temp_indexa = group(micro_region)
qui summ temp_indexa 
global N_Clusters = r(max)
cap drop temp_indexa
	
/*one way CV1 and CV3 */
summclust moderate_aligned, ///
yvar(relief_mv_bm) ///
xvar( low_aligned moderate_notaligned severe_aligned severe_notaligned mv_bm_party_P1 a_mv_bm_party_P1) ///
fevar(cod_mun year) ///
 cluster(micro_region) rho(0.5) jack	
	
	mata:tabthree[2,1] = $N_Clusters
	mata:tabthree[2,2] = gstarzero // Effective Number of Clusters: G*(0)
	mata:tabthree[2,3] = clustsum[4,1] // Cluster Variability - mean
	mata:tabthree[2,4] = clustsum[1,1] // Cluster Variability - min
	mata:tabthree[2,5] = clustsum[2,1] // Cluster Variability -  q1
	mata:tabthree[2,6] = clustsum[3,1] // Cluster Variability -  median
	mata:tabthree[2,7] = clustsum[5,1] // Cluster Variability -  q3
	mata:tabthree[2,8] = clustsum[6,1] // Cluster Variability -  max 
	
/*determine number of clusters*/
macro drop N_Clusters
qui egen temp_indexa = group(uf)
qui summ temp_indexa 
global N_Clusters = r(max)
cap drop temp_indexa
		
/*one way CV1 and CV3 */
summclust moderate_aligned, ///
yvar(relief_mv_bm) ///
xvar( low_aligned moderate_notaligned severe_aligned severe_notaligned mv_bm_party_P1 a_mv_bm_party_P1) ///
fevar(cod_mun year) ///
 cluster(uf) rho(0.5) jack	
 	
	mata:tabthree[3,1] = $N_Clusters
	mata:tabthree[3,2] = gstarzero // Effective Number of Clusters: G*(0)
	mata:tabthree[3,3] = clustsum[4,1] // Cluster Variability - mean
	mata:tabthree[3,4] = clustsum[1,1] // Cluster Variability - min
	mata:tabthree[3,5] = clustsum[2,1] // Cluster Variability -  q1
	mata:tabthree[3,6] = clustsum[3,1] // Cluster Variability -  median
	mata:tabthree[3,7] = clustsum[5,1] // Cluster Variability -  q3
	mata:tabthree[3,8] = clustsum[6,1] // Cluster Variability -  max 
	
/*determine number of clusters*/
macro drop N_Clusters
qui egen temp_indexa = group(year)
qui summ temp_indexa 
global N_Clusters = r(max)
cap drop temp_indexa
		
/*one way CV1 and CV3 */
summclust moderate_aligned, ///
yvar(relief_mv_bm) ///
xvar( low_aligned moderate_notaligned severe_aligned severe_notaligned mv_bm_party_P1 a_mv_bm_party_P1) ///
fevar(cod_mun year) ///
 cluster(year) rho(0.5) jack	
 
	mata:tabthree[4,1] = $N_Clusters
	mata:tabthree[4,2] = gstarzero // Effective Number of Clusters: G*(0)
	mata:tabthree[4,3] = clustsum[4,1] // Cluster Variability - mean
	mata:tabthree[4,4] = clustsum[1,1] // Cluster Variability - min
	mata:tabthree[4,5] = clustsum[2,1] // Cluster Variability -  q1
	mata:tabthree[4,6] = clustsum[3,1] // Cluster Variability -  median
	mata:tabthree[4,7] = clustsum[5,1] // Cluster Variability -  q3
	mata:tabthree[4,8] = clustsum[6,1] // Cluster Variability -  max 
	
	
* state x year
/*determine number of clusters*/
macro drop N_Clusters
qui egen temp_indexa = group(uf year)
qui summ temp_indexa 
global N_Clusters = r(max)
		
/*one way CV1 and CV3 */
summclust moderate_aligned, ///
yvar(relief_mv_bm) ///
xvar( low_aligned moderate_notaligned severe_aligned severe_notaligned mv_bm_party_P1 a_mv_bm_party_P1) ///
fevar(cod_mun year) ///
 cluster(temp_indexa) rho(0.5) jack	
 
	mata:tabthree[5,1] = $N_Clusters
	mata:tabthree[5,2] = gstarzero // Effective Number of Clusters: G*(0)
	mata:tabthree[5,3] = clustsum[4,1] // Cluster Variability - mean
	mata:tabthree[5,4] = clustsum[1,1] // Cluster Variability - min
	mata:tabthree[5,5] = clustsum[2,1] // Cluster Variability -  q1
	mata:tabthree[5,6] = clustsum[3,1] // Cluster Variability -  median
	mata:tabthree[5,7] = clustsum[5,1] // Cluster Variability -  q3
	mata:tabthree[5,8] = clustsum[6,1] // Cluster Variability -  max 	
	
cap drop temp_indexa	
	
* state x year
/*determine number of clusters*/
macro drop N_Clusters
qui egen temp_indexa = group(micro_region year)
qui summ temp_indexa 
global N_Clusters = r(max)
		
/*one way CV1 and CV3 */
summclust moderate_aligned, ///
yvar(relief_mv_bm) ///
xvar( low_aligned moderate_notaligned severe_aligned severe_notaligned mv_bm_party_P1 a_mv_bm_party_P1) ///
fevar(cod_mun year) ///
 cluster(temp_indexa) rho(0.5) jack	
 
	mata:tabthree[6,1] = $N_Clusters
	mata:tabthree[6,2] = gstarzero // Effective Number of Clusters: G*(0)
	mata:tabthree[6,3] = clustsum[4,1] // Cluster Variability - mean
	mata:tabthree[6,4] = clustsum[1,1] // Cluster Variability - min
	mata:tabthree[6,5] = clustsum[2,1] // Cluster Variability -  q1
	mata:tabthree[6,6] = clustsum[3,1] // Cluster Variability -  median
	mata:tabthree[6,7] = clustsum[5,1] // Cluster Variability -  q3
	mata:tabthree[6,8] = clustsum[6,1] // Cluster Variability -  max
	
cap drop temp_indexa
	
mata: tabthree

/*
after running "mata: tabthree"
one should manually convert the table in the console to a costumize table
*/

cap log close
 
exit
	