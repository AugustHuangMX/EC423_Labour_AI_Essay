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
      #course-code Labour Economics \
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

_Current aggregate studies of AI often find small occupation-level employment effects. I argue that these results can mask within-occupation compositional change: AI reduces demand for junior workers while raising the marginal product of senior tasks. I formalize this mechanism by extending the expertise framework of Autor and Thompson (2025) to allow junior--senior task specialization. Using UK position data from Revelio Labs matched to LLM exposure scores, and treating the release of ChatGPT in November 2022 as a shock, I find that higher-exposure occupations experience a sustained decline in the junior hiring share, reaching 11.5 percentage points by 2025. Mobility evidence points to increased senior reallocation, which does not by itself identify net augmentation, and to larger seniority gains among transitioning juniors. I find no corresponding wage effects in predicted salary data._

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

Since the launch of ChatGPT in autumn 2022, generative AI has developed quickly across text, code, image, and other creative tasks. This has raised a clear labour-market question: why have such large technical advances not yet produced large aggregate employment effects? Earlier computerisation produced visible structural change, including the occupational polarisation documented by #cite(<autor2013dorn>, form: "prose"). One might therefore expect large language models to generate similarly visible disruption, especially because #cite(<GPTs_are_GPTs>, form: "prose") estimate that a large share of workers hold occupations with tasks exposed to LLMs.

Yet recent evidence is more muted at the aggregate level. The task framework of #cite(<Acemoglu2019automation>, form: "prose") predicts that automation can both displace tasks and create new demand, so the net employment effect is ambiguous. Consistent with this, #cite(<massenkoffmccrory2026labor>, form: "prose") find no systematic unemployment increase in highly exposed occupations, while #cite(<Canaries_in_the_Coal_Mine>, form: "prose") find sharper losses for early-career workers rather than broad occupational collapse. This suggests that the main adjustment may be hidden inside occupations.

I argue that aggregate null results can mask offsetting compositional shifts within occupations. AI may displace junior workers, whose tasks overlap more with current AI capabilities, while augmenting senior workers, whose expertise-intensive tasks remain complementary to AI. Since both groups sit inside the same occupation codes, junior displacement and senior augmentation may partly cancel in occupation-level employment measures. This idea is consistent with the seniority-biased effects documented by #cite(<lichtinger_generative_2025>, form: "prose") and with evidence that early-career workers are especially exposed #cite(<Canaries_in_the_Coal_Mine>).

This framing also helps connect two strands of evidence that otherwise look separate. Studies of aggregate occupation-level employment often find small or delayed effects, while firm- or worker-level studies increasingly point to pressure on entry-level work. The contribution of this essay is to treat these as related facts rather than competing results: the same occupation can experience junior displacement and senior reallocation at the same time.

The theoretical contribution is to extend the expertise framework of #cite(<NBERw33941>, form: "prose") by relaxing within-occupation worker homogeneity. In my partial-equilibrium CES model, junior and senior workers have comparative advantage in different tasks. AI substitutes for junior labour in low-expertise tasks and complements senior labour through task-level production. The model predicts a falling junior employment share, rising senior marginal products, ambiguous net occupation-level employment, and wage movements that may be hard to detect if quantity adjustment is stronger than price adjustment.

The empirical contribution is to test this within-occupation mechanism directly, rather than treating an occupation as a single homogeneous labour input. This is where individual-level position histories are especially useful for the research question studied here.

I test these predictions using UK position data from Revelio Labs matched to the LLM exposure scores of #cite(<GPTs_are_GPTs>, form: "prose"). The empirical design treats the release of ChatGPT in November 2022 as a shock and uses cross-occupation variation in exposure. I find a sustained decline in the junior share of new positions in highly exposed occupations. I also study career mobility as a related adjustment margin, addressing the call by #cite(<Canaries_in_the_Coal_Mine>, form: "prose") and #cite(<klein2025generative>, form: "prose") for more worker-level evidence. Senior workers in exposed occupations become more mobile, while junior workers who transition experience larger seniority gains; this estimate is stable after Heckman correction. I find no clear wage effects in the Revelio predicted salary data and no evidence of occupation switching away from exposed occupations.

The remainder of this essay proceeds as follows. Section 2 develops the theoretical framework. Section 3 describes the data and identification strategy. Section 4 presents the empirical results on compositional shifts and career mobility. Section 5 discusses limitations and situates the findings within the broader literature. Section 6 concludes.







= Theoretical Framework

#cite(<NBERw33941>, form: "prose") introduce an expertise framework in which the effect of automation depends on which tasks are automated. When automation replaces inexpert tasks, the remaining task bundle becomes more expertise-intensive; wages may rise, but employment can fall because fewer workers meet the threshold. Their framework assumes that workers inside an occupation are homogeneous: each worker must perform all non-automated tasks and, conditional on meeting the expertise threshold, is equally productive.

This assumption is useful for their between-occupation analysis, but it rules out the within-occupation margin studied here. I keep the idea that occupations bundle tasks of different expertise levels, but allow junior and senior workers to specialise inside the same occupation. The motivation comes from knowledge-hierarchy models such as #cite(<garicanoRossiHansberg2006>, form: "prose"), where less experienced workers handle more routine problems and experienced workers solve harder ones. This gives a production-side reason why the same occupation code can contain different task portfolios. I use Revelio seniority as the empirical proxy for this distinction.

The model is deliberately partial equilibrium. I do not model how the whole economy reallocates workers across occupations, as in #cite(<NBERw33941>, form: "prose"). Instead, I ask what happens inside a given occupation when AI becomes more capable. This narrower setup is useful because the empirical analysis also works at the occupation-by-time and worker-transition levels. It allows the model to focus on the junior--senior composition margin without needing to explain all aggregate employment changes.

