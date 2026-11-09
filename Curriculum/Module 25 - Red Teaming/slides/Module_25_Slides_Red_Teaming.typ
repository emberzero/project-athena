#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 25: Red Teaming],
    subtitle: [Governing Realistic Attack Simulations],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 25 - Red Teaming],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Why This Matters")[
  - We pay for a SOC. Would it notice a real attacker?
  - Who may know about a test, and who decides when it stops?
  - How do we attack production without breaking it or the law?
  - How do results turn into better defence?

  #cblock(title: [This module is about management])[
    No techniques, no tools. Those are in Modules 04-22.
  ]
]

#section-slide(title: "What Red Teaming Is")

#slide(title: "Three Kinds of Test")[
  #table(
    columns: (auto, 1fr, 1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [], [*Scan*], [*Pentest*], [*Red team*],
    [Question], [Known weaknesses?], [How far in this scope?], [Would we detect and stop it?],
    [Who knows], [Everyone], [IT, defenders], [Control team only],
    [Duration], [Hours], [Days to weeks], [Months],
    [Result], [Vuln list], [Ranked findings], [Attack story, detection gaps],
  )
]

#slide(title: "Objectives and Flags")[
  - A red team works towards agreed *flags*
  - Flags describe business harm, not technical milestones
  - Example: "approve a payment", "read the customer database"
  - Proven safely: marker file, test record, never real damage
  - Emulate an attacker realistic *for this organisation*

  #cblock(title: [Not before the basics work])[
    Without monitoring and incident response, a red team only confirms the obvious.
  ]
]

#slide(title: "The Teams")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Team*], [*Who*], [*Role*],
    [Red], [External testers or internal team], [Plays the attacker, chases flags],
    [Blue], [SOC, IT ops, responders], [Defends as usual, *not told*],
    [White / control], [Few senior staff], [Steers, keeps secret, stops],
    [Purple], [Red and blue together], [Replay and improve detection],
  )
]

#slide(title: "The Control Team")[
  - TIBER-EU and DORA term for the white team
  - Small, senior, access to the management board
  - Approves scope and test plan
  - Red team's contact during the test
  - Decides on leg-ups, pauses and stops
  - Handles escalations by the blue team
]

#section-slide(title: "Frameworks and Regulation")

#slide(title: "TIBER-EU")[
  - Threat Intelligence-Based Ethical Red Teaming
  - ECB, May 2018; updated to align with DORA
  - Adopted nationally, 21 countries incl. AT and DE
  - Live production systems, threat-led scenarios
  - TIBER Cyber Team and test managers at the authority
  - Attestation, recognised across countries
  - Modelled on CBEST (Bank of England, 2014)
]

#slide(title: "TIBER-AT")[
  - OeNB and FMA, Implementation Guide Nov 2023
  - TIBER Cyber Team located at the OeNB
  - FMA issues the attestation
  - Revised in 2025 for DORA
  - Germany: TIBER-DE (Bundesbank)

  #cblock(title: [Purpose])[
    Practise the method voluntarily before DORA TLPT becomes mandatory.
  ]
]

#slide(title: "DORA Threat-Led Penetration Testing")[
  #table(
    columns: (auto, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Basis*], [Regulation (EU) 2022/2554, Art. 26 and 27],
    [*Who*], [Financial entities identified by the authority],
    [*How often*], [At least every three years],
    [*What*], [Critical or important functions, live production],
    [*Testers*], [External every three tests; significant banks external only],
    [*Details*], [Delegated Regulation (EU) 2025/1190],
  )
]

#slide(title: "The Phases")[
  #align(center + horizon, image("../lectures/images/tlpt-phases.svg", height: 88%))
]

#slide(title: "Closure Deadlines under DORA")[
  #table(
    columns: (1fr, auto),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Step*], [*After end of active test*],
    [Red team test report], [within 4 weeks],
    [Blue team test report], [at most 10 weeks],
    [Replay and purple teaming (mandatory)], [at most 10 weeks],
    [Summary report to authority], [8 weeks after reports accepted],
  )
]

#section-slide(title: "Scoping and Rules of Engagement")

#slide(title: "Authorisation")[
  - Without consent: § 118a, § 126a-c StGB and others (Module 01)
  - Written, signed, specific, by someone entitled to grant it
  - Usually the management body, not the CISO alone
  - Only systems the organisation controls
  - Cloud, SaaS, outsourcers: their consent or out of scope
  - Private devices and accounts: never in scope
]

