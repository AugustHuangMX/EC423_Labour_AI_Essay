/*
============================================================
05_robustness.do
============================================================
目的：Part A (Compositional Shift) 的 Robustness Checks

Specifications：
  主回归: z(m1) continuous, junior ≤ 2
  R1: z(m2) Felten AIOE, junior ≤ 2
  R2: z(m3) Tomlinson AI Applicability, junior ≤ 2
  R3: z(m1), junior ≤ 1
  R4: z(m1), junior ≤ 3
  R5: high_m1 binary, junior ≤ 2

所有 continuous measures 做 occupation-level z-score 标准化，
使系数统一解读为"AI exposure 增加一个标准差的效应"。
R5 用 binary treatment（不标准化），系数解读为高/低组差异。

Baseline = 2022H2 (hy = 10)
Post = 2023H1 起 (hy >= 11)
Cluster SE: O*NET code level

产出：
  - output/figures/rob_es_main.png    （主回归，标准化版）
  - output/figures/rob_es_m2.png      （R1: Felten）
  - output/figures/rob_es_m3.png      （R2: Tomlinson）
  - output/figures/rob_es_sen1.png    （R3: seniority ≤ 1）
  - output/figures/rob_es_sen3.png    （R4: seniority ≤ 3）
  - output/figures/rob_es_binary.png  （R5: binary treatment）
  - output/tables/robustness_summary.csv
============================================================
*/


* ============================================================
* Part 0: 环境设置 + 数据加载 + 标准化
* ============================================================

clear all
set more off

global root "/Users/huangminxing/Documents/EC423_Essay"
global output "$root/output/figures"
global tables "$root/output/tables"

use "$root/clean/positions_all.dta", clear

* --- Occupation-level z-score 标准化 ---
* 先提取每个 onet_code 的唯一值计算均值和标准差，
* 避免被每个职业的 position 数量加权

preserve
keep onet_code m1 m2 m3
duplicates drop onet_code, force
foreach v in m1 m2 m3 {
    summ `v'
    local mean_`v' = r(mean)
    local sd_`v' = r(sd)
}
restore

foreach v in m1 m2 m3 {
    gen z_`v' = (`v' - `mean_`v'') / `sd_`v''
}

* --- Junior indicators（三种 cutoff）---
gen is_junior_2 = (seniority <= 2)
gen is_junior_1 = (seniority <= 1)
gen is_junior_3 = (seniority <= 3)

gen ym = mofd(startdate) if startdate != .
format ym %tm

di as text "=== Part 0 完成 ==="
di as text "z_m1 均值: `mean_m1', 标准差: `sd_m1'"
di as text "z_m2 均值: `mean_m2', 标准差: `sd_m2'"
di as text "z_m3 均值: `mean_m3', 标准差: `sd_m3'"


* ============================================================
* Part 1: 定义 robustness program
* ============================================================
/*
参数说明：
  treat()  — treatment 变量名（如 z_m1, z_m2, high_m1）
  junior() — junior indicator 变量名（如 is_junior_2）
  fig()    — 输出图文件路径
  label()  — 图标题

程序同时跑 pooled DiD 和 event study，
通过 return scalar 返回 pooled DiD 的系数、SE、N。
*/

capture program drop run_robustness
program define run_robustness, rclass
    syntax, treat(string) junior(string) fig(string) label(string)

    preserve
    keep if ym >= tm(2018m1) & ym <= tm(2025m12)

    * --- 半年度编码（修正版：H1 = Jan-Jun, H2 = Jul-Dec）---
    gen half = yofd(dofm(ym))
    replace half = half + 0.5 if month(dofm(ym)) >= 7
    gen hy = (half - 2018) * 2 + 1

    * --- Collapse 到职业×半年度 ---
    collapse (mean) junior_share = `junior' (count) n = `junior' ///
             (first) `treat', by(onet_code hy)

    * === Pooled DiD ===
    gen post = (hy >= 11)
    gen ai_post = `treat' * post
    reghdfe junior_share ai_post [aweight = n], ///
        absorb(onet_code hy) vce(cluster onet_code)

    * 保存 pooled DiD 结果
    return scalar b = _b[ai_post]
    return scalar se = _se[ai_post]
    return scalar N = e(N)

    * === Event Study ===
    drop ai_post post
    forvalues k = 1/16 {
        gen interact_`k' = `treat' * (hy == `k')
    }
    drop interact_10  // baseline = 2022H2

    reghdfe junior_share interact_* [aweight = n], ///
        absorb(onet_code hy) vce(cluster onet_code)

    regsave interact_*, ci level(95)
    gen period = real(subinstr(var, "interact_", "", .))
    rename coef beta
    rename ci_lower ci_lo
    rename ci_upper ci_hi
    keep period beta ci_lo ci_hi

    * 补回基准期
    local np1 = _N + 1
    set obs `np1'
    replace period = 10 if period == .
    replace beta   = 0  if period == 10
    replace ci_lo  = 0  if period == 10
    replace ci_hi  = 0  if period == 10
    sort period

    * --- 画图 ---
    twoway (rarea ci_hi ci_lo period, color(cranberry%15) lwidth(none)) ///
           (connected beta period, lcolor(cranberry) mcolor(cranberry) ///
                msymbol(circle) msize(medsmall) lwidth(medthick)), ///
           yline(0, lcolor(gs10) lpattern(solid) lwidth(thin)) ///
           xtitle("") ///
           ytitle("β: AI Exposure × Period", size(medium)) ///
           title("`label'", size(medium)) ///
           legend(off) ///
           xlabel(1 "2018H1" 2 "2018H2" 3 "2019H1" 4 "2019H2" ///
                  5 "2020H1" 6 "2020H2" 7 "2021H1" 8 "2021H2" ///
                  9 "2022H1" 10 "2022H2" 11 "2023H1" 12 "2023H2" ///
                  13 "2024H1" 14 "2024H2" 15 "2025H1" 16 "2025H2", ///
                  labsize(vsmall) angle(45)) ///
           ylabel(, labsize(small) format(%5.2f)) ///
           graphregion(color(white)) plotregion(color(white)) ///
           note("Std errors clustered at O*NET code level. 95% CI.", ///
                size(vsmall))
    graph export "`fig'", replace width(2000)

    restore
