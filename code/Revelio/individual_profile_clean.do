/*
这个清理代码主要负责清洗 Revelio 数据并且产生一些中间结果，供后续分析使用。


主要更新：
2026-03-26 创建文档
*/

clear all
set more off

* 设置工作目录
global root "/Users/huangminxing/Documents/EC423_Essay"
global raw  "$root/raw/Revelio"
global clean "/Users/huangminxing/Documents/EC423_Essay/clean"

* 导入数据
import delimited "$clean/individual_profile.csv", clear

* 删除所有 2025 年之前未更新简历的人
gen updated_year = year(date(updated_dt, "YMD"))
drop if updated_year < 2025
drop updated_year

* 只保留有 highest_degree 的人
drop if highest_degree == ""

* 丢掉没有性别信息的人
gen gender = .
replace gender = 1 if sex_predicted == "M"
replace gender = 2 if sex_predicted == "F"
drop if gender == .
drop sex_predicted


drop if highest_degree == "Associate" 


* 重新编码学历水平，映射为 1-5 的数值变量
gen degree_level = .
replace degree_level = 1 if highest_degree == "High School"
replace degree_level = 2 if highest_degree == "Bachelor"
replace degree_level = 3 if highest_degree == "Master" | highest_degree == "MBA"
replace degree_level = 4 if highest_degree == "Doctor"


drop if degree_level == .

tab degree_level, missing // 检查学历分布

* 打标签
label define degree_level 1 "High School" 2 "Bachelor" 3 "Master/MBA" 4 "Doctor"
label values degree_level degree_level

drop highest_degree
drop f_prob
drop m_prob
drop user_country

save "/Users/huangminxing/Documents/EC423_Essay/clean/individual_profile_clean", replace