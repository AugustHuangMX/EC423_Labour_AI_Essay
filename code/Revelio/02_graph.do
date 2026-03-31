/*
Graph
*/
clear all
set more off


use "/Users/huangminxing/Documents/EC423_Essay/clean/positions_all.dta", clear


// 定义初级岗位
gen is_junior = (seniority <= 2)
label variable is_junior "初级岗位（seniority 1-2）"

gen ym = mofd(startdate) if startdate != .
format ym %tm
label variable ym "职位开始月份"


* AI exposure 分布（occupation level，去重后看）
preserve
bysort onet_code: keep if _n == 1
summarize ai_exposure, detail
histogram ai_exposure, bin(50) xtitle("AI Exposure (Eloundou et al.)") title("AI Exposure 分布（by O*NET code）")
restore


* === 定义高/低 AI exposure 组 ===
gen high_exp = (ai_exposure >= 0.3658537) if ai_exposure != .
label variable high_exp "高AI暴露组（median split）"
label define high_exp_lb 0 "Low AI Exposure" 1 "High AI Exposure"
label values high_exp high_exp_lb

* === 月度 junior share 趋势图 ===
* 限制时间窗口 2018-2025，且 startdate 非缺失
preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)

* 按月度 × exposure组 计算 junior share
collapse (mean) junior_share = is_junior (count) n = is_junior, by(ym high_exp)

* 画图
twoway (line junior_share ym if high_exp == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line junior_share ym if high_exp == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("Junior Share of New Positions") ///
       title("Junior Share of New Position Starts by AI Exposure Group") ///
       legend(order(1 "High AI Exposure" 2 "Low AI Exposure") rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022). Junior = seniority ≤ 2." ///
            "AI exposure median split at 0.366 (Eloundou et al. 2024).")

graph export "/Users/huangminxing/Documents/EC423_Essay/output/junior_share_monthly.png", replace width(2000)
restore




preserve
keep ym high_exp is_junior
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)
collapse (count) n = is_junior, by(ym high_exp is_junior)

* 转换为千人单位
gen n_k = n / 1000

* --- 图1：High AI Exposure 组 ---
twoway (line n_k ym if high_exp == 1 & is_junior == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line n_k ym if high_exp == 1 & is_junior == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("New Position Starts (thousands)") ///
       title("High AI Exposure: New Position Starts by Seniority") ///
       legend(order(1 "Junior (seniority ≤ 2)" 2 "Senior (seniority ≥ 3)") rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022).")
graph export "/Users/huangminxing/Documents/EC423_Essay/output/abs_count_high_exp.png", replace width(2000)

* --- 图2：Low AI Exposure 组 ---
twoway (line n_k ym if high_exp == 0 & is_junior == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line n_k ym if high_exp == 0 & is_junior == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("New Position Starts (thousands)") ///
       title("Low AI Exposure: New Position Starts by Seniority") ///
       legend(order(1 "Junior (seniority ≤ 2)" 2 "Senior (seniority ≥ 3)") rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022).")
graph export "/Users/huangminxing/Documents/EC423_Essay/output/abs_count_low_exp.png", replace width(2000)

restore
