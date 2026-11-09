# Scoping and Reconnaissance

Scoping is the part of a penetration test that protects everyone: the client from surprises, the
tester from prosecution, and third parties from being attacked by accident. Reconnaissance is the
first technical phase, and its quality determines how much of the remaining time is productive.

Module 02 covers reconnaissance techniques in depth. This lecture covers the part that is specific
to a paid engagement: turning a client conversation into a scope you can defend, and then mapping
only what that scope allows.

## Pre-Engagement

### Questions to answer before quoting

- **What are we testing?** Concrete identifiers: IP ranges in CIDR notation, fully qualified
  hostnames, URLs including the path prefix, mobile app package names, AD domain names.
- **What are we not testing?** Explicit exclusions are as important as inclusions. Legacy hosts in
  the same /24, the production payment gateway, the CEO's laptop.
- **From where?** External over the internet, internal from a supplied VPN, or on site.
- **With what starting knowledge?** Black, grey or white box, and which credentials are provided.
- **When?** The test window, including whether out-of-hours testing is required or forbidden.
- **How far may we go?** Is exploitation allowed, or only verification? Is lateral movement in
  scope? Is data exfiltration simulated or actually performed? Are denial-of-service tests
  permitted (almost always not)?
- **Who do we call?** A technical contact and an escalation contact, both reachable during the
  window, with phone numbers as well as email addresses.

### Rules of Engagement

The Rules of Engagement (RoE) document is the operational companion to the contract. It records
the scope, the window, the contacts, the permitted techniques, and the stop conditions. A usable
RoE answers questions at 02:00 without anyone having to be woken up.

Minimum content:

- Scope and explicit out-of-scope list
- Test window and time zone
- Source IP addresses the tester will use, so the blue team can allow-list or correlate them
- Permitted and forbidden techniques
- Handling rules for discovered data, especially personal data
- Stop conditions and the notification procedure
- Evidence handling and report delivery method

### Authorization

Authorization must be in writing, signed by someone who has the authority to grant it, and
specific about scope and dates. "Our head of IT said it was fine on a call" is not authorization.
This is a legal requirement rather than a formality: without it, the activity falls squarely under
StGB §118a and related provisions. See Module 01.

Three situations need extra care:

- **Shared hosting and cloud.** The client does not own the hardware. Most providers publish a
  penetration testing policy stating what is permitted against resources you own on their platform
  and what requires prior notification. Read the current policy of the specific provider, because
  these policies change.
- **Third-party services.** A SaaS login page on the client's subdomain belongs to the SaaS vendor.
  Out of scope unless the vendor agrees in writing.
- **Personal data.** If testing exposes personal data, GDPR obligations apply to you as well as to
  the client. Minimize what you collect, prove what you need to prove, and do not copy a customer
  database because you could.

### Stop conditions

Agree in advance what causes the test to stop immediately and trigger a phone call:

- Evidence of a pre-existing, unrelated compromise
- A production outage, whether or not you caused it
- Discovery of data that is clearly out of scope, for example medical or payroll records
- Anything suggesting the system is life-safety relevant

## Reconnaissance

Reconnaissance splits into passive and active, and the boundary is whether you send traffic to the
target.

### Passive reconnaissance

Passive means querying third parties, not the target. It leaves no trace in the client's logs,
which makes it the right place to start even when stealth is not required, because it is also
free.

Useful sources:

- **DNS records.** Authoritative data about the published infrastructure.
- **Certificate transparency logs.** Public logs of issued TLS certificates, which leak hostnames
  that were never meant to be public, including test and staging names.
- **WHOIS and RDAP.** Registrant and netblock ownership, which helps confirm what the client
  actually owns.
- **Search engines and code hosting.** Leaked configuration, internal hostnames in commit history,
  API keys in public repositories.
- **Job adverts and conference talks.** The technology stack, named in detail, by the client.

```bash
# Authoritative DNS records for a domain
dig example.com ANY
dig example.com MX
dig example.com TXT
dig +short NS example.com

# Reverse lookup for a netblock entry
dig -x 198.51.100.10 +short

# Registry data
whois example.com
```

Certificate transparency is worth a specific mention because it is the single highest-yield
passive source for finding hosts. Every publicly trusted certificate issued for a hostname is
logged, so a search for a domain returns a list of names someone requested certificates for,
including `vpn-test`, `jenkins` and `old-admin`.

### Active reconnaissance

Active means the target sees your traffic. From this point on you are inside the test window and
inside the scope, and nothing else.

