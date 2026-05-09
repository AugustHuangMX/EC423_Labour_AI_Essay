**学生：** Minxing **专业：** MSc Econometrics and Mathematical Economics，LSE **课程：** EC423 Labour Economics **截止日期：** 2026年5月26日（周二）下午4点 **字数限制：** 6,000字（不含摘要、脚注、参考文献、附录） **格式：** 独立研究论文

---

## Essay标题（暂定）

Aggregate Nulls, Compositional Shifts: AI Exposure and the Junior Employment Share in UK Occupations

> 存在后续继续更改的可能，目前

---

## 核心论点（Thesis）

聚合层面 AI 对就业的 null result 掩盖了职业内部的组合变化：AI 替代 junior workers（其任务与 AI 能力重叠），同时增强 senior workers（其任务与 AI 互补）。两种效应在 occupation level 部分抵消。

理论贡献：扩展 Autor and Thompson (2025) 的专业知识框架至职业内部异质性，放松其职业内同质性假设（Assumption 3 的 inseparability component），引入 junior/senior 任务分工的比较优势。Partial equilibrium CES 模型包含三类任务（L: low-expertise, H: high-expertise, G: generic），两类工人（Junior, Senior），AI 作为 junior 劳动在 task L 上的完全替代品。

实证贡献：（待补充）

---

## 研究动机

H&L (Hosseini and Lichtinger 2025) Conclusion 明确留下的研究空白："Understanding whether the observed adjustments persist, and how firms and workers adapt through training, task design, or career development, remains an open and important area for further study." 本文旨在填补此空白。

此外，theoretical 的动机来源于 Autor and Thompson (2025) 的 Expertise。

---


## 论文结构


| Section | 大致字数 | 内容 | 状态 |
|---|---|---|---|
| Introduction | ~500 | Motivation, contribution, preview of results | ✅ Draft 完成（2026-04-10），已更新（2026-04-30） |
| Theoretical Framework | ~800 | A&T extension, CES model, four predictions | ✅ Draft 完成，P2 已更新 |
| Data and Identification Strategy | ~1000 | Revelio 描述, AI exposure 构建, parallel trends 处理, Heckman setup | ✅ 已完成，Heckman 动机段已更新 |
| Empirical Results Part A: Compositional Shift | ~600 | Hiring share DiD + event study | ✅ Draft 完成 |
| Empirical Results Part B: Career Mobility | ~600 | Extensive margin → intensive margin → Heckman → wage | ✅ 已用 reghdfe 重跑，全文已更新 |
| Discussion | ~500 | 文献对话, selection concern, limitations | ✅ 已完成，已更新 |
| Conclusion | ~300 | | ✅ 已完成，已更新 |
| Appendix: Theoretical Model Derivations | N/A (不计字数) | FOC, senior specialisation, comparative statics, net employment | ✅ Draft 完成 |
| Robustness Check| 待定| 使用额外的两个 AI Exposure，更换 seniority 的 threshold| 未完成|
---

## 数据架构

### Positions 数据（主分析数据集）

- **文件路径：** `/Users/huangminxing/Documents/EC423_Essay/clean/positions_all.dta`
- **时间覆盖：** 所有在 2019-01-01 之后仍 active 的 position
- **startdate 缺失：** ~5.5M（10.8%）
- **关键生成变量：**
  - `is_junior`：`seniority <= 2`（占 58.9%）
  - `ym`：`mofd(startdate)`
  - `high_exp`：`ai_exposure >= 0.3658537`（occupation-level median split）；注意 high_exp 占 80.44%（severe imbalance，binary split 不用于主分析）
  - `m1`：Eloundou et al. (2024) `dv_rating_beta`，连续变量
  - `m2`: AI Occupational Exposure (Felten et al. 2021)
  - `m3`: AI Applicability Score (Tomlinson et al. 2025)
  - `post`：`startdate >= 01jan2023`
注：m2,m3 的用处为robustness check，m1 是正式的主回归内容

