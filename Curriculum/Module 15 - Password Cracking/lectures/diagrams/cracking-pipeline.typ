#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (8mm, 9mm),

    dbox((0, 0), [wordlist]),
    dbox((0, 1), [mask /\ keyspace]),
    dbox((1, 0.5), [candidate\ generator], fill: fill-accent),
    dbox((2, 0.5), [hash function\ + salt], fill: fill-accent),
    dbox((3, 0.5), [compare\ hashes]),
    dgood((4, 0.5), [cracked]),

    edge((0, 0), (1, 0.5), "->"),
    edge((0, 1), (1, 0.5), "->"),
    edge((1, 0.5), (2, 0.5), "->"),
    edge((2, 0.5), (3, 0.5), "->"),
    edge((3, 0.5), (4, 0.5), "->", label: text(size: 7.5pt)[hit]),
    edge((3, 0.5), (1, 0.5), "-->", bend: 40deg, label: text(size: 7.5pt)[miss]),

    dbox((1, 1.6), [rules /\ mangling], fill: fill-warn),
    edge((1, 1.6), (1, 0.5), "->"),
  )

  #block(width: 100mm)[#dnote[
    Every attack mode is the same loop; only the candidate generator changes.
    The hash function in the middle is the cost centre, which is why a slow
    KDF with a high cost parameter is the single most effective defence
    against offline cracking.
  ]]
]
