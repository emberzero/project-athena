# Reporting

The report is the product. Everything before it is work in progress. A test that found a critical
flaw and described it badly has delivered nothing, because nothing will be fixed. A test that
found three medium issues and explained them so clearly that all three were fixed within a week
has delivered a great deal.

Two audiences read the same document and want different things. Management wants to know whether
to be worried and what it costs to stop being worried. Engineers want to know exactly which
request on which endpoint, and exactly what to change. A good report serves both without making
either read the other's section.

## Structure

A conventional structure, in the order it is read:

1. **Title page and document control.** Client, scope reference, test window, authors,
   classification, version history. The classification matters: this document is a list of ways to
   break into the client.
2. **Executive summary.** One page, no jargon. What was tested, what the overall posture looks
   like, the three things that matter most, and the recommended next steps.
3. **Scope and methodology.** What was in scope and explicitly what was not, the test window, the
   source addresses used, the standards followed, the tools used, and the limitations.
4. **Findings overview.** A table of findings with severity, affected asset and status, so a reader
   can triage before reading detail.
5. **Detailed findings.** One section per finding, in severity order.
6. **Strategic recommendations.** The systemic changes behind the individual findings: patch
   process, segmentation, credential management, logging.
7. **Appendices.** Scan output, artifacts table, tooling versions, CVSS vectors, glossary.

### The executive summary

Write it last and write it for someone who will read nothing else. Rules that make it usable:

- No tool names, no CVE numbers, no hostnames.
- Lead with business impact, not with technique.
- Say what is good as well as what is bad. A summary that only accuses is read defensively.
- Quantify where you honestly can and avoid invented numbers where you cannot.

Weak:

> We performed an external penetration test and identified a critical unauthenticated RCE in the
> Tomcat instance on srv-dmz-04, as well as several misconfigurations.

Better:

> Starting from the public internet with no credentials, we were able to take full control of a
> public-facing application server within the first day and from there read the complete customer
> database. The underlying causes are a missed patch and the absence of network separation between
> the public-facing servers and the internal database network. Fixing the patch removes the
> immediate exposure; introducing that network separation is the change that prevents the next
> comparable bug from having the same consequence.

### The limitations section

Say what the test could not cover and why: a host that was offline during the window, a module
excluded by the client, a technique forbidden by the RoE, time that ran out. This protects you,
and more importantly it stops the client reading "no findings in area X" as "area X is secure".

## Anatomy of a Finding

Every finding carries the same fields, every time, so readers learn where to look.

- **Identifier and title.** Short, descriptive, no drama. "Unauthenticated file upload leads to
  remote code execution", not "Total system compromise!!".
- **Severity.** Your rating, with the CVSS vector if you use CVSS, plus a sentence on how context
  changed the rating.
- **Affected assets.** Hostnames, URLs, IP addresses, parameter names.
- **Description.** What the weakness is, in general terms, in two or three sentences.
- **Impact.** What an attacker achieves. Concrete, and in the client's terms.
- **Reproduction steps.** Numbered, complete, copy-pasteable. Someone who is not you must be able
  to follow them.
- **Evidence.** The request and response, the screenshot, the command output. Redact real personal
  data.
- **Remediation.** What to change. Specific enough to turn into a ticket, including a short-term
  mitigation if the real fix is slow.
- **References.** CWE, vendor advisory, OWASP page.

### Worked example

> **F-03: Password reuse between DMZ and internal servers**
>
> **Severity:** High. CVSS v3.1 base 8.1, raised in context because the reused account had
> administrative rights on the database server holding production customer data.
>
> **Affected assets:** `10.10.1.20` (DMZ application server), `10.10.9.5` (database server),
> local account `svc-deploy`.
>
> **Description:** The local service account `svc-deploy` uses the same password on the DMZ
> application server and on the internal database server. The credential was recoverable from a
> world-readable deployment script on the DMZ host.
>
> **Impact:** Any compromise of the DMZ application server yields administrative access to the
> internal database server, bypassing the trust boundary the DMZ exists to create. During this
> test the full customer table was reachable from an initial unauthenticated internet position.
>
> **Reproduction:**
>
> 1. On `10.10.1.20`, read `/opt/deploy/release.sh` as any local user.
> 2. Note the `svc-deploy` password on line 14.
> 3. Authenticate to `10.10.9.5` as `svc-deploy` with that password.
> 4. Confirm administrative rights with a privilege query.
>
> **Evidence:** `evidence/F-03-script.png`, `evidence/F-03-login.txt`. Record values redacted.
>
> **Remediation:** Short term, change the `svc-deploy` password to a unique value per host and
> remove the credential from the deployment script, reading it from a secrets store instead. Long
> term, provision service accounts per trust zone and rotate credentials automatically, so that a
> credential recovered in the DMZ is useless internally.
>
> **References:** CWE-798 (use of hard-coded credentials), CWE-522 (insufficiently protected
> credentials).

Note what the remediation does: it gives a change that can ship this week and the structural change
that prevents the class. Both, every time.

