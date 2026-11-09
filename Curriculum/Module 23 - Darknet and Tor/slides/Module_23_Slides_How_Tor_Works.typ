#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 23: Darknet and Tor],
    subtitle: [How Tor Works],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 23 - How Tor Works],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "The Problem")[
  - TLS hides *what* you say
  - It does not hide *that* you talk to each other
  - A VPN moves the trust, it does not remove it

  #cblock(title: [Tor's goal])[
    No single point knows both *who you are* and *where you go*.
  ]
]

#section-slide(title: "Onion Routing")

#slide(title: "Three Relays")[
  #align(center + horizon, image("../lectures/images/tor-routing.png", width: 66%))
]

#slide(title: "Who Knows What")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 8pt,
    stroke: 0.5pt + gray,
    [*Relay*], [*Knows*], [*Does not know*],
    [Guard], [Your IP], [Destination],
    [Middle], [Guard and exit], [You, destination],
    [Exit], [Destination, plaintext if no TLS], [You],
  )

  Each relay peels *one* layer of encryption.
]

#slide(title: "Building a Circuit")[
  1. TLS to the guard, *ntor* key exchange (Curve25519)
  2. Through the guard: key exchange with the middle
  3. Through both: key exchange with the exit

  - One symmetric key per hop, AES in counter mode
  - Fixed-size *cells* (514 bytes): size reveals nothing
  - New circuit for new connections about every 10 minutes
  - Tor Browser: one circuit per site
]

#slide(title: "How Apps Talk to Tor: SOCKS")[
  The Tor client exposes a SOCKS port; behind it, it builds the circuit.

  ```bash
  curl --socks5-hostname 127.0.0.1:9050 \
    https://check.torproject.org/api/ip
  # {"IsTor":true,"IP":"185.220.101.x"}
  ```

  #cblock(title: [DNS leak])[
    Plain `--socks5` resolves the name *outside Tor*: your DNS resolver
    (usually your ISP) sees which site you visit.
  ]
]

#section-slide(title: "Directory System")

#slide(title: "Who Is in the Network?")[
  - Nine *directory authorities*, keys compiled into Tor
  - Every hour: collect, measure, vote, sign a *consensus*
  - Client needs a majority of signatures

  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [`Guard`], [Stable and fast enough for entry],
    [`Exit`], [Allows traffic to the normal internet],
    [`HSDir`], [Stores onion service descriptors],
    [`BadExit`], [Caught manipulating traffic],
  )
]

#slide(title: "Why Guards Stay Fixed")[
  #split(
    [
      *Random entry every time*
      - Sooner or later the attacker is your entry *and* exit
      - Unlucky again and again
    ],
    [
      *One guard for months*
      - Unlucky once, or safe for months
      - Limits long-term exposure
    ],
  )
]

#section-slide(title: "Censorship")

#slide(title: "Bridges and Pluggable Transports")[
  The relay list is public, so censors block it.

  - *Bridges:* unlisted relays, handed out a few at a time
  - *obfs4:* looks like random bytes
  - *Snowflake:* WebRTC via volunteer browser proxies
  - *meek:* hides behind a big cloud/CDN
  - *WebTunnel:* looks like normal HTTPS

  A permanent arms race.
]

#slide(title: "Tor Browser")[
  #cblock(title: [Goal])[
    Not invisible, but *indistinguishable*.
  ]

  - Same user-agent, fonts, time zone for everyone
  - Letterboxing hides your screen size
  - No history, cookies wiped, one circuit per site
  - Security levels: Standard, Safer, *Safest* (no JavaScript)
  - Don't install add-ons. Don't resize the window.
]

#section-slide(title: "Limits")

#slide(title: "What Tor Does Not Protect Against")[
  - Someone watching *both ends* (traffic correlation)
  - The exit reading unencrypted traffic
  - You logging into your own account
  - Malware and browser exploits
  - Apps that bypass the proxy
  - The fact that you use Tor (without bridges)
]

#standout-slide(title: [Tor hides who talks to whom. Not who you are.])
