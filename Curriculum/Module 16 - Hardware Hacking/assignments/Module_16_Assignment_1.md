# Assignment 1: Firmware Extraction, Analysis and Threat Model

## Objective

You will take one firmware image for an embedded device, triage it, carve its filesystem, and work
out what an attacker gains from it: credentials, keys, services started at boot, and the binaries
that handle untrusted input. You will then write the threat model for that device and answer the
only question that matters commercially: does compromising one unit compromise the whole fleet.

## Logistics

- **Work:** individual, or pairs if your instructor allows it. Pairs submit one PDF with both
  names and a short statement of who did what.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module16_Assignment1.pdf`.

## Setup

**No hardware is required and nothing here costs money.** Pick one of the two target paths:

- **Path A (recommended):** a publicly downloadable firmware update image from the vendor support
  page of a consumer device: a home router, an IP camera, a network printer, a smart plug. Prefer a
  device you own. A Linux-based device of a few megabytes is a better target than a tiny
  microcontroller image, because it has a filesystem to carve.
- **Path B:** an image provided by your instructor. Use this if Path A gives you an encrypted
  image you cannot get into, or if you have no suitable device.

Tooling, all free, in a Linux VM:

```bash
sudo apt install binwalk squashfs-tools qemu-user-static file xxd unzip
# plus a disassembler: Ghidra or radare2
```

If the image you downloaded turns out to be fully encrypted, say so with the evidence from task 2
and switch to Path B. Documenting a dead end with proof is a valid result, not a failure.

## Rules of engagement

- This is an **offline analysis** assignment. Nothing you do runs against a live device, a
  network, or a service.
- **In scope:** the firmware image file, and a device you personally own if you attempt the
  hardware bonus.
- **Out of scope:** your school's network and equipment, any device you do not own, any device on
  loan from the school without written permission from its owner, and any attempt to log in to a
  real device with credentials you recovered. Finding a password in an image and then using it on
  a device that is not yours is the point at which analysis becomes an offence in Austria
  (StGB §118a, §126a, §126b). Module 01 covers the detail.
- Do not redistribute the firmware image or anything extracted from it. Keep the extracted
  filesystem inside your VM. If a configuration partition contains personal data, do not include
  it in your report; describe it instead.
- Keep your report readable without the image attached. Do not attach the firmware.

## 1. Know your target

Before you open the file, research the device.

**In the report:**

- Device name, model, hardware revision if known, and the exact firmware version and download URL
  you used (or "instructor-provided image", with its filename and SHA-256).
- A component table built from teardown photographs, the vendor's documentation, FCC filings or
  datasheets: SoC, RAM, flash chip (type and size), radios, and anything else you can identify.
  Give a datasheet link per part where you found one. Mark anything you inferred rather than
  confirmed.
- A bus table: for each of UART, SPI, I2C and JTAG/SWD, state whether the board plausibly exposes
  it, what evidence you have, and in one sentence what an attacker with access to that bus could
  do. Use the entry points from lecture 1 and the extraction routes from lecture 4.

## 2. Triage the image

```bash
sha256sum firmware.bin
file firmware.bin
binwalk -E firmware.bin        # entropy
strings -n 8 firmware.bin | head -40
```

**In the report:** the SHA-256 of the image, the `file` output, the entropy plot or a description
of it, and your verdict: plaintext, compressed, or encrypted. Justify the verdict with the
entropy shape and the presence or absence of readable strings, as in lecture 4, stage 3.

## 3. Carve the filesystem

```bash
binwalk firmware.bin           # signature scan with offsets
binwalk -e firmware.bin
# if the root filesystem is found but not unpacked:
dd if=firmware.bin of=rootfs.sqfs bs=1 skip=<offset>
unsquashfs rootfs.sqfs
```

**In the report:** a partition map table with one row per region `binwalk` identified: offset
(hex), size, type, and what it is (bootloader, kernel, root filesystem, configuration area,
padding). Then the top two levels of the extracted filesystem tree, the init system in use, and
the total number of files. If the image is bare-metal with no filesystem, say so and instead give
the load address and reset vector you determined, and skip to task 5.

## 4. Hunt the attack surface

Work through the filesystem the way lecture 4 describes:

```bash
cd squashfs-root
cat etc/passwd etc/shadow 2>/dev/null
grep -rIn "BEGIN .*PRIVATE KEY" .
grep -rIn -e password -e secret -e token etc/ usr/ 2>/dev/null
ls -l etc/init.d/ etc/rc.d/ 2>/dev/null
find . -perm -4000 -type f 2>/dev/null
grep -rIn "http://" etc/ usr/sbin/ 2>/dev/null
```

**In the report:** a findings table, ordered by severity, with these columns:

| Finding | File and offset or path | Severity | Why it matters | Local or fleet-wide |
| --- | --- | --- | --- | --- |

"Fleet-wide" means the finding compromises every unit of the product, not just the one you looked
at: a shared TLS key, a hardcoded root password, a signing key. Mark each finding accordingly, and
include at least one row for something you looked for and did *not* find. A short, honest table is
worth more than a long one padded with every `grep` hit.

Also list the services started at boot, and for each one state whether it listens on the network.

## 5. One binary, properly

Pick a single binary that handles untrusted input: the web server, a CGI script, the UPnP or
mDNS daemon, the update client. Then either

- run it under user-mode QEMU from inside the extracted filesystem, as in lecture 4:

```bash
cp "$(which qemu-arm-static)" squashfs-root/
sudo chroot squashfs-root ./qemu-arm-static /usr/sbin/httpd -h
```

- or load it into Ghidra or radare2 with the right architecture and analyse it statically.

**In the report:** the binary's path, architecture and whether it is stripped; the output of the
emulation attempt (including the error, if it refused to run, and your reading of why); the names
or addresses of the functions that read attacker-controlled input; and one plausible weakness you
can point at with evidence (an unbounded copy, a `system()` call built from input, a credential
comparison). **You are not asked to write an exploit.** State clearly what you proved and what
remains a hypothesis.

## 6. Threat model

Fill in the defence table from lecture 1 for your target, and justify every row from what you
actually observed in the image:

| Attack path | Defence | Present on this device | Evidence | Consequence if absent |
| --- | --- | --- | --- | --- |

Cover the six paths from the lecture: reading external flash, UART console, JTAG/SWD, firmware
rollback, cloned or modified firmware, and opening the enclosure. Close with one paragraph
answering: does breaking one unit break the fleet, and what is the single cheapest change the
vendor could make.

## 7. Report

One PDF: your name, the date, the sections above in order, and a conclusion. Every finding needs
its command or its file path. Mark inference as inference.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Target research** | 15% | Firmware version and source stated, a component table with datasheet links, and a bus table where each of the four buses has evidence and a concrete attacker capability. |
| **Triage** | 10% | Hash, `file` output and entropy evidence present, with a verdict that follows from the evidence rather than being asserted. |
| **Carving** | 15% | A complete partition map with offsets and types, and an extracted filesystem described accurately, or a documented and proven dead end plus the Path B fallback. |
| **Attack surface** | 20% | A severity-ordered findings table with real paths, a correct local-versus-fleet judgement per row, the boot services listed, and at least one documented negative result. |
| **Binary analysis** | 20% | One binary identified by path and architecture, emulated or disassembled with output shown, input-handling functions named, and one evidence-backed weakness clearly separated from speculation. |
| **Threat model** | 10% | All six defence rows filled from observed evidence, plus a defensible answer on fleet-wide impact and the cheapest fix. |
| **Report quality** | 10% | Reproducible commands, no firmware or personal data attached, inference marked as such, professional tone. |
| **Bonus** | +20% | See below. |

## Bonus

Pick **one**. Both are optional and neither is needed for full marks.

**Option A: hardware (requires a device you own).** On a retired router, camera or dev board that
belongs to you, find ground, VCC, TX and RX on the test header with a multimeter, attach a
3.3 V USB-to-serial adapter, and capture the boot log. Needed: the device, a multimeter and an
adapter, together well under the price of a textbook; the school may already have both. Check the
logic level before you connect, and expect to lose the device.

```bash
picocom -b 115200 /dev/ttyUSB0
```

**In the report:** a photograph of the board with your pin labels drawn on it, the baud rate and
how you determined it, the boot log, and whether the console drops to a shell or a bootloader
prompt. If you also dump the flash with a SPI programmer, read it twice and give both SHA-256
hashes.

**Option B: crack the root hash.** If task 4 produced a password hash, identify its format and
attack it with the Module 15 toolchain on your own machine.

**In the report:** the hash format and hashcat mode, the command, the time to crack or the point
at which you stopped, and the recovered password if you got it. Then one paragraph: what does a
crackable shared root hash mean for every unit of this product, and would a per-device password
have changed anything about the rest of your findings.
