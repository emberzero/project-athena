# Assignment 1: Building Your Own Security Toolkit in Python

## Objective

You build four small security tools in Python, from the standard library up: a TCP connect scanner,
a banner grabber, an offline hash cracker, and an HTTP inspection tool. Each one turns a technique
from the lectures into code you can run, read and defend. The point is not to reimplement nmap or
hashcat. The point is to understand every line, because a tool whose output you cannot explain is
worthless in a report. This is the practical half of the module.

## Logistics

- **Work:** individual.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF named `Lastname_Firstname_Module05_Assignment1.pdf`, plus your four
  script files (`scan.py`, `banner.py`, `crack.py`, `httptool.py`).
- Use `uv` for everything: `uv venv`, `uv pip install ...`, `uv run script.py`. Commit a
  `requirements.txt` so your results can be reproduced.
- Every screenshot and every result must come from *your own* machine or VMs. Output tied to another
  host cannot be submitted.

## Setup

- A Linux lab VM, or your own machine, with a current Python 3 and `uv` installed.
- A second target to scan: a lab VM on a host-only network (for example Metasploitable or an OWASP
  Juice Shop container), or services you start on `127.0.0.1`. A quick HTTP target:

  ```bash
  python3 -m http.server 8000     # serves the current directory on :8000
  ```

- A small wordlist you control. Do not download a breach dump; make your own for this assignment:

  ```bash
  printf '%s\n' dolphin summer2024 hunter2 letmein \
    correcthorse >> wordlist.txt
  ```

### Scope and legality

Run every tool only against `127.0.0.1`, against a VM you own on a host-only network, or against a
target you installed yourself. Do not point any script at the school network, at a classmate's
machine, at a cloud host, or at any address on the public internet. In Austria, scanning or
accessing a system you are not authorized to touch falls under StGB §118a and related provisions;
Module 01 covers why this line matters. Everything you need runs on your own lab.

### Tooling

Prefer the standard library: `socket`, `ssl`, `ipaddress`, `hashlib`, `hmac`, `argparse`,
`logging`, `concurrent.futures`, `json`. The only third-party package you need is `requests` for
Task 4. Keep each script runnable with `uv run`.

## Required Tasks

Solve all four. For each, submit the script and, in your report, the command you ran, a screenshot
of the output, and the short written answers the task asks for.

### T1. TCP connect scanner (`scan.py`)

Write a threaded TCP connect scanner.

1. Accept a target and a port range on the command line with `argparse`
   (for example `uv run scan.py 127.0.0.1 -p 1-1024`).
2. Encode an **allow-list of scopes** in the script and refuse to run against anything outside it.
   Resolve names first, then check scope, then connect.
3. Use `socket.connect_ex` and classify each port as `open`, `closed` (`ECONNREFUSED`) or
   `unknown`. Do not call anything else "filtered".
4. Scan concurrently with `ThreadPoolExecutor`, and add a `--json` option that writes results with
   the target and a timestamp.

In your report: explain why a connect scan is logged by the target service, and why raising the
worker count is not always better.

### T2. Banner grabber (`banner.py`)

Extend scanning into service identification.

1. For a host and an open port, connect with a timeout and read the first bytes the service sends,
   decoding with `errors="replace"`.
2. Handle services that stay silent until spoken to (send a `\r\n` and read again).
3. For a TLS port, use the `ssl` module to complete a handshake and print the certificate's subject,
   issuer, expiry date and the negotiated protocol version.
4. Report any certificate expiring within 30 days, and any handshake that succeeds at TLS 1.0 or 1.1.

In your report: explain in two or three sentences why a version banner is a *candidate* finding and
not a confirmed vulnerability. Name at least two reasons a banner can be misleading.

### T3. Offline hash cracker (`crack.py`)

Build the cracking loop so its cost is visible, against hashes you create yourself.

1. Generate your own targets: hash five passwords from your wordlist, once with unsalted SHA-256 and
   once with a per-user salt (`secrets.token_bytes(16)`). Do not use anyone else's hashes.
2. Write a dictionary attack that opens the wordlist in **binary** mode, strips only `\r\n`, and
   tests one candidate at a time.
3. Add a small mangling rule set (capitalisation, a trailing digit or `!`, an appended year) and
   report how many more passwords it recovers.
4. Re-hash the same passwords with `hashlib.pbkdf2_hmac` at a realistic iteration count and time how
   many candidates per second you manage against each of the three schemes.

In your report: from your three timings, estimate how long each scheme would resist a cracker a
thousand times faster than your machine, and state your assumptions. Explain in one sentence what a
per-user salt changes and what it does *not*.

### T4. HTTP inspection tool (`httptool.py`)

Write a small HTTP client for a lab web target, using `requests`.

1. Use a `Session`, set a `timeout`, set `allow_redirects=False`, and send a recognisable
   `User-Agent` that identifies the traffic as authorized testing.
2. Print the status code, the response length, and the values of these security headers:
   `Content-Security-Policy`, `Strict-Transport-Security`, `X-Frame-Options`,
   `X-Content-Type-Options`. Write a one-line finding for each header that is missing.
3. Fetch `robots.txt` and report any paths it discloses.
4. Add a `--headers-only` mode that sends a `HEAD` request and prints only the header report.

In your report: for one missing security header, name the attack it helps resist and the concrete
configuration change that would add it.

## Report

Structure: a short introduction, one section per task (T1 to T4), then a conclusion. For every task,
show the command, the output (screenshot), the script, and the written answers requested above. In
the conclusion, name for each tool one defensive control that would reduce what the tool can learn
or do against a target.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **T1 Scanner** | 20% | Works, scope allow-list enforced after resolution, correct open/closed/unknown classification, concurrency and `--json` present, writeup correct. |
| **T2 Banner grabber** | 20% | Banner and TLS certificate read correctly, expiry and weak-TLS checks work, candidate-vs-confirmed explained with two valid reasons. |
| **T3 Hash cracker** | 25% | Self-generated targets, binary-mode wordlist, mangling rules, three timings measured, salt effect and resistance estimate explained with stated assumptions. |
| **T4 HTTP tool** | 15% | Session with timeout and no auto-redirect, header report correct, `robots.txt` parsed, `--headers-only` mode works, one header fix named correctly. |
| **Code quality** | 10% | Readable scripts, `argparse`, specific exception handling, no bare `except`, no shell from input, `__main__` guard, `requirements.txt` committed. |
| **Report quality** | 10% | Clear structure, every claim backed by your own output, scope and legality respected throughout. |
| **Bonus** | +20% | See below. |

## Bonus Challenges

Each is optional and documented the same way as the required tasks.

### B1. Constant-time verification

Add a `verify` function to `crack.py` using `hmac.compare_digest`, and a second one using `==`. In
your report, explain which threat the first removes and why timing it on your own machine is hard to
measure.

### B2. CIDR sweep

Extend `scan.py` to accept a CIDR range with `ipaddress`, iterate its hosts, and refuse to run if
the range is not private. Confirm it rejects a public range.

### B3. Authorization matrix

Against a lab web app you installed (Juice Shop or DVWA), extend `httptool.py` to log in with two
accounts you created and request the same set of object identifiers as each. Present the result as a
grid and mark every cell where one user reached another user's object.
