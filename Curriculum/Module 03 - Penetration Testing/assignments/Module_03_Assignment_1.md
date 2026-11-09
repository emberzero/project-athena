# Assignment 1: A Full Engagement Against Your Own Lab

## Objective

You will run one complete penetration test against a lab you build yourself, from written rules of
engagement through to a client-ready report. The point is not the shell. The point is that you can
scope an engagement, triage scanner noise into verified findings, prove impact with the least
possible damage, and hand a defender a document they can act on. After this assignment you should be
able to take an unknown target and produce the same deliverable a junior consultant is paid for.

## Logistics

- **Work:** individual. You may discuss methodology with classmates, but the lab, the findings and
  the report must be your own.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module03_Assignment1.pdf`. Raw scan output goes
  into an appendix of the same PDF, not as separate files.

## Setup

You need two virtual machines on an isolated virtual network. Everything here is free.

- **Hypervisor:** VirtualBox, VMware Workstation Player or UTM. All are free for this use.
- **Attacker VM:** Kali Linux (the prebuilt VirtualBox/VMware image) or a Debian VM with `nmap`,
  `nikto`, `gobuster`, `hydra`, `searchsploit` and `metasploit-framework` installed.
- **Target VM:** one deliberately vulnerable image. Metasploitable 2 is the safe default because it
  is known to work and is well documented. Any beginner-rated VulnHub box that runs a vulnerable
  network or web service is equally acceptable; ask your instructor before choosing something else.
- **Network:** put both VMs on a *host-only* or *internal* network. Confirm before you scan that your
  default route does not point at the lab interface:

  ```bash
  ip addr show
  ip route
  ```

Resource budget: roughly 6 GB of RAM and 40 GB of disk for both VMs together. If your machine cannot
run two VMs, tell your instructor early; the fallback is a shared classroom lab host or an authorized
training platform such as TryHackMe or Hack The Box, where the exploitation and reporting tasks work
unchanged and task 5 is replaced by the alternative given there.

Target images are intentionally insecure. Never bridge one to the school network or to your home LAN.

## Rules of engagement

- **In scope:** only the target VM on your own isolated lab network, running on your own hardware or
  on hardware your instructor assigned to you.
- **Out of scope:** the school network, your home LAN, classmates' machines and labs, and anything on
  the public internet. Vulnerability research against a live third party is not a grey area; see
  Module 01 and StGB §118a, §126a and §126b.
- No denial-of-service testing, even in your own lab, beyond what a tool does incidentally.
- If you use a training platform instead, stay inside the machines that platform assigned to you.

Breaking scope fails the assignment regardless of the quality of the report.

## Tasks

### 1. Rules of engagement and scope (before you scan anything)

Write a one-page RoE for your own lab engagement, treating yourself as the tester and your instructor
as the client contact. It must contain: scope in CIDR notation, the explicit out-of-scope list, the
test window, your source IP address, permitted and forbidden techniques, two stop conditions, and
what you would do if you broke something.

Build a `scope.txt` holding your in-scope addresses and drive every active scan from it with
`nmap -iL`.

Deliverable: the RoE as the first appendix of your report, and the contents of your `scope.txt`.

### 2. Reconnaissance

Discover the host, then enumerate its services. Record every command with the time you ran it, and
keep the output in all formats so you can quote it later:

```bash
sudo nmap -sn -iL scope.txt
sudo nmap -sS -sV -sC -p- -iL scope.txt -oA scans/allports
sudo nmap -sU --top-ports 50 -iL scope.txt -oA scans/udp
```

Deliverable: a service inventory table with one row per open port, giving the port, protocol,
service, reported version and one sentence on why that service is interesting. State explicitly which
services the full TCP scan found that a top-1000 scan would have missed.

### 3. Vulnerability assessment and triage

Run at least two different kinds of check against the target: `nmap --script vuln`, plus a web
scanner (`nikto`, or `gobuster` for content discovery) or a full scanner such as Greenbone if your
instructor provides one. Read what a script does before you run it.

Then do the part the scanner cannot do:

1. Produce a triage table of the raw output: every reported issue, grouped by root cause rather than
   by host row, with a status of *verified*, *false positive* or *not tested*. State how many raw rows
   you started with and how many root causes they collapsed into.
2. Verify at least **three** candidate issues by hand, non-destructively, recording the exact command
   or request and the exact response for each.
3. At least one of your three must turn out not to be exploitable as reported, or you must explain
   why none did. Name the cause: a backported fix, a misleading banner, an unreachable endpoint, a
   compensating control.
4. Score one verified finding with the CVSS v3.1 calculator. Give the vector string, then two
   sentences adjusting the rating for a fictional organization that runs this host, and say why your
   contextual rating is higher or lower than the base score.

Deliverable: the triage table, the three verification records, and the CVSS vector with its
contextual adjustment.

### 4. Exploitation

Exploit one verified finding. Before you fire anything, run `info` and `check` (or read the exploit
source if you are not using Metasploit) and record what each told you. Proof of code execution is
`id` and `hostname`, not a video tour of the filesystem.

Then write one unique artifact to the target so your evidence cannot be anyone else's:

```bash
# on the compromised target, from your shell
echo "pentest by <lastname> $(date -Iseconds)" > /tmp/pentest-<lastname>.txt
id; hostname; ip addr show; cat /tmp/pentest-<lastname>.txt
```

Deliverable: the pre-exploitation `info`/`check` record, a screenshot of the shell showing the
command block above with your own lastname and your own lab IP visible, and one sentence naming the
control that would have prevented the exploit.

### 5. Post-exploitation and impact

Answer three of the four post-exploitation questions on your foothold:

1. Where am I? Capture `id`, `hostname`, `ip addr`, `ss -tulpen` and the OS release.
2. Can I escalate? Check `sudo -l`, SUID binaries and credentials in configuration files or shell
   history. Report what you found even if escalation failed, and say which check would have caught it.
3. What is the actual impact? One paragraph in the client's language: data, money, availability,
   obligations. Not "obtained root on the target VM".

Also produce an artifacts table: every file you wrote, account you created, service you stopped and
setting you changed, with timestamps, including the ones you reverted. Do not clear any logs.

If you are working on a training platform where you do not own the host, skip the local enumeration
dump and instead document what you *could* have reached and why the platform's rules stop you.

Deliverable: the orientation output, the escalation attempt with its result, the impact paragraph,
and the artifacts table.

### 6. The report

Assemble tasks 1 to 5 into a single report with the structure from lecture 5:

- Title page with document control: scope reference, test window, author, classification.
- Executive summary, one page, written last. No tool names, no CVE numbers, no hostnames. Say what
  was good as well as what was bad.
- Scope, methodology and limitations. Name the methodology you worked against (PTES, OWASP WSTG,
  NIST SP 800-115) and say what you could not test and why.
- Findings overview table, then **at least two** detailed findings in severity order. Each detailed
  finding carries the full field list: identifier, title, severity with vector and contextual note,
  affected assets, description, impact, numbered reproduction steps, evidence, remediation with both a
  short-term mitigation and the structural fix, and CWE references.
- Strategic recommendations: two systemic changes, each tied to at least two of your findings.
- Appendices: RoE, `scope.txt`, raw scan output, artifacts table, tool versions.

Reproduction steps are graded by whether a stranger can follow them. Write them so your instructor
could rebuild the lab and repeat the finding from your text alone.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Scope and RoE** | 10% | A one-page RoE with all seven required elements, a `scope.txt`, and evidence that every active scan was driven from it. |
| **Reconnaissance** | 15% | A complete service inventory with correct versions, the full-range scan done, and the services a top-1000 scan would have missed named explicitly. |
| **Triage and verification** | 25% | Raw findings grouped by root cause with before/after counts, three issues verified by hand with exact request and response, at least one correctly explained as not exploitable, and a CVSS vector with a justified contextual adjustment. |
| **Exploitation** | 15% | `info`/`check` recorded before firing, code execution proven with the least damage, the unique artifact visible with your own lastname and lab IP, and the preventing control named. |
| **Post-exploitation and impact** | 15% | Orientation captured, escalation attempted and honestly reported, impact stated in business terms, and a complete artifacts table with timestamps. |
| **Report quality** | 20% | Full structure present, executive summary free of jargon and readable by a non-technical reader, every detailed finding carrying all fields, reproduction steps a stranger can follow, and remediation split into short-term and structural. |

Dishonest evidence, a finding you cannot reproduce but present as verified, or any activity outside
your own lab is marked zero for the affected area and reported as an academic integrity matter.

## Bonus: pivoting and the control that stops it (up to +20%)

Add a second target VM on a separate internal network that your attacker VM cannot reach directly, so
the only route is through the host you compromised in task 4.

1. Build the two-segment lab and show, with a failed scan from your attacker VM, that the second
   network is unreachable at the start.
2. Reach a service on the second target through your foothold, using an SSH dynamic forward with
   `proxychains`, a Metasploit route, or `chisel`. Document the route with a diagram.
3. Establish a reverse shell, then add an egress rule on the compromised host that permits outbound
   traffic to one address only. Show that the reverse shell now fails.
4. Write the two findings this produces as a defender would need them: one on segmentation, one on
   egress filtering, each with the full field list and a remediation that names a specific change.

Full bonus marks require the failed-before and working-after evidence for the pivot, the diagram, and
the egress rule shown to break your own shell. A pivot without the failed baseline proves nothing.
