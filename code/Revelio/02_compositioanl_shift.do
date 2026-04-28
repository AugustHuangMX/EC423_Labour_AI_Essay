/*
============================================================
02_compositional_shift.do
============================================================
目的：Compositional Shift subsection 的全部分析产出。
Compositional Shift 指成分变化

建立"高 AI 暴露职业中 junior share 下降"的基本事实。

逻辑：
  Part 0 — 环境设置 + 数据加载 + position_number 异常清洗
  Part 1 — 变量构建（is_junior, ym, high_exp, post）
  Part 2 — 描述性图
           2a. 月度 junior share 趋势（high vs low AI exposure）
           2b. 绝对数量图（high exposure 组 junior vs senior）
           2c. 绝对数量图（low exposure 组 junior vs senior）
  Part 3 — Pooled DiD 回归 + 导出系数 CSV
  Part 4 — Event study: junior share（半年度 + 季度）
           基准期 = 2017H1 / 2017Q1
           时间窗口 2017–2025
  Part 5 — Event study: log count by seniority（季度）
           基准期 = 2017Q1

数据：positions_all.dta（~50.7M obs，已 merge AI exposure）
Post 定义：startdate >= 01jan2023（following H&L 2025）
Cluster SE：O*NET code level

预计产出文件：
  - output/figures/junior_share_monthly.png
  - output/figures/abs_count_high_exp.png
  - output/figures/abs_count_low_exp.png
  - output/figures/event_study_half.png      （半年度 junior share）
  - output/figures/event_study_quarterly.png  （季度 junior share）
  - output/figures/event_study_did_seniority.png（季度 log count by seniority）
  - output/tables/did_pooled.csv
  - output/tables/es_half_coefs.csv
  - output/tables/es_quarterly_coefs.csv
============================================================
*/


* ============================================================
* Part 0: 环境设置 + 数据加载 + 清洗
* ============================================================

clear all
set more off

global root "/Users/huangminxing/Documents/EC423_Essay" // 创建根目录路径
global output "$root/output/figures"
global tables "$root/output/tables"

cap mkdir "$tables"

use "$root/clean/positions_all.dta", clear

* --- 清洗异常用户：position_number > 50 的整个 user_id drop ---
tempfile bad_users
preserve
keep if position_number > 50
keep user_id
duplicates drop
save `bad_users'
restore

merge m:1 user_id using `bad_users', keep(master) nogen
** merge 的含义是 many to one. 第一个变量是匹配变量。using xxx 的含义是用此前保存过的 `bad_users` 数据集来 merge。keep(master) 的含义是只保留 master 数据集（即原始数据）中的观测。nogen 的含义是 merge 后不生成 _merge 变量。 keep(master) 意味着保存没有匹配的主数据行(即不在 bad_users) 里的行。
** nogen 意味着不生成 _merge 变量。因为我们只关心保留原始数据中的观测，而不需要知道哪些观测被匹配到了 bad_users 中。


di as text "=== Part 0 完成：数据加载 + 异常用户清洗 ==="
di as text "剩余观测数：" _N


* ============================================================
* Part 1: 变量构建
* ============================================================
/*
主要需要生成的变量：
    1. is_junior: junior 岗位 indicator（seniority ≤ 2）
    2. ym: 职位开始的年月（monthly）
    3. high_exp: 高 AI 暴露组 indicator（基于 ai_ex
posure 的 median split）
*/



gen is_junior = (seniority <= 2)
label variable is_junior "初级岗位（seniority 1-2）"

gen ym = mofd(startdate) if startdate != .
format ym %tm
label variable ym "职位开始月份"

gen high_exp = (ai_exposure >= 0.3658537) if ai_exposure != .
label variable high_exp "高AI暴露组（median split）"
label define high_exp_lb 0 "Low AI Exposure" 1 "High AI Exposure"
label values high_exp high_exp_lb

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

preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)

reg is_junior c.ai_exposure##i.post, vce(cluster onet_code)

regsave using "$tables/did_pooled.csv", replace ci level(95) ///
    addlabel(spec, "Pooled DiD")

di as text "=== Part 3 完成：Pooled DiD ==="
restore


* ============================================================
* Part 4: Event Study — junior share（半年度）
* Omitted baseline = 2022H1 = hy 9
* 时间窗口 2018H1–2025H2 (16 periods)
* ============================================================

preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)

gen half = yofd(dofm(ym))
replace half = half + 0.5 if mod(month(dofm(ym)) - 1, 6) >= 3
gen hy = (half - 2018) * 2 + 1
label variable hy "半年度编码（1=2018H1, ..., 16=2025H2）"

collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) ai_exposure, by(onet_code hy)

forvalues k = 1/16 {
    gen interact_`k' = ai_exposure * (hy == `k')
}
drop interact_9  // omitted baseline = 2022H1

