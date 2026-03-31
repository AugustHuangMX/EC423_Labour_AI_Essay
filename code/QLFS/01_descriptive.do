/*==============================================================================
  01_descriptive.do

  Purpose: Track quarterly employment shares by age group within Q1 (lowest)
           and Q4 (highest) AI exposure occupation groups.
           Descriptive test of the paper's core prediction.

  Input:   clean/qlfs_stacked.dta
  Output:  Figures
==============================================================================*/

clear all
set more off

global root "/Users/huangminxing/Documents/EC423_Essay"
global clean "$root/clean"
global output "$root/output"
capture mkdir "$output"

use "$clean/qlfs_stacked.dta", clear

* --- Sample restriction -------------------------------------------------------
keep if employed == 1 & age_group != . & exposure_quartile != .

* ============================================================================
* === Part 1: Compute within-group weighted employment shares =================
* ============================================================================

* Only extreme quartiles: Q1 (lowest exposure) and Q4 (highest exposure)
keep if exposure_quartile == 1 | exposure_quartile == 4

* Weighted employment count by quarter x exposure group x age group
collapse (sum) emp_count = weight, by(date_q full_year qtr exposure_quartile age_group)

* Total employment in each quarter x exposure group (denominator)
bysort date_q exposure_quartile: egen total_emp = total(emp_count)

* Employment share within each exposure group
gen emp_share = emp_count / total_emp * 100

label variable emp_share "Employment share within group (%)"
label variable date_q "Quarter"

* --- Labels for figures -------------------------------------------------------
label define eq_lbl 1 "Q1 (Low LLM exposure)" 4 "Q4 (High LLM exposure)"
label values exposure_quartile eq_lbl

* ============================================================================
* === Part 2: Time-series figures =============================================
* ============================================================================

* --- Figure 1: Age 22-25 share in Q4 vs Q1 ------------------------------------
* Key figure: if theory is correct, the 22-25 share in Q4 should decline after 2023

twoway ///
    (connected emp_share date_q if age_group == 1 & exposure_quartile == 4, ///
        mcolor(cranberry) lcolor(cranberry) msymbol(circle) lpattern(solid)) ///
    (connected emp_share date_q if age_group == 1 & exposure_quartile == 1, ///
        mcolor(navy) lcolor(navy) msymbol(triangle) lpattern(dash)) ///
    , ///
    legend(order(1 "High exposure (Q4)" 2 "Low exposure (Q1)") rows(1) position(6)) ///
    title("Employment share of ages 22-25: High vs Low AI exposure") ///
    subtitle("Source: UK LFS 2019-2025, by LLM exposure quartile") ///
    ytitle("Share of employment within exposure group (%)") ///
    xtitle("") ///
    xline(`=yq(2022,4)', lcolor(gs10) lpattern(dash)) ///
    text(8 `=yq(2022,4)' "ChatGPT release", size(vsmall) placement(east)) ///
    ylabel(, angle(0) format(%4.1f)) ///
    scheme(s2color) ///
    name(fig_age2225, replace)

graph export "$output/fig_emp_share_22_25.png", replace width(1200)

* --- Figure 2: All age groups in Q4 (high exposure) ---------------------------
* Shows composition shift within high-exposure occupations

twoway ///
    (connected emp_share date_q if age_group == 1 & exposure_quartile == 4, ///
        mcolor(cranberry) lcolor(cranberry) msymbol(circle) lwidth(medthick)) ///
    (connected emp_share date_q if age_group == 2 & exposure_quartile == 4, ///
        mcolor(orange) lcolor(orange) msymbol(diamond) lpattern(dash)) ///
    (connected emp_share date_q if age_group == 3 & exposure_quartile == 4, ///
        mcolor(forest_green) lcolor(forest_green) msymbol(square) lpattern(shortdash)) ///
    (connected emp_share date_q if age_group == 4 & exposure_quartile == 4, ///
        mcolor(navy) lcolor(navy) msymbol(triangle) lpattern(longdash)) ///
    , ///
    legend(order(1 "Ages 22-25" 2 "Ages 26-30" 3 "Ages 31-40" 4 "Ages 41-64") rows(1) position(6)) ///
    title("Age composition in high AI exposure occupations (Q4)") ///
    subtitle("Source: UK LFS 2019-2025") ///
    ytitle("Share of employment within Q4 (%)") ///
    xtitle("") ///
    xline(`=yq(2022,4)', lcolor(gs10) lpattern(dash)) ///
    text(55 `=yq(2022,4)' "ChatGPT release", size(vsmall) placement(east)) ///
    ylabel(, angle(0) format(%4.1f)) ///
    scheme(s2color) ///
    name(fig_q4_all_ages, replace)

graph export "$output/fig_q4_composition.png", replace width(1200)

* --- Figure 3: All age groups in Q1 (low exposure, control) -------------------
* If prediction is correct, no similar composition shift should appear here

twoway ///
    (connected emp_share date_q if age_group == 1 & exposure_quartile == 1, ///
        mcolor(cranberry) lcolor(cranberry) msymbol(circle) lwidth(medthick)) ///
    (connected emp_share date_q if age_group == 2 & exposure_quartile == 1, ///
        mcolor(orange) lcolor(orange) msymbol(diamond) lpattern(dash)) ///
    (connected emp_share date_q if age_group == 3 & exposure_quartile == 1, ///
        mcolor(forest_green) lcolor(forest_green) msymbol(square) lpattern(shortdash)) ///
    (connected emp_share date_q if age_group == 4 & exposure_quartile == 1, ///
        mcolor(navy) lcolor(navy) msymbol(triangle) lpattern(longdash)) ///
    , ///
    legend(order(1 "Ages 22-25" 2 "Ages 26-30" 3 "Ages 31-40" 4 "Ages 41-64") rows(1) position(6)) ///
    title("Age composition in low AI exposure occupations (Q1)") ///
    subtitle("Source: UK LFS 2019-2025 (control group)") ///
    ytitle("Share of employment within Q1 (%)") ///
    xtitle("") ///
    xline(`=yq(2022,4)', lcolor(gs10) lpattern(dash)) ///
    text(55 `=yq(2022,4)' "ChatGPT release", size(vsmall) placement(east)) ///
    ylabel(, angle(0) format(%4.1f)) ///
    scheme(s2color) ///
    name(fig_q1_all_ages, replace)

graph export "$output/fig_q1_composition.png", replace width(1200)

* --- Print key data points ----------------------------------------------------
di as text "=============================================="
di as text "Key data: Age 22-25 share in Q4"
di as text "=============================================="
list date_q emp_share if age_group == 1 & exposure_quartile == 4, clean

di as text "=============================================="
di as text "Key data: Age 22-25 share in Q1"
di as text "=============================================="
list date_q emp_share if age_group == 1 & exposure_quartile == 1, clean
