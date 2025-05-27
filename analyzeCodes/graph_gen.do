gen main_sieve_diff = 0

replace main_sieve_diff = 0 if diffmainsieve1_rank < 1/3

replace main_sieve_diff = 0 if (diffmainsieve1_rank< 2/3 & diffmainsieve1_rank > 1/3)


replace main_sieve_diff = 1 if (diffmainsieve1_rank < 2/3 & diffmainsieve1_rank > 1/3)


replace main_sieve_diff = 2 if (diffmainsieve1_rank >= 2/3 )
histogram main_sieve_diff, by(cluster)

gen main_inclu_diff = 0
replace main_inclu_diff = 1 if (diffinclu_pct < 2/3 & diffinclu_pct >= 1/3)
replace main_inclu_diff = 2 if (diffinclu_pct >= 2/3)
forvalues v= 1/7{
	hist diffmainsieve1_rank if cluster == `v', by(main_inclu_diff) saving(hist`v')
	}
gr combine hist1.gph hist2.gph hist3.gph hist4.gph hist5.gph hist6.gph hist7.gph



