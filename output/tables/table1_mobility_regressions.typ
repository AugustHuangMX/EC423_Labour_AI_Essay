#figure(
  text(size: 9pt)[#table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: (left, center, center, center, center, center, center),
    stroke: none,
    inset: (x: 6pt, y: 4pt),

    // === 顶部粗线 ===
    table.hline(stroke: 0.8pt),

    // === 一级表头 ===
    table.cell(rowspan: 2)[],
    table.cell(colspan: 2)[_#sym.Delta Seniority_],
    table.cell(colspan: 2)[_#sym.Delta ln Salary_],
    table.cell(colspan: 2)[_Occ. Switch_],

    table.hline(start: 1, end: 3, stroke: 0.5pt),
    table.hline(start: 3, end: 5, stroke: 0.5pt),
    table.hline(start: 5, end: 7, stroke: 0.5pt),

    // === 二级表头 ===
    [(1)], [(2)], [(3)], [(4)], [(5)], [(6)],

    table.hline(stroke: 0.5pt),

    // === Junior ===
    [Junior], [1.241#super[\*\*\*]], [1.197#super[\*\*\*]], [--0.042#super[\*\*]], [--0.042#super[\*\*]], [0.161#super[\*\*\*]], [0.180#super[\*\*\*]],
    [], [(0.069)], [(0.067)], [(0.019)], [(0.018)], [(0.047)], [(0.048)],

    // === AI Exposure ===
    [AI Exposure], [0.683#super[\*\*\*]], [0.591#super[\*\*\*]], [0.088#super[\*\*\*]], [0.087#super[\*\*\*]], [--0.143], [--0.103],
    [], [(0.127)], [(0.123)], [(0.030)], [(0.029)], [(0.093)], [(0.094)],

    // === Post ===
    [Post], [0.104#super[\*\*\*]], [0.063#super[\*\*\*]], [--0.032#super[\*\*\*]], [--0.033#super[\*\*\*]], [--0.004], [0.013],
    [], [(0.017)], [(0.018)], [(0.009)], [(0.008)], [(0.009)], [(0.009)],

    // === Junior × AI Exp. ===
    [Junior $times$ AI Exp.], [--0.329#super[\*\*\*]], [--0.274#super[\*\*]], [--0.005], [--0.004], [--0.120#super[\*]], [--0.143#super[\*\*]],
    [], [(0.109)], [(0.107)], [(0.030)], [(0.029)], [(0.072)], [(0.073)],

    // === Junior × Post ===
    [Junior $times$ Post], [--0.118#super[\*\*\*]], [--0.084#super[\*\*\*]], [0.039#super[\*\*\*]], [0.040#super[\*\*\*]], [--0.004], [--0.019#super[\*\*]],
    [], [(0.018)], [(0.018)], [(0.007)], [(0.007)], [(0.009)], [(0.008)],

    // === AI Exp. × Post ===
    [AI Exp. $times$ Post], [0.052#super[\*]], [0.144#super[\*\*\*]], [--0.110#super[\*\*\*]], [--0.108#super[\*\*\*]], [0.019], [--0.021],
    [], [(0.029)], [(0.031)], [(0.015)], [(0.015)], [(0.016)], [(0.016)],



    // === Triple-diff（关键系数，加粗） ===
    [*Junior $times$ AI Exp. $times$ Post*], [*0.124*#super[\*\*\*]], [*0.061*#super[\*]], [*--0.003*], [*--0.004*], [*--0.015*], [*0.012*],
    [], [*(0.034)*], [*(0.035)*], [*(0.013)*], [*(0.013)*], [*(0.015)*], [*(0.015)*],



    // === Δ Seniority（仅 Salary 列） ===
    [#sym.Delta Seniority], [], [], [0.202#super[\*\*\*]], [0.202#super[\*\*\*]], [], [],
    [], [], [], [(0.003)], [(0.003)], [], [],

    // === IMR（仅 Heckman 列） ===
    [IMR ($lambda$)], [], [--0.174#super[\*\*\*]], [], [--0.003], [], [0.075#super[\*\*\*]],
    [], [], [(0.019)], [], [(0.005)], [], [(0.011)],

    // === Constant ===
    [Constant], [--0.801#super[\*\*\*]], [--0.612#super[\*\*\*]], [0.068#super[\*\*\*]], [0.071#super[\*\*\*]], [0.688#super[\*\*\*]], [0.606#super[\*\*\*]],
    [], [(0.076)], [(0.074)], [(0.019)], [(0.017)], [(0.059)], [(0.063)],

    table.hline(stroke: 0.5pt),

    // === 模型统计量 ===
    [_N_], [12,487,869], [12,487,869], [10,676,912], [10,676,912], [12,487,869], [12,487,869],
    [$R^2$], [0.138], [0.139], [0.341], [0.341], [0.020], [0.022],
    [Heckman correction], [No], [Yes], [No], [Yes], [No], [Yes],

    table.hline(stroke: 0.8pt),
  )],
  kind: table,
  caption: [Career mobility regressions: triple-difference estimates],
) <tab:mobility>