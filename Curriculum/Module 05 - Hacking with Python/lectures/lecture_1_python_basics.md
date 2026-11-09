# Python Basics for Security Work

## 1.1 Introduction

Python is the default language for security tooling because it removes the distance between an idea
and a working script. Nmap, Burp and Wireshark cover the common cases; Python covers the case that
is specific to the system in front of you. A proprietary protocol on TCP/9100, a login form with a
rotating token, ten thousand log lines that need correlating: each of those is a twenty-line script
rather than a product.

This lecture is not a general Python course. It covers the parts of the language and the standard
library that security scripts actually use, and the mistakes that make a script report the wrong
answer. Everything later in the module builds on it.

## 1.2 Environment

Use a virtual environment per project. A security toolbox accumulates packages with conflicting
requirements, and installing them system-wide eventually breaks the system's own Python.

```bash
# uv: creates the environment and installs into it
uv venv
uv pip install requests scapy

# the stdlib equivalent
python3 -m venv .venv
source .venv/bin/activate
pip install requests scapy
```

Run a script with `uv run script.py` or, inside an activated environment, `python script.py`.
Pin what you depend on in a `requirements.txt` or `pyproject.toml` and commit it, so a result from
six months ago can be reproduced.

### 1.2.1 Which Python

Write for a current Python 3. Avoid Python 2 code found online. Beyond its age, it treats strings as
bytes, which silently corrupts binary protocol work.

## 1.3 The Language, as Scripts Use It

### 1.3.1 Types you will meet constantly

```python
ports = [21, 22, 80, 443]              # list: ordered, mutable
seen = {"192.168.56.10", "192.168.56.11"}  # set: membership test, no duplicates
banner = {"port": 22, "service": "ssh"}    # dict: keyed record
target = ("192.168.56.10", 22)             # tuple: fixed-size record
```

A `set` is the right type for "have I already scanned this host". Membership testing in a set does
not get slower as it grows; in a list it does, and a scan over a /16 will crawl.

### 1.3.2 Strings versus bytes

This is the single most common source of broken security scripts. A network socket, a hash function
and a file opened in binary mode all deal in `bytes`. Text is `str`. Python will not convert between
them implicitly.

```python
b"GET / HTTP/1.0\r\n\r\n"          # bytes literal, what you send on a socket
"GET / HTTP/1.0\r\n\r\n".encode()  # str -> bytes (UTF-8 by default)
raw.decode("utf-8", errors="replace")  # bytes -> str, never crashing on junk
```

Banner grabbing returns bytes from a service that owes you no promise about encoding. Decode with
`errors="replace"` when you intend to print it, and keep the raw bytes when you intend to analyse
it. Treat anything that came off the wire as attacker-controlled: never pass it to `eval`, never
interpolate it into a shell command, and never trust its length.

### 1.3.3 Control flow and comprehensions

```python
open_ports = [p for p in range(1, 1025) if is_open(host, p)]
hosts = {line.strip() for line in open("targets.txt") if line.strip()}
```

Comprehensions are idiomatic and readable up to one condition. Beyond that, write the loop.

### 1.3.4 Functions and type hints

```python
def grab_banner(host: str, port: int, timeout: float = 2.0) -> bytes | None:
    """Return the first bytes a service sends, or None if nothing arrives."""
```

Hints are not enforced at runtime, but they document the bytes/str boundary where it matters most,
and an editor will catch the mismatch before the scan does.

### 1.3.5 Errors are the normal case

In a scan, failure is the expected outcome for most targets. A script that aborts on the first
refused connection is useless.

```python
import socket

try:
    with socket.create_connection((host, port), timeout=2) as sock:
        banner = sock.recv(1024)
except (socket.timeout, OSError) as exc:
    banner = None
    log.debug("%s:%s unreachable: %s", host, port, exc)
```

Catch the specific exceptions you expect. A bare `except:` swallows typos and `Ctrl+C` alike, and
turns a bug into a wrong result instead of a crash, which is far worse in a report.

## 1.4 Standard Library Worth Knowing

Most of a security script is standard library. Reach for a dependency only when the stdlib genuinely
does not cover the job.

| Module              | Use                                                          |
| ------------------- | ------------------------------------------------------------ |
| `socket`            | TCP/UDP connections, name resolution, banner grabbing        |
| `ssl`               | TLS handshakes, reading the server certificate               |
| `ipaddress`         | parsing CIDR ranges, iterating hosts, classifying addresses  |
| `hashlib`, `hmac`   | digests, HMACs, constant-time comparison                     |
| `secrets`           | cryptographically secure random values and tokens            |
| `argparse`          | command-line interface, so the script is reusable            |
| `logging`           | output that can be turned up to debug without editing code   |
| `csv`, `json`       | machine-readable results for the report                      |
| `concurrent.futures`| thread and process pools                                     |
| `subprocess`        | driving external tools such as nmap                          |

### 1.4.1 ipaddress

Never parse a CIDR range with string splitting.

```python
import ipaddress

net = ipaddress.ip_network("192.168.56.0/24")
print(net.num_addresses)                 # 256
for host in net.hosts():                 # skips network and broadcast
    print(host)

addr = ipaddress.ip_address("10.0.0.5")
print(addr.is_private, addr.is_loopback) # True False
```

`is_private` is the cheap guard that keeps an accidental typo in a target file from pointing your
scanner at the public internet.

### 1.4.2 argparse

