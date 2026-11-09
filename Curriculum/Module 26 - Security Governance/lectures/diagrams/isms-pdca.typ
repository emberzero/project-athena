#import "/utils/athena-diagram.typ": *

#let stage(title, clauses, detail) = [
  #strong(title) #text(size: 7.5pt, fill: muted)[(#clauses)] \
  #text(size: 7.5pt, fill: muted, detail)
]

#diagram-page[
  #diagram(
    spacing: (14mm, 12mm),
    dbox((0, 0), stage([Plan], [cl. 4-6], [Scope, policy, roles \ risk assessment \ SoA, treatment plan]), width: 46mm),
    dbox((1, 0), stage([Do], [cl. 7-8], [Implement controls \ awareness, documents \ run risk treatment]), width: 46mm),
    dbox((1, 1), stage([Check], [cl. 9], [Monitoring, metrics \ internal audit \ management review]), width: 46mm),
    dbox((0, 1), stage([Act], [cl. 10], [Nonconformities \ corrective action \ improvement]), width: 46mm),

    node((0.5, 0.5), text(size: 7.5pt, fill: muted)[ISMS], stroke: none),

    edge((0, 0), (1, 0), "-|>"),
    edge((1, 0), (1, 1), "-|>"),
    edge((1, 1), (0, 1), "-|>"),
    edge((0, 1), (0, 0), "-|>"),
  )

  #dnote[
    PDCA is the usual way to explain an ISMS. ISO/IEC 27001:2022 itself is
    organised in clauses 4-10; the mapping above is a teaching aid, not text
    from the standard. The cycle never ends: each review starts the next plan.
  ]
]