== Model Setup

Consider a single occupation in partial equilibrium. Output $Y$ is produced by combining three task types via CES aggregation:

$ Y = lr([ beta_L y_L^((sigma - 1) / sigma) + beta_H y_H^((sigma - 1) / sigma) + beta_G y_G^((sigma - 1) / sigma) ])^(sigma / (sigma - 1)) $ <eq-ces>

where $0 < sigma < 1$ is the within-occupation task substitution elasticity and $beta_L, beta_H, beta_G > 0$ are task share parameters, with $beta_L + beta_H + beta_G = 1$. The parameter $sigma$ is distinct from the between-occupation elasticity $lambda$ in #cite(<NBERw33941>, form: "prose").

Following #cite(<NBERw33941>, form: "prose"), tasks fall into three categories:

- Task $L$: low-expertise activities, including routine operations that are readily automatable by AI.
- Task $H$: high-expertise activities, including context-dependent judgement, managerial decision-making, and other functions requiring accumulated experience.
- Task $G$: generic support tasks assigned to junior workers, including common execution-oriented activities that remain non-automated.

The generic task allows junior workers to remain useful even when AI substitutes for part of their task bundle. This matters for generative AI because exposure is high in many white-collar occupations #cite(<webbImpactArtificialIntelligence>), where junior workers often perform both routine cognitive tasks and support work. Without task $G$, the model would predict too stark a form of displacement; with it, the junior share can fall without junior employment disappearing entirely.



Each task type is produced as follows:

$ y_L = A dot.c M + a_L dot.c n_J^L, quad y_H = b_H dot.c n_S, quad y_G = c dot.c n_J^G $ <eq-tasks>

In task $L$, AI capital $M$ (rented at rate $r$) and junior labour $n_J^L$ are perfect substitutes, with $A$ denoting AI capability. This is the displacement channel. Task $H$ requires senior workers because it involves judgement and accumulated experience. This is the augmentation channel: AI raises the value of complementary high-expertise tasks. Task $G$ is junior-assigned support work; I abstract from senior production of $G$ because senior time has a higher return in task $H$.#footnote[This restriction is equivalent to assuming that the senior return in task $H$ exceeds the return seniors would obtain from generic support work. See @A2.]

Junior workers allocate their labour between tasks $L$ and $G$ subject to $n_J^L + n_J^G = n_J$. At the occupation level, labour supply responds to wages with constant elasticity:

$ n_J = phi_J w_J^epsilon, quad n_S = phi_S w_S^epsilon $ <eq-supply>

where $epsilon > 0$ captures workers' ability to enter or exit the occupation in response to wage changes.

== Equilibrium and Comparative Statics

The competitive firm's cost minimisation yields three conditions; full derivations are in @A1 and @A3:comparative.

_No-arbitrage in task $L$._ Since AI and junior labour are perfect substitutes, the firm employs both only when their unit costs are equalised:

$ w_J = frac(a_L dot.c r, A) $ <eq-noarb>

As AI capability $A$ rises, the junior wage $w_J$ falls.

_Internal allocation of junior labour._ Equalizing the marginal revenue product of junior labour across tasks $L$ and $G$ yields $y_G slash y_L = gamma$, where $gamma equiv (beta_G c slash beta_L a_L)^sigma$ is independent of $A$.

_Senior augmentation via complementarity._ Senior wages satisfy:

$ w_S = p dot.c beta_H lr((frac(Y, y_H)))^(1 / sigma) dot.c b_H $ <eq-senior>

The term $(Y slash y_H)^(1 slash sigma)$ is the complementarity channel. Holding senior labour fixed, higher AI capability raises $y_L$ and total output $Y$, which increases the marginal revenue product of task $H$ and therefore $w_S$. The resulting rise in senior labour dampens but does not reverse this outward shift in senior demand.

_Comparative statics._ A rise in $A$ lowers $w_J$ and, with elastic labour supply, reduces $n_J$. Within junior labour, workers move away from task $L$ toward task $G$, but total junior employment still falls. At the same time, the increase in $y_L$ raises senior marginal products through CES complementarity, increasing $w_S$ and $n_S$. The combined effect is a lower junior employment share. The net effect on total occupation-level employment remains ambiguous because the junior decline and senior increase work in opposite directions.

== Testable Predictions

The static model formally delivers four implications:

+ *Compositional shift:* In occupations with higher AI exposure, the junior employment share declines following the AI shock, as junior workers are displaced from task $L$ and exit the occupation.
+ *Senior augmentation:* Senior workers in high-exposure occupations experience rising marginal products, wages, and labour demand through CES complementarity.
+ *Wage adjustment:* Junior wages decline and senior wages rise. If the occupation-level supply elasticity $epsilon$ is large, wage changes may be small relative to employment changes, but the model still predicts price adjustment.
+ *Aggregate ambiguity:* The net occupation-level employment effect is indeterminate in sign, consistent with the aggregate null results documented in the existing literature.

Because junior workers retain a role in task $G$, the model predicts partial rather than total displacement. The model is static and does not include search, matching, or skill accumulation, so the career-mobility results below should be read as complementary evidence rather than direct model tests.






/////////
///////// 3. Data and Identification Strategy
///////// 
= Data and Identification Strategy

== Data and Specification

// 简单介绍数据结构
I use individual-level position data from Revelio Labs, which aggregates UK LinkedIn profiles. The sample contains 23,305,509 workers and 50,742,348 position records active at some point between January 2019 and December 2025. For each position, I observe the O\*NET occupation code, start and end dates, predicted salary, company id, seniority level, and within-individual position number. @tab:seniority-table shows the seniority scale.

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

