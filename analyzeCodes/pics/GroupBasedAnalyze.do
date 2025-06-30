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

gen high_group = .
replace high_group = 1 if inlist(cluster,1,2,3,4)
replace high_group = 0 if inlist(cluster,5,6,7)

mixed std_diffmainsieve1  c.std_diffcent#i.high_group c.std_diffclcent#i.high_group i.high_group || iscity: || ispublic:

*------------------------------------------------------------------
* p1：std_diffcent × high_group
*------------------------------------------------------------------
coefplot , base ///
    keep(*.high_group#c.std_diffcent) ///
    rename(                                             ///
        1.high_group#c.std_diffcent = "High sieve group" ///
        0.high_group#c.std_diffcent = "Low sieve group"  ///
    ) ///
	level(90) ///
	horizontal                                                               ///  橫向森林圖
    ciopts(recast(rcap))                                                     ///  誤差棒畫 rcap
    msymbol(O) mcolor(navy)                                                  ///  點樣式
    xline(0, lcolor(gs8) lwidth(thin))                                       ///  0 參考線
    ylabel(, angle(0))                                                      ///
    title("Coef. of centrality", size(medium))            ///
    saving(p1, replace)

*------------------------------------------------------------------
* p2：std_diffclcent × high_group
*------------------------------------------------------------------
coefplot , base ///
    keep(*.high_group#c.std_diffclcent) ///
    rename(                                             ///
        1.high_group#c.std_diffclcent = "High sieve group" ///
        0.high_group#c.std_diffclcent = "Low sieve group"  ///
    ) ///
	level(90) ///
	horizontal                                                               ///
    ciopts(recast(rcap))                                                     ///
    msymbol(O) mcolor(dknavy)                                                ///
    xline(0, lcolor(gs8) lwidth(thin))                                       ///
    ylabel(, angle(0))                                                      ///
    title("Coef. of cluster centrality",size(medium))          ///
    saving(p2, replace)
*------------------------------------------------------------------
coefplot , base ///
    keep(1.high_group _cons)  ///
	sort(, descending) ///
    rename(                                             ///
        _cons = "Low sieve group" ///
        1.high_group = "High sieve group"  ///
    ) ///
	level(90) ///
	horizontal                                                               ///
    ciopts(recast(rcap))                                                     ///
    msymbol(O) mcolor(dknavy)                                                ///
    xline(0, lcolor(gs8) lwidth(thin))                                       ///
    ylabel(, angle(0))                                                      ///
    title("Intercept",size(medium))          ///
    saving(p3, replace)

graph combine p1.gph p2.gph

