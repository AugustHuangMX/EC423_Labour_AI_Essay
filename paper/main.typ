// ============================================================
//  MAIN BODY
// ============================================================

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








= Data

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




= Discussion

Notice that research on the impact of AI on labour markets is still in its infancy, and there are many open questions about the mechanisms through which AI affects workers. One important argument is that we still couldn't find a consistent and convincing exposure measure for AI, which is crucial for empirical analysis. The most recent commonly used measurements can't broadly agree with each other on highly exposed occupations, making it hard to draw robust conclusions about the impact of AI on labour markets @gimbel2026labor.

= Conclusion
