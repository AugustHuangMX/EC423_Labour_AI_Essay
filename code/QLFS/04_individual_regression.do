/*==============================================================================
  04_individual_regression.do
  
  目的：在个人层面检验核心预测——年轻工人在ChatGPT后是否更不可能
        出现在高AI暴露职业中
  
  优势：利用80万+个人级别观测，而不是压缩为224个单元格
  
  策略：
    1. OLS：aioe_llm = β(young × post) + 控制变量
       → 年轻工人在2023年后是否转向更低暴露的职业？
    2. Probit/LPM：high_exposure = β(young × post) + 控制变量
       → 年轻工人在2023年后进入高暴露职业的概率是否下降？
    3. 加入更多年龄组的交互项看梯度
==============================================================================*/

clear all
set more off

global root "/Users/huangminxing/Documents/EC423_Essay"
global clean "$root/clean"
global output "$root/output"

use "$clean/qlfs_stacked.dta", clear

* 限定样本：在职、有有效年龄组和暴露评分
keep if employed == 1 & age_group != . & aioe_llm != .
* === 只保留第一波受访者，避免同一个人重复观测 ===
keep if wave == 1
di "Wave 1 样本量: " _N

* --- 生成关键变量 ---
gen young = (age_group == 1)
label variable young "22-25岁"

gen young_post = young * post_ai

* 各年龄组的虚拟变量（以41-64为基准组）
gen age_2225 = (age_group == 1)
gen age_2630 = (age_group == 2)
gen age_3140 = (age_group == 3)

* 各年龄组与post_ai的交互
gen age_2225_post = age_2225 * post_ai
gen age_2630_post = age_2630 * post_ai
gen age_3140_post = age_3140 * post_ai

* ============================================================================
* === 第一组：因变量 = LLM暴露评分（连续型）================================
* === 问题：年轻工人在2023年后是否转向更低暴露的职业？ ====================
* ============================================================================

encode region, gen(region_num)

di as text "=============================================="
di as text "回归A1：OLS，因变量=LLM暴露评分，二分年龄"
di as text "=============================================="

reg aioe_llm young_post young post_ai [pw=weight], robust

di as text "=============================================="
di as text "回归A2：加入性别、地区、学历控制变量"
di as text "=============================================="

reg aioe_llm young_post young post_ai i.sex i.region_num i.hiqual [pw=weight], robust

di as text "=============================================="
di as text "回归A3：用季度固定效应替代post_ai"
di as text "=============================================="

reg aioe_llm young##i.date_q i.sex i.region_num [pw=weight], robust

* 看young在各季度的边际效应
margins, dydx(young) at(date_q=(236(1)263)) vsquish

di as text "=============================================="
di as text "回归A4：所有年龄组的交互（以41-64为基准）"
di as text "=============================================="

reg aioe_llm age_2225_post age_2630_post age_3140_post ///
    age_2225 age_2630 age_3140 post_ai ///
    i.sex i.region_num [pw=weight], robust

di as text "=============================================="
di as text "回归A5：所有年龄组 × 季度固定效应"
di as text "=============================================="

reg aioe_llm age_2225##i.date_q age_2630##i.date_q age_3140##i.date_q ///
    i.sex i.region_num [pw=weight], robust

* 看22-25岁在各季度的边际效应（对比基准组41-64）
margins, dydx(age_2225) at(date_q=(236(1)263)) vsquish

* ============================================================================
* === 第二组：因变量 = 高暴露虚拟变量（LPM）================================
* === 问题：年轻工人在2023年后进入高暴露职业的概率是否下降？ ==============
* ============================================================================

di as text "=============================================="
di as text "回归B1：LPM，因变量=高暴露（中位数分割）"
di as text "=============================================="

reg high_exposure young_post young post_ai [pw=weight], robust

di as text "=============================================="
di as text "回归B2：LPM加控制变量"
di as text "=============================================="

reg high_exposure young_post young post_ai i.sex i.region_num i.hiqual [pw=weight], robust

di as text "=============================================="
di as text "回归B3：LPM，因变量=Q4暴露（top 25%）"
di as text "=============================================="

gen in_q4 = (exposure_quartile == 4) if exposure_quartile != .
label variable in_q4 "处于最高暴露四分位"

reg in_q4 young_post young post_ai [pw=weight], robust

di as text "=============================================="
di as text "回归B4：LPM Q4加控制变量"
di as text "=============================================="

reg in_q4 young_post young post_ai i.sex i.region_num i.hiqual [pw=weight], robust

di as text "=============================================="
di as text "回归B5：所有年龄组交互，因变量=Q4暴露"
di as text "=============================================="

reg in_q4 age_2225_post age_2630_post age_3140_post ///
    age_2225 age_2630 age_3140 post_ai ///
    i.sex i.region_num [pw=weight], robust

* ============================================================================
* === 第三组：结果汇总表 ====================================================
* ============================================================================

di as text "=============================================="
di as text "核心系数汇总"
di as text "=============================================="
di as text "关键系数是 young_post（或 age_2225_post）"
di as text "理论预测：负值（年轻工人在AI后转向低暴露职业）"
di as text "=============================================="
