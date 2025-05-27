*twoway  (lfitci std_diffmainsieve1 std_diffinclu if diffmainsieve1 != 0) (scatter std_diffmainsieve1 std_diffinclu if diffmainsieve1 != 0), by(cluster)

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



tab diffinclu_bin diffmainsieve1_bin, chi2 cchi2
tab diffcent_bin diffmainsieve1_bin, chi cchi2
tab diffclcent_bin diffmainsieve1_bin, chi cchi2




local ngroups = 7

matrix C = J(`ngroups', 4, .)


forvalues g = 1/7 {
    qui corr diffinclu_bin diffmainsieve1_bin if cluster == `g'
    local inc_corr_val = r(rho)
	qui corr diffcent_bin diffmainsieve1_bin if cluster == `g'
	local cent_corr_val = r(rho)
	qui corr diffclcent_bin diffmainsieve1_bin if cluster == `g'
	local clcent_corr_val = r(rho)
	

    * 填進矩陣
    matrix C[`g', 1] = `g'
    matrix C[`g', 2] = `inc_corr_val'
	matrix C[`g', 3] = `cent_corr_val'
	matrix C[`g', 4] = `clcent_corr_val'

}

* 4. 顯示結果
matrix list C



*twoway hist diffinclu if diffmainsieve1_bin != 0 ,by(cluster diffmainsieve1_bin)



mixed diffmainsieve1_bin c.diffinclu_bin##i.cluster c.diffclcent_bin##i.cluster  c.diffcent_bin##i.cluster  || ispublic: || iscity:, difficult


matrix results = J(7, 4, .)
forvalues clusnum = 1/7 {
    qui lincom diffinclu_bin + `clusnum'.cluster#c.diffinclu_bin

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
    qui lincom diffclcent_bin + `clusnum'.cluster#c.diffclcent_bin

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
    qui lincom diffcent_bin + `clusnum'.cluster#c.diffcent_bin

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



export delimited using "/Users/eric/Documents/SchoolCourses/schoolNetworkGithub/analyzeCodes/processedData/with_change_nochange.csv", replace



