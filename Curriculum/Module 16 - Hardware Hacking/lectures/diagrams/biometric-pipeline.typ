#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (14mm, 8mm),
    node-stroke: none,
    dbox((0, 0), [Sensor\ capture]),
    dbox((0, 1), [Feature\ extraction]),
    dbox((0, 2), [Matcher\ (score vs. threshold)]),
    dbox((0, 3), [Accept /\ reject]),
    dbox((1, 1), [Template\ store], fill: fill-neutral),

    dbad((-1, 0), [Presentation\ attack: mould,\ photo, replay]),
    dgood((1, 0), [Liveness /\ PAD check]),
    dbad((1, 2), [Template theft,\ score tampering]),

    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->"),
    edge((0, 2), (0, 3), "->"),
    edge((1, 1), (0, 2), "->", label: [enrolled\ template], label-side: right),
    edge((-1, 0), (0, 0), "->"),
    edge((1, 0), (0, 0), "-->"),
    edge((1, 2), (1, 1), "-->"),
  )

  #dnote[Every arrow into the pipeline is an attack surface; the matcher decision is the asset.]
]
