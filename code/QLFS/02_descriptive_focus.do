/*==============================================================================
  02_descriptive_focused.do
  
  目的：在更细的职业层面寻找年龄构成变化的信号
  
  策略：
    1. 按2位数SOC查看哪些组LLM暴露最高
    2. 聚焦特定高暴露职业组 vs 特定低暴露职业组
    3. 用top 10% vs bottom 10%替代四分位
==============================================================================*/

clear all
set more off

global root "/Users/huangminxing/Documents/EC423_Essay"
global clean "$root/clean"
global output "$root/output"

use "$clean/qlfs_stacked.dta", clear
keep if employed == 1 & age_group != . & aioe_llm != .

* ============================================================================
* === 第一步：看哪些2位数SOC组LLM暴露最高 ==================================
* ============================================================================

* 计算每个2位数SOC的平均LLM暴露评分和就业人数
preserve
collapse (mean) mean_llm = aioe_llm (sum) emp = weight, by(soc2010_2d)
gsort -mean_llm
list soc2010_2d mean_llm emp, clean
restore

* ============================================================================
* === 第二步：定义聚焦的高/低暴露职业组 ====================================
* ============================================================================

* 基于2位数SOC的平均LLM暴露，选择最高和最低的几组

gen focus_group = .
* 高暴露核心组改为 SOC 24/35/23/41（都在1.0附近或以上）
replace focus_group = 1 if inlist(soc2010_2d, 24, 35, 23, 41)

* 低暴露对照组改为 SOC 81/82/53/91（都低于-1.0）
replace focus_group = 0 if inlist(soc2010_2d, 81, 82, 53, 91)

label define focus_lbl 0 "低暴露对照组" 1 "高暴露核心组"
label values focus_group focus_lbl

* 快速检查分组的LLM评分分布
tabstat aioe_llm if focus_group != ., by(focus_group) stat(mean sd min max n)

* ============================================================================
* === 第三步：聚焦组的就业份额时间序列 ======================================
* ============================================================================

preserve
keep if focus_group != .

* 计算每个 季度×聚焦组×年龄组 的加权就业人数
collapse (sum) emp_count = weight, by(date_q full_year qtr focus_group age_group)

* 计算每个 季度×聚焦组 的总就业
bysort date_q focus_group: egen total_emp = total(emp_count)

* 就业份额
gen emp_share = emp_count / total_emp * 100

* --- 图4：22-25岁在聚焦高暴露 vs 聚焦低暴露中的就业份额 ---
twoway ///
    (connected emp_share date_q if age_group == 1 & focus_group == 1, ///
        mcolor(cranberry) lcolor(cranberry) msymbol(circle) lpattern(solid)) ///
    (connected emp_share date_q if age_group == 1 & focus_group == 0, ///
        mcolor(navy) lcolor(navy) msymbol(triangle) lpattern(dash)) ///
    , ///
    legend(order(1 "高暴露核心（SOC 24/35/41）" 2 "低暴露对照（SOC 81/82/92）") ///
        rows(1) position(6) size(small)) ///
    title("22-25岁就业份额：聚焦高 vs 低LLM暴露职业组") ///
    subtitle("来源：UK LFS 2019-2025") ///
    ytitle("22-25岁占该组就业的比例（%）") ///
    xtitle("") ///
    xline(`=yq(2022,4)', lcolor(gs10) lpattern(dash)) ///
    text(8 `=yq(2022,4)' "ChatGPT发布", size(vsmall) placement(east)) ///
    ylabel(, angle(0) format(%4.1f)) ///
    scheme(s2color) ///
    name(fig_focused_2225, replace)

graph export "$output/fig_focused_22_25.png", replace width(1200)

* --- 图5：聚焦高暴露组内各年龄段份额 ---
twoway ///
    (connected emp_share date_q if age_group == 1 & focus_group == 1, ///
        mcolor(cranberry) lcolor(cranberry) msymbol(circle) lwidth(medthick)) ///
    (connected emp_share date_q if age_group == 2 & focus_group == 1, ///
        mcolor(orange) lcolor(orange) msymbol(diamond) lpattern(dash)) ///
    (connected emp_share date_q if age_group == 3 & focus_group == 1, ///
        mcolor(forest_green) lcolor(forest_green) msymbol(square) lpattern(shortdash)) ///
    (connected emp_share date_q if age_group == 4 & focus_group == 1, ///
        mcolor(navy) lcolor(navy) msymbol(triangle) lpattern(longdash)) ///
    , ///
    legend(order(1 "22-25岁" 2 "26-30岁" 3 "31-40岁" 4 "41-64岁") rows(1) position(6)) ///
    title("高LLM暴露核心职业（SOC 24/35/41）年龄构成变化") ///
    subtitle("来源：UK LFS 2019-2025") ///
    ytitle("占该组就业的比例（%）") ///
    xtitle("") ///
    xline(`=yq(2022,4)', lcolor(gs10) lpattern(dash)) ///
    ylabel(, angle(0) format(%4.1f)) ///
    scheme(s2color) ///
    name(fig_focused_q4_ages, replace)

graph export "$output/fig_focused_high_composition.png", replace width(1200)

restore

* ============================================================================
* === 第四步：用 top 10% vs bottom 10% 的极端分割 ===========================
* ============================================================================

* 创建十分位
xtile exposure_decile = aioe_llm if employed == 1, nq(10)

preserve
keep if exposure_decile == 1 | exposure_decile == 10

collapse (sum) emp_count = weight, by(date_q full_year qtr exposure_decile age_group)
bysort date_q exposure_decile: egen total_emp = total(emp_count)
gen emp_share = emp_count / total_emp * 100

* --- 图6：22-25岁在top 10% vs bottom 10%中的就业份额 ---
twoway ///
    (connected emp_share date_q if age_group == 1 & exposure_decile == 10, ///
        mcolor(cranberry) lcolor(cranberry) msymbol(circle) lpattern(solid)) ///
    (connected emp_share date_q if age_group == 1 & exposure_decile == 1, ///
        mcolor(navy) lcolor(navy) msymbol(triangle) lpattern(dash)) ///
    , ///
    legend(order(1 "最高暴露（D10）" 2 "最低暴露（D1）") rows(1) position(6)) ///
    title("22-25岁就业份额：最高 vs 最低10%LLM暴露职业") ///
    subtitle("来源：UK LFS 2019-2025") ///
    ytitle("22-25岁占该组就业的比例（%）") ///
    xtitle("") ///
    xline(`=yq(2022,4)', lcolor(gs10) lpattern(dash)) ///
    ylabel(, angle(0) format(%4.1f)) ///
    scheme(s2color) ///
    name(fig_decile_2225, replace)

graph export "$output/fig_decile_22_25.png", replace width(1200)

restore

di as text "分析完成。请查看 $output 文件夹中的图表。"
