#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 22: Social Engineering],
    subtitle: [Manipulating People, Not Machines],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 22 - Social Engineering],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Introduction")

#slide(title: "What Social Engineering Is")[
  - Manipulating people into revealing info or taking harmful actions
  - Targets the *human* element, not code or configuration
  - No exploit needed: convince the helpdesk to reset a password

  #cblock(title: [Why it keeps working])[
    It needs no technical sophistication, only an understanding of how
    people behave under trust, fear, authority or time pressure.
  ]
]

#slide(title: "A Typical Example")[
  - An email asks you to reset a password or verify details
  - It copies a real service's wording, branding and sender address
  - Close enough to pass a quick glance
  - Enter your credentials, and the attacker now has them

  Phishing and pretexting both exploit one thing: the target's
  willingness to believe the sender is who they claim to be.
]

#section-slide(title: "Types of Attacks")

#slide(title: "The Recognisable Shapes")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Phishing*], [Deceptive message mimics a trusted source],
    [*Pretexting*], [A fabricated scenario makes a request routine],
    [*Baiting*], [Offers something wanted; the bait carries a payload],
    [*Quid pro quo*], [Something valuable traded for information],
    [*Impersonation*], [Posing as a specific colleague or boss],
    [*Tailgating*], [Following someone through a controlled door],
  )
]

#slide(title: "They Differ, and They Combine")[
  - All exploit human psychology, not a technical flaw
  - They differ in *channel*, *story* and *what they ask for*
  - Tailgating's digital twin: riding an authenticated session
    (an unlocked workstation, a talked-into remote-support link)

  #cblock(title: [Most real attacks are blends])[
    A pretext sets the story, a phishing message delivers it, and
    impersonation makes it credible. Spot the parts to see the whole.
  ]
]

#section-slide(title: "Stages of an Attack")

#slide(title: "The Chain")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*1 Reconnaissance*], [Gather info, assemble a profile],
    [*2 Target selection*], [Pick by susceptibility and usefulness],
    [*3 Developing trust*], [Build a facade of credibility],
    [*4 Exploitation*], [Make the crafted request],
    [*5 Execution*], [Run the attack, reach the objective],
    [*6 Evasion*], [Cover tracks, stay unnoticed],
  )

  Each stage produces what the next one needs.
]

#slide(title: "Defences Map Onto Stages")[
  - *Reconnaissance:* limit what staff publish about internal structure
  - *Trust:* a verification procedure for unusual requests
  - *Evasion:* logging the attacker cannot reach

  #cblock(title: [One broken link is enough])[
    Disrupting any single stage breaks the chain.
  ]
]

#section-slide(title: "Psychological Principles")

#slide(title: "Why Humans Are the Target")[
  - Microsoft: up to *91%* of cyberattacks start with phishing
  - Even cautious people fall for trust and authority plays
  - The methods look like ordinary everyday interactions

  That is what makes them hard to spot and hard to stop.
]

#slide(title: "Principles Attackers Exploit")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Reciprocity*], [People feel obliged to return favours],
    [*Commitment*], [Small yes leads to a bigger one],
    [*Social proof*], [People follow the lead of others],
    [*Authority*], [Requests from authority bypass scepticism],
    [*Liking*], [We are swayed by people we like],
    [*Scarcity*], [Perceived scarcity drives quick action],
  )
]

#slide(title: "Why It Works")[
  - *Cognitive overload:* jargon clouds judgement
  - *Emotional decisions:* fear overrides logic
  - *Trust as default:* implicit trust in professional settings
  - *Authority compliance:* a natural urge to obey
  - *Social norms:* politeness holds the door for a "technician"
  - *Technology as a veil:* identity is hard to verify
]

#standout-slide(title: [Humans are the weakest link, and the one thing training can actually change.])

#section-slide(title: "Tools and Techniques")

#slide(title: "OSINT and Profiling")[
  #split(
    [
      *OSINT*
      - Collect from public sources
      - Search engines, social media, records
      - Specialized gathering tools
      - Feeds a targeted attack
    ],
    [
      *DISC profiling*
      - *D:* assertive, result-oriented
      - *I:* sociable, persuasive
      - *S:* calm, reliable
      - *C:* detail-oriented, analytical
    ],
  )

  Profiling predicts how a target will respond, so the attacker adapts.
]

#slide(title: "Pretexting and Rapport")[
  - *Pretexting:* a believable, tailored scenario; role-play for trust
  - *Rapport:* apply reciprocity, authority, liking, scarcity, proof
  - *Framing:* present information to shape the target's perception
  - *Elicitation:* extract info subtly, without raising suspicion
  - *Nonverbal cues:* read body language, adjust your own signals
]

#slide(title: "Executing the Attack")[
  - *Phishing:* convincing emails
  - *Vishing:* calls with an authoritative or trustworthy persona
  - *Impersonation:* for physical or digital access

  #cblock(title: [Why study the attacker's toolkit])[
    Knowing the methods used against you is what makes effective
    countermeasures possible.
  ]
]

#section-slide(title: "Prevention and Defense")

#slide(title: "Hadnagy's M.A.P.P. Framework")[
  #table(
    columns: (auto, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*1 Identify*], [Learn the forms: phishing, pretexting, baiting],
    [*2 Policies*], [Realistic, enforceable, revisited regularly],
    [*3 Checkups*], [Security audits and simulated attacks],
    [*4 Awareness*], [Continuous, interactive education],
  )

  Mitigation and Prevention Plan: the four steps, tied together.
]

#slide(title: "A Security Awareness Culture")[
  - Make security *everyone's* responsibility
  - Use real breaches and examples as teaching material
  - Defense spans awareness, policy, culture and improvement

  #cblock(title: [No silver bullet], color: red.darken(20%))[
    No single measure prevents social engineering. The four steps
    reduce the risk, and they are a starting point.
  ]
]

#standout-slide(title: [Social engineering works on human imperfection. Education and vigilance are the defence.])
