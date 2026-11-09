#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 09: Forensics],
    subtitle: [Acquire, Analyse, Present],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 09 - Forensics],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "What Makes It Forensics")[
  - An admin is done when the service is back
  - A forensic examiner is done when *another examiner*, given the same
    evidence, reaches the same conclusion

  #cblock(title: [Incident response vs. forensics])[
    IR: what is happening, how do we contain it? \
    Forensics: what exactly happened, in what order, by whom, what can we prove?
  ]

  Pulling the power cable contains an attack *and* destroys RAM.
]

#section-slide(title: "Introduction")

#slide(title: "Branches of the Discipline")[
  Same method, different artefacts.

  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Branch*], [*Primary evidence*],
    [Disk / host], [Disk images, file systems, OS artefacts],
    [Memory], [A RAM capture],
    [Network], [Packet captures, flow records, proxy and DNS logs],
    [Mobile], [Phone acquisitions, app databases],
    [Cloud], [Provider audit logs, snapshots],
    [Malware analysis], [A suspicious binary],
  )
]

#slide(title: "The Forensic Process")[
  #align(center, image("../lectures/images/forensic-process.svg", width: 80%))

  - Identification, acquisition and preservation, analysis, presentation
  - The order is fixed; nothing skips backwards (ISO/IEC 27037, NIST SP 800-86)
]

#slide(title: "Core Principles")[
  - *Work on a copy*, never the original; the original is sealed
  - *Integrity is proven by hash*: SHA-256 of source and image
  - *Any interaction changes the system*: know and record what you changed
  - *Document as you go*: commands verbatim, timestamps, time zone (UTC)
  - *Repeatability*: no finding rests on a tool's verdict alone

  #cblock(title: [MD5], color: red.darken(20%))[
    Practical MD5 collisions are public since 2004. Not a sound integrity
    argument on its own.
  ]
]

#slide(title: "Order of Volatility (RFC 3227)")[
  ```text
  most volatile
  |  CPU registers, cache
  |  RAM: processes, connections, open files
  |  Network state: ARP cache, routing, sockets
  |  Running system: users, kernel modules
  |  Disk: file systems, swap, hibernation file
  |  Remote and off-system logs
  |  Physical config, backups, archived media
  least volatile
  ```

  "Unplug it immediately" is sometimes exactly the wrong move.
]

#slide(title: "Anti-Forensics")[
  - *Timestomping:* `$STANDARD_INFORMATION` vs. `$FILE_NAME` disagree
  - *Wiping:* targeted wiping leaves a hole in the timeline
  - *Log clearing:* on Windows, clearing a log is itself logged
  - *Encryption:* the volume key is in RAM while running
  - *Living off the land:* evidence moves to process and command-line logs

  #cblock(title: [Defence])[
    Evidence that *leaves the host*: forward logs in near real time to
    append-only central storage.
  ]
]

#slide(title: "Legal Frame in Austria")[
  - *Written authorisation before any acquisition*
  - Without it: StGB §118a (unlawful access); careless tools: §126a, §126b
  - Images contain personal data: the GDPR applies
  - Employee monitoring: involve the works council (Betriebsrat)
  - Crime suspected: seizure follows the StPO. *Preserve, do not seize*, get
    advice early
]

#section-slide(title: "Evidence Acquisition")

#slide(title: "What a Forensic Copy Is")[
  ```text
  file copy          ->  allocated file content only
  partition image    ->  one file system incl. free space
  full device image  ->  every sector of the device
  ```

  - Free space still holds deleted file content
  - File slack, swap, hibernation files, gaps between partitions
  - *Default to a full device image*
]

#slide(title: "The Acquisition Path")[
  ```text
  seized disk --read only--> hardware write blocker
    --> examiner workstation --dd / ewfacquire--> image file
  SHA-256 of source == SHA-256 of image
  ```

  - *Hardware write blocker* physically refuses write commands
  - Software fallback relies on the kernel honouring the flag:

  ```bash
  blockdev --setro /dev/sdb   # mark read-only
  blockdev --getro /dev/sdb   # 1 means read-only
  ```
]

