#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 02: Reconnaissance],
    subtitle: [Information Gathering & NMAP],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 02 - Information Gathering],
  ),
  config-common(
    handout: false,
  ),
)

#let meme(path) = slide(title: "", dark: true)[
  #align(center + horizon, image(path, height: 100%))
]

#title-slide()

#slide(title: "Information Gathering")[
  #color-block(title: [Definition])[
    Collect, analyze and catalog data about a target until it becomes actionable.
  ]

  - *Network*: IPs, domains, DNS
  - *Systems*: OS, services, versions
  - *People*: names, email format, roles
]

#section-slide(title: "NMAP")

#slide(title: "What is NMAP?")[
  #quote-block[
    The network scanner. Since 1997. Free, scriptable, everywhere.
  ]

  1. *Host discovery* -- who is online?
  2. *Port scanning* -- what is open?
  3. *Version detection* -- what is running?
  4. *OS detection* -- what is it running on?
]

#slide(title: "Host Discovery")[
  ```bash
  nmap -sn 192.168.1.0/24   # ping sweep
  nmap -Pn 192.168.1.10     # skip ping, assume up
  nmap -PR 192.168.1.0/24   # ARP, best on local LAN
  ```
]

#slide(title: "Port Scanning")[
  ```bash
  nmap -sS 192.168.1.10          # SYN scan (root)
  nmap -sT 192.168.1.10          # full connect
  nmap -p- 192.168.1.10          # all 65535 ports
  nmap --top-ports 100 10.0.0.1  # the usual suspects
  ```
]

#slide(title: "Don't Forget UDP")[
  #color-block(title: [A TCP scan finds no UDP services. None.])[
    DNS, SNMP, TFTP and NTP are invisible until you ask for them.
  ]

  ```bash
  sudo nmap -sU --top-ports 20 192.168.1.10
  ```

  A full UDP sweep takes hours. Scan the top ports.
]

#slide(title: "Versions and OS")[
  ```bash
  nmap -sV 192.168.1.10   # service versions
  nmap -O  192.168.1.10   # OS fingerprint (root)
  nmap -A  192.168.1.10   # everything, loud
  ```

  ```
  PORT     STATE SERVICE VERSION
  22/tcp   open  ssh     OpenSSH 8.2p1
  80/tcp   open  http    Apache 2.4.41
  ```
]

#slide(title: "Port States")[
  - *open* -- a service answers
  - *closed* -- reachable, nothing listening
  - *filtered* -- a firewall dropped the probe
  - *open|filtered* -- UDP, can't tell
]

#meme("figures/ig_morpheus.png")

#slide(title: "Timing: -T0 to -T5")[
  - *T0/T1* -- paranoid, slow, hours
  - *T3* -- default
  - *T4* -- fast, fine on good networks
  - *T5* -- insane, misses results, may break things
]

#meme("figures/ig_fine.png")

#slide(title: "Always Save Output")[
  ```bash
  nmap -oA scan 192.168.1.10   # .nmap + .xml + .gnmap
  ```

  You will need it again. You will not remember the flags.
]

#meme("figures/ig_gru.png")

#section-slide(title: "NSE: Scripting Engine")

#slide(title: "NSE Scripts")[
  600+ Lua scripts in categories: `default`, `vuln`, `discovery`, ...

  ```bash
  nmap -sC target                              # safe defaults
  nmap --script=vuln target                    # known vulns
  nmap --script=ssl-enum-ciphers -p 443 target
  ```
]

#slide(title: "The Workflow")[
  ```bash
  nmap -sn 10.0.0.0/24 -oA 1-hosts            # 1. who is up
  nmap -iL hosts.txt -p- --open -oA 2-ports   # 2. what is open
  nmap -sV -sC -O -oA 3-services target       # 3. what is it
  nmap --script=vuln -oA 4-vulns target       # 4. what is wrong
  ```
]

#section-slide(title: "Enumeration")

#slide(title: "What is Enumeration?")[
  #color-block(title: [Scanning finds the door. Enumeration reads the nameplate.])[
    Pull users, shares, configs and policies out of each service.
  ]
]

#slide(title: "SMB (139/445)")[
  ```bash
  smbclient -L //192.168.1.10 -N          # list shares, no password
  smbclient //192.168.1.10/public -N -c ls
  enum4linux -a 192.168.1.10              # all of it, plus users
  ```

  `-N` is an anonymous session. No exploit needed.
]

#slide(title: "SNMP (161/udp)")[
  ```bash
  snmpwalk -v 2c -c public 192.168.1.1 1.3.6.1.2.1.1
  onesixtyone -c community.txt 192.168.1.1
  ```

  - Hostname, location, contact, interfaces
  - Default community strings: `public`, `private`. Still common.
]

#slide(title: "LDAP and DNS")[
  ```bash
  ldapsearch -x -h 192.168.1.10 -b "dc=example,dc=com"
  dig @ns1.example.com example.com AXFR   # zone transfer
  amass enum -d example.com               # subdomains
  ```
]

#section-slide(title: "Rules")

#slide(title: "Before You Scan")[
  #color-block(title: [Written authorization])[
    Scope, ports, timing, time window.
  ]

  - A fast full scan on an old embedded device is a denial of service
  - Log every command with a timestamp
]

#slide(title: "Defending")[
  - Turn off what you don't need
  - Change SNMP strings, block anonymous SMB, no zone transfers
  - Strip version banners
  - Alert on port sweeps
]

#slide(title: "Remember")[
  - `-sn` #sym.arrow.r `-p-` #sym.arrow.r `-sV -sC` #sym.arrow.r `--script=vuln`
  - Always `-oA`
  - Enumeration turns ports into usernames
  - Authorization first
]

#slide(title: "Resources")[
  - nmap.org/book
  - nmap.org/nsedoc
  - HackTheBox / TryHackMe
]

#title-slide()
