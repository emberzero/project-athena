#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (15mm, 10mm),
    dbox((0, 0), [Client \ Tor Browser], width: 24mm),
    dbox((1, 0), [Guard \ relay], width: 22mm),
    dbox((2, 0), [Middle \ relay], width: 22mm),
    dbox((3, 0), [Exit \ relay], width: 22mm),
    dbox((3, 1), [Website], width: 22mm),

    edge((0, 0), (1, 0), "->", label: [3 layers]),
    edge((1, 0), (2, 0), "->", label: [2 layers]),
    edge((2, 0), (3, 0), "->", label: [1 layer]),
    edge((3, 0), (3, 1), "->", label: [plain / TLS]),

    node((1, 1), text(size: 7.5pt, fill: muted)[knows: client IP \ not: destination], stroke: none),
    node((2, 1), text(size: 7.5pt, fill: muted)[knows: guard, exit \ only], stroke: none),
  )

  #block(width: 135mm)[#dnote[
    The client wraps each cell in three layers of encryption. Every relay
    removes one layer and learns only its neighbours. The exit sees the
    destination and, without TLS, the content, but never the client's address.
  ]]
]
