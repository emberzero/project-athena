#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (15mm, 10mm),
    node-stroke: none,

    dbox((1, 0), [Forest root domain\ `example.com`\ Schema + Config NC], fill: fill-accent),
    dbox((2, 0), [`partner.example.net`\ (separate forest)], fill: fill-neutral),
    edge((1, 0), (2, 0), "<->", label: [forest\ trust], label-size: 7pt),

    dbox((0, 1), [`eu.example.com`]),
    dbox((2, 1), [`lab.example.com`]),
    edge((1, 0), (0, 1), "-", label: [child], label-size: 7pt),
    edge((1, 0), (2, 1), "-"),

    dbox((0, 2), [`OU=Workstations`\ GPO linked here]),
    dbox((1, 2), [`OU=Servers`]),
    edge((0, 1), (0, 2), "-"),
    edge((0, 1), (1, 2), "-"),
  )

  #block(width: 112mm)[#dnote[
    The forest trust to `partner.example.net` is filtered with SID filtering. The
    domain is a replication and policy boundary; the forest is the security
    boundary, because every domain in a forest shares one schema and trusts the
    others transitively. Compromising any DC in the forest therefore puts the
    whole forest at risk.
  ]]
]
