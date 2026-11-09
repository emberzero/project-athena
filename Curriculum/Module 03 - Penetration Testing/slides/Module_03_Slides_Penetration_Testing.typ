#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 03: Penetration Testing],
    subtitle: [Scoping, exploitation and the report],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 03 - Penetration Testing],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "What a Penetration Test Is")

#slide(title: "Definition")[
  An *authorized*, *time-boxed* attempt to compromise a defined
  set of systems, to show what an attacker could achieve.

  - The deliverable is not the compromise
  - The deliverable is a *report a defender can act on*

  #cblock(title: [The weight is on "authorized"], color: red.darken(20%))[
    The same commands are a service with a signed authorization
    and a crime without one. Austria: StGB #sym.section 118a,
    #sym.section 126a, #sym.section 126b. See Module 01.
  ]
]

#slide(title: "Four Services People Confuse")[
  #table(
    columns: (auto, 1fr, auto),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Service*], [*Question it answers*], [*Time*],
    [Vuln scan], [Which known weaknesses does automation report?], [Hours],
    [Vuln assessment], [Which are real, and how bad?], [Days],
    [Pen test], [What can an attacker actually reach?], [1-3 wk],
    [Red team], [Would defenders notice and respond?], [Weeks+],
  )

  A scan reports possibilities; a test demonstrates consequences;
  a red team tests the defenders.
]

#slide(title: "The Engagement Lifecycle")[
  #align(center, image("../lectures/images/pentest-phases.svg", width: 80%))

  Phases 2 to 5 are a *loop*, not a pipeline: a foothold
  restarts reconnaissance from the inside.
]

#slide(title: "Flavours of Test")[
  #split(
    [
      *Knowledge given*
      - Black box: name/IP only
      - Grey box: partial, the usual choice
      - White box: full, source included
    ],
    [
      *Position*
      - External: from the internet
      - Internal: from the LAN
      - Assumed breach: handed a foothold
    ],
  )

  More information given means more findings per day. It is a
  budget decision, not a security property.
]

#standout-slide(title: [A finding without a named control and a
  concrete fix is an unfinished finding.])

#section-slide(title: "Scoping and Reconnaissance")

#slide(title: "Pre-Engagement Questions")[
  Answer before quoting, in concrete identifiers:

  - *What* is in scope? CIDR ranges, FQDNs, URLs, app packages
  - *What is not?* Exclusions matter as much as inclusions
  - *From where*, with *what* starting knowledge?
  - *When* is the test window?
  - *How far* may we go? Exploit, pivot, exfiltrate?
  - *Who do we call* when something breaks?
]

#slide(title: "Rules of Engagement")[
  The RoE answers questions at 02:00 without waking anyone.

  - Scope and explicit out-of-scope list
  - Test window and time zone
  - Source IPs the tester uses, for the blue team
  - Permitted and forbidden techniques
  - Handling of discovered data, especially personal data
  - Stop conditions and the notification procedure

  Authorization must be *written and signed*. A call is not
  authorization. Cloud, shared hosting and third-party SaaS
  need separate permission; the client does not own them.
]

#slide(title: "Passive Reconnaissance")[
  Passive means querying third parties, not the target. Free,
  silent, the right place to start.

  - DNS records, WHOIS and RDAP
  - Search engines and code hosting (leaked keys, hostnames)
  - Job adverts: the stack, named by the client

  #cblock(title: [Highest-yield source])[
    *Certificate transparency* logs every issued TLS cert, so a
    domain search leaks names like `vpn-test` and `old-admin`.
  ]
]

#slide(title: "Active Reconnaissance")[
  Active means the target sees your traffic. Discovery first,
  then service enumeration.

  ```bash
  # host discovery only, no port scan
  nmap -sn 10.10.1.0/24

  # top ports, versions, default scripts
  sudo nmap -sS -sV -sC --top-ports 1000 \
    --open -oA scans/quick 10.10.1.20

  # drive scans from a scope file, never a typed CIDR
  sudo nmap -sS -sV -iL scope.txt -oA scans/scope
  ```

  Always `-iL`: it prevents the mistyped-mask accident.
]

#section-slide(title: "Vulnerability Assessment")

#slide(title: "From Scanner Output to Finding")[
  #align(center, image("../lectures/images/finding-triage.svg", width: 52%))

  A scanner report is raw material. The assessment is
  deduplication, manual verification and contextual rating.
]

#slide(title: "Classes of Weakness")[
  #table(
    columns: (1fr, auto),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [*Class*], [*Automation?*],
    [Missing patches], [Good],
    [Misconfiguration], [Good],
    [Weak crypto and transport], [Good],
    [Injection and input handling], [Partial],
    [Broken access control], [No],
    [Business logic flaws], [No],
  )

  A test whose findings are all in the top three is a scan with
  a nicer cover page.
]

