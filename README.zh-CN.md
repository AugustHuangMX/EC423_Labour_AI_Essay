# 对冲效应：职业内部的 AI 替代与增强

**[English README](README.md)**

> LSE 计量与数理经济学硕士
> EC423 劳动经济学 — 课程论文, 2025/26

## 摘要

聚合层面 AI 对就业的 null result 掩盖了职业内部的组合变化：AI 替代初级员工（其任务与 AI 能力重叠），同时增强高级员工（其任务与 AI 互补）。两种效应在职业层面部分抵消。

## 研究动机

本文填补 Hosseini and Lichtinger (2025) 留下的研究空白——他们指出理解企业与员工如何通过培训、任务设计或职业发展适应 AI "仍是一个开放且重要的研究领域"。理论框架扩展 Autor and Thompson (2025) 的专业知识模型至职业内部异质性。

## 理论框架

扩展 Autor and Thompson (2025)：

- 放松职业内同质性假设
- 引入基于比较优势的初级/高级任务分工
- 局部均衡 CES 模型，含两类任务（低专业度 L，高专业度 H）
- AI 作为初级劳动力在任务 L 上的完全替代品

**核心预测：**

1. 初级工资随 AI 能力下降 (∂w_J/∂A < 0)
2. 高级工资因任务互补性上升 (∂w_S/∂A > 0)
3. 职业层面净就业效应 ≈ 0

## 数据

### 主要数据集：Revelio Labs（通过 WRDS 获取）

源自 LinkedIn 个人档案的个体级职业面板数据，覆盖英国劳动力。

| 表 | 粒度 | 核心变量 |
|----|------|---------|
| **Profile** | 一人一行 | gender, degree_level, prestige |
| **Education** | 一人多行 | degree, field, university |
| **Positions** | 一人多行 | onet_code, seniority (1–7), salary, 日期 |

- **Positions 数据集：** 5,070 万条观测，已匹配 AI exposure 分数
- **Seniority：** 7 级分类（1 = 实习/入门，7 = C-suite）
- **O\*NET 代码：** 917 个不同职业代码

### AI Exposure 分数

来源：Eloundou et al. (2024) "GPTs are GPTs"
指标：O\*NET-SOC 职业层面的 `dv_rating_beta`（E1 + 0.5 × E2）

## 实证策略

### 事件研究法（核心识别）

$$\text{JuniorShare}_{o,t} = \alpha_o + \gamma_t + \sum_{k \neq 2022H1} \beta_k \cdot \text{AIExposure}_o \times \mathbb{1}[t = k] + \varepsilon_{o,t}$$

- 分析单元：O\*NET 代码 × 半年单元格（N = 14,567）
- 职业和时间固定效应
- 连续型 AI exposure 度量
- 聚类标准误（O\*NET 代码层面）
- 按单元格规模加权

### 识别假设

1. **处理外生性：** AI exposure 基于预先确定的 O\*NET 任务描述
2. **共同冲击吸收：** DiD 结构控制宏观趋势（加息周期、科技裁员）
3. **事前趋势调整：** 职业特定线性趋势处理观测到的事前趋势
4. **聚类标准误：** 在处理变异层面（O\*NET 代码）

## 主要结果

### 双重差分

| 项 | 系数 | t 值 |
|----|------|------|
| Post × High AI | −0.033 | −80.5 |

### 事件研究发现

- **基准：** Post-ChatGPT 系数从 +0.007 单调下降至 −0.111
- **趋势调整后：** Post-period 效应为 −0.030 至 −0.047，在 1% 水平显著
- 控制职业特定线性趋势后，事前趋势恢复平行

### 描述性证据

- 高 exposure 职业初级占比：~55% → ~30%（post-ChatGPT）
- 高 exposure 职业初级岗位绝对数量大幅下降（~250k → ~50k）
- 高级岗位相对稳定（~120–150k）

## 仓库结构

```
├── code/
│   ├── Revelio/          # Stata do-files：数据处理与分析
│   ├── QLFS/             # 早期 QLFS 分析（已弃用）
│   └── combine.py        # 数据合并工具
├── clean/                # 处理后数据集 (.dta)
├── raw/                  # 原始数据与外部数据集
│   └── ai_exposure.dta   # Eloundou et al. (2024) exposure 分数
├── output/               # 图表输出
│   ├── event_study_junior_share.png
│   ├── event_study_comparison.png
│   ├── junior_share_monthly.png
│   ├── abs_count_high_exp.png
│   ├── abs_count_low_exp.png
│   └── tables/
├── paper/                # 论文草稿与笔记
└── README.md             # English version
```

## 参考文献

- Autor, D. and Thompson, A. (2025). "Does Automation Replace Expertise?" *JEEA*.
- Eloundou, T., Manning, S., Mishkin, P. and Rock, D. (2024). "GPTs are GPTs." *Science*.
- Hosseini, S. and Lichtinger, A. (2025). "AI and Employment: Firm-Level Evidence."
- Webb, M. (2020). "The Impact of AI on Innovation."
- Felten, E., Raj, M. and Seamans, R. (2021, 2023). "The Occupational Impact of AI."
- Acemoglu, D. and Restrepo, P. (2019, 2020). Task-based framework.
