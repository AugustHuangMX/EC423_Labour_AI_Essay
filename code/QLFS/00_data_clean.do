/*==============================================================================
  00_data_clean.do
  
  目的：加载合并后的QLFS原始数据，统一变量名称，清理并加入AI暴露指数。
  
  输入：clean/qlfs_raw_stacked.dta
        raw/AI_Exposure_UK.csv（DfE AI暴露评分）
  输出：clean/qlfs_stacked.dta
  
  作者：Minxing Huang
  项目：EC423 延伸论文 — AI与劳动力市场
  
  更新日志：
    2026.03.13  初版：构建堆叠数据集
    2026.03.16  加入DfE (2023) AI暴露评分（AIOE/LLM），创建高/低暴露分组
    2026.03.17  加入 THISWV
    2026.03.25  重构：先用00_data_merge_raw.do合并原始文件，本脚本只做清理和合并评分
==============================================================================*/

clear all
set more off

* --- 设置路径 ----------------------------------------------------------------
global root "/Users/huangminxing/Documents/EC423_Essay"
global raw  "$root/raw/QLFS"
global clean "$root/clean"

use "$clean/qlfs_raw_stacked.dta", clear

* --- SOC编码过渡说明 ---------------------------------------------------------
* 2019 Q1 – 2020 Q4：原生 SOC 2010 在 SOC10M 变量中
* 2021 Q1 – 2025 Q4：原生 SOC 2020，反向映射至 SC2010M
* 注意：2021 Q1–2022 Q3 期间存在SOC 2020误编码问题，ONS已于2023年7月修正
*       pwt24文件包含修正后的数据，但4位数级别仍有残余噪声
*       通过在职业组层面聚合来缓解此问题
* -----------------------------------------------------------------------------

* === 1. SOC编码处理 ==========================================================

gen soc2010 = .
replace soc2010 = soc10m if soc10m != .
replace soc2010 = sc2010m if soc2010 == . & sc2010m != .

* === 2. 统一学历变量 =========================================================
* 过渡前文件使用 HIQUAL15；过渡后使用 HIQUAL22
* 两者编码方案不同，暂时保留数值，后续如需作为回归控制变量再做映射

gen hiqual = .
replace hiqual = hiqual15
replace hiqual = hiqual22 if hiqual15 == .

* === 3. 重命名核心变量 =======================================================

rename piwt24 income_weight
rename pwt24 weight
rename inecac05 econ_activity
rename thiswv wave
rename gor9d region
rename gorwkr region_work
rename ftptwk work_type
rename jobbeg job_start_date
rename publicr public_sector
rename _year year
rename _qtr qtr

* === 4. 生成年-季度标识符 ====================================================

gen yrqtr = year + (qtr - 1) / 4

* Stata季度日期变量，用于时间序列绘图
gen int date_q = yq(year, qtr)
format date_q %tq

* === 5. 保留所需变量 =========================================================

keep soc2010 soc20m ///
     age sex course hiqual region region_work ///
     work_type emplen manager job_start_date addjob ///
     econ_activity income_weight weight wave ///
     grsswk hourpay hrrate gross99 netwk ///
     sector public_sector ///
     year qtr yrqtr date_q

* === 6. 基本清理 =============================================================

* 将LFS缺失编码（-8 = "无回答", -9 = "不适用"）转为Stata系统缺失值
foreach var of varlist soc2010 age emplen work_type manager sector ///
                       public_sector hiqual {
    capture confirm variable `var'
    if _rc == 0 {
        replace `var' = . if `var' < 0
    }
}

* 清理收入变量
foreach var of varlist grsswk hourpay hrrate gross99 netwk {
    capture confirm variable `var'
    if _rc == 0 {
        replace `var' = . if `var' < 0
    }
}

* === 7. 标注关键变量 =========================================================

label variable soc2010        "SOC 2010 职业编码（统一后）"
label variable age             "受访者年龄"
label variable sex             "性别"
label variable econ_activity   "ILO经济活动状态"
label variable year            "调查年份"
label variable qtr             "季度"
label variable region          "政府办公区域"
label variable hiqual          "最高学历（统一后）"
label variable weight          "个人级别截面权重"
label variable income_weight   "个人收入权重"
label variable yrqtr           "年-季度（连续变量）"
label variable date_q          "Stata季度日期"

* === 8. 创建分析变量 =========================================================

