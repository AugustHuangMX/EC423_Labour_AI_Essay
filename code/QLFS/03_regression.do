/*==============================================================================
  03_regression.do
  
  目的：用回归检验核心预测——高暴露职业中年轻工人的就业份额是否在
        ChatGPT后相对下降
  
  策略：
    1. 构建 occupation-group × age-group × quarter 单元格级别数据
    2. 核心回归：emp_share = β₁(young × post × high_exposure) + 控制变量
    3. 多种暴露定义的稳健性检验
==============================================================================*/

clear all
set more off

global root "/Users/huangminxing/Documents/EC423_Essay"
global clean "$root/clean"
global output "$root/output"

use "$clean/qlfs_stacked.dta", clear
keep if employed == 1 & age_group != . & aioe_llm != .

* ============================================================================
* === 第一步：构建单元格级别数据 ============================================
* ============================================================================

* --- 方法1：用四分位（Q1 vs Q4）---
preserve
keep if exposure_quartile == 1 | exposure_quartile == 4

* 生成高暴露虚拟变量
gen high_exp = (exposure_quartile == 4)

* 生成年轻工人虚拟变量（22-25岁）
gen young = (age_group == 1)

* 按 季度 × 暴露组 × 年龄组 计算加权就业人数
collapse (sum) emp_count = weight, by(date_q full_year qtr high_exp age_group young post_ai)

* 计算每个 季度 × 暴露组 的总就业
bysort date_q high_exp: egen total_emp = total(emp_count)

* 就业份额（百分比）
gen emp_share = emp_count / total_emp * 100

* --- 核心回归 ---

* 回归1：基础三重差分
* emp_share = α + β₁(young × post × high) + β₂(young × post) 
*           + β₃(young × high) + β₄(post × high) 
*           + β₅(young) + β₆(post) + β₇(high) + ε

gen young_post = young * post_ai
gen young_high = young * high_exp
gen post_high  = post_ai * high_exp
gen triple     = young * post_ai * high_exp

di as text "=============================================="
di as text "回归1：基础三重差分（Q1 vs Q4）"
di as text "=============================================="

reg emp_share triple young_post young_high post_high young post_ai high_exp

* 回归2：加入季度固定效应（替代post_ai的粗略二分法）
di as text "=============================================="
di as text "回归2：加入季度固定效应"
di as text "=============================================="

reg emp_share triple young_high young##i.date_q high_exp##i.date_q

* 回归3：加权回归（用total_emp作为权重，给大单元格更多权重）
di as text "=============================================="
di as text "回归3：加权回归"
di as text "=============================================="

reg emp_share triple young_post young_high post_high young post_ai high_exp [aw=total_emp]

restore

* ============================================================================
* === 第二步：用十分位极端组（D1 vs D10）重复 ===============================
* ============================================================================

preserve

xtile exposure_decile = aioe_llm, nq(10)
keep if exposure_decile == 1 | exposure_decile == 10

gen high_exp = (exposure_decile == 10)
gen young = (age_group == 1)

collapse (sum) emp_count = weight, by(date_q full_year qtr high_exp age_group young post_ai)
bysort date_q high_exp: egen total_emp = total(emp_count)
gen emp_share = emp_count / total_emp * 100

gen young_post = young * post_ai
gen young_high = young * high_exp
gen post_high  = post_ai * high_exp
gen triple     = young * post_ai * high_exp

di as text "=============================================="
di as text "回归4：三重差分（D1 vs D10）"
di as text "=============================================="

reg emp_share triple young_post young_high post_high young post_ai high_exp

di as text "=============================================="
di as text "回归5：D1 vs D10 加权回归"
di as text "=============================================="

reg emp_share triple young_post young_high post_high young post_ai high_exp [aw=total_emp]

restore

* ============================================================================
* === 第三步：用聚焦SOC组重复 ===============================================
* ============================================================================

preserve

gen focus_group = .
replace focus_group = 1 if inlist(soc2010_2d, 24, 35, 23, 41)
replace focus_group = 0 if inlist(soc2010_2d, 81, 82, 53, 91)
keep if focus_group != .

gen high_exp = (focus_group == 1)
gen young = (age_group == 1)

collapse (sum) emp_count = weight, by(date_q full_year qtr high_exp age_group young post_ai)
bysort date_q high_exp: egen total_emp = total(emp_count)
gen emp_share = emp_count / total_emp * 100

gen young_post = young * post_ai
gen young_high = young * high_exp
gen post_high  = post_ai * high_exp
gen triple     = young * post_ai * high_exp

di as text "=============================================="
di as text "回归6：三重差分（聚焦SOC组）"
di as text "=============================================="

reg emp_share triple young_post young_high post_high young post_ai high_exp

di as text "=============================================="
di as text "回归7：聚焦SOC组加权回归"
di as text "=============================================="

reg emp_share triple young_post young_high post_high young post_ai high_exp [aw=total_emp]

restore

di as text "=============================================="
di as text "所有回归完成。"
di as text "=============================================="
