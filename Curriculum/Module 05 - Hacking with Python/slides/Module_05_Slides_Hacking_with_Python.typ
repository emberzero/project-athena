#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 05: Hacking with Python],
    subtitle: [Scripting the tools you cannot buy],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 05 - Hacking with Python],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Python Basics for Security Work")

#slide(title: "Why Python")[
  Nmap, Burp and Wireshark cover the common cases. Python covers
  the case specific to the system in front of you.

  - A proprietary protocol on TCP/9100
  - A login form with a rotating token
  - Ten thousand log lines that need correlating

  Each of those is a twenty-line script, not a product.
]

#slide(title: "bytes vs str")[
  The single most common source of broken security scripts.
  A socket, a hash and a binary file all deal in `bytes`.

  ```python
  b"GET / HTTP/1.0\r\n\r\n"       # bytes on the wire
  "GET /".encode()               # str -> bytes
  raw.decode("utf-8",            # bytes -> str,
             errors="replace")   # never crashing on junk
  ```

  Python will not convert between them for you. Treat anything
  off the wire as *attacker-controlled*.
]

#slide(title: "Failure Is the Normal Case")[
  In a scan, most targets do not answer. A script that aborts on
  the first refused connection is useless.

  ```python
  try:
      with socket.create_connection(
              (host, port), timeout=2) as sock:
          banner = sock.recv(1024)
  except (socket.timeout, OSError):
      banner = None
  ```

  Catch the *specific* exception. A bare `except:` swallows typos
  and Ctrl+C alike and turns a bug into a wrong result.
]

#slide(title: "Standard Library Worth Knowing")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [`socket`, `ssl`], [connections, TLS, banner grabbing],
    [`ipaddress`], [parse CIDR, iterate hosts, classify],
    [`hashlib`, `hmac`], [digests, constant-time compare],
    [`secrets`], [secure random values and tokens],
    [`argparse`, `logging`], [reusable CLI, tunable output],
    [`concurrent.futures`], [thread and process pools],
    [`subprocess`], [driving external tools safely],
  )

  Reach for a dependency only when the stdlib does not cover it.
]

#slide(title: "Two Guard Rails")[
  #split(
    [
      *Scope, in code*
      ```python
      addr = ipaddress.ip_address(x)
      addr.is_private   # True
      addr.is_loopback  # False
      ```
      `is_private` stops a typo pointing the scanner at the
      public internet.
    ],
    [
      *No shell from input*
      ```python
      subprocess.run(
        ["nmap", "-sV", target],
        timeout=300)
      ```
      Pass an argument list and leave `shell=False`; a `;` in a
      hostname is otherwise a command.
    ],
  )
]

#slide(title: "Concurrency and Rate")[
  Scanning is I/O-bound, so threads help:

  ```python
  with ThreadPoolExecutor(max_workers=50) as pool:
      results = pool.map(check, ports)
  ```

  - The GIL means threads do *not* speed up hashing; use
    `multiprocessing` for CPU-bound work
  - More workers is not better: hundreds of connections look
    like a SYN flood and can knock over small devices
  - Rate-limit by default; the polite default will not take down
    a production host
]

#standout-slide(title: [Building a tool and pointing it at a
  system are different acts. Authorization in writing, first.])

#section-slide(title: "Password Cracking")

#slide(title: "Cracking Is Just Guessing")[
  A candidate is run through the *same function the defender
  used*, and the result is compared with the stored value.

  Three generations of storage:

  - *Bare digest*: `md5`/`sha256`, fast and unsalted. One table
    cracks every user at once.
  - *Salted digest*: unique per-user salt kills precomputation.
    Still fast.
  - *KDF*: PBKDF2, bcrypt, scrypt, Argon2. Salted *and*
    deliberately slow. The only acceptable choice for new systems.
]

#slide(title: "The Cracking Loop")[
  #align(center, image("../lectures/images/cracking-pipeline.svg", width: 56%))

  The attacker repeats the right-hand side per candidate. The
  defender picks the KDF and cost factor once. That asymmetry is
  the whole subject.
]

#slide(title: "A Dictionary Attack")[
  Crack a hash you created five lines earlier.

  ```python
  TARGET = hashlib.sha256(b"dolphin").hexdigest()

  def crack(target, wordlist_path):
      with open(wordlist_path, "rb") as fh:
          for line in fh:
              word = line.rstrip(b"\r\n")
              if hashlib.sha256(word).hexdigest() \
                      == target:
                  return word
      return None
  ```

  Open in *binary*; `rstrip(b"\r\n")` not `strip()`; one line at
  a time, never the whole file into memory.
]

#slide(title: "Offline vs Online")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 7pt,
    stroke: 0.5pt + gray,
    [], [*Offline*], [*Online*],
    [Attacker has], [the hash file], [a login endpoint],
    [Limited by], [hardware], [network and app],
    [Defence], [strong KDF], [rate limit, lockout, MFA],
  )

  A high bcrypt cost does nothing against credential stuffing;
  rate limiting does nothing once the database is stolen. You
  need both.
]

#slide(title: "Why the Python Cracker Is Slow")[
  Three structural reasons:

  1. The hash loop runs in the interpreter
  2. The GIL blocks threads on CPU-bound hashing
  3. No GPU, which is exactly what hashing parallelises onto

  ```bash
  hashid '$2b$12$...'              # identify first
  hashcat -m 1400 -a 0 sha256.txt wordlist.txt
  hashcat -m 0 -a 0 md5.txt wordlist.txt -r best64.rule
  ```

  Python teaches the loop and prepares candidates; *hashcat* and
  *John* do the cracking.
]

