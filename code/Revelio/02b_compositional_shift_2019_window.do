/*
============================================================
02b_compositional_shift_2019_window.do
============================================================
目的：作为 robustness check，重新估计 compositional shift 的
      2019H1--2025H2 窗口版本。

核心变化：
  1. 时间窗口从 2018m1--2025m12 改为 2019m1--2025m12。
  2. 半年度 event study 改为 14 个 periods：
       1 = 2019H1, ..., 14 = 2025H2。
  3. omitted baseline 为 2022H2，在新编码下为 hy = 8。
  4. 输出文件均带有 _2019window 后缀，避免覆盖主结果。

注意：本文件不会覆盖 clean/positions_all.dta。
============================================================
*/

clear all
set more off

global root "/Users/huangminxing/Documents/EC423_Essay"
global output "$root/output/figures"
global tables "$root/output/tables"

cap mkdir "$output"
cap mkdir "$tables"

use "$root/clean/positions_all.dta", clear

* --- 清洗异常用户：position_number > 50 的整个 user_id drop，但不写回原始数据 ---
bysort user_id: egen byte bad_user = max(position_number > 50)
drop if bad_user == 1
drop bad_user

* --- 变量构建 ---
gen byte is_junior = (seniority <= 2) if !missing(seniority)
label variable is_junior "初级岗位（seniority 1-2）"

gen int ym = mofd(startdate) if !missing(startdate)
format ym %tm
label variable ym "职位开始月份"

* ============================================================
* Part 1: 月度 junior share 图（2019 window）
* ============================================================

preserve
keep if !missing(ym) & ym >= tm(2019m1) & ym <= tm(2025m12)

collapse (mean) junior_share = is_junior (count) n = is_junior, by(ym high_m1)

twoway (line junior_share ym if high_m1 == 1, lcolor(cranberry) lwidth(medthick)) ///
       (line junior_share ym if high_m1 == 0, lcolor(navy) lwidth(medthick)), ///
       xline(`=tm(2022m11)', lcolor(gs8) lpattern(dash)) ///
       xtitle("") ytitle("Junior Share of New Positions") ///
       legend(order(1 "High AI Exposure" 2 "Low AI Exposure") ///
              rows(1) position(6)) ///
       xlabel(, format(%tmCY) angle(45)) ///
       graphregion(color(white)) plotregion(color(white)) ///
       note("Vertical line: ChatGPT release (Nov 2022). Junior = seniority <= 2." ///
            "AI exposure median split at 0.366 (Eloundou et al. 2024).")

graph export "$output/junior_share_monthly_2019window.png", replace width(2000)
restore

* ============================================================
* Part 2: Pooled DiD（2019 window）
* ============================================================

preserve
keep if !missing(ym) & ym >= tm(2019m1) & ym <= tm(2025m12)

gen half = yofd(dofm(ym))
replace half = half + 0.5 if month(dofm(ym)) >= 7
gen hy = (half - 2019) * 2 + 1
label variable hy "半年度编码（1=2019H1, ..., 14=2025H2）"

collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) m1, by(onet_code hy)

* Post period starts from 2023H1; 2022H2 is the omitted pre-adjustment baseline
gen byte post = (hy > 8)
gen double ai_post = m1 * post

reghdfe junior_share ai_post [aweight = n], ///
    absorb(onet_code hy) vce(cluster onet_code)

regsave ai_post, ci level(95)
export delimited using "$tables/did_pooled_2019window.csv", replace

restore

* ============================================================
* Part 3: Event Study — junior share（2019 window）
* ============================================================

preserve
keep if !missing(ym) & ym >= tm(2019m1) & ym <= tm(2025m12)

gen half = yofd(dofm(ym))
replace half = half + 0.5 if month(dofm(ym)) >= 7
gen hy = (half - 2019) * 2 + 1
label variable hy "半年度编码（1=2019H1, ..., 14=2025H2）"

collapse (mean) junior_share = is_junior (count) n = is_junior ///
         (first) m1, by(onet_code hy)

forvalues k = 1/14 {
    gen double interact_`k' = m1 * (hy == `k')
}
drop interact_8   // omitted baseline = 2022H2

reghdfe junior_share interact_* [aweight = n], ///
    absorb(onet_code hy) vce(cluster onet_code)

regsave interact_*, ci level(95)
gen period = real(subinstr(var, "interact_", "", .))
rename coef coef_base
rename ci_lower ci_lo_base
rename ci_upper ci_hi_base
keep period coef_base ci_lo_base ci_hi_base

* 手动补回基准期
set obs 14
replace period = 8 if missing(period)
replace coef_base = 0 if period == 8
replace ci_lo_base = 0 if period == 8
replace ci_hi_base = 0 if period == 8
sort period

* 生成半年度标签
gen label = ""
replace label = "2019H1" if period == 1
replace label = "2019H2" if period == 2
replace label = "2020H1" if period == 3
replace label = "2020H2" if period == 4
replace label = "2021H1" if period == 5
replace label = "2021H2" if period == 6
replace label = "2022H1" if period == 7
replace label = "2022H2" if period == 8
replace label = "2023H1" if period == 9
replace label = "2023H2" if period == 10
replace label = "2024H1" if period == 11
replace label = "2024H2" if period == 12
replace label = "2025H1" if period == 13
replace label = "2025H2" if period == 14

twoway (rarea ci_hi_base ci_lo_base period, color(cranberry%15) lwidth(none)) ///
       (connected coef_base period, lcolor(cranberry) mcolor(cranberry) ///
            msymbol(circle) msize(medsmall) lwidth(medthick)), ///
       yline(0, lcolor(gs10) lpattern(solid) lwidth(thin)) ///
       xtitle("") ///
       ytitle("beta: AI Exposure x Period", size(medium)) ///
       legend(off) ///
       xlabel(1 "2019H1" 2 "2019H2" 3 "2020H1" 4 "2020H2" ///
              5 "2021H1" 6 "2021H2" 7 "2022H1" 8 "2022H2" ///
              9 "2023H1" 10 "2023H2" 11 "2024H1" 12 "2024H2" ///
              13 "2025H1" 14 "2025H2", labsize(vsmall) angle(45)) ///
       ylabel(, labsize(small) format(%5.2f)) ///
       graphregion(color(white)) plotregion(color(white)) ///
       note("Omitted baseline: 2022H2." ///
            "Standard errors clustered at O*NET code level. Shaded area: 95% CI.", ///
            size(vsmall))

graph export "$output/event_study_baseline_2019window.png", replace width(2000)

export delimited period label coef_base ci_lo_base ci_hi_base ///
    using "$tables/es_half_coefs_2019window.csv", replace

restore

di as text "=== 完成：2019H1--2025H2 compositional shift robustness do-file ==="
