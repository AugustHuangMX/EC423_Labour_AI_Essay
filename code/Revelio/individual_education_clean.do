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
use "$raw/individual/education_1.dta"


