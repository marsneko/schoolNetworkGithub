import delimited "/Users/eric/Documents/SchoolCourses/schoolNetworkGithub/analyzeCodes/tempdata/raw_in_out_cluster_with_sieve_109to107.csv",clear encoding(UTF-8)
est clear

*ssc install missings   
missings dropvars, force

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

* test network interaction 

mixed diffinclu i.cluster#c.incluster107 c.eigencentrality107 c.clustereigencentrality107#i.cluster i.cluster || ispublic: || iscity:, difficult
coefplot,base keep(*.cluster#c.incluster107)  rename(     ///                              
        1.cluster#c.incluster107 = "Cluster 1"			///
		2.cluster#c.incluster107 = "Cluster 2" 			///
        3.cluster#c.incluster107 = "Cluster 3" 			///
        4.cluster#c.incluster107 = "Cluster 4" 			///
        5.cluster#c.incluster107 = "Cluster 5" 			///
        6.cluster#c.incluster107 = "Cluster 6" 			///
        7.cluster#c.incluster107 = "Cluster 7" ) 			///
		title(Coef. of incluster (107) to diff. incluster, size(medium))		///
		level(90) ///
		ciopts(recast(rcap))                      /* 95% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		xscale(range(-1.5 0.5)) ///
		xlabel(-1.5(0.5)0.5) ///
		saving(p1,replace)
coefplot,base keep(*.cluster#c.clustereigencentrality107)  rename(     ///                              
        1.cluster#c.clustereigencentrality107 = "Cluster 1"			///
		2.cluster#c.clustereigencentrality107 = "Cluster 2" 			///
        3.cluster#c.clustereigencentrality107 = "Cluster 3" 			///
        4.cluster#c.clustereigencentrality107 = "Cluster 4" 			///
        5.cluster#c.clustereigencentrality107 = "Cluster 5" 			///
        6.cluster#c.clustereigencentrality107 = "Cluster 6" 			///
        7.cluster#c.clustereigencentrality107 = "Cluster 7" ) 			///
		title(Coef. of cluster centrality (107) to diff. incluster, size(small))		///
		level(90) ///
		ciopts(recast(rcap))                      /* 95% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		xscale(range(-1.5 0.5)) ///
		xlabel(-1.5(0.5)0.5) ///
		saving(p2,replace)
graph combine p1.gph p2.gph


mixed diffclcent i.cluster#c.incluster107 c.eigencentrality107 c.clustereigencentrality107#i.cluster i.cluster || ispublic: || iscity:, difficult
coefplot,base keep(*.cluster#c.incluster107)  rename(     ///                              
        1.cluster#c.incluster107 = "Cluster 1"			///
		2.cluster#c.incluster107 = "Cluster 2" 			///
        3.cluster#c.incluster107 = "Cluster 3" 			///
        4.cluster#c.incluster107 = "Cluster 4" 			///
        5.cluster#c.incluster107 = "Cluster 5" 			///
        6.cluster#c.incluster107 = "Cluster 6" 			///
        7.cluster#c.incluster107 = "Cluster 7" ) 			///
		title(Coef. of incluster (107) to diff. cluster centrality, size(small))		///
		level(90) ///
		ciopts(recast(rcap))                      /* 95% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		xscale(range(-1.5 0.5)) ///
		xlabel(-1.5(0.5)0.5) ///
		saving(p1,replace)
coefplot,base keep(*.cluster#c.clustereigencentrality107)  rename(     ///                              
        1.cluster#c.clustereigencentrality107 = "Cluster 1"			///
		2.cluster#c.clustereigencentrality107 = "Cluster 2" 			///
        3.cluster#c.clustereigencentrality107 = "Cluster 3" 			///
        4.cluster#c.clustereigencentrality107 = "Cluster 4" 			///
        5.cluster#c.clustereigencentrality107 = "Cluster 5" 			///
        6.cluster#c.clustereigencentrality107 = "Cluster 6" 			///
        7.cluster#c.clustereigencentrality107 = "Cluster 7" ) 			///
		title(Coef. of cluster centrality (107) to diff. cluster centrality, size(small))		///
		level(90) ///
		ciopts(recast(rcap))                      /* 95% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		xscale(range(-1.5 0.5)) ///
		xlabel(-1.5(0.5)0.5) ///
		saving(p2,replace)
graph combine p1.gph p2.gph
 
mixed diffcent i.cluster#c.incluster107 c.eigencentrality107#i.cluster c.clustereigencentrality107#i.cluster i.cluster || ispublic: || iscity:, difficult


 
 
