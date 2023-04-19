**** OPTIMAL BANDWIDTH: Calonico, Cattaneo and Titiunik (2014b).	
rdbwselect relief_mv_bm mv_bm_party_P1 if mv_bm_party_P1~=., all
	global CCT_party = e(h_CCT) 
	global CCT_party : display %9.3fc $CCT_party

dis $CCT_party 

keep if ( mv_bm_party_P1 <= $CCT_party &   mv_bm_party_P1 >= -$CCT_party) & relief_mv_bm!=.


*** Keep relevant sample size:
reghdfe relief_mv_bm ///
alg_mv_bm_party mv_bm_party_P1 a_mv_bm_party_P1 ///
moderate_spei severe_spei ///
moderate_spei_aligned severe_spei_aligned ///
, cluster(cod_mun) absorb(cod_mun year)

keep if e(sample)==1


tab2 low_spei moderate_spei severe_spei low_spi moderate_spi severe_spi 
