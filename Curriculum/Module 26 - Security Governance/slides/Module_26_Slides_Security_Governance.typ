#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 26: Security Governance],
    subtitle: [Roles, Risks, Standards and Rules],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 26 - Security Governance],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Why This Matters")[
  - Who decides how much security the company needs?
  - Who is accountable when it fails?
  - Which risks do we fix, and which do we accept?
  - Which laws apply to us, and what do they demand?

  #cblock(title: [Technology is not enough])[
    Many breaches start with a known risk that nobody owned.
  ]
]

#section-slide(title: "Governance and Roles")

#slide(title: "Governance vs. Management")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [], [*Governance*], [*Management*],
    [Question], [Right things?], [Things right?],
    [Who], [Board, Geschäftsführung], [CISO, security team, IT],
    [Does], [Direction, risk appetite, budget, oversight], [Plan, implement, measure, report],
  )

  #cblock(title: [Accountability stays at the top])[
    Tasks can be delegated. Responsibility cannot (NIS2 Art. 20, DORA).
  ]
]

#slide(title: "The Roles")[
  #split(
    [
      *Security*
      - *Management body*: strategy, budget, signs the policy
      - *CISO*: runs the programme, reports risks
      - *ISB*: coordinates the security process (BSI term)
    ],
    [
      *Data protection*
      - *DPO*: required by GDPR Art. 37
      - DE: also from 20 people processing data (BDSG § 38)
      - AT: no extra threshold
      - Independent, no conflict of interest
    ],
  )
]

#slide(title: "Three Lines Model")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 8pt,
    stroke: 0.5pt + gray,
    [*Line*], [*Who*], [*Role*],
    [1st], [Business units, IT ops], [Own and run controls],
    [2nd], [CISO / ISB, risk, DPO], [Methods, support, challenge],
    [3rd], [Internal audit], [Independent assurance],
  )

  Whoever runs a control should not be the only one judging it.
]

#slide(title: "Where Does the CISO Report?")[
  - *To the CIO*: close to IT, but conflict of interest
  - *To the CEO / board*: independent and visible
  - *To risk, CFO or legal*: common in banks and insurers

  #cblock(title: [The test])[
    Can the CISO escalate a risk without it being filtered by those who caused it?
  ]
]

#section-slide(title: "ISMS and ISO 27001")

#slide(title: "What Is an ISMS?")[
  - Policies, processes, roles and records, not a product
  - Makes security continuous instead of a one-time project
  - *ISO/IEC 27001:2022*: requirements, certifiable
  - *ISO/IEC 27002:2022*: implementation guidance
  - Clauses 4-10: context, leadership, planning, support, operation, evaluation, improvement
]

#slide(title: "The PDCA Cycle")[
  #align(center + horizon, image("../lectures/images/isms-pdca.svg", height: 85%))
]

#slide(title: "Annex A: 93 Controls")[
  #table(
    columns: (auto, auto, auto, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Theme*], [*Section*], [*Controls*], [*Examples*],
    [Organizational], [A.5], [37], [Policies, assets, suppliers, incidents],
    [People], [A.6], [8], [Screening, awareness, remote work],
    [Physical], [A.7], [14], [Perimeter, clear desk, disposal],
    [Technological], [A.8], [34], [Backup, logging, secure coding],
  )

  2013 edition: 114 controls in 14 domains. 2022: 11 new controls.
]

#slide(title: "Statement of Applicability")[
  - Required by clause 6.1.3 d)
  - For every Annex A control: applicable? why? implemented?
  - Exclusions must follow from the risk assessment or scope
  - First document auditors and customers ask for

  #cblock(title: [Reading a certificate])[
    Check the *scope* and ask for the SoA. The logo alone says little.
  ]
]

#slide(title: "Certification")[
  #table(
    columns: (auto, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Stage 1*], [Documentation and readiness],
    [*Stage 2*], [On-site: is it implemented and effective?],
    [*Certificate*], [Valid three years],
    [*Surveillance*], [Yearly audits in years 2 and 3],
    [*Recertification*], [Full audit before expiry],
  )

  Accredited bodies: Akkreditierung Austria, DAkkS (DE).
]

#standout-slide(title: [Certified does not mean secure.])

#section-slide(title: "Risk Management")

#slide(title: "Asset, Threat, Vulnerability")[
  - *Asset*: anything of value (data, systems, people, reputation)
  - *Threat*: potential cause of harm (ransomware group, flood)
  - *Vulnerability*: weakness a threat can exploit
  - *Risk*: likelihood x impact

  #cblock(title: [No vulnerability, no risk])[
    A flood is no risk for a server on the third floor on a hill.
  ]
]