## Rating Risk Honestly

Severity is where reports lose credibility fastest, in both directions.

- **Inflating.** Rating everything high so the report looks valuable. The client's engineers notice
  within one finding, and then they discount the real high as well.
- **Deflating.** Downgrading because the client seemed unhappy. Not your call; the risk acceptance
  decision is theirs, and your job is to describe the risk accurately so they can make it.

A defensible rating has two components, and the report should show both:

- The technical severity, ideally with a published vector so it can be checked.
- The contextual adjustment, with the reason stated: exposure, data sensitivity, existing
  compensating controls, exploitability observed in the wild.

When a client disagrees, record the disagreement rather than silently changing the number. "The
client assesses this as Medium because the affected network is not reachable from user segments;
we retain our High rating because we reached it during the test" is a legitimate and useful
paragraph.

## Writing That Gets Fixes Shipped

- **One finding per root cause.** Forty hosts missing the same patch is one finding with forty
  affected assets.
- **Use the active voice and name the component.** "The login endpoint accepts..." beats "it was
  observed that...".
- **No blame.** Describe systems, not people. A report that reads as an accusation produces
  defensiveness instead of tickets.
- **Make remediation checkable.** "Harden the server" is not a ticket. "Set `SSLProtocol` to
  exclude TLS 1.0 and 1.1 in the virtual host configuration" is.
- **Include what worked.** If MFA blocked your spray, say so. It tells the client which investments
  paid off, and it is how security budgets survive.
- **Screenshots with context.** A terminal screenshot with no hostname or timestamp proves nothing.

## Handling and Delivery

The report is one of the most sensitive documents the client will hold, and so are your working
notes.

- Encrypt the deliverable in transit and at rest; agree the delivery channel in the RoE rather than
  attaching it to an unencrypted email at the end.
- Keep a defined retention period, and delete engagement data when it expires. Under the GDPR you
  are processing the client's data on their behalf, which means a written agreement, documented
  retention and documented deletion. Module 01 covers the obligations.
- Agree who may receive the report. Onward sharing with an auditor or an insurer should be a
  decision, not an accident.
- Redact personal data in evidence. A screenshot proving you read a customer record does not need
  the customer's name in it.

## Retest and Closure

A report without a retest is a report that might be ignored. The usual pattern:

1. Deliver the draft and hold a walkthrough call so engineers can ask questions while the context
   is fresh.
2. Incorporate factual corrections. Keep rating disagreements as recorded disagreements.
3. Deliver the final report.
4. After remediation, retest the findings and issue a short retest letter stating for each finding
   whether it is fixed, partially fixed, or open.

The retest letter is frequently the document the client actually forwards to a customer or an
auditor, so keep it short and unambiguous.

## The Defensive View

Reporting is where an offensive engagement becomes a defensive improvement, and the report's
structure either enables that or prevents it.

- Mapping findings to a framework such as MITRE ATT&CK gives the blue team something to build
  detections against, in addition to something to patch.
- The artifacts table from post-exploitation lets the SOC reconcile the alerts they saw, and the
  alerts they did not see, with what actually happened. That comparison is often the most valuable
  page in the document.
- The strategic recommendations section is where segmentation, egress filtering, least privilege
  and logging belong. Individual findings get patched; only the strategic section changes the
  shape of the next test's result.

## Exercises

1. Take one finding from your lab work in lecture 3 or 4 and write it up using the full field list
   above. Give it to a classmate and have them reproduce it using only your steps.
2. Write a one-page executive summary for your lab engagement. Remove every tool name, CVE number
   and hostname, then check it still says something.
3. Write the strategic recommendations section for the same engagement: three systemic changes,
   each tied to at least two findings.
4. Draft the retest letter for two findings, one fixed and one still open.

## Key Takeaways

- The report is the deliverable. A finding that cannot be understood will not be fixed.
- Two audiences: a jargon-free executive summary and precise, reproducible technical detail.
- Every finding needs the same fields, including reproduction steps a stranger can follow and
  remediation someone can turn into a ticket.
- Give both a short-term mitigation and the structural fix for the class of problem.
- Rate honestly, show the vector, state the contextual adjustment, and record disagreements rather
  than quietly changing numbers.
- Say what was out of scope and what you could not test, so absence of findings is not read as
  absence of risk.
- Treat the report and your notes as sensitive data: encrypted delivery, defined retention,
  redacted evidence.
- A retest closes the loop and is often the document that gets forwarded.

## Resources

- [PTES reporting guidance](http://www.pentest-standard.org/index.php/Reporting)
- [NIST SP 800-115, reporting chapter](https://csrc.nist.gov/pubs/sp/800/115/final)
- [CVSS calculator, FIRST](https://www.first.org/cvss/calculator/3.1)
- [CWE: Common Weakness Enumeration](https://cwe.mitre.org/)
- [MITRE ATT&CK](https://attack.mitre.org/)
- Module 01: Ethics and Legal
