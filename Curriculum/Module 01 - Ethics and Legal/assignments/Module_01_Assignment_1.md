# Assignment 1: Legal and Ethical Case File

## Objective

You will take a set of hacking scenarios and determine, section by section, which Austrian criminal
provisions they trigger and why - the same assessment you have to make before you touch any system in a
later module. You will then analyse one real, publicly documented case, draft a responsible disclosure
notification, and write the authorization document for your own lab that keeps your practical work on the
right side of §118a.

## Logistics

- **Work:** individual, or in pairs. Pairs hand in one PDF with both names and a short note on who wrote
  what.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module01_Assignment1.pdf`.

## Setup

Nothing to install and nothing to pay for. You need the two legal lectures of this module, the ethics
lecture, and access to the statute text. The Austrian provisions are available free of charge in the
Rechtsinformationssystem des Bundes at <https://www.ris.bka.gv.at/>, the German ones at
<https://www.gesetze-im-internet.de/stgb/>.

For Task 5 you need the lab environment you will use for the rest of the course - a virtual machine on your
own computer (VirtualBox or VMware Workstation Player, both free) or a Docker container you built yourself.
If you do not have one yet, create one empty Linux VM; the document is about *scope*, not about content.

## Boundary

This assignment is entirely research, analysis and writing. **No task here involves testing, scanning or
accessing any system.** The scenarios are fictional, the real case comes from public reporting, and the only
machine named in your submission is your own.

Do not "verify" anything about a real company's infrastructure for Task 3. Reading published reports, court
decisions, advisories and news coverage is all that is asked for, and anything beyond that would be the very
offence you are writing about.

## Tasks

### 1. Scenario assessment

For each of the seven scenarios below, produce one row in a table containing:

- The section(s) of the Austrian StGB that apply, or **"no offence"** with a justification.
- Which **key element** of that section is fulfilled, in your own words and tied to the facts given.
- Whether this is a case of *Vorsatz* (§5 Abs 1) or *Absicht* (§5 Abs 2) as far as the facts allow a
  judgement, and what in the scenario tells you that.
- The penalty range for the variant you think applies.
- Whether prosecution requires the authorization of the victim.

Names are fictional.

```text
A  Jonas collects a list of default administrator passwords for home routers and
   writes a script that would try them automatically. He never runs it.

B  Sarah guesses the password of a stranger's webmail account after several dozen
   attempts, logs in, and reads the messages stored in the mailbox.

C  Michael is a system administrator with legitimate full access to the company
   file server. After an argument he deletes a colleague's project directory.

D  A group coordinates enough traffic against an online shop to keep it
   unreachable for a day. No data is accessed or changed.

E  Nina hides a voice recorder in a closed meeting room and records the
   conversation that takes place there.

F  Tobias attaches a device to a payment terminal that reads the data from the
   bank cards used at it, and stores that data.

G  David captures his neighbour's unencrypted wireless traffic, extracts the chat
   messages from it, and forwards them to a third person.
```

Exactly one of the seven is intended to be arguable rather than clear-cut. Say which one you think that is
and argue both readings in three to four sentences.

### 2. Austria against Germany

Pick **two** of the seven scenarios. For each, state how it would be assessed under the German provisions
covered in the module (§202a, §202b, §202c StGB) and name one concrete difference in outcome: a different
section, a different penalty range, a different element that has to be proven, or a result that is an offence
in one country and not in the other. Two or three sentences per scenario, no essay.

### 3. One real case

Choose **one** publicly documented case: a cybercrime prosecution, a security researcher who got into legal
trouble, or a disclosure that went wrong. Register your choice with your instructor first so that no two
students in the class analyse the same case.

Write roughly one page:

- The facts, in a short paragraph, with dates.
- Which Austrian sections would apply if the same conduct had taken place in Austria, with the elements
  mapped to the facts the same way as in Task 1.
- Which principles from the hacker ethics lecture were in play, and where the actor's own justification
  held up or did not.
- What the actor could have done differently to reach the same outcome legally.

Cite at least **two independent sources**, with URLs and access dates. Court decisions, CERT advisories,
vendor advisories and reporting from established outlets count. A single blog post repeating a rumour does
not.

### 4. The disclosure notification

Assume you found a vulnerability in a product while testing it inside your own lab: the web interface of a
device you own exposes stored credentials to any unauthenticated visitor on the local network. Write the
notification you would actually send:

- A disclosure email to the vendor: what you found, how to reproduce it, what the impact is in plain
  language, what you did **not** do (no access to third-party systems, no data taken, no persistence left
  behind), and your proposed publication date.
- A timeline with concrete day offsets from day 0 to publication, following the process in the ethics
  lecture.
- One paragraph on what you do if the vendor does not answer within your window: which escalation path you
  take, who you involve, and what you weigh against what before you consider publishing without the vendor.

Write it as a document that could be sent, not as a description of a document that could be sent.

### 5. Authorization document for your own lab

Write the rules of engagement for your own practice environment, one page, which you will reuse in the
practical modules of this course. It has to contain:

- The targets, named exactly: VM name, hostname, IP or IP range, and how you can tell your lab network from
  your home network.
- Which activities are permitted inside that scope.
- What is explicitly excluded, including your own router and any other device in your household that other
  people depend on.
- How you handle data that appears during testing, including anything that is not yours.
- A statement of who authorized this and on which date, signed by you.

Then add two to four sentences: which section of the StGB each boundary in your document is there to keep
you on the right side of.

## Evaluation Criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Scenario assessment** | 30% | All seven scenarios with the correct section or a defensible "no offence", the fulfilled element argued from the facts rather than copied from the lecture, intent classified and justified, penalty range and authorization requirement correct. |
| **Arguable scenario** | 5% | The genuinely arguable scenario is identified and both readings are argued, not just asserted. |
| **Austria against Germany** | 10% | Two scenarios assessed under §202a to §202c with one concrete, correctly named difference in outcome each. |
| **Real case** | 25% | A case that actually fits, facts stated accurately with dates, Austrian sections mapped element by element, ethics principles applied to the actor's own justification, a realistic legal alternative, and two independent sources that check out. |
| **Disclosure notification** | 20% | A sendable email with reproduction steps, a plain impact statement, an explicit statement of restraint, a dated timeline, and an escalation paragraph that weighs the trade-off instead of just picking a side. |
| **Lab authorization** | 10% | Scope named precisely enough to be checkable, exclusions that include shared household devices, a data-handling rule, a signature with a date, and each boundary tied to the right section. |
| **Bonus** | +20% | See below. |

Invented facts, a case that does not exist, or a source that does not say what you claim it says costs the
full **Real case** block. Check your citations before you submit; this is the habit the rest of the course
depends on.

## Bonus: Argue the other side

Pick the scenario from Task 1 that you found hardest and write both sides of it, about half a page each.

- **For the prosecution:** which elements are fulfilled, on which facts, and why the conduct falls squarely
  within the section.
- **For the defence:** which element is not proven, which alternative reading of the facts supports that, and
  which milder section would be the fallback.

Then one short paragraph with your own conclusion and the single fact that, if it were established either
way, would decide the case.

Graded on whether the weaker side is argued seriously. A defence section that concedes in the first sentence
earns nothing here.