需要注意的是 `m3` 的时间性。`m3` 基于 2024 年 1–9 月的 Bing Copilot 使用数据，这是你 post-treatment 期间的数据。`m1` 和 `m2` 的外生性论证之所以成立，是因为它们基于 pre-determined 的任务描述或技术能力评估，不受劳动力市场调整的反向影响。`m3` 则不同——2024 年哪些职业的人在用 Copilot，可能本身就是劳动力市场调整的结果。比如，如果某些职业的 junior workers 已经被替代，剩下的 senior workers 可能恰恰更多地使用 AI 工具，这会让 m3 的 applicability score 内生于你研究的 outcome。

因此我们需要在 robustness check 的写作中需要明确 acknowledge 这一点。建议方法：`m1` 和 `m2` 衡量的是 predicted exposure（基于任务特征的事前预测），m3 衡量的是 revealed applicability（基于真实使用的事后观测）。三者一致说明结论不依赖于某一种特定的 AI exposure 构建方式，但 m3 的 post-treatment 性质意味着它的外生性弱于 m1/m2，不宜作为主规范。你目前 m1 为主、m2/m3 为 robustness 的安排是对的。

不过记得他们的相关性是高达 0.79 因此预计不会有特别大的问题。


### Mobility 分析数据集

- **文件：** `transitions_clean.dta`（32.5M obs，12.6M valid transitions）
- **清洗规则：** position_number > 50 (user drop), overlapping dates (user drop, 32.6%), startdate missing (position drop)
- **Post 定义（mobility）：** `transition_date >= 01nov2022`

---

## 已完成的实证结果

### Part A: Compositional Shift

#### Event Study 设定
- **频率：** 半年度（正文图）+ 季度（appendix）
- **Omitted baseline：** 2022H2 = period 10（系数 = 0）
- **时间窗口：** 2018H1–2025H2（16 half-year periods）
- **Unit：** O\*NET × half-year cells
- **Post 定义：** 2023H1 起（following H&L 2025）
- **虚线位置：** 2022H2 和 2023H1 之间

#### Pooled DiD
- `ai_exposure × post` = −0.077, t = −8.37, N = 14,587
- 解读：AI exposure 从 0 到 1 对应 post 期 junior 概率额外下降 7.7pp

#### Pre-trend 处理策略
- 平行趋势大致成立
- Pre 期系数在 −0.023 到 +0.024 之间波动，大部分不显著
- 2022H1 系数 = −0.005 (p = 0.44)，与 baseline 无显著差异
- 正式线性 pre-trend 检验（FHS 2019）：斜率本质为零
- Post 期：−0.064 at 2023H1，−0.103 at 2024H1，−0.115 by 2025H2，全部 1% 显著

#### Compositional Shift 与 KT (2025) 的差异化
- KT 在 firm-level 做 DiD，本文在 occupation-level 做 event study
- KT 没有 event study（identification 相对薄弱）
- 本文 value-add：(a) 更严格的 event study 识别；(b) 为 mobility 分析铺路
- KT 原文说 "low-seniority employment declining by 0.4 percent"（非 5.8%，5.8% 来自新闻稿可能有误）
- 论文中用定性引用而非具体数字引用 KT

#### 图表清单
| 图表 | 位置 | 文件 |
|------|------|------|
| junior_share_monthly | 正文 Figure | `output/figures/junior_share_monthly.png` |
| event_study_baseline | 正文 Figure | `output/figures/event_study_baseline.png` |
| event_study_quarterly | Appendix | `output/figures/event_study_quarterly.png` |
| abs_count_high_exp | Appendix | `output/figures/abs_count_high_exp.png` |
| abs_count_low_exp | Appendix | `output/figures/abs_count_low_exp.png` |
| event_study_comparison | Appendix | `output/figures/event_study_comparison.png` |

### Part B: Career Mobility（✅ 代码已用 reghdfe 重跑，论文已更新 2026-04-30）

> **重要变更记录（2026-04-30）：** 原 mobility 回归使用 pooled OLS（plain `reg`），与论文 specification 中的 α_o + γ_t 不一致。已全部改为 `reghdfe` 加 `absorb(onet_code transition_ym)`（intensive margin）或 `absorb(onet_code start_ym)`（extensive margin）。Probit 加了 `i.onet_num`（onet_code 的 numeric encoding）。以下数字为 FE specification 的结果。

