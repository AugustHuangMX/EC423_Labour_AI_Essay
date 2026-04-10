/*
============================================================
02_compositional_shift.do
============================================================
目的：Compositional Shift subsection 的全部分析产出。
      建立"高 AI 暴露职业中 junior share 下降"的基本事实。

逻辑：
  Part 0 — 环境设置 + 数据加载 + position_number 异常清洗
  Part 1 — 变量构建（is_junior, ym, high_exp, post）
  Part 2 — 描述性图
           2a. 月度 junior share 趋势（high vs low AI exposure）
           2b. 绝对数量图（high exposure 组 junior vs senior）
           2c. 绝对数量图（low exposure 组 junior vs senior）
  Part 3 — Pooled DiD 回归 + 导出系数 CSV
  Part 4 — Event study
           4a. Collapse 到 O*NET × half-year cell
           4b. Baseline specification（occupation + time FE）
           4c. Trend-adjusted specification（加 occupation-specific linear trend）
           4d. 合并两个 spec 的系数 + 对比图 + 导出 CSV

数据：positions_all.dta（~50.7M obs，已 merge AI exposure）
时间窗口：2018m1–2025m12（描述性图）；2018H1–2025H2（event study，16 periods）
Post 定义：startdate >= 01jan2023（following H&L 2025）
Event study 基准期：2022H2（ChatGPT 发布半年，pre-adoption 最后时点）
Cluster SE：O*NET code level

产出文件：
  - output/junior_share_monthly.png        （描述性趋势图）
  - output/abs_count_high_exp.png           （高暴露组绝对数量）
  - output/abs_count_low_exp.png            （低暴露组绝对数量）
  - output/event_study_comparison.png       （baseline vs trend-adjusted）
  - output/tables/did_pooled.csv            （DiD 系数表）
  - output/tables/event_study_coefs.csv     （两个 spec 的 event study 系数）
============================================================
*/


* ============================================================
* Part 0: 环境设置 + 数据加载 + 清洗
* ============================================================

clear all
set more off

global root "/Users/huangminxing/Documents/EC423_Essay"
global output "$root/output"
global tables "$root/output/tables"

cap mkdir "$tables"

use "$root/clean/positions_all.dta", clear

* --- 清洗异常用户：position_number > 50 的整个 user_id drop ---
* 与 03_mobility.do 的清洗规则对齐
tempfile bad_users
preserve
keep if position_number > 50
keep user_id
duplicates drop
save `bad_users'
restore

merge m:1 user_id using `bad_users', keep(master) nogen
* master only = 正常用户，using only 和 matched = 异常用户（被 drop）

di as text "=== Part 0 完成：数据加载 + 异常用户清洗 ==="
di as text "剩余观测数：" _N


* ============================================================
* Part 1: 变量构建
* ============================================================

* --- 初级岗位 ---
gen is_junior = (seniority <= 2)
label variable is_junior "初级岗位（seniority 1-2）"

* --- 月度时间变量 ---
gen ym = mofd(startdate) if startdate != .
format ym %tm
label variable ym "职位开始月份"

* --- 高/低 AI exposure 组（median split） ---
gen high_exp = (ai_exposure >= 0.3658537) if ai_exposure != .
label variable high_exp "高AI暴露组（median split）"
label define high_exp_lb 0 "Low AI Exposure" 1 "High AI Exposure"
label values high_exp high_exp_lb

* --- Post 定义：2023年1月起（following H&L 2025） ---
gen post = (startdate >= td(01jan2023)) if startdate != .
label variable post "Post-ChatGPT（2023年1月起）"

di as text "=== Part 1 完成：变量构建 ==="
tab is_junior
tab high_exp
tab post


* ============================================================
* Part 2: 描述性图
* ============================================================

* --- 2a. 月度 junior share 趋势图 ---
preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)

collapse (mean) junior_share = is_junior (count) n = is_junior, by(ym high_exp)

twoway (line junior_share ym if high_exp == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line junior_share ym if high_exp == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("Junior Share of New Positions") ///
       legend(order(1 "High AI Exposure" 2 "Low AI Exposure") ///
              rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022). Junior = seniority ≤ 2." ///
            "AI exposure median split at 0.366 (Eloundou et al. 2024).")

graph export "$output/junior_share_monthly.png", replace width(2000)
restore


* --- 2b. 绝对数量图：高暴露组 ---
preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)
gen one = 1
collapse (count) n = one, by(ym high_exp is_junior)
gen n_k = n / 1000

