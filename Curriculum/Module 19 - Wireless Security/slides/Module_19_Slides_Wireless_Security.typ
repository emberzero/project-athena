#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 19: Wireless Security],
    subtitle: [WiFi Architecture, Attacks and Defences],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 19 - Wireless Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Why Wireless Is Different")[
  - Data travels over radio, not cables
  - Anyone in radio range can receive it
  - No physical port needed to listen in

  #cblock(title: [Focus of this module])[
    Many wireless protocols need securing. This module covers *WLAN* (WiFi).
  ]
]

#section-slide(title: "Wireless Network Architecture")

#slide(title: "Types of Wireless Networks")[
  #table(
    columns: (auto, 1fr, auto),
    inset: 8pt,
    stroke: 0.5pt + gray,
    [*Type*], [*Scope*], [*Example*],
    [WPAN], [Personal, short range, low power], [Bluetooth],
    [WLAN], [Homes and offices, 2.4 / 5 GHz], [WiFi],
    [WMAN], [City-wide], [WiMAX],
    [WWAN], [Broad areas, cellular], [GSM, LTE, 5G],
  )
]

#slide(title: "WiFi Generations")[
  #table(
    columns: (auto, auto, auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Name*], [*Standard*], [*Max. bandwidth*], [*Band*],
    [Wi-Fi 7], [802.11be], [46120 Mbit/s], [2.4, 5, 6 GHz],
    [Wi-Fi 6E], [802.11ax], [9608 Mbit/s], [6 GHz],
    [Wi-Fi 6], [802.11ax], [9608 Mbit/s], [2.4, 5 GHz],
    [Wi-Fi 5], [802.11ac], [6933 Mbit/s], [5 GHz],
    [Wi-Fi 4], [802.11n], [600 Mbit/s], [2.4, 5 GHz],
    [--], [802.11g / a / b], [54 / 54 / 11 Mbit/s], [2.4 / 5 / 2.4 GHz],
  )

  Theoretical maxima, not real-world throughput.
]

#slide(title: "WLAN Topologies and Hardware")[
  #split(
    [
      *Topologies*
      - *BSS:* clients and one AP
      - *ESS:* linked BSSs, roaming
      - *Mesh:* nodes forward for each other
      - *Ad-hoc (IBSS):* no AP at all
    ],
    [
      *Hardware*
      - *Access Point:* broadcasts the signal
      - *WLAN controller:* manages many APs centrally
      - *Clients:* laptops, phones, IoT
    ],
  )
]

#slide(title: "SSIDs and Channels")[
  - *SSID:* the network name, sent in beacon frames
  - Hiding the SSID is *not* a security measure
  - 2.4 GHz: channels 1-14, 20 MHz wide, overlapping
  - Channels *1, 6, 11* do not overlap
  - 5 GHz: channels 36-165, high-speed transfer
  - One sender per channel at a time: *CSMA/CA*
    - Listen first, wait a random time if busy
    - RTS/CTS reserve the channel
]

#slide(title: "Frame Types")[
  #split(
    [
      - *Management:* beacons, probes, authentication
      - *Control:* help deliver data (RTS/CTS)
      - *Data:* carry user data
    ],
    [
      #table(
        columns: (1fr, auto),
        inset: 5pt,
        stroke: 0.5pt + gray,
        [*Field*], [*Bytes*],
        [Frame Control], [2],
        [Duration], [2],
        [Addresses], [6 each],
        [Sequence Number], [2],
        [Payload], [var.],
        [FCS], [4],
      )
    ],
  )
]

#slide(title: "Joining a Network")[
  1. *Discovery:* beacons (passive) or probe request (active)
  2. *Authentication:* OSA / SKA / SAE
  3. *Association:* request and response
  4. *Key exchange:* WPA2 4-way handshake / WPA3 SAE

  #cblock(title: [Sent in the clear], color: red.darken(20%))[
    Everything up to step 4 is plaintext management frames: SSIDs, which
    clients are on which AP, when they join or leave.
  ]
]

#slide(title: "Passive vs Active Scanning")[
  #split(
    [
      *Passive*
      - Listen for beacons on each channel
      - Client sends nothing
      - Slower
    ],
    [
      *Active*
      - Send probe requests
      - Faster, finds hidden SSIDs
      - Leaks the client's remembered SSIDs
    ],
  )

  Hidden SSID: shows up in probes and association requests as soon as a
  client connects. It shifts exposure to the client.
]

