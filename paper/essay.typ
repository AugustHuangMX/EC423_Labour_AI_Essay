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
#let essay-title     = "Aggregate Nulls, Compositional Shifts: AI Exposure and the Junior Employment Share in UK Occupations"  // Your essay title
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
#show ref: set text(fill: rgb("#8B0000"))

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
  #v(2fr)
  #align(center)[
    #text(size: 16pt, weight: "bold", essay-title)

    #v(1.5em)

    #text(size: 12pt)[
      Extended Essay \
      #course-code — Labour Economics \
      #v(0.5em)
      Candidate Number: #candidate-number \
      Word Count: #word-count
    ]
  ]
  #v(2fr)

  // ----- Abstract -----
  #line(length: 100%, stroke: 0.5pt)
  #v(0.5em)
  #align(center)[
    #text(size: 14pt, weight: "bold", "Abstract")
  ]
  #v(0.5em)

_Aggregate studies of AI's labour market effects consistently report small or null employment impacts at the occupation level. I argue that these results mask offsetting compositional shifts within occupations: AI displaces junior workers whose tasks overlap with AI capabilities while augmenting senior workers whose expertise-intensive tasks are complementary. I formalise this mechanism by extending the expertise framework of Autor and Thompson (2025) to permit within-occupation task specialisation in a partial-equilibrium CES model. Using individual-level UK position data from Revelio Labs matched with LLM exposure scores, I exploit the unanticipated release of ChatGPT in November 2022 as a natural experiment. Occupations with higher AI exposure experience a monotonically increasing decline in the junior hiring share, reaching 11.5 percentage points by 2025. Senior workers in exposed occupations become substantially more mobile, consistent with augmentation raising their market value, while junior workers experience reduced transition opportunities. Conditional on transitioning, juniors in exposed occupations achieve larger seniority gains — an effect robust to Heckman correction, suggesting genuine skill-upgrading._

  #v(1fr)
]

// Reset page counter so next page = 1
#counter(page).update(1)

// ============================================================
//  MAIN BODY
// ============================================================


//
// 
// 
// 1. Introduction
// 
// 
// 

= Introduction

Since the launch of ChatGPT in autumn 2022, generative AI has undergone rapid development over the past three years. Beyond text generation, AI has achieved notable breakthroughs across a range of creative domains — including code generation, image synthesis, music composition, and video production. The pace of these advances has far exceeded the expectations of most observers, raising pressing questions about how would AI eventually affect the labour market generally.

The task of the framework of #cite(<Acemoglu2019automation>, form: "prose") predicts that the automation could create new jobs while simultaneously displacing current tasks. A central implication is that the net effect on aggregate employment is theoretically ambiguous, depending on the relative strength of these competing forces.  Earlier waves of computerisation did produce measurable structural change: #cite(<autor2013dorn>, form: "prose") document significant occupational polarization in the United States as routine-cognitive and routine-manual tasks were automated, hollowing out middle-skill employment while expanding both tails of the skill distribution. One might therefore expect the strong diffusion of large language models and other generative AI systems since late 2022 to generate similarly visible labour market disruption. But the results of those rapidly increasing literatures analyzing the growing of the generative AI systems are strikingly muted: studies examining occupation- or industry-level employment find effects that are small, statistically insignificant, or both #cite(<acemogluArtificialIntelligenceJobs2022>). This pattern appears puzzling given the breadth of tasks that generative AI can now perform. #cite(<GPTs_are_GPTs>, form: "prose") estimate that roughly 80 percent of the US workforce holds occupations in which at least 10 percent of tasks are exposed to large language models, yet the expected employment disruption has not materialized at conventional levels of aggregation. There are, however, early indications that the apparent absence of effects may itself be an artefact of aggregation. #cite(<lichtinger_generative_2025>, form: "prose"), using US résumé and job posting data, find that generative AI disproportionately affects workers by seniority level, a pattern they term _seniority-biased technological change_. Their findings suggest that the locus of AI's labour market impact lies not between occupations but _within_ them---a possibility that aggregate studies are ill-equipped to detect, which is also the biggest source of this essay's motivation.

I argue that these aggregate null results are not evidence of absence, but rather reflect offsetting compositional shifts within occupations. The central thesis of this essay is that AI displaces junior workers, whose task portfolios overlap heavily with the capabilities of current AI systems, while simultaneously augmenting senior workers, whose expertise-intensive tasks are complementary to AI. Because both groups are classified under the same occupation codes, the displacement of juniors and the entrenchment of seniors partially cancel when measured at the occupation level, producing the observed near-zero aggregate effects. This prediction aligns with a growing body of anecdotal and empirical evidence that firms have sharply curtailed entry-level hiring while increasing demand for — and compensation of — experienced workers #cite(<Canaries_in_the_Coal_Mine>).

I extend the expertise framework of #cite(<NBERw33941>, form: "prose") by relaxing their assumption of within-occupation worker homogeneity. In the resulting partial-equilibrium CES model, junior and senior workers possess comparative advantage in different task types, and AI enters as a factor input that substitutes for junior labour in low-expertise tasks while complementing senior labour through the CES production structure. The model yields four testable predictions: 1. a declining junior employment share in exposed occupations; 2. augmentation of senior workers manifested as increased outside options; 3. a near-zero net effect at the occupation level; 4. adjustment operating through the quantity margin rather than the wage margin.


Measuring the impact of AI is hard. Unlike discrete, large-scale shocks such as the COVID-19 pandemic, constructing a credible counterfactual for the impact of AI on the labour market is particularly challenging, precisely because AI adoption is gradual and diffuse rather than sudden @massenkoffmccrory2026labor. I test these predictions using an individual-level panel of UK workers constructed from Revelio Labs, matched with the AI occupational exposure scores of #cite(<GPTs_are_GPTs>, form: "prose"). This dataset allows me to track workers' career trajectories, seniority transitions, occupation switches, and wage changes before and after the release of ChatGPT in November 2022, exploiting cross-occupation variation in AI exposure intensity. I document a significant decline in the junior share of positions within highly exposed occupations following the AI shock, consistent with displacement. Conditional on remaining employed, junior workers in exposed occupations experience larger seniority gains --- an effect robust to Heckman selection correction, suggesting genuine skill-upgrading. Senior workers in exposed occupations become substantially more mobile, consistent with augmentation raising their market value and expanding outside options. Notably, I find no differential wage effect for junior workers and no evidence of occupation switching in response to AI exposure, indicating that adjustment operates through quantities rather than prices. These findings fill an empirical gap explicitly identified by #cite(<Canaries_in_the_Coal_Mine>, form: "prose") and #cite(<klein2025generative>, form: "prose"), who call for individual-level trajectory analysis to complement their aggregate and firm-level results.

The remainder of this essay proceeds as follows. Section 2 develops the theoretical framework. Section 3 describes the data and identification strategy. Sections 4 presents the empirical results on compositional shifts and career mobility. Section 5 discusses limitations and situates the findings within the broader literature. Section 6 concludes.







= Theoretical Framework

#cite(<NBERw33941>, form: "prose") introduce an "expertise" framework which argue that the effect of the task automation depends not only on the quantity of tasks displaced, but also on the _expertise level_ of those tasks relative to the remaining "task bundle". When the automation replace the _inexpert_ task, the expertise requirement would rise, leading the wage goes up, and the employment would also falls due to fewer workers clear the higher threshold. When the automation replaces the _expert_ tasks, the outcome reverses. This "expertise bifurcation" resolves the longstanding puzzle of why routine task-intensive occupations have experienced declining employment but not uniformly declining wages. 


