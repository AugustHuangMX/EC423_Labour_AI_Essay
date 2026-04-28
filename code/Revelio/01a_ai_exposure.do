/*
主要目的：额外生成两个 ai_exposure index 用来做 robustness check：
*/

clear all
set more off


* ============================================================
* 将 Yale Budget Lab AI exposure 数据 merge 到 Revelio 数据
* ============================================================

* --- 第一步：准备 Yale 数据 ---
* 假设你已经把 Yale 数据存为 yale_ai_scores.csv
import delimited "/Users/huangminxing/Documents/EC423_Essay/raw/yale_ai_scores.csv", clear varnames(1)


rename soc2018 soc_2018
rename aiapplicabilityscore ai_applicability   // Tomlinson et al. (2025)
label variable ai_applicability "AI Applicability Score (Tomlinson et al. 2025)"
rename aioe aioe_felten                         // Felten et al. (2021)
label variable aioe_felten "AI Occupational Exposure (Felten et al. 2021)"
rename humanratingbeta human_rating_beta        // Eloundou et al. (2024) 人类标注版
label variable human_rating_beta "Human Rating Beta (Eloundou et al. 2024)"

* 确保 SOC code 是 string 格式，去掉可能的空格
tostring soc_2018, replace
replace soc_2018 = strtrim(soc_2018)

* 保留你需要的三个 robustness 变量
keep soc_2018 ai_applicability aioe_felten human_rating_beta

* 保存为 dta
save "/Users/huangminxing/Documents/EC423_Essay/raw/yale_scores_clean.dta", replace


* --- 第二步：在 Revelio 数据中生成 SOC code ---
use "/Users/huangminxing/Documents/EC423_Essay/raw/ai_exposure.dta", clear

rename ai_exposure dv_rating
label variable dv_rating "GPTs are GPTs" //来源于文献 GPTs are GPTs

* 从 O*NET code 提取 SOC code（取小数点前的部分）
* onet_code 格式: "11-1011.00"，取前7个字符（含连字符）
gen soc_from_onet = substr(onet_code, 1, 7)

* --- 第三步：直接 merge（假设大部分 SOC 2010 = SOC 2018）---
* 先用 soc_from_onet 直接匹配 Yale 的 soc_2018
rename soc_from_onet soc_2018
merge m:1 soc_2018 using "/Users/huangminxing/Documents/EC423_Essay/raw/yale_scores_clean.dta", keep(master match) gen(_merge_yale)

* 看看 match rate
tab _merge_yale
* 预期：大部分能 match，因为多数 SOC code 在 2010→2018 之间没变

* --- 第四步：处理 unmatched（如果需要）---
* 如果 unmatched 数量很少（<10%），可以直接接受
* 如果较多，需要用 BLS 的 SOC 2010→2018 crosswalk 处理：
* 下载地址: https://www.bls.gov/soc/2018/home.htm
* 文件: "2010 SOC to 2018 SOC Crosswalk"

* 对于 unmatched 的观测：
* 1) 把 soc_2018（实际是 SOC 2010 code）通过 crosswalk 映射到真正的 SOC 2018
* 2) 再 merge 一次
* 这里先看看直接 merge 的效果再决定是否需要这一步

* --- 第五步：检查结果 ---
* 查看新变量的覆盖率
count if !missing(ai_applicability)
count if !missing(aioe_felten)


drop if _merge_yale == 1 // 只保留 merge 成功的观测（即在 Revelio 数据中有对应 SOC code 的行）
drop _merge_yale


* 查看与你现有 ai_exposure (dv_rating) 的相关性
pwcorr dv_rating ai_applicability aioe_felten human_rating_beta



* 覆盖原来的文件
save "/Users/huangminxing/Documents/EC423_Essay/raw/ai_exposure.dta", replace

