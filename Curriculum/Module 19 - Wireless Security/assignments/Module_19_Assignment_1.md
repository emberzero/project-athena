# Assignment 1: Wireless Capture Analysis and Network Hardening Audit

## Objective

You will read a real 802.11 capture the way a defender has to read one: identify every access point and client in range, follow a single client through the association sequence frame by frame, recover a hidden SSID, and find the deauthentication attack hidden in the traffic. You will then recover a WPA2 passphrase from a captured four-way handshake offline, and finish by auditing a wireless network you own against the hardening measures from Lecture 6. Afterwards you will be able to say, from evidence rather than from memory, what an attacker in radio range learns before any encryption begins and which configuration changes actually take that away.

## Logistics

- **Work:** individual, or in pairs. A pair submits one report naming both authors, and each partner marks which tasks they led.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module19_Assignment1.pdf`.
- **Length:** no minimum word count. Every claim in the report must be backed by a command, a frame number or a screenshot.

## Rules of engagement

Read these before you touch anything. They are not a formality.

- **In scope:** the capture file your instructor provides, and a wireless network you personally own and administer (your own home router, or your own phone's hotspot).
- **Out of scope:** the school's wireless networks, your neighbours' networks, a classmate's phone or laptop, and every other network you did not set up yourself. This includes passively capturing their traffic.
- No deauthentication frames, no rogue access point and no passphrase cracking against anything but your own network or the provided capture file.

Capturing or cracking somebody else's wireless traffic is a criminal offence in Austria, not a grey area: see Module 01 and StGB **§118a** (unlawful access to a computer system), **§126a** (damage to data) and **§126b** (disruption of a computer system). Your own home network is yours to attack. Nothing else here is. A report that contains evidence from an out-of-scope network scores zero for the whole assignment, regardless of how good the analysis is.

## Setup

**Required (free, no hardware).**

- **Wireshark** on your own machine. Tasks 1 to 4 need nothing else.
- The capture file your instructor provides. It is a monitor-mode capture of a lab network, recorded on hardware the school owns, and it is the only capture you need for tasks 1 to 4.
- **Aircrack-ng** for task 5. It ships with Kali and is packaged for most Linux distributions; on Windows use it inside a Linux VM or WSL.
- A wordlist. `rockyou.txt` ships with Kali at `/usr/share/wordlists/`; otherwise your instructor provides one. Do not download wordlists from random sources.

**Optional (hardware path for task 5).** If your instructor has a USB WiFi adapter that supports monitor mode and packet injection, you may capture your own handshake from your own phone hotspot instead of using the provided handshake capture. **This needs hardware the school may not own.** A normal built-in laptop WiFi card usually cannot do it, and a suitable adapter costs money. The no-hardware path (a second capture file provided by your instructor, containing a handshake for a passphrase that is in the wordlist) is worth full marks. The hardware path is worth the same marks plus a better story in your report.

Nothing in this assignment requires you to buy anything.

## Tasks

### 1. Network inventory from the capture

Open the provided capture in Wireshark and build an inventory of everything that is on the air.

Useful display filters:

```text
wlan.fc.type_subtype == 0x08          beacon frames
wlan.fc.type_subtype == 0x04          probe requests
wlan.fc.type_subtype == 0x05          probe responses
wlan.fc.type_subtype == 0x00          association requests
eapol                                 the four-way handshake
wlan.fc.type_subtype == 0x0c          deauthentication frames
```

**Deliverable.** A table of every access point in the capture, with one row each:

| SSID | BSSID | Channel | Security (from the RSN/WPA information element) | Beacons seen |
| ---- | ----- | ------- | ----------------------------------------------- | ------------ |

State in one sentence per AP how you read the security setting out of the beacon, naming the field you looked at. "Wireshark said WPA2" is not an answer; name the information element.

Add a second table listing the client MAC addresses you can see and, for each, which BSSID it is associated with and how you can tell.

### 2. Follow one association

Pick one client that joins a network inside the capture and walk through its association from Lecture 1.5.5.

**Deliverable.** A table with one row per step (beacon or probe, authentication, association, the four EAPOL messages), giving for each the **frame number** from the capture, the frame subtype, and the direction (client to AP, or AP to client). Then answer, in three to five sentences:

- Which of these frames are sent unencrypted, and which fields in them are readable by anyone in radio range?
- What exactly does an attacker learn from this sequence without knowing the passphrase?

### 3. Recover the hidden SSID

One access point in the capture does not put its SSID in its beacon frames.

**Deliverable.** The BSSID of that AP, the network name, and the **frame number** of the frame that gave the name away, plus which field in it carried the name. Then: two sentences on why hiding an SSID shifts exposure from the AP to the client rather than removing it (Lecture 1.5.5).

### 4. Find the attack in the capture

The capture contains a deauthentication attack.

**Deliverable.**

- The number of deauthentication frames, the claimed sender, the target, and the time window they fall in. Give the filter you used.
- The reason code carried in those frames, and what it claims.
- The evidence that these frames were forged rather than sent by the real AP. State what in the capture supports that, and be honest about what the capture cannot prove.
- Two or three sentences on why 802.11 lets this happen by default, and the name of the mechanism that stops it (Lecture 4.3.3). State whether that mechanism is optional or mandatory under WPA2 and under WPA3.

### 5. Recover a WPA2 passphrase offline

Using the handshake capture (or your own, if you took the hardware path), recover the passphrase.

```bash
aircrack-ng -w /usr/share/wordlists/rockyou.txt -b <BSSID> handshake.cap
```

**Deliverable.**

- The exact command you ran and the full `aircrack-ng` output as a screenshot, with the recovered passphrase visible and the key-found line included.
- The number of candidate keys tested and the keys-per-second rate your machine reached.
- From that rate: how long an exhaustive search of a 12-character passphrase of random lowercase letters would take on your hardware. Show the arithmetic. One sentence on what that tells you about passphrase length versus character-class rules (Lecture 6.6.1).
- Three to four sentences explaining what the handshake actually contains, why the passphrase is not in it, and what `aircrack-ng` computes for each guess (Lecture 5.3.1). Getting this wrong is the single most common misunderstanding in this module.
- One sentence on why WPA3-SAE removes this attack entirely.

If you took the hardware path, also document the adapter, the `airmon-ng` and `airodump-ng` commands, and how you obtained the handshake. Your own hotspot's SSID must appear in the output.

### 6. Harden a network you own

Audit one wireless network you personally administer against Lecture 6. Do this from the router's own admin interface, not by attacking it.

**Deliverable.** A findings table, one row per check:

| # | Check | Current setting | Verdict | What you changed, or why you cannot |
| - | ----- | --------------- | ------- | ----------------------------------- |

Cover at least these eight: security protocol in use and whether a WPA/TKIP or WEP fallback is enabled; passphrase length and how it was chosen; WPS; Protected Management Frames; firmware version and whether a newer one exists; remote administration and the admin password; guest network and client isolation; the list of connected devices.

Then: redact the SSID, the passphrase and any MAC addresses in your screenshots, and write three sentences naming the single change from your table that most reduces the risk of the attack you performed in task 5, with your reasoning.

## Evaluation criteria

| Area | Weight | What earns full marks |
| ---- | ------ | --------------------- |
| **Network inventory** | 20% | Both tables complete and correct for the provided capture, security read from the named information element rather than from Wireshark's summary column, client-to-BSSID mapping justified. |
| **Association walkthrough** | 15% | Every step present with the correct frame number and direction, and a correct account of which frames are in the clear and what they leak. |
| **Hidden SSID** | 10% | Correct BSSID, correct name, correct frame number and field, and the exposure argument stated correctly. |
| **Deauthentication analysis** | 15% | Correct count, sender, target and reason code with the filter shown, a defensible forgery argument that admits its limits, and PMF named with its correct status under WPA2 and WPA3. |
| **Passphrase recovery** | 20% | Correct passphrase with the full output shown, the rate reported, the brute-force arithmetic correct and shown, and a correct explanation of what the handshake contains and what is being computed per guess. |
| **Hardening audit** | 15% | All eight checks with a concrete current setting and a verdict, remediation that is actually actionable, screenshots redacted, and the prioritisation argument tied to task 5. |
| **Report quality** | 5% | Clear structure, every claim backed by a command, frame number or screenshot, readable and professional, PDF named correctly. |
| **Bonus** | +20% | See below. |

A report that uses evidence from a network outside the rules of engagement scores zero overall.

## Bonus: prove a defence works

Worth up to +20%. Pick **one**.

**Option A: beat your own attack.** On a network you own, enable Protected Management Frames (or switch it to WPA3-SAE if the hardware supports both ends). Repeat the deauthentication step from task 4 against your own client with `aireplay-ng`, and show with a capture that the client stays associated. Document both runs, before and after, with the capture evidence side by side, and explain why the frames stop working. This needs the monitor-mode adapter.

**Option B: build a detector.** Write a script (`tshark`, Python with Scapy, or a Kismet configuration) that reads a capture and flags a deauthentication flood: report the offending BSSID, the frame count and the time window, with a threshold you justify. Run it against the provided capture and against a clean capture to show it does not fire on normal traffic. Submit the script source, both runs, and two or three sentences on what a patient attacker would do to slip under your threshold.