A script with hardcoded targets gets copy-pasted and edited, and the edited copy is the one that
scans the wrong network.

```python
import argparse

parser = argparse.ArgumentParser(description="TCP connect scanner for authorized lab use")
parser.add_argument("target", help="host or CIDR range, e.g. 192.168.56.0/24")
parser.add_argument("-p", "--ports", default="1-1024")
parser.add_argument("-t", "--timeout", type=float, default=1.0)
parser.add_argument("-v", "--verbose", action="store_true")
args = parser.parse_args()
```

### 1.4.3 subprocess

Python is often the glue around existing tools. Pass arguments as a list and leave `shell=False`
(the default): with `shell=True`, a hostname containing `;` becomes a command.

```python
import subprocess

result = subprocess.run(
    ["nmap", "-sV", "-oX", "-", target],
    capture_output=True, text=True, timeout=300, check=False,
)
if result.returncode != 0:
    log.error("nmap failed: %s", result.stderr)
```

Set a `timeout`. A hung child process will otherwise hang your whole run.

### 1.4.4 Concurrency

Scanning is I/O-bound: the script spends its time waiting for packets, not computing. Threads are
the right tool, and `ThreadPoolExecutor` is the whole API you need.

```python
from concurrent.futures import ThreadPoolExecutor

with ThreadPoolExecutor(max_workers=50) as pool:
    results = list(pool.map(lambda p: (p, is_open(host, p)), ports))
```

CPython's global interpreter lock means threads do **not** speed up CPU-bound work such as hashing;
for that, use `multiprocessing` or a purpose-built tool. More workers is not strictly better:
hundreds of parallel connections look like a SYN flood to an IDS, and can knock over the embedded
device you were only trying to inventory.

## 1.5 Third-Party Packages

- **requests**: HTTP client. Sessions, cookies, proxies, TLS options.
- **scapy**: build, send and dissect packets at layer 2 and 3. Needs root.
- **beautifulsoup4**: parse HTML that was never meant to be parsed.
- **paramiko**: SSH client, for automating access you already have.
- **cryptography**: correct primitives, when you must touch crypto at all.

Install from PyPI with care. Typosquatted package names are a real supply-chain attack: read the
name you typed before you press enter, and prefer packages you can name the maintainer of.

## 1.6 Writing Scripts Other People Can Trust

A script that produces a number nobody can reproduce is worthless in a report.

- Record what you ran: target, timestamp, options, tool version. Put it in the output file.
- Separate collection from interpretation. Write raw results to JSON; decide what they mean later.
- Make the script idempotent where you can, so a re-run confirms rather than contradicts.
- Log with `logging`, not `print`, so `-v` is a flag and not a code change.
- Rate-limit by default. The polite default is the one that will not take down a production host.

```python
if __name__ == "__main__":
    main()
```

The guard matters: without it, importing your module to reuse one function immediately launches a
scan.

## 1.7 Legal and Ethical Frame

Writing the tool and running the tool are separate acts, and Austrian law treats them separately.
Accessing a computer system without authorization falls under StGB §118a, damaging data under
§126a, and disrupting a system's functionality under §126b. §126c covers the misuse of computer
programs and access data, which is relevant precisely because this module is about building tools.
Processing personal data you encounter engages the GDPR.

The practical rules for this module:

- Written authorization, naming the systems and the time window, before anything is sent.
- Run every exercise against your own lab VMs, a deliberately vulnerable target you installed, or a
  platform that permits it in its terms.
- RFC 1918 addresses and `example.com` in examples, never a real third party.
- No scanning of the school network or of any host you do not own.

Module 01 covers the legal detail; treat this as the reminder, not the reference.

## 1.8 Lab Exercise

Against your own lab VM only:

1. Write `banner.py` that takes a host and a port, connects with a 2-second timeout, prints the
   first 1024 bytes it receives decoded with `errors="replace"`, and exits cleanly when the port is
   closed.
2. Extend it to accept a CIDR range via `ipaddress`, and refuse to run if the range is not private.
3. Add `argparse`, `logging` and a `--json` output option.
4. Run it against your lab, then look at the same traffic in Wireshark. Confirm the packets match
   what you think your script sent.

## Key Takeaways

- Virtual environments per project; pin and commit your dependencies.
- `bytes` is what comes off the wire, `str` is text, and Python will not guess between them.
- Catch the specific exception you expect; in scanning, failure is the normal path.
- The standard library covers most of the job: `socket`, `ssl`, `ipaddress`, `hashlib`, `argparse`.
- Threads for I/O-bound scanning, processes for CPU-bound work, and fewer workers than you think.
- Never build a shell command from input you did not create; pass argument lists to `subprocess`.
- Authorization in writing first. Building a tool and pointing it at a system are different acts.

## Resources

### Official Documentation

- **Python Standard Library**: <https://docs.python.org/3/library/>
- **socket module**: <https://docs.python.org/3/library/socket.html>
- **ipaddress module**: <https://docs.python.org/3/library/ipaddress.html>
- **uv**: <https://docs.astral.sh/uv/>

### Books

- **"Black Hat Python"** by Justin Seitz and Tim Arnold: security scripting in Python
- **"Violent Python"** by TJ O'Connor: older, but the patterns still hold
- **"Fluent Python"** by Luciano Ramalho: the language itself, in depth

### Practice

- **Exercism Python track**: <https://exercism.org/tracks/python>
- **TryHackMe**, **HackTheBox**: lab targets you are permitted to script against
