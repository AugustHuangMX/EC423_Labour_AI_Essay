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
#let essay-title     = "Canaries in Every Mine?  Offsetting Effects of AI on Junior and Senior Workers within Occupations"  // Your essay title
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
  _Your abstract goes here._
]

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


= Theoretical Framework

Consider a single occupation producing output $Y$, by two types of tasks:

- Task $L$: Low expertise, including routine jobs, easy be replaced by AI automation.
- Task $H$: High expertise, including context-dependent tasks, management tasks, and other tasks requiring accumulated experience.


The output $Y$ follows a CES aggregation: 

$
Y = [beta y_L ^((sigma-1)/sigma) + (1-beta)y_H^((sigma-1)/(sigma) )]^((sigma)/(sigma-1))
$

where $sigma$ is the within-occupation elasticity of substitution between the two types of tasks, which is distinct from the between-occupation elasticity in #cite(<NBERw33941>, form: "prose"), and $beta$ is the share of low-expertise tasks in the occupation.




= Literature Review





== Empirical Evidence



= Analysis

== Data

The data I used here is the positions dataset provided by Revelio Labs, which contains detailed information on job postings in the UK, including the O*NET codes for each occupation. For analysis, I used data from 2019 to 2025, which allows me to capture the period before and after the release of major generative AI tools in late 2022.

= Discussion

Notice that research on the impact of AI on labour markets is still in its infancy, and there are many open questions about the mechanisms through which AI affects workers. One important argument is that we still couldn't find a consistent and convincing exposure measure for AI, which is crucial for empirical analysis. The most recent commonly used measurements can't broadly agree with each other on highly exposed occupations, making it hard to draw robust conclusions about the impact of AI on labour markets @gimbel2026labor.

= Conclusion

// ============================================================
//  REFERENCES (not counted in word limit)
// ============================================================
#pagebreak()
#bibliography("refs.bib", title: "References", style: "apa")

#set par(
  first-line-indent: 0em,
  hanging-indent: 1.5em,   // hanging indent for bibliography entries
)

// Add references in author-year (Harvard / APA) format, e.g.:
// Acemoglu, D. and Restrepo, P. (2020) 'Robots and Jobs: Evidence from US Labor Markets', _Journal of Political Economy_, 128(6), pp. 2188–2244.

// ============================================================
//  APPENDICES (not counted in word limit)
// ============================================================
// Uncomment below if needed:
// #pagebreak()
#heading(numbering: none)[Appendix]
// #set heading(numbering: "A.1")
// Your appendix content here.
