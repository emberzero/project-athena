# Assignment 1: Persistence, Beaconing and the Limits of Detection

## Objective

You will build a disposable virtual machine and give yourself, using three of the persistence mechanisms from Lecture 1, a harmless program that survives a reboot. Then you will switch sides and find all three again from a defender's position, using a baseline you took before you started. Finally you will run a benign beacon against a listener on your own host, measure its timing in a packet capture, and argue from the ring model why a kernel rootkit would have defeated every detection you just performed. Afterwards you will understand persistence and C2 beaconing as things you have built and measured, not as bullet points.

## Logistics

- **Work:** individual, or in pairs. A pair submits one report naming both authors; each partner builds their own VM, and the report shows both sets of output.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module20_Assignment1.pdf`.

## Rules of engagement

- Everything in this assignment runs **inside a virtual machine you built yourself**, on a host-only or internal network. Nothing leaves that VM.
- **You will not download, run or handle real malware.** Not a sample from a feed, not a RAT builder, not a cracked Cobalt Strike, nothing from a Discord server. Every program you run in this assignment is one you wrote yourself, and the whole point of the exercise is that it is harmless.
- **No command and control server.** Your beacon talks to a listener on your own host over the host-only network and nowhere else. Do not register a domain, do not use a webhook, do not touch a CDN or a public service.
- No persistence mechanism on your host machine, on a school machine, or on anybody else's device. Only inside your VM.

Installing persistence or remote-access software on a system that is not yours is a criminal offence in Austria: see Module 01 and StGB **§118a** (unlawful access to a computer system), **§126a** (damage to data) and **§126b** (disruption of a computer system). The techniques in Lecture 1 are illegal to deploy outside your own lab. The lab is the assignment.

## Setup

Free. No special hardware beyond a computer that can run one virtual machine, which means roughly 8 GB of RAM and 40 GB of free disk.

- **A hypervisor.** VirtualBox (free, all platforms) or VMware Workstation Player / Fusion (free for personal use). On Apple Silicon, UTM is free.
- **A guest operating system.** Either:
  - **Windows:** Microsoft publishes a time-limited evaluation Windows image for free. Any recent Windows release works; it will expire, which does not matter here.
  - **Linux:** any desktop distribution, free. Pick this if your hardware struggles with Windows or you are on Apple Silicon.
- **Networking:** configure the VM's adapter as **host-only** (VirtualBox) or **Private Network** (UTM) so the VM can reach your host and nothing else.
- **A snapshot.** Take one labelled `clean` before task 2 and restore it at the end. This is not optional; it is how you get your machine back.
- **Wireshark or tcpdump**, on the host, for task 5. Free.

Everything else you need is already on the guest: `reg`, `schtasks`, PowerShell on Windows; `cron`, `systemd`, a shell on Linux.

## Tasks

Pick **one** track, Windows or Linux, and stay in it. The tasks are identical in substance.

### 1. Build the lab and take a baseline

Create the VM, set its network to host-only, and give it a hostname that includes your surname (for example `smith-lab`). Create your own user account on it.

Before you install anything, record a baseline of the places persistence lives:

```powershell
# Windows, run in the VM
reg query HKCU\Software\Microsoft\Windows\CurrentVersion\Run         > C:\baseline-run.txt
schtasks /query /fo LIST /v                                          > C:\baseline-tasks.txt
dir "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"     > C:\baseline-startup.txt
```

```bash
# Linux, run in the VM
crontab -l > ~/baseline-cron.txt 2>&1
systemctl --user list-timers --all > ~/baseline-timers.txt
systemctl --user list-unit-files > ~/baseline-units.txt
cp ~/.profile ~/baseline-profile.txt
```

**Deliverable.** A screenshot of `systeminfo` (Windows) or `uname -a && hostnamectl` (Linux) showing **your** hostname and username, the hypervisor and guest version, confirmation that the adapter is host-only, and a screenshot of the `clean` snapshot in the hypervisor. Then take the baseline and keep the files.

### 2. Write the payload

Write one short script, in any language already on the guest, that does exactly this and nothing else: append one line to a log file containing the current timestamp, the hostname and the username. It must exit immediately. It must not touch the network, must not delete anything and must not hide itself.

**Deliverable.** The full source in your report, and the first three lines of the log file it produced, showing your hostname.

### 3. Install three persistence mechanisms

Give your payload three independent ways to run after a reboot, from Lecture 1 ("Techniques"):

- **Windows:** the `HKCU` Run key, the Startup folder, and a scheduled task created with `schtasks`.
- **Linux:** a shell startup file, a user `cron` entry, and a user `systemd` timer.

Reboot the VM, then confirm the payload ran.

**Deliverable.** A table with one row per mechanism:

| Mechanism | Exact command or file used to install it | Privilege needed | Evidence it ran after reboot | How noisy it is, and why |
| --------- | ---------------------------------------- | ---------------- | ---------------------------- | ------------------------ |

The evidence column points at a specific log line with its timestamp, not at "it worked". Include the log file after the reboot, showing three new lines.

### 4. Find them again as a defender

Now take the defender's view. Re-run the same queries from task 1 and diff them against your baseline.

```bash
# Linux, in the VM
diff ~/baseline-cron.txt <(crontab -l)
```

On Windows use `Compare-Object` in PowerShell, or `fc` at the command prompt.

**Deliverable.**

- The diff output for all three mechanisms, showing each one appearing.
- For each mechanism, one sentence on what a defender without a baseline would have had to do instead.
- Name one tool, other than these built-in commands, that enumerates persistence on your platform, and say in two sentences what it shows that your commands do not. Cite where you found it.
- Two or three sentences: which of the three mechanisms would you expect to survive longest on a monitored corporate machine, and why? Refer to Lecture 1.

### 5. Beacon, and measure it

Start a listener on your **host** on the host-only interface. `python3 -m http.server 8000` is enough. On the guest, write a second script that sends an HTTP GET to that listener in a loop, with a fixed sleep interval of your own choosing between 20 and 60 seconds, plus random jitter of up to 20% of that interval.

Run it for at least 10 minutes while capturing on the host-only interface with Wireshark or tcpdump.

**Deliverable.**

- Your chosen interval and jitter, the script source, and the capture filter you used.
- A table of the request timestamps and the delta between consecutive requests, from the capture and not from your script's own output.
- The mean and the standard deviation of those deltas, and a one-sentence statement of the signature a defender would look for.
- Three to five sentences: your beacon is trivially detectable. Explain, from Lecture 1 ("Infrastructure"), how a real RAT makes this harder, naming at least two of jitter, domain fronting, fast flux and DNS tunnelling, and say for each which part of your detection it defeats.
- One sentence on why a C2 operator may not care about eventual detection.

### 6. Where detection runs out

One to one and a half pages, no filler.

Using the ring diagram from Lecture 2, go through your own work and state which of your detections in tasks 4 and 5 a **ring 0** rootkit on that VM could defeat, and how. Be specific: name the detection, name what the rootkit tampers with.

Then answer:

- Which observation points survive a ring 0 rootkit, and why? Your host-only capture is one of them; say exactly why it is different from a capture taken inside the guest.
- Name the rootkit variant from Lecture 2 that defeats even that, and say what it implies for the defender.
- Two or three sentences on why rootkits are rare compared to infostealers, in terms of attacker cost and payoff (Lecture 1, "Infostealers").

### 7. Clean up

Restore the `clean` snapshot. Confirm in your report that you did, with a screenshot, and verify that all three persistence mechanisms are gone by re-running one query per mechanism.

## Evaluation criteria

| Area | Weight | What earns full marks |
| ---- | ------ | --------------------- |
| **Lab and baseline** | 10% | VM built with the student's own hostname and user, host-only networking confirmed, `clean` snapshot shown, and a complete baseline taken before anything was installed. |
| **Payload** | 5% | Source included, harmless as specified, and log output showing the student's own hostname. |
| **Persistence** | 20% | All three mechanisms installed and demonstrably surviving a reboot, with the exact install command, the privilege required, and a timestamped log line as evidence for each. |
| **Detection** | 20% | A real diff against the student's own baseline showing all three, a correct account of what a baseline-less defender faces, a named third-party tool with a citation, and a defensible argument about which mechanism survives monitoring. |
| **Beaconing** | 25% | Timing measured from the packet capture rather than the script, deltas tabulated with mean and standard deviation, the detection signature stated correctly, and at least two evasion techniques each mapped to the specific part of the detection it defeats. |
| **Detection limits** | 15% | Each of the student's own detections correctly assessed against a ring 0 rootkit with the tampering named, the host capture's privilege boundary explained correctly, and the variant that defeats it named. |
| **Report and cleanup** | 5% | Clear structure, every claim backed by output or a screenshot, snapshot restored and verified, PDF named correctly. |

Running real malware, or installing any of this outside your own VM, scores zero for the whole assignment.

## Bonus: DLL search order, or automate the hunt

Worth up to +20%. Pick **one**.

**Option A: search-order hijack (Windows only).** Using the documented Windows DLL search order from Lecture 1, place a DLL you wrote yourself next to a program in a directory you control, so that your DLL loads instead of the intended one. Your DLL must do nothing but append a line to the log file and then hand off correctly, so the program still works. Document the search order step you abused, the before and after, and why this is harder to spot than a Run key. Then explain in two or three sentences which of your task 4 checks would have missed it entirely.

**Option B: a persistence hunter.** Write a script that collects the persistence locations on your platform, compares them against a stored baseline, and reports additions with enough context for a human to triage them. Run it against the clean snapshot to show no false positives, then against the compromised state to show all three mechanisms found. Submit the source, both runs, and two or three sentences on a persistence location your script does not cover and how an attacker would use that gap.
