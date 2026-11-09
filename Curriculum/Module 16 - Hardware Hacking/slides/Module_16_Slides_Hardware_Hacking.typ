#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 16: Hardware Hacking],
    subtitle: [Devices in Your Hands],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 16 - Hardware Hacking],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Introduction")

#slide(title: "Why Attack Devices Physically?")[
  - *Firmware* is the shortest path to the whole product line
  - Embedded systems are *long-lived*, often with no update channel
  - Cost pressure removes secure boot, encrypted flash, tamper detection
  - The device is the *oracle*: power-cycle it, single-step boot, watch every bus

  #cblock(title: [The broken assumption])[
    "The attacker cannot read our flash" stops being safe once they can touch the device.
  ]
]

#slide(title: "The Attack Surface")[
  #align(center + horizon, image("../lectures/images/attack-surface.svg", height: 82%))
]

#slide(title: "Buses You Will Meet")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Bus*], [*Typical use*], [*Gives an attacker*],
    [UART], [Serial console, bootloader], [A shell, boot messages],
    [SPI], [External flash, radios], [The whole firmware image],
    [I2C], [EEPROM, sensors, RTC], [Config, small keys],
    [JTAG], [Factory test, debug], [Halt CPU, read/write RAM],
    [SWD], [ARM Cortex-M debug], [The same, over two pins],
  )

  UART needs an agreed baud rate (115200, 9600). SPI and I2C are clocked.
]

#slide(title: "Finding the Pads")[
  1. Photograph both sides of the board
  2. Read every IC marking, pull the datasheets
  3. *Powered off:* continuity mode finds GND
  4. *Powered on:* steady 3.3 V is likely VCC; UART TX idles high, dips on boot
  5. Logic analyser or USB-serial adapter: *look before you write*

  #cblock(title: [Careful], color: red.darken(20%))[
    Check logic levels: 5 V into a 3.3 V pin destroys parts.
  ]
]

#slide(title: "The Toolbox")[
  #split(
    [
      - Multimeter
      - USB-to-serial adapter
      - Logic analyser + sigrok
      - SPI programmer + `flashrom`
      - SOIC-8 test clip
    ],
    [
      - Soldering iron, hot air
      - JTAG/SWD probe + OpenOCD
      - Oscilloscope
      - Proxmark3 / NFC reader
      - JTAGulator (pin finding)
    ],
  )

  A usable bench costs less than a laptop.
]

#slide(title: "First Contact Over UART")[
  ```bash
  ls /dev/tty*        # /dev/ttyUSB0, /dev/ttyACM0
  picocom -b 115200 /dev/ttyUSB0
  screen /dev/ttyUSB0 115200
  ```

  - Garbage output = wrong baud rate
  - Step through 9600 ... 115200, or let a logic analyser decode it

  #align(center)[
    recon #sym.arrow access #sym.arrow extract #sym.arrow analyse #sym.arrow exploit
  ]
]

#slide(title: "Law and Defence")[
  #cblock(title: [Authorization first], color: red.darken(20%))[
    StGB §118a (unauthorised access), §126a (damaging data), §126b (interfering). Get permission *in writing*; buy your own targets.
  ]

  #table(
    columns: (1fr, 1.4fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [*Attack path*], [*What stops it*],
    [Reading flash], [Encrypted flash, keys in OTP],
    [UART / JTAG], [Disabled / fused in production],
    [Modified firmware], [Secure boot, ROM root of trust],
  )
]

#section-slide(title: "RFID and NFC")

#slide(title: "Frequency Bands")[
  #table(
    columns: (auto, 1fr, auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Band*], [*Standards*], [*Range*], [*Use*],
    [125/134 kHz], [EM4100, HID Prox], [few cm], [Old badges],
    [13.56 MHz], [ISO 14443, 15693], [to 10 cm], [Access, NFC],
    [860-960 MHz], [EPC Gen2], [metres], [Logistics],
  )

  - *LF:* read-only ID, no authentication. Any reader in range gets the ID.
  - Treat LF credentials as *public identifiers*, never as secrets.
]

#slide(title: "HF Card Families")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*MIFARE Classic*], [Crypto1, 48-bit keys. Broken since 2008, still common],
    [*Ultralight / NTAG*], [Little or no crypto. Fine for URLs and tickets],
    [*DESFire EV1/2/3*], [3DES/AES mutual auth. Sound with per-card keys],
    [*JavaCard / 7816*], [Full smartcards: passports, payment],
  )

  Enumerating a card is read-only: `hf search`, `hf 14a info`.
]

