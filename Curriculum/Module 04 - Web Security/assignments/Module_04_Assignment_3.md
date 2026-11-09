# Assignment 3: API Security Assessment Project

## Objective

You will run a full security assessment against a deliberately vulnerable API that you deploy
yourself, find and exploit at least five vulnerabilities from the OWASP API Security Top 10:2023,
and report them the way a professional tester reports to a client. Afterwards you will be able to
enumerate an unfamiliar API, test it systematically against the API Top 10, and write findings that
a developer can act on and a manager can read.

## Logistics

- **Work:** individual, or in pairs. A pair submits one report naming both authors and stating who
  tested what.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module04_Assignment3.pdf`. A pair uses the
  name of the first author listed. Scripts and raw request logs go in an appendix inside the same
  PDF; do not submit archives.

## Setup

Choose **one** target and deploy it on your own machine. Both are free and open source, and both
are published for exactly this purpose.

### Option A: crAPI (the fuller target)

```bash
git clone https://github.com/OWASP/crAPI
cd crAPI
docker compose -f deploy/docker/docker-compose.yml up -d
```

Covers more of the API Top 10, includes a web front end and a GraphQL endpoint, and needs several
gigabytes of RAM. Check the repository README for the current compose path and the port it serves
on - the project moves these occasionally.

### Option B: VAmPI (the lighter target)

```bash
docker pull erev0s/vampi:latest
docker run -d -p 5000:5000 erev0s/vampi
```

A small vulnerable REST API with an OpenAPI document it serves itself. Faster to stand up, fewer
distinct vulnerability classes. Choose this one if your machine is short on memory.

### Tooling

- **Burp Suite Community**, free, for intercepting and replaying requests.
- **Postman** or **Insomnia**, or just `curl` and `jq`, for driving the API directly.
- **jwt_tool** (<https://github.com/ticarpi/jwt_tool>) if your target issues JWTs.
- Python with `requests` for the scripted tests in Task 3. Lecture 5 contains a BOLA test loop you
  can adapt.
- Docker. Everything else is free; nothing here needs hardware beyond a laptop that can run the
  container.

### Rules of engagement

- **In scope:** only the container you deployed, on your own machine, reachable only from
  `localhost`.
- **Out of scope:** everything else. No public API, no bug bounty target, no school system, no
  classmate's container, and no "I only tested it gently" exceptions. Lecture 5 suggests testing a
  public API as practice; for this graded assignment, do not.
- Do not expose the container to the network or to the internet. It is deliberately vulnerable and
  it is yours to keep contained.
- Module 01 and Austrian StGB §118a, §126a and §126b cover the boundary. Unauthorised testing is a
  criminal matter here, not a disciplinary one.

## Tasks

### 1. Enumeration

Map the API before you attack it.

**In the report:** a table of every endpoint you found, with its method, whether authentication is
required, the parameters it accepts, and how you discovered it (documentation, front-end traffic in
Burp, the OpenAPI document, guessing). Then half a page on the technology stack: framework,
database if identifiable, authentication mechanism, and any version banners or error messages that
disclosed something.

Also state which target you chose and why, and include the output of `docker ps` showing your
container running.

### 2. Register your own accounts

Create **two** user accounts of your own on the target and note their identifiers. Every
authorisation test below uses these two. Your tokens and user IDs are specific to your deployment,
which is what makes your evidence yours.

**In the report:** both usernames or emails, both user IDs, and one decoded JWT or session cookie
per account with the sensitive values redacted except the subject claim.

### 3. Test against the OWASP API Top 10:2023

Work through these systematically. For each, state what you tested, how, and the result - including
the categories where you found nothing. A negative result that is documented is worth marks; a
category you skipped silently is not.

1. **API1 - Broken Object Level Authorisation.** Use account A's token against account B's
   resources, across every object-bearing endpoint you found. Script the loop rather than clicking.
2. **API2 - Broken Authentication.** Password policy, rate limiting on login, token lifetime, token
   reuse after logout, and the JWT weaknesses from lecture 5: `alg: none`, a weak signing secret,
   algorithm confusion, missing expiry.
3. **API3 - Broken Object Property Level Authorisation.** Mass assignment: add fields the client
   should not control, such as a role or balance field, to an update request. Excessive data
   exposure: look for fields in responses the client never needed.
4. **API4 - Unrestricted Resource Consumption.** Rate limits, pagination limits, and on crAPI's
   GraphQL endpoint, query depth and batching.
5. **API5 - Broken Function Level Authorisation.** Reach administrative functions with a normal
   user's token, including endpoints that are not linked from the front end.
6. **API7 - SSRF.** Any endpoint that fetches a URL: internal addresses, `localhost`, and the cloud
   metadata address.
7. **At least two of:** SQL or NoSQL injection, injection reflected into a response, CORS
   misconfiguration, missing security headers, or information disclosure through errors.

### 4. Write the findings

**At least five confirmed findings, in at least four different API Top 10 categories.** Each
finding gets its own subsection containing:

- **Title, severity and category:** severity per the scale below, plus the API Top 10 entry and a
  CWE identifier.
- **Affected endpoints:** exact paths and methods.
- **Reproduction:** numbered steps, with the raw HTTP request and the relevant part of the response
  in code blocks. Someone holding your report and a fresh deployment must be able to reproduce it
  without asking you anything.
- **Impact:** what an attacker gets, in terms of this application's data and functions. Tie it to
  your own two accounts where the finding is an authorisation flaw.
- **Remediation:** the specific change. Name the check, the library, the configuration or the
  schema change. "Implement proper authorisation" earns nothing.

### 5. Report framing

Wrap the findings in:

- **Executive summary**, one page, for a reader who will not read the findings: what was tested,
  what the worst problem is, how many findings at each severity, and what to fix first.
- **Scope and methodology**, half a page: target and version, dates, tools, what you did not test
  and why.
- **Findings summary table**: finding, severity, category, affected endpoint, fix priority.
- **Appendix**: your test scripts and any long request logs.

### Severity scale

Use this scale and justify any rating you give in one sentence.

- **Critical** - remote code execution, authentication bypass, or access to every user's data.
- **High** - privilege escalation, access to other users' sensitive data, or no brute-force
  protection on authentication.
- **Medium** - limited information disclosure, CSRF on a meaningful action, weak password policy.
- **Low** - verbose errors, missing headers with no demonstrated impact, non-sensitive disclosure.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Enumeration** | 15% | Endpoint table substantially complete for the chosen target, with method, auth requirement, parameters and discovery method, plus a correct technology-stack description. |
| **Test coverage** | 20% | All seven test areas in Task 3 attempted and documented, negative results included, with the method stated for each. |
| **Findings** | 25% | Five or more genuine vulnerabilities across four or more API Top 10 categories, correctly classified with a correct CWE, and correctly rated against the severity scale. |
| **Reproducibility of evidence** | 15% | Every finding has raw requests and responses tied to the student's own accounts and deployment, and could be reproduced from the report alone. |
| **Remediation** | 15% | Each fix names a concrete mechanism that would actually close that finding in that codebase. |
| **Report craft** | 10% | Executive summary readable by a non-specialist, scope and methodology stated honestly including what was not tested, summary table consistent with the findings, appendix present. |
| **Bonus** | +20% | See below. |

Five findings with copied remediation boilerplate score below three findings a developer could fix
from the report. Severity inflation is marked down: rating a missing header as Critical costs marks
in the findings row.

## Bonus: Automate and verify (up to +20%)

Do **both**.

1. **Automate one class of test.** Write a script that tests one category across every endpoint you
   enumerated - a BOLA sweep, a JWT weakness check, or a mass-assignment fuzzer - and produces a
   readable result table. Include the script and its output. It must read your endpoint list rather
   than hardcode one path.
2. **Fix one finding and prove it.** Patch the target's source for one of your findings, redeploy,
   and show the same exploit failing while legitimate use still works. Include the diff.

### Bonus evaluation

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Automation** | +10% | A working script covering all enumerated endpoints for one category, with output that distinguishes vulnerable from safe endpoints. |
| **Verified fix** | +8% | A real diff, the exploit shown failing afterwards, and legitimate functionality shown still working. |
| **Explanation** | +2% | Two or three sentences on why the fix is sufficient and where else the same pattern would need applying. |

## Resources

- OWASP API Security Top 10:2023: <https://owasp.org/API-Security/>
- crAPI: <https://github.com/OWASP/crAPI>
- VAmPI: <https://github.com/erev0s/VAmPI>
- Burp Suite documentation: <https://portswigger.net/burp/documentation>
- OWASP Cheat Sheet Series: <https://cheatsheetseries.owasp.org/>
- CWE list: <https://cwe.mitre.org/>