* 年龄组
capture drop age_group
gen age_group = .
replace age_group = 0 if age < 22
replace age_group = 1 if age >= 22 & age <= 25
replace age_group = 2 if age >= 26 & age <= 30
replace age_group = 3 if age >= 31 & age <= 40
replace age_group = 4 if age >= 41 & age <= 64
replace age_group = 5 if age > 64

label define age_group_lbl 0 "<22" 1 "22-25" 2 "26-30" 3 "31-40" 4 "41-64" 5 "65+", replace
label values age_group age_group_lbl
label variable age_group "年龄组"

* 就业指标（基于ILO经济活动分类）
gen employed = (econ_activity == 1) if econ_activity != .
label variable employed "在职（ILO定义）"

* AI后时期指标（ChatGPT于2022年11月发布）
gen post_ai = (year >= 2023) if year != .
label variable post_ai "ChatGPT后时期（2023年起）"

* 2位数SOC 2010用于更宽泛的分组
gen soc2010_2d = floor(soc2010 / 100) if soc2010 != .
label variable soc2010_2d "SOC 2010 二位数大组"

* ==============================================================================
* ===  合并AI暴露评分（DfE 2023）  ============================================
* ==============================================================================
* 数据来源：英国教育部 (2023)《AI对英国就业和培训的影响》附件数据
* 方法论：Felten, Raj & Seamans (2023) AIOE，由NFER/谢菲尔德大学/华威大学
*         通过 O*NET → UK SOC 2010 映射
* 使用LLM评分作为主要度量（与ChatGPT/生成式AI冲击最相关）

di as text "=============================================="
di as text "正在合并AI暴露评分..."
di as text "=============================================="

* --- 准备AIOE数据 ---
preserve

import delimited "$root/raw/AI_Exposure_UK.csv", clear

keep soc allai llm

rename soc soc2010
rename allai aioe_all
rename llm aioe_llm

save "$clean/aioe_scores.dta", replace

restore

* --- 执行合并 ---
merge m:1 soc2010 using "$clean/aioe_scores.dta"

* 检查合并质量
di as text "--- 合并诊断（仅在职人员）---"
tab _merge if employed == 1

* 未匹配的4个SOC编码（1116选举官员、1171武装部队军官、
* 1255废物处理经理、3311士官及其他军衔）仅占在职样本的0.4%
drop if _merge == 2
drop _merge

* --- 标注AI暴露变量 ---
label variable aioe_all "AI职业暴露评分（所有AI应用）"
label variable aioe_llm "AI职业暴露评分（大语言模型）"

* --- 创建暴露分组 ---

* 方法1：中位数分割（以LLM评分为基准，仅在职且有有效SOC的人群）
summarize aioe_llm if employed == 1 & aioe_llm != ., detail
local med = r(p50)
di as text "在职人群LLM暴露评分中位数 = `med'"

gen high_exposure = (aioe_llm >= `med') if aioe_llm != .
label define exposure_lbl 0 "低LLM暴露" 1 "高LLM暴露"
label values high_exposure exposure_lbl
label variable high_exposure "高LLM暴露（中位数分割）"

* 方法2：四分位数分组（用于稳健性检验）
xtile exposure_quartile = aioe_llm if employed == 1, nq(4)
label variable exposure_quartile "LLM暴露四分位（1=最低, 4=最高）"

* --- 快速检查 ---
di as text "--- 年龄组 × 暴露分组 交叉表 ---"
tab age_group high_exposure if employed == 1, row

di as text "--- 暴露四分位分布 ---"
tab exposure_quartile if employed == 1

* === 9. 数据集总结 ===========================================================

di as text "=============================================="
di as text "堆叠数据集总结"
di as text "=============================================="

di as text "总观测数：`=_N'"
tab year qtr, missing
tab age_group if employed == 1, missing

* === 10. 保存最终数据集 ======================================================

order date_q year qtr yrqtr soc2010 soc2010_2d soc20m age age_group sex ///
      econ_activity employed hiqual work_type emplen manager region ///
      region_work sector public_sector weight income_weight wave post_ai ///
      aioe_all aioe_llm high_exposure exposure_quartile

compress
save "$clean/qlfs_stacked.dta", replace

di as text "=============================================="
di as text "已保存：$clean/qlfs_stacked.dta"
di as text "=============================================="

* --- 清理临时文件 ------------------------------------------------------------
capture erase "$clean/aioe_scores.dta"

di as text "数据清理流程完成。"