# Offsetting Effects: AI Displacement and Augmentation Within Occupations

**[中文版 README](README.zh-CN.md)**

> MSc Econometrics and Mathematical Economics, LSE
> EC423 Labour Economics — Course Essay, 2025/26

## Abstract

Aggregate-level null results on AI's impact on employment mask compositional shifts within occupations: AI displaces junior workers — whose tasks overlap with AI capabilities — while augmenting senior workers — whose tasks are complementary to AI. These two effects partially offset each other at the occupation level.

## Research Motivation

This essay addresses the research gap left by Hosseini and Lichtinger (2025), who note that understanding how firms and workers adapt through training, task design, or career development "remains an open and important area for further study." The theoretical framework extends Autor and Thompson (2025)'s expertise model to allow for within-occupation heterogeneity.

## Theoretical Framework

Extension of Autor and Thompson (2025):

- Relaxes the within-occupation homogeneity assumption
- Introduces junior/senior task division based on comparative advantage
- Partial equilibrium CES model with two task types (low-expertise *L*, high-expertise *H*)
- AI acts as a perfect substitute for junior labour on task *L*

**Key predictions:**

1. Junior wages decline with AI capability (∂w_J/∂A < 0)
2. Senior wages rise via task complementarity (∂w_S/∂A > 0)
3. Net occupation-level employment effects ≈ 0

## Data

### Primary Dataset: Revelio Labs (via WRDS)

Individual-level occupational panel data sourced from LinkedIn profiles, covering UK workers.

| Table | Granularity | Key Variables |
|-------|------------|---------------|
| **Profile** | One row per person | gender, degree_level, prestige |
| **Education** | Multiple rows per person | degree, field, university |
| **Positions** | Multiple rows per person | onet_code, seniority (1–7), salary, dates |

- **Positions dataset:** 50.7M observations with matched AI exposure scores
- **Seniority:** 7-level classification (1 = intern/entry, 7 = C-suite)
- **O\*NET codes:** 917 distinct occupation codes

### AI Exposure Scores

Source: Eloundou et al. (2024) "GPTs are GPTs"
Measure: `dv_rating_beta` (E1 + 0.5 × E2) at O\*NET-SOC occupation level

## Empirical Strategy

### Event Study (Core Identification)

$$\text{JuniorShare}_{o,t} = \alpha_o + \gamma_t + \sum_{k \neq 2022H1} \beta_k \cdot \text{AIExposure}_o \times \mathbb{1}[t = k] + \varepsilon_{o,t}$$

- Unit of analysis: O\*NET code × half-year cells (N = 14,567)
- Occupation and time fixed effects
- Continuous AI exposure measure
- Clustered standard errors at O\*NET code level
- Weighted by cell size

### Identification

1. **Treatment exogeneity:** AI exposure based on pre-determined O\*NET task descriptions
2. **Common shock absorption:** DiD structure controls for macro trends (rate hikes, tech layoffs)
3. **Pre-trend adjustment:** Occupation-specific linear trends address observed pre-trends
4. **Cluster SE:** At treatment variation level (O\*NET code)

## Key Results

### Diff-in-Diff

| Term | Coefficient | t-stat |
|------|------------|--------|
| Post × High AI | −0.033 | −80.5 |

### Event Study Findings

- **Baseline:** Post-ChatGPT coefficients decline monotonically from +0.007 to −0.111
- **Trend-adjusted:** Post-period effects of −0.030 to −0.047, significant at 1% level
- Pre-period parallel trends restored after controlling for occupation-specific linear trends

### Descriptive Evidence

- Junior share in high-exposure occupations: ~55% → ~30% (post-ChatGPT)
- Absolute junior position starts in high-exposure occupations declined sharply (~250k → ~50k)
- Senior positions remained relatively stable (~120–150k)

## Repository Structure

```
├── code/
│   ├── Revelio/          # Stata do-files for data processing and analysis
│   ├── QLFS/             # Earlier QLFS analysis (superseded)
│   └── combine.py        # Data merging utilities
├── clean/                # Processed datasets (.dta)
├── raw/                  # Raw data and external datasets
│   └── ai_exposure.dta   # Eloundou et al. (2024) exposure scores
├── output/               # Figures and tables
│   ├── event_study_junior_share.png
│   ├── event_study_comparison.png
│   ├── junior_share_monthly.png
│   ├── abs_count_high_exp.png
│   ├── abs_count_low_exp.png
│   └── tables/
├── paper/                # Draft and notes
└── README.zh-CN.md       # 中文版
```

## References

- Autor, D. and Thompson, A. (2025). "Does Automation Replace Expertise?" *JEEA*.
- Eloundou, T., Manning, S., Mishkin, P. and Rock, D. (2024). "GPTs are GPTs." *Science*.
- Hosseini, S. and Lichtinger, A. (2025). "AI and Employment: Firm-Level Evidence."
- Webb, M. (2020). "The Impact of AI on Innovation."
- Felten, E., Raj, M. and Seamans, R. (2021, 2023). "The Occupational Impact of AI."
- Acemoglu, D. and Restrepo, P. (2019, 2020). Task-based framework.
