#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 24: Government Agencies],
    subtitle: [Defenders, Spies and Police in Cyberspace],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 24 - Government Agencies],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Why This Matters")[
  - Ransomware hits your company: who must you tell, and by when?
  - You read a CERT advisory: who wrote it?
  - An attack is attributed to a state: what does that mean?
  - An authority asks for customer data: is that lawful?

  #cblock(title: [The state is on every side])[
    It regulates, warns, helps, investigates and sometimes attacks.
  ]
]

#section-slide(title: "The Landscape")

#slide(title: "Three Pillars")[
  #align(center + horizon, image("../lectures/images/agency-landscape.svg", height: 85%))
]

#slide(title: "Kept Apart on Purpose")[
  #split(
    [
      *Germany: Trennungsgebot*
      - Intelligence and police strictly separate
      - Intelligence services cannot arrest or search
      - Lesson from the Gestapo
    ],
    [
      *Austria*
      - No constitutional separation
      - Domestic intelligence (DSN) sits inside the police structure
      - 2021 reform separated functions within the DSN
    ],
  )
]

#slide(title: "Three Levels")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Level*], [*Defence*], [*Law enforcement*],
    [National], [BSI, CERT.at, GovCERT], [BK / C4, BKA, LKA],
    [EU], [ENISA, CERT-EU, CSIRTs network], [Europol EC3, Eurojust],
    [International], [CISA, NCSC (reference)], [Interpol, Budapest Convention],
  )
]

#section-slide(title: "Cyber Defence & CERTs")

#slide(title: "What a CERT Does")[
  - Warnings and advisories
  - Incident handling support
  - Coordinated vulnerability disclosure
  - Notifying owners of compromised systems
  - Situational awareness

  #cblock(title: [Not the police])[
    Reporting to a CERT does *not* automatically start a criminal case.
  ]
]

#slide(title: "Germany and Austria")[
  #split(
    [
      *Germany*
      - *BSI*: national authority, runs CERT-Bund and the IT Situation Centre
      - IT-Grundschutz, certification, KRITIS supervision
      - *Cyber-AZ*: cooperation platform across all pillars
    ],
    [
      *Austria*
      - *CERT.at*: national CERT, run by nic.at
      - *GovCERT*: public administration, Federal Chancellery with CERT.at
      - Sector CERTs, e.g. Austrian Energy CERT
    ],
  )
]

#slide(title: "EU and International")[
  - *ENISA*: supports member states, exercises, certification, EUVD
  - *CERT-EU*: CERT for the EU institutions
  - *CSIRTs network*: all national CSIRTs, cross-border coordination
  - *CISA* (US): Known Exploited Vulnerabilities catalogue
  - *NCSC* (UK): part of GCHQ, the opposite of the German model
]

#slide(title: "NIS2: Who and What")[
  - Essential and important entities in many sectors
  - Usually from 50 employees or 10 M EUR turnover
  - Risk management measures (Art. 21)
  - Management approves, oversees, can be *personally liable* (Art. 20)
  - Fines up to 10 M EUR or 2 % of global turnover
]

#slide(title: "NIS2 Reporting Timeline")[
  #table(
    columns: (auto, auto, 1fr),
    inset: 8pt,
    stroke: 0.5pt + gray,
    [*Deadline*], [*Report*], [*Content*],
    [24 h], [Early warning], [Malicious act suspected? Cross-border impact?],
    [72 h], [Notification], [Severity, impact, indicators of compromise],
    [1 month], [Final report], [Root cause, mitigations],
  )

  #cblock(title: [Status AT and DE])[
    Both missed the Oct 2024 deadline. Check the current national law.
  ]
]

#section-slide(title: "Intelligence Services")

#slide(title: "Types of Intelligence")[
  - *HUMINT*: human sources
  - *SIGINT*: intercepted signals and communications
  - *OSINT*: public information
  - *Cyber operations*: direct access to systems

  *Five Eyes*: NSA, GCHQ, CSE, ASD, GCSB (UKUSA, 1946)
]

#slide(title: "Snowden, 2013")[
  - *PRISM*: data from large US tech companies
  - *Tempora*: GCHQ taps transatlantic cables
  - *XKeyscore*: search through intercepted traffic
  - 2015: BND ran NSA selectors targeting European firms

  Result: encryption everywhere, E2E messengers by default.
]

#slide(title: "Services in Germany and Austria")[
  #split(
    [
      *Germany*
      - *BND*: foreign, SIGINT
      - *BfV*: domestic, counter-espionage
      - *MAD*: military counter-intelligence
      - *ZITiS*: builds tools, no operations
      - *CIR*: Bundeswehr cyber branch
    ],
    [
      *Austria*
      - *DSN*: domestic, replaced BVT in 2021
      - *Heeresnachrichtenamt*: military foreign intelligence, SIGINT
      - *Abwehramt*: military counter-intelligence
    ],
  )
]

#slide(title: "State-Attributed APTs")[
  #table(
    columns: (auto, auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Group*], [*Attributed to*], [*Known for*],
    [APT28], [GRU 26165], [Bundestag hack 2015],
    [APT29], [SVR], [SolarWinds 2020],
    [Sandworm], [GRU 74455], [Ukraine grid, NotPetya],
    [APT1], [PLA 61398], [Industrial espionage],
    [Lazarus], [North Korea], [WannaCry, crypto theft],
    [Equation], [Linked to NSA], [Leaked: EternalBlue],
  )
]

#standout-slide(title: [A state's secret exploit became WannaCry.])

#slide(title: "Lawful Interception and State Trojans")[
  - Encryption makes classic interception useless
  - *Source interception*: read messages on the device
  - *Online search*: covert access to the whole device
  - Both need a vulnerability

  #cblock(title: [The conflict])[
    A vulnerability kept for surveillance stays open for everyone.
  ]
]

#slide(title: "Oversight")[
  #split(
    [
      *Germany*
      - PKGr (parliament)
      - G10-Kommission
      - Unabhängiger Kontrollrat (since 2022)
    ],
    [
      *Austria*
      - Rechtsschutzbeauftragte
      - Parliamentary subcommittees
      - Kontrollkommission Verfassungsschutz
    ],
  )
]

#section-slide(title: "Law Enforcement")

#slide(title: "Who Investigates")[
  - Prosecutor leads, police investigate, court orders searches
  - *Austria*: BK with C4, Landeskriminalämter
  - *Germany*: BKA, LKA with ZAC contact points, ZIT Frankfurt
  - *Europol EC3* and *Eurojust*: coordination, no arrest powers
  - *Interpol*: worldwide, Red Notices
]

#slide(title: "Evidence Across Borders")[
  #table(
    columns: (auto, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*MLAT*], [Formal state-to-state request, months],
    [*EIO*], [EU judicial order with deadlines],
    [*e-Evidence*], [Directly to provider, 10 days / 8 h, from Aug 2026],
    [*CLOUD Act*], [US providers, wherever data is stored],
  )

  *Budapest Convention* (2001): offences, procedures, 24/7 network.
]

#slide(title: "As a Company")[
  - Report early: ZAC (DE), C4 or local police (AT)
  - Preserve evidence, document chain of custody
  - Police report *and* NIS2 report: separate duties
  - Paying ransom: discouraged, illegal if recipient is sanctioned
]

#standout-slide(title: [Know the reporting path before the first incident.])