Central to their framework is Assumption 3 (occupational task bundling): _each worker in an occupation must perform _all_ of its non-automated tasks, and conditional on meeting the expertise threshold, all workers are equally productive. This inseparability property is well suited to their between-occupation analysis, where the relevant variation lies across occupations with differing task compositions._ However, it rules out within-occupation heterogeneity — precisely the margin this essay wants to investigates.

In the following section. I keep the core insight of #cite(<NBERw33941>, form: "prose") that occupations bundle tasks of varying expertise levels, but relax the inseparability requirement. What I do is that I introduce within-occupation task specialization: junior and senior workers allocate effort disproportionately to tasks matching their comparative advantage. This modification preserves the bundling structure while permitting the within-occupation compositional shifts documented in the subsequent empirical analysis. It is also reasonable because from the data I use, I have the seniority variable which allows me to distinguish different workers in the same occupation or same company/firm. 

== Model Setup

Consider a single occupation in partial equilibrium. Output $Y$ is produced by combining three task types via CES aggregation:

$ Y = lr([ beta_L y_L^((sigma - 1) / sigma) + beta_H y_H^((sigma - 1) / sigma) + beta_G y_G^((sigma - 1) / sigma) ])^(sigma / (sigma - 1)) $ <eq-ces>

where $sigma > 0$ is the within-occupation task substitution elasticity and $beta_L, beta_H, beta_G > 0$ are task share parameters summing to unity. For normalization, we let $beta_L + beta_H + beta_G = 1$. The parameter $sigma$ governs how readily the occupation substitutes between task types; it is conceptually distinct from the between-occupation elasticity $lambda$ in #cite(<NBERw33941>, form: "prose").

Following #cite(<NBERw33941>, form: "prose"), tasks fall into three categories:

- Task $L$: low-expertise activities, including routine operations that are readily automatable by AI.
- Task $H$: high-expertise activities, including context-dependent judgement, managerial decision-making, and other functions requiring accumulated experience.
- Task $G$: generic tasks that are common across occupations and performed by all worker types regardless of seniority.

The inclusion of a generic task follows the framework of #cite(<NBERw33941>, form: "prose"), and is motivated by a distinctive feature of the current AI wave: unlike the industrial automation of the twentieth century, which primarily displaced manual and blue-collar labour, generative AI disproportionately affects white-collar occupations — precisely those traditionally regarded as requiring substantial investment in education #cite(<webbImpactArtificialIntelligence>). The impact of AI on occupational task structures thus operates in a top-down manner, penetrating first into the cognitive and professional tasks that define high-skill roles.



Each task type is produced as follows:

$ y_L = A dot.c K + a_L dot.c n_J^L, quad y_H = b_H dot.c n_S, quad y_G = c dot.c n_J^G $ <eq-tasks>

In task $L$, AI capital $K$ (rented at rate $r$) and junior labour $n_J^L$ are perfect substitutes, with $A$ denoting AI capability. Task $H$ requires senior workers exclusively: the judgement-intensive nature of these tasks imposes an expertise threshold that junior workers cannot clear, consistent with hierarchical expertise in #cite(<NBERw33941>, form: "prose"). Task $G$ is performed by *only* junior workers; while senior workers could in principle perform generic tasks, comparative advantage ensures they specialize entirely in task $H$ in equilibrium.#footnote[This requires $w_S > w_J$ in equilibrium, which holds under the maintained assumptions. See @A2 for verification.]

Junior workers allocate their labour between tasks $L$ and $G$ subject to $n_J^L + n_J^G = n_J$. At the occupation level, labour supply responds to wages with constant elasticity:

$ n_J = phi_J w_J^epsilon, quad n_S = phi_S w_S^epsilon $ <eq-supply>

where $epsilon > 0$ captures workers' ability to enter or exit the occupation in response to wage changes.

== Equilibrium and Comparative Statics

The competitive firm's cost minimization yields three equilibrium conditions. Full derivations are provided in @A3:comparative.

_No-arbitrage in task $L$._ Since AI and junior labour are perfect substitutes, the firm employs both only when their unit costs are equalized:

$ w_J = frac(a_L dot.c r, A) $ <eq-noarb>

Junior wages are pinned entirely by AI's cost-effectiveness. As AI capability $A$ rises, $w_J$ falls — regardless of conditions in tasks $H$ or $G$.

_Internal allocation of junior labour._ Equalizing the marginal revenue product of junior labour across tasks $L$ and $G$ yields a constant task output ratio $y_G slash y_L = gamma$, where $gamma equiv (beta_G c slash beta_L a_L)^sigma$ is a structural parameter independent of $A$. Although AI transforms the production of task $L$ internally, the ratio of generic to low-expertise output is invariant to AI capability because both tasks share the same marginal factor at wage $w_J$.

_Senior augmentation via complementarity._ Senior wages satisfy:

$ w_S = p dot.c beta_H lr((frac(Y, y_H)))^(1 / sigma) dot.c b_H $ <eq-senior>

The term $(Y slash y_H)^(1 slash sigma)$ embodies the key channel: as AI raises $y_L$ and hence total output $Y$, while $y_H$ remains unchanged, the marginal revenue product of task $H$ — and therefore $w_S$ — rises. This is the within-occupation analogue of the between-occupation augmentation result in #cite(<NBERw33941>, form: "prose").

_Comparative statics._ An increase in AI capability $A$ produces the following adjustment. First, $w_J$ falls via @eq-noarb, reducing $n_J$ through elastic labour supply as junior workers exit to other occupations. Within the occupation, junior workers partially reallocate from task $L$ to task $G$, but total junior employment nonetheless declines. Second, the rise in $y_L$ increases total output $Y$, raising the marginal product of task $H$ via CES complementarity. Senior wages $w_S$ rise and, through elastic supply, $n_S$ increases. The combined effect — falling $n_J$ and rising $n_S$ — produces a decline in the junior employment share. The net effect on total occupation-level employment is theoretically ambiguous, depending on the magnitudes of $sigma$ and $epsilon$.

== Testable Predictions

The model generates four predictions that I take to the data:

+ *Compositional shift:* In occupations with higher AI exposure, the junior employment share declines following the AI shock, as junior workers are displaced from task $L$ and exit the occupation.
+ *Senior augmentation:* Senior workers in high-exposure occupations experience rising demand driven by CES complementarity raising their marginal product, which may manifest as higher employment, increased outside options, or both.
+ *Wage adjustment:* Junior wages decline and senior wages rise, though the magnitudes may be small if the occupation-level supply elasticity $epsilon$ is large — a prediction consistent with adjustment occurring primarily through quantities rather than prices.
+ *Aggregate ambiguity:* The net occupation-level employment effect is indeterminate in sign, consistent with the aggregate null results documented in the existing literature.

The generic task channel provides an additional nuance: because junior workers retain a productive role in task $G$, displacement from high-AI occupations is _partial_ rather than total. The junior employment share declines but does not vanish, consistent with the patterns documented in the empirical analysis that follows.






/////////
///////// 3. Data and Identification Strategy
///////// 
= Data and Identification Strategy

== Data and Specification