#slide(title: "Verifying Correctly")[
  ```python
  ITERATIONS = 600_000   # a policy, not a constant
  digest = hashlib.pbkdf2_hmac(
      "sha256", pw.encode(), salt, ITERATIONS)
  return hmac.compare_digest(candidate, digest)
  ```

  - *`hmac.compare_digest`, not `==`*: a normal compare leaks how
    much of the value was correct through timing
  - *Cost is policy*: look up the current OWASP value, store it
    with the hash, and raise it as hardware improves
]

#slide(title: "Defences That Work")[
  In roughly descending order of effect:

  - *MFA* - a cracked password alone stops being enough
  - *A modern KDF* at a current cost factor
  - *Block breached passwords* at registration (HIBP, k-anonymity)
  - *Length over composition* rules; no forced rotation
  - *Rate limiting and lockout*, plus spray detection
  - *Detect the dump*: mass reads of the user table, canary
    accounts
]

#section-slide(title: "Vulnerability Scanning")

#slide(title: "Scope First, Always")[
  Before a packet leaves the machine, the script must know what
  it may touch.

  ```python
  ALLOWED = [ipaddress.ip_network("192.168.56.0/24")]

  def in_scope(addr):
      ip = ipaddress.ip_address(addr)
      return any(ip in net for net in ALLOWED)
  ```

  Resolve first, then check scope, then connect: a name that was
  a lab address last week can resolve elsewhere today.
]

#slide(title: "The TCP Connect Scan")[
  #align(center, image("../lectures/images/connect-scan-outcomes.svg", width: 40%))

  ```python
  code = sock.connect_ex((host, port))
  # 0 = open, ECONNREFUSED = closed, else unknown
  ```

  A connect scan completes the handshake, so the service logs it.
  It is loud by construction.
]

#slide(title: "What a Result Proves")[
  - `connect_ex` returning 0 is *open*; `ECONNREFUSED` is
    *closed*; everything else is *unknown*, not "filtered"
  - A *SYN scan* never completes the handshake, so it leaves no
    application log entry. Writing it is instructive; relying on
    it is not, so `nmap -sS` for real work
  - *UDP* is ambiguous: no answer covers both open and filtered
    without a protocol-specific probe

  Let nmap scan; let Python decide what the result means here.
]

#slide(title: "Version Is Not Vulnerable")[
  A banner says `OpenSSH_8.9p1 Ubuntu-3ubuntu0.1`. Not a verdict:

  - *Backports* patch without changing the version string
  - *Banners lie* and reverse proxies rewrite them
  - *Configuration decides* what is actually reachable

  #cblock(title: [Mark confidence], color: red.darken(20%))[
    Version matching produces *candidates*. Record a `confidence`
    field, a timestamp and the scope. Never invent a CVE; look it
    up in the NVD or the vendor advisory.
  ]
]

#section-slide(title: "Web Application Testing")

#slide(title: "The HTTP Client")[
  A browser hides headers and enforces rules the server should.
  A script sends exactly the bytes you choose.

  ```python
  s = requests.Session()
  s.headers.update(
      {"User-Agent": "athena-lab-test/0.1"})
  resp = s.get(url, timeout=10,
               allow_redirects=False)
  ```

  Always set `timeout`; disable auto-redirects while testing;
  read `resp.content` length as well as status. Identify your
  traffic so the SOC is not surprised.
]

#slide(title: "Through an Intercepting Proxy")[
  #align(center, image("../lectures/images/proxy-in-the-middle.svg", width: 42%))

  ```python
  proxies = {"https": "http://127.0.0.1:8080"}
  requests.get(url, proxies=proxies,
               verify="burp-ca.pem")
  ```

  Trust the proxy's CA; never `verify=False`, which hides every
  TLS problem you were hired to find.
]

#slide(title: "Injection Classes, Same Shape")[
  Send a crafted value, watch for a distinguishable response, in
  the lab only. The *fix* matters more than the payload.

  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Class*], [*Fix*],
    [SQL injection], [parameterised queries],
    [Reflected / XSS], [context-aware output encoding, CSP],
    [Command injection], [argument lists, no shell],
    [Path traversal], [resolve and check it stays in base],
    [SSRF], [allow-list after resolution, block private],
  )
]

#slide(title: "Confirm Before Reporting")[
  ```python
  if timing(url, "1' AND SLEEP(3)-- ") \
          - timing(url, "1") > 2.5:
      print("possible SQLi, verify manually")
  ```

  - Reflection alone is *not* XSS: check the encoding of the
    surrounding context
  - A single timing spike is *not* SQLi: networks jitter. Repeat
    it and confirm the time tracks the delay you asked for
  - For confirmation, `sqlmap`; writing your own chain wastes time
]

#slide(title: "Authorization Testing")[
  Where Python beats every point-and-click tool. Broken access
  control is systematic, and a systematic bug wants a loop.

  ```python
  for user, path in product(SESSIONS, OBJECTS):
      r = SESSIONS[user].get(base + path)
      print(user, path, r.status_code, len(r.content))
  ```

  Build the grid of identities against objects. Every cell where
  a user reaches another's object is an *IDOR*.

  *Fix:* authorize server-side, at the data layer, by object
  owner.
]

#slide(title: "API Testing")[
  APIs are easier to test: they are already machine-readable. An
  OpenAPI spec lists endpoints no link points at.

  - *Authorization* on every method of every endpoint
  - *Mass assignment*: add `"role": "admin"`, see if it binds
  - *Excessive data exposure*: more fields than the UI shows
  - *Rate limiting*: do a hundred rapid requests still succeed?
  - *JWTs*: reject `alg: none`, verify `exp`, `aud`, `iss`
    server-side; never decide from an unverified decode
]

#standout-slide(title: [A finding names the control, not the
  symptom. And every target is yours, with written consent.])
