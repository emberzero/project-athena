#import "/utils/athena-diagram.typ": *

// What a single socket.connect_ex() result actually tells you.

#diagram-page[
  #diagram(
    spacing: (16mm, 7mm),

    dbox((0, 1), [`connect_ex((host, port))`]),

    dgood((1, 0), [returns `0`\ #text(size: 7.5pt)[open]]),
    dbox((1, 1), [`ECONNREFUSED`\ #text(size: 7.5pt)[closed]]),
    dbad((1, 2), [timeout / no reply\ #text(size: 7.5pt)[unknown]]),

    edge((0, 1), (1, 0), "->", label: [SYN-ACK], label-side: left),
    edge((0, 1), (1, 1), "->", label: [RST]),
    edge((0, 1), (1, 2), "->", label: [silence], label-side: right),
  )

  #block(width: 92mm, dnote[
    Only the first two outcomes are evidence. "Silence" conflates a dropping
    firewall, a saturated host, a lost packet and a timeout set too low.
    Never report it as "filtered" without a second probe.
  ])
]