#### 1. Extensive Margin: Transition Probability（符号相对旧版反转）
- `ai_post` = **+0.548*** (SE = 0.028)：senior 在高 AI 职业中 post-ChatGPT **更容易 transition**（市场价值上升，外部需求增加）
- `junior_ai_post` = **−0.660*** (SE = 0.031)：junior 净效应 ≈ −0.11，**更不容易 transition**
- Robustness（排除 2024.7 后 position）：−0.662 (SE = 0.029)
- N = 27,471,965；R² = 0.181
- **新叙事：** senior augmentation 表现为 increased outside options（而非旧版的 reduced mobility）；junior 在高 AI 职业中双重挤压（compositional shift + reduced transition opportunities）

#### 2. Intensive Margin: Seniority Change（Heckman 不再 attenuate）
- Baseline: `junior_ai_post` = **0.122*** (SE = 0.030, t = 4.04)
- Heckman: `junior_ai_post` = **0.125*** (SE = 0.030, t = 4.15)
- IMR: **λ̂ = −0.129*** (SE = 0.014, t = −9.3)
- **关键变化：** 修正后系数基本不变（0.122 → 0.125），说明加了 FE 后 selection bias 被 occupation-level heterogeneity 吸收。Preferred interpretation 从 "both interpretations" 改为 **genuine skill-upgrading**。
- **λ̂ < 0 的正确解读：** negative selection on outcome dimension（transition propensity 高的人 seniority gains 反而小），而非旧版错误的 "positive selection"。
- N = 12,487,780；R² = 0.160（baseline）/ 0.161（Heckman）

#### 3. Intensive Margin: Log Wage Change
- `junior_ai_post` = 0.007 (t = 0.51)：不显著
- `ai_post` = −0.111***：高 AI 职业整体 wage growth 下降
- 控制了 `delta_seniority` 以分离晋升相关的工资变化
- 调整通过 quantity margin 而非 price margin
- Heckman IMR = 0.011*** (t ≈ 3.2)
- N = 10,676,852

#### 4. Occupation Switch
- `junior_ai_post` = −0.008 (t = −0.61)：不显著
- Informative null：排除 "恐慌性转行"
- Heckman IMR = 0.057*** (t ≈ 9.2)
- N = 12,487,780

#### Probit（First Stage）
- N = 2,701,601（10% subsample）
- `firm_sep_rate` = 2.341*** (z = 343.30)：exclusion restriction 极强
- `firm_sep_junior` = −0.200*** (z = −22.09)
- 包含 `i.onet_num`（~913 occupation dummies）
- Murphy-Topel 修正未做（first-stage 样本足够大，estimation error negligible）；已在论文 footnote 中说明

---

## 待完成（Next Steps）

### 高优先级
1. ~~**Compositional Shift subsection 写作**~~：✅ 完成
2. ~~**Mobility subsection 写作**~~：✅ 完成，已用 FE 结果更新
3. ~~**Theoretical Framework（~800 words）**~~：✅ Draft 完成，P2 已更新
4. ~~**Theoretical Model Appendix**~~：✅ Draft 完成
5. ~~**Data and Identification Strategy（~1000 words）**~~：✅ 已完成，Heckman 段已更新
6. ~~**Introduction + Discussion + Conclusion**~~：✅ 已完成，均已更新

### 中优先级
7. ~~**Typst 表格制作**~~：✅ Mobility 的 Table 3（extensive）和 Table 4（intensive）已更新
8. **Appendix 整理**：quarterly event study, abs count 图, trend-adjusted 对比图
9. **字数检查 + 最终校对**

### 低优先级
10. **Robustness checks**（替换 AI exposure index, 不同 seniority cutoff 等）——compositional shift 部分已完成，mobility 部分未完成
11. **Robustness: overlapping positions** — 只 drop pair 而非整个 user（Rule 2 清洗丢 32.6%）

---

## Identification Strategy 要点

