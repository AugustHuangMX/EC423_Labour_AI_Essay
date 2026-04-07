#figure(
  text(size: 9pt)[#table(
    columns: 3,
    column-gutter: 12pt,
    align: (left, center, center),
    stroke: none,
    inset: (x: 4pt, y: 4pt),

    // === 顶部粗线 ===
    table.hline(stroke: 0.8pt),

    // === 表头 ===
    [], [_Full sample_], [_Censoring-robust_],

    table.hline(start: 1, end: 3, stroke: 0.5pt),

    [], [(1)], [(2)],

    table.hline(stroke: 0.5pt),

    // === 系数 ===
    [Junior], [0.194#super[\*\*\*]], [0.194#super[\*\*\*]],
    [], [(0.038)], [(0.038)],

    [AI Exposure], [0.365#super[\*\*\*]], [0.365#super[\*\*\*]],
    [], [(0.053)], [(0.053)],

    [Post], [0.222#super[\*\*\*]], [0.333#super[\*\*\*]],
    [], [(0.031)], [(0.029)],

    [Junior $times$ AI Exp.], [--0.216#super[\*\*\*]], [--0.216#super[\*\*\*]],
    [], [(0.053)], [(0.053)],

    [Junior $times$ Post], [--0.145#super[\*\*\*]], [--0.168#super[\*\*\*]],
    [], [(0.030)], [(0.028)],

    [AI Exp. $times$ Post], [--0.373#super[\*\*\*]], [--0.352#super[\*\*\*]],
    [], [(0.044)], [(0.043)],


    [*Junior $times$ AI Exp. $times$ Post*], [*0.228*#super[\*\*\*]], [*0.229*#super[\*\*\*]],
    [], [*(0.042)*], [*(0.041)*],


    [Constant], [0.221#super[\*\*\*]], [0.221#super[\*\*\*]],
    [], [(0.037)], [(0.038)],

    table.hline(stroke: 0.5pt),

    // === 模型统计量 ===
    [_N_], [27,472,206], [24,531,424],
    [$R^2$], [0.009], [0.022],

    table.hline(stroke: 0.8pt),
  )

  #v(4pt)
  #text(size: 8pt)[*Note:* The dependent variable is an indicator for whether a position is followed by a transition to a different employer or occupation. Column (2) excludes positions with start dates after July 2024 to address potential right-censoring of ongoing positions. Cluster-robust standard errors in parentheses.]
  ],
  kind: table,
  
  caption: [Transition probability: triple-difference estimates],
) <tab:transition>