end


* ============================================================
* Part 2: 运行全部 6 个 specifications
* ============================================================

* --- Spec 0: 主回归（标准化版，用于汇总表对比）---
run_robustness, treat(z_m1) junior(is_junior_2) ///
    fig("$output/rob_es_main.png") ///
    label("Main: Eloundou (std), Junior ≤ 2")
local b0  = r(b)
local se0 = r(se)
local n0  = r(N)
di as text "=== Spec 0 完成: b = `b0', se = `se0' ==="

* --- R1: Felten AIOE ---
run_robustness, treat(z_m2) junior(is_junior_2) ///
    fig("$output/rob_es_m2.png") ///
    label("R1: Felten AIOE (std), Junior ≤ 2")
local b1  = r(b)
local se1 = r(se)
local n1  = r(N)
di as text "=== R1 完成: b = `b1', se = `se1' ==="

* --- R2: Tomlinson AI Applicability ---
run_robustness, treat(z_m3) junior(is_junior_2) ///
    fig("$output/rob_es_m3.png") ///
    label("R2: Tomlinson (std), Junior ≤ 2")
local b2  = r(b)
local se2 = r(se)
local n2  = r(N)
di as text "=== R2 完成: b = `b2', se = `se2' ==="

* --- R3: Seniority ≤ 1 ---
run_robustness, treat(z_m1) junior(is_junior_1) ///
    fig("$output/rob_es_sen1.png") ///
    label("R3: Eloundou (std), Junior ≤ 1")
local b3  = r(b)
local se3 = r(se)
local n3  = r(N)
di as text "=== R3 完成: b = `b3', se = `se3' ==="

* --- R4: Seniority ≤ 3 ---
run_robustness, treat(z_m1) junior(is_junior_3) ///
    fig("$output/rob_es_sen3.png") ///
    label("R4: Eloundou (std), Junior ≤ 3")
local b4  = r(b)
local se4 = r(se)
local n4  = r(N)
di as text "=== R4 完成: b = `b4', se = `se4' ==="

* --- R5: Binary treatment ---
run_robustness, treat(high_m1) junior(is_junior_2) ///
    fig("$output/rob_es_binary.png") ///
    label("R5: Eloundou Binary, Junior ≤ 2")
local b5  = r(b)
local se5 = r(se)
local n5  = r(N)
di as text "=== R5 完成: b = `b5', se = `se5' ==="


* ============================================================
* Part 3: 汇总表
* ============================================================

clear
set obs 6

gen spec = ""
gen treatment = ""
gen junior_def = ""
gen coef = .
gen se = .
gen N = .

replace spec       = "Main"            in 1
replace spec       = "R1: Felten"      in 2
replace spec       = "R2: Tomlinson"   in 3
replace spec       = "R3: Sen ≤ 1"     in 4
replace spec       = "R4: Sen ≤ 3"     in 5
replace spec       = "R5: Binary"      in 6

replace treatment  = "z(Eloundou)"         in 1
replace treatment  = "z(Felten)"           in 2
replace treatment  = "z(Tomlinson)"        in 3
replace treatment  = "z(Eloundou)"         in 4
replace treatment  = "z(Eloundou)"         in 5
replace treatment  = "Binary(Eloundou)"    in 6

replace junior_def = "≤ 2" in 1
replace junior_def = "≤ 2" in 2
replace junior_def = "≤ 2" in 3
replace junior_def = "≤ 1" in 4
replace junior_def = "≤ 3" in 5
replace junior_def = "≤ 2" in 6

replace coef = `b0'  in 1
replace coef = `b1'  in 2
replace coef = `b2'  in 3
replace coef = `b3'  in 4
replace coef = `b4'  in 5
replace coef = `b5'  in 6

replace se = `se0' in 1
replace se = `se1' in 2
replace se = `se2' in 3
replace se = `se3' in 4
replace se = `se4' in 5
replace se = `se5' in 6

replace N = `n0' in 1
replace N = `n1' in 2
replace N = `n2' in 3
replace N = `n3' in 4
replace N = `n4' in 5
replace N = `n5' in 6

* 生成星号标记
gen stars = ""
forvalues i = 1/6 {
    local t = coef[`i'] / se[`i']
    local at = abs(`t')
    if `at' >= 2.576 {
        replace stars = "***" in `i'
    }
    else if `at' >= 1.96 {
        replace stars = "**" in `i'
    }
    else if `at' >= 1.645 {
        replace stars = "*" in `i'
    }
}

list spec treatment junior_def coef se stars N, clean noobs

export delimited using "$tables/robustness_summary.csv", replace

di as text "=== 全部 robustness checks 完成 ==="