1. **Treatment 外生性：** Eloundou et al. 基于 O\*NET 任务描述，pre-determined
2. **Common shock 排除：** DiD 差分掉 common macro trend
3. **Pre-trends 处理：** 无单调 pre-trend（线性检验 γ ≈ 0）；非线性 hump 有 COVID explanation 且在 treatment 前消退
4. **Unanticipated shock：** ChatGPT 发布无预兆，排除 anticipation effects
5. **Selection into transition（Heckman）：** pre-period firm separation rate（+ junior interaction）作 exclusion restriction；修正后系数**不变**（0.122 → 0.125），λ̂ = −0.129 为 negative selection on outcome dimension
6. **Right-censoring：** 排除 2024.7 后 position 结果不变
7. **COVID period：** 保留 2020-2021 在 pre-period，time FE 吸收
8. **Staggered design 不适用：** common shock + continuous intensity
9. **Cluster SE：** O\*NET code level
10. **Baseline choice：** 2022H2（compositional shift）；2022年11月（mobility）
11. **Fixed effects：** Occupation FE + time FE（月度）in all mobility regressions；occupation FE + half-year FE in compositional shift

---

## 理论框架（✅ Draft 完成，2026-04-10；P2 更新 2026-04-30）

### 和 A&T (2025) 的关系
- **保留：** 职业捆绑不同 expertise 水平的任务（Assumption 3 的 bundling component）；三类任务分类（generic, low-expertise/automated, high-expertise）
- **放松：** Inseparability（不再要求每个工人做所有未自动化任务；允许 within-occupation task specialisation）
- **替换：** A&T 的 Cobb-Douglas task aggregation → CES（允许任务之间替代弹性 σ > 0）
- **分析层面：** A&T 是 between-occupation GE；本文是 within-occupation PE

### 模型设定
- **产出：** $Y = [\beta_L y_L^{(\sigma-1)/\sigma} + \beta_H y_H^{(\sigma-1)/\sigma} + \beta_G y_G^{(\sigma-1)/\sigma}]^{\sigma/(\sigma-1)}$
- **三类任务：**
  - $y_L = A \cdot M + a_L \cdot n_J^L$（AI 和 junior 完全替代）
  - $y_H = b_H \cdot n_S$（仅 senior；junior 无法清除 expertise threshold）
  - $y_G = c \cdot n_J^G$（仅 junior；不可自动化。Senior 可做但比较优势决定均衡中不做）
- **Junior 分配约束：** $n_J^L + n_J^G = n_J$
- **供给：** $n_J = \phi_J w_J^\epsilon$，$n_S = \phi_S w_S^\epsilon$（constant-elasticity occupation-level supply）
- **关键参数：** σ（within-occupation task substitution elasticity，区别于 A&T 的 λ）；ε（occupation-level supply elasticity）

### 三个均衡条件
1. **No-arbitrage（C.1）：** $w_J = a_L r / A$（junior wage pinned by AI cost-effectiveness）
2. **Internal allocation（C.2）：** $y_G / y_L = \gamma \equiv (\beta_G c / \beta_L a_L)^\sigma$（常数，不随 A 变化）
3. **Senior MRP（C.3）：** $w_S = p \beta_H (Y/y_H)^{1/\sigma} b_H$（通过 CES 互补性随 A 上升）

### 比较静态（A↑时）
1. $w_J \downarrow$ → $n_J \downarrow$（displacement via elastic supply）
2. $y_L \uparrow$ → $Y \uparrow$ → $(Y/y_H)^{1/\sigma} \uparrow$ → $w_S \uparrow$ → $n_S \uparrow$（augmentation via complementarity）
3. Junior 内部重配置：$n_J^G \uparrow$，$n_J^L \downarrow$（双重挤出）
4. Junior share $s_J \downarrow$；net employment ambiguous

