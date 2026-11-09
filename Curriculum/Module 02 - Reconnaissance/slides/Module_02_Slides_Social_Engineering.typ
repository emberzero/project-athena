#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 02: Reconnaissance],
    subtitle: [Social Engineering in Reconnaissance],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 02 - Social Engineering],
  ),
  config-common(
    handout: false,
  ),
)

#let meme(path) = slide(title: "", dark: true)[
  #align(center + horizon, image(path, height: 100%))
]

// tall meme next to a few bullets
#let meme-split(title, path, body) = slide(title: title)[
  #grid(columns: (1fr, auto), gutter: 8mm, align(horizon, body), image(path, height: 10.5cm))
]

#title-slide()

#slide(title: "Social Engineering for Recon")[
  #color-block(title: [Definition])[
    Getting information from *people* that you can't get from systems.
  ]

  - This lecture: information gathering only
  - Full coverage: Module 22
]

#meme("figures/se_pooh.png")

#slide(title: "Why It Works")[
  - People want to be helpful
  - People trust authority
  - People are busy and under pressure
  - Perfect firewall, one chatty employee
]

#meme("figures/se_scc.png")

#section-slide(title: "Pretexting")

#slide(title: "The Pretext")[
  #color-block(title: [A believable story that justifies the question])[
    IT support, vendor, survey, new hire, potential customer.
  ]

  - Research first: real names, real jargon
  - Have answers ready for "who are you again?"
]

#meme("figures/se_spiderman.png")

#slide(title: "What Attackers Ask For")[
  - OS, antivirus, VPN, MFA in use
  - Email and username format
  - Badge system, visitor policy
  - Working hours, who is on vacation
]

#section-slide(title: "Channels")

#slide(title: "Phone (Vishing)")[
  - Real-time, can adapt to answers
  - Call when people are busy
  - Start small, escalate
]

#slide(title: "Email")[
  - "Five-minute technology survey"
  - Scales to hundreds of targets
  - Looks for *answers*, not clicks
]

#slide(title: "In Person")[
  - Tailgating through the door
  - High-vis vest and clipboard
  - Whiteboards, sticky notes, badges on lanyards
]

#meme("figures/se_bihw.png")

#slide(title: "Social Media")[
  - Office photos: screens, badges, whiteboards
  - "Finally finished our Palo Alto rollout!"
  - Complaints about internal systems
]

#section-slide(title: "Psychology")

#slide(title: "Cialdini's Six Levers")[
  1. *Authority* -- "This is corporate IT"
  2. *Reciprocity* -- "I helped you last time"
  3. *Social proof* -- "Your colleagues already did"
  4. *Scarcity* -- "Need it by end of day"
  5. *Liking* -- common ground, compliments
  6. *Consistency* -- small yes, then bigger yes
]

#standout-slide(title: [Urgency switches off thinking.])

#section-slide(title: "Defense")

#meme-split("Red Flags", "figures/se_panik.png")[
  - Urgent, unusual, secret
  - Asks you to skip procedure
  - Verifies *their* identity by asking *you* questions
]

#slide(title: "What To Do")[
  - Hang up, call back on a known number
  - Follow policy, escalate when unsure
  - Report attempts, even failed ones
  - Clean desk, challenge strangers, don't hold the door
]

#section-slide(title: "Rules")

#slide(title: "Authorization")[
  #color-block(title: [Written rules of engagement])[
    Who may be targeted, which channels, what is off limits.
  ]

  - Impersonating officials may be illegal
  - Recording calls needs consent
  - Debrief people as a lesson, never as punishment
]

#slide(title: "Remember")[
  - People leak what systems protect
  - Pretext + psychology = information
  - Verify, slow down, report
  - Authorization first
]

#slide(title: "Resources")[
  - "The Art of Deception" by Kevin Mitnick
  - "Influence" by Robert Cialdini
  - Module 22 - Social Engineering
]

#title-slide()