#slide(title: "Verify Before You Report")[
  A version banner is a hypothesis, not a vulnerability.

  - Reproduce manually; record exact request and response
  - Prefer a *non-destructive* proof
  - State the privilege and network position it needed
  - Mark anything unreproducible as unverified, do not hide it

  Common false positives: backported fixes, proxy banners,
  honeypots, unreachable endpoints.
]

#slide(title: "Four Vocabularies, Often Mixed Up")[
  - *CVE* - a name for one bug in one product
  - *CWE* - the weakness type behind many CVEs
  - *CVSS* - a 0.0-10.0 score of the bug in the abstract
  - *EPSS* - the likelihood it is exploited in the wild

  #cblock(title: [CVSS is an input, not an answer])[
    A base score knows nothing about your client. A tester
    adjusts for exposure and data sensitivity, and says why.
  ]
]

#section-slide(title: "Exploitation and Post-Exploitation")

#slide(title: "Prove It With the Least Damage")[
  In order of preference:

  1. *Read-only proof* - retrieve one record you should not reach
  2. *Code execution proof* - run `id` or `whoami`, capture it
  3. *Interactive session* - only when you must explore the host

  Memory-corruption, kernel and "unreliable" exploits belong in
  a lab first. "I crashed the domain controller" ends the test.
]

#slide(title: "Metasploit Workflow")[
  ```text
  msf6 > use exploit/windows/smb/ms17_010_psexec
  msf6 exploit(...) > info
  msf6 exploit(...) > show options
  msf6 exploit(...) > set RHOSTS 10.10.1.30
  msf6 exploit(...) > check
  msf6 exploit(...) > exploit
  ```

  `info` and `check` are the two commands beginners skip. Run
  both before `exploit`, every time.
]

#slide(title: "Bind vs Reverse, and Egress")[
  - *Bind shell*: target listens, you connect. Inbound firewall
    almost always blocks it.
  - *Reverse shell*: target connects back to you, defeating
    inbound filtering.

  #cblock(title: [Why egress filtering is a control])[
    A server that may only reach the mirror and the log
    collector cannot call home. A large fraction of
    exploitation chains stop there. Name it as the remediation.
  ]
]

#slide(title: "Post-Exploitation: So What?")[
  Four questions, in order:

  1. *Where am I?* `id`, `hostname`, `ip addr`, `ss -tulpen`
  2. *Can I become root or SYSTEM?* sudo, SUID, creds, cron
  3. *What else can I reach?* Pivot into hidden networks
  4. *What is the actual impact?* In the client's terms

  Findings here are usually about *segmentation* and
  *credential reuse*, not about software bugs.
]

#slide(title: "Pivoting and Impact")[
  #align(center, image("../lectures/images/pivot-path.svg", width: 66%))

  State impact as "from the internet we reached the customer
  database", not "obtained SYSTEM on SRV-APP-02".
]

#slide(title: "Cleanup Rules")[
  - *Persistence* is usually out of scope
  - *Document* every file, account and setting you changed,
    with timestamps, even reverted ones
  - *Never clear logs* - it destroys investigation and may be a
    crime (StGB #sym.section 126a)
  - *Prove access to data without copying it* - the GDPR applies
    to the tester too
]

#section-slide(title: "Reporting")

#slide(title: "The Report Is the Product")[
  Two audiences, one document:

  - *Management* wants to know whether to worry and what it costs
  - *Engineers* want the exact request and the exact change

  Structure: title page, *executive summary*, scope and method,
  findings overview, detailed findings, strategic
  recommendations, appendices.
]

#slide(title: "Anatomy of a Finding")[
  Same fields, every time, so readers learn where to look:

  #split(
    [
      - Identifier and title
      - Severity (+ CVSS vector)
      - Affected assets
      - Description
    ],
    [
      - Impact, in client terms
      - Reproduction steps
      - Evidence (redacted)
      - Remediation + references
    ],
  )

  Give both a short-term mitigation and the structural fix for
  the whole class.
]

#slide(title: "Rate Risk Honestly")[
  - *Inflating*: everything "high" - engineers discount the real
    high too
  - *Deflating*: downgrading to please the client - not your call

  Show both the technical severity (with a vector) and the
  contextual adjustment, with the reason.

  When a client disagrees, *record the disagreement* rather than
  quietly changing the number.
]

#slide(title: "Closing the Loop")[
  - Say what you *could not* test, so no findings is not read as
    no risk
  - Map findings to MITRE ATT&CK so the blue team can build
    detections
  - Encrypt delivery, define retention, redact personal data
  - *Retest* after the fix and issue a short retest letter

  The retest letter is often the document the client forwards
  to an auditor.
]

#standout-slide(title: [Exploitation needs one bug.
  Post-exploitation needs the absence of several controls.])
