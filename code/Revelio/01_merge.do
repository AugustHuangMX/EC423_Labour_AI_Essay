/*
挂载 AI exposure scores + 高/低 exposure 分组出图
把 AI exposure 分数根据 onet code merge 到positions 里
*/
clear all
set more off


use "/Users/huangminxing/Documents/EC423_Essay/clean/positions_all.dta", clear

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


drop country
drop title

save "/Users/huangminxing/Documents/EC423_Essay/clean/positions_all.dta", replace


* ---- 3. 检查 exposure 分布 ----
sum ai_exposure, d

* ---- 4. 定义高/低 AI exposure（按 median 分） ----
* 先算 occupation-level median（不被大职业 dominate）
preserve
    keep onet_code ai_exposure
    duplicates drop onet_code, force
    sum ai_exposure, d
    local med = r(p50)
    di "Occupation-level median AI exposure: `med'"
restore

* 用上面的 median 分组
* 注意：你需要把下面的数字替换成实际输出的 median
* 先跑上面的代码看 median 是多少，然后填入这里, 算出来是 0.3659
gen high_ai = (ai_exposure > 0.3659) if ai_exposure != .
tab high_ai

* ---- 5. 核心图：Junior share by AI exposure × 季度 ----
gen start_yq = qofd(startdate)
format start_yq %tq

preserve
    keep if start_yq >= tq(2019q1) & start_yq <= tq(2024q4)
    keep if ai_exposure != .

    gen senior = (seniority >= 3)

    * 按季度 × AI exposure × junior/senior 计数
    collapse (count) n = position_id, by(start_yq high_ai senior)

    * 计算 junior share
    reshape wide n, i(start_yq high_ai) j(senior)
    gen junior_share = n0 / (n0 + n1)

    * 画图
    twoway (line junior_share start_yq if high_ai == 1, lcolor(cranberry) lwidth(medthick)) ///
           (line junior_share start_yq if high_ai == 0, lcolor(navy) lwidth(medthick)), ///
           xline(`=tq(2022q4)', lcolor(gs8) lpattern(dash)) ///
           legend(order(1 "High AI exposure" 2 "Low AI exposure")) ///
           title("Junior Share of New Position Starts by AI Exposure, UK") ///
           subtitle("Vertical line = ChatGPT launch (2022 Q4)") ///
           ytitle("Share of starts at seniority 1-2") xtitle("") ///
           ylabel(, format(%4.2f)) ///
           scheme(s2color)
    graph export "/Users/huangminxing/Documents/EC423_Essay/output/fig_junior_share_by_ai_exposure.png", replace
restore


* year on year 同比来消除季节性

preserve
    keep if start_yq >= tq(2019q1) & start_yq <= tq(2024q4)
    keep if ai_exposure != .

    gen senior = (seniority >= 3)
    gen start_q = quarter(dofq(start_yq))
    gen start_y = year(dofq(start_yq))

    collapse (count) n = position_id, by(start_y start_q high_ai senior)
    reshape wide n, i(start_y start_q high_ai) j(senior)
    gen junior_share = n0 / (n0 + n1)

    * 按半年聚合，平滑噪音
    gen half = cond(start_q <= 2, 1, 2)
    collapse (mean) junior_share, by(start_y half high_ai)
    gen period = start_y + (half - 1) * 0.5

    twoway (connected junior_share period if high_ai == 1, lcolor(cranberry) msymbol(circle) mcolor(cranberry)) ///
           (connected junior_share period if high_ai == 0, lcolor(navy) msymbol(square) mcolor(navy)), ///
           xline(2022.75, lcolor(gs8) lpattern(dash)) ///
           legend(order(1 "High AI exposure" 2 "Low AI exposure")) ///
           title("Junior Share of New Starts by AI Exposure (Half-Yearly)") ///
           subtitle("UK, vertical line = ChatGPT launch") ///
           ytitle("Share at seniority 1-2") xtitle("") ///
           ylabel(, format(%4.2f)) ///
           scheme(s2color)
    graph export "/Users/huangminxing/Documents/EC423_Essay/output/fig_junior_share_halfyear.png", replace
restore
