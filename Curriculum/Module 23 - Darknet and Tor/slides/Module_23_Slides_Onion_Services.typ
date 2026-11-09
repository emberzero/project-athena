#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 23: Darknet and Tor],
    subtitle: [Onion Services],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 23 - Onion Services],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Hide the Server Too")[
  - Normal Tor: client anonymous, website public
  - *Onion service:* the server is anonymous as well
  - No public IP, works behind NAT and firewalls
  - Neither side learns where the other is
]

#section-slide(title: "Addresses")

#slide(title: "The Address Is the Key")[
  ```text
  pg6mmjiyjmcrsslvykfwnntlaru7p5svn6y2ymmju6nubxndf4pscryd.onion

  base32( public_key | checksum | version )
          32 bytes     2 bytes    0x03
  ```

  - No registry, no DNS, nobody can seize the name
  - Self-authenticating: no certificate authority needed
  - Impossible for humans to check
]

#slide(title: "The Private Key Is the Identity")[
  #cblock(title: [hs_ed25519_secret_key])[
    Whoever holds this file *is* the service.
  ]

  - Seized server + key = police can run the site
  - That is exactly what happened to Hansa (2017)
]

#section-slide(title: "Rendezvous")

#slide(title: "How Client and Service Meet")[
  #align(center, image("../lectures/images/onion-rendezvous.svg", height: 11.5cm))
]

#slide(title: "Step by Step")[
  0. Service keeps circuits to about 3 *introduction points*
  1. Publishes a signed *descriptor* to HSDir relays
  2. Client computes the HSDirs, fetches the descriptor
  3. Client picks a *rendezvous point*, leaves a cookie, asks via intro point
  4. Service connects to the rendezvous point

  *Six relays* in total. That's why it is slow.
]

#slide(title: "No List of All Onion Services")[
  - v2: HSDirs could read descriptors and harvest addresses
  - v3: daily *blinded* keys, descriptors encrypted with the address
  - You only find a service if someone tells you the address

  #cblock(title: [Client authorization])[
    Descriptor encrypted for listed keys only. Without a key you cannot even
    find the introduction points.
  ]
]

#section-slide(title: "Running One")

#slide(title: "Two Lines of torrc")[
  ```text
  HiddenServiceDir /var/lib/tor/my_service/
  HiddenServicePort 80 127.0.0.1:8080
  ```

  #cblock(title: [Most common unmasking], color: red.darken(20%))[
    Web server *also* reachable on its public IP. Shodan finds it; content,
    certificates or favicon hashes link the two.
  ]

  Also: `/server-status`, verbose error pages, outgoing requests.
]

#slide(title: "Vanity Addresses and Phishing")[
  - Brute-force keys until the prefix matches (`mkp224o`)
  - Each character: 32 times more work
  - Facebook's address starts with `facebook`
  - Scammers: same prefix + live proxy, swap crypto addresses

  *Defence:* address from the official website, bookmarks, *Onion-Location*.
]

#section-slide(title: "What Runs There")

#slide(title: "Onion Services in the Wild")[
  #split(
    [
      *Legitimate*
      - Tor Project, SecureDrop
      - BBC, DW, NYT, ProPublica
      - DuckDuckGo, Proton, Facebook
      - OnionShare, Briar, Ricochet
    ],
    [
      *Criminal*
      - Markets (escrow, ratings, Monero)
      - Ransomware leak sites
      - Access and exploit forums
      - Lots of plain scams
    ],
  )
]

#slide(title: "Attacks on Onion Services")[
  - *DoS:* introductions are cheap to send, expensive to serve
    - Since Tor 0.4.8: proof-of-work puzzles under attack
  - *Guard discovery:* first step to the server's IP
    - Defence: vanguards (lite version built in)
  - *Plain web bugs:* SQLi, uploads, misconfiguration
]

#standout-slide(title: [The protocol rarely breaks. The server does.])
