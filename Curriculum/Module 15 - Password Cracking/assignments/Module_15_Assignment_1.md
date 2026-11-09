# Assignment 1: Building, Cracking and Auditing a Password Set

## Objective

You will build your own small hash corpus on a VM you control, crack it with John the Ripper and
hashcat using four different attack strategies, and measure how long each hash survives. You will
then turn those measurements into the only deliverable that matters in a real audit: a statement
about whether a password policy actually defeats the techniques from lecture 3.

## Logistics

- **Work:** individual.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module15_Assignment1.pdf`.

## Setup

Everything here is free and runs on a laptop. No GPU is required; a CPU-only run is slower but
every task is sized to finish on CPU.

- A Linux VM you own: Kali or a Debian/Ubuntu install in VirtualBox, VMware or UTM.
  Snapshot it before you start.
- `john` (the *jumbo* community build, which is what Kali ships), `hashcat`, `hashid`,
  `zip2john`, `mkpasswd` (package `whois` on Debian), `md5sum`, `zip`.
- `rockyou.txt`. On Kali it is at `/usr/share/wordlists/rockyou.txt`, possibly gzipped
  (`sudo gunzip /usr/share/wordlists/rockyou.txt.gz`).
- hashcat's shipped rule files, usually `/usr/share/hashcat/rules/best64.rule`.

Check the installation before you begin:

```bash
john --list=build-info | head -3
hashcat -I 2>/dev/null | head -5    # device list; CPU-only is fine
ls -l /usr/share/wordlists/rockyou.txt
```

## Rules of engagement

- **In scope:** hashes you generated yourself on your own VM, archives you created yourself, and
  any hash file your instructor hands out.
- **Out of scope:** school systems, your classmates' accounts, any online service, any hash dump
  found on the internet, and any password belonging to another person.
- Do not reuse a password you actually use anywhere. Everything you type into this assignment
  becomes part of a PDF your instructor reads.
- Cracking a hash you were not authorised to possess is an offence in Austria (StGB §118a, §126a,
  §126b, and §126c for the tooling). Module 01 covers the detail; lecture 4, section 4.7 covers
  what a lawful audit requires.

## 1. Build your own corpus

Create ten local accounts on your VM, each with a password from the list of categories below. Pick
the actual passwords yourself, and make at least three of them contain your own surname or your
VM's hostname, so your corpus is demonstrably yours.

| ID | Category |
| --- | --- |
| P1 | A word that appears verbatim in `rockyou.txt`, taken from a line number above 100000 |
| P2 | A rockyou word with a capital first letter and a year appended |
| P3 | A rockyou word with `!` appended and one letter replaced by a digit (leetspeak) |
| P4 | Exactly 8 lowercase letters, randomly chosen |
| P5 | Your surname plus four digits |
| P6 | Your VM hostname plus a two-character suffix |
| P7 | A password that satisfies a classic composition rule: one upper, one lower, one digit, one symbol, 8 characters |
| P8 | A four-word passphrase, words separated by spaces |
| P9 | 16 characters from a password manager, fully random |
| P10 | A repeat of P1, on a different account, to show what a salt hides |

Then produce two hash files from the same ten passwords:

```bash
# Slow, salted: the real /etc/shadow format (yescrypt or sha512crypt, depending on your distro)
sudo useradd -m p1 && echo 'p1:<password>' | sudo chpasswd     # repeat for p1..p10
sudo unshadow /etc/passwd /etc/shadow > ~/corpus-shadow.txt

# Fast, unsalted: the same ten passwords as raw MD5
printf '%s' '<password>' | md5sum                              # repeat, collect into corpus-md5.txt
```

**In the report:** the table above, filled in with your ten passwords; the contents of both hash
files; and the output of `hashid` on one hash from each file, with the hashcat mode number it
suggests. Explain in two sentences what P1 and P10 look like in `corpus-shadow.txt` versus in
`corpus-md5.txt`, and why.

## 2. Crack it, four ways

Run at least these four attacks. Note the wall-clock time at which each hash falls; `john` prints
cracks as they happen, and `hashcat --status --status-timer 10` does the same.

```bash
# a) Straight dictionary
john --wordlist=/usr/share/wordlists/rockyou.txt corpus-shadow.txt

# b) Dictionary plus mangling rules
hashcat -m 0 -a 0 corpus-md5.txt /usr/share/wordlists/rockyou.txt -r /usr/share/hashcat/rules/best64.rule

