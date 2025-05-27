*******************************************************
* interaction_plots_offset.do
* 目的：比較三個 inclu_cat 水平（減少、不變、增加）下
*      sieve_cat 在不同 cluster 的事件率趨勢
*******************************************************  



* -------------------------------------------------------------------
* -------------------------------------------------------------------
* Step 1: 將 -1,0,1 重新編碼為 0,1,2（以 diff_clcent 取代 diffinclu_bin）
* -------------------------------------------------------------------
gen byte inclu_cat = .
replace inclu_cat = 0 if diff_clcent == -1
replace inclu_cat = 1 if diff_clcent == 0
replace inclu_cat = 2 if diff_clcent == 1
label define inclu_lbl 0 "減少" 1 "不變" 2 "增加"
label values inclu_cat inclu_lbl

gen byte sieve_cat = .
replace sieve_cat = 0 if diffmainsieve1_bin == -1
replace sieve_cat = 1 if diffmainsieve1_bin == 0
replace sieve_cat = 2 if diffmainsieve1_bin == 1
label define sieve_lbl 0 "減少" 1 "不變" 2 "增加"
label values sieve_cat sieve_lbl

* -------------------------------------------------------------------
* Step 2: 建立三維列聯表（次數統計）
* -------------------------------------------------------------------
contract inclu_cat sieve_cat cluster
* 會產生 _freq 代表每個 cell 的次數

* -------------------------------------------------------------------
* Step 3: 計算每個 cluster 的總樣本數，並產生 offset
* -------------------------------------------------------------------
egen cluster_n = total(_freq), by(cluster)
gen double logN = log(cluster_n)

* -------------------------------------------------------------------
* Step 4: 模型估計（Poisson with offset）
*         分別存 base model 與 full model
* -------------------------------------------------------------------
poisson _freq ib1.inclu_cat##i.sieve_cat i.cluster, offset(logN)
estimates store base

poisson _freq ib1.inclu_cat##i.sieve_cat##i.cluster, offset(logN)
estimates store full

* -------------------------------------------------------------------
* Step 5: 檢定交互關係是否隨 cluster 改變
* -------------------------------------------------------------------
lrtest base full

* -------------------------------------------------------------------
* Step 6: 畫出三組 marginsplot （事件率）
* -------------------------------------------------------------------
* 先預測 count，然後除以 cluster_n 得到 rate
foreach lvl in 0 1 2 {
    margins if inclu_cat==`lvl', over(sieve_cat cluster) expression(exp(predict(xb)))
    marginsplot, name(p`lvl', replace) ///
        title("inclu_cat = " + elabel(inclu_lbl, `lvl')) ///
        xtitle("sieve_cat") ytitle("Predicted rate") ///
        plotdimension(cluster)
}
graph combine p0 p1 p2, cols(3) ///
    title("inclu_cat 三種水平下 sieve_cat 事件率比較 (比例)")

