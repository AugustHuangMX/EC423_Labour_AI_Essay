* ============================================================
* Career Mobility: 数据清洗 + Transition Dataset 构建
* 一次性完成所有清洗，避免重复加载 50M 行数据
* ============================================================

clear all
set more off

* --- Step 0: 只加载必要变量，省内存 ---
use user_id position_number startdate enddate seniority ///
    ai_exposure high_ai salary onet_code rcid weight ///
    using "/Users/huangminxing/Documents/EC423_Essay/clean/positions_all.dta", clear

di "原始数据: " _N " observations"

* --- Step 1: 排序（后续所有 by 操作依赖此排序）---
sort user_id position_number

* --- Step 2: User-level 清洗（一次 flag，一次 drop）---

* 规则1: position_number > 50 的用户
by user_id: gen byte flag1 = (position_number[_N] > 50)

* 规则3+4: seniority 或 ai_exposure 缺失
gen byte _bad = (missing(seniority) | missing(ai_exposure))
by user_id: egen byte flag34 = max(_bad)
drop _bad

* 规则5: enddate < startdate（日期倒挂）
gen byte _bad = (enddate < startdate) if enddate != . & startdate != .
replace _bad = 0 if missing(_bad)
by user_id: egen byte flag5 = max(_bad)
drop _bad

* 规则2: 相邻职位时间重叠（enddate > next_startdate）
by user_id: gen long _next_start = startdate[_n+1]
gen byte _bad = (enddate > _next_start) if enddate != . & _next_start != .
replace _bad = 0 if missing(_bad)
by user_id: egen byte flag2 = max(_bad)
drop _bad _next_start

* 汇总报告
di "--- User-level 清洗报告 ---"
di "规则1 (position_number > 50):"
count if flag1
di "规则2 (时间重叠):"
count if flag2
di "规则3+4 (seniority/ai_exposure 缺失):"
count if flag34
di "规则5 (enddate < startdate):"
count if flag5

* 执行 drop
gen byte drop_user = (flag1 | flag2 | flag34 | flag5)
di "总计需 drop 的 observations:"
count if drop_user
drop if drop_user
drop flag1 flag2 flag34 flag5 drop_user

di "User-level 清洗后: " _N " observations"

* --- Step 3: Position-level 清洗 ---

* 规则6: startdate 缺失且非第一个 position → drop 该条
sort user_id position_number
by user_id: gen byte _is_first = (_n == 1)
gen byte drop_pos = (missing(startdate) & _is_first == 0)
di "规则6 (非首位 position startdate 缺失):"
count if drop_pos
drop if drop_pos
drop _is_first drop_pos

di "Position-level 清洗后: " _N " observations"

* --- Step 4: 重新排序，构建 transition 变量 ---
sort user_id position_number

* 生成 junior 标记
gen byte is_junior = (seniority <= 2)

* 下一个职位的特征
by user_id: gen double next_seniority = seniority[_n+1]
by user_id: gen float next_ai_exp = ai_exposure[_n+1]
by user_id: gen long next_startdate = startdate[_n+1]
by user_id: gen next_onet = onet_code[_n+1]
by user_id: gen byte next_high_ai = high_ai[_n+1]
by user_id: gen double next_salary = salary[_n+1]

* Transition outcome 变量
gen delta_seniority = next_seniority - seniority
gen delta_ai_exp = next_ai_exp - ai_exposure
gen occ_switch = (next_onet != onet_code) if next_onet != ""
gen delta_salary = next_salary - salary
*log salary 变化
gen log_salary = ln(salary) if salary > 0
gen log_next_salary = ln(next_salary) if next_salary > 0
gen delta_log_salary = log_next_salary - log_salary

* Transition timing（用 enddate 优先，缺失则用 next_startdate）
gen long transition_date = enddate
replace transition_date = next_startdate if missing(transition_date)
format transition_date %td
gen transition_ym = mofd(transition_date)
format transition_ym %tm

* Post-ChatGPT 标记
gen byte post = (transition_date >= td(01nov2022)) if !missing(transition_date)

* 标记有效 transition（有下一个职位）
gen byte has_transition = !missing(next_seniority)

* --- Step 5: 时间窗口筛选 ---
* 只保留 transition 发生在 2019-2025 的观测
* 注意：没有 transition 的最后一条 position 也保留（可能用于 tenure 分析）
gen byte in_window = (transition_date >= td(01jan2019) & transition_date <= td(31dec2025)) ///
    if has_transition
drop if has_transition & !in_window
drop in_window

di "时间窗口筛选后: " _N " observations"

* --- Step 6: Salary outlier 标记 ---
* 在清洗后的数据上计算分位数
quietly summarize salary, detail
local p5 = r(p5)
local p99 = r(p99)
di "Salary trimming: bottom 5% = " `p5' ", top 1% = " `p99'

* 标记 origin 或 destination salary 异常的 transition
gen byte salary_outlier = (salary < `p5' | salary > `p99') if !missing(salary)
replace salary_outlier = 1 if missing(salary)
gen byte next_sal_outlier = (next_salary < `p5' | next_salary > `p99') if !missing(next_salary)
replace next_sal_outlier = 1 if missing(next_salary)

gen byte bad_salary_transition = (salary_outlier | next_sal_outlier) if has_transition
di "Salary outlier transitions:"
count if bad_salary_transition == 1

* 不 drop，只标记——分析时可以 exclude
* 因为 drop 会打断 position 序列

* --- Step 7: 保存 ---
compress
save "/Users/huangminxing/Documents/EC423_Essay/clean/transitions_clean.dta", replace

di "最终数据: " _N " observations"
di "其中有效 transition: "
count if has_transition
di "有效且 salary 无异常的 transition: "
count if has_transition & bad_salary_transition == 0
