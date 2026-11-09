#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 02: Reconnaissance],
    subtitle: [Open Source Intelligence (OSINT)],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 02 - OSINT],
  ),
  config-common(
    handout: false,
  ),
)

#let meme(path) = slide(title: "", dark: true)[
  #align(center + horizon, image(path, height: 100%))
]

#title-slide()

#slide(title: "What is OSINT?")[
  #color-block(title: [Open Source Intelligence])[
    Turning *publicly available* data into actionable intelligence.
  ]

  - No hacking, no unauthorized access
  - Raw data #sym.arrow.r analysis #sym.arrow.r intelligence
  - Used for pentests, threat intel, incident response
]

#meme("figures/osint_astronaut.png")

#section-slide(title: "Four Flavours")

#slide(title: "1. People")[
  - Social media, GitHub, resumes
  - Breach notification services (Have I Been Pwned)
  - Photo metadata (EXIF)
  - *Why it matters:* this is what phishing is built on
]

#meme("figures/osint_same.png")

#slide(title: "2. Organizations")[
  - Website, press releases, job postings
  - LinkedIn: who works there, what they do
  - *Yields:* email format, tech stack, org chart
]

#meme("figures/osint_pigeon.png")

#slide(title: "3. Technical")[
  - WHOIS, DNS, TLS certificates
  - Shodan, Censys
  - Wayback Machine, public code repos
  - *Yields:* IP ranges, subdomains, exposed services
]

#slide(title: "4. Geospatial")[
  - Maps, street view, satellite imagery
  - Geotagged posts and photos
  - *Yields:* facility layout, entrances, working hours
]

#section-slide(title: "Tools")

#slide(title: "Technical OSINT in Four Commands")[
  ```bash
  whois example.com
  dig example.com ANY
  amass enum -d example.com
  # subdomains via certificate transparency:
  # https://crt.sh/?q=%.example.com
  ```
]

#slide(title: "Usernames and Emails")[
  ```bash
  theHarvester -d example.com -b google,linkedin
  sherlock username123      # same handle on other platforms?
  ```
]

#slide(title: "Frameworks")[
  - *Maltego* -- visual link analysis
  - *Recon-ng* -- modular, database-backed
  - *SpiderFoot* -- automated, 200+ modules
  - *osintframework.com* -- the map of everything
]

#slide(title: "Images")[
  ```bash
  exiftool photo.jpg   # GPS, camera, timestamp
  ```

  Reverse image search: Google, TinEye, Yandex.
]

#section-slide(title: "Workflow")

#slide(title: "Company Recon in Five Steps")[
  1. Domains and subdomains (`whois`, `amass`, crt.sh)
  2. Employees and email format (LinkedIn, theHarvester)
  3. Tech stack (job postings, Wappalyzer)
  4. Exposed services (Shodan, Censys)
  5. Draw the graph (Maltego)
]

#section-slide(title: "Rules")

#slide(title: "Public Is Not the Same as Fair Game")[
  - Terms of service, GDPR, anti-scraping laws still apply
  - Purpose matters: research vs. harassment
  - Store what you collect securely

  #color-block(title: [Golden rule])[
    Would you be fine if someone did this to you?
  ]
]

#standout-slide(title: [Finding is recon. Accessing is intrusion.])

#section-slide(title: "Defense")

#slide(title: "Protect Yourself")[
  - Lock down social media privacy
  - Strip EXIF before posting
  - Separate handles and emails per purpose
  - Do a self-OSINT audit once in a while
]

#slide(title: "Protect the Organization")[
  - Review job postings for over-sharing
  - WHOIS privacy
  - Monitor for leaked credentials
  - Quarterly self-OSINT audit
]

#slide(title: "Exercise: Self-OSINT")[
  1. Search your own name in quotes
  2. Check Have I Been Pwned
  3. Reverse-search your profile picture
  4. Write down what surprised you
]

#slide(title: "Resources")[
  - osintframework.com
  - inteltechniques.com
  - "We Are Bellingcat" by Eliot Higgins
  - Trace Labs OSINT CTF
]

#title-slide()
