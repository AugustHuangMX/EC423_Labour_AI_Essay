* ============================================================
* 快速探索：Position starts & separations by seniority × time
* ============================================================

use "/Users/huangminxing/Documents/EC423_Essay/clean/positions_all.dta", clear

* 生成年季度变量
gen start_yq = qofd(startdate)
format start_yq %tq
gen end_yq = qofd(enddate)
format end_yq %tq

* ---- 图1: 新职位开始数 by seniority × 季度 ----
* 限定 2019Q1 - 2024Q4（2025 年数据不完整）
preserve
    keep if start_yq >= tq(2019q1) & start_yq <= tq(2024q4)

    * 把 seniority 分为 junior (1-2) 和 senior (3+)
    gen senior = (seniority >= 3)

    * 按季度 × junior/senior 计数
    collapse (count) n_starts = position_id, by(start_yq senior)

    * 画图
    twoway (line n_starts start_yq if senior == 0, lcolor(cranberry) lwidth(medthick)) ///
           (line n_starts start_yq if senior == 1, lcolor(navy) lwidth(medthick)), ///
           xline(`=tq(2022q4)', lcolor(gs8) lpattern(dash)) ///
           legend(order(1 "Junior (seniority 1-2)" 2 "Senior (seniority 3+)")) ///
           title("New Position Starts by Seniority, UK") ///
           subtitle("Vertical line = ChatGPT launch (2022 Q4)") ///
           ytitle("Number of position starts") xtitle("") ///
           scheme(s2color)
    graph export "/Users/huangminxing/Documents/EC423_Essay/output/fig_starts_by_seniority.png", replace
restore

* ---- 图2: 同上但用比例（junior share of starts） ----
preserve
    keep if start_yq >= tq(2019q1) & start_yq <= tq(2024q4)
    gen senior = (seniority >= 3)
    collapse (count) n = position_id, by(start_yq senior)
    reshape wide n, i(start_yq) j(senior)
    gen junior_share = n0 / (n0 + n1)

    twoway (line junior_share start_yq, lcolor(cranberry) lwidth(medthick)), ///
           xline(`=tq(2022q4)', lcolor(gs8) lpattern(dash)) ///
           title("Junior Share of New Position Starts, UK") ///
           subtitle("Vertical line = ChatGPT launch (2022 Q4)") ///
           ytitle("Share of starts at seniority 1-2") xtitle("") ///
           ylabel(, format(%4.2f)) ///
           scheme(s2color)
    graph export "/Users/huangminxing/Documents/EC423_Essay/output/fig_junior_share_starts.png", replace
restore

* ---- 图3: Separations by seniority × 季度 ----
preserve
    keep if end_yq >= tq(2019q1) & end_yq <= tq(2024q4)
    gen senior = (seniority >= 3)
    collapse (count) n_ends = position_id, by(end_yq senior)

    twoway (line n_ends end_yq if senior == 0, lcolor(cranberry) lwidth(medthick)) ///
           (line n_ends end_yq if senior == 1, lcolor(navy) lwidth(medthick)), ///
           xline(`=tq(2022q4)', lcolor(gs8) lpattern(dash)) ///
           legend(order(1 "Junior (seniority 1-2)" 2 "Senior (seniority 3+)")) ///
           title("Position Separations by Seniority, UK") ///
           subtitle("Vertical line = ChatGPT launch (2022 Q4)") ///
           ytitle("Number of separations") xtitle("") ///
           scheme(s2color)
    graph export "/Users/huangminxing/Documents/EC423_Essay/output/fig_separations_by_seniority.png", replace
restore