I define a worker as _junior_ if the position has seniority level 1 or 2.#footnote[The methodology of how Revelio Labs classify seniority is available at: https://www.data-dictionary.reveliolabs.com/methodology.html\#seniority.] This corresponds to Entry and Junior roles and captures 58.9 per cent of the sample. These workers typically perform execution-oriented tasks under supervision. From the Associate level onward, workers have more discretion and are closer to the senior task type in the model. #cite(<lichtinger_generative_2025>, form: "prose") validate this measure by showing that job-title keywords align with expected seniority differences and remain stable around the diffusion of generative AI.

To measure AI exposure, I use the LLM exposure score of #cite(<GPTs_are_GPTs>, form: "prose"), which estimates the share of task time that could be reduced by at least 50 per cent with access to a large language model. I merge this occupation-level score to Revelio using O\*NET--SOC codes, with an 89.5 per cent match rate. The score enters the main regressions continuously. In the extensive-margin mobility sample, it ranges from 0 to 1, with mean 0.494, standard deviation 0.177, and interquartile range 0.147. I therefore interpret mobility coefficients using one-standard-deviation changes as well as full-scale changes. For robustness, I also use the AI Occupational Exposure index of #cite(<felten2021occupational>, form: "prose") and the AI Applicability Score of #cite(<tomlinson2025working>, form: "prose"), reported in @B.

//Specification 部分





The main compositional-shift analysis uses position starts from 2019H1 to 2025H2. I collapse the data into occupation $times$ half-year cells and estimate

$ "JuniorShare"_(o,t) = sum_(k eq.not k_0) beta_k (m_(1,o) times bb(1)[t = k]) + alpha_o + gamma_t + epsilon_(o,t) $ <eq:eventstudy>

where $"JuniorShare"_(o,t)$ is the share of new hires classified as junior in occupation $o$ and half-year $t$; $m_(1,o)$ is LLM exposure; $alpha_o$ and $gamma_t$ are occupation and half-year fixed effects; and 2022H2 is the omitted baseline. I use 2022H2 as the reference period because ChatGPT was released late in that half-year, leaving little time for hiring responses to appear in position start dates. I weight cells by the number of positions and cluster standard errors at the O\*NET level. I also report a pooled difference-in-differences version with $m_(1,o) times "Post"_t$, where $"Post"_t$ begins in 2023H1.

For mobility, I construct consecutive position pairs for each worker and define the transition date as the start date of the next position. After cleaning, the dataset contains 12.6 million valid transitions.#footnote[I exclude individuals with more than 50 recorded positions (likely data artefacts), drop all positions for individuals with any overlapping employment spells to avoid ambiguous transition timing, and remove positions with missing start dates.] The mobility post period begins in November 2022.

I separate the mobility analysis into an extensive margin and an intensive margin. The extensive margin asks whether a position is followed by another observed position in the panel. The intensive margin conditions on a transition and asks what kind of move occurs. This distinction matters because the model predicts changes in the relative value of junior and senior work, but it does not itself contain a search or matching process.

The extensive margin specification estimates a linear probability model of the form

$ "Transition"_i = delta_1 "AI"_o times "Post"_i + delta_2 "Junior"_i times "AI"_o times "Post"_i + bold(X)_i' eta + alpha_o + gamma_(s(i)) + epsilon_i $ <eq:extensive>

where $"Transition"_i$ equals one if origin-position observation $i$ is followed by another position; $bold(X)_i$ includes lower-order interactions; and $s(i)$ indexes the origin start month. The coefficient $delta_1$ captures the senior AI-exposure effect after ChatGPT, while $delta_2$ captures the additional junior effect. Conditional on transition, I estimate seniority gains using

$ Delta "Seniority"_i = theta_1 "AI"_o times "Post"_i + theta_2 "Junior"_i times "AI"_o times "Post"_i + bold(X)_i' mu + alpha_o + gamma_(tau(i)) + u_i $ <eq:intensive>

where $tau(i)$ is the transition month. I also use log salary change and occupation switching as intensive-margin outcomes.

All mobility specifications include occupation and month fixed effects. The occupation fixed effects absorb permanent differences across occupations, including the level of AI exposure. The month fixed effects absorb common time shocks. Identification therefore comes from whether junior and senior workers in more exposed occupations change differentially after ChatGPT.

Because the intensive-margin regressions condition on transition, I also report a #cite(<Heckman1979>, form: "prose") two-step correction. The concern is that the set of workers who transition after ChatGPT may not be random. For example, if weaker juniors are displaced and only stronger juniors move successfully, the observed seniority gain could overstate true upgrading. The selection equation uses the main regressors, occupation fixed effects, and a firm-level exclusion restriction: the pre-period mean separation rate at the origin firm, entered directly and interacted with junior status. The logic is that firms with historically high turnover create more transitions, but conditional on moving, their historical separation rate should not directly determine the seniority gain in the next job. I estimate the probit on a 10 percent user-id subsample and include the inverse Mills ratio in the outcome equation. The corrected standard errors do not include Murphy--Topel or bootstrap adjustment, so they should be read cautiously.



// 3.2 Identification Strategy 部分
== Identification Strategy

The causal interpretation rests on two conditions. First, exposure must not be shaped by post-treatment labour-market adjustment. This holds by construction for the LLM exposure score, which is based on pre-existing O\*NET task descriptions rather than firm adoption decisions. This differs from firm-level AI adoption measures, which may respond to workforce composition.

