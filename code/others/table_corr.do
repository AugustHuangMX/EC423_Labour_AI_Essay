/*
构建 AI Exposure 相关性表格
*/

clear all
set more off

global root "/Users/huangminxing/Documents/EC423_Essay" // 创建根目录路径
global figures "$root/output/figures"
global tables "$root/output/tables"

use "$root/raw/ai_exposure.dta", clear

* 选择三种 AI exposure 变量
keep onet_code dv_rating aioe_felten ai_applicability

* 计算相关系数并输出
pwcorr dv_rating aioe_felten ai_applicability, star(0.05)

* 保存相关系数矩阵到 CSV
matrix C = r(C)
matrix list C

* 创建相关系数表格
clear
set obs 3
gen var = ""
replace var = "Eloundou et al. (2024)" in 1
replace var = "Felten et al. (2021)" in 2
replace var = "Tomlinson et al. (2025)" in 3

gen eloundou = .
gen felten = .
gen tomlinson = .

matrix C = C'
forval i = 1/3 {
    forval j = 1/3 {
        if `i' == 1 replace eloundou = C[`i',`j'] in `j'
        if `i' == 2 replace felten = C[`i',`j'] in `j'
        if `i' == 3 replace tomlinson = C[`i',`j'] in `j'
    }
}

export delimited using "$tables/table_ai_exposure_corr.csv", replace

