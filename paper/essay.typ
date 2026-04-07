// ============================================================
// LSE Extended Essay Template — Labour Economics (2025/26)
// ============================================================
// Formatting requirements:
//   • Maximum 6,000 words (14–21 double-spaced pages)
//   • Double spaced, minimum 12pt font, numbered pages
//   • Abstract, footnotes, references, appendices excluded
//     from word count
// ============================================================

// ----- Configuration -----
#let candidate-number = "XXXXX"        // Your 5-digit candidate number
#let course-code     = "EC423"         // e.g. EC423
#let essay-title     = "Title Title Title"  // Your essay title
#let essay-format    = "Independent Research"  // or "Structured Research Assignment"
#let word-count      = "XXXX"          // Final word count

// ----- Page setup -----
#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  // Page numbers — not on cover page
  numbering: "1",
  number-align: center + bottom,
)

// ----- Typography -----
#set text(
  font: "New Computer Modern",  // clean serif; alternatives: "Linux Libertine", "Times New Roman"
  size: 12pt,
  lang: "en",
  region: "gb",
)

// Double spacing (1.5em line height ≈ double spacing at 12pt)
#set par(
  leading: 1.5em,
  first-line-indent: 1.5em,
  justify: true,
)

// Remove first-line indent after headings
#show heading: it => {
  it
  par(text(size: 0pt, ""))  // empty par to reset indent
}
#show cite: set text(fill: rgb("#8B0000"))

// ----- Headings -----
#set heading(numbering: "1.1")

#show heading.where(level: 1): it => {
  v(1.5em)
  text(size: 14pt, weight: "bold", it)
  v(0.75em)
}

#show heading.where(level: 2): it => {
  v(1em)
  text(size: 12pt, weight: "bold", it)
  v(0.5em)
}

// ----- Footnotes -----
#set footnote.entry(
  separator: line(length: 30%, stroke: 0.5pt),
  indent: 0em,
  gap: 0.5em,
)

// ----- Figures & tables -----
#set figure(gap: 1em)
#show figure.caption: it => {
  text(size: 10pt, it)
}

// ----- Equations -----
#set math.equation(numbering: "(1)")

// ============================================================
//  COVER PAGE
// ============================================================
#page(numbering: none)[
  #set par(first-line-indent: 0em)
  #v(4fr)
  #align(center)[
    #text(size: 16pt, weight: "bold", essay-title)

    #v(2em)

    #text(size: 12pt)[
      Extended Essay \ 
      #course-code — Labour Economics \
      #v(0.5em)
      Candidate Number: #candidate-number \
      Word Count: #word-count
    ]
  ]
  #v(6fr)
]

// ============================================================
//  ABSTRACT (not counted in word limit)
// ============================================================
#page(numbering: "1")[
  // Reset page counter so first content page = 1
  #counter(page).update(1)

  #align(center)[
    #text(size: 14pt, weight: "bold", "Abstract")
  ]
  #v(1em)

  #set par(first-line-indent: 0em)
  // Write your abstract here (keep it brief, ~150–200 words).
  还没想好怎么写
]

// ============================================================
//  MAIN BODY
// ============================================================


#text(fill: blue)[
  
*Todo*:（按先后优先级）

- General DiD in Empirical Analysis
- Literature Review
- Theoretical Model
- Conclusion
- Discussion]


= Introduction

Since the launch of ChatGPT in autumn 2022, generative AI has undergone rapid development over the past three years. Beyond text generation, AI has achieved notable breakthroughs across a range of creative domains — including code generation, image synthesis, music composition, and video production. The pace of these advances has far exceeded the expectations of most observers, raising pressing questions about the implications for workers in occupations traditionally considered resistant to automation.


Early empirical evidence suggests that these advances are already reshaping labour markets for creative workers. Freelancers on Upwork in AI-exposed occupations experienced a 2 per cent decline in the number of contracts and a 5.2 per cent fall in earnings following the release of major generative AI tools, with image-related workers suffering considerably steeper losses @hui2024short. 

A recent paper by #cite(<pabba2026aicapital>, form:"prose") argues that AI tools should not be treated merely as software, but rather as a form of capital.



// 随便写写
Measuring the impact of AI is hard. Unlike discrete, large-scale shocks such as the COVID-19 pandemic, constructing a credible counterfactual for the impact of AI on the labour market is particularly challenging, precisely because AI adoption is gradual and diffuse rather than sudden @massenkoffmccrory2026labor. 


Another focus about this essay is about unemployment. I want to use the QLFS data in UK to investigate the impact of AI on unemployment, and whether the impact is different for junior and senior workers within occupations.

= Literature Review


= Theoretical Framework

Consider a single occupation producing output $Y$, by two types of tasks:

- Task $L$: Low expertise, including routine jobs, easy be replaced by AI automation.
- Task $H$: High expertise, including context-dependent tasks, management tasks, and other tasks requiring accumulated experience.


The output $Y$ follows a CES aggregation: 

$
Y = [beta y_L ^((sigma-1)/sigma) + (1-beta)y_H^((sigma-1)/(sigma) )]^((sigma)/(sigma-1))
$