// 简单介绍数据结构
The data I use is the individual-level position data from Revelio Labs, which aggregates information from LinkedIn profiles in the United Kingdom. The sample comprises 23,305,509 distinct workers holding 50,742,348 position records that were active at some point between January 2019 and December 2025, which spans before and after the release of ChatGPT in November 2022. For each position, I observe the O\*NET occupation code, start and end dates, predicted salary data, company id, and two variables central to my analysis: an ordinal seniority measure ranging from 1 (Entry) to 7 (Senior Executive), and a within-individual position number that records the chronological order of each role. A detailed mapping of the seniority classification is provided in @tab:seniority-table.

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

) <tab:seniority-table>

In practice, I define a worker as _junior_ if their position carries a seniority level of 1 or 2, corresponding to Entry and Junior roles in @tab:seniority-table.#footnote[The methodology of how Revelio Labs classify seniority is available at: https://www.data-dictionary.reveliolabs.com/methodology.html\#seniority.] These workers typically perform execution-oriented tasks under supervision. Start from Associate level onwards, worker begins to have some discretionary space rather than merely executing tasks assigned by superiors. In the language of the theoretical framework, they have not yet cleared the expertise threshold required for task $H$. This classification captures 58.9 per cent of the sample. #cite(<lichtinger_generative_2025>, form: "prose") validate this seniority measure by showing that the distribution of job-title keywords aligns with expected seniority distinctions and remains stable before and after the diffusion of generative AI.

To measure occupation-level exposure to AI, I use the LLM exposure scores constructed by #cite(<GPTs_are_GPTs>, form: "prose"), who employ a combination of human annotators and GPT-4 to assess, for each O\*NET task, the share of task time that could be reduced by at least 50 per cent with access to a large language model. The resulting score enters all specifications as a continuous variable. I merge these scores to the Revelio positions data via O\*NET--SOC codes, achieving an 89.5 per cent match rate; unmatched positions are excluded from the analysis. For robustness check, I replicate the main specifications using two alternative measures: the AI Occupational Exposure index of #cite(<felten2021occupational>, form: "prose") and the AI Applicability Score of #cite(<tomlinson2025working>, form: "prose"), with results reported in Appendix C.

// 注：还没有跑 Robustness Check



//Specification 部分





The primary empirical specification is an event study that tracks the junior hiring share across occupations with differing AI exposure over time. I collapse the position-level data into occupation $times$ half-year cells and estimate

$ "junior_share"_(o,t) = sum_(k eq.not 2022"H1") beta_k (m_(1,o) times bold(1)[t = k]) + alpha_o + gamma_t + epsilon_(o,t) $ <eq:eventstudy>

where $"junior_share"_(o,t)$ is the proportion of new hires classified as junior (seniority $lt.eq$ 2) in O\*NET occupation $o$ during half-year $t$; $m_(1,o)$ is the continuous LLM exposure score; $alpha_o$ and $gamma_t$ are occupation and time fixed effects; and the summation runs over all half-year periods from 2018H1 to 2025H2, with 2022H1---the last fully pre-treatment period---omitted as the baseline. The coefficients $beta_k$ trace out the differential evolution of the junior share for a one-unit increase in AI exposure relative to the baseline period. I weight each cell by the number of underlying positions to account for heterogeneous cell sizes and cluster standard errors at the O\*NET occupation level to permit arbitrary within-occupation serial correlation. As a complementary specification, I also report a pooled difference-in-differences estimate that replaces the period-specific interactions with a single $m_(1,o) times "Post"_t$ term, where $"Post"_t$ equals one from 2023H1 onward.

To examine career mobility, I further construct a worker-level transition dataset from the original positions dataset. A transition is defined as a consecutive pair of positions held by the same individual, with the transition date set to the start date of the subsequent position. I impose sample restrictions to ensure clean identification of job transitions, yielding 12.6 million valid transitions.#footnote[I exclude individuals with more than 50 recorded positions (likely data artefacts), drop all positions for individuals with any overlapping employment spells to avoid ambiguous transition timing, and remove positions with missing start dates.] I define the post-treatment period for mobility as beginning in November 2022, corresponding to the month of ChatGPT's public release.

The extensive margin specification estimates a linear probability model of the form

$ "Transition"_(i,t) = delta_1 "AI"_o times "Post"_t + delta_2 "Junior"_i times "AI"_o times "Post"_t + bold(X)'_i eta + alpha_o + gamma_t + epsilon_(i,t) $ <eq:extensive>

where $"Transition"_(i,t)$ equals one if individual $i$ moves to a different position at time $t$; $"AI"_o$ is the continuous LLM exposure score of the origin occupation; $"Junior"_i$ equals one if the origin position has seniority $lt.eq$ 2; and $bold(X)_i$ includes the lower-order interactions. The coefficient $delta_1$ captures the differential change in transition probability for senior workers in high-exposure occupations after ChatGPT, while $delta_2$ captures the additional differential for junior relative to senior workers. I estimate the intensive margin---conditional on a transition occurring---using the change in seniority level as the outcome:

$ Delta "Seniority"_(i,t) = theta_1 "AI"_o times "Post"_t + theta_2 "Junior"_i times "AI"_o times "Post"_t + bold(X)'_i mu + alpha_o + gamma_t + u_(i,t) $ <eq:intensive>

where $Delta "Seniority"_(i,t)$ is the difference in seniority between the destination and origin positions. The coefficient $theta_2$ captures whether junior workers in high-exposure occupations experience differentially larger seniority gains upon transition in the post period.

The intensive-margin estimates condition on a transition having occurred, which raises a sample selection concern #cite(<Heckman1979>). If the composition of the transition sample changes systematically after ChatGPT --- for example, if weaker junior workers are disproportionately displaced, leaving only stronger workers to transition --- the seniority gains in @eq:intensive may be biased. I address this with a Heckman two-step procedure. The selection equation models the probability of transitioning using the main regressors, occupation fixed effects, and a firm-level exclusion restriction: the pre-period mean separation rate at the worker's origin firm, entered both as a main effect and interacted with junior status. The logic is that firms with historically higher turnover generate more transitions mechanically, but conditional on transitioning, the origin firm's historical separation rate should not affect the seniority change achieved in the new position. The inverse Mills ratio from the selection equation is then included in the outcome equation to correct for non-random selection into the transition sample.


// 3.2 Identification Strategy 部分
== Identification Strategy

The causal interpretation of the event-study coefficients rests on two conditions: that occupation-level AI exposure is not itself shaped by post-treatment labour market adjustment, and that the timing of the shock was unanticipated. The first condition holds by construction. The LLM exposure scores of #cite(<GPTs_are_GPTs>, form: "prose") are derived from O\*NET task descriptions that predate ChatGPT; they capture how susceptible an occupation's task bundle is to large language models, not whether firms have actually adopted AI. This is an important distinction from #cite(<lichtinger_generative_2025>, form: "prose"), who rely on firm-level variation in AI adoption — a measure that may be endogenous to workforce composition decisions. In my setting, exposure is pinned down by the pre-existing task content of jobs and does not respond to post-shock employer behaviour.

The second condition is supported by how suddenly ChatGPT appeared. @fig:googletrend shows that the Google Trends index for "ChatGPT" was zero before its release in November 2022 and rose sharply thereafter, confirming that the technology's public availability came as a surprise. The two-month gap between the release and the end of the baseline period (2022H1) is too short for measurable hiring adjustments to take shape, which supports the choice of 2022H1 as the omitted period in @eq:eventstudy.