Second, the timing of the shock should be plausibly unanticipated. @fig:googletrend shows that public attention to "ChatGPT" was essentially zero before its release on 30 November 2022 and rose sharply afterward. I therefore use 2022H2 as the omitted period in @eq:eventstudy and define the compositional-shift post period from 2023H1 onward.

#figure(
  image("../output/figures/chatgpt_trend.png", width: 70%),
  caption: [Google Trends index for the keyword "ChatGPT", 2019--2025],
) <fig:googletrend>

The key identifying assumption is parallel evolution of junior hiring shares across exposure levels absent generative AI. I assess this using the pre-treatment event-study coefficients and a formal linear pre-trend test following #cite(<freyaldenhoven2019>, form: "prose").

Two limitations remain. I cannot include firm $times$ time fixed effects because treatment varies at the occupation level. Therefore, firm-level shocks correlated with occupation exposure cannot be fully ruled out. I also hold the junior--senior threshold fixed, although AI may change expertise requirements within occupations over time. Finally, the COVID period remains in the pre-period. Half-year and month fixed effects absorb common pandemic shocks, and the event study checks whether exposed occupations were already diverging before ChatGPT.







= Results


I first document the main compositional result: the junior share of new hires falls in more AI-exposed occupations after ChatGPT. I then examine mobility outcomes to understand how workers adjust after the shock.

This result is related to the firm-level evidence in #cite(<klein2025generative>, form: "prose"), but the empirical margin is different. That study focuses on firm-level employment outcomes, while my main outcome is the junior hiring share within occupation--half-year cells. The estimates are therefore not directly comparable, but both point to junior workers bearing an important part of the early adjustment.

== Compositional Shift

@fig-junior-share plots the monthly junior share of new position starts for occupations above and below the median AI exposure score. Before late 2022, both series are stable, with the high-exposure group around 55 per cent and the low-exposure group around 85 per cent. From early 2023, the high-exposure series falls sharply, dropping below 40 per cent by late 2025, while the low-exposure series declines only modestly. The timing is closely aligned with the diffusion of generative AI.

#figure(
  image("../output/figures/junior_share_monthly_2019window.png", width: 95%),
  caption: [Monthly junior share of new position starts by AI exposure group. Junior defined as seniority $<= 2$ (Revelio Labs classification). AI exposure median split at 0.366 (#cite(<GPTs_are_GPTs>, form: "prose")). Vertical dashed line marks ChatGPT release (November 2022).]
) <fig-junior-share>

The pooled difference-in-differences estimate in @tab-pooled-did is $-0.096$ ($t=-8.71$). Thus, after ChatGPT, occupations with higher exposure experience a larger decline in the junior hiring share. A full-scale increase in exposure corresponds to a 9.6 percentage-point reduction.

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
    [$"AI"_o times "Post"_t$], [$-0.096$], [$0.011$], [$-8.71$], [$[-0.117, -0.074]$],
    table.hline(stroke: 0.8pt),
  ),
  caption: [
    Pooled difference-in-differences estimate. Dependent variable: junior hiring share at the occupation--half-year level, weighted by cell size. Occupation and half-year fixed effects absorbed. Standard errors clustered at the O\*NET code level. Estimation window: 2019H1--2025H2. $N = 12,760$.
  ],
  kind: table,
) <tab-pooled-did>

The event study in @fig-event-study provides the main identification check. The pre-treatment coefficients fluctuate around zero with no clear trend, and the 2022H1 coefficient is small and insignificant ($-0.005$, $p=0.44$). There is a mild positive hump during 2019H2--2020H2, plausibly related to COVID-era differences across white-collar occupations, but it disappears before the treatment window. A formal linear pre-trend test following #cite(<freyaldenhoven2019>, form: "prose") also gives an essentially zero slope. After 2023H1, the coefficients turn negative and grow in magnitude: $-0.064$ in 2023H1, $-0.103$ in 2024H1, and $-0.115$ by 2025H2. All post-period estimates are significant at the 1 per cent level. The post-treatment decline is larger and more persistent than the pre-period fluctuations. The quarterly event study in Appendix @fig-event-study-Quarterly shows a similar timing pattern.

#figure(
  image("../output/figures/event_study_baseline_2019window.png", width: 95%),
  caption: [Event study: effect of AI exposure on junior share of new position starts. Each point represents the estimated coefficient $hat(beta)_k$ from @eq:eventstudy. Estimation window: 2019H1--2025H2. Baseline period: 2022H2. Standard errors clustered at the O\*NET code level; shaded area shows 95% confidence interval.]
) <fig-event-study>

Overall, the evidence supports the first model prediction: high-exposure occupations experience a sustained decline in the junior share of new hires after the diffusion of generative AI.

The magnitude is economically meaningful. By 2025H2, the event-study estimate implies an 11.5 percentage-point lower junior hiring share for a fully exposed occupation relative to the baseline period. Even though the full zero-to-one exposure change is large, the direction and timing are clear: the break occurs after ChatGPT becomes widely known and continues through the post period.

The event-study design is important here because the pooled estimate alone would be hard to interpret if high- and low-exposure occupations were already on different paths. The absence of a clear pre-trend does not prove the identifying assumption, but it makes the post-period break more credible. It also helps separate the AI-related decline from the temporary COVID-era fluctuations visible earlier in the sample.


=== Robustness Check


Appendix @B reports robustness checks. The result is similar using the AI Occupational Exposure index of #cite(<felten2021occupational>, form: "prose") and under a binary exposure split. The AI Applicability Score of #cite(<tomlinson2025working>, form: "prose") gives a smaller and insignificant estimate, which is less surprising because it is based on observed usage rather than pre-determined task exposure. This measure may capture adoption frictions as well as exposure. Varying the junior cutoff shows that the effect is strongest at the baseline definition, seniority $lt.eq 2$, and weaker when junior is defined only as level 1 or expanded to level 3. I therefore interpret the baseline result as evidence about workers below the expertise threshold, not about one exact job-title category.








