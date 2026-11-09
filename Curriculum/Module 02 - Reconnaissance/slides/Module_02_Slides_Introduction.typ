#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 02: Reconnaissance],
    subtitle: [Introduction to Reconnaissance],
    authors: [*Marcel Schnideritsch*],
    extra: [],
    footer: [Module 02 - Reconnaissance],
  ),
  config-common(
    handout: false,
  ),
)

#let meme(path) = slide(title: "", dark: true)[
  #align(center + horizon, image(path, height: 100%))
]

#title-slide()

#slide(title: "What is Reconnaissance?")[
  #color-block(title: [Definition])[
    Systematically collecting information about a target *before* acting on it.
  ]

  - First step of every attack
  - Decides what the next steps look like
  - Attackers do it. Defenders should too.
]

#standout-slide(title: [Information is power.])

#section-slide(title: "Passive vs. Active")

#slide(title: "Passive Reconnaissance")[
  #color-block(title: [Zero packets to the target])[
    Only public sources: search engines, job postings, DNS, certificates.
  ]

  - Hard to detect, nothing in their logs
  - Slow, data may be outdated
  - Tools: `whois`, `dig`, theHarvester, Maltego
]

#meme("figures/intro_drake.png")

#slide(title: "Active Reconnaissance")[
  #color-block(title: [Talk to the target directly])[
    Scanning, banner grabbing, service and OS fingerprinting.
  ]

  - Fast, accurate, current
  - Leaves logs, triggers IDS/IPS
  - *Needs written authorization*
  - Tools: `nmap`, masscan, Nessus, Nikto
]

#meme("figures/intro_fine.png")

#slide(title: "Passive vs. Active")[
  #table(
    columns: (auto, 1fr, 1fr),
    table.header([], [*Passive*], [*Active*]),
    [Detection], [Very low], [High],
    [Accuracy], [Historical], [Current],
    [Speed], [Slow], [Fast],
    [Authorization], [Rarely needed], [Always needed],
  )
]

#section-slide(title: "The Recon Process")

#slide(title: "Five Phases")[
  1. *Information Gathering* -- domains, IPs, people, tech stack
  2. *Scanning* -- live hosts, open ports, versions
  3. *Enumeration* -- users, shares, configs
  4. *Vulnerability Mapping* -- CVEs, misconfigurations
  5. *Analysis* -- attack paths, report
]

#slide(title: "Each Phase Feeds the Next")[
  #quote-block[
    Job posting says "AWS + Terraform" #sym.arrow.r look at cloud assets \
    Cert transparency shows `dev.example.com` #sym.arrow.r add to scope \
    `nmap -sV` says Apache 2.4.49 #sym.arrow.r check the CVE database
  ]
]

#section-slide(title: "Real-World Breaches")

#slide(title: "Recon Made These Possible")[
  - *Target (2013)*: attackers found the HVAC vendor, phished them, walked in
  - *Equifax (2017)*: fingerprinted an unpatched Apache Struts
  - *SolarWinds (2020)*: studied the build pipeline for months
]

#standout-slide(title: [The weakest link is often a supplier.])

#section-slide(title: "Rules")

#slide(title: "Authorization is Non-Negotiable")[
  #color-block(title: [Written permission. Always.])[
    Scope, IP ranges, time windows. Documented before you start.
  ]

  - Unauthorized scanning is a crime (StGB §118a, CFAA, Computer Misuse Act)
  - Even "passive" can cross the line
  - Log everything you do, with timestamps
]

#meme("figures/intro_mordor.png")

#slide(title: "Defending Against Recon")[
  - Scan yourself before someone else does
  - Strip version banners, minimize exposed services
  - WHOIS privacy, CDNs, honeypots
  - Detect it: rapid port sweeps, half-open SYNs from one IP
]

#section-slide(title: "Takeaways")

#slide(title: "Remember")[
  - Recon decides whether an attack works
  - Passive = stealth, active = accuracy
  - Authorization first, always
  - Defenders: know what attackers can see
]

#slide(title: "Resources")[
  - nmap.org/book
  - osintframework.com
  - attack.mitre.org
  - HackTheBox / TryHackMe
]

#title-slide()