#section-slide(title: "WiFi Security Fundamentals")

#slide(title: "Risks and Protocols")[
  *Risks:* unauthorized access, data interception, disruption, malware

  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*WEP*], [Broken: key recovered in minutes. Never use.],
    [*WPA*], [Deprecated: TKIP built on RC4],
    [*WPA2*], [OK with AES-CCMP and strong passphrase],
    [*WPA3*], [Current standard: SAE, mandatory PMF],
  )

  Disable WEP/TKIP fallbacks: mixed mode can be downgraded.
]

#slide(title: "Basic Hardening")[
  - Strong passphrase, non-identifying SSID
  - *Disable WPS:* PIN is open to brute force
  - Router firewall on, firmware updated
  - Limit transmit power, separate guest network
  - Review connected devices

  #cblock(title: [MAC filtering is not a control])[
    MAC addresses are sent in the clear and trivial to copy.
  ]
]

#section-slide(title: "Authentication and Encryption")

#slide(title: "Authentication Methods")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*OSA*], [No credentials, AP accepts everyone],
    [*SKA*], [WEP key challenge-response, client only],
    [*PSK*], [Shared passphrase, WPA/WPA2-Personal],
    [*EAP*], [Framework: certificates, OTP, Kerberos, ...],
    [*RADIUS*], [Central AAA server for enterprise WiFi],
  )
]

#slide(title: "SKA: Worse Than Nothing")[
  1. Client requests authentication
  2. AP sends a *clear-text* challenge
  3. Client returns it encrypted with the WEP key
  4. AP checks and accepts

  #cblock(title: [Why it backfires], color: red.darken(20%))[
    One captured exchange gives a known plaintext and ciphertext pair,
    hence the RC4 keystream. Replay it to authenticate without the key.
  ]
]

#slide(title: "WPA2 Four-Way Handshake")[
  - Both sides derive the *PMK* from passphrase + SSID
  - Passphrase itself is never transmitted
  - M1: ANonce, then M2: SNonce + MIC, then M3: GTK, then M4: ack
  - Result: per-session key *PTK* for encryption

  #cblock(title: [Offline cracking], color: red.darken(20%))[
    M1 + M2 are enough: crack the passphrase offline against the MIC.
    A deauth frame forces a fresh handshake on demand.
  ]
]

#slide(title: "EAP and Enterprise")[
  - AP is only a *relay* between client and RADIUS server
  - AP never sees the password
  - Each user has individual credentials
  - Server's MSK seeds the 4-way handshake

  #cblock(title: [Validate the certificate], color: red.darken(20%))[
    If clients skip server certificate validation, a rogue AP with its
    own RADIUS server captures the credentials.
  ]
]

#slide(title: "Encryption: WEP and WPA")[
  #split(
    [
      *WEP*
      - RC4, static shared key
      - 24-bit IV repeats
      - CRC-32: not cryptographic
      - Statistical key recovery in minutes
      - Key length irrelevant
    ],
    [
      *WPA (TKIP)*
      - New key per packet (key mixing)
      - IV sequence counter
      - "Michael" MIC replaces CRC-32
      - Still RC4: no longer secure
    ],
  )
]

#slide(title: "Encryption: WPA2 and WPA3")[
  #split(
    [
      *WPA2*
      - AES with CCMP
      - KRACK (2017): key reinstallation
      - Fixed by *patches*, not a new protocol
    ],
    [
      *WPA3*
      - *SAE* replaces PSK handshake
      - No offline cracking
      - Forward secrecy
      - Mandatory PMF
      - OWE: per-client keys, open nets
    ],
  )

  OWE does not authenticate the AP: no defence against an evil twin.
]

#section-slide(title: "WiFi Attack Vectors")

#slide(title: "Passive vs Active")[
  #split(
    [
      *Passive*
      - Monitor only, change nothing
      - Hard or impossible to detect
      - Sniffing, traffic analysis
      - Defence: encryption, VPN
    ],
    [
      *Active*
      - Inject, alter, disrupt
      - Easier to detect
      - MITM, DoS, rogue AP
      - Defence: monitoring, IDS
    ],
  )
]