== Career Mobility 

I next examine career mobility. These estimates are not direct tests of the static model, but they show how workers adjust after the compositional shift. I study transition probability, seniority gains, log salary changes, and occupation switching.

This worker-level analysis is useful for two reasons. First, a fall in the junior hiring share does not show what happens to workers who are already in exposed occupations. Second, gross flows may reveal reallocation even when net occupation-level employment changes are small. The mobility results should therefore be read as descriptive evidence on adjustment margins rather than as structural estimates of the model.

=== Extensive Margin: Who Moves?

@tab:transition reports the extensive-margin results. The coefficient on $"AI" times "Post"$ is $0.548$, implying a 9.7 percentage-point increase in senior transition probability for a one-standard-deviation increase in exposure. This pattern is consistent with higher outside options and poaching for senior workers, but it could also reflect exits from worse matches. I therefore interpret it as increased gross senior reallocation, not as direct evidence on net senior employment. The triple interaction is $-0.660$, so the AI-specific mobility gradient is weaker for juniors. Combining the two treatment terms gives about $-0.11$ per full-scale unit, or $-2.0$ percentage points for a one-standard-deviation increase. This is a relative AI-exposure effect, not an absolute decline in junior mobility, because the common post-period movement and the junior-specific post effect are also part of the total transition probability. The result is almost unchanged when excluding recent position starts ($-0.662$), suggesting that short-run right-censoring is not driving the estimate.

This pattern is consistent with the model's junior-displacement logic, but the senior-side interpretation is more cautious. The model predicts higher senior labour demand, whereas the empirical outcome here is a gross transition probability. A senior transition can be a move into a better match, but it can also be an exit from a weaker match. For this reason, I treat the extensive-margin result as evidence of reallocation rather than as a direct test of senior employment growth.

#include "../output/tables/table2_extensive_margin.typ"





=== Intensive Margin: Transition Outcomes

Conditional on transition, @tab:mobility shows larger seniority gains for juniors leaving high-exposure occupations after ChatGPT. The baseline triple interaction is $0.122$, meaning that transitioning juniors in more exposed occupations move to higher-seniority roles relative to the comparison groups. The firm separation rate is a strong first-stage predictor of transition, and after Heckman correction the coefficient remains $0.125$. The inverse Mills ratio is negative ($-0.129$), which suggests negative selection on the outcome dimension: workers more likely to transition tend to have smaller seniority gains. The stability of the treatment coefficient is therefore more important than the exact corrected standard error, and it points toward genuine skill-upgrading among transitioning juniors.

The salary and occupation-switching results are weaker. The triple interaction for log salary change is small and insignificant ($0.007$, $t=0.51$), even after controlling for seniority gains. The occupation-switching interaction is also small and insignificant ($-0.008$, $t=-0.61$). Thus, the post-ChatGPT adjustment appears mainly in hiring composition and seniority progression rather than in wage compression or occupational flight.

The occupation-switching null is useful because it weighs against a simple story in which junior workers respond to AI exposure by leaving exposed occupations entirely. Instead, workers who move appear to remain in related occupational space while changing seniority level. This fits the idea that the early adjustment is within occupation, not only between occupations.

The wage null should also be read carefully. The theoretical model predicts wage movements, but Revelio salaries are predicted rather than directly observed compensation. It is therefore possible that true price effects are noisy or delayed in this dataset. The stronger evidence in this paper is on the quantity and composition margins.

#include "../output/tables/table1_mobility_regressions.typ"




///
/// 
/// Discussion
/// 
/// 
= Discussion
A natural question arising from the results is why I do not detect the wage movements predicted by the theoretical framework. In the model, junior employment falls because $w_J$ falls, and senior employment rises because $w_S$ rises. A high labour supply elasticity $epsilon$ can make these wage movements small relative to the quantity response, but it does not remove the price response altogether. The absence of a detected wage effect should therefore be interpreted as a limitation of the empirical test rather than as direct confirmation of the wage predictions of the model. One important caveat is that the salary data from Revelio Labs are predicted values, imputed from job titles, locations, and company characteristics, rather than actual reported compensation. This means that the wage evidence is available, but less reliable than the employment and mobility measures. It is worth noting that #cite(<lichtinger_generative_2025>, form: "prose"), who draw on the same Revelio Labs data infrastructure, do not report any wage-based analysis, which may itself reflect an awareness of this limitation. A more precise test of the price channel is therefore an important direction for future research, especially with administrative wage records or other datasets containing reliable individual compensation.

The Heckman correction in the mobility analysis provides a further window into mechanisms beyond the formal model. The estimated inverse Mills ratio is negative ($hat(lambda) = -0.129$), indicating that workers with higher unobserved propensity to transition tend to experience smaller seniority gains upon moving. In the standard parameterisation, this implies negative selection on the outcome dimension: the unobservables that make a worker more likely to transition are associated with _worse_, not better, destination matches. The key finding, however, is that the triple-interaction point estimate is virtually unchanged after correction ($0.125$ versus $0.122$ in the baseline). Since the reported standard errors in the corrected columns do not include Murphy--Topel or bootstrap adjustment, the precision of these estimates may be overstated. I therefore place more weight on the stability of the point estimate than on the exact corrected standard error. The preferred empirical interpretation is one of genuine skill-upgrading among transitioning juniors: AI tools may help capable junior workers in exposed occupations build competencies faster, enabling larger seniority gains upon transition. The occupation-switching null reinforces this reading — junior workers in high-exposure occupations are not fleeing to unrelated fields but moving upward within the same occupational domain. Because the theoretical framework treats junior and senior workers as fixed types, this result should be viewed as a complementary career-progression finding rather than as a formal model prediction.