where $sigma$ is the within-occupation elasticity of substitution between the two types of tasks, which is distinct from the between-occupation elasticity in #cite(<NBERw33941>, form: "prose"), and $beta$ is the share of low-expertise tasks in the occupation.








= Data and Identification Strategy

The data I used here is the positions dataset provided by Revelio Labs, which contains detailed information on job postings in the UK. For analysis, I used data from 2019 to 2025, which allows me to capture the period before and after the release of ChatGPT tool in late 2022. 

For each position, I observe the predicted salary, the O*NET occupation code, and other basic characteristics. Two additional variables are particularly relevant to this study. The first is an ordinal seniority variable, ranging from 1 to 7, that captures the hierarchical level of each position within an organisational structure. A detailed mapping is provided in @tab:seniority.#footnote[A detailed description of the seniority classification methodology is available at: https://www.data-dictionary.reveliolabs.com/methodology.html\#seniority.] I take this variable at face value throughout the analysis. #cite(<lichtinger_generative_2025>, form: "prose") validate the measure by showing that the distribution of job-title keywords aligns closely with expected seniority distinctions and remains stable both before and after the diffusion of generative AI, confirming that it reliably captures positional hierarchy over time.

// seniority level 的图表
#figure(
  {
    set text(size: 10pt)
  table(
    columns: 3,
    align: (center, left, left),
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header(
      [*Seniority*], [*Level*], [*Examples*],
    ),
    table.hline(stroke: 0.5pt),
    [1], [Entry],            [Accounting Intern, Software Engineer Trainee, Paralegal],
    [2], [Junior],           [Account Receivable Bookkeeper, Junior Software QA Engineer, Legal Adviser],
    [3], [Associate],        [Senior Tax Accountant, Lead Electrical Engineer, Attorney],
    [4], [Manager],          [Account Manager, Superintendent Engineer, Lead Lawyer],
    [5], [Director],         [Chief of Accountants, VP Network Engineering, Head of Legal],
    [6], [Executive],        [Managing Director (Treasury), Director of Engineering (Backend Systems), Attorney (Partner)],
    [7], [Senior Executive], [CFO, COO, CEO],
    table.hline(stroke: 0.8pt),
  )},
  caption: [Revelio Labs seniority classification],

) <tab:seniority>

The second is the position number, which records the chronological order of each position within a given individual's profile, with lower values corresponding to earlier roles. This variable enables the analysis of within-individual career mobility, which I exploit in a later section.

I then merge the AI exposure scores constructed by #cite(<GPTs_are_GPTs>, form: "prose") to the positions dataset via the O*NET occupation code. Based on the merged scores, I classify occupations into three categories: low exposure (below the 25th percentile), medium exposure (25th to 75th percentile), and high exposure (above the 75th percentile).#footnote[The exposure scores are publicly available at: https://github.com/openai/GPTs-are-GPTs.]





== Workers' Mobility 

From the 


#text(fill: blue)[这个部分讨论一下 Identification Strategy 为草稿]


Like the key research question from #cite(<Heckman1979>, form: "prose"), for those people who do not work, we couldn't observe wage. It is therefore necessary to address sample selection bias. In my essay, the intensive margin regression only look at those workers' outcome who successfully transit, but people who really transit isn't necessarily random. Imagine of two junior workers at high AI exposed jobs, one is with high ability one is not. During the post-ChatGPT period, those with better ability would transit to higher seniority jobs, and those weaker would stay or even drop out of the labour market. This would lead to higher $Delta "Seniority"$, it is not because AI helps junior, it is because only "winners" are observed. #footnote[The Heckman Model and the role of the inverse Mills ratio (Hazard ratio) in correcting for sample selection bias were covered in the EC423 Labour Economics lectures (Autumn Topic 1 and Autumn Topic 3), though the lecture didn't take a lot of part in Heckman two-step procedure. I apply the same logic here: the selection equation models entry into the transition sample, and the inverse Mills ratio corrects for non-random selection in the outcome equation. See #cite(<Heckman1979>, form: "prose") for the original derivation.]




= Empirical Analysis 

== Career Mobility 

In this section, I turn to the analysis of career mobility, with particular emphasis on the post-ChatGPT period. The individual-level panel structure of the Revelio Labs data allows me to track career transitions directly. This addresses a limitation explicitly acknowledged by both #cite(<lichtinger_generative_2025>, form: "prose") and #cite(<klein2025generative>, form: "prose"), who identify the analysis of individual career trajectories following AI exposure as a direction for future research.

For each transition, I construct outcome variables capturing the change in seniority level, the log wage change ($Delta ln w$), and an indicator for whether the worker switched O\*NET occupation code. The core specification throughout is a triple-difference model:

$ Y_i = beta_1 "Junior"_i + beta_2 "AIExp"_i + beta_3 "Post"_t + beta_4 "Junior"_i times "AIExp"_i + \ beta_5 "Junior"_i times "Post"_t + beta_6 "AIExp"_i times "Post"_t + beta_7 "Junior"_i times "AIExp"_i times "Post"_t + epsilon_i $