### Predictions vs 实证（已更新 2026-04-30）
| 预测 | 方向 | 实证结果 |
|------|------|---------|
| P1: Junior share decline | $\partial s_J / \partial A < 0$ | ✅ Event study: −0.115 by 2025H2 |
| P2: Senior augmentation | $\partial n_S / \partial A > 0$ | ✅ Extensive margin: ai_post = +0.548（senior 更 mobile，市场价值上升） |
| P3: $w_J$ decline | $\partial w_J / \partial A < 0$ | ❌ 不显著（triple-diff ≈ 0） |
| P4: $w_S$ rise | $\partial w_S / \partial A > 0$ | ❌ 不显著 |
| P5: Net employment ambiguous | sign depends on params | ✅ Aggregate null in literature |

Wage null results 的理论解释：高 ε（供给弹性大）→ quantity adjusts, price doesn't。Revelio salary 为 predicted values 也是 measurement concern。

### Appendix 结构（✅ Draft 完成）
- A.1: FOC 完整推导（四个 FOC → 三个均衡条件）
- A.2: Senior specialisation 证明（$w_S > w_J$ as regularity condition）
- A.3: 比较静态正式推导（四步：junior wage/employment → task outputs → senior augmentation → compositional shift + junior reallocation）
- A.4: Net employment 符号条件
- Corner solution：正文一句话 acknowledge，不展开

---

## 关键文献

| 论文 | 用途 |
|------|------|
| Autor & Thompson (2025) JEEA | 理论基础：expertise framework |
| Eloundou et al. (2024) Science | AI exposure scores（primary measure） |
| Hosseini & Lichtinger (2025) | Empirical motivation + timing identification |
| Brynjolfsson, Chandar & Chen (2025) | 方法论参考：early AI-affected occupations |
| Klein Teeselink (2025) | Junior displacement 的先行证据（UK firm-level） |
| Acemoglu & Restrepo (2018, 2019, 2020) | Task-based framework（canonical task model） |
| Freyaldenhoven, Hansen & Shapiro (2019) AER | Pre-trend testing methodology |
| Webb (2020) | AI exposure（robustness check） |
| Felten, Raj & Seamans (2021, 2023) | AIOE index（robustness check） |
| Tomlinson et al. (2025) | AI Applicability Score（robustness check，注意 post-treatment 时间性） |
| Gimbel, Kendall & Kulsakdinun (2026) | AI exposure 测量共识缺乏 |
| Cortes (2016) JHR | Occupational transition tracking 方法论参考 |
| Heckman (1979) Econometrica | Selection correction methodology |
| Wooldridge (2010) MIT Press | Heckman two-step textbook treatment |
| Massenkoff & McCrory (2026) | AI 劳动力市场影响度量困难 |

---

## 代码文件

| 文件 | 用途 | 状态 |
|------|------|------|
|`00_combine.do`| 将 Revelio Labs 原始文件进行合并| ✅ |
|`01_merge.do`| 将 ai_exposure 的指标合并到 `position_all.dta`里| ✅ |
| `02_compositional_shift.do` | Part A 全部分析 + 图表 | ✅ |
| `03_mobility.do` | Mobility 数据清洗 | ✅ 无需更改 |
| `03a_mobility_analysis.do` | 描述性统计（by ai_group × junior × post）| ✅ 无需更改 |
| `04_mobility_heckman.do` | Mobility 回归 + Heckman | ✅ **已改为 reghdfe**（2026-04-30） |

### 04_mobility_heckman.do 变更记录（2026-04-30）
1. Probit：去掉 `preserve/restore`，改用 `probit_sample` flag；加 `i.onet_num`（occupation FE）；用 `predict xb, xb` 替代手动计算
2. Intensive margin：6 个 `reg` → `reghdfe`，`absorb(onet_code transition_ym)`；`m1` 和 `post` 主效应被 FE 吸收
3. Extensive margin：2 个 `reg` → `reghdfe`，`absorb(onet_code start_ym)`；去掉 `post2` 系列变量，统一用 `post`
4. Table 导出：去掉 `_cons` 行；加 Occupation FE / Month FE 标注行；变量列表去掉 `m1` 和 `post`

---

## 编码规范