#figure(
  image("../output/figures/chatgpt_trend.png", width: 70%),
  caption: [Google Trends index for the keyword "ChatGPT", 2019--2025],
) <fig:googletrend>

The key identifying assumption behind @eq:eventstudy is that, absent generative AI, the junior hiring share would have evolved similarly across occupations with different levels of LLM exposure. This assumption cannot be tested directly, but the event-study design offers a useful diagnostic: if the pre-treatment coefficients $hat(beta)_k$ are close to zero and show no systematic trend, it is harder to argue that the post-period divergence reflects pre-existing dynamics rather than the AI shock. I report this assessment in Section 4, together with a formal linear pre-trend test following #cite(<freyaldenhoven2019>, form: "prose").

Two limitations of this design deserve mention. First, because AI exposure is measured at the occupation level, I cannot include firm $times$ time fixed effects of the kind used by #cite(<lichtinger_generative_2025>, form: "prose"). My estimates therefore cannot rule out the possibility that firm-level confounders correlated with occupation-level exposure account for part of the observed compositional shift. Second, the seniority threshold that defines junior status is treated as fixed, yet AI may itself change the expertise requirements within occupations over time, shifting the boundary between junior and senior work endogenously. I hold this boundary constant throughout the analysis and note that modelling its endogenous response would require the between-occupation general equilibrium framework of #cite(<NBERw33941>, form: "prose"), which is beyond the scope of this essay.







= Results


I begin by establishing the central compositional fact: the junior share of new hires in high-AI-exposure occupations declined significantly after ChatGPT, a finding consistent with that of #cite(<klein2025generative>, form: "prose") at the firm level, he estimates a 5.8 per cent reduction in junior employment among highly exposed UK firms @kcl2025ai. The contribution of this section is twofold. First, I provide a more rigorous identification check through event-study analysis with occupation-specific trend controls. Second, I lay the empirical foundation for the career mobility analysis that follows.

== Compositional Shift

The present analysis complements this finding at a finer occupational granularity — individual position starts classified by O\*NET code — and subjects it to a more demanding identification strategy through event-study estimation.

@fig-junior-share plots the monthly junior share of new position starts, separately for occupations above and below the median AI exposure score. Prior to late 2022, both series fluctuate around stable means: approximately 55 per cent for the high-exposure group and 85 per cent for the low-exposure group. The higher baseline share of junior workers in low-exposure occupations is unsurprising, as these roles tend to be more entry-level in nature. From early 2023 onward, the high-exposure series drops sharply, falling below 40 per cent by late 2025, while the low-exposure series exhibits only a modest decline. The divergence is visually striking and temporally aligned with the diffusion of generative AI.

#figure(
  image("../output/junior_share_monthly.png", width: 95%),
  caption: [Monthly junior share of new position starts by AI exposure group. Junior defined as seniority $<= 2$ (Revelio Labs classification). AI exposure median split at 0.366 (#cite(<GPTs_are_GPTs>, form: "prose")). Vertical dashed line marks ChatGPT release (November 2022).]
) <fig-junior-share>

To quantify this divergence, I estimate an occupation-level difference-in-differences specification:

$ "JuniorShare"_(o,t) = alpha_o + gamma_t + beta dot "AI"_o times "Post"_t + epsilon_(o,t) $

where $"JuniorShare"_(o,t)$ is the share of new positions with seniority level 2 or below in occupation $o$ and half-year $t$, $"AI"_o$ is the continuous AI exposure score, and $"Post"_t$ equals one from 2023H1 onward. Observations are weighted by cell size; standard errors are clustered at the O\*NET occupation level (917 clusters).

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header(
      [], [*Coefficient*], [*Std. error*], [*$t$*], [*95% CI*],
    ),
    table.hline(stroke: 0.5pt),
    [$"AI"_o times "Post"_t$], [$-0.077$], [$0.009$], [$-8.37$], [$[-0.095, -0.059]$],
    table.hline(stroke: 0.8pt),
  ),
  caption: [
    Pooled difference-in-differences estimate. Dependent variable: junior hiring share at the occupation--half-year level, weighted by cell size. Occupation and half-year fixed effects absorbed. Standard errors clustered at the O\*NET code level (917 clusters). $N = 14,587$.
  ],
  kind: table,
) <tab-pooled-did>

The estimated interaction coefficient is $hat(beta) = -0.077$ ($t = -8.37$, $p < 0.001$): after the diffusion of generative AI, occupations with higher exposure experience a disproportionately larger decline in the share of new positions filled by junior workers. A hypothetical shift from zero to full exposure corresponds to a 7.7 percentage-point reduction in the junior share.

The pooled estimate, however, assumes that pre-treatment trends in the junior share were parallel across exposure levels. I examine this assumption through a semi-annual event study:

$ "JuniorShare"_(o,t) = alpha_o + gamma_t + sum_(k eq.not 0) beta_k dot "AI"_o dot bb(1)[t = k] + epsilon_(o,t) $ <eq-event-study>

where $alpha_o$ and $gamma_t$ denote occupation and half-year fixed effects, respectively, and the summation runs over all half-year periods with 2022H2 ($k = 0$) as the omitted baseline. Although ChatGPT was released on 30 November 2022, I designate 2022H2 rather than 2022H1 as the reference period for two reasons. First, #cite(<lichtinger_generative_2025>, form: "prose") document that firm-level hiring adjustments did not commence until the first quarter of 2023, implying that the final months of 2022 remained behaviourally pre-treatment. Second, the inherent lag between hiring decisions and position start dates — encompassing job posting, interviewing, and onboarding — further delays any compositional response in the Revelio data. The coefficient at 2022H1 ($-0.005$, $p = 0.44$) is statistically indistinguishable from the baseline, providing internal validation of this choice. Observations are weighted by cell size.


@fig-event-study and @tab-event-study present the results. The pre-period coefficients (2018H1 to 2022H1) fluctuate within a narrow band around zero, with no monotonic trend. A mild positive hump is visible during 2019H2–2020H2, plausibly reflecting differential COVID-era hiring in high-AI-exposure occupations, which are disproportionately white-collar and remote-compatible. These fluctuations are transient and subside before the treatment window: the coefficient at 2022H1 is $-0.005$, statistically indistinguishable from the baseline. A formal test for a linear pre-trend, implemented by replacing the unrestricted pre-period interactions with a single occupation-specific trend term following #cite(<freyaldenhoven2019>, form: "prose"), yields an estimated slope of essentially zero, confirming the absence of a systematic pre-existing divergence.

The post-period tells a sharply different story. From 2023H1 onward, the estimates decline steeply: $-0.064$ at 2023H1, $-0.103$ at 2024H1, and $-0.115$ by 2025H2. All post-period coefficients are significant at the 1 per cent level, with 95 per cent confidence intervals well below zero. The decline is an order of magnitude larger than the pre-period fluctuations and — unlike the pre-period hump — is sustained over three years.  A quarterly event study (see Appendix @fig-event-study-Quarterly) confirms that the decline begins precisely in 2022Q4–2023Q1, aligning with the onset documented by #cite(<lichtinger_generative_2025>, form: "prose").

#figure(
  image("../output/figures/event_study_baseline.png", width: 95%),
  caption: [Event study: effect of AI exposure on junior share of new position starts. Each point represents the estimated coefficient $hat(beta)_k$ from @eq-event-study. Baseline period: 2022H2. Standard errors clustered at the O\*NET code level; shaded area shows 95% confidence interval.]
) <fig-event-study>

