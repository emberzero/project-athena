# Assignment 2: Linux Privilege Escalation

## Objective

You land on a Linux box as an unprivileged user and work your way up to the admin account. Each
challenge is a small, self-contained machine with one misconfiguration: a dangerous `sudo` rule, a
`SUID` binary, a credential left lying around, a writable `PATH`, or a Linux capability. You will
enumerate the system, find the one way up, and read the flag in `/home/admin/flag.txt`. This is the
practical half of the privilege escalation lecture.

## Logistics

- **Work:** individual.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF named `Lastname_Firstname_Module11_Assignment2.pdf`.
- Every flag and every screenshot must come from *your own* portal instances. The flags are tied to
  your instance, so they cannot be shared between students.

## Setup

- Each challenge is a separate machine in the **Athena portal** under the **privesc** category. Start
  the one you are working on; the portal shows its IP address and the login once it is ready.
- Log in over SSH as the unprivileged user:

  ```bash
  ssh user@<ip>   # password: pentestlab
  ```

- Your goal on every machine is the same: become `admin` (or root) and read `/home/admin/flag.txt`.
- Instances are torn down after their lifetime runs out. Grab the flag and your evidence before that,
  and restart the instance if it expires.

### Scope and legality

Work only on the portal instance you started for the challenge you are solving. Do not point any
command, scan or exploit at another host, at a classmate's instance, at the portal itself or at any
machine on the school network or the internet. Module 01 covers why this line matters. Everything you
need is on the box in front of you.

### Tooling

You may use the enumeration helpers from the lecture: `linpeas`, `pspy`, and `GTFOBins`
(<https://gtfobins.github.io>). For a SUID binary or a `sudo` rule, GTFOBins tells you the exact
escape, but you must still explain *why* it works. A pasted one-liner with no explanation earns no
marks.

## Required Challenges

Solve all five. For each one, give in your report:

1. The enumeration command that revealed the misconfiguration, and its relevant output.
2. The privilege escalation vector in one or two sentences: what is wrong and why it lets you become admin.
3. The exact commands you ran to escalate.
4. The flag, with the `id` output next to it showing you are now admin.

### R1. Sudo I (`sudo_i`)

`user` may run one standard tool as `admin`. Find out which, and turn it into a read of the flag.

### R2. SUID I (`suid_i`)

One standard tool on this box runs with more privileges than it should. Find it and use it to read
the flag.

### R3. Credentials I (`credential_i`)

The admin was in a hurry the last time they worked on this box. Something they typed is still around.
Find it, become admin, read the flag.

### R4. PATH Injection (`suid_ii`)

A custom health check runs as root and calls standard programs by name, not by full path. Work out how
it finds those programs, and make it run yours instead.

### R5. Capabilities I (`cap_i`)

A binary on this box was granted a Linux capability it does not need. Find which binary and which
capability (the lecture shows the command), and use it to reach admin.

## Bonus Challenges

Each one is harder or a variant of a required technique. Document them the same way as the required
challenges.

### B1. Sudo II (`sudo_ii`)

`user` may edit one file as `admin`. Work out which `sudo` rule this is and why it hands you more than
a single file.

### B2. Credentials II (`credential_ii`)

The admin's home directory is a little too open. Find what should not be readable and use it to log in
as admin.

### B3. Credentials III (`credential_iii`)

Something on this box checks every minute that SSH still works. Watch the processes (`pspy` helps) and
see what that check reveals.

## Report

Structure: a short introduction, one section per challenge (required first, then any bonus), and a
conclusion. For every challenge, show the enumeration, the vector, the commands and the flag with
`id`, as listed above. In the conclusion, name for each of the five required challenges one
configuration change that would have closed the hole.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **R1 Sudo I** | 15% | Correct tool identified, flag read, GTFOBins escape explained. |
| **R2 SUID I** | 15% | SUID binary found with the right `find` command, flag read, escape explained. |
| **R3 Credentials I** | 15% | The leftover credential found and shown, admin reached, flag read. |
| **R4 PATH Injection** | 20% | `PATH` manipulation explained correctly, malicious program planted, flag read. |
| **R5 Capabilities I** | 15% | Capability found with `getcap`, named correctly, used to reach admin. |
| **Report quality** | 10% | Clear structure, every claim backed by output from the student's own instance. |
| **Remediation** | 10% | A correct, specific fix for each of the five required challenges. |
| **Bonus** | +30% | Up to +10% per bonus challenge, fully documented with evidence. |
