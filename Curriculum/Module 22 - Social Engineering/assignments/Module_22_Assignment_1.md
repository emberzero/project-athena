# Assignment 1: Anatomy of a Social Engineering Attack

## Objective

You will take apart a documented social engineering incident stage by stage, classify ten
real messages that arrived in your own mailbox, and then write the prevention plan that
would have broken the chain. Afterwards you will be able to name which stage of an attack
you are looking at, which psychological principle is being used on you, and which single
control stops it.

## Logistics

- **Work:** individual.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module22_Assignment1.pdf`.
- **Length:** four pages maximum, excluding the screenshots in the appendix. This is a
  hard limit. Precision is being graded, not volume.

## Setup

No software, no lab and no money. You need:

- **A documented case.** Pick one publicly reported social engineering incident with enough
  published detail to reconstruct the stages. Useful sources are the ones from the
  lectures: [Krebs on Security](https://krebsonsecurity.com/), the
  [CISA](https://www.cisa.gov/) advisories, the [SANS Institute](https://www.sans.org/),
  and for Austrian cases [Watchlist Internet](https://www.watchlist-internet.at/). Your
  instructor keeps a sign-up list so that no two students analyse the same case; claim
  yours before you start.
- **Your own spam and phishing folder.** You will classify messages that were already sent
  to you. If your folder is thin, your instructor can supply a set of sanitised samples.
- **Your own notes from lectures 2, 3, 4 and 6.** Everything you need is taught in them.

## Rules of engagement

This assignment contains no practical attack, and that boundary is part of the grade.

- **You send nothing.** No email, no message, no call, to anybody, for any reason.
- **You contact nobody.** No real company, no employee, no help desk, no classmate, no
  school staff member, and no teacher is a target, a test subject, or a source of
  information for this assignment.
- **You do not click.** In the messages you classify, no link is opened and no attachment
  is opened. Read headers and text only.
- **The organisation in task 3 is fictional.** Invented name, invented staff, and
  `example.com` as its domain. Do not model it on a real company.
- Attempting any of the above for real is not a school exercise. Unauthorized access is an
  offence under StGB §118a, and data interference and damage under §126a and §126b. See
  Module 01.
- **Redact before you submit.** Your screenshots will contain your own address and possibly
  other people's names. Black them out.

## Tasks

### 1. Decompose your case into the six stages

Reconstruct your chosen incident using the stage model from lecture 3. Fill in one row per
stage:

| Stage | What the attacker did, in this case | Evidence in the source | Attack type (lecture 2) | Principle exploited (lecture 4) |
| ----- | ----------------------------------- | ---------------------- | ----------------------- | ------------------------------- |

Rules for full marks:

- Every row cites the published source for that claim, with a page or paragraph reference,
  not just a link at the end.
- Where the reporting does not say what happened at a stage, write *not reported* and say
  what you would need to know. Inventing a plausible stage is the failure mode this task
  is designed to catch.
- The attack type column uses the names from lecture 2 (phishing, pretexting, baiting,
  quid pro quo, impersonation, tailgating). Most real incidents combine several; name them
  all and say which carried the attack.

**Deliverable:** the completed table, plus one paragraph naming the stage at which the
attack was eventually noticed and what noticed it.

### 2. Classify ten messages from your own mailbox

Take ten distinct messages from your own spam or phishing folder. For each one:

| # | Date | Claimed sender | Real sender address or domain | Attack type | Dominant principle | The ask |
| - | ---- | -------------- | ----------------------------- | ----------- | ------------------ | ------- |

Then write three short paragraphs:

- **The ask.** Across your ten messages, what are they actually trying to get? Group them.
- **What still gives them away.** For each message, name the one indicator you would teach
  someone to look at, and say why that one and not another.
- **The outlier.** Pick the single most convincing message of the ten and explain, in four
  or five sentences, exactly why it is more convincing than the others.

**Deliverable:** the table, the three paragraphs, and redacted screenshots of all ten
messages in the appendix. Include at least the sender line and the subject in each
screenshot.

### 3. A prevention plan that breaks the chain

Invent a small organisation: a name, a domain at `example.com`, roughly twenty staff, and
one sentence on what it does. Then write its prevention plan using Hadnagy's four steps
from lecture 6.

For full marks the plan must contain:

- **One concrete control per attack stage** from task 1, stated as something a person does
  or is prevented from doing, with the step at which it intervenes. "Train the staff" is
  not a control; "the help desk resets no password without a call back to the number in the
  internal directory" is.
- **A written verification procedure** for unusual requests: who verifies, on which
  channel, and what happens when the requester is senior and in a hurry. A procedure with
  an exception for seniority is worth no marks, and the paragraph should say why.
- **One realistic check** you would run to find out whether the plan works, and the
  measurement you would take from it.
- **One rule you deliberately did not write**, with the reason. Not every risk is worth a
  policy, and saying so is part of the skill.

**Deliverable:** the plan, at most one and a half pages.

### 4. The stage your own plan would miss

One short section: take the attack from task 1 and run it against your own plan from task 3.
Name the stage where it would still get through, and what it would cost the organisation to
close that gap. An honest gap scores better than a claim that the plan is complete.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Stage decomposition** | 30% | All six stages covered with per-row source citations, correct attack types, and *not reported* used where the reporting is silent instead of being filled in by guesswork. |
| **Principle analysis** | 15% | The principle named at each stage is the one actually doing the work, and the choice is justified rather than asserted. |
| **Mailbox classification** | 25% | Ten distinct real messages, real sender domains extracted, the ask identified per message, and an indicator per message that does not depend on writing quality. |
| **Prevention plan** | 20% | One concrete control per stage with its intervention point, a verification procedure with no seniority exception, a check with a measurement, and a justified omission. |
| **Self-critique and report** | 10% | A specific stage where the plan still fails, with its cost, in a report within the page limit. |
| **Bonus** | +20% | See below. |

Copied text, a case already claimed by another student, or screenshots that are not from
your own mailbox score zero for the affected rows.

## Bonus: the awareness slide that is still true in five years

Most awareness material teaches detection by writing quality, which your task 2 analysis
may have shown to be a weak indicator.

1. Find a real, publicly available awareness page, leaflet or slide that teaches spotting
   bad grammar, generic greetings, or similar production defects. Cite it.
2. Rewrite one page of it so that every indicator it teaches is about the request, the
   channel, or the urgency, rather than the prose. Keep it to one page and keep it readable
   by a non-technical colleague.
3. Add two sentences on how you would measure whether your version works better than the
   original, using the reporting rate as well as the click rate.

Full bonus marks require your rewritten page to be usable as-is by the fictional
organisation from task 3, and every indicator on it to be one your own ten messages
confirm.
