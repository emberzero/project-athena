#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 20: RATs and Rootkits],
    subtitle: [Introduction to RATs and Rootkits],
    authors: ([*Marcel Schnideritsch*, *Martin Juritsch*]),
    extra: [],
    footer: [Marcel Schnideritsch, Martin Juritsch],
  ),
  config-common(
    handout: false,
  )
)

#title-slide()

#section-slide(title: "Introduction")

#slide(title: "RATs and Rootkits")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 6mm,
    align: (top, center),
  )[
    // Left column — text
    - Remote Access
    - Backdoors
  ][
    // Right column — image
    #image("../figures/fartware.gif", width: 90%)
  ]
]

#section-slide(title: "RATs")

#slide(title: "RATs")[
  - Remote Access Trojans
  - Infostealers
  - Operationally similar to legitimate tools
]

#slide(title: "Infostealers")[
  - *x* got ratted -> Usually just an infostealer
  - Basic social engineering
  - Steals tokens, passwords, cookies, etc.
  - VERY poplar in communities with lots of *young people*
  - No infra, relies heavily on webhooks or similar
]

#slide(title: "Real RATs")[
  #grid(
    columns: (2fr, 1fr),
    gutter: 3mm,
    align: (top, center),
  )[
    // Left: bullets
    - More complex, requires C2 infra
    - Not worth for individual targets
    - Can pivot into Ransomware or related
  ][
    // Right: animated graphic — adjust width/height if needed
    #image("../figures/xmrig.gif", width: 120%)
  ]
]

#slide(title: "RAT Operation")[
  1) Entry via social engineering

  2) *current cve* or *0day* to escalate

  3) Install and start beaconing

  4) Profit
]

#section-slide(title: "Command and Control (C2)")

#slide(title: "Command and Control (C2)")[
  - Recieve and execute commands
  - Exfiltrate data
  - Commercial or custom frameworks
]

#slide(title: "Command and Control (C2)")[
  #set align(center)
  #image("../figures/cobalt-strike.jpg")
]

#slide(title: "C2 Communication")[
  - Beaconing
    - host -> C2
  - Crawling
    - C2 -> known hosts
  - Traffic obfuscation
    - Redirection
    - C2 over DNS
    - Encryption
    - Mallealbe traffic
]

#slide(title: "More traffic obfuscation")[
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 3mm,
    align: (top, center),
  )[
    // Left: bullet list
    - Domain Fronting
    - Fast Flux
    - DNS Tunneling
    - Other generic traffic obfuscation
  ][
    // Right: image (adjust width/height to taste)
    #image("../figures/domain-fronting-scheme.png", width: 100%)
  ]
]

#slide(title: "Persistence")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 3mm,
    align: (top, center),
  )[
    // Left: bullets
    - Registry
    - Startup
    - Scheduled Tasks
    - DLLs
  ][
    // Right: image — adjust height or width if needed
    #image("../figures/DLL-load-order.png", height: 100%)
  ]
]

#slide(title: "Protection")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 6mm,
    align: (top, top),
  )[
    // Left column — Prevent infection block
    === Prevent infection
    - User training
    - Patching
    - Minimal permissions
  ][
    // Right column — Detect block
    === Detect
    - Monitor traffic
    - EDR monitoring
  ]
]

#slide(title: "Examples")[
  - Discord Bot Infostealer
  https://www.trellix.com/blogs/research/java-based-sophisticated-stealer-using-discord-bot-as-eventlistener/)


  - RAT builder RAT
  https://cyberpress.org/weaponized-xworm-rat-builder-targeting-script-kiddies/)
]

#section-slide(title: "Rootkits")

#slide(title: "Rootkits")[
  - Backdoor with typically elevated privileges


  - Traditionally requires permissions and/or exploit to install

]

#slide(title: "Types of Rootkits")[
    === Userland
    - First type of rootkits
    - Replace glibc, etc.

    === Kernel
    - Permissions or exploit required
    - Nowadays more protections

    === Firmware/BIOS/Hypervisor
    - Very rare and complex
]



#slide(title: "Mobile Rootkits")[
  - State spyware may fall into this category
  - Root/jailbreak usually included
  - Very rare due to cost of required vulns
]

#slide(title: "Why Ring0")[
  - Normally invisible from userspace
  - Manipulate structures and install hooks
  - Can be detected by earlier/deeper code
]

#slide(title: "Kernel Protections")[
  #split(columns: (1fr, 2fr), align: horizon)[
    - Non-exposed symbols
    - KASLR & SMAP
    - Write protection
    - Exploit protections
    - Integrity checks
    - Still not perfect
  ][
    #image("../figures/kernel-protection.png")
  ]
]

#slide(title: "Firmware/BIOS/ Hypervisor")[
  - Functionally similar to enterprise management software
  - Requires high severity vuln to install
  - Might start to become more common
]

#title-slide(
  title: [Module 20: RATs and Rootkits],
  subtitle: [Introduction],
)
