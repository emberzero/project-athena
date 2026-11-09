# Assignment 1: From Lab to Session to Detection

## Objective

You will build an isolated virtual lab, use Metasploit end to end against a deliberately vulnerable
target you own, and then turn the engagement around and explain how a defender would have caught
you. Afterwards you will be able to drive the search-use-set-run-session workflow with the database
behind it, choose a payload that fits the target, work a Meterpreter session through basic
post-exploitation, and tie every step you took to the control that detects or prevents it.

## Logistics

- **Work:** individual.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module10_Assignment1.pdf`.
- Also submit your resource script as a separate `.rc` text file.

## Setup

Everything here is free and runs on one laptop. Budget roughly 8 GB of RAM and 40 GB of disk for two
VMs at once; if your machine cannot manage both, ask your instructor about lab access rather than
cutting the isolation.

- A hypervisor: VirtualBox, VMware Workstation Player, UTM or KVM. All have a free option.
- **Attacker VM:** Kali Linux. Metasploit is preinstalled. Update with
  `sudo apt update && sudo apt full-upgrade`.
- **Target VM:** a deliberately vulnerable machine. Any of these is acceptable:
  - Metasploitable 2, the simplest starting point, from the Rapid7 Metasploitable project.
  - Any VulnHub image rated beginner that exposes a vulnerable network service.
  - A VM you build yourself running a known-vulnerable version of a service on purpose.

  Ask your instructor which target the class is using before you download anything; they may
  provide an image.
- Both VMs on a **host-only or internal network** with no route to the internet or to the school
  LAN. Verify the isolation before you attack anything: from the target VM, a ping to a public
  address must fail.
- **Name your VMs after yourself.** Set the attacker hostname to `<lastname>-kali` and, where the
  target image allows it, the target hostname to `<lastname>-target`. Several deliverables below are
  screenshots that must show those hostnames, which is how your work is distinguished from everyone
  else's.
- No hardware beyond your own computer, and nothing to buy.

## Rules of engagement

- **In scope:** only the two VMs on your own isolated virtual network.
- **Out of scope:** everything else. Your host machine, the school network, the hypervisor's NAT
  network, other students' VMs, anything on the internet. No exceptions, and no "just a quick scan"
  of something outside the lab.
- A deliberately vulnerable VM must never be reachable from a real network. If you bridge it, you
  have built somebody else's foothold.
- Running any module in this assignment against a system you do not own or have written
  authorisation to test is a criminal offence; in Austria StGB §118a, §126a and §126b are the
  relevant provisions. Module 01 covers the legal frame. "I was learning" is not a defence.

## Task 1: Build and document the lab

1. Create both VMs on an isolated network. Record the hypervisor, the network mode, the subnet, and
   each VM's address.
2. Demonstrate the isolation: from the target, show that a ping to a public address fails; from
   Kali, show that you can reach the target.
3. Initialise the Metasploit database with `sudo msfdb init`, start it, and confirm with `db_status`
   inside the console.
4. Create a workspace named after yourself with `workspace -a <lastname>_lab`.

**Deliverable:** a short network diagram or table of the lab, plus a screenshot of `msfconsole`
showing `db_status` connected and your workspace selected.

## Task 2: Reconnaissance into the database

1. Write a resource script, `<lastname>_recon.rc`, that selects your workspace and runs a service
   scan of your target with `db_nmap -sV`.
2. Run it with `msfconsole -r <lastname>_recon.rc`.
3. Query the results with `hosts` and `services`.
4. Run at least one auxiliary scanner module against a service you found, and say what it told you
   that the version scan did not.

**Deliverable:** the resource script listing, the `hosts` and `services` output, and a table of the
services you found with port, protocol, service and version. Add one column stating, for each
service, whether you consider it a candidate entry point and why.

## Task 3: Choose an exploit, with reasoning

1. Pick one service from your table and use `search` with filters to find candidate modules. Show
   the search you used, not just the result.
2. Read `info` on at least two candidates and compare them on module rank, disclosure date,
   available targets and what the module actually does.
3. Say which one you chose and why. If a module supports `check`, run it and include the output.
4. State the underlying vulnerability. If the module references a CVE, cite the entry from the
   [NVD](https://nvd.nist.gov/) and summarise it in two sentences in your own words. If it does not
   reference a CVE, say so rather than inventing one.

**Deliverable:** the comparison of the two candidate modules, your choice with its justification,
and the vulnerability description with its reference.

## Task 4: Exploit and obtain a session

1. Set the module options. Show `show options` after setting them, not before.
2. Choose a payload deliberately. State whether it is single or staged, bind or reverse, and why
   that choice fits this target and this network. One sentence on what would have gone wrong with
   the other choice.
3. Run the exploit. If it fails, work the checklist from Lecture 3 and document what you changed
   between attempts. **A documented failure that you diagnosed correctly scores better than an
   undocumented success.**
4. In the session, record `sysinfo`, `getuid` and the network configuration.
5. Create proof that the session is yours: write a file on the target at a path of your choosing
   containing your full name and the output of `date -u`, then read it back inside the session and
   compute its SHA-256.

**Deliverable:** the exploit transcript showing the handler starting and the session opening, the
session information commands, and the proof file with its SHA-256. The screenshot must show your
hostnames from Task 1.

## Task 5: Post-exploitation

Stay inside your own lab. Work through the first phases from Lecture 5 in order.

1. **Situational awareness.** Report who you are, what the host is, which interfaces and routes it
   has, and what is running. Say explicitly whether the routing table reveals any network you could
   not otherwise reach.
2. **Escalation candidates.** Run `post/multi/recon/local_exploit_suggester` against your session
   and report what it proposes. You are not required to succeed at escalating. You are required to
   explain why its output is a list of candidates and not a list of facts.
3. **Two post modules.** Run at least two `post/` modules appropriate to your target's platform and
   report what each returned.
4. **Collection.** Download one file from the target that a client would care about, and record its
   path, size and SHA-256. Show the corresponding `loot`, `creds` or `notes` entry in the database.
5. **Cleanup.** Remove the proof file and anything else you uploaded, close the session, and show
   that it is gone.

**Deliverable:** a numbered account of the five steps with the command and the result for each, the
hashes of the files you handled, and a cleanup confirmation.

## Task 6: Turn it around

This section is the point of the assignment. Write it from the defender's chair.

1. Build an **attack path table**: one row per step you took, from scan to cleanup, with the
   artefact or signal a defender could have observed, and the control that would have detected or
   prevented it. Use the detection notes from Lectures 4 and 5 as your starting point, not your
   ceiling.
2. Name the **three** controls that would have given the best return against your specific attack
   path, in order, and justify the order.
3. Explain in a short paragraph why your payload choice in Task 4 would or would not have survived
   egress filtering, and what the attacker would have had to do instead.

**Deliverable:** the attack path table, the ranked three controls with justification, and the egress
paragraph.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Lab build and isolation** | 10% | Both VMs documented with addresses and network mode, isolation demonstrated by a failed outbound ping from the target, database connected and a workspace named after the student. |
| **Reconnaissance** | 15% | A working resource script, `hosts` and `services` populated from `db_nmap`, a complete service table with versions, and a justified entry-point judgement per service. |
| **Module choice and reasoning** | 15% | The search shown, two candidates compared on rank, date and targets, a clear justification for the choice, and an accurate vulnerability description with a real reference or an honest statement that none exists. |
| **Exploitation** | 20% | A session obtained, or a failure diagnosed step by step against the checklist; the payload choice argued as single-or-staged and bind-or-reverse; and the proof file with its hash visible in a screenshot showing the student's own hostnames. |
| **Post-exploitation** | 15% | All five steps carried out with commands and results, the exploit suggester's output correctly characterised as candidates, two post modules run, a collected file hashed and present in the database, and cleanup shown. |
| **Defensive analysis** | 20% | An attack path table covering every step with a plausible observable and a matching control, three controls ranked with real justification, and an egress paragraph that reasons about the student's own payload rather than repeating the lecture. |
| **Report quality** | 5% | Clear structure, readable prose, commands and output legible, screenshots annotated, and the sections in the order the tasks ask for. |
| **Bonus** | +20% | See below. |

## Bonus: pivot or deliver

Worth up to +20%. Pick **one**, and label the section clearly as a bonus.

**Option A: pivot.** Add a third VM on a second isolated network that only the target VM can reach,
so your Kali machine has no route to it. From your session, run
`post/multi/manage/autoroute`, then scan and identify a service on the third VM through the pivot.
Show that the scan reaches a host your attacker VM cannot reach directly, and explain why a
perimeter firewall is irrelevant here and what segmentation rule would have stopped you.

**Option B: deliver your own payload.** Generate a standalone payload with `msfvenom`, catch it with
`exploit/multi/handler`, and get a session that way instead of through a service exploit. Transfer
the file into the target through a mechanism you document. Then explain what makes this path easier
and harder than Task 4's, and which of the two a file-scanning antivirus and which a
behaviour-monitoring EDR would be more likely to catch, with reasons drawn from how staged payloads
are delivered.

For either option, full marks require working evidence plus the defensive reasoning. Evidence
without the analysis is half the task.
