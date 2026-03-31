*==============================================================================
* 00_data_merge_raw.do
*
* 目的：将28个QLFS季度文件原样合并为单一数据集
*       不做变量重命名或筛选，保留所有原始变量
*       如果某个文件缺少变量，对应观测留空
*
* 输入：raw/QLFS/lfsp_*.dta（28个文件）
* 输出：clean/qlfs_raw_stacked.dta
*==============================================================================

clear all
set more off

global root  "/Users/huangminxing/Documents/EC423_Essay"
global raw   "$root/raw/QLFS"
global clean "$root/clean"

capture mkdir "$clean"

local quarters "jm aj js od"
local years    "19 20 21 22 23 24 25"

* --- 第一个文件：加载并统一变量名为小写 ----------------------------------------

local first = 1
local filenum = 0

foreach yr of local years {
    foreach qtr of local quarters {

        local fname "lfsp_`qtr'`yr'_eul_pwt24"

        capture confirm file "$raw/`fname'.dta"
        if _rc != 0 {
            di as error "文件未找到：`fname'.dta — 跳过"
            continue
        }

        local filenum = `filenum' + 1
        di as text "----------------------------------------------"
        di as text "正在处理第 `filenum' 个文件：`fname'.dta"
        di as text "----------------------------------------------"

        use "$raw/`fname'.dta", clear

        * 统一变量名小写（避免大小写不匹配导致append报错）
        rename *, lower

        * 添加来源标记（暂不gen，append后统一添加）
        if `first' == 1 {
            gen str30 _source_file = "`fname'"
            gen _year = 2000 + real("`yr'")
            if "`qtr'" == "jm" gen _qtr = 1
            if "`qtr'" == "aj" gen _qtr = 2
            if "`qtr'" == "js" gen _qtr = 3
            if "`qtr'" == "od" gen _qtr = 4

            save "$clean/qlfs_raw_stacked.dta", replace
            local first = 0
            di as text "  → 基准文件：`=c(k)' 个变量，`=_N' 条观测"
        }
        else {
            * 先append，再统一添加来源标记
            append using "$clean/qlfs_raw_stacked.dta", force

            * 标记当前文件的观测
            replace _source_file = "`fname'" if _source_file == ""
            replace _year = 2000 + real("`yr'") if _year == .
            if "`qtr'" == "jm" replace _qtr = 1 if _qtr == .
            if "`qtr'" == "aj" replace _qtr = 2 if _qtr == .
            if "`qtr'" == "js" replace _qtr = 3 if _qtr == .
            if "`qtr'" == "od" replace _qtr = 4 if _qtr == .

            save "$clean/qlfs_raw_stacked.dta", replace
            di as text "  → 已追加，`=c(k)' 个变量，累计 `=_N' 条观测"
        }
    }
}

* --- 汇总 --------------------------------------------------------------------

di as text ""
di as text "=============================================="
di as text "合并完成"
di as text "总变量数：`=c(k)'"
di as text "总观测数：`=_N'"
di as text "=============================================="
di as text ""

* 按来源文件统计观测数
tab _source_file, missing

compress
save "$clean/qlfs_raw_stacked.dta", replace

di as text "已保存：$clean/qlfs_raw_stacked.dta"