In summary, high-AI-exposure occupations experienced a sustained and statistically significant decline in the junior share of new hires following the diffusion of generative AI. By 2025H2, the estimated effect reaches approximately 11.5 percentage points for a fully exposed occupation. The magnitude of the post-period break, its monotonic trajectory, and its precise temporal alignment with the diffusion of generative AI collectively support a causal interpretation, notwithstanding the minor pre-period fluctuations. This compositional shift raises a natural follow-up question: what happens to the junior workers who would otherwise have entered these occupations?


=== Robustness Check


I assess the sensitivity of the compositional shift results to alternative specifications, with full details reported in @B. Replacing the primary AI exposure measure with the AI Occupational Exposure index of #cite(<felten2021occupational>, form: "prose") yields a standardised coefficient of $-0.018$ ($t = -5.33$), close to the baseline estimate of $-0.021$. The result also holds under a binary treatment specification: high-exposure occupations experience a 3.9 percentage-point larger decline in the junior share relative to low-exposure occupations. The AI Applicability Score of #cite(<tomlinson2025working>, form: "prose"), which captures observed Copilot usage rather than theoretical task exposure, produces a smaller and statistically insignificant estimate. This is not unexpected. The identification strategy relies on pre-determined theoretical exposure interacted with the ChatGPT shock, and a usage-based measure introduces additional variation from adoption frictions — differences in how quickly firms actually deploy AI tools — that attenuates the estimated relationship.

Varying the seniority threshold reveals that the effect is concentrated at the junior--senior boundary. The coefficient is statistically insignificant when junior status is restricted to seniority level 1 alone, strongest at the baseline cutoff of $lt.eq 2$, and attenuated when expanded to $lt.eq 3$. This pattern suggests that seniority level 2 workers — those who perform substantive but routine cognitive tasks without the expertise needed to pivot toward complementary functions — constitute the primary margin of displacement.








== Career Mobility 

In this section, I turn to the analysis of career mobility, with particular emphasis on the post-ChatGPT period. The individual-level panel structure of the Revelio Labs data allows me to track career transitions directly. This addresses a limitation explicitly acknowledged by both #cite(<lichtinger_generative_2025>, form: "prose") and #cite(<klein2025generative>, form: "prose"), who identify the analysis of individual career trajectories following AI exposure as a direction for future research.

For each transition, I construct outcome variables capturing the change in seniority level, the log wage change ($Delta ln w$), and an indicator for whether the worker switched O\*NET occupation code. The core specification throughout is a triple-difference model:

$ Y_i = beta_1 "Junior"_i + beta_2 "Junior"_i times "AI"_o + beta_3 "Junior"_i times "Post"_t \ + beta_4 "AI"_o times "Post"_t + beta_5 "Junior"_i times "AI"_o times "Post"_t + alpha_o + gamma_t + epsilon_i $

where $alpha_o$ and $gamma_t$ denote occupation and month fixed effects, respectively. The main effects of $"AI"_o$ and $"Post"_t$ are absorbed by the fixed effects and omitted.

=== Extensive Margin: Who Moves?

@tab:transition reports results from the extensive-margin analysis. Using the full sample of 27.5 million positions (including those without a subsequent transition), I estimate the triple-difference specification with an indicator for whether a transition is observed as the dependent variable. The estimate of $beta_4$ is $0.548$, indicating that senior workers in high-exposure occupations became substantially _more_ mobile after ChatGPT. This is consistent with AI augmenting senior workers' expertise, thereby raising their market value and generating increased demand from competing employers. The triple-interaction term $beta_5 = -0.660$ is negative and highly significant: relative to senior workers, junior workers in the same high-exposure occupations experienced a substantially _smaller_ increase in transition probability. The net effect for junior workers ($beta_4 + beta_5 approx -0.11$) is negative, implying that juniors in high-AI-exposure occupations became less mobile after ChatGPT while their senior counterparts became more so. This asymmetry is consistent with the model's predictions: AI raises the returns to senior expertise, expanding their outside options, while simultaneously narrowing the opportunities available to junior workers whose tasks overlap with AI capabilities. The result is robust to excluding positions that began after July 2024 ($beta_5 = -0.662$), ruling out mechanical right-censoring as a driver.

#include "../output/tables/table2_extensive_margin.typ"





=== Intensive Margin: Transition Outcomes

Conditional on transitioning, Column (1) of @tab:mobility shows that junior workers leaving high-exposure occupations after ChatGPT gain significantly more seniority in their next position ($beta_5 = 0.122$). This estimate is susceptible to a selection concern: if AI disproportionately displaces weaker junior workers, those who successfully transition constitute a positively selected subsample, and the observed seniority gain may overstate any genuine upskilling effect.

To address this concern, I implement a #cite(<Heckman1979>, form: "prose") two-step correction. The selection equation models the probability of transitioning as a function of the main regressors, occupation fixed effects, and a firm-level exclusion restriction: the pre-period mean separation rate at the individual's company, entered both as a main effect and interacted with junior status.#footnote[The exclusion restriction logic is that firms with historically higher turnover generate more transitions mechanically, but conditional on transitioning, the origin firm's historical separation rate should not affect the seniority change achieved in the new position. The interaction with junior status allows the relationship between firm turnover and transition probability to differ across seniority groups.] The separation rate is a strong predictor of transitions in the first stage ($z = 343$). The probit is estimated on a 10 per cent random subsample for computational tractability, and the resulting inverse Mills ratio is included in the outcome equation estimated on the full sample.#footnote[The probit is estimated on observations where $"mod"("user_id", 10) = 0$, yielding approximately 2.7 million observations. The standard errors in the corrected specifications do not incorporate the Murphy--Topel adjustment for generated-regressor uncertainty. Because the first-stage sample is large, estimation error in the probit coefficients is negligible relative to second-stage sampling variability.]

Column (2) reports the corrected estimates. The inverse Mills ratio is significant and negative ($hat(lambda) = -0.129$), indicating that workers with higher unobserved propensity to transition tend to experience _smaller_ seniority gains upon moving --- a pattern of negative selection on the outcome dimension. Crucially, however, the triple-interaction term is virtually unchanged after correction ($beta_5 = 0.125$, compared with $0.122$ in the baseline). The Heckman correction thus confirms that selection into the transition sample does not contaminate the estimated treatment effect once occupation and time fixed effects are included. The seniority gain for junior workers in high-AI-exposure occupations after ChatGPT appears to reflect genuine skill-upgrading --- AI tools facilitate faster competency acquisition for capable junior workers --- rather than compositional upgrading of the transition pool through selective attrition.

Columns (3) and (4) examine log wage changes upon transition, controlling for the change in seniority level to isolate wage effects net of promotion-related gains. The triple-interaction term $beta_5$ is essentially zero and statistically insignificant ($0.007$, $t = 0.51$), indicating that junior workers are not differentially penalised in wage terms relative to senior workers. The coefficient on $"AI"_o times "Post"_t$ is negative and significant ($-0.111$), suggesting that transitions originating from high-exposure occupations are associated with lower wage growth overall, but this effect does not differ by seniority. The adjustment mechanism thus operates primarily through the quantity margin --- who remains in and who exits the occupation --- rather than through differential wage compression.