# c) Mask attack, shaped to a category above
hashcat -m 0 -a 3 corpus-md5.txt '?l?l?l?l?l?l?l?l'

# d) Hybrid: wordlist with a mask appended
hashcat -m 0 -a 6 corpus-md5.txt /usr/share/wordlists/rockyou.txt '?d?d?d?d'
```

**In the report:** one results table with a row per password and these columns: ID, which attack
cracked it, time to crack (or "survived"), and the command used. For every hash that survived,
state which attack *would* eventually find it and roughly how long that would take. For the mask
in (c), write down the keyspace arithmetic from lecture 1, section 1.5.

## 3. Measure the cost parameter

Benchmark your own machine and show, with numbers, why the KDF choice matters more than the
policy:

```bash
hashcat -b -m 0        # raw MD5
hashcat -b -m 3200     # bcrypt
```

**In the report:** both hash rates as measured on *your* hardware, and the time your machine would
need to exhaust the 8-character lowercase keyspace (26^8) at each rate. One short paragraph: which
of the ten passwords above would still be safe if the hash were MD5, and which would be safe if it
were bcrypt at a realistic cost factor.

## 4. Extract a hash from a container

Pick a password from a `rockyou.txt` line number of your own choosing above 200000, create a
password-protected ZIP containing a text file with your name in it, and recover the password from
the archive alone:

```bash
sed -n '234567p' /usr/share/wordlists/rockyou.txt    # your chosen line
zip -e myname.zip myname.txt
zip2john myname.zip > zip.hash
john --wordlist=/usr/share/wordlists/rockyou.txt zip.hash
```

**In the report:** the line number you used, the `zip2john` output (one line is enough), the
`john --show` result, and one sentence on why `zip2john` is needed at all rather than pointing a
cracker at the ZIP file.

## 5. Audit a policy

Audit the password policy of a system you control: the `pam_pwquality`/`pam_unix` configuration of
your own VM (`/etc/security/pwquality.conf`, `/etc/pam.d/common-password`, `/etc/login.defs`), or a
service you self-host.

**In the report:**

- A table with one row per rule you found: the rule as configured, whether lecture 4, section 4.2
  classifies it as a "do" or a "do not", and what you would change.
- An audit summary of task 2 written the way section 4.7 requires: statistics, not plaintexts. For
  example "6 of 10 cracked within ten minutes, 3 of them by dictionary alone". State the
  hypothetical retention and destruction step you would have written for a real engagement.
- Two sentences on which single policy change would have broken your own corpus the hardest, and
  why that is not the change most organisations make.

## 6. Report

One PDF: your name, the date, the sections above in order, and a short conclusion. Include the
commands you ran and screenshots or pasted output as evidence. Professional tone, no padding.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Corpus construction** | 15% | Ten passwords matching all ten categories, at least three tied to your own surname or hostname, both hash files present, and a correct explanation of what the salt does to P1 versus P10. |
| **Cracking results** | 25% | All four attack types run, a complete per-password results table with time to crack and the exact command, and a defensible prediction for every password that survived. |
| **Cost measurement** | 15% | Both benchmark rates from your own hardware, correct 26^8 arithmetic for each, and a conclusion that distinguishes the KDF's effect from the password's. |
| **Container hash** | 15% | Line number stated, `zip2john` output and recovered password shown, and a correct explanation of why the extraction step exists. |
| **Policy audit** | 20% | Real configuration values quoted from your own system, each mapped to the lecture 4 do/do-not list with a concrete fix, plus a statistics-only audit summary including retention and destruction. |
| **Report quality** | 10% | Clear structure, reproducible commands, evidence for every claim, no plaintext password of a real account anywhere. |
| **Bonus** | +20% | See below. |

## Bonus: beat best64 on your own corpus

Write your own hashcat rule file and show, with measurements, that it finds more of *your* corpus
than `best64.rule` does for the same number of candidates.

1. Inspect what the shipped rules generate before you hash anything:
   `hashcat -a 0 --stdout wordlist.txt -r /usr/share/hashcat/rules/best64.rule | head -30`.
2. Write a rule file of at most 20 rules, targeting the password shapes you actually chose in
   task 1. Explain each rule in one line.
3. Run both rule sets against `corpus-md5.txt` with the same wordlist and compare: hashes cracked,
   candidates generated (`--status` reports progress), and time.

**In the report:** a section titled "Bonus: custom rule set", your rule file with per-rule
explanations, the comparison table, and one honest paragraph on why a rule set tuned to a corpus
you designed yourself is not evidence that it generalises.
