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
gen one = 1
collapse (count) n = one, by(ym high_exp is_junior)

gen n_k = n / 1000

twoway (line n_k ym if high_exp == 1 & is_junior == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line n_k ym if high_exp == 1 & is_junior == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("New Position Starts (thousands)") ///
       title("High AI Exposure: New Position Starts by Seniority") ///
       legend(order(1 "Junior (seniority ≤ 2)" 2 "Senior (seniority ≥ 3)") rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022).")
graph export "/Users/huangminxing/Documents/EC423_Essay/output/abs_count_high_exp.png", replace width(2000)

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



/**** 
Event Study 
****/
* === Event Study: Junior Share by AI Exposure ===

preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m6)

* 生成半年度变量
gen half = yofd(dofm(ym))
replace half = half + 0.5 if mod(month(dofm(ym)) - 1, 6) >= 3
* 转成整数编码方便操作：2018.0 → 1, 2018.5 → 2, ...
gen hy = (half - 2018) * 2 + 1
label variable hy "半年度编码"

* collapse 到 onet_code × 半年度 cell
collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) ai_exposure, by(onet_code hy)

* 基准期：2022H1 = hy == 9
* 生成交互项
forvalues k = 1/15 {
    gen interact_`k' = ai_exposure * (hy == `k')
}
drop interact_9  // 基准期

* 回归
reghdfe junior_share interact_* [aweight = n], absorb(onet_code hy) ///
    vce(cluster onet_code) 

* 提取系数画图
regsave interact_*, ci level(95)

* 整理数据
gen period = real(subinstr(var, "interact_", "", .))
replace period = period - 9  // 相对于基准期的距离
sort period

* 补回基准期（系数=0）
set obs `=_N + 1'
replace period = 0 if period == .
replace coef = 0 if period == 0
replace ci_lower = 0 if period == 0
replace ci_upper = 0 if period == 0
sort period

* 生成半年度标签
gen label = ""
local start = 2018
forvalues i = -8/6 {
    local p = `i' + 9
    local yr = 2018 + floor((`p' - 1) / 2)
    local h = mod(`p' - 1, 2) + 1
    replace label = "`yr'H`h'" if period == `i'
}

* 画图
twoway (rarea ci_upper ci_lower period, color(cranberry%20) lwidth(none)) ///
       (connected coef period, lcolor(cranberry) mcolor(cranberry) msymbol(circle)), ///
       xline(-0.5, lcolor(gs8) lpattern(dash)) ///
       yline(0, lcolor(gs10) lpattern(solid)) ///
       xtitle("Half-years relative to 2022H1") ///
       ytitle("β: AI Exposure × Period") ///
       title("Event Study: AI Exposure Effect on Junior Share") ///
       legend(off) ///
       xlabel(-8(1)6, valuelabel angle(45)) ///
       note("Baseline: 2022H1. Cluster-robust SEs at O*NET code level." ///
            "Weighted by cell size. 95% confidence intervals.")
graph export "/Users/huangminxing/Documents/EC423_Essay/output/event_study_junior_share.png", replace width(2000)

restore


* === Robustness: 加入 occupation-specific linear trend ===
preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m6)

gen half = yofd(dofm(ym))
replace half = half + 0.5 if mod(month(dofm(ym)) - 1, 6) >= 3
gen hy = (half - 2018) * 2 + 1

collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) ai_exposure, by(onet_code hy)

forvalues k = 1/15 {
    gen interact_`k' = ai_exposure * (hy == `k')
}
drop interact_9

* 加入 occupation-specific linear trend
gen trend = hy
gen occ_trend = ai_exposure * trend

reghdfe junior_share interact_* occ_trend [aweight = n], ///
    absorb(onet_code hy) vce(cluster onet_code)

restore





preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m6)

gen half = yofd(dofm(ym))
replace half = half + 0.5 if mod(month(dofm(ym)) - 1, 6) >= 3
gen hy = (half - 2018) * 2 + 1

collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) ai_exposure, by(onet_code hy)

forvalues k = 1/15 {
    gen interact_`k' = ai_exposure * (hy == `k')
}
drop interact_9

* === Specification 1: Baseline ===
reghdfe junior_share interact_* [aweight = n], absorb(onet_code hy) vce(cluster onet_code)
regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
replace period = period - 9
rename coef coef_base
rename ci_lower ci_lo_base
rename ci_upper ci_hi_base
keep period coef_base ci_lo_base ci_hi_base
tempfile base
save `base'

* === Specification 2: Trend-adjusted ===
restore
preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m6)

gen half = yofd(dofm(ym))
replace half = half + 0.5 if mod(month(dofm(ym)) - 1, 6) >= 3
gen hy = (half - 2018) * 2 + 1

collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) ai_exposure, by(onet_code hy)

forvalues k = 1/15 {
    gen interact_`k' = ai_exposure * (hy == `k')
}
drop interact_9

gen trend = hy
gen occ_trend = ai_exposure * trend

reghdfe junior_share interact_* occ_trend [aweight = n], absorb(onet_code hy) vce(cluster onet_code)
regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
replace period = period - 9
rename coef coef_trend
rename ci_lower ci_lo_trend
rename ci_upper ci_hi_trend
keep period coef_trend ci_lo_trend ci_hi_trend

* === 合并两个 specification ===
merge 1:1 period using `base', nogen

* 补回基准期
set obs `=_N + 1'
replace period = 0 if period == .
foreach v of varlist coef_* ci_* {
    replace `v' = 0 if period == 0
}
sort period

* === 画图：两个 spec 并排 ===
twoway (rarea ci_hi_base ci_lo_base period, color(cranberry%15) lwidth(none)) ///
       (connected coef_base period, lcolor(cranberry) mcolor(cranberry) msymbol(circle) lwidth(medthick)) ///
       (rarea ci_hi_trend ci_lo_trend period, color(navy%15) lwidth(none)) ///
       (connected coef_trend period, lcolor(navy) mcolor(navy) msymbol(diamond) lwidth(medthick)), ///
       xline(-0.5, lcolor(gs8) lpattern(dash)) ///
       yline(0, lcolor(gs10) lpattern(solid)) ///
       xtitle("Half-years relative to 2022H1") ///
       ytitle("β: AI Exposure × Period") ///
       title("Event Study: Baseline vs. Trend-Adjusted") ///
       legend(order(2 "Baseline" 4 "Occupation-specific trend") rows(1) position(6)) ///
       xlabel(-8(1)6, angle(45)) ///
       note("Baseline period: 2022H1. Cluster-robust SEs at O*NET code level." ///
            "Weighted by cell size. 95% confidence intervals.")
graph export "/Users/huangminxing/Documents/EC423_Essay/output/event_study_comparison.png", replace width(2000)

restore
