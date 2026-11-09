#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 01: Ethics],
    subtitle: [Hacker Ethics – Guiding Principles in IT Security],
    authors: ([*Marcel Schnideritsch*]),
    extra: [],
    footer: [Module 01 - Ethics],
  ),
  config-common(
    handout: false,
  )
)

#title-slide()

#section-slide(title: "Introduction to Hacker Ethics")

#slide(title: "Definition")[
  #color-block(
    title: [Hacker Ethics],
    [
      *Hacker ethics* are moral values shaping how individuals in the cybersecurity community act.

      They emphasize:

      - Curiosity, creativity, and freedom of information
      - Responsible behavior in the digital world
      - A tradition originating in the 1960s/70s, codified by Steven Levy (1984)

      *Not about crime—about exploration and improving systems.*
    ],
  )
]

#section-slide(title: "Core Principles")

#slide(title: "Core Principles – Part 1")[
  1. *Information should be free*

    Open knowledge promotes innovation and transparency.

  2. *Unlimited access to learning tools*

    Hands-on exploration (*tinkering*) fosters understanding.

  3. *Mistrust authority – promote decentralization*

    Power should be distributed, not centralized.

  #alert("Inspired by hacker subcultures at MIT and beyond.")
]

#slide(title: "Core Principles – Part 2")[
  4. *Judge by skill, not status*

    Merit over formal credentials.

  5. *Code as art*

    Beauty in elegant solutions and creative hacks.

  6. *Computers can improve lives*

    #alert("Ethical use of tech to empower people and fix broken systems.")
]

#section-slide(title: "Ethical Dilemmas")

#slide(title: "Ethical Dilemmas Overview")[
  #set table(
    stroke: none,
    gutter: 0.2em,
    fill: (x, y) => if x == 0 or y == 0 {
      gray
    },
    inset: (right: 1.5em),
  )
  #table(
    columns: 3,
    align: (left, left, left),
    [*Category*], [*Intent*], [*Typical Actions*],
    [White Hat], [Improve security], [Authorized testing, reporting],
    [Grey Hat], [Ambiguous], [Unsolicited testing],
    [Black Hat], [Personal gain], [Exploitation, theft],
  )

  #alert("Ethics are shaped not just by actions—but also by intent and context.")
]

#slide(title: "Dilemma 1: Vulnerability Disclosure")[
  *What should you do when you find a vulnerability?*

  - *Responsible disclosure:* Notify vendors, give time to fix
  - *Full disclosure:* Go public to pressure action
  - *Non-disclosure:* Risky but sometimes done

  #alert("⟶ Community norms favor responsible, coordinated disclosure.")
]

#slide(title: "Dilemma 2: Privacy vs. Security")[
  *How do we balance protection and freedom?*

  - Surveillance can prevent threats—but may violate privacy
  - Ethical hackers support:

    - Privacy-preserving tech (e.g., encryption)
    - Transparent oversight and accountability

  #alert("\"Security\" is not an excuse to erase rights.")
]

#slide(title: "Dilemma 3: Gray Hat Behavior")[
  *Is it okay to break rules for a good cause?*

  - Access without permission—then report flaws
  - Intention is good, but legality is unclear
  - Laws like the CFAA make this a risky path

  #alert("⚠️ Even good intentions can lead to legal consequences.")
]

#section-slide(title: "Conclusion")

#slide(title: "Conclusion")[
  Hacker ethics are about #alert("how") and #alert("why") we hack.

  They call for:

  - Curiosity, creativity, and responsibility
  - Openness and meritocracy
  - Continuous reflection and legal awareness

  #alert("Ethical hacking is about building a better, safer digital world.")
]

#slide(title: "Further Reading")[
  - *Hackers* – Steven Levy (1984)
  - *The Hacker Ethic* – Pekka Himanen (2001)
  - *The Cathedral and the Bazaar* – Eric S. Raymond (1999)
  - *Coordinated Vulnerability Disclosure* – Householder et al. (2020)
  - *Economics of Privacy* – Acquisti et al. (2015)
  - *Ethical Analysis of Hacking* – Denning et al. (2014)
]

#title-slide(
  title: [Module 01: Ethics],
  subtitle: [Hacker Ethics – Guiding Principles in IT Security],
)
