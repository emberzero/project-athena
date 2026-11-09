#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 23: Darknet and Tor],
    subtitle: [Introduction to the Darknet],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 23 - Introduction],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "What Is the Darknet?")[
  #cblock(title: [Definition])[
    An *overlay network* that needs special software to reach and that hides
    *who talks to whom*.
  ]

  - Not a hidden basement of the internet
  - Same cables, different network on top
  - The property that protects a whistleblower also protects a fraudster
]

#section-slide(title: "Three Terms")

#slide(title: "Surface, Deep, Dark")[
  #table(
    columns: (auto, 1fr, auto),
    inset: 8pt,
    stroke: 0.5pt + gray,
    [*Layer*], [*Examples*], [*Access*],
    [Surface web], [News, Wikipedia, blogs], [Any browser],
    [Deep web], [Webmail, banking, school LMS, intranets], [Browser + login],
    [Darknet], [Onion services, I2P sites, Hyphanet], [Special software],
  )

  Your inbox is "deep web". The darknet is small and separate.
]

#slide(title: "Darknet Technologies")[
  #split(
    [
      #cblock(title: [Tor])[
        3 relays, about 2 million daily users. Reaches the normal web *and*
        hosts onion services.
      ]
      #cblock(title: [I2P])[
        Every user routes. One-way tunnels, "garlic routing". Internal services.
      ]
    ],
    [
      #cblock(title: [Hyphanet])[
        Formerly Freenet. Distributed encrypted data store. No server to seize.
      ]
      #cblock(title: [Friend-to-friend])[
        Only peers you added. Invisible to strangers.
      ]
    ],
  )
]

#section-slide(title: "History")

#slide(title: "Built by the Navy")[
  - *Mid-1990s:* onion routing at the US Naval Research Laboratory
  - *2002:* Tor deployed (Dingledine, Mathewson, Syverson)
  - *2004:* free licence, design paper, hidden services
  - *2006:* The Tor Project, non-profit
  - *2011-2013:* Silk Road makes "darknet" a household word
  - *2021:* old v2 onion addresses switched off
]

#standout-slide(title: [Anonymity loves company.])

#slide(title: "Why the Navy Needed Strangers")[
  A network used only by spies reveals that its users are spies.

  #cblock(title: [Key insight])[
    Anonymity only works if *many different people* use the same network.
  ]
]

#section-slide(title: "Who Uses It?")

#slide(title: "Two Lists, Both Real")[
  #split(
    [
      *Legitimate*
      - Journalists and sources (SecureDrop)
      - People under censorship
      - Activists, human-rights workers
      - Researchers, police, military
      - BBC, DW, NYT, DuckDuckGo, Facebook
    ],
    [
      *Criminal*
      - Drug and data markets
      - Ransomware leak sites
      - Initial access brokers
      - Child abuse material
      - Scams, scams, scams
    ],
  )

  Most Tor traffic goes to *normal websites*, not onion services.
]

#section-slide(title: "Law")

#slide(title: "Is Tor Legal?")[
  - *Using Tor:* legal in Austria, Germany, almost all of the EU
  - *What you do over it:* judged like anything else
    - SMG, §126c StGB (AT), §202c StGB (DE)
  - *Running a criminal platform:* §127 StGB (DE, since 2021)
  - *Exit relays:* legal, but operators have been searched and convicted (Graz 2014)
]

#slide(title: "Rule for This Course")[
  #cblock(title: [Do not visit], color: red.darken(20%))[
    Markets, forums, leak sites. Not even "just to look".
  ]

  - Downloading leaked data can itself be a crime
  - Illegal content can load automatically
  - These sites serve malware

  All labs use *your own* services and legitimate ones.
]

#standout-slide(title: [Tor is legal. Crime is still crime.])