#slide(title: "Risk Matrix")[
  #table(
    columns: (auto, 1fr, 1fr, 1fr),
    inset: 9pt,
    stroke: 0.5pt + gray,
    align: center,
    [*L \\ I*], [*1 Low*], [*2 Medium*], [*3 High*],
    [*3 High*], [3], [6], [9],
    [*2 Medium*], [2], [4], [6],
    [*1 Low*], [1], [2], [3],
  )

  Scales need *written definitions*, or ratings cannot be compared.
]

#slide(title: "Four Treatment Options")[
  #table(
    columns: (auto, auto, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Option*], [*ISO 27005*], [*Example*],
    [Mitigate], [Modify], [MFA, offline backups],
    [Transfer], [Share], [Cyber insurance, outsourcing],
    [Avoid], [Avoid], [Switch off the unused service],
    [Accept], [Retain], [Signed, documented, reviewed],
  )

  Transfer does not transfer legal responsibility.
]

#slide(title: "The Risk Register")[
  #table(
    columns: (auto, 1fr, auto, auto, auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*ID*], [*Risk*], [*L*], [*I*], [*R*], [*Treatment*],
    [R-01], [Ransomware, no offline backup], [3], [3], [9], [Mitigate + insure],
    [R-02], [SQL injection in shop], [2], [3], [6], [Mitigate],
    [R-04], [Unsupported fax server], [2], [1], [2], [Avoid],
    [R-05], [Test server outage], [2], [1], [2], [Accept],
  )

  Every risk has an *owner*. Review regularly, not only before audits.
]

#section-slide(title: "Frameworks and Regulation")

#slide(title: "NIST CSF 2.0 (2024)")[
  #split(
    [
      *Six functions*
      - *Govern* (new)
      - Identify
      - Protect
      - Detect
      - Respond
      - Recover
    ],
    [
      *Use*
      - Free, any size or sector
      - Outcomes, not technologies
      - Current vs. target profile
      - Govern frames the other five
    ],
  )
]

#slide(title: "BSI IT-Grundschutz")[
  - BSI-Standards 200-1 (ISMS), 200-2 (method), 200-3 (risk), 200-4 (BCM)
  - *Kompendium*: modules for typical components
  - Protection requirement: normal, high, very high
  - Risk analysis only for high needs or gaps
  - Basis-, Kern-, Standard-Absicherung
  - AT: Österreichisches Informationssicherheitshandbuch
]

#slide(title: "EU Regulation at a Glance")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Law*], [*Applies to*], [*Key point*],
    [NIS2], [Essential and important entities], [Mgmt accountability, Art. 21 measures],
    [DORA], [Financial sector, since 17 Jan 2025], [ICT risk, testing, third parties],
    [GDPR], [Anyone processing personal data], [Art. 32 security, 72 h breach report],
    [CRA], [Products with digital elements], [Secure by design, phased in],
  )

  NIS2 reporting deadlines: see Module 24, Lecture 2.
]

#slide(title: "NIS2 Reaches Suppliers Too")[
  - Art. 21 requires covered entities to secure their supply chain
  - Small suppliers get questionnaires, contract clauses, audits
  - Most Art. 21 measures map to ISO 27001 Annex A

  #cblock(title: [Cyber Resilience Act])[
    In force since Dec 2024. Reporting since 11 Sep 2026, full obligations from 11 Dec 2027.
  ]
]

#section-slide(title: "Policies, Awareness, Audits")

#slide(title: "Document Hierarchy")[
  #table(
    columns: (auto, 1fr, auto),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Level*], [*Purpose*], [*Approved by*],
    [Policy], [What and why], [Management],
    [Standard], [Measurable mandatory rules], [CISO / ISB],
    [Procedure], [How, step by step], [Process owner],
    [Guideline], [Recommendations], [CISO / ISB],
  )

  Short, owned, realistic, reviewed. Works council for monitoring.
]

#slide(title: "Awareness That Works")[
  - Target roles: finance, developers, admins, management
  - Short and continuous, not one video per year
  - Make reporting easy, thank those who report
  - Measure reporting rate, not only click rate
  - Phishing simulations: agreed, aggregated, never humiliating
]

#slide(title: "Audits")[
  - *Internal* (cl. 9.2), *supplier*, *certification*, *regulatory*
  - Evidence and *samples*: documents, interviews, technical checks
  - Findings name requirement, evidence and gap
  - Typical: stale risk register, leaver accounts, untested restores
  - Automotive suppliers: *TISAX* (ENX, VDA ISA)
]

#standout-slide(title: [Compliance is the minimum. Aim for security you can show.])
