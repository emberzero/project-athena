#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (10mm, 8mm),
    dbox((0, 0), [Identify]),
    dbox((1, 0), [Acquire]),
    dbox((2, 0), [Analyse]),
    dbox((3, 0), [Report]),

    edge((0, 0), (1, 0), "->"),
    edge((1, 0), (2, 0), "->"),
    edge((2, 0), (3, 0), "->"),

    dgood((1.5, 1), [Chain of custody \ + integrity hashes], width: 48mm),
    edge((1.5, 1), (0, 0), "--"),
    edge((1.5, 1), (3, 0), "--"),
  )

  #block(width: 125mm)[#dnote[
    The four phases run once, in order. The chain of custody and the hash of the
    acquired image are maintained across all of them: if either breaks, the
    evidence from that point on is no longer defensible.
  ]]
]
