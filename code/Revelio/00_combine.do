/*
合并 Revelio Positions UK 2019-2025，由于文件过大，因此采用逐步去重的方式
理论上只需要 run 一次
*/

clear
set more off

local datadir "/Users/huangminxing/Documents/EC423_Essay/raw/Revelio/positions"

* 用第一年作为 base
use "`datadir'/positions_2019.dta", clear
di "2019 加载完成，行数: " _N

* 逐年追加，每次追加后立即去重
forvalues y = 2020/2025 {
    append using "`datadir'/positions_`y'.dta"
    di "append `y' 后行数: " _N
    duplicates drop position_id, force
    di "`y' 去重后行数: " _N
}

* 基本检查
di "最终行数: " _N
distinct user_id
tab seniority, m
count if onet_code == ""

gen start_year = year(startdate)
tab start_year, m

save "/Users/huangminxing/Documents/EC423_Essay/clean/positions_all.dta", replace

