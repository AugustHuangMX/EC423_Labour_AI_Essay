/*
挂载 AI exposure scores + 高/低 exposure 分组出图
把 AI exposure 分数根据 onet code merge 到positions 里
*/
clear all
set more off


use "/Users/huangminxing/Documents/EC423_Essay/clean/positions_all.dta", clear

capture drop country
capture drop title
capture drop position_id

rename rcid company_id


* 同样去掉空格
replace onet_code = strtrim(onet_code)

merge m:1 onet_code using "/Users/huangminxing/Documents/EC423_Essay/raw/ai_exposure.dta"

* 检查 merge 质量
tab _merge

// * 看 unmatched 的 onet code 分布
// preserve
//     keep if _merge == 1
//     bysort onet_code: gen occ_count = _N
//     gsort -occ_count
//     duplicates drop onet_code, force
//     list onet_code occ_count in 1/20
// restore

//结果就是这些都是 all other 的内容，所以我决定直接丢掉这些数据

* 删掉 exposure 表里有但 positions 里没有的（_merge==3）
drop if _merge != 3
drop _merge

* 进行代码形式的简写

rename dv_rating m1
rename aioe_felten m2
rename ai_applicability m3


save "/Users/huangminxing/Documents/EC423_Essay/clean/positions_all.dta", replace




* ---- 4. 定义高/低 AI exposure（按 median 分） ----
* 先算 occupation-level median（不被大职业 dominate）并且同时生成多个指标的。
preserve
    keep onet_code m1
    duplicates drop onet_code, force
    sum m1, d
    local med = r(p50)
    di "Occupation-level median AI exposure: `med'"
restore





* 用上面的 median 分组
* 注意：你需要把下面的数字替换成实际输出的 median
* 算出来的结果是 
* m1 = 0.3659
* m2 = 0
* m3 = -0.18

gen high_m1 = (m1 > 0.3659) if m1 != .
tab high_m1
gen high_m2 = (m2 > 0) if m2 != .
tab high_m2
gen high_m3 = (m3 > -0.18) if m3 != .
tab high_m3




* ---- 5. 核心图：Junior share by AI exposure × 季度 ----
gen start_yq = qofd(startdate)
format start_yq %tq

preserve
    keep if start_yq >= tq(2019q1) & start_yq <= tq(2024q4)
    keep if m1 != .

    gen senior = (seniority >= 3)
	gen number = 1

    * 按季度 × AI exposure × junior/senior 计数
    collapse (count) n = number , by(start_yq high_m1 senior)

    * 计算 junior share
    reshape wide n, i(start_yq high_m1) j(senior)
    gen junior_share = n0 / (n0 + n1)

    * 画图
    twoway (line junior_share start_yq if high_m1 == 1, lcolor(cranberry) lwidth(medthick)) ///
           (line junior_share start_yq if high_m1 == 0, lcolor(navy) lwidth(medthick)), ///
           xline(`=tq(2022q4)', lcolor(gs8) lpattern(dash)) ///
           legend(order(1 "High AI exposure" 2 "Low AI exposure")) ///
           title("Junior Share of New Position Starts by AI Exposure, UK") ///
           subtitle("Vertical line = ChatGPT launch (2022 Q4)") ///
           ytitle("Share of starts at seniority 1-2") xtitle("") ///
           ylabel(, format(%4.2f)) ///
           scheme(s2color)
    //graph export "/Users/huangminxing/Documents/EC423_Essay/output/fig_junior_share_by_ai_exposure.png", replace
restore
