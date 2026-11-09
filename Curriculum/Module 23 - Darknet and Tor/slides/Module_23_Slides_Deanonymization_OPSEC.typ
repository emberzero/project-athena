#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 23: Darknet and Tor],
    subtitle: [Deanonymization and OPSEC],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 23 - Deanonymization and OPSEC],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "A Paradox")[
  - Tor's cryptography has held up for 20+ years
  - Almost every big market operator got caught anyway

  #cblock(title: [Resolution])[
    Most cases attacked something *around* Tor: the browser, the server, the
    money, or a person.
  ]
]

#section-slide(title: "Technical Attacks")

#slide(title: "Traffic Correlation")[
  - Watch packets entering *and* leaving: match timing and volume
  - No decryption needed
  - Large ASes are often on both paths (RAPTOR, 2015)
  - 2024, Germany: timing analysis against a user on outdated Ricochet without vanguards-lite
]

#slide(title: "Malicious Relays")[
  #table(
    columns: (auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + gray,
    [*BTCMITM20* \ 2020], [About 25% of exit capacity, SSL stripping, swapped Bitcoin addresses],
    [*KAX17* \ 2017-21], [Hundreds of guard/middle relays, likely deanonymization],
    [*CMU* \ 2014], [Relay early signal, data reached the FBI (Silk Road 2.0)],
  )

  Countered by scanning, `BadExit`, fixed guards, family rules.
]

#slide(title: "Website Fingerprinting")[
  - Your ISP sees the *shape* of encrypted traffic
  - ML classifier: "this pattern is site X"
  - Very accurate in the lab, much harder in the open world
  - Reason Tor adds padding
]

#slide(title: "Browser Exploits (NIT)")[
  - One exploit #sym.arrow.r connection *outside* Tor #sym.arrow.r real IP
  - *Freedom Hosting 2013:* Firefox exploit sent IP, MAC, hostname
  - *Playpen 2015:* FBI ran the site for 2 weeks, thousands identified

  *Defence:* Safest level (no JavaScript), Whonix.
]

#section-slide(title: "Case Studies")

#slide(title: "Silk Road (2013)")[
  - "altoid" advertised the site in 2011...
  - ...and later posted `rossulbricht@gmail.com` in the same name
  - Fake IDs intercepted at the border
  - Server found in Iceland (official account disputed)
  - Arrested in a library, laptop grabbed *unlocked*

  Nothing required breaking Tor.
]

#slide(title: "AlphaBay and Hansa (2017)")[
  #split(
    [
      *AlphaBay*
      - Admin's Hotmail in early e-mail headers
      - Crypto traced to cars and villas
      - Laptop unlocked at arrest
    ],
    [
      *Hansa*
      - Dutch police *took over* the market
      - Ran it for a month
      - AlphaBay refugees walked right in
      - Code changed to log passwords and addresses
    ],
  )
]

#standout-slide(title: [The site you trust may already be run by the police.])

#slide(title: "The Pattern")[
  #table(
    columns: (1fr, auto),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [Old account, e-mail, username], [Silk Road, AlphaBay],
    [Crypto traced to exchanges], [AlphaBay, Welcome to Video],
    [Server misconfiguration], [Silk Road (disputed), many more],
    [Platform takeover], [Hansa, Playpen],
    [Browser exploit], [Freedom Hosting, Playpen],
    [Unlocked device], [Silk Road, AlphaBay],
    [Tor itself], [CMU 2014, timing case 2024],
  )
]

#section-slide(title: "OPSEC")

#slide(title: "Principles")[
  - *Threat model first:* advertisers #sym.eq.not school network #sym.eq.not police
  - *Compartmentalize:* separate identities, accounts, devices
  - *Never reuse* usernames, e-mails, keys, wallets
  - *Metadata:* EXIF, time zones, writing style
  - *Assume compromise:* encryption, locked screens, amnesic systems
  - *The past is permanent*
]

#slide(title: "Hardening Tools")[
  #table(
    columns: (auto, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Tails*], [Live USB, all through Tor, forgets everything],
    [*Whonix*], [Gateway VM + Workstation VM: exploit cannot learn real IP],
    [*Qubes OS*], [Every task in its own VM],
  )

  None of them help if you log into your own account.
]

#section-slide(title: "Defenders")

#slide(title: "Darknet Monitoring")[
  - Your company on a leak site? Credentials for sale?
  - Aggregators (ransomware.live), threat-intel platforms
  - Breach notification (Have I Been Pwned, CERTs)
  - Direct access only with mandate, isolated VMs, documented sock puppets

  #cblock(title: [Never])[
    Buy, download leaks without clearance, or encourage a crime.
  ]
]

#standout-slide(title: [Crypto holds. People slip.])
