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







gen diffmainsieve1_bin = diffmainsieve1

replace diffmainsieve1_bin = 1 if diffmainsieve1 > 0
replace diffmainsieve1_bin = -1 if diffmainsieve1 < 0

gen diffinclu_bin = diffinclu
gen diffcent_bin = diffcent
gen diffclcent_bin = diffclcent


summarize diffinclu
local standardevi = r(sd)
replace diffinclu_bin = 0 if diffinclu >= -1.96 * `standardevi' & diffinclu <= 1.96 * `standardevi'
replace diffinclu_bin = 1 if diffinclu > 1.96 * `standardevi'
replace diffinclu_bin = -1 if diffinclu < -1.96 * `standardevi'

summarize diffcent
local standardevi = r(sd)
replace diffcent_bin = 0 if diffcent >= -1.96 * `standardevi' & diffcent <= 1.96 * `standardevi'
replace diffcent_bin = 1 if diffcent > 1.96 * `standardevi'
replace diffcent_bin = -1 if diffcent < -1.96 * `standardevi'

summarize diffclcent
local standardevi = r(sd)
replace diffclcent_bin = 0 if diffclcent >= -1.96 * `standardevi' & diffclcent <= 1.96 * `standardevi'
replace diffclcent_bin = 1 if diffclcent > 1.96 * `standardevi'
replace diffclcent_bin = -1 if diffclcent < -1.96 * `standardevi'

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
tab diffcent_cat diffmainsieve1_cat, chi cchi2
tab diffclcent_cat diffmainsieve1_cat, chi cchi2


melogit diffmainsieve1_cat i.diffclcent_cat#i.cluster  i.diffcent_cat#i.cluster  i.cluster i.iscity##i.ispublic ,difficult


coefplot                                   ///
      , base keep(*.diffclcent_cat#*.cluster) drop(0.diffclcent_cat#1.cluster)  /* 只留交互作用 */ ///
        rename(                           /* y 軸改成簡潔名稱 */ ///
            1.diffclcent_cat#1.cluster = "Cluster 1"  ///
            1.diffclcent_cat#2.cluster = "Cluster 2"  ///
            1.diffclcent_cat#3.cluster = "Cluster 3"  ///
            1.diffclcent_cat#4.cluster = "Cluster 4"  ///
            1.diffclcent_cat#5.cluster = "Cluster 5"  ///
            1.diffclcent_cat#6.cluster = "Cluster 6"  ///
            1.diffclcent_cat#7.cluster = "Cluster 7") ///
        level(90) 									///
		xtitle(odd ratio) ///
		eform ///
		horizontal                        /* 橫向森林圖 */ ///
        ciopts(recast(rcap))              /* 誤差棒畫 rcap */ ///
        msymbol(O)   mcolor(navy)         /* 點樣式、顏色 */ ///
        ylabel(, angle(0))                /* y 標籤水平 */ ///
        title("odd ratio of cluster centrality",size(medium)) ///
        saving(p1, replace)


*--------------------------------------------------------------------
* 第二張：p2 － 垂直排列、90% CI，依係數大小排序
*--------------------------------------------------------------------
coefplot                                   ///
      ,base keep(*.diffcent_cat#*.cluster)  drop(0.diffcent_cat#1.cluster) ///
        rename(                           ///
            1.diffcent_cat#1.cluster = "Cluster 1"  ///
            1.diffcent_cat#2.cluster = "Cluster 2"  ///
            1.diffcent_cat#3.cluster = "Cluster 3"  ///
            1.diffcent_cat#4.cluster = "Cluster 4"  ///
            1.diffcent_cat#5.cluster = "Cluster 5"  ///
            1.diffcent_cat#6.cluster = "Cluster 6"  ///
            1.diffcent_cat#7.cluster = "Cluster 7") ///
        level(90)                         /* 90% CI → 左/右尾 5% */ ///
		xtitle(odd ratio) ///
		eform ///     
        ciopts(recast(rcap))              ///
        msymbol(O)   mcolor(dknavy)       ///
        title("odd ratio of centrality",size(medium)) ///
        ylabel(, angle(0))                ///
        saving(p2, replace)
*--------------------------------------------------------------------

*coefplot, keep(*.diffclcent_cat#*.cluster)  saving(p3,replace)
graph combine p1.gph p2.gph 