reghdfe junior_share interact_* [aweight = n], ///
    absorb(onet_code hy) vce(cluster onet_code)

regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
rename coef coef_base
rename ci_lower ci_lo_base
rename ci_upper ci_hi_base
keep period coef_base ci_lo_base ci_hi_base

* 补回基准期
local N_plus = _N + 1
set obs `N_plus'
replace period = 9 if period == .
replace coef_base = 0 if period == 9
replace ci_lo_base = 0 if period == 9
replace ci_hi_base = 0 if period == 9
sort period

* 生成半年度标签
gen label = ""
forvalues i = 1/16 {
    local yr = 2018 + floor((`i' - 1) / 2)
    local h = mod(`i' - 1, 2) + 1
    replace label = "`yr'H`h'" if period == `i'
}
replace label = "2022H1" if period == 9

* 正文图
twoway (rarea ci_hi_base ci_lo_base period, color(cranberry%15) lwidth(none)) ///
       (connected coef_base period, lcolor(cranberry) mcolor(cranberry) ///
            msymbol(circle) msize(medsmall) lwidth(medthick)), ///
       xline(10, lcolor(gs8) lpattern(dash)) ///
       yline(0, lcolor(gs10) lpattern(solid) lwidth(thin)) ///
       xtitle("") ///
       ytitle("β: AI Exposure × Period", size(medium)) ///
       legend(off) ///
       xlabel(1 "2018H1" 2 "2018H2" 3 "2019H1" 4 "2019H2" ///
              5 "2020H1" 6 "2020H2" 7 "2021H1" 8 "2021H2" ///
              9 "2022H1" 10 "2022H2" 11 "2023H1" 12 "2023H2" ///
              13 "2024H1" 14 "2024H2" 15 "2025H1" 16 "2025H2", ///
              labsize(vsmall) angle(45)) ///
       ylabel(, labsize(small) format(%5.2f)) ///
       graphregion(color(white)) plotregion(color(white)) ///
       note("Baseline period: 2022H1. Dashed line marks onset of post-adoption period (2023H1)." ///
            "Standard errors clustered at O*NET code level. Shaded area: 95% CI.", ///
            size(vsmall))
graph export "$output/event_study_baseline.png", replace width(2000)

* 导出系数
export delimited period label coef_base ci_lo_base ci_hi_base ///
    using "$tables/es_half_coefs.csv", replace

restore

di as text "=== Part 4 完成：半年度 Event Study ==="


* ============================================================
* Part 4b: Event Study — junior share（季度）
* 基准期 = 2017Q1 = qtr 1, 时间窗口 2017Q1–2025Q4 (36 periods)
* ============================================================

preserve
keep if ym != . & ym >= tm(2017m1) & ym <= tm(2025m12)

gen yr = yofd(dofm(ym))
gen q = ceil(month(dofm(ym)) / 3)
gen qtr = (yr - 2017) * 4 + q

collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) ai_exposure, by(onet_code qtr)

forvalues k = 1/36 {
    gen interact_`k' = ai_exposure * (qtr == `k')
}
drop interact_1  // 基准期 = 2017Q1

reghdfe junior_share interact_* [aweight = n], ///
    absorb(onet_code qtr) vce(cluster onet_code)

regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
replace period = period - 1  // 2017Q1 = 0
rename coef coef_base
rename ci_lower ci_lo_base
rename ci_upper ci_hi_base
keep period coef_base ci_lo_base ci_hi_base

local N_plus = _N + 1
set obs `N_plus'
replace period = 0 if period == .
replace coef_base = 0 if period == 0
replace ci_lo_base = 0 if period == 0
replace ci_hi_base = 0 if period == 0
sort period

* ChatGPT onset = 2023Q1 = qtr 25 → period 24, 虚线在 23.5
twoway (rarea ci_hi_base ci_lo_base period, color(cranberry%15) lwidth(none)) ///
       (connected coef_base period, lcolor(cranberry) mcolor(cranberry) ///
            msymbol(circle) msize(medsmall) lwidth(medthick)), ///
       xline(23.5, lcolor(gs8) lpattern(dash)) ///
       yline(0, lcolor(gs10) lpattern(solid) lwidth(thin)) ///
       xtitle("") ytitle("β: AI Exposure × Quarter", size(medium)) ///
       legend(off) ///
       xlabel(0 "2017Q1" 4 "2018Q1" 8 "2019Q1" 12 "2020Q1" ///
              16 "2021Q1" 20 "2022Q1" 24 "2023Q1" 28 "2024Q1" ///
              32 "2025Q1" 35 "2025Q4", ///
              labsize(vsmall) angle(45)) ///
       ylabel(, labsize(small) format(%5.2f)) ///
       graphregion(color(white)) plotregion(color(white)) ///
       note("Baseline: 2017Q1. Dashed line marks post-adoption onset (2023Q1)." ///
            "Junior share. Standard errors clustered at O*NET code level. 95% CI.", ///
            size(vsmall))
graph export "$output/event_study_quarterly.png", replace width(2000)

export delimited period coef_base ci_lo_base ci_hi_base ///
    using "$tables/es_quarterly_coefs.csv", replace

restore

di as text "=== Part 4b 完成：季度 Event Study ==="


* ============================================================
* Part 5: DiD Event Study — log count by seniority（季度）
* 基准期 = 2017Q1, 时间窗口 2017Q1–2025Q4
* ============================================================

preserve
keep if ym != . & ym >= tm(2017m1) & ym <= tm(2025m12)

gen yr = yofd(dofm(ym))
gen q = ceil(month(dofm(ym)) / 3)
gen qtr = (yr - 2017) * 4 + q

gen one = 1
collapse (count) n = one, by(onet_code qtr is_junior ai_exposure)
gen ln_n = ln(n)

forvalues k = 1/36 {
    gen interact_`k' = ai_exposure * (qtr == `k')
}