Columns (5) and (6) examine occupational switching. The triple-interaction term is small and insignificant ($beta_5 = -0.008$, $t = -0.61$ in the baseline). Junior workers do not systematically reallocate toward lower-AI-exposure occupations after ChatGPT. This null result is informative: the post-ChatGPT adjustment in career mobility operates along the seniority dimension rather than through occupational flight. Workers who transition move to positions of comparable AI exposure but at higher seniority --- a pattern more consistent with upward filtering within related occupations than with wholesale retreat from AI-exposed work.

#include "../output/tables/table1_mobility_regressions.typ"




///
/// 
/// Discussion
/// 
/// 
= Discussion
A natural question arising from the results is why wages do not move in the directions predicted by the theoretical framework. One important caveat is that the salary data from Revelio Labs are predicted values, imputed from job titles, locations, and company characteristics, rather than actual reported compensation. This introduces classical measurement error that attenuates estimated coefficients toward zero. It is worth noting that #cite(<lichtinger_generative_2025>, form: "prose"), who draw on the same Revelio Labs data infrastructure, do not report any wage-based analysis — which may itself reflect an awareness of this limitation. But even setting measurement error aside, the null wage result is consistent with the model under high labour supply elasticity $epsilon$. When supply is elastic, demand shocks are absorbed primarily through changes in quantities — who gets hired and who leaves — rather than through wage adjustment. The compositional shifts documented in Section 4, where junior hiring shares decline and senior workers gain expanded outside options, are precisely the quantity-margin responses the model predicts when $epsilon$ is large.

The Heckman correction in the mobility analysis provides a further window into mechanisms. The inverse Mills ratio is negative and significant ($hat(lambda) = -0.129$), indicating that workers with higher unobserved propensity to transition tend to experience smaller seniority gains upon moving. In the standard parameterisation, this implies negative selection on the outcome dimension: the unobservables that make a worker more likely to transition are associated with _worse_, not better, destination matches. The key finding, however, is that the triple-interaction coefficient is virtually unchanged after correction ($0.125$ versus $0.122$ in the baseline). This stability indicates that, once occupation and time fixed effects absorb cross-occupation heterogeneity, selection into the transition sample does not contaminate the estimated treatment effect. The preferred interpretation is therefore one of genuine skill-upgrading: AI tools help capable junior workers in exposed occupations build competencies faster, enabling larger seniority gains upon transition. The occupation-switching null reinforces this reading — junior workers in high-exposure occupations are not fleeing to unrelated fields but moving upward within the same occupational domain.

The extensive-margin results merit further discussion. Senior workers in high-AI-exposure occupations become substantially more mobile after ChatGPT, while the net effect for junior workers is negative. One natural concern is whether increased senior mobility is consistent with the model's prediction that senior employment rises ($partial n_S slash partial A > 0$). The model predicts that AI raises senior wages via CES complementarity, which increases the quantity of senior labour supplied to the occupation. Higher market value, however, also generates poaching demand from other employers, raising gross transition rates even as net occupational employment grows. The extensive-margin estimate captures gross flows, not net stocks; it is therefore consistent with senior augmentation provided that inflows match or exceed outflows. Direct measurement of net senior headcount changes at the occupation level would provide a sharper test, but lies beyond the scope of the present data.

A broader concern for this literature is the lack of consensus on how to measure occupational exposure to AI. #cite(<gimbel2026labor>, form: "prose") document that the most widely used indices — including those of #cite(<GPTs_are_GPTs>, form: "prose"), #cite(<felten2021occupational>, form: "prose"), and #cite(<webbImpactArtificialIntelligence>, form: "prose") — disagree substantially on which occupations are most exposed, reflecting differences in whether exposure is defined through task descriptions, technical benchmarks, or patent-based measures. This motivates my use of three methodologically distinct indices: the primary LLM exposure score based on expert and GPT-4 assessment of task-level automation potential, the AI Occupational Exposure index derived from mapping AI capabilities to occupational abilities, and the AI Applicability Score constructed from revealed usage patterns in real-world AI interactions. If the main findings hold across all three, this substantially strengthens the confidence that the results are not driven by a particular measurement choice. A separate data limitation concerns the representativeness of the Revelio Labs sample. Because the data are drawn from public LinkedIn profiles, the sample likely over-represents white-collar, professional occupations relative to the working population as a whole. Since LLM exposure is concentrated in precisely such occupations, this sample composition may amplify the estimated effects relative to what a nationally representative survey would yield.

Finally, as noted in Section 3, the seniority threshold separating junior from senior workers is held fixed throughout the analysis, yet AI may itself reshape expertise requirements within occupations, shifting this boundary endogenously over time. Modelling such a response would require the between-occupation general equilibrium framework of #cite(<NBERw33941>, form: "prose") and is left for future work. More broadly, the estimates presented here capture the early stages of generative AI diffusion. The capabilities of the technology are expanding rapidly — from text-based assistance toward autonomous task execution — and the occupational task bundles that define current exposure scores may not remain stable as these capabilities evolve. Whether the compositional shifts documented in this essay persist, intensify, or reverse as firms and workers adapt over a longer horizon remains an open question, and one that longer post-treatment panels will be well placed to address.

///
/// 
/// Conclusion
/// 
/// 
= Conclusion


This essay has argued that aggregate null results for AI's employment effects conceal meaningful compositional shifts within occupations. Extending the expertise framework of #cite(<NBERw33941>, form: "prose") to permit within-occupation task specialisation, I derive predictions for how AI capability improvements differentially affect junior and senior workers, and test these predictions using individual-level data from the UK labour market. The evidence is consistent with the model's core mechanism: in occupations more exposed to large language models, the junior hiring share declines, senior workers become substantially more mobile as augmentation raises their market value, and those juniors who do transition achieve larger seniority gains --- an effect robust to Heckman selection correction, consistent with genuine skill-upgrading. Wage effects, by contrast, are absent, consistent with adjustment operating through quantities rather than prices.

These findings carry a subtler implication. Much of the public debate frames AI as a threat to entire occupations or skill groups. The evidence here suggests a different pattern: AI reshapes _who does the work within an occupation_ before it reshapes _whether the occupation exists_. If this pattern generalises, then the workers most immediately affected are not those in "threatened occupations" but those at the bottom of the ladder within occupations that are, on the whole, thriving. This is a form of displacement that aggregate statistics are poorly equipped to detect, and that conventional policy responses — retraining workers for different occupations — are poorly designed to address. The more relevant question may be how firms and institutions restructure entry-level pathways when the tasks that once served as training grounds are increasingly performed by machines.

Whether these early compositional shifts prove transitory or permanent, and whether the expertise threshold itself adapts in response, are questions that longer post-treatment data will help resolve. But if displacement does begin at the junior level, as the evidence here suggests, the implications extend beyond the immediately affected workers. Every senior professional was once a junior one; entry-level positions have traditionally served as the channel through which new labour market entrants acquire occupation-specific skills and progress toward independent judgment. A sustained contraction of this channel would warrant attention from policymakers and educational institutions, not because entire occupations are disappearing, but because the pathway into them is narrowing.






// ============================================================
//  REFERENCES
// ============================================================
#pagebreak()
#bibliography("refs.bib", title: "References", style: "apa")








// ============================================================
//  APPENDICES (not counted in word limit)
// ============================================================


#pagebreak()





#heading(numbering: none)[Appendix]

#counter(heading).update(0)
#set heading(numbering: "A.1")
#set heading(supplement: "Appendix")

// Your appendix content here.

