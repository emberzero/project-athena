#import "/utils/athena-diagram.typ": *

#let phase(title, who, detail) = [
  #strong(title) \
  #text(size: 7.5pt, fill: muted, who) \
  #text(size: 7.5pt, detail)
]

#diagram-page[
  #diagram(
    spacing: (10mm, 7mm),
    dbox((0, 0), phase("1. Preparation", [control team, test managers],
      [Project charter, scope and flags, \ select TI provider and testers]), width: 120mm),
    dbox((0, 1), phase("2a. Threat intelligence", [TI provider, about 4 weeks],
      [Targeted threat intelligence report, \ scenarios, red team test plan]), width: 120mm),
    dbad((0, 2), phase("2b. Red team test", [testers, at least 12 weeks],
      [Active testing against live production, \ blue team unaware, weekly updates]), width: 120mm),
    dgood((0, 3), phase("3. Closure", [all parties, blue team now informed],
      [Red and blue team reports, replay, \ purple teaming, summary report]), width: 120mm),
    dbox((0, 4), phase("Remediation and attestation", [entity, TLPT authority],
      [Remediation plan, attestation, \ next test in about three years]), width: 120mm),

    edge((0, 0), (0, 1), "-|>"),
    edge((0, 1), (0, 2), "-|>"),
    edge((0, 2), (0, 3), "-|>"),
    edge((0, 3), (0, 4), "-|>"),
  )

  #dnote[
    Phases as named in the updated TIBER-EU framework and the DORA TLPT standards,
    Delegated Regulation (EU) 2025/1190. Durations are the minimums or typical
    values given there; a full engagement usually takes most of a year.
  ]
]
