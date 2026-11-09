#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 12: Windows and AD Security],
    subtitle: [Tokens, Tickets and Tiering],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 12 - Windows and AD Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Why Windows")[
  - Windows dominates corporate desktops and a large share of servers
  - Almost every enterprise intrusion touches a Windows host somewhere

  #cblock(title: [Legal], color: red.darken(20%))[
    Own lab or written authorization only. In Austria: StGB §118a
    (unlawful access), §126a / §126b (damage); encountered personal data is
    under the GDPR. Module 01 has the detail.
  ]
]

#section-slide(title: "The Windows Security Model")

#slide(title: "Logon Produces a Token")[
  #split(
    [
      #image("../lectures/images/windows-logon.svg", width: 100%)
    ],
    [
      Windows never re-checks your password when you open a file. It checks the
      *token* your process carries.

      Obtaining or forging a token is as good as knowing the password.
    ],
  )
]

#slide(title: "SIDs and Well-Known RIDs")[
  ```text
  S-1-5-21-<domain>-1013
    authority 5 = NT Authority; sub-authority 21 = issued
    by a SAM or domain; final field = RID
  ```

  #split(
    [
      #table(
        columns: (auto, 1fr),
        inset: 5pt,
        stroke: 0.5pt + gray,
        [500], [Administrator],
        [502], [krbtgt],
        [512], [Domain Admins],
        [519], [Enterprise Admins],
      )
    ],
    [
      Renaming a user keeps the SID.
      ```text
      whoami /user
      whoami /groups
      whoami /priv
      ```
    ],
  )
]

#slide(title: "Tokens and Dangerous Privileges")[
  A token holds the user SID, group SIDs, privileges, an integrity level.
  Some privileges *are* SYSTEM, not a step towards it:

  #table(
    columns: (auto, 1fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [`SeDebugPrivilege`], [Open any process, including LSASS],
    [`SeImpersonatePrivilege`], [Impersonate a client that connects],
    [`SeBackup` / `SeRestore`], [Read / write any file, ignoring the DACL],
    [`SeTakeOwnership`], [Take ownership, then rewrite the DACL],
    [`SeLoadDriver`], [Load kernel code],
  )

  Service accounts often hold `SeImpersonatePrivilege`.
]

#slide(title: "Descriptors and Integrity")[
  #split(
    [
      *Security descriptor*
      - Owner (can always rewrite the DACL)
      - DACL: ordered allow / deny ACEs
      - SACL: audit entries only
      ```text
      icacls C:\inetpub\wwwroot
      ```
      `(M)` or `(F)` for `Users` on an executed path is a finding.
    ],
    [
      *Mandatory integrity*
      - Untrusted, Low, Medium, High, System
      - Low writes cannot reach a higher object
      - UAC issues filtered + full tokens
      - Microsoft does not treat UAC as a boundary
    ],
  )
]

#slide(title: "Where Credentials Live")[
  #table(
    columns: (auto, 1fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [*SAM hive*], [Local account NT hashes (needs SYSTEM hive too)],
    [*LSASS memory*], [NT hashes, Kerberos tickets and keys per session],
    [*DPAPI*], [Saved browser / Credential Manager secrets],
    [*MSCache / DCC2*], [Cached domain logons, crack-only],
  )

  An NT hash is unsalted MD4 and is *used directly* for NTLM auth, so a stolen
  hash authenticates without cracking. That is *pass-the-hash*.
]

#slide(title: "Credential Defences and Logon Types")[
  #split(
    [
      *Real fixes*
      - LSA Protection (`RunAsPPL`)
      - Credential Guard
      - Protected Users group
      - Don't log admins onto workstations (tiering)
    ],
    [
      *Logon types*
      - Type 2 Interactive: leaves creds
      - Type 3 Network: leaves *none*
      - Type 10 RDP: leaves creds
      - Prefer type 3 (PsExec) over RDP
    ],
  )

  Key events: 4624 logon, 4625 failed, 4672 admin logon, 4688 process (+ cmd
  line), 7045 service installed.
]

#section-slide(title: "Windows Security Features")

#slide(title: "Boot, Disk, Memory and Defender")[
  - *Secure Boot* verifies the boot chain; nothing after boot
  - *BitLocker* protects a *powered-off* machine; a running one is decrypted
    for every process. TPM-only without a PIN leaves a logon-screen gap
  - *Memory-safety:* DEP/NX, ASLR, CFG, CET (per-binary: one legacy DLL undoes
    ASLR)
  - *ASR rules* block attack classes (LSASS theft); *Tamper Protection* locks
    Defender settings
  - *Credential Guard* (VBS) isolates secrets: the structural pass-the-hash fix
]

