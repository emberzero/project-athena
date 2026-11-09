#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 04: Web],
    subtitle: [Introduction to Burp Suite],
    authors: [*Marcel Schnideritsch*],
    extra: [],
    footer: [Module 04 - Web Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Glossar")[
  #color-block(
    title: [Proxy: ],
    [
      A proxy like in Burp sits in the middle between your browser and the website, letting you see, stop, and change the requests and responses before they go through.
    ],
  )
]

#section-slide(title: "What is Burp Suite?")

#slide(title: "What is Burp Suite?")[
  #grid(
    columns: (2fr, 1fr),
    gutter: 3mm,
  )[
    - All-in-one tool for Webapp Testing
    - Proxy between browser & web application
    - Widely used by:
      - Penetration Testers
      - Bug Bounty Hunters
      - Security Researchers
  ][
    #place(
      dx: 20pt,
      dy: 50pt,
      image("../figures/burp_logo.png"),
    )
  ]
]

#slide(title: "Why Use Burp Suite?")[
  - Industry standard for WebApp pentesting
  - Automates scanning for vulnerabilities
  - Modular: Proxy, Repeater, Intruder, Scanner, etc.
  - Extensible with plugins (BApp Store)
  - Comprehensive toolset for web security testing
  - User-friendly interface
  - Active community & support
]

#slide(title: "Burp Suite Editions")[
  - Community Edition (Free, limited features)
  - Professional Edition (Paid, full features)
  - Enterprise Edition (Automated large-scale scanning)
]

#blank-slide()[
  #image("../figures/burp_cheat.png", height: 100%)
]

#section-slide(title: "Core Features")

#slide(title: "Burp Suite Components")[
  - Burp Proxy: Intercept & modify HTTP/S traffic
  - Burp Repeater: Manually modify & resend requests
  - Burp Intruder: Automated customized attacks
  - Burp Scanner: Automated vulnerability scanning (Pro only)
  - Burp Collaborator: Out-of-band interaction testing
  - Extensions: Add custom functionality via BApp Store
]

#section-slide(title: "Practical Demo Scenarios")

#section-slide(title: "Best Practices & Tips")

#slide(title: "Best Practices & Tips")[
  - Always define Scope
  - Organize with projects & sessions
  - Combine with browser plugins (FoxyProxy)
  - Regularly update Burp Suite to the latest version
  - Use the right tool for the task (Proxy, Repeater, Intruder)
  - Familiarize yourself with common web vulnerabilities (OWASP Top 10)
  - Leverage extensions from the BApp Store for additional functionality
  - Document your findings and steps taken during testing
]

#section-slide(title: "Hands-on Exercises")

#slide(title: "Resources")[
  - Labs: https://portswigger.net/web-security/all-labs
]

#title-slide(
  author: [Marcel Schnideritsch],
  title: [Introduction to Burp Suite],
  subtitle: [],
)