tempfile did_seniority_data
save `did_seniority_data'
restore

* --- Junior ---
use `did_seniority_data', clear
keep if is_junior == 1
drop interact_1

reghdfe ln_n interact_* [aweight = n], ///
    absorb(onet_code qtr) vce(cluster onet_code)

regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
replace period = period - 1
rename coef coef_junior
rename ci_lower ci_lo_junior
rename ci_upper ci_hi_junior
keep period coef_junior ci_lo_junior ci_hi_junior
tempfile junior_es
save `junior_es'

* --- Senior ---
use `did_seniority_data', clear
keep if is_junior == 0
drop interact_1

reghdfe ln_n interact_* [aweight = n], ///
    absorb(onet_code qtr) vce(cluster onet_code)

regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
replace period = period - 1
rename coef coef_senior
rename ci_lower ci_lo_senior
rename ci_upper ci_hi_senior
keep period coef_senior ci_lo_senior ci_hi_senior
tempfile senior_es
save `senior_es'

* --- 合并 + 画图 ---
use `junior_es', clear
merge 1:1 period using `senior_es', nogen

local N_plus = _N + 1
set obs `N_plus'
replace period = 0 if period == .
foreach v of varlist coef_* ci_* {
    replace `v' = 0 if period == 0
}
sort period

twoway (rarea ci_hi_junior ci_lo_junior period, color(cranberry%15) lwidth(none)) ///
       (connected coef_junior period, lcolor(cranberry) mcolor(cranberry) ///
            msymbol(circle) msize(small) lwidth(medthick)) ///
       (rarea ci_hi_senior ci_lo_senior period, color(navy%15) lwidth(none)) ///
       (connected coef_senior period, lcolor(navy) mcolor(navy) ///
            msymbol(diamond) msize(small) lwidth(medthick)), ///
       xline(23.5, lcolor(gs8) lpattern(dash)) ///
       yline(0, lcolor(gs10) lpattern(solid) lwidth(thin)) ///
       xtitle("") ytitle("β: AI Exposure × Quarter", size(medium)) ///
       legend(order(2 "Juniors" 4 "Seniors") ///
              rows(1) position(6) size(small)) ///
       xlabel(0 "2017Q1" 4 "2018Q1" 8 "2019Q1" 12 "2020Q1" ///
              16 "2021Q1" 20 "2022Q1" 24 "2023Q1" 28 "2024Q1" ///
              32 "2025Q1" 35 "2025Q4", ///
              labsize(vsmall) angle(45)) ///
       ylabel(, labsize(small)) ///
       graphregion(color(white)) plotregion(color(white)) ///
       note("Baseline: 2017Q1. Dashed line marks post-adoption onset (2023Q1)." ///
            "Log position count. Standard errors clustered at O*NET code level. 95% CI.", ///
            size(vsmall))
graph export "$output/event_study_did_seniority.png", replace width(2000)

di as text "=== Part 5 完成：DiD by Seniority ==="


* ============================================================
di as text "=============================================="
di as text "02_compositional_shift.do 全部完成"
di as text "=============================================="
di as text "产出文件："
di as text "  $output/junior_share_monthly.png"
di as text "  $output/abs_count_high_exp.png"
di as text "  $output/abs_count_low_exp.png"
di as text "  $output/event_study_half.png"
di as text "  $output/event_study_quarterly.png"
di as text "  $output/event_study_did_seniority.png"
di as text "  $tables/did_pooled.csv"
di as text "  $tables/es_half_coefs.csv"
di as text "  $tables/es_quarterly_coefs.csv"
di as text "=============================================="