twoway (line n_k ym if high_exp == 1 & is_junior == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line n_k ym if high_exp == 1 & is_junior == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("New Position Starts (thousands)") ///
       legend(order(1 "Junior (seniority ≤ 2)" 2 "Senior (seniority ≥ 3)") ///
              rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022).")
graph export "$output/abs_count_high_exp.png", replace width(2000)


* --- 2c. 绝对数量图：低暴露组 ---
twoway (line n_k ym if high_exp == 0 & is_junior == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line n_k ym if high_exp == 0 & is_junior == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("New Position Starts (thousands)") ///
       legend(order(1 "Junior (seniority ≤ 2)" 2 "Senior (seniority ≥ 3)") ///
              rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022).")
graph export "$output/abs_count_low_exp.png", replace width(2000)

restore

di as text "=== Part 2 完成：描述性图 ==="


* ============================================================
* Part 3: Pooled DiD 回归
* ============================================================

* 限制有 startdate 的观测
preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)

* DiD 回归：is_junior = f(ai_exposure × post)
* 用连续 ai_exposure，不是 binary high_exp
reg is_junior c.ai_exposure##i.post, vce(cluster onet_code)

* 导出系数
regsave using "$tables/did_pooled.csv", replace ci level(95) ///
    addlabel(spec, "Pooled DiD")

di as text "=== Part 3 完成：Pooled DiD ==="
di as text "DiD 系数（ai_exposure × post）见上方回归输出"

restore


* ============================================================
* Part 4: Event Study
* ============================================================

* --- 4a. Collapse 到 O*NET × half-year cell ---
preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)

* 半年度编码：2018H1 = 1, 2018H2 = 2, ..., 2025H2 = 16
gen half = yofd(dofm(ym))
replace half = half + 0.5 if mod(month(dofm(ym)) - 1, 6) >= 3
gen hy = (half - 2018) * 2 + 1
label variable hy "半年度编码（1=2018H1, ..., 16=2025H2）"

collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) ai_exposure, by(onet_code hy)

* 生成 ai_exposure × period 交互项
* 基准期：2022H2 = hy 10
forvalues k = 1/16 {
    gen interact_`k' = ai_exposure * (hy == `k')
}
drop interact_10  // 基准期 = 2022H2

* 保存 cell-level 数据供两个 spec 使用
tempfile cells
save `cells'


* --- 4b. Baseline specification ---
use `cells', clear
reghdfe junior_share interact_* [aweight = n], ///
    absorb(onet_code hy) vce(cluster onet_code)

regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
replace period = period - 10  // 相对于基准期 2022H2
rename coef coef_base
rename ci_lower ci_lo_base
rename ci_upper ci_hi_base
keep period coef_base ci_lo_base ci_hi_base
tempfile base
save `base'


* --- 4c. Trend-adjusted specification ---
use `cells', clear
gen occ_trend = ai_exposure * hy

reghdfe junior_share interact_* occ_trend [aweight = n], ///
    absorb(onet_code hy) vce(cluster onet_code)

regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
replace period = period - 10
rename coef coef_trend
rename ci_lower ci_lo_trend
rename ci_upper ci_hi_trend
keep period coef_trend ci_lo_trend ci_hi_trend


* --- 4d. 合并 + 画图 + 导出 ---
merge 1:1 period using `base', nogen

* 补回基准期（系数 = 0）
local N_plus = _N + 1
set obs `N_plus'
replace period = 0 if period == .
foreach v of varlist coef_* ci_* {
    replace `v' = 0 if period == 0
}
sort period

* 生成半年度标签
gen label = ""
forvalues i = -9/6 {
    local p = `i' + 10
    local yr = 2018 + floor((`p' - 1) / 2)
    local h = mod(`p' - 1, 2) + 1
    replace label = "`yr'H`h'" if period == `i'
}

* 对比图
twoway (rarea ci_hi_base ci_lo_base period, color(cranberry%15) lwidth(none)) ///
       (connected coef_base period, lcolor(cranberry) mcolor(cranberry) ///
            msymbol(circle) lwidth(medthick)) ///
       (rarea ci_hi_trend ci_lo_trend period, color(navy%15) lwidth(none)) ///
       (connected coef_trend period, lcolor(navy) mcolor(navy) ///
            msymbol(diamond) lwidth(medthick)), ///
       xline(0.5, lcolor(gs8) lpattern(dash)) ///
       yline(0, lcolor(gs10) lpattern(solid)) ///
       xtitle("Half-years relative to 2022H2") ///
       ytitle("β: AI Exposure × Period") ///
       legend(order(2 "Baseline" 4 "Occupation-specific trend") ///
              rows(1) position(6)) ///
       xlabel(-9(1)6, angle(45)) ///
       note("Baseline period: 2022H2. Cluster-robust SEs at O*NET code level." ///
            "Weighted by cell size. 95% confidence intervals.")
graph export "$output/event_study_comparison.png", replace width(2000)

* 导出系数表
export delimited period label coef_base ci_lo_base ci_hi_base ///
    coef_trend ci_lo_trend ci_hi_trend ///
    using "$tables/event_study_coefs.csv", replace

restore

di as text "=============================================="
di as text "02_compositional_shift.do 全部完成"
di as text "=============================================="
di as text "产出文件："
di as text "  $output/junior_share_monthly.png"
di as text "  $output/abs_count_high_exp.png"
di as text "  $output/abs_count_low_exp.png"
di as text "  $output/event_study_comparison.png"
di as text "  $tables/did_pooled.csv"
di as text "  $tables/event_study_coefs.csv"
di as text "=============================================="