#slide(title: "Attacks, and What Each Requires")[
  - *Skimming / cloning:* trivial on LF; needs sector keys on Classic; fails on properly keyed DESFire
  - *Eavesdrop / replay:* works on static data, not on fresh-nonce challenge-response
  - *Downgrade / integrator error:* default keys, one shared key, reader accepts the weak card

  #cblock(title: [The UID is an address, not a secret])[
    Phones randomise it; "magic" cards set it freely. Authorising on UID alone is bypassed by a blank card.
  ]
]

#slide(title: "Relay Attacks")[
  #align(center + horizon, image("../lectures/images/rfid-relay.svg", width: 82%))

  Two proxies bridge a real reader and a victim's card. The crypto is *untouched*; only physical defences stop it: distance bounding, shielding, or a non-relayable second factor.
]

#slide(title: "RFID Defensive Checklist")[
  - Cards with *mutual authentication* (DESFire EV2/EV3); deprecate LF and Classic
  - *Diversify keys per card* from a master in a secure module
  - Never authorise on the UID; authorise on successful crypto auth
  - Log the access decision on a backend; watch for odd patterns
  - Second factor at high-value doors (PIN, unlocked mobile credential)
  - Treat the reader as untrusted; authenticate the reader-to-controller link
]

#section-slide(title: "Biometrics")

#slide(title: "Biometrics: The Core Property")[
  #cblock(title: [Not a secret, and cannot be revoked], color: red.darken(20%))[
    You leave fingerprints on every glass; your face is photographed daily. A leaked password changes; a leaked fingerprint is gone for life.
  ]

  - *Verification (1:1):* "are you who you claim?" against one template
  - *Identification (1:N):* "who is this?" against the whole database; error rates scale badly with N
]

#slide(title: "The Pipeline, and Where It Breaks")[
  #align(center + horizon, image("../lectures/images/biometric-pipeline.svg", height: 66%))

  Capture #sym.arrow extract #sym.arrow store #sym.arrow match #sym.arrow decide. The *decision bit* to the door relay matters most: cut the line, short the relay, and no biometric helps.
]

#slide(title: "Error Rates")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*FAR*], [False Accept: an impostor is accepted],
    [*FRR*], [False Reject: a legitimate user is rejected],
    [*EER*], [Equal Error Rate: where FAR equals FRR],
    [*FTE / FTA*], [Failure to Enrol / to Acquire],
  )

  - FAR and FRR trade off on *one threshold*; no setting improves both
  - FAR describes *zero-effort* impostors, not a deliberate spoof
]

#slide(title: "Presentation Attacks")[
  An artefact fed to the sensor. Countermeasure: *presentation attack detection* (PAD), tested to ISO/IEC 30107.

  - *Fingerprint:* lifted latent cast in flexible material
  - *Face:* printed photo, screen replay, 3D mask
  - *Iris:* high-res photo, contact lens for curvature
  - *Voice:* recording, replay, synthesis

  The easier a trait is to capture remotely, the easier it is to spoof.
]

#slide(title: "Templates and Defensive Design")[
  #split(
    [
      *Templates*
      - Store the template, never the sample
      - Cannot be hashed: matching is fuzzy
      - Use template protection; match on-device in a secure element
    ],
    [
      *Design*
      - Biometric as *one factor*, not the only one
      - Tested PAD, named methodology
      - Authenticate reader to controller
      - Fallback no weaker than the primary path
    ],
  )
]

#slide(title: "Biometrics and the Law")[
  #cblock(title: [GDPR Article 9], color: red.darken(20%))[
    Biometric data for identification is *special category* data. Consent is rarely free between school and pupil; a DPIA is normally required.
  ]

  For a school project: enrol *yourself*, with your own consent, delete afterwards, keep it out of any shared repository.
]

#section-slide(title: "Reverse Engineering Embedded Systems")

#slide(title: "Three Questions, In Order")[
  1. What is on the board?
  2. How do I get the firmware?
  3. What does the firmware do?

  #align(center)[
    SoC marking #sym.arrow datasheet #sym.arrow boot modes, pins, debug
  ]
  #align(center)[
    flash marking #sym.arrow datasheet #sym.arrow command set, capacity
  ]

  Recon first: part numbers decide every later option.
]