= Derivation of Theoretical Model 

== Firm's Optimisation Problem and First-Order Conditions<A1>

The representative firm in the occupation takes output price $p$ and factor prices $w_J$, $w_S$, $r$ as given, and chooses AI capital $M$, junior labour in task $L$ ($n_J^L$), junior labour in task $G$ ($n_J^G$), and senior labour $n_S$ to maximize profit:

$ max_(M, n_J^L, n_J^G, n_S) quad p dot Y - w_J (n_J^L + n_J^G) - w_S n_S - r M $

where output $Y$ is the CES aggregate defined in @eq-ces, and the three task production functions are given by @eq-tasks.

Substituting the CES structure, the marginal revenue product of task $k in {L, H, G}$ is:

$ p dot frac(partial Y, partial y_k) = p dot beta_k lr((frac(Y, y_k)))^(1 / sigma) $ <eq-mrp>

The first-order conditions for an interior solution are:

$ p dot beta_L lr((frac(Y, y_L)))^(1 / sigma) dot A = r $ <eq-foc-m>

$ p dot beta_L lr((frac(Y, y_L)))^(1 / sigma) dot a_L = w_J $ <eq-foc-njl>

$ p dot beta_G lr((frac(Y, y_G)))^(1 / sigma) dot c = w_J $ <eq-foc-njg>

$ p dot beta_H lr((frac(Y, y_H)))^(1 / sigma) dot b_H = w_S $ <eq-foc-ns>

*Derivation of the no-arbitrage condition.* Dividing @eq-foc-m by @eq-foc-njl:

$ frac(A, a_L) = frac(r, w_J) quad => quad w_J = frac(a_L dot r, A) $

Since AI and junior labour are perfect substitutes in task $L$, the firm employs both only when their unit costs are equalised. This condition pins junior wages entirely as a function of AI capability $A$ and the rental rate $r$, independently of conditions in tasks $H$ and $G$.

*Derivation of the constant task output ratio.* Dividing @eq-foc-njl by @eq-foc-njg:

$ frac(beta_L lr((Y slash y_L))^(1 / sigma) dot a_L, beta_G lr((Y slash y_G))^(1 / sigma) dot c) = 1 $

Simplifying:

$ frac(beta_L a_L, beta_G c) dot lr((frac(y_G, y_L)))^(1 / sigma) = 1 quad => quad frac(y_G, y_L) = lr((frac(beta_G c, beta_L a_L)))^sigma equiv gamma $

The ratio $gamma$ is a structural constant determined by technology and task share parameters. Intuitively, both tasks $L$ and $G$ are produced using the same marginal factor (junior labour at wage $w_J$), so their marginal costs move simultaneously. The CES demand system then fixes their output ratio regardless of $A$.

*Senior wage expression.* From @eq-foc-ns directly:

$ w_S = p dot beta_H lr((frac(Y, y_H)))^(1 / sigma) dot b_H $

This is the marginal revenue product of senior labour in task $H$.


== Senior Specialization in Task H<A2>

The main text asserts that senior workers specialize entirely in task $H$ in equilibrium despite being physically capable of performing task $G$. I verify this claim here. The intuition is simple.

If a senior worker were reallocated to task $G$, her marginal revenue product would equal that of junior workers in task $G$, which by @eq-foc-njg is exactly $w_J$. Her marginal revenue product in task $H$ is $w_S$. Senior specialization in task $H$ is therefore optimal whenever $w_S > w_J$, that is:

$ p dot beta_H lr((frac(Y, y_H)))^(1 / sigma) dot b_H > frac(a_L dot r, A) $

This condition holds when task $H$ is sufficiently valued relative to task $L$ — specifically, when the expertise-intensive component of the occupation commands a premium over routine tasks. This is empirically well supported: in the Revelio Labs data, salaries for senior positions (seniority $>=$ 5) substantially exceed those for entry-level positions (seniority $<=$ 2) within the same O\*NET occupation. I maintain $w_S > w_J$ as a regularity condition throughout.


== Comparative Statics<A3:comparative>

I now try to derive the effects of an increase in AI capability $A$ on the equilibrium allocation, which covers mainly four steps.

*Step 1: Junior wage and employment*

From the no-arbitrage condition:

$ frac(partial w_J, partial A) = - frac(a_L r, A^2) < 0 $

Substituting into the supply function (@eq-supply):

$ n_J = phi_J lr((frac(a_L r, A)))^epsilon quad => quad frac(partial n_J, partial A) = - epsilon phi_J (a_L r)^epsilon A^(-(epsilon + 1)) < 0 $
An increase in AI capability monotonically reduces both the wage and employment of junior workers in the occupation. The magnitude of the employment response is governed by the supply elasticity $epsilon$: when $epsilon$ is large, even a small decline in $w_J$ induces substantial exit. Pinning down the precise value of $epsilon$ is beyond the scope of this essay; the key qualitative prediction — that junior employment falls with AI capability — holds for any $epsilon > 0$.

*Step 2: Task output levels*

To characterize how task outputs respond to $A$, I reduce the model's dimensionality. Since $y_G = gamma y_L$ with $gamma$ constant, I define $tilde(beta)_L equiv beta_L + beta_G gamma^((sigma - 1) / sigma)$ and write the CES aggregate as a function of two effective task outputs:

$ Y = lr([tilde(beta)_L y_L^((sigma - 1) / sigma) + beta_H y_H^((sigma - 1) / sigma)])^(sigma / (sigma - 1)) $ <eq-ces-reduced>

From @eq-foc-m, the shadow price of task $L$ output satisfies:

$ p dot beta_L lr((frac(Y, y_L)))^(1 / sigma) = frac(r, A) $

This implicitly defines the demand for $y_L$ as a function of $y_H$ and $A$. Holding $y_H$ fixed, an increase in $A$ reduces the effective marginal cost of task $L$ output ($r slash A$), which by CES demand raises $y_L$. Since $y_G = gamma y_L$, task $G$ output rises proportionally.

To verify that total output $Y$ rises: from @eq-ces-reduced, $Y$ is increasing in both $y_L$ and $y_H$. Since $y_L$ increases and $y_H$ is (initially) unchanged, $Y$ unambiguously increases.

*Step 3: Senior augmentation*

I establish that the demand curve for senior labour shifts outward when $A$ increases, and that the equilibrium senior wage and employment both rise.

Define the inverse demand for senior labour, holding $A$ fixed:

$ w_S^D (n_S; A) equiv p dot beta_H lr((frac(Y(n_S, A), b_H n_S)))^(1 / sigma) dot b_H $ <eq-inverse-demand>

where $Y(n_S, A)$ is total output evaluated at the optimal task allocation for given $n_S$ and $A$.

*Claim 1: $w_S^D$ is decreasing in $n_S$*. An increase in $n_S$ raises $y_H = b_H n_S$ and hence $Y$. However, $y_H$ rises proportionally with $n_S$, while $Y$ exhibits diminishing returns to $y_H$ under the CES structure ($sigma < infinity$). Consequently, $Y slash (b_H n_S)$ falls, and so does $w_S^D$.

*Claim 2: $w_S^D$ is increasing in $A$*. Holding $n_S$ fixed, an increase in $A$ reduces the marginal cost of task $L$, raising $y_L$ and $y_G = gamma y_L$. Since $y_H = b_H n_S$ is unchanged, $Y$ increases while $y_H$ does not, so $Y slash (b_H n_S)$ rises and $w_S^D$ rises.

