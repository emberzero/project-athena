#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 13: Blue Teaming],
    subtitle: [Defensive Security Technologies and Processes],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 13 - Blue Teaming],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "What Is Blue Teaming?")[
  - Blue teaming is *defensive* security
  - The red team attacks; the blue team detects and responds
  - Goal: prevent, detect and contain intrusions

  #cblock(title: [This module])[
    Firewalls, intrusion detection and prevention, incident response, and
    SIEM.
  ]
]

#slide(title: "Red vs. Blue")[
  #align(center, image("../lectures/images/red_vs_blue.png", height: 11cm))
]

#section-slide(title: "Defensive Security Overview")

#slide(title: "Core Technologies")[
  - *IDS:* records events, raises an alert, blocks nothing
  - *IPS:* sits in the traffic path, blocks as it happens
  - *SIEM:* aggregates and analyses security alerts
  - *EDR:* monitors endpoints, detects and eradicates threats
  - *Antivirus:* signatures plus heuristics; a baseline control
  - *Firewalls:* decide which traffic may pass between networks
]

#slide(title: "Core Defence Processes")[
  - *Incident response:* systematic handling of breaches
  - *Threat intelligence:* who attacks you, with which tools
  - *Vulnerability management:* find, assess, remediate, report
  - *Risk management:* identify, evaluate and control risk

  #cblock(title: [Technology is not enough])[
    Tools raise alerts; processes and people turn them into decisions.
  ]
]

#section-slide(title: "Firewalls")

#slide(title: "What Is a Firewall?")[
  - Filters traffic and decides, per packet, whether it may pass
  - A gatekeeper at the entrance to a network
  - The admin's *rule set* defines what is permitted
  - The firewall has no idea what is "good" or "malicious"

  #cblock(title: [Key point])[
    A rule set is only as good as the policy behind it. Unmatched traffic is
    dropped.
  ]
]

#slide(title: "Permit and Deny")[
  #split(
    [
      *Allowed traffic*
      #image("../lectures/images/Firewall_1.png", width: 100%)
    ],
    [
      *Dropped traffic*
      #image("../lectures/images/Firewall_2.png", width: 100%)
    ],
  )
]

#slide(title: "Software vs. Hardware")[
  #table(
    columns: (auto, 1fr, 1fr),
    table.header([], [*Software*], [*Hardware*]),
    [Scope], [One device], [Whole network],
    [Location], [On the device], [Separate appliance],
    [Control], [Granular per host], [Broad, network-wide],
  )

  Often combined for layered defence.
]

#slide(title: "Firewall vs. Antivirus")[
  - *Firewall:* blocks unauthorised connections (network)
  - *Antivirus:* detects, identifies, removes malicious code (host)
  - Antivirus catches threats that never crossed the network
    #linebreak() (e.g. malware on a USB stick)

  They solve different problems and do not replace each other.
]

#slide(title: "Types by Inspection Depth")[
  - *Packet filter* (L3): IP, port, protocol; no state
  - *Stateful inspection* (L4): tracks connection state
  - *Proxy / app gateway* (L7): inspects application data
  - *NGFW:* firewall + IPS + app awareness + DPI
  - *DPI:* scrutinises the payload, not just headers

  #cblock(title: [Trade-off])[
    Deeper inspection gives more context but costs more CPU per packet.
  ]
]

#section-slide(title: "Intrusion Detection and Prevention")

#slide(title: "IDS vs. IPS")[
  - *IDS:* a diagnostic tool, raises alerts only
  - *IPS:* diagnostic *and* incident-response tool, blocks
  - IDS sits *out of band* (SPAN port or tap), traffic arrives anyway
  - IPS sits *inline*, so it can drop packets

  #cblock(title: [Consequence], color: red.darken(20%))[
    An IDS that fails loses visibility. An IPS that fails can cut
    connectivity.
  ]
]

