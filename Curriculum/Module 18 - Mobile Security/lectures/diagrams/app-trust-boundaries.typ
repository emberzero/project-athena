#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (12mm, 8mm),
    dbox((1, 0), [Mobile app\ (client)]),
    dbad((0, 0), [Local storage,\ logs, clipboard]),
    dbad((2, 0), [Network path\ (hostile Wi-Fi)]),
    dbad((1, 1), [Other apps:\ deep links, intents,\ exported components]),
    dgood((2, 1), [Backend API\ (authoritative)]),
    edge((1, 0), (0, 0), "<->"),
    edge((1, 0), (2, 0), "<->"),
    edge((1, 1), (1, 0), "->"),
    edge((2, 0), (2, 1), "<->"),
  )
  #dnote[Red: surfaces an attacker can reach on a device they control.\
    The backend is the only place a trust decision survives.]
]