Host discovery first, because scanning 65,535 ports on 254 addresses when 12 hosts exist wastes
most of the window.

```bash
# Host discovery only, no port scan
nmap -sn 10.10.1.0/24

# ARP-based discovery, most reliable on a local segment (needs root)
sudo nmap -sn -PR 10.10.1.0/24
```

Then service enumeration on the hosts that answered. Keep the output in all formats so you can
grep it later and attach it as evidence.

```bash
# Fast first pass: top ports, version detection, default scripts
sudo nmap -sS -sV -sC --top-ports 1000 --open -oA scans/quick 10.10.1.20

# Full TCP range once you know the host is interesting
sudo nmap -sS -p- -oA scans/allports 10.10.1.20

# UDP is slow; pick the ports that matter
sudo nmap -sU --top-ports 50 -oA scans/udp 10.10.1.20

# Work from a file of in-scope targets, so you cannot typo your way out of scope
sudo nmap -sS -sV -iL scope.txt -oA scans/scope
```

Keeping the scope in a file and always passing `-iL` is a cheap habit that prevents the single
most common professional accident: a mistyped CIDR mask scanning a neighbour's network.

Web-specific enumeration follows, since a service on 443 tells you almost nothing by itself:

```bash
# Server headers, redirects and TLS details
curl -sSI https://example.com
openssl s_client -connect example.com:443 -servername example.com </dev/null 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates -ext subjectAltName

# Virtual hosts and paths, against your own lab target
gobuster dir -u http://10.10.1.20/ -w /usr/share/wordlists/dirb/common.txt
```

### Keeping notes that become a report

Start the report during reconnaissance, not at the end. For every host record what responded, what
version was reported, and the timestamp. Three practices pay for themselves:

- One directory per engagement, with `scans/`, `evidence/`, `notes.md`.
- Every command recorded as you ran it, so a finding can be reproduced exactly.
- Screenshots and raw tool output stored at the moment you see them, because the target will be
  patched before you write the report.

```bash
# A transcript of everything typed and printed in a shell session
script -a notes/session-$(date +%F).log
```

## The Defensive View

Everything in this lecture has a counterpart on the blue side, and a report should say so.

- **Passive exposure is reduced by managing what is published.** Certificate transparency cannot be
  opted out of, so the fix is not to put internal hostnames into public certificates, and to use a
  wildcard or a separate internal CA for internal names.
- **DNS hygiene.** Remove records for decommissioned hosts. Stale records pointing at
  reassignable cloud addresses are the cause of subdomain takeover.
- **Port scanning is detectable, and detection is the control.** A SYN scan across a segment is a
  distinctive pattern in firewall and IDS logs. If a full scan of the perimeter produced no alert,
  that is a finding about monitoring, independent of what the scan discovered.
- **Reduce the attack surface instead of hiding it.** A closed port is a control; a filtered port
  is a control; a service listening on `0.0.0.0` that only needs `127.0.0.1` is an unnecessary
  risk that costs one configuration line to remove.

## Exercises

Run all of these against your own lab network only.

1. Write a one-page RoE for a fictional test of your lab: scope in CIDR notation, window, contacts,
   forbidden techniques, stop conditions.
2. Build a `scope.txt` for your lab and run a discovery scan with `-iL`. Confirm that every host
   that answers is one you intended to include.
3. For a domain you own, list the hostnames visible in certificate transparency logs and compare
   them with the hostnames you believed were public.
4. Run a full TCP scan against one lab host and compare the result with the top-1000 scan. Note
   which interesting service only appeared in the full scan.

## Key Takeaways

- The scope is a list of concrete identifiers plus an explicit exclusion list, and the
  authorization is a signed document.
- The RoE exists so that nobody has to improvise at night: contacts, window, permitted techniques,
  stop conditions.
- Cloud, shared hosting and third-party SaaS need separate permission, because the client does not
  own them.
- Passive reconnaissance is free and silent; certificate transparency is its highest-yield source.
- Always drive active scans from a scope file, never from a CIDR you typed by hand.
- Take evidence and notes as you go. A finding you cannot reproduce is not a finding.

## Resources

- [OWASP Web Security Testing Guide, information gathering chapter](https://owasp.org/www-project-web-security-testing-guide/)
- [Nmap reference guide](https://nmap.org/book/man.html)
- [Certificate Transparency](https://certificate.transparency.dev/)
- [PTES pre-engagement interactions](http://www.pentest-standard.org/index.php/Pre-engagement)
- Module 01: Ethics and Legal; Module 02: Reconnaissance
