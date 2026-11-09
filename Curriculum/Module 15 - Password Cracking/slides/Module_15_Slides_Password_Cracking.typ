#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 15: Password Cracking],
    subtitle: [Storage, Techniques, Tools and Policy],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 15 - Password Cracking],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "What Password Cracking Is")[
  - Recovering a plaintext password from a derived value, usually a hash
  - Not one technique but a *search*:
    + guess a candidate
    + apply the same transformation the system applied
    + compare the result
  - Everything else is a way of making that search cheaper
]

#slide(title: "Legal Boundary", )[
  #cblock(title: [Authorised systems only], color: red.darken(20%))[
    Cracking a hash you may not possess is an offence in Austria under StGB
    §118a and §126c. Recovered credentials are personal data under the GDPR.
  ]

  Work only on your own lab or under written, scoped authorisation.
  Module 01 covers the legal framework.
]

#section-slide(title: "How Passwords Are Stored")

#slide(title: "Why Passwords Are Not Stored")[
  - A system needs to *recognise* a password, not know it
  - It stores a one-way function; the check compares outputs
  - Three expected properties:
    - *Preimage resistance:* output to input is infeasible
    - *Determinism:* same input always gives same output
    - *Cost:* each evaluation should be deliberately slow
]

#slide(title: "Enrolment and Verification")[
  #align(center, image("../lectures/images/salted-hash-storage.svg", width: 90%))
]

#slide(title: "Hash, Salt, Cost")[
  - *Plain hash* (`SHA256(pw)`): fast and unsalted -- a poor store
    #linebreak() leaks reuse, precomputable forever
  - *Salt:* random value mixed in, stored next to the hash
    #linebreak() kills precomputation, hides reuse -- but does *not* slow a guess
  - *Cost:* a tunable work factor is what slows the attacker

  #cblock(title: [A salt is not a secret])[
    The attacker has it. It raises the cost of building tables, not of a
    single known-hash guess.
  ]
]

#slide(title: "Key Derivation Functions")[
  #table(
    columns: (auto, 1fr),
    table.header([*Function*], [*Notes*]),
    [PBKDF2], [Iteration count; CPU-only, cheapest to attack],
    [bcrypt], [Cost factor; GPU-unfriendly; truncates at 72 B],
    [scrypt], [Memory-hard; attack HW needs RAM],
    [Argon2id], [Memory-hard; current recommendation (RFC 9106)],
  )

  Memory-hardness starves the parallel units a GPU/ASIC relies on.
]

#slide(title: "Where Hashes Come From")[
  - *Unix:* `/etc/shadow`, scheme id + salt + hash (`$6$`, `$y$`...)
  - *Windows:* SAM / NTDS.dit -- the NT hash is *unsalted* and
    #linebreak() a *single fast* iteration; also reusable (pass-the-hash)
  - *App databases:* a leaked `users` table; depends on the dev
  - *Captured protocol material:* Kerberos tickets, NetNTLM,
    #linebreak() WPA2 handshakes -- all attackable offline
]

#section-slide(title: "Online vs. Offline")

#slide(title: "Two Different Threat Classes")[
  #align(center, image("../lectures/images/online-vs-offline.svg", width: 88%))
]

#slide(title: "Online vs. Offline")[
  #split(
    [
      *Online*
      - Guesses hit a live service
      - Rate set by the defender
      - Every attempt is logged
      - Stopped by rate limits,
        lockout, MFA
    ],
    [
      *Offline*
      - Runs on attacker hardware
      - No rate limit, no logs
      - Defender cannot notice
      - Only cost (KDF) and
        unlikeliness help
    ],
  )

  A breach notification is also a cracking deadline.
]

#slide(title: "Keyspace and Entropy")[
  ```text
  lowercase only      26^8 ~ 2.1 * 10^11
  lower+upper+digits  62^8 ~ 2.2 * 10^14
  all printable ASCII 95^8 ~ 6.6 * 10^15
  ```

  - Entropy $= L dot log_2(N)$, only for *uniformly random* choices
  - `Sommer2024!` is long but near the front of any guess order
  - Length is the cheaper lever than character classes

  #cblock(title: [Entropy measures the generator, not the string])[]
]

#section-slide(title: "Techniques")

#slide(title: "The Only Loop There Is")[
  #align(center, image("../lectures/images/cracking-pipeline.svg", width: 85%))

  The hash is fixed by the target; a technique is judged on how much of the
  realistic population it covers per guess.
]

#slide(title: "Dictionary and Rule-Based Mangling")[
  - *Dictionary:* try a list; the single highest-yield technique,
    #linebreak() because password choice is heavily concentrated
    #linebreak() stopped by a *blocklist* at the moment of choosing
  - *Mangling rules:* encode human habits as transformations
    #linebreak() `sommer` to `Sommer2024!` or `s@mm3r1`
    #linebreak() stopped by removing predictability + a slow KDF
]

#slide(title: "Brute Force and Mask Attacks")[
  - *Brute force:* every string over an alphabet
  - *Mask:* structure imposed per position, removing huge spaces

  ```text
  ?l a-z   ?u A-Z   ?d 0-9   ?s symbols
  ?u?l?l?l?l?l?d?d?d?d  (very common human shape)
  ```

  - Each `?l` multiplies by 26, each `?a` by ~95
  - *Stopped by length:* past ~12 random chars it is infeasible
]