#slide(title: "Imaging Tools")[
  ```bash
  dd if=/dev/sdb of=evidence.dd bs=4M \
     conv=noerror,sync status=progress
  dc3dd if=/dev/sdb of=evidence.dd hash=sha256 log=ev.log
  ewfacquire -t evidence -f encase6 -d sha256 /dev/sdb
  ewfverify evidence.E01
  ```

  - `noerror,sync` pads bad sectors, offsets stay correct
  - Without `sync` the image shifts and becomes useless
  - *E01*: compressed, case metadata, per-chunk CRCs
]

#slide(title: "Verification")[
  ```bash
  sha256sum /dev/sdb    > source.sha256
  sha256sum evidence.dd > image.sha256
  ```

  - Mismatch: image not usable. *A mismatch is a finding*, not a retry
  - Causes: source written to, padded read error, misreported size
  - Hash of an `.E01` *file* is not the hash of the acquired data
  - Failing disks may never give a stable hash: say so in the report
]

#slide(title: "Live Acquisition")[
  #split(
    [
      *Memory*
      ```bash
      avml /mnt/case/memory.lime
      ```
      - Processes, connections, keys
      - Tool appears in its own capture
      - Not a consistent snapshot
    ],
    [
      *Volatile state*
      ```bash
      date -u
      ps auxww
      ss -tupan
      ip neigh; ip route
      lsof -n -P; lsmod
      ```
      - Output to external storage
    ],
  )

  A rootkit can lie to every tool on the host; the memory image can be
  checked independently.
]

#slide(title: "Network, Cloud, Mobile")[
  ```bash
  tcpdump -i eth0 -s 0 -w /mnt/case/capture.pcap
  ```

  - With TLS, metadata (who, when, how much) is often all you have
  - *Cloud:* snapshot, export, hash; note query and time range
  - Audit logging must be enabled and protected *before* the incident
  - *Mobile:* logical acquisition via backup is the usual floor
]

#slide(title: "Chain of Custody")[
  ```text
  Item 09-001  Seagate ST1000, S/N XXXXXXX, 1 TB
  2026-03-02 09:14Z  seized, sealed bag #4471   M. Example
  2026-03-02 11:40Z  into evidence store        A. Keeper
  2026-03-03 08:05Z  released for imaging       -> B. Examiner
  2026-03-03 15:22Z  returned, seal intact      -> A. Keeper
  ```

  - Acquisition record: device, serial, blocker, tool + version, command, hashes
  - A gap in the chain can make a court disregard the evidence
]

#section-slide(title: "Analysis")

#slide(title: "Layers of a Storage Device")[
  #split(
    [
      #image("../lectures/images/storage-layers.svg", width: 100%)
    ],
    [
      ```bash
      mmls evidence.dd
      fsstat -o 2048 evidence.dd
      fls -o 2048 -r -d evidence.dd
      istat -o 2048 evidence.dd 128
      icat -o 2048 evidence.dd 128
      blkls -o 2048 evidence.dd
      ```
      Wrong offset: plausible garbage, not an error.
    ],
  )
]

#slide(title: "Deleted Files vs. Carving")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [], [*`fls` + `icat`*], [*Carving*],
    [Uses], [File system metadata], [File signatures only],
    [Name, path, times], [Yes, while the record survives], [No],
    [Fragmented files], [Yes], [Generally not],
    [False positives], [No], [Yes],
  )

  - Identify files by magic bytes (`file`), not the extension
  - NSRL hash sets eliminate known software; *elimination is not
    exoneration*
]

