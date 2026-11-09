#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (20mm, 13mm),
    dbox((0, 1), [Client], width: 20mm),
    dbox((2, 1), [Onion \ service], width: 22mm),
    dbox((1, 0), [HSDir \ relays], width: 26mm),
    dbox((1, 1), [Introduction \ point], width: 28mm),
    dgood((1, 2), [Rendezvous \ point], width: 28mm),

    edge((2, 1), (1, 0), "->", label: [1 publish], label-side: right),
    edge((0, 1), (1, 0), "->", label: [2 fetch]),
    edge((0, 1), (1, 1), "->", label: [3 intro]),
    edge((2, 1), (1, 1), "--", label: [0 waits], label-side: left),
    edge((0, 1), (1, 2), "->", label: [3 cookie], label-side: right),
    edge((2, 1), (1, 2), "->", label: [4 connect], label-side: left),
  )

  #block(width: 135mm)[#dnote[
    0: the service keeps circuits open to a few introduction points.
    1-2: it publishes a signed descriptor naming them; the client fetches it.
    3: the client picks a rendezvous point, leaves a one-time cookie there and
    asks the service, via an introduction point, to meet it. 4: the service
    connects to the rendezvous point. Every arrow is a full Tor circuit, so
    neither side learns the other's IP address.
  ]]
]
