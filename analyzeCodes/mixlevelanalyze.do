estimates store model1
mixed diffinclu c.main_sieve1_byassigment_rank##i.cluster ispublic || 學校名稱_code:
estimates store model2
mixed diffinclu c.main_sieve1_byassigment_rank##i.cluster  || 學校名稱_code:  


twoway (scatter diffmainsieve1 diffinclu, msize(tiny)) (lfitci diffmainsieve1 diffinclu), by(cluster)