#slide(title: "Application, Script and Network Control")[
  - *AppLocker:* allow-list by publisher (survives updates), path or hash.
    A path rule covering a user-writable folder is the classic mistake
  - *WDAC:* kernel-enforced, covers drivers, more work to deploy
  - *Script block logging* (4104): decoded script text, the valuable log
  - *AMSI:* hands buffers to AV before they run
  - *Constrained Language Mode:* safe PowerShell subset (with WDAC)
  - *Network (highest value):* require SMB signing, block
    workstation-to-workstation SMB/RPC, deploy *LAPS*
]

#section-slide(title: "Windows Penetration Testing")

#slide(title: "Impacket")[
  Python implementation of SMB, RPC, LDAP, Kerberos. Speaks the protocols
  from Linux.

  ```text
  domain/user:password@host
    -hashes LMHASH:NTHASH   pass-the-hash
    -k                      pass-the-ticket (Kerberos)
    -dc-ip 10.10.10.10      where the DC is
  ```

  `secretsdump.py` dumps hashes; `GetUserSPNs.py` kerberoasts;
  `ntlmrelayx.py` relays NTLM.
]

#slide(title: "What Execution Leaves Behind")[
  #table(
    columns: (auto, 1fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [*Method*], [*Artefact*],
    [`psexec.py`], [Binary to `ADMIN$` + service: event 7045, loud],
    [`smbexec.py`], [A service per command],
    [`wmiexec.py`], [No service / file; `wmiprvse.exe` child in 4688],
    [`atexec.py`], [Scheduled task in the Task Scheduler log],
  )

  All need valid privileged credentials. Defences: LAPS, deny network logon
  to local accounts, alert on unexpected 7045.
]

#slide(title: "Kerberos as an Attack Surface")[
  #split(
    [
      #image("../lectures/images/kerberos-flow.svg", width: 100%)
    ],
    [
      Two driving properties:
      - Service tickets are encrypted with the *service account's key*
      - The service *never consults the KDC*; it decrypts and believes the
        contents
    ],
  )
]

#slide(title: "Kerberoasting and AS-REP Roasting")[
  #split(
    [
      *Kerberoasting*
      - Any user requests a service ticket for any SPN
      - Crack the ciphertext offline
      ```text
      GetUserSPNs.py -request
      ```
      Defence: gMSA, AES, honeypot SPN, alert 4769 RC4.
    ],
    [
      *AS-REP roasting*
      - Accounts without pre-auth leak an AS-REP to anyone
      ```text
      GetNPUsers.py -request
      ```
      Defence: clear the flag. There is almost no legitimate use.
    ],
  )
]

#slide(title: "Ticket Forgery and Reuse")[
  - *Silver ticket:* forged service ticket from a stolen service key; invisible
    to DC logs
  - *Golden ticket:* forged TGT from the `krbtgt` key; any user, until the key
    changes. A *post-compromise* artefact
  - *Pass-the-ticket / overpass-the-hash:* tickets are portable; a hash can
    buy a real TGT

  Recovery from a golden ticket: reset `krbtgt` *twice* with replication
  between. Defence: Credential Guard, Protected Users, tiering.
]

#slide(title: "BloodHound and LOLBins")[
  #split(
    [
      *BloodHound*
      - Domain as a directed graph
      - Edges: `GenericAll`, `WriteDacl`, `DCSync`, `ForceChangePassword`
      - Privilege is transitive; one chain to DA is enough
      - *Run it as a defender* on a schedule
    ],
    [
      *LOLBins*
      - Signed Microsoft binaries abused
      - `certutil`, `regsvr32`, `rundll32`, `mshta`, `wmic`
      - "Signed by Microsoft" is not a security question
      - Detect by behaviour and parentage
    ],
  )
]

#slide(title: "Local Privilege Escalation")[
  Normal user to SYSTEM: nearly always a misconfiguration, not an exploit.

  - *Weak service permissions:* `SERVICE_CHANGE_CONFIG`, writable binary
  - *Unquoted service path* + writable parent directory
  - *`AlwaysInstallElevated`:* any MSI runs as SYSTEM; no safe use
  - Scheduled tasks, DLL search order, stored credentials
  - *`SeImpersonatePrivilege`* treated as SYSTEM

  Enumerate with WinPEAS / PowerUp / Seatbelt, then *verify each finding
  manually*.
]

#section-slide(title: "Introduction to Active Directory")

#slide(title: "What AD Is")[
  LDAP directory + Kerberos KDC + replication, on *domain controllers*.

  #cblock(title: [One sentence explains the module])[
    `C:\Windows\NTDS\ntds.dit` on every DC contains every password hash in the
    domain. A DC is the credential store for the whole organisation.
  ]

  Every DC holds a writable copy and replicates; there is no single master.
]

#slide(title: "Forest, Domain, OU")[
  #align(center, image("../lectures/images/ad-forest.svg", width: 66%))

  The *forest*, not the domain, is the security boundary. Two domains do not
  isolate; for real isolation you need separate forests.
]