#slide(title: "Seven Common Attack Vectors")[
  #table(
    columns: (auto, auto, 1fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [*Attack*], [*Type*], [*Main defence*],
    [Sniffing], [Passive], [Encryption (WPA3/OWE)],
    [MITM], [Active], [HTTPS, VPN],
    [DoS (deauth)], [Active], [PMF (802.11w)],
    [Evil twin], [Active], [Verify AP, fingerprinting],
    [Packet injection], [Active], [Encryption, IDS],
    [WiFi phishing], [Active], [User education],
    [Password cracking], [Mostly passive], [Long passphrase, WPA3],
  )
]

#slide(title: "Details That Matter")[
  - *WPA2-PSK:* anyone with the passphrase and a client's handshake can
    decrypt that client's traffic
  - *Deauth:* management frames unauthenticated by default
  - *Jamming:* no protocol prevents it, only detect and locate
  - *WPS PIN:* checked in two halves, small search space
  - *Offline cracking:* no login attempt reaches the network
]

#section-slide(title: "Wireless Penetration Testing")

#slide(title: "Core Tools")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Aircrack-ng*], [Monitor, capture, inject, crack keys],
    [*Kismet*], [Passive discovery, sniffer, WIDS],
    [*Wireshark*], [Protocol analyzer, per-packet detail],
  )

  Monitor mode needs an adapter and driver that support it, the usual
  practical obstacle.
]

#slide(title: "Cracking a WPA2 Passphrase")[
  1. Monitor mode, lock to the target channel
  2. Note the target BSSID and channel
  3. Capture the four-way handshake (or deauth to force one)
  4. Crack with a wordlist against the captured MIC offline
  5. With the passphrase, join and decrypt earlier traffic

  #cblock(title: [It is a guessing attack])[
    The handshake holds no passphrase, only a MIC to test guesses against.
    A long random passphrase simply does not fall to it.
  ]
]

#slide(title: "Evil Twin Attack")[
  1. *Recon:* scan SSID, channel, clients
  2. *Rogue AP:* same SSID, often a stronger signal
  3. *Deauth burst:* spoofed frames evict clients
  4. *Re-associate:* client picks the strongest match
  5. *Gateway:* captive portal, DNS spoof, TLS downgrade, capture

  A rogue AP cannot reproduce the passphrase, so it runs as an open
  network with a portal asking the victim for credentials.
]

#slide(title: "Evil Twin: Limits and Defences")[
  - Correctly configured HTTPS with HSTS and a VPN still hold
  - So the attack targets the *user* through a portal, not the crypto

  #cblock(title: [Defences])[
    - PMF blocks the deauth step
    - Enterprise with enforced certificate validation stops auth
    - Users: never enter the passphrase into a web page
  ]
]

#section-slide(title: "Best Practices")

#slide(title: "Defence in Layers")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Policy / people*], [Acceptable use, training, IR plan],
    [*Monitoring*], [WIDS, rogue-AP detection, audits],
    [*Segmentation*], [Guest VLAN, client isolation],
    [*Authentication*], [WPA2/3-Enterprise, RADIUS, MFA],
    [*Link encryption*], [AES-CCMP or GCMP, PMF enabled],
    [*Device hygiene*], [Firmware patching, WPS disabled],
  )

  Defeating one layer still leaves an attacker facing the next.
]

#slide(title: "Passphrases and Updates")[
  #split(
    [
      *Passphrases*
      - Entropy beats character rules
      - Long random phrase wins
      - No forced periodic changes (NIST)
      - Change on departure or breach
    ],
    [
      *Patching*
      - Firmware is where fixes land
      - Automate updates
      - Test before wide rollout
      - Many attacks exploit known bugs
    ],
  )
]

#slide(title: "Monitoring, Policy, Response")[
  - Continuous monitoring: anomalies, unknown devices
  - IDS alerts automatically, deauth floods included
  - Periodic audits: access control, encryption, policies
  - Security policy: acceptable use, access, incidents
  - Incident response plan written *in advance*
  - Staff training sustains a security culture
]

#standout-slide(title: [Pick a current protocol and a strong passphrase. Everything else reduces exposure, it does not replace that.])
