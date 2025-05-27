preserve

* 建立指示變數
tabulate diffmainsieve1_bin, generate(dm_)   // 會產生 dm_1 dm_2 … dm_k

graph bar (sum) dm_* if diffinclu_bin==1,      ///
    over(cluster, gap(2))                      ///
    stack asyvars                              ///
    percent                                    ///
    ytitle("percentage")                           ///
    legend(order(1 "decrease" 2 "no change" 3 "increase" )) ///
    title("Distribution of mainsieve change when incluster increasing")
restore
