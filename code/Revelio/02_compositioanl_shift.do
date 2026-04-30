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

save "$root/clean/positions_all.dta", replace
** merge 的含义是 many to one. 第一个变量是匹配变量。using xxx 的含义是用此前保存过的 `bad_users` 数据集来 merge。keep(master) 的含义是只保留 master 数据集（即原始数据）中的观测。nogen 的含义是 merge 后不生成 _merge 变量。 keep(master) 意味着保存没有匹配的主数据行(即不在 bad_users) 里的行。
** nogen 意味着不生成 _merge 变量。因为我们只关心保留原始数据中的观测，而不需要知道哪些观测被匹配到了 bad_users 中。




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

** 按照中位数进行更改

label variable high_m1 "m1: 高AI暴露组"
label variable high_m2 "m2: 高AI暴露组"
label variable high_m3 "m3: 高AI暴露组"

** 打标签
label define high_m1_lb 0 "Low AI Exposure" 1 "High AI Exposure"
label values high_m1 high_m1_lb
label define high_m2_lb 0 "Low AI Exposure" 1 "High AI Exposure"
label values high_m2 high_m2_lb
label define high_m3_lb 0 "Low AI Exposure" 1 "High AI Exposure"
label values high_m3 high_m3_lb



gen post = (startdate >= td(01jan2023)) if startdate != .
label variable post "Post-ChatGPT（2023年1月起）"

di as text "=== Part 1 完成：变量构建 ==="

tab is_junior
tab high_m1
tab high_m2
tab high_m3
tab post


* ============================================================
* Part 2: 描述性图
* ============================================================

* --- 2a. 月度 junior share 趋势图 ---
preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)

collapse (mean) junior_share = is_junior (count) n = is_junior, by(ym high_m1)

twoway (line junior_share ym if high_m1 == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line junior_share ym if high_m1 == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("Junior Share of New Positions") ///
       legend(order(1 "High AI Exposure" 2 "Low AI Exposure") ///
              rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022). Junior = seniority ≤ 2." ///
            "AI exposure median split at 0.366 (Eloundou et al. 2024).")
// graph export "$output/junior_share_monthly.png", replace width(2000)
restore

* --- 2b. 绝对数量图：高暴露组 ---
preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)
gen one = 1
collapse (count) n = one, by(ym high_m1 is_junior)
gen n_k = n / 1000

