#figure(
  {
    set text(size: 9pt)
    table(
      columns: 3,
      align: (left, center, center),
      stroke: none,
      column-gutter: 0.8em,

      table.hline(stroke: 0.8pt),
      table.header(
        [],
        [*Full Sample*],
        [*Excluding Recent*],
      ),
      table.hline(stroke: 0.5pt),

      [Junior],
        [--0.075\*\*\*], [--0.044\*\*\*],
      [],
        [(0.010)], [(0.010)],

      [Junior $times$ AI],
        [0.205\*\*\*], [0.151\*\*\*],
      [],
        [(0.019)], [(0.018)],

      [Junior $times$ Post],
        [0.377\*\*\*], [0.370\*\*\*],
      [],
        [(0.009)], [(0.008)],

      [AI $times$ Post],
        [0.548\*\*\*], [0.567\*\*\*],
      [],
        [(0.028)], [(0.028)],

      [Junior $times$ AI $times$ Post],
        [--0.660\*\*\*], [--0.662\*\*\*],
      [],
        [(0.031)], [(0.029)],

      table.hline(stroke: 0.3pt),

      [_N_],
        [27,471,965], [24,531,422],
      [_R_#super[2]],
        [0.181], [0.158],
      [Occupation FE],
        [Yes], [Yes],
      [Month FE],
        [Yes], [Yes],

      table.hline(stroke: 0.8pt),
    )
  },
  caption: [Career mobility regressions: extensive margin (probability of job transition)],
  kind: table,
) <tab:transition>

#text(size: 8pt, style: "italic")[
  _Notes:_ Dependent variable is an indicator for whether the worker transitions to a new position. Column (1) uses the full sample; column (2) excludes positions starting after 2024m6 to assess censoring of recently started positions. All specifications are linear probability models with occupation and month fixed effects. Standard errors clustered at the O\*NET occupation level in parentheses. \*\*\* $p < 0.01$, \*\* $p < 0.05$, \* $p < 0.10$.
]