#slide(title: "Detection Techniques")[
  #table(
    columns: (auto, 1fr),
    table.header([*Technique*], [*Behaviour*]),
    [Signature-based], [Matches a database of known attack patterns; misses
    new attacks],
    [Anomaly-based], [Flags deviations from a baseline; catches unknowns but
    more false positives],
  )
]

#slide(title: "The Cost of Being Inline")[
  - IPS uses both signature- and anomaly-based detection
  - A false positive now *blocks legitimate traffic*, not just alerts
  - Being inline adds latency and a single point of failure
  - *Fail-open* vs. *fail-closed* is a deliberate choice:
    #linebreak() availability or security
]

#slide(title: "IDPS and Its Types")[
  - *IDPS:* IDS and IPS combined into one solution
  - *HIDPS:* on the host (servers), watches files and processes
  - *NIDPS:* on a network segment, watches the traffic
  - A network sensor cannot see inside encrypted traffic unless
    #linebreak() TLS is terminated there, so it does not replace host monitoring

  Modern IDPS merge into NGFW, SIEM and XDR, and increasingly use ML/AI.
]

#section-slide(title: "Incident Response")

#slide(title: "What Is Incident Response?")[
  - A systematic framework for responding to incidents
  - Primary role: handle, control and mitigate damage from a breach
  - Belongs in every organisation's security strategy

  #cblock(title: [Incident Response Plan])[
    A documented, tested plan. Rehearsed with *table-top exercises* that
    simulate a breach and find weaknesses before a real one.
  ]
]

#slide(title: "The Phases")[
  - *Detection:* monitoring flags unusual activity
  - *Analysis:* establish what happened and what is affected
  - *Containment:* isolate affected systems
  - *Eradication:* remove the cause (malware, account, flaw)
  - *Recovery:* restore operation, watch for the attacker
  - *Post-incident:* report as required, feed lessons back in
]

#slide(title: "Incident Response Life Cycle")[
  #align(center, image(
    "../lectures/images/Incident-Response-Lifecycle-black-text.png",
    height: 12cm,
  ))
]

#section-slide(title: "SIEM")

#slide(title: "Security Information and Event Management")[
  - SIEM = security information mgmt (SIM) + event mgmt (SEM)
  - Aggregates event data: apps, endpoints, firewalls, networks
  - Real-time monitoring and alerting for cyber threats

  #cblock(title: [Why it matters])[
    One log line usually means nothing. It becomes an incident only once
    events from several sources are correlated.
  ]
]

#slide(title: "The Pipeline")[
  ```text
  Sources        Pipeline          Output
  --------------------------------------------------
  firewalls  -+
  IDS / IPS  -+-> Collection    agents, syslog, API
  servers    -+       |
  endpoints  -+       v
  apps       -+  Normalise      one schema: time,
  cloud/IAM  -+       |         user, host, action
                      v
                 Correlate      rules + baselines
                      |
          +-----------+-----------+
          v           v           v
       alerts     dashboards   long-term
                              store
  ```
]

#slide(title: "Capabilities and Benefits")[
  #split(
    [
      *Capabilities*
      - Threat analytics
      - Cloud security
      - Compliance reporting
      - User behaviour analytics
      - Alerting, incident response
    ],
    [
      *Benefits*
      - Rapid detection
      - Forensic analysis
      - Historical log search
    ],
  )
]

#slide(title: "Limits and Challenges")[
  - SIEM only sees sources that are actually forwarded to it
  - Correlation rules only find patterns someone described
  - Needs integration with other solutions
  - Needs expert oversight; costs are high
  - Hard to tell regular activity from an incident

  #cblock(title: [The real lesson])[
    Coverage and tuning, not the product, decide how useful it is.
  ]
]

#slide(title: "Beyond SIEM: SOAR and XDR")[
  - *SOAR:* orchestration, automation and response
    #linebreak() extends a SIEM, but the combination stays reactive
  - *XDR:* extended detection and response, fills that gap
  - AI narrows the alert window and automates parts of response
]

#standout-slide(title: [The blue team's job is not to buy tools.
It is to make sure the alerts those tools raise reach a human who can act.])