#slide(title: "GPO, Replication, Reading the Directory")[
  - A GPO lives in the directory *and* in `SYSVOL` (world-readable in-domain).
    Edit rights over a GPO = admin rights over its scope
  - *Replication* (DRS over RPC) returns password hashes to a requesting DC.
    The two extended rights enable *DCSync*

  #cblock(title: [Enumeration is not an exploit])[
    Any authenticated user can read most of the directory, by design. Defence
    restricts what the directory *grants*, not who can read it.
  ]
]

#section-slide(title: "AD Security Features")

#slide(title: "Tiering: The Control That Matters")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Tier 0*], [DCs, AD, PKI; Domain / Enterprise / Schema Admins, the
      Operators groups, DnsAdmins (Backup Operators can read `ntds.dit` = DA)],
    [*Tier 1*], [Member servers, applications, business data],
    [*Tier 2*], [Workstations and their accounts],
  )

  The single rule: *a higher-tier credential is never exposed on a lower-tier
  machine.* Credential theft needs a credential present; tiering removes it.
  A Domain Admin with an SPN or a 5-year-old password is a finding.
]

#slide(title: "Protecting Accounts and Services")[
  - *Protected Users:* no NTLM, no RC4/DES, no caching, no delegation, 4h TGT.
    For humans, not service accounts
  - *Authentication Silos:* enforce tiering in the KDC
  - *AdminSDHolder:* reverts ACLs on protected groups hourly; stale
    `adminCount=1` marks former privilege
  - *LAPS:* per-machine local admin password; turns a workstation compromise
    from domain-wide to single-machine
  - *gMSA:* 240+ random bytes, auto-rotated: the answer to Kerberoasting
]

#slide(title: "Delegation")[
  In descending order of danger:

  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Unconstrained*], [Full TGT handed to the service; no safe modern use],
    [*Constrained*], [Impersonate users only to listed SPNs],
    [*RBCD*], [The resource names who may delegate to it],
  )

  ```powershell
  Get-ADComputer -Filter {TrustedForDelegation -eq $true}
  ```

  Mark sensitive accounts "cannot be delegated". Protected Users get this free.
]

#slide(title: "Protocols, Quota, DC Hygiene")[
  - Retiring NTLM: *audit, remediate, block.* Interim: *require SMB signing*,
    *LDAP signing + channel binding* on DCs, *EPA* on HTTP auth
  - Disable RC4, enable Kerberos armoring (FAST), rotate `krbtgt`
  - *Machine account quota to zero* unless something needs it (default 10)
  - DCs run nothing else; deny non-Tier-0 logon; patch promptly
  - Audit: Directory Service Changes, 4768/4769, 4776, group changes; *ship
    logs off the DC*
]

#section-slide(title: "AD Penetration Testing")

#slide(title: "NTLM Relay and Coercion")[
  #split(
    [
      #image("../lectures/images/ntlm-relay.svg", height: 10.5cm)
    ],
    [
      - LLMNR / NBT-NS / mDNS have no authentication; any host answers
      - Relay the NTLM exchange to a third service
      - *Coercion* (spooler, EFSRPC) triggers it on demand, often from a DC
    ],
  )
]

#slide(title: "First Credential: Relay and Spraying")[
  #cblock(title: [Highest-value hardening cluster])[
    Disable LLMNR / NBT-NS. Require SMB signing, LDAP signing + channel
    binding. EPA on HTTP enrollment. Disable the spooler on DCs. Retire NTLM.
  ]

  ```bash
  kerbrute passwordspray -d lab.local \
    --dc 10.10.10.10 users.txt 'Autumn2024!'
  ```

  Spraying survives lockout. Defence: banned-password lists beat complexity
  rules; MFA; alert on 4768/4771 failures across many accounts.
]

#slide(title: "Escalation Paths")[
  - *Kerberos:* Kerberoasting, AS-REP roasting, ticket reuse (lecture 3)
  - *Delegation abuse:* unconstrained yields TGTs; RBCD needs a writable
    computer object + the machine account quota
  - *AD CS:* a CA is Tier 0. ESC issues reduce to: enroller supplies the
    subject, or web enrollment accepts NTLM without channel binding
  - *DCSync:* replication rights fetch any hash, including `krbtgt`:

  ```bash
  secretsdump.py -just-dc-user krbtgt LAB.LOCAL/admin@10.10.10.10
  ```

  Detect DCSync: event 4662 from a non-DC. High fidelity.
]

#slide(title: "Trusts and Reporting")[
  #split(
    [
      *Trusts*
      - Within a forest: no SID filtering, transitive: any domain = the forest
      - Forest trust: SID filtering on by default; keep it on
    ],
    [
      *A finding names*
      - The path, step by step
      - The impact the client cares about
      - The single cheapest break
      - Whether monitoring would see it
    ],
  )

  Prioritise by paths removed: LAPS, SMB signing, LLMNR off, remove
  unconstrained delegation.
]

#standout-slide(title: [Almost every AD finding is a feature configured too generously.])