#slide(title: "Timestamps (MACB)")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [], [*NTFS*], [*ext4*],
    [M], [content modified], [`mtime`],
    [A], [accessed], [`atime`],
    [C], [MFT record changed], [`ctime` (inode changed)],
    [B], [born / created], [`crtime`],
  )

  - On Unix, `ctime` is *not* creation time
  - `atime` is often disabled (`relatime`, `noatime`)
  - Normalise to UTC; measure clock skew, don't correct silently
]

#slide(title: "Windows Artefacts")[
  - *Event logs* (`.evtx`), *Registry* hives, `NTUSER.DAT`
  - *Prefetch*: a program ran, roughly when; *Amcache*
  - `$MFT`, `$UsnJrnl`, Recycle Bin, LNK files, Jump Lists

  #table(
    columns: (auto, 1fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [4624 / 4625], [Successful / failed logon],
    [4688], [Process creation (if enabled)],
    [4720], [Account created],
    [7045], [Service installed (System log)],
  )
]

#slide(title: "Linux Artefacts")[
  - `auth.log` / `secure`: SSH logons, `sudo`
  - Journal, audit log (if auditd configured)
  - `/etc/passwd`, `/etc/shadow`: added accounts, UID 0 duplicates
  - Persistence: systemd units, cron, `authorized_keys`

  #cblock(title: [Shell history])[
    No timestamps unless `HISTTIMEFORMAT` was set, written at shell exit,
    easily edited. *A lead, never proof.*
  ]
]

#slide(title: "Memory Analysis with Volatility 3")[
  ```bash
  vol -f memory.raw windows.pslist
  vol -f memory.raw windows.cmdline
  vol -f memory.raw windows.netscan
  vol -f memory.raw windows.malfind
  ```

  - Processes without a file, injected code, full command lines, keys
  - *`pslist` vs. `psscan`*: found by scan but not in the list means
    unlinked, a rootkit technique
  - `linux.*` plugins need a symbol table for the exact kernel
]

#slide(title: "Network Analysis and the Timeline")[
  - TLS everywhere: analyse SNI, certificates, DNS, timing, volume
  - Fixed-interval small connections to one host: *beaconing*

  ```bash
  log2timeline.py --storage_file case.plaso evidence.dd
  psort.py -o l2tcsv -w timeline.csv case.plaso
  ```

  - Every row names its source artefact; normalise to UTC
  - One artefact is a lead, *two independent artefacts* are a finding
]

#section-slide(title: "Presenting Evidence")

#slide(title: "Know the Audience")[
  #table(
    columns: (auto, 1fr, auto),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Audience*], [*Wants*], [*Length*],
    [Management], [Impact, scope, what to do now, cost], [One page],
    [IT and security], [Indicators, systems, remediation], [A few pages],
    [Legal counsel], [What is provable, by which artefact], [Full report],
    [Court], [Method, reproducibility, limitations], [Full report, appendices],
  )

  *One layered report*, consistent at every layer.
]

#slide(title: "Writing a Finding")[
  ```text
  Observation     what the artefact literally contains
  Interpretation  what that means, and why
  Confidence      how firmly it supports the interpretation
  ```

  - Name the artefact: "`$UsnJrnl` entry", not "file system records"
  - "The `jdoe` account", not "Jane Doe"
  - Avoid _stolen_, _hacker_, _obviously_, _clearly_
  - Confidence scale: *High* (independent artefacts agree), *Moderate*,
    *Low*
]

#slide(title: "Limitations and Review")[
  #split(
    [
      *Limitations build credibility*
      - Encryption, lost volatile data
      - Log retention, clock skew
      - Live image, carved data
      - *Attribution*: account, not person
    ],
    [
      *Peer review checks*
      - Every finding cites an artefact?
      - Summary claims more than findings?
      - Hashes match acquisition records?
      - Times consistent, one zone?
    ],
  )

  Under challenge: defend the method and the artefact, not the tool. Correct
  errors immediately.
]

#standout-slide(title: [Reproducible by somebody else, or it is not forensics.])
