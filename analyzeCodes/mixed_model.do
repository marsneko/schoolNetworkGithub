import delimited "/Users/eric/Documents/SchoolCourses/schoolNetworkGithub/analyzeCodes/tempdata/raw_in_out_cluster_with_sieve_109to107.csv",clear encoding(UTF-8)
est clear

gen diffmainsieve1_rank = main_sieve1_byassigment_rank - main_sieve1_byassigment_rank_108 
gen diffmainsieve2_rank = main_sieve2_byassigment_rank - main_sieve2_byassigment_rank_108
egen mean_mainsieve1 = mean(main_sieve1_byassigment),by(cluster)
egen mean_mainsieve1_108 = mean(main_sieve1_byassigment_108),by(cluster)
egen sd_mainsieve1 = sd(main_sieve1_byassigment),by(cluster)
egen sd_mainsieve1_108 = sd(main_sieve1_byassigment_108),by(cluster)
gen std_mainsieve1 = (main_sieve1_byassigment - mean_mainsieve1)/sd_mainsieve1
gen std_mainsieve1_108 = (main_sieve1_byassigment_108 - mean_mainsieve1_108)/sd_mainsieve1_108
gen std_diffmainsieve1 = std_mainsieve1 - std_mainsieve1_108
gen diffmainsieve1 = main_sieve1_byassigment - main_sieve1_byassigment_108


egen rank_inclu107 = rank(incluster107), by(cluster)
egen rank_inclu108 = rank(incluster108), by(cluster)
egen total107 = count(incluster107), by(cluster)
egen total108 = count(incluster108), by(cluster)
gen pct_inclu107 = rank_inclu107/total107
gen pct_inclu108 = rank_inclu108/total108
gen pct_diffinclu = pct_inclu108 - pct_inclu107

gen diffinclu = incluster108 - incluster107
egen rank_diffinclu = rank(diffinclu), by(cluster)
egen total_diffinclu = count(diffinclu), by(cluster)
gen diffinclu_pct = rank_diffinclu/total_diffinclu


gen diffcent = eigencentrality108  - eigencentrality107 
egen rank_diffcent = rank(diffcent),by(cluster)
egen total_diffcent = count(diffcent),by(cluster)
gen diffcent_pct = rank_diffcent/ total_diffcent

gen diffclcent = clustereigencentrality108  - clustereigencentrality107 
egen rank_diffclcent = rank(diffclcent),by(cluster)
egen total_diffclcent = count(diffcent),by (cluster)
gen diffclcent_pct = rank_diffclcent / total_diffclcent

egen std_clustereigencentrality = std(clustereigencentrality)
egen std_clustereigencentrality108 = std(clustereigencentrality108)
egen std_clustereigencentrality107 = std(clustereigencentrality107)
gen std_diffclcent = std_clustereigencentrality108 - std_clustereigencentrality107

egen std_eigencentrality = std(eigencentrality)
egen std_eigencentrality108 = std(eigencentrality108)
egen std_eigencentrality107 = std(eigencentrality107)
gen std_diffcent = std_eigencentrality108 - std_eigencentrality107

egen std_inclu = std(incluster)
egen std_inclu107 = std(incluster107)
egen std_inclu108 = std(incluster108)
gen std_diffinclu = std_inclu108 - std_inclu107


forvalues clusnum = 1/7 {
	qui reg  std_diffmainsieve1 diffinclu if cluster == `clusnum'
	eststo:
}
esttab
est clear 






matrix results = J(7, 4, .)
mixed std_diffmainsieve1 c.std_diffclcent#i.cluster c.std_diffcent#i.cluster i.cluster|| ispublic: || iscity:, difficult


/*
forvalues clusnum = 1/7 {
    lincom std_diffclcent + `clusnum'.cluster#c.std_diffclcent

    local row = `clusnum' 
    local est = r(estimate)
    local se = r(se)
	
    local zval = `est'/`se'
    local pval = 2* (1- normal(abs(`zval')))

    matrix results[`row', 1] = `est'
    matrix results[`row', 2] = `se'
    matrix results[`row', 3] = `zval'
	matrix results[`row', 4] = `pval'
}


matrix rownames results =  cluster_1 cluster_2 cluster_3 cluster_4 cluster_5 cluster_6 cluster_7
matrix colnames results = Coef Standard_error z_value p_value

matlist results, names
*twoway (lfitci std_diffmainsieve1 std_diffinclu) (scatter std_diffmainsieve1 std_diffinclu, mcolor(navy) msize(vtiny)), by(cluster)

*/
coefplot,base keep(*.cluster#c.std_diffclcent)  rename(     ///                              
        1.cluster#c.std_diffclcent = "Cluster 1"			///
		2.cluster#c.std_diffclcent = "Cluster 2" 			///
        3.cluster#c.std_diffclcent = "Cluster 3" 			///
        4.cluster#c.std_diffclcent = "Cluster 4" 			///
        5.cluster#c.std_diffclcent = "Cluster 5" 			///
        6.cluster#c.std_diffclcent = "Cluster 6" 			///
        7.cluster#c.std_diffclcent = "Cluster 7" ) 			///
		title(Coef. of cluster centrality, size(medium))		///
		level(90) ///
		ciopts(recast(rcap))                      /* 95% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		saving(p1,replace)
		
coefplot,base keep(*.cluster#c.std_diffcent) rename( 		///
        1.cluster#c.std_diffcent = "Cluster 1"			///
		2.cluster#c.std_diffcent = "Cluster 2" 			///
        3.cluster#c.std_diffcent = "Cluster 3" 			///
        4.cluster#c.std_diffcent = "Cluster 4" 			///
        5.cluster#c.std_diffcent = "Cluster 5" 			///
        6.cluster#c.std_diffcent = "Cluster 6" 			///
        7.cluster#c.std_diffcent = "Cluster 7" )			///
		level(90) ///
		title(Coef. of centrality, size(medium))		///
		ciopts(recast(rcap))                      /* 95% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		saving(p2,replace)

coefplot,base keep(_cons *.cluster ) drop(1.cluster) ///
		sort ///
		rename(		///
		_cons = "Cluster 1"				///
		2.cluster = "Cluster 2" 			///
        3.cluster = "Cluster 3" 			///
        4.cluster = "Cluster 4" 			///
        5.cluster = "Cluster 5" 			///
        6.cluster = "Cluster 6" 			///
        7.cluster = "Cluster 7" ) 			///
		title(Intercept of each cluster , size(medium))  		///
		level(90) ///
		ciopts(recast(rcap))                      /* 95% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		saving(p3,replace)

graph combine p1.gph p2.gph 


