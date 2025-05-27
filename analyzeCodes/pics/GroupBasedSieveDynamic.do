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



egen std_clustereigencentrality = std(clustereigencentrality)
egen std_clustereigencentrality108 = std(clustereigencentrality)
egen std_clustereigencentrality107 = std(clustereigencentrality108)
gen std_diffclcent = std_clustereigencentrality108 - std_clustereigencentrality107

gen diffclcent = clustereigencentrality - clustereigencentrality108

egen std_eigencentrality = std(eigencentrality)
egen std_eigencentrality108 = std(eigencentrality)
egen std_eigencentrality107 = std(eigencentrality108)
gen std_diffcent = std_eigencentrality108 - std_eigencentrality107

gen diffcent = eigencentrality - eigencentrality108

egen std_inclu = std(incluster)
egen std_inclu107 = std(incluster108)
egen std_inclu108 = std(incluster)
gen std_diffinclu = std_inclu108 - std_inclu107

gen diffinclu = incluster - incluster108


gen diffmainsieve1_bin = diffmainsieve1

replace diffmainsieve1_bin = 1 if diffmainsieve1 > 0
replace diffmainsieve1_bin = -1 if diffmainsieve1 < 0

gen diffinclu_bin = diffinclu
gen diffcent_bin = diffcent
gen diffclcent_bin = diffclcent


gen high_group = .
replace high_group = 1 if inlist(cluster,1,2,3,4)
replace high_group = 0 if inlist(cluster,5,6,7)

mixed std_diffclcent i.high_group#c.std_diffmainsieve1 i.high_group || ispublic: || iscity:, difficult
coefplot,base keep(*.high_group#c.std_diffmainsieve1)  rename(     ///                              
        1.high_group#c.std_diffmainsieve1 = "High sieve group"			///
		0.high_group#c.std_diffmainsieve1 = "Low sieve group" 			///
        ) 			///
		title(Coef. of mainsieve change to cluster centrality change, size(small))		///
		level(90) ///
		ciopts(recast(rcap))                      /* 90% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		saving(p1,replace)


mixed std_diffcent i.high_group#c.std_diffmainsieve1 i.high_group || ispublic: || iscity:, difficult
coefplot,base keep(*.high_group#c.std_diffmainsieve1)  rename(     ///                              
        1.high_group#c.std_diffmainsieve1 = "High sieve group"			///
		0.high_group#c.std_diffmainsieve1 = "Low sieve group" 			///
        ) 			///
		title(Coef. of mainsieve change to  centrality change, size(small))		///
		level(90) ///
		ciopts(recast(rcap))                      /* 90% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		saving(p2,replace)


mixed std_diffinclu i.high_group#c.std_diffmainsieve1 i.high_group || ispublic: || iscity:, difficult
coefplot,base keep(*.high_group#c.std_diffmainsieve1)  rename(     ///                              
        1.high_group#c.std_diffmainsieve1 = "High sieve group"			///
		0.high_group#c.std_diffmainsieve1 = "Low sieve group" 			///
        ) 			///
		title(Coef. of mainsieve change to incluster change, size(small))		///
		level(90) ///
		ciopts(recast(rcap))                      /* 90% CI 畫誤差棒 */ ///
		msymbol(O) mcolor(navy)                   /* 點樣式、顏色 */ ///
		xline(0, lcolor(gs10))   						 ///
		saving(p3,replace)
graph combine p1.gph p2.gph p3.gph


/*
*------------------------------------------------------------------------------
preserve

* 建立指示變數
tabulate diffinclu_bin, generate(dm_)   // 會產生 dm_1 dm_2 … dm_k

graph bar (sum) dm_* if diffmainsieve1_bin==-1,      ///
    over(cluster, gap(2))                      ///
    stack asyvars                              ///
    percent                                    ///
    ytitle("percentage")                           ///
    legend(order(1 "decrease" 2 "no change" 3 "increase" )) ///
    title("Distribution of mainsieve change when incluster increasing")
restore




* 先分類為 -1（減少）, 0（不變）, 1（增加）
foreach var in diffinclu diffcent diffclcent diffmainsieve1{

    * 接著轉換為 0=減少, 1=不變, 2=增加
    gen `var'_cat = .    
    replace `var'_cat = 0 if `var'_bin == -1 | `var'_bin == 0
    replace `var'_cat = 1 if `var'_bin == 1

    * 加上標籤
    label define change_lbl 0 "decrease or no change" 1 "increase" , replace
    label values `var'_cat change_lbl
}


tab diffinclu_cat diffmainsieve1_cat, chi2 cchi2
tab diffcent_bin diffmainsieve1_bin, chi cchi2
tab diffclcent_bin diffmainsieve1_bin, chi cchi2


melogit diffclcent_cat i.cluster#i.diffmainsieve1_cat i.cluster || ispublic: || iscity:, difficult
margins, dydx(diffmainsieve1_cat) over(cluster)
marginsplot


melogit diffcent_cat i.cluster#i.diffmainsieve1_cat i.cluster || ispublic: || iscity:, difficult
margins, dydx(diffmainsieve1_cat) over(cluster)
marginsplot 

melogit diffinclu_cat i.cluster#i.diffmainsieve1_cat i.cluster || ispublic: || iscity:, difficult
margins, dydx(diffmainsieve1_cat) over(cluster)
marginsplot 


*/