=== Extensive Margin: Who Moves?

@tab:transition reports results from the extensive-margin analysis. Using the full sample of 27.5 million positions (including those without a subsequent transition), I estimate the triple-difference specification with an indicator for whether a transition is observed as the dependent variable. The estimate of $beta_6$ is $-0.373$, indicating that senior workers in high-exposure occupations became substantially less mobile after ChatGPT, consistent with AI augmenting role-specific expertise and strengthening attachment to current positions. The triple-interaction term $beta_7 = 0.228$ is positive and highly significant: relative to senior workers, junior workers in the same high-exposure occupations experienced a considerably smaller decline in transition probability. That is, while all workers in high-AI-exposure occupations became less mobile, this stabilisation was concentrated among senior workers; junior workers remained comparatively more exposed to turnover. The result is robust to excluding positions that began after July 2024 ($beta_7 = 0.229$), ruling out mechanical right-censoring as a driver.

#include "../output/tables/table_extensive_margin.typ"


=== Intensive Margin: Transition Outcomes

Conditional on transitioning, Column (1) of @tab:mobility shows that junior workers leaving high-exposure occupations after ChatGPT gain significantly more seniority in their next position ($beta_7 = 0.124$). However, this estimate is susceptible to positive selection: if AI disproportionately displaces weaker junior workers, those who successfully transition constitute a positively selected subsample, and the observed seniority gain overstates any genuine upskilling effect.

To address this concern, I implement a #cite(<Heckman1979>, form: "prose") two-step correction. The selection equation models the probability of transitioning as a function of the main regressors and a firm-level exclusion restriction: the pre-period separation rate at the individual's company, which plausibly affects whether a worker transitions but not the characteristics of the destination position. The probit is estimated on a 10 per cent random subsample for computational tractability, and the resulting inverse Mills ratio is included in the outcome equation estimated on the full sample.#footnote[The probit is estimated on observations where $"mod"("user_id", 10) = 0$. Coefficients are used to compute the linear index and the Mills ratio for all observations. Results are virtually identical when estimated on alternative subsamples ($"mod" = 1, 2, dots$).]

Column (2) reports the corrected estimates. The inverse Mills ratio is significant ($hat(lambda) = -0.174$), confirming that workers with lower predicted transition probability tend to experience smaller seniority gains conditional on transitioning — that is, positive selection into the transition sample is present. After correction, $beta_7$ declines from 0.124 to 0.061, significant only at the 10 per cent level. This approximately 50 per cent reduction indicates that a substantial share of the observed seniority gain reflects compositional upgrading of the transition pool rather than a genuine treatment effect. Nevertheless, both interpretations reinforce the central thesis. If the effect is genuine, AI facilitates upward mobility for capable junior workers. If it reflects selection, AI filters out weaker junior workers from high-exposure occupations. Either channel implies that within-occupation composition shifts in the direction predicted by the model.

Columns (3) and (4) examine log wage changes upon transition. The triple-interaction term $beta_7$ is essentially zero and statistically insignificant, indicating that junior workers are not differentially penalised in wage terms relative to senior workers. The adjustment mechanism thus operates primarily through the quantity margin — who remains in and who exits the occupation — rather than through differential wage compression.

Columns (5) and (6) examine occupational switching. The triple-interaction term is small and insignificant ($beta_7 = -0.015$, $t = -1.00$ in the baseline). Junior workers do not systematically reallocate toward lower-AI-exposure occupations after ChatGPT. This null result is informative: the post-ChatGPT adjustment in career mobility operates along the seniority dimension rather than through occupational flight. Workers who transition move to positions of comparable AI exposure but at higher seniority — a pattern more consistent with upward filtering within related occupations than with wholesale retreat from AI-exposed work.

#include "../output/tables/table1_mobility_regressions.typ"


= Discussion

#text(fill: blue)[4.7: Discussion 部分仍然是想到哪写到哪，后期需要系统地进行整理和补充]

Notice that research on the impact of AI on labour markets is still in its infancy, and there are many open questions about the mechanisms through which AI affects workers. One important argument is that we still couldn't find a consistent and convincing exposure measure for AI, which is crucial for empirical analysis. The most recent commonly used measurements can't broadly agree with each other on highly exposed occupations, making it hard to draw robust conclusions about the impact of AI on labour markets @gimbel2026labor.


== Why Wage Prediction "Fails"?





= Conclusion



// ============================================================
//  REFERENCES
// ============================================================
#pagebreak()
#bibliography("refs.bib", title: "References", style: "apa")

#set par(
  first-line-indent: 0em,
  hanging-indent: 1.5em,   // hanging indent for bibliography entries
)


// ============================================================
//  APPENDICES (not counted in word limit)
// ============================================================
// Uncomment below if needed:
#pagebreak()
#heading(numbering: none)[Appendix]
#counter(heading).update(0)
#set heading(numbering: "A.1")
// Your appendix content here.

= Validation from QLFS Data

I also use data set from Quarterly Labour Force Survey by UK government. And I am also aware that the dataset itself exists.