- Stata 代码注释用中文
- 偏好简洁直接的回答，只展示需要改动的部分
- 论文用 Typst 编写（New Computer Modern 12pt, 1.5em leading）
- 三段式输出：(1) Typst 代码 (2) 中文直译 (3) 修改日志

---

# 随心写

- Heckman 修正后 seniority 系数不变（0.122 → 0.125），preferred interpretation 是 genuine skill-upgrading，不再需要 hedge "both interpretations"
- λ̂ < 0 的正确解读是 negative selection on outcome dimension（transition propensity 高的人 seniority gains 小），不是 positive selection。旧版论文表述有误，已修正。
- Extensive margin sign flip（旧 ai_post = −0.373 → 新 +0.548）是因为加了 occupation FE 后吸收了 occupation-level confounders。旧 spec 中高 AI 职业本身的 baseline transition rate 差异被混入了 ai_post。新结果更可信。
- Senior 更 mobile 不等于 senior 净流出。模型预测 n_S ↑，extensive margin 测的是 gross transition rate。Gross flows 上升 + net employment 上升完全兼容（poaching demand 增加）。Discussion 已加一段说明。
- Occ switch null result 排除了"恐慌性转行"，frame 为 informative null
- Wage adjustment 可能 lag behind quantity adjustment，Revelio salary 为 predicted values 也是 measurement concern
- Quantity margin vs price margin：调整主要通过谁留下/谁离开，而非差异化工资压缩
- KT (2025) 的 5.8% 来自新闻稿，论文原文是 0.4%，引用时用定性表述
- 时间重叠清洗丢了 32.6% 数据，可做 robustness（只 drop pair 而非整个 user）
- 理论模型中 junior/senior 边界是外生的（由 seniority level 决定）；AI 可能内生改变 expertise threshold 是一个 limitation，可在 Discussion 提及并引用 A&T 的 between-occupation 版本
- 三类任务 vs 两类任务：Generic task channel 解释为什么 junior share 下降但不归零；两类任务版本的 predictions 完全一样但缺少这个 nuance
- Examiner 可能追问：senior 更 mobile 是否与 ∂n_S/∂A > 0 矛盾？回答：extensive margin 测 gross flows 不是 net stocks；poaching demand 上升 + net employment 上升完全兼容。Discussion 已 acknowledge。
- Murphy-Topel 修正未做。辩护：first-stage 2.7M obs，probit 系数估计几乎 exact，generated regressor uncertainty negligible。论文 footnote 已说明。
- Exclusion restriction 实际包含 `firm_sep_rate` 和 `firm_sep_junior`（交互项）。论文已更新说明。
- Salary regression 控制了 `delta_seniority`。论文已更新说明。
- `post` 变量在 extensive margin 中对 has_transition = 0 的 position 用 startdate 定义，对 has_transition = 1 的用 transition_date 定义，存在微妙的不对称。实际影响可忽略，但可作为潜在 limitation。

---

## 论文版本变更日志

### v2（2026-04-30）
- **代码：** `04_mobility_heckman.do` 全部 mobility 回归从 plain `reg` 改为 `reghdfe`，加 occupation + month FE
- **Abstract：** 重写，反映新 extensive margin 方向和 Heckman 结果
- **Introduction：** 更新 predictions preview（P2 从 "reduced mobility" 改为 "augmentation raising market value"）；更新 results preview（"less mobile" → "more mobile"；"positively selected" → "robust to Heckman correction"）
- **Section 2.3 P2：** 从 "Senior stability" 改为 "Senior augmentation"，不预设具体表现形式
- **Section 3.1 Heckman 动机：** 从 "positively selected → upward-biased" 改为 "may be biased"；扩展 exclusion restriction 描述
- **Section 4.2.1 Extensive margin：** 全面重写（sign flip），新叙事为 senior opportunity + junior squeeze
- **Section 4.2.2 Intensive margin：** 全面重写（Heckman 不再 attenuate），新叙事为 skill-upgrading is preferred
- **Discussion：** Heckman 段重写（正确解读 λ̂ < 0）；新增 gross vs net flows 段
- **Conclusion：** 更新（"less mobile" → "more mobile"；"positive selection" → "robust to Heckman correction"）