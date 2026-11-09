#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (12mm, 10mm),
    node-stroke: none,
    dbox((0, 0), [Door reader\ (13.56 MHz)]),
    dbad((1, 0), [Proxy\ "fake card"]),
    dbad((2, 0), [Proxy\ "fake reader"]),
    dbox((3, 0), [Victim card\ in a pocket]),

    edge((0, 0), (1, 0), "<->"),
    edge((1, 0), (2, 0), "<->"),
    edge((2, 0), (3, 0), "<->"),

    node((0.5, 0.45), text(size: 7.5pt, fill: muted)[NFC field]),
    node((1.5, 0.45), text(size: 7.5pt, fill: muted)[radio link]),
    node((2.5, 0.45), text(size: 7.5pt, fill: muted)[NFC field]),
  )

  #box(width: 120mm)[
    #dnote[
      The card answers a genuine challenge, so strong card cryptography does not stop this.
      What changes is the round-trip time.
    ]
  ]
]
