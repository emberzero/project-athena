# Purple Teaming, Reporting and Closure

The covert part of a red team engagement ends on an agreed date or when the flags are reached. For the organisation, the useful part only starts then. Everything the red team did, and everything the blue team saw or missed, has to be turned into knowledge that improves the defence. An engagement that ends with a report in a drawer has cost a lot of money and stress and produced little.

This lecture covers the closure phase: how the blue team is informed, how red and blue team replay the attack and work together as a purple team, how findings and detection gaps are reported to different audiences, and how remediation is tracked until it is finished. Module 03, Lecture 5 covers report writing for penetration tests; the principles carry over, but a red team report has some specific features.

## Ending the Covert Test

When the active test ends, the control team informs the blue team. How this is done matters. People who spent nights on an "incident" that turns out to be a test can feel deceived. A good debrief:

- thanks the blue team and recognises what it did well, especially if it detected the red team;
- explains why the test had to be secret;
- makes clear that the goal is to improve the organisation's defence, not to judge individuals;
- invites the blue team to write its own report and to take part in the replay as an equal partner.

At the same time, the red team removes everything it left behind (accounts, files, devices, configuration changes) according to the list it kept during the test, and the control team checks that the clean-up is complete. Credentials the red team obtained are reset.

## Two Reports, Two Perspectives

TIBER-EU and the DORA standards require two reports from the closure phase:

- The **red team test report** describes the test from the attacker's side: the scenarios, the steps taken, which flags were reached, where leg-ups were used, and the weaknesses that made progress possible. Under the DORA standards the testers deliver it to the control team within four weeks after the end of the active test.
- The **blue team test report** describes the same period from the defender's side: what was detected, when, how it was handled, and where the response stopped. The blue team writes it after reading the red team report, at the latest ten weeks after the end of the active test.

Putting the two side by side gives the complete picture: a timeline of the attack with the defender's view of each step.

## Replay and Purple Teaming

In the **replay**, red and blue team go through the attack together, step by step. The red team shows what it did and when; the blue team checks its logs, alerts and tickets for the same time. For each step the question is: was it visible, did it raise an alert, did someone act on it, and if not, why not?

**Purple teaming** goes one step further. Red and blue team work together on selected topics, usually the steps the blue team missed. The red team repeats an action in a controlled way; the blue team checks whether it is now visible, improves or writes a detection, and the red team repeats the action to confirm that the detection works. This cycle of *execute, observe, improve, verify* is repeated until both sides are satisfied or the limits of the current tools are clear.

Under the DORA standards, replay and purple teaming are mandatory parts of the closure phase and take place within ten weeks after the end of the active test. The ECB publishes separate purple teaming guidance for TIBER-EU tests.

Purple teaming is also used outside formal red team engagements, as a regular exercise in which an internal team tests specific detections. It is cheaper and faster than a red team engagement and very effective at improving detection, but it does not replace a covert test: only a test the blue team does not know about shows how it reacts to a surprise.

## Findings and Detection Gaps

A red team report contains two kinds of results, and they lead to different actions.

| | Finding | Detection gap |
| --- | --- | --- |
| **What it is** | A weakness that let the attacker make progress | A step that the defence did not notice or did not act on |
| **Example** | Service desk resets passwords after a phone call without verifying the caller | Login from an unusual location was logged but raised no alert |
| **Who fixes it** | System or process owner | Security operations (detection engineering, SOC processes) |
| **Typical fix** | Change a configuration, process or control | New log source, new detection rule, changed alert handling, training |

Both are needed. Fixing only findings leaves the organisation blind to the next attacker who finds a different way in. Fixing only detection gaps means detecting attacks that should have been prevented. Some results are both: a missing control that also produced no alert.

Each result is rated. For findings, the usual risk rating applies (Module 03, Lecture 5, and Module 26, Lecture 3). For detection gaps, the rating considers where in the attack the gap occurred: a gap early in the attack, when the attacker is still easy to stop, is often more valuable to close than one at the end.

Results also distinguish between *systemic* issues (a process that does not exist, a missing log source across the whole environment) and *individual* issues (one misconfigured server). Systemic issues are fewer but matter more.

## The Executive Report and the Technical Report

The readers of a red team report want very different things. Most reports are therefore split.

### Executive summary

Written for the management body and senior managers, who decide about budget and priorities. It is short, usually two to four pages, and contains:

- the purpose of the test and the scenarios in one paragraph each;
- the overall result: which flags were reached, how long it took, whether and when the attack was detected;
- the three to five most important systemic issues, in business terms;
- the main recommendations with a rough indication of effort;
- a comparison with previous tests, if there were any.

It avoids technical detail and does not name individuals. "An attacker could have approved payments without being noticed for six weeks" is the kind of sentence management needs to read.

### Technical report

Written for the control team, the blue team and the system owners who will fix the issues. It contains the full attack timeline, each step with its ATT&CK tactic, the corresponding blue team observations, every finding and detection gap with evidence and rating, every leg-up with its reason, and detailed recommendations. It is classified and distributed only to those who need it, because it describes how to attack the organisation.

Under DORA, the financial entity also submits a **summary report** of the relevant findings to the TLPT authority, which then issues the attestation.

## Remediation Tracking

The **remediation plan** lists for each finding and detection gap:

- the measure that will address it;
- an owner who is accountable for it;
- a deadline that matches the rating;
- the status, and how completion will be verified.

Common problems are measures that are agreed and then forgotten, deadlines that are extended again and again, and "fixed" findings that nobody checked. Good practice:

- Enter all measures into the same system that tracks other security risks and tasks, for example the risk register or the ticket system, so they do not depend on one report.
- Report progress regularly to management, as part of the normal security reporting (Module 26, Lecture 1).
- **Verify fixes.** A detection gap is closed when a repeated test, often in a purple teaming session, shows the detection fires and the response works. A finding is closed when it is retested.
- Accept risks explicitly where a fix is not possible or not worth the cost, with the signature of the risk owner and a review date.
- Use the results to plan the next test: the next engagement should check whether the main issues are really fixed and look at areas this one did not cover.

## Feedback on the Engagement

Both frameworks also require feedback on the process itself: the control team, blue team, red team and threat intelligence provider tell each other what worked and what did not. Questions include whether the scope was right, whether the threat intelligence was useful, whether communication and deconfliction worked, and whether the test caused avoidable stress or risk. This feedback improves the next engagement and the way the organisation buys such tests.

## Conclusion

The closure phase turns a covert test into improvement. The blue team is informed respectfully and writes its own report alongside the red team's. In the replay, both sides go through the attack step by step, and in purple teaming they work together to close the detection gaps they found, a step that DORA makes mandatory. Results are split into findings, which need preventive fixes, and detection gaps, which need better monitoring and response. An executive summary tells management what matters in business terms; a technical report gives the details to those who fix them. A remediation plan with owners, deadlines and verified fixes makes sure that the engagement has a lasting effect.

## Resources

- Module 03, Lecture 5, for report writing
- Module 13, Lecture 4, for incident response
- **TIBER-EU Purple Teaming Guidance and report guidance**: <https://www.ecb.europa.eu/paym/cyber-resilience/tiber-eu/html/index.en.html>
- **MITRE ATT&CK**: <https://attack.mitre.org/>
