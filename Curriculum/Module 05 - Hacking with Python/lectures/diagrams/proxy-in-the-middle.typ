#import "/utils/athena-diagram.typ": *

// Lab setup: route your own script through an intercepting proxy so every
// request it sends is visible and replayable.

#diagram-page[
  #diagram(
    spacing: (13mm, 10mm),

    dbox((0, 0), [Python\ script]),
    dgood((1, 0), [Intercepting\ proxy\ 127.0.0.1:8080]),
    dbox((2, 0), [Lab target\ 192.168.56.10]),

    edge((0, 0), (1, 0), "->", label: [`proxies=`]),
    edge((1, 0), (2, 0), "->"),
    edge((2, 0), (1, 0), "->", label: [response], label-side: right, bend: -30deg),

    dbox((1, 1), [Proxy history:\ repeat, diff, export]),
    edge((1, 0), (1, 1), "->"),
  )

  #block(width: 92mm, dnote[
    The proxy's own CA certificate must be trusted by the script
    (`verify="proxy-ca.pem"`), not disabled. Turning verification off hides
    the TLS failures you are being paid to find.
  ])
]