The extensive-margin results merit further discussion. Senior workers in high-AI-exposure occupations become substantially more mobile after ChatGPT, while the AI-specific mobility gradient is weaker for junior workers. This does not mean that junior transition probabilities fell in absolute terms: the positive $"Junior" times "Post"$ coefficient indicates a positive junior-specific post differential relative to seniors, while $beta_4 + beta_5$ only captures how this differential changes with AI exposure. One natural concern is whether increased senior mobility should be read as evidence for the model's prediction that senior employment rises ($partial n_S slash partial A > 0$). The answer is no: the extensive-margin estimate captures gross transitions, not inflows, outflows, or stocks. A senior transition can reflect poaching into a better match, which would be consistent with augmentation. It can also reflect exit from deteriorating conditions in exposed occupations. Distinguishing these mechanisms would require constructing occupation-level inflows, outflows, and net senior headcount changes from the position start and end dates. Such an analysis is feasible with a richer use of the Revelio Labs position data, but lies beyond the scope of the current paper. A related limitation is right-censoring. Excluding very recent position starts shows that the estimates are not driven mechanically by the final months of the panel, but it is a weak diagnostic for censoring that is spread across the post-period. A stronger test would impose a common potential follow-up window, such as retaining only positions with at least 24 months of possible observation, or estimate a duration model that treats ongoing spells as censored. I therefore interpret senior mobility as evidence of increased reallocation among senior workers, not as a standalone confirmation of senior augmentation.

A broader concern for this literature is the lack of consensus on how to measure occupational exposure to AI. #cite(<gimbel2026labor>, form: "prose") document that the most widely used indices — including those of #cite(<GPTs_are_GPTs>, form: "prose"), #cite(<felten2021occupational>, form: "prose"), and #cite(<webbImpactArtificialIntelligence>, form: "prose") — disagree substantially on which occupations are most exposed, reflecting differences in whether exposure is defined through task descriptions, technical benchmarks, or patent-based measures. This motivates my use of three methodologically distinct indices: the primary LLM exposure score based on expert and GPT-4 assessment of task-level automation potential, the AI Occupational Exposure index derived from mapping AI capabilities to occupational abilities, and the AI Applicability Score constructed from revealed usage patterns in real-world AI interactions. If the main findings hold across all three, this substantially strengthens the confidence that the results are not driven by a particular measurement choice. A separate data limitation concerns the representativeness of the Revelio Labs sample. Because the data are drawn from public LinkedIn profiles, the sample likely over-represents white-collar, professional occupations relative to the working population as a whole. Since LLM exposure is concentrated in precisely such occupations, this sample composition may amplify the estimated effects relative to what a nationally representative survey would yield.

The AI Applicability Score also deserves a cautious interpretation. Unlike the Eloundou and Felten measures, it is based on observed Copilot use during the post-treatment period. This makes it useful as a revealed-use comparison, but weaker as an exogenous exposure measure. Its weaker result therefore does not overturn the main finding based on pre-determined task exposure.

Finally, as noted in Section 3, the seniority threshold separating junior from senior workers is held fixed throughout the analysis, yet AI may itself reshape expertise requirements within occupations, shifting this boundary endogenously over time. Modelling such a response would require the between-occupation general equilibrium framework of #cite(<NBERw33941>, form: "prose") and is left for future work. More broadly, the estimates presented here capture the early stages of generative AI diffusion. The capabilities of the technology are expanding rapidly — from text-based assistance toward autonomous task execution — and the occupational task bundles that define current exposure scores may not remain stable as these capabilities evolve. Whether the compositional shifts documented in this essay persist, intensify, or reverse as firms and workers adapt over a longer horizon remains an open question, and one that longer post-treatment panels will be well placed to address.

///
/// 
/// Conclusion
/// 
/// 
= Conclusion


This essay has argued that aggregate null results for AI's employment effects conceal meaningful compositional shifts within occupations. Extending the expertise framework of #cite(<NBERw33941>, form: "prose") to permit within-occupation task specialisation, I derive formal predictions for how AI capability improvements affect junior employment shares, senior marginal products, wages, and net occupation-level employment. The evidence is strongest for the model's junior compositional prediction: in occupations more exposed to large language models, the junior hiring share declines. The worker-level mobility results provide complementary evidence on adjustment margins beyond the static model. Juniors who transition achieve larger seniority gains, consistent with genuine skill-upgrading, while senior workers become substantially more mobile. These results should be interpreted as career-progression and gross-reallocation patterns rather than direct tests of formal model predictions. By contrast, I do not detect the wage movements predicted by the formal model in the Revelio predicted salary data, so the price-margin results should be interpreted cautiously.

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

The representative firm in the occupation takes output price $p$ and factor prices $w_J$, $w_S$, $r$ as given, and chooses AI capital $M$, junior labour in task $L$ ($n_J^L$), junior labour in task $G$ ($n_J^G$), and senior labour $n_S$ to maximise profit:

$ max_(M, n_J^L, n_J^G, n_S) quad p dot.c Y - w_J (n_J^L + n_J^G) - w_S n_S - r M $

where output $Y$ is the CES aggregate defined in @eq-ces, and the three task production functions are given by @eq-tasks.

Substituting the CES structure, the marginal revenue product of task $k in {L, H, G}$ is:

$ p dot.c frac(partial Y, partial y_k) = p dot.c beta_k lr((frac(Y, y_k)))^(1 / sigma) $ <eq-mrp>

The first-order conditions for an interior solution are:

$ p dot.c beta_L lr((frac(Y, y_L)))^(1 / sigma) dot.c A = r $ <eq-foc-m>

$ p dot.c beta_L lr((frac(Y, y_L)))^(1 / sigma) dot.c a_L = w_J $ <eq-foc-njl>

$ p dot.c beta_G lr((frac(Y, y_G)))^(1 / sigma) dot.c c = w_J $ <eq-foc-njg>

$ p dot.c beta_H lr((frac(Y, y_H)))^(1 / sigma) dot.c b_H = w_S $ <eq-foc-ns>

*Derivation of the no-arbitrage condition.* Dividing @eq-foc-m by @eq-foc-njl:

$ frac(A, a_L) = frac(r, w_J) quad => quad w_J = frac(a_L dot.c r, A) $

Since AI and junior labour are perfect substitutes in task $L$, the firm employs both only when their unit costs are equalised. This condition pins junior wages entirely as a function of AI capability $A$ and the rental rate $r$, independently of conditions in tasks $H$ and $G$.

*Derivation of the constant task output ratio.* Dividing @eq-foc-njl by @eq-foc-njg:

$ frac(beta_L lr((Y slash y_L))^(1 / sigma) dot.c a_L, beta_G lr((Y slash y_G))^(1 / sigma) dot.c c) = 1 $

Simplifying:

$ frac(beta_L a_L, beta_G c) dot.c lr((frac(y_G, y_L)))^(1 / sigma) = 1 quad => quad frac(y_G, y_L) = lr((frac(beta_G c, beta_L a_L)))^sigma equiv gamma $

The ratio $gamma$ is a structural constant determined by technology and task share parameters. Intuitively, both tasks $L$ and $G$ are produced using the same marginal factor (junior labour at wage $w_J$), so their marginal costs move simultaneously. The CES demand system then fixes their output ratio regardless of $A$.

*Senior wage expression.* From @eq-foc-ns directly:

$ w_S = p dot.c beta_H lr((frac(Y, y_H)))^(1 / sigma) dot.c b_H $

This is the marginal revenue product of senior labour in task $H$.


== Senior Allocation to Task H<A2>

The main text writes task $G$ as a junior-assigned generic task and therefore abstracts from senior production of $G$. This is a simplifying modelling restriction, not a separate empirical claim. It can be interpreted as the corner solution of a more general model in which senior workers could perform generic support tasks but face a higher opportunity cost of time.

If a senior worker were reallocated to task $G$, the return would be no higher than the marginal revenue product of junior workers in task $G$, which by @eq-foc-njg is exactly $w_J$. The return to senior labour in task $H$ is $w_S$. Senior allocation to task $H$ is therefore consistent with optimisation whenever $w_S > w_J$, that is:

$ p dot.c beta_H lr((frac(Y, y_H)))^(1 / sigma) dot.c b_H > frac(a_L dot.c r, A) $

This condition holds when task $H$ is sufficiently valued relative to routine and generic support tasks. This is empirically plausible: in the Revelio Labs data, salaries for senior positions (seniority $>=$ 5) substantially exceed those for entry-level positions (seniority $<=$ 2) within the same O\*NET occupation. I maintain $w_S > w_J$ as a regularity condition throughout.


== Comparative Statics<A3:comparative>

I derive the effects of an increase in AI capability $A$ on the equilibrium allocation in four steps.

*Step 1: Junior wage and employment*

From the no-arbitrage condition:

$ frac(partial w_J, partial A) = - frac(a_L r, A^2) < 0 $

Substituting into the supply function (@eq-supply):

$ n_J = phi_J lr((frac(a_L r, A)))^epsilon quad => quad frac(partial n_J, partial A) = - epsilon phi_J (a_L r)^epsilon A^(-(epsilon + 1)) < 0 $
An increase in AI capability monotonically reduces both the wage and employment of junior workers in the occupation. The magnitude of the employment response is governed by the supply elasticity $epsilon$: when $epsilon$ is large, even a small decline in $w_J$ induces substantial exit. Pinning down the precise value of $epsilon$ is beyond the scope of this essay; the key qualitative prediction — that junior employment falls with AI capability — holds for any $epsilon > 0$.

*Step 2: Task output levels*

To characterize how task outputs respond to $A$, I reduce the model's dimensionality. Since $y_G = gamma y_L$ with $gamma$ constant, I define $tilde(beta)_L equiv beta_L + beta_G gamma^((sigma - 1) / sigma)$ and write the CES aggregate as a function of two effective task outputs:

$ Y = lr([tilde(beta)_L y_L^((sigma - 1) / sigma) + beta_H y_H^((sigma - 1) / sigma)])^(sigma / (sigma - 1)) $ <eq-ces-reduced>

In this reduced representation, the full marginal value of increasing $y_L$ includes the induced increase in $y_G = gamma y_L$. The shadow price of the effective low-expertise task bundle is therefore:

$ p dot.c tilde(beta)_L lr((frac(Y, y_L)))^(1 / sigma) = frac(r, A) $

This differs from the original three-task FOC in @eq-foc-m, where $beta_L$ captures the direct marginal value of AI-generated task $L$ output. Once the optimal relation $y_G = gamma y_L$ is imposed, $tilde(beta)_L$ captures the full marginal value of the combined low-expertise and generic task bundle. The condition implicitly defines the demand for $y_L$ as a function of $y_H$ and $A$. Holding $y_H$ fixed, an increase in $A$ reduces the effective marginal cost of task $L$ output ($r slash A$), which by CES demand raises $y_L$. Since $y_G = gamma y_L$, task $G$ output rises proportionally.