#slide(title: "Getting the Firmware")[
  Least to most invasive, try in order:

  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Vendor image*], [Download an update; cheapest, no hardware],
    [*Bootloader*], [U-Boot console over UART: `md`, `printenv`],
    [*JTAG / SWD*], [OpenOCD `halt` then `dump_image`],
    [*External flash*], [SOIC-8 clip + `flashrom`, or esptool on ESP32],
  )

  Read the chip *twice* and compare hashes: a bad clip gives a plausible corrupt image.
]

#slide(title: "Understanding the Image")[
  ```bash
  file dump.bin
  binwalk -E dump.bin    # entropy: flat+high = encrypted
  binwalk -e dump.bin    # carve the filesystem
  unsquashfs rootfs.sqfs
  ```

  - High uniform entropy, no strings = encrypted or compressed
  - A Linux image holds bootloader, kernel, SquashFS rootfs, config
  - Bare-metal image = flat binary, vector table: static analysis in Ghidra
]

#slide(title: "What to Look For")[
  ```bash
  cat etc/passwd etc/shadow
  grep -rIn "BEGIN .*PRIVATE KEY" .
  grep -rIn -e password -e secret -e token etc/
  ls -l etc/init.d/        # what starts at boot
  ```

  Recurring, boring, serious findings:
  - Root hash that cracks in seconds
  - One TLS key shared by the whole product line
  - Hardcoded creds in a CGI script, `telnetd` always on, HTTP updates
]

#slide(title: "RE Defensive Counterparts")[
  #table(
    columns: (1fr, 1.2fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [*Extraction route*], [*What makes it fail*],
    [Vendor image], [Signed, encrypted packages],
    [Bootloader console], [Disabled or per-device secret],
    [JTAG / SWD], [Debug port fused off],
    [External flash], [Flash encryption, key in OTP],
    [Any image obtained], [No shared secrets; per-device keys],
  )

  Preventing extraction only delays. What protects the fleet: the image holds nothing worth having, and a modified image will not boot.
]

#section-slide(title: "Exploiting Embedded Systems")

#slide(title: "Check the Boring Paths First")[
  - *Default / hardcoded credentials* over the device's own telnet or SSH
  - *Debug services:* `telnetd`, vendor daemons, "support" HTTP endpoints
  - *Bootloader console:* attacker-controlled boot arguments

  ```text
  => setenv bootargs 'console=ttyS0,115200 init=/bin/sh'
  => boot
  ```

  A root shell, no credentials. *Shared secrets* are the single most damaging design error.
]

#slide(title: "Memory Corruption Is Easier Here")[
  Same classes as Modules 04 and 06 (stack, heap, format string, integer overflow), friendlier environment:

  - Often *no ASLR, no canaries, no NX*
  - Everything runs as *root* in one address space
  - No crash reporting, no restart with a new layout
  - Old pinned libraries

  Cheap fixes: hardening flags, a non-root user, a watchdog, a current libc.
]

#slide(title: "Secure Boot")[
  #align(center + horizon, image("../lectures/images/secure-boot-chain.svg", height: 58%))

  A chain of signature checks anchored in mask ROM + OTP fuses. Property: *only vendor-signed code runs.* It fails through writable first stage, unverified rootfs, rollback, or leaked signing keys.
]

#slide(title: "Fault Injection")[
  Push the chip outside spec so *one instruction misbehaves*: skip the branch that says "if signature invalid, stop".

  - Voltage glitch, clock glitch, EM pulse, laser, temperature
  - The work is *timing*: sweep width and offset over thousands of tries
  - ChipWhisperer is the standard learning platform

  Defences (all design-time): redundant checks, no single-bit decisions, environmental sensors, random delays, a secure element.
]

#slide(title: "Side-Channel Analysis")[
  A chip leaks through *power, EM and time*. Fault injection changes behaviour; side channels only observe, and that recovers keys.

  - *SPA:* one trace shows the algorithm's shape
  - *DPA / CPA:* many traces, statistics, key one byte at a time
  - *Timing:* an early-exit `memcmp` of a MAC leaks its answer

  Answer: constant-time code and comparison, masking, blinding. Not secrecy.
]

#slide(title: "Putting the Defences Together")[
  #split(
    [
      1. Root of trust in ROM + OTP
      2. Full chain of trust
      3. Encrypted flash
      4. Debug fused off
      5. Per-device keys
    ],
    [
      6. Signed updates, anti-rollback
      7. Hardened userland
      8. Secure element
      9. Tamper response
      10. Fleet monitoring
    ],
  )

  Not every product needs all ten. A €15 sensor and a payment terminal sit at different points; deciding where is threat modelling.
]

#standout-slide(title: [Break one unit, not the fleet. Per-device keys, signed boot, a backend that notices.])