twoway (line n_k ym if high_m1 == 1 & is_junior == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line n_k ym if high_m1 == 1 & is_junior == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("New Position Starts (thousands)") ///
       legend(order(1 "Junior (seniority ≤ 2)" 2 "Senior (seniority ≥ 3)") ///
              rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022).")
//graph export "$output/abs_count_high_exp.png", replace width(2000)

* --- 2c. 绝对数量图：低暴露组 ---
twoway (line n_k ym if high_m1 == 0 & is_junior == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line n_k ym if high_m1 == 0 & is_junior == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("New Position Starts (thousands)") ///
       legend(order(1 "Junior (seniority ≤ 2)" 2 "Senior (seniority ≥ 3)") ///
              rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       note("Vertical line: ChatGPT release (Nov 2022).")
//graph export "$output/abs_count_low_exp.png", replace width(2000)
restore

di as text "=== Part 2 完成：描述性图 ==="


* ============================================================
* Part 3: Pooled DiD 回归
* ============================================================

preserve
keep if ym >= tm(2018m1) & ym <= tm(2025m12)

* 生成半年度编码（和 event study 一致）
gen half = yofd(dofm(ym))
replace half = half + 0.5 if month(dofm(ym)) >= 7
gen hy = (half - 2018) * 2 + 1

* Collapse 到职业×半年度
collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) m1, by(onet_code hy)

* 生成 post 变量（hy >= 10 即 2022H2 及之后）
gen post = (hy >= 10)

* Pooled DiD，和 event study 同一数据结构
gen ai_post = m1 * post
reghdfe junior_share ai_post [aweight = n], ///
    absorb(onet_code hy) vce(cluster onet_code)

restore

* ============================================================
* Part 4: Event Study — junior share（半年度）
* Omitted baseline = 2022H2 = hy 10
* 时间窗口 2018H1–2025H2 (16 periods)
* ============================================================

preserve
keep if ym != . & ym >= tm(2018m1) & ym <= tm(2025m12)

gen half = yofd(dofm(ym))
replace half = half + 0.5 if month(dofm(ym)) >= 7
gen hy = (half - 2018) * 2 + 1
label variable hy "半年度编码（1=2018H1, ..., 16=2025H2）"

collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) m1, by(onet_code hy)

forvalues k = 1/16 {
    gen interact_`k' = m1 * (hy == `k')
}
drop interact_10 // omitted baseline = 2022H1

reghdfe junior_share interact_* [aweight = n], ///
    absorb(onet_code hy) vce(cluster onet_code)

regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
rename coef coef_base
rename ci_lower ci_lo_base
rename ci_upper ci_hi_base
keep period coef_base ci_lo_base ci_hi_base

* 手动补回基准期
local N_plus = _N + 1
set obs `N_plus'
replace period = 10 if period == .
replace coef_base = 0 if period == 10
replace ci_lo_base = 0 if period == 10
replace ci_hi_base = 0 if period == 10
sort period


* 生成半年度标签
gen label = ""
forvalues i = 1/16 {
    local yr = 2018 + floor((`i' - 1) / 2)
    local h = mod(`i' - 1, 2) + 1
    replace label = "`yr'H`h'" if period == `i'
}
replace label = "2022H2" if period == 10

* 正文图
twoway (rarea ci_hi_base ci_lo_base period, color(cranberry%15) lwidth(none)) ///
       (connected coef_base period, lcolor(cranberry) mcolor(cranberry) ///
            msymbol(circle) msize(medsmall) lwidth(medthick)), ///
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
       note("Standard errors clustered at O*NET code level. Shaded area: 95% CI.", ///
            size(vsmall))
graph export "$output/event_study_baseline.png", replace width(2000)

* 导出系数
export delimited period label coef_base ci_lo_base ci_hi_base ///
    using "$tables/es_half_coefs.csv", replace

restore

di as text "=== Part 4 完成：半年度 Event Study ==="


* ============================================================
* Part 4b: Event Study — junior share（季度）
* 基准期 = 2018Q1 = qtr 1, 时间窗口 2018Q1–2025Q4 (32 periods)
* ============================================================

preserve
keep if ym >= tm(2018m1) & ym <= tm(2025m12)

* 生成季度编码（1=2018Q1, ..., 32=2025Q4）
gen yr = yofd(dofm(ym))
gen q = ceil(month(dofm(ym)) / 3)
gen qtr = (yr - 2018) * 4 + q

* Collapse 到职业×季度
collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) m1, by(onet_code qtr)

* 生成交互项，基准期 = 2022Q1 = qtr 17
forvalues k = 1/32 {
    gen interact_`k' = m1 * (qtr == `k')
}
drop interact_19  // omitted baseline = 2022Q3

reghdfe junior_share interact_* [aweight = n], ///
    absorb(onet_code qtr) vce(cluster onet_code)

regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
rename coef coef_base
rename ci_lower ci_lo_base
rename ci_upper ci_hi_base
keep period coef_base ci_lo_base ci_hi_base

* 补回基准期
local N_plus = _N + 1
set obs `N_plus'
replace period = 19 if period == .
replace coef_base = 0 if period == 19
replace ci_lo_base = 0 if period == 19
replace ci_hi_base = 0 if period == 19
sort period

* 生成季度标签
gen label = ""
forvalues i = 1/32 {
    local yr = 2018 + floor((`i' - 1) / 4)
    local qq = mod(`i' - 1, 4) + 1
    replace label = "`yr'Q`qq'" if period == `i'
}

* 图
twoway (rarea ci_hi_base ci_lo_base period, color(cranberry%15) lwidth(none)) ///
       (connected coef_base period, lcolor(cranberry) mcolor(cranberry) ///
            msymbol(circle) msize(medsmall) lwidth(medthick)), ///
       yline(0, lcolor(gs10) lpattern(solid) lwidth(thin)) ///
       xtitle("") ///
       ytitle("β: AI Exposure × Quarter", size(medium)) ///
       legend(off) ///
       xlabel(1 "2018Q1" 5 "2019Q1" 9 "2020Q1" 13 "2021Q1" ///
              17 "2022Q1" 21 "2023Q1" 25 "2024Q1" 29 "2025Q1" ///
              32 "2025Q4", ///
              labsize(vsmall) angle(45)) ///
       ylabel(, labsize(small) format(%5.2f)) ///
       graphregion(color(white)) plotregion(color(white)) ///
       note("Standard errors clustered at O*NET code level. Shaded area: 95% CI.", ///
            size(vsmall))
graph export "$output/event_study_quarterly.png", replace width(2000)

export delimited period label coef_base ci_lo_base ci_hi_base ///
    using "$tables/es_quarterly_coefs.csv", replace
restore
di as text "=== Part 4b 完成：季度 Event Study ==="