To verify that total output $Y$ rises: from @eq-ces-reduced, $Y$ is increasing in both $y_L$ and $y_H$. Since $y_L$ increases and $y_H$ is (initially) unchanged, $Y$ unambiguously increases.

*Step 3: Senior augmentation*

I establish that the demand curve for senior labour shifts outward when $A$ increases, and that the equilibrium senior wage and employment both rise.

Define the inverse demand for senior labour, holding $A$ fixed:

$ w_S^D (n_S; A) equiv p dot.c beta_H lr((frac(Y(n_S, A), b_H n_S)))^(1 / sigma) dot.c b_H $ <eq-inverse-demand>

where $Y(n_S, A)$ is total output evaluated at the optimal task allocation for given $n_S$ and $A$.

*Claim 1: $w_S^D$ is decreasing in $n_S$*. An increase in $n_S$ raises $y_H = b_H n_S$ and hence $Y$. However, $y_H$ rises proportionally with $n_S$, while $Y$ exhibits diminishing returns to $y_H$ under the CES structure ($sigma < infinity$). Consequently, $Y slash (b_H n_S)$ falls, and so does $w_S^D$.

*Claim 2: $w_S^D$ is increasing in $A$*. Holding $n_S$ fixed, an increase in $A$ reduces the marginal cost of task $L$, raising $y_L$ and $y_G = gamma y_L$. Since $y_H = b_H n_S$ is unchanged, $Y$ increases while $y_H$ does not, so $Y slash (b_H n_S)$ rises and $w_S^D$ rises.

*Equilibrium effect.* The demand curve $w_S^D (n_S; A)$ is downward-sloping and shifts outward when $A$ rises. The supply curve $n_S = phi_S w_S^epsilon$ is upward-sloping. Standard comparative statics of supply-demand intersection imply that the new equilibrium features both higher $w_S$ and higher $n_S$:

$ frac(partial w_S, partial A) > 0, quad frac(partial n_S, partial A) > 0 $

The increase in $n_S$ also raises $y_H = b_H n_S$ in equilibrium. This feedback lowers $Y slash y_H$ relative to the impact effect at fixed $n_S$, but it does not overturn the comparative static because the senior labour demand curve has shifted outward. This confirms the augmentation result: AI capability improvements raise senior wages and senior employment via CES task complementarity.

*Step 4: Compositional shift*

Define the junior employment share as $s_J equiv n_J slash (n_J + n_S)$. From Steps 1 and 3, $partial n_J slash partial A < 0$ and $partial n_S slash partial A > 0$. Both the numerator and denominator of $s_J$ are affected, the junior employment share unambiguously declines.

*Internal reallocation of junior labour*

Although total junior employment falls, the allocation of remaining juniors between tasks $L$ and $G$ also shifts. From $y_G = gamma y_L$ and $y_G = c dot.c n_J^G$:

$ n_J^G = frac(gamma y_L, c) $

Since $y_L$ is increasing in $A$ (Step 2), $n_J^G$ increases. Combined with declining total junior employment ($n_J$ falls), this implies:

$ n_J^L = n_J - n_J^G $

which falls faster than $n_J$ itself. Junior workers are squeezed out of task $L$ on two margins: AI directly substitutes their labour, and the remaining juniors reallocate toward task $G$ where AI cannot substitute.


The above derivations assume an interior solution in which $n_J^L > 0$. For sufficiently large $A$, all junior workers exit task $L$ and produce only task $G$ output. I focus on the interior case, which is empirically relevant given that junior workers remain present in high-exposure occupations throughout the sample period.



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
    columns: (auto, auto, auto, auto, auto,),
    align: (left, left, center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header(
      [*Specification*], [*Treatment*], [*Junior def.*],
      [*Coefficient*], [*Std. error*],
    ),
    table.hline(stroke: 0.5pt),
    [Main],            [z(Eloundou)],      [$lt.eq 2$], [$-0.021^(***)$], [$(0.002)$], 
    [R1: Felten],      [z(Felten)],        [$lt.eq 2$], [$-0.018^(***)$], [$(0.003)$],
    [R2: Tomlinson],   [z(Tomlinson)],     [$lt.eq 2$], [$-0.005$], [$(0.003)$], 
    [R3: Seniority 1], [z(Eloundou)],      [$lt.eq 1$], [$-0.003$], [$(0.003)$],
    [R4: Seniority 3], [z(Eloundou)],      [$lt.eq 3$], [$-0.009^(***)$], [$(0.003)$],
    [R5: Binary],      [Binary(Eloundou)], [$lt.eq 2$], [$-0.039^(***)$], [$(0.005)$],
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


#figure(
  image("../output/figures/event_study_baseline.png", width: 85%),
  caption: [
    Extended-window event study using 2018H1--2025H2. The omitted baseline is 2022H2. This specification is reported as a robustness check because position starts before 2019 may be affected by left-censoring from the construction of the position sample.
  ],
) <fig-event-study-2018-window>



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
    Event study coefficients from @eq:eventstudy. The dependent variable is the junior hiring share at the occupation--half-year level, weighted by cell size. The estimation window is 2019H1--2025H2. The omitted baseline is 2022H2. Standard errors clustered at the O\*NET code level (917 clusters).
  ],
  kind: table,
) <tab-event-study>




#figure(
  image("../output/figures/event_study_quarterly.png", width: 70%),
  caption: [Supplementary quarterly event study using the extended 2018Q1--2025Q4 window. The figure is used as a timing check for the onset of the post-ChatGPT decline.]
) <fig-event-study-Quarterly>