#slide(title: "Scope Starts from the Business")[
  #table(
    columns: (auto, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Functions*], [Online banking, payment processing],
    [*Flags*], [Approve a payment, read customer data],
    [*Attack surface*], [Internet, email to staff, service desk, lobby],
    [*Excluded*], [Card processor, building control, safety systems],
    [*Never*], [DoS, destruction, real transactions],
  )

  Every exclusion has a reason. A system nobody dares to test is a risk itself.
]

#slide(title: "People in Scope")[
  - Phishing and pretexting process personal data: GDPR applies
  - Works council may have to be involved: ask legal first
  - Results in aggregate, no individual is blamed
  - No pretexts using fear, health or family
  - No contact outside work or via private channels
]

#slide(title: "Rules of Engagement")[
  #split(
    [
      *Operations*
      - Out-of-band channels
      - At least weekly updates
      - Code word for identity
      - Emergency contacts, 24/7
    ],
    [
      *Safety*
      - Stop conditions
      - Risk management for the test
      - Data handling and deletion
      - Safe proof of flags
      - Leg-ups only if stuck, documented
    ],
  )
]

#slide(title: "Stop Conditions")[
  - Signs of a real attacker in the environment
  - Production outage or odd behaviour, whoever caused it
  - Clearly out-of-scope data, e.g. health records
  - Any risk to physical safety
  - Third party outside the scope affected
  - Test about to become public
]

#slide(title: "Deconfliction")[
  + Blue team escalates as usual
  + Control team checks the red team activity log
  + *Not the red team:* real incident, test pauses
  + *Red team:* let the response run, step in at a set point

  #cblock(title: [Critical point])[
    Stop false reports to police, CERT or supervisor. Never block a real one.
  ]
]

#section-slide(title: "Threat-Informed Planning")

#slide(title: "From Intelligence to Scenario")[
  - *Who* would attack us? Relevant threat actors
  - *What* would they want? Money, data, disruption, visibility
  - *What* could they learn about us? Public footprint
  - Result: targeted threat intelligence report
  - 2-4 scenarios: actor, motivation, start, flag, path
  - Start: full scenario or *assumed breach*, a recorded decision
]

#slide(title: "MITRE ATT&CK Tactics (v20.1)")[
  #set text(size: 0.85em)
  #split(
    [
      - Reconnaissance
      - Resource Development
      - Initial Access
      - Execution
      - Persistence
      - Privilege Escalation
      - Stealth
      - Defense Impairment
    ],
    [
      - Credential Access
      - Discovery
      - Lateral Movement
      - Collection
      - Command and Control
      - Exfiltration
      - Impact
    ],
  )
  Common language for TI, plan, report and blue team. Always state the version.
]

#slide(title: "Measuring Detection")[
  #table(
    columns: (auto, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Prevented*], [A control blocked the step],
    [*Detected and responded*], [Alert, investigation, action],
    [*Detected, no response*], [Alert closed or not escalated],
    [*Logged only*], [In the logs, no alert],
    [*Not visible*], [No log or sensor captured it],
  )

  Plus time to detect and time to respond. A rule that exists is not coverage.
]

#section-slide(title: "Purple Teaming, Reporting, Closure")

#slide(title: "Replay and Purple Teaming")[
  - Blue team informed with respect, thanked, not blamed
  - Red and blue reports side by side: one timeline
  - Replay: step by step, what was visible?
  - Purple: execute, observe, improve, verify
  - Mandatory under DORA, within 10 weeks

  #cblock(title: [No replacement for the covert test])[
    Once the blue team knows, it cannot show how it handles surprise.
  ]
]

#slide(title: "Findings vs. Detection Gaps")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [], [*Finding*], [*Detection gap*],
    [What], [Weakness that enabled progress], [Step nobody noticed or acted on],
    [Example], [Reset without caller check], [Odd login logged, no alert],
    [Owner], [System or process owner], [Security operations],
  )

  Fix both. Systemic issues matter more than single hosts.
]

#slide(title: "Two Audiences")[
  #split(
    [
      *Executive summary*
      - 2-4 pages
      - Flags, time, detection
      - 3-5 systemic issues
      - Business terms, no names
    ],
    [
      *Technical report*
      - Full timeline per tactic
      - Blue team view per step
      - Evidence, ratings, leg-ups
      - Classified, need-to-know
    ],
  )
]

#slide(title: "Remediation Tracking")[
  - Each measure: owner, deadline, status, verification
  - Tracked in the risk register or ticket system
  - Progress in regular management reporting
  - Closed only when retested, often in a purple session
  - Unfixable issues: accepted explicitly, with review date
  - Results shape the scope of the next test
]

#standout-slide(title: [Being caught is not a failed test. Learning nothing is.])