#slide(title: "Combinator, Hybrid and Statistical")[
  - *Combinator / hybrid:* word + word, or word + year/digits
    #linebreak() a very common real shape; stopped by *enough* random words
  - *Statistical / Markov:* emit candidates by estimated likelihood
    #linebreak() the sharpest tool against human-chosen passwords

  "My password looks random" is a weak claim -- so did millions of others.
]

#slide(title: "Rainbow Tables")[
  - A time-memory trade-off: precompute chains, store endpoints
  - Largely *historical*

  #cblock(title: [A per-user salt defeats them completely])[
    An n-bit salt needs $2^n$ tables. They survive only where salts are
    absent, e.g. legacy LM hashes. LM is off by default on modern Windows.
  ]
]

#slide(title: "Attacks That Skip Cracking")[
  - *Credential stuffing:* replay breached pairs; works via *reuse*
    #linebreak() defence: MFA, breach checks, traffic-pattern detection
  - *Password spraying:* one password against many accounts
    #linebreak() evades lockout; defence: org-wide detection
  - *Hash / ticket reuse:* pass-the-hash, Kerberos reuse
    #linebreak() defence: architectural -- tiering, limit exposure
]

#section-slide(title: "Tools")

#slide(title: "The Toolchain")[
  ```text
  1. acquire    a hash, handshake, encrypted archive
  2. extract    convert to a crackable line
  3. identify   determine algorithm and mode
  4. attack     run the cracker; iterate candidates
  ```

  Skipping *identify* is the most common beginner mistake -- the wrong mode
  gives zero results and tells you nothing.
]

#slide(title: "John the Ripper vs. Hashcat")[
  #table(
    columns: (auto, 1fr),
    table.header([*Tool*], [*Strength*]),
    [John the Ripper], [Format breadth; `*2john` helpers extract from
    archives, SSH keys, KeePass, etc.],
    [Hashcat], [GPU-first raw speed; needs a type number `-m` and an
    attack mode `-a`],
  )

  ```text
  john --wordlist=rockyou.txt --rules=Jumbo hashes.txt
  hashcat -m 1000 -a 0 hashes.txt rockyou.txt -r best64.rule
  ```
]

#slide(title: "Inspect and Measure")[
  - `--stdout` shows candidates without hashing (learn a rule set)
  - `--show` prints what is already cracked (the pot file)
  - Benchmark on *your* hardware; never trust quoted numbers

  ```text
  hashcat -b -m 3200      # bcrypt
  hashcat -b -m 0         # MD5
  ```

  #cblock(title: [The whole argument of this module])[
    The ratio between those two rates: the *defender's* hash choice, not the
    attacker's hardware, dominates the outcome.
  ]
]

#slide(title: "Online and Wordlists")[
  - Online tools (`hydra`, `netexec`) are loud and detectable
    #linebreak() used sparingly and in scope; lockout can cause an outage
  - The *candidate list* matters more than the tool
    #linebreak() `rockyou.txt` is the classic start; SecLists collects more
  - A *targeted* list beats a bigger generic one
    #linebreak() org vocabulary, product names, the local town, the year
]

#section-slide(title: "Policies and Best Practices")

#slide(title: "A Layered Model")[
  #split(
    [
      Each layer assumes the one above has failed.

      A control that stops working when the database leaks is a convenience,
      not a layer.
    ],
    [
      #align(center, image("../lectures/images/defence-layers.svg", height: 12.5cm))
    ],
  )
]

#slide(title: "What Modern Guidance Says")[
  #split(
    [
      *Do*
      - Set a meaningful minimum length (12+)
      - Allow a long max (64+), full Unicode
      - Check against a blocklist
      - Allow password managers
      - Store with a memory-hard KDF
    ],
    [
      *Do not*
      - Composition rules
      - Forced periodic rotation
      - Password hints / questions
      - Silent truncation
    ],
  )

  Sources: NIST SP 800-63B, BSI IT-Grundschutz, OWASP.
]

#slide(title: "Blocklists and Rate Limiting")[
  - A *blocklist* removes the top of the distribution -- where a
    #linebreak() dictionary earns almost all its hits
    #linebreak() k-anonymity lookup (e.g. HIBP) checks without sending the password
  - Prefer *throttling with backoff* over hard lockout
    #linebreak() (hard lockout is a denial-of-service primitive)
  - Rate limit per account *and* per source
  - Identical response for unknown user and wrong password
]

#slide(title: "Beyond the Password: MFA")[
  #table(
    columns: (auto, auto, auto),
    table.header([*Factor*], [*Guessing*], [*Phishing*]),
    [SMS code], [resists], [no],
    [TOTP app], [resists], [no],
    [Push approval], [resists], [partly],
    [FIDO2 / WebAuthn], [resists], [yes],
  )

  Only FIDO2 binds the challenge to the origin, so a proxy site fails.
]

#slide(title: "Passkeys and SSO")[
  - *Passkey:* a FIDO2 credential as the primary factor
    #linebreak() nothing reusable transmitted, no server secret to steal
    #linebreak() removes offline cracking, stuffing and phishing at once
  - *SSO:* fewer password stores, but concentrates risk on the IdP
    #linebreak() -- where the strongest controls belong
]

#slide(title: "Auditing Your Own Policy")[
  - The legitimate application: crack your own hashes to test policy
  - Required before anything technical:
    + *Written authorisation* (systems, window, people)
    + A *GDPR data protection assessment*
    + Report *statistics, not passwords*
    + A documented *destruction step*

  A useful metric is not "how many" but *how fast* they fall.
]

#standout-slide(title: [A policy is good if it moves passwords away from what
attackers find easily -- not if it merely feels strict.])
