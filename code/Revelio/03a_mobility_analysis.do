use "/Users/huangminxing/Documents/EC423_Essay/clean/transitions_clean.dta", clear
keep if has_transition

* ============================================
* 按 ai_exposure 分三组：bottom 25%, middle 50%, top 25%
* ============================================
* 先看分位数
quietly summarize ai_exposure, detail
di "p25 = " r(p25) ", p75 = " r(p75) ", median = " r(p50)

gen byte ai_group = .
replace ai_group = 1 if ai_exposure <= r(p25)
replace ai_group = 2 if ai_exposure > r(p25) & ai_exposure <= r(p75)
replace ai_group = 3 if ai_exposure > r(p75) & !missing(ai_exposure)

label define ai_grp 1 "Low (bottom 25%)" 2 "Mid (25-75%)" 3 "High (top 25%)"
label values ai_group ai_grp

* 检查分组平衡
tab ai_group is_junior, col
tab ai_group post, col

* ============================================
* 1. Delta Seniority
* ============================================
di "=== Delta Seniority ==="
table is_junior ai_group post, stat(mean delta_seniority) stat(n delta_seniority) ///
    nformat(%9.3f)

* ============================================
* 2. Delta AI Exposure
* ============================================
di "=== Delta AI Exposure ==="
table is_junior ai_group post, stat(mean delta_ai_exp) stat(n delta_ai_exp) ///
    nformat(%9.4f)

* ============================================
* 3. Occupation Switch Rate
* ============================================
di "=== Occupation Switch Rate ==="
table is_junior ai_group post, stat(mean occ_switch) stat(n occ_switch) ///
    nformat(%9.4f)

* ============================================
* 4. Delta Salary (clean only)
* ============================================
di "=== Delta Salary ==="
table is_junior ai_group post if bad_salary_transition == 0, ///
    stat(mean delta_salary) stat(n delta_salary) nformat(%9.1f)
