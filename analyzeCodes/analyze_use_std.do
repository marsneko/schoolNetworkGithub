est clear 


forvalues clusnum = 1/7 {
 reg  std_diffmainsieve1 std_diffclcent if cluster == `clusnum'
	eststo:
}
esttab
est clear 


matrix results = J(7, 4, .)
mixed std_diffmainsieve1 c.std_diffclcent##i.cluster  c.std_diffcent##i.cluster  || ispublic: || iscity:, difficult



forvalues clusnum = 1/7 {
    qui lincom std_diffclcent + `clusnum'.cluster#c.std_diffclcent

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


mixed std_diffmainsieve1 c.std_diffclcent##i.cluster  c.std_diffcent##i.cluster c.std_diffinclu##i.cluster || ispublic: || iscity:, difficult
matrix results = J(7, 4, .)
forvalues clusnum = 1/7 {
    qui lincom std_diffinclu + `clusnum'.cluster#c.std_diffinclu

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


matrix results = J(7, 4, .)
forvalues clusnum = 1/7 {
    qui lincom std_diffclcent + `clusnum'.cluster#c.std_diffclcent

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

matrix results = J(7, 4, .)
forvalues clusnum = 1/7 {
    qui lincom std_diffcent + `clusnum'.cluster#c.std_diffcent

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










*hexplot std_diffmainsieve1 std_diffinclu,by(cluster)
*twoway (lfitci std_diffmainsieve1 std_diffinclu) (scatter std_diffmainsieve1 std_diffinclu, mcolor(navy) msize(vtiny)), by(cluster)
*twoway (lfitci std_mainsieve1 std_clustereigencentrality  ) (scatter std_mainsieve1 std_clustereigencentrality , mcolor(navy) msize(vtiny)), by(cluster)
*corr std_diffinclu std_diffmainsieve1 std_diffcent std_diffclcent
*matrix C = r(C)
*heatplot C, values(format(%9.3f)) color(hcl, diverging intensity(.6)) legend(off) aspectratio(1)

mixed std_diffmainsieve1 std_clustereigencentrality107 std_clustereigencentrality108 std_eigencentrality107 std_eigencentrality108  c.std_diffinclu##i.cluster || ispublic: || iscity:, difficult
 
matrix results = J(7, 4, .)
forvalues clusnum = 1/7 {
    qui lincom std_diffinclu + `clusnum'.cluster#c.std_diffinclu

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


forvalues clusnum = 1/7 {
	reg std_mainsieve1 std_clustereigencentrality if cluster == `clusnum', robust
	eststo:
}
esttab
esti clear

forvalues clusnum = 1/7 {
	reg std_mainsieve1 std_eigencentrality if cluster == `clusnum', robust
	eststo:
}
esttab
esti clear