*Equilibrium effect.* The demand curve $w_S^D (n_S; A)$ is downward-sloping and shifts outward when $A$ rises. The supply curve $n_S = phi_S w_S^epsilon$ is upward-sloping. Standard comparative statics of supply-demand intersection imply that the new equilibrium features both higher $w_S$ and higher $n_S$:

$ frac(partial w_S, partial A) > 0, quad frac(partial n_S, partial A) > 0 $

This confirms the augmentation result: AI capability improvements raise senior wages and senior employment via CES task complementarity.

*Step 4: Compositional shift*

Define the junior employment share as $s_J equiv n_J slash (n_J + n_S)$. From Steps 1 and 3, $partial n_J slash partial A < 0$ and $partial n_S slash partial A > 0$. Both the numerator and denominator of $s_J$ are affected, the junior employment share unambiguously declines.

*Internal reallocation of junior labour*

Although total junior employment falls, the allocation of remaining juniors between tasks $L$ and $G$ also shifts. From $y_G = gamma y_L$ and $y_G = c dot n_J^G$:

$ n_J^G = frac(gamma y_L, c) $

Since $y_L$ is increasing in $A$ (Step 2), $n_J^G$ increases. Combined with declining total junior employment ($n_J$ falls), this implies:

$ n_J^L = n_J - n_J^G $

which falls faster than $n_J$ itself. Junior workers are squeezed out of task $L$ on two margins: AI directly substitutes their labour, and the remaining juniors reallocate toward task $G$ where AI cannot substitute.


The above derivations assume an interior solution in which $n_J^L > 0$ For sufficiently large $A$, all junior workers exit task $L$ and produce only task $G$ output. I focus on the interior case, which is empirically relevant given that junior workers remain present in high-exposure occupations throughout the sample period.



== Net Occupation-Level Employment

The net effect of AI capability on total occupation-level employment $N = n_J + n_S$ is:

$ frac(partial N, partial A) = frac(partial n_J, partial A) + frac(partial n_S, partial A) $

The first term is unambiguously negative and the second is unambiguously positive (from my derivation in @A3:comparative). The net sign depends on the relative magnitudes, which are governed by the structural parameters. Senior augmentation dominates ($partial N slash partial A > 0$) when:

- The task share of high-expertise tasks ($beta_H$) is large, amplifying the complementarity channel.
- Senior supply is highly responsive ($phi_S$ large or $epsilon$ large), so that wage increases translate into large employment gains.

Conversely, junior displacement dominates ($partial N slash partial A < 0$) when $beta_L$ is large, junior supply is highly responsive ($phi_J$ large or $epsilon$ large), and the initial junior share is high.



= Robustness Check<B>

== Summary of Alternative Specifications

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, left, center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header(
      [*Specification*], [*Treatment*], [*Junior def.*],
      [*Coefficient*], [*Std. error*], [*$N$*],
    ),
    table.hline(stroke: 0.5pt),
    [Main],            [z(Eloundou)],      [$lt.eq 2$], [$-0.021^(***)$], [$(0.002)$], [14,587],
    [R1: Felten],      [z(Felten)],        [$lt.eq 2$], [$-0.018^(***)$], [$(0.003)$], [14,227],
    [R2: Tomlinson],   [z(Tomlinson)],     [$lt.eq 2$], [$-0.005$], [$(0.003)$], [14,227],
    [R3: Seniority 1], [z(Eloundou)],      [$lt.eq 1$], [$-0.003$], [$(0.003)$], [14,587],
    [R4: Seniority 3], [z(Eloundou)],      [$lt.eq 3$], [$-0.009^(***)$], [$(0.003)$], [14,587],
    [R5: Binary],      [Binary(Eloundou)], [$lt.eq 2$], [$-0.039^(***)$], [$(0.005)$], [14,587],
    table.hline(stroke: 0.8pt),
  ),
  caption: [
    Robustness of the pooled difference-in-differences estimate for the junior hiring share. All continuous treatment variables are standardised to have zero mean and unit standard deviation at the occupation level. The dependent variable is the mean junior share within each occupation--half-year cell, weighted by cell size. Standard errors in parentheses, clustered at the O\*NET code level.  $*** p < 0.01$.
  ],
  kind: table,
) <tab-robustness>

#set text(size: 8pt)
_Notes._ The baseline period is 2022H2. "z(·)" denotes the occupation-level z-score of the indicated measure. R1 uses the AI Occupational Exposure index of Felten, Raj and Seamans (2021). R2 uses the AI Applicability Score of Tomlinson et al. (2025). R5 defines high exposure as above-median Eloundou et al. (2024) score.
#set text(size: 12pt)


#figure(
  grid(
    columns:2,
    column-gutter: 1em,
    row-gutter: 1em,
    image("../output/figures/rob_es_m2.png"),
    image("../output/figures/rob_es_m3.png"),
    image("../output/figures/rob_es_sen1.png"),
    image("../output/figures/rob_es_sen3.png"),
    image("../output/figures/rob_es_binary.png")
  ),
  caption: [Robustness Check under different AI Exposure Measure and Different Junior Category Specification]
) <fig-rob>



= Other Statistics

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header(
      [*Period*], [*$hat(beta)_k$*], [*95% CI lower*], [*95% CI upper*],
    ),
    table.hline(stroke: 0.5pt),
    [2018H1], [$-0.023$], [$-0.045$], [$-0.001$],
    [2018H2], [$space.thin 0.000$], [$-0.014$], [$space.thin 0.014$],
    [2019H1], [$space.thin 0.005$], [$-0.011$], [$space.thin 0.020$],
    [2019H2], [$space.thin 0.018$], [$space.thin 0.006$], [$space.thin 0.030$],
    [2020H1], [$space.thin 0.012$], [$-0.008$], [$space.thin 0.032$],
    [2020H2], [$space.thin 0.024$], [$space.thin 0.008$], [$space.thin 0.039$],
    [2021H1], [$space.thin 0.003$], [$-0.013$], [$space.thin 0.018$],
    [2021H2], [$space.thin 0.007$], [$-0.001$], [$space.thin 0.015$],
    [2022H1], [$-0.005$], [$-0.018$], [$space.thin 0.008$],
    table.hline(stroke: 0.3pt),
    [*2022H2*], [*0*], [], [],
    table.hline(stroke: 0.3pt),
    [2023H1], [$-0.064$], [$-0.090$], [$-0.038$],
    [2023H2], [$-0.062$], [$-0.082$], [$-0.043$],
    [2024H1], [$-0.103$], [$-0.136$], [$-0.071$],
    [2024H2], [$-0.098$], [$-0.124$], [$-0.072$],
    [2025H1], [$-0.114$], [$-0.151$], [$-0.077$],
    [2025H2], [$-0.115$], [$-0.150$], [$-0.080$],
    table.hline(stroke: 0.8pt),
  ),
  caption: [
    Event study coefficients from @eq-event-study. The dependent variable is the junior hiring share at the occupation--half-year level, weighted by cell size. The omitted baseline is 2022H2. Standard errors clustered at the O\*NET code level (917 clusters).
  ],
  kind: table,
) <tab-event-study>




#figure(
  image("../output/figures/event_study_quarterly.png", width: 70%),
  caption: [Event study: effect of AI exposure on junior share of new position starts on quarterly basis]
) <fig-event-study-Quarterly>
