#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 02: Reconnaissance],
    subtitle: [Search Engines for Reconnaissance],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 02 - Search Engines],
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

#slide(title: "Search Engines as Recon Tools")[
  #color-block(title: [Fully passive])[
    You query Google or Shodan. The target never sees a packet.
  ]

  - Google indexes pages, including ones nobody meant to publish
  - Shodan indexes devices
]

#section-slide(title: "Google Dorking")

#slide(title: "The Operators")[
  ```
  site:example.com
  filetype:pdf      ext:xls
  inurl:admin       intitle:"index of"
  intext:confidential
  ```
]

#meme-split("What People Leave Lying Around", "figures/search_gb.png")[
  ```
  intitle:"index of" backup
  site:example.com ext:sql
  intitle:"phpinfo()"
  ```

  - Directory listings, database dumps
  - Config files with credentials
  - Exact software versions
]

#slide(title: "Google Hacking Database")[
  Curated dorks, by category: exploit-db.com/google-hacking-database

  - Login pages, vulnerable servers
  - Files containing passwords
  - Error messages that leak paths
]

#section-slide(title: "Shodan")

#slide(title: "What is Shodan?")[
  #quote-block[
    The search engine for everything connected to the internet.
  ]

  - Scans the whole IPv4 space, grabs banners, indexes them
  - Webcams, routers, databases, ICS, medical devices
  - Cross-references versions with CVEs
]

#slide(title: "Shodan Filters")[
  ```
  hostname:example.com
  org:"Example Corp"
  port:3389  country:AT
  product:"Apache" version:"2.4.49"
  vuln:CVE-2021-44228
  ```
]

#meme-split("What Shodan Shows About You", "figures/search_panik.png")[
  - `org:` lists every IP registered to you
  - Only 443 open? Good.
  - `vuln:` has results? Patch today.
]

#slide(title: "Shodan CLI")[
  ```bash
  pip install shodan
  shodan init YOUR_API_KEY
  shodan search 'org:"Example Corp"'
  shodan host 203.0.113.10
  ```
]

#meme("figures/search_fine.png")

#slide(title: "Friends of Shodan")[
  - *Censys* -- strong on TLS certificates
  - *crt.sh* -- certificate transparency, `%.example.com`
  - *GitHub search* -- leaked keys, `filename:.env`
  - *Wayback Machine* -- what the site used to say
]

#section-slide(title: "Rules")

#standout-slide(title: [Finding is recon. Accessing is intrusion.])

#slide(title: "Responsible Use")[
  - Document, don't log in
  - Found something serious? Report it (CERT, the organization)
  - Only touch systems you are authorized to test
]

#section-slide(title: "Defense")

#meme("figures/search_cmm.png")

#slide(title: "Stay Out of the Index")[
  - `robots.txt` is a polite request, not a lock
  - `noindex` meta tag, Search Console removal
  - Real fix: authentication, not obscurity
]

#slide(title: "Watch Your Own Footprint")[
  ```
  site:yourcompany.com intitle:"index of"
  site:yourcompany.com ext:sql
  org:"Your Company" vuln:*
  ```

  Quarterly. Fix what you find. Strip version banners.
]

#slide(title: "Remember")[
  - Dorks find documents; Shodan finds devices
  - Passive, but very effective
  - Finding is fine, accessing is not
  - Search for yourself before attackers do
]

#slide(title: "Resources")[
  - exploit-db.com/google-hacking-database
  - shodan.io, help.shodan.io
  - TryHackMe Google Dorking room
]

#title-slide()
