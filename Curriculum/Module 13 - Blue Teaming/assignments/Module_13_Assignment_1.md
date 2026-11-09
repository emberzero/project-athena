# Assignment 1: Defending and Monitoring a Host You Own

## Objective

You will turn a bare Linux VM into a defended host: write a firewall policy and prove it works, put an
IDS behind it and detect your own attack with a signature you wrote yourself, then handle the result as
an incident. Afterwards you will be able to explain a rule set you built, read an alert back to the
packet that caused it, and describe what a SIEM would have to collect to see the same event.

## Logistics

- **Work:** individual, or in pairs. Pairs submit one report and name who did which task.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module13_Assignment1.pdf`.
- Every screenshot or pasted output must show your own hostname or VM IP. Output that cannot be tied
  to your own machine earns no marks.

## Setup

Everything here is free and runs on a normal school or home laptop.

- A hypervisor: VirtualBox, VMware Workstation Player, UTM or KVM. All free for this use.
- One Linux VM, Debian or Ubuntu Server, 1 vCPU and 1 GB RAM is enough. This is your **target**.
- A second machine to attack from: your host OS, or a small Kali VM. Both VMs on a **host-only** or
  **internal** network, so nothing you do leaves your laptop.
- On the target: `nftables` or `ufw` (both in the base repositories), an IDS, and `rsyslog`.
- For the IDS, use Snort, which the IDPS lecture names. Its community rule set is free to download.
  If your instructor prefers OSSEC or Security Onion, use that instead and say so in the report.
- If virtualization is unavailable to you, ask your instructor for the packet capture and log bundle
  for the no-VM path. Tasks 1 to 3 then become analysis of that capture instead of your own host.

Set `MARKER` to your own string before you start, for example `mschnideritsch-m13`. You will use it as a
unique token in traffic and in your IDS rule, and it is what makes your evidence yours.

## Rules of engagement

- **In scope:** your own VMs, on an isolated virtual network, and nothing else.
- **Out of scope:** the school network, school servers, your classmates' machines, your home router,
  and anything on the public internet. Do not bridge the VM network to a real LAN for these tasks.
- Scanning or probing a host you do not own is an offence under StGB **§118a**, and interfering with a
  system or its data falls under **§126a** and **§126b**. Module 01 covers what this means for you.
- Downloading rule sets and reading documentation over the internet is of course fine.

## 1. Firewall policy

1. Install a service the firewall has something to protect: SSH plus one web server (`nginx` or
   `python3 -m http.server`) is enough.
1. Write a **default-deny** policy by hand, in a file, not with interactive one-liners. It must:
   - drop everything inbound that no rule permits;
   - permit SSH only from your attacker machine's address, not from the whole subnet;
   - permit HTTP from the whole isolated subnet;
   - permit established and related return traffic;
   - log dropped packets to the system log with a prefix containing your `MARKER`.
1. In the report, include the complete rule file **with a comment on every rule** saying what it is for.
   A rule you cannot explain counts as a finding against you.
1. Build a test matrix and run it. One row per test, with the command you ran and the result:

   | Test | From | To | Expected | Observed |
   | --- | --- | --- | --- | --- |
   | SSH from attacker | attacker | target:22 | allowed | |
   | SSH from a third address | other | target:22 | dropped | |
   | HTTP from attacker | attacker | target:80 | allowed | |
   | Outbound DNS from target | target | resolver:53 | allowed | |
   | Anything to a closed port | attacker | target:8080 | dropped and logged | |

   Add at least two rows of your own. For the dropped tests, paste the matching log line showing your
   `MARKER`.
1. State in two or three sentences which of the firewall types from the lecture your rule set is, at
   which OSI layer it decides, and name one concrete attack against your web server that it cannot see
   at that layer.

**Deliverable:** the commented rule file, the completed test matrix, log lines with your marker, and the
classification paragraph.

## 2. Detection

1. Put the IDS on the target host and confirm it is running and reading the right interface.
1. Write **your own signature**, not a downloaded one. It must alert on an HTTP request whose URI or
   body contains your `MARKER`. Keep it minimal and give it a unique SID above 1000000, for example:

   ```text
   alert tcp any any -> $HOME_NET 80 (msg:"M13 marker seen"; content:"MARKER-HERE"; sid:1000001; rev:1;)
   ```

1. Trigger it from the attacker machine, for example with
   `curl "http://<target>/?q=$MARKER"`, and paste the resulting alert in full.
1. Now generate two kinds of traffic the IDS should **not** alert on: a normal page request and one
   other benign request of your choice. Show that no alert fires. If one does, say why and fix either
   the rule or your explanation.
1. Run a port scan of your own target from the attacker machine and record what the IDS reported and
   what the firewall log reported for the same scan. Compare the two: which one told you more, and what
   did each one miss?
1. Your IDS is passive. Describe in one short paragraph what would change if you deployed it inline as
   an IPS instead, and name one concrete risk your own rule would create in that position.

**Deliverable:** the rule you wrote, the alert it produced, evidence of the two non-alerts, the
scan comparison, and the IDS-versus-IPS paragraph.

## 3. Incident response

Treat the port scan and the marker request from Task 2 as a real incident on a production host.

1. Build a timeline table from your own evidence. One row per event, with the timestamp from the log or
   alert, the source of that evidence, and what it shows:

   | Time | Evidence source | What it shows |
   | --- | --- | --- |

1. Walk the incident through the six phases from the Incident Response lecture: detection, analysis,
   containment, eradication, recovery and post-incident activity. For each phase write what you would
   actually do **on this host**, with the command where there is one. "Isolate the system" earns nothing;
   "remove the VM from the internal network with `nft` rule X / detach the adapter, keeping the host
   running so the memory image survives" earns full marks.
1. Decide and justify one trade-off: you can either pull the host off the network at once or leave it up
   to collect more evidence. Say which you choose here and what you would lose either way.
1. Name two things your own setup made hard, and one change to the firewall or the rule set that would
   make the next incident easier to investigate.

**Deliverable:** the timeline table, the six-phase plan with concrete actions, the trade-off decision,
and the two lessons learned.

## 4. Feeding a SIEM

You will not deploy a SIEM. You will specify one.

1. List the log sources your setup already has and what each would contribute. One row each, at minimum
   the firewall log, the IDS alerts, the SSH authentication log and the web server access log:

   | Source | Format and transport | What an analyst gets from it | What it cannot show |
   | --- | --- | --- | --- |

1. Take three real log lines from three different sources on your host and normalise them into one
   common schema, as the SIEM lecture describes: timestamp, host, user, source address, action, result.
   Show the raw line and the normalised row side by side.
1. Write two correlation rules in plain pseudo-code, each using **at least two** of your sources, each
   describing something that actually happened on your VM or plausibly could. For each rule state the
   condition, the time window, the severity and why you chose that window.
1. For one of your rules, give one realistic false positive and say how you would tune it away without
   losing the detection.

**Deliverable:** the source table, the three normalised lines, the two correlation rules, and the false
positive discussion.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Firewall policy** | 25% | Default-deny rule set, every rule commented and correct, full test matrix run with drop log lines carrying your marker, and a correct classification by type and layer. |
| **Detection** | 25% | Your own working signature, the alert it produced, demonstrated non-alerts on benign traffic, a scan comparison that says what each sensor missed, and a sound IDS-versus-IPS argument. |
| **Incident response** | 20% | Timeline built from your own timestamps, all six phases with host-specific actions and commands, and a justified containment trade-off. |
| **SIEM specification** | 20% | Complete source table including blind spots, three correctly normalised lines, two multi-source rules with justified windows, and a credible false positive with its tuning. |
| **Report quality** | 10% | Structured, readable, every claim backed by evidence from your own host, commands reproducible by the reader. |
| **Bonus** | +20% | See below. |

Work that is not traceable to your own VM, and rule sets or timelines shared between students, are
graded as not submitted.

## Bonus: tune a noisy rule, or defeat your own signature

Pick **one**.

- **Tuning.** Load the IDS community rule set, run ten minutes of ordinary traffic on your VM, and
  collect the alerts. Pick the noisiest rule, explain what it matches, decide whether it is a true
  positive, and either suppress or rewrite it. Show the alert counts before and after and defend the
  decision. Include the before-and-after rule or suppression line.
- **Evasion.** Send the same marker request in a way your own signature does not catch, for example
  split across TCP segments or encoded, and show the IDS staying silent while the request still reaches
  the web server. Then write a second signature that catches both forms, and explain what the first one
  assumed about the traffic that was not true.
