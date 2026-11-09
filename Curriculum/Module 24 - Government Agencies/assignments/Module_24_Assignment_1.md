# Assignment: Ransomware at a Hospital Operator - Who Do You Call?

## Objective

A ransomware attack is a technical problem for the first few hours and a legal and organisational problem for months afterwards. In this assignment you play the information security officer of a fictional Austrian hospital operator on the morning of an attack. You decide which agencies to contact and why, build the NIS2 reporting timeline, draft the first two reports, decide on a criminal complaint, and think through what changes if a state turns out to be behind the attack. There is no hands-on technical work. The assignment covers all four lectures of this module.

## Logistics

- **Work:** individual.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF named `Lastname_Firstname_Module24_Assignment1.pdf`.
- **Length:** 6-10 pages excluding the bibliography and the two report drafts in the appendix.

### Check the current law

The NIS2 Directive (Directive (EU) 2022/2555) sets the framework, but it applies through national law. Austria's implementation was still changing when this module was written (Lecture 2). Before you write, look up the current status of the Austrian NIS law: which law is in force, which authority receives reports, and whether there is a national reporting form or portal. Name the law and the date you checked it in your introduction. Where the current Austrian rules differ from what the lecture describes, follow the current rules and say so. Do not invent paragraphs, deadlines or authorities; if you cannot confirm a detail, write that it is unconfirmed.

## Scenario

**Klinikverbund Alpenvorland** (KVA) is a fictional public hospital operator in Upper Austria. It runs three hospitals with about 2,400 employees and 900 beds. One of the hospitals is 15 km from the German border, and its emergency department regularly receives patients from Bavaria. Under NIS2, KVA is an essential entity in the health sector. You are KVA's information security officer and the person named in the incident response plan as responsible for reporting.

The timeline below uses *Day 0* for the day of the attack.

| Time | Event |
| --- | --- |
| Day -9 | An employee in the purchasing department opens an invoice attachment. Nobody notices anything. |
| Day 0, 02:40 | The endpoint detection system raises an alert about unusual remote administration activity on two servers. The night operator acknowledges it and plans to look at it in the morning. |
| Day 0, 04:15 | The laboratory information system and the radiology image archive (PACS) stop responding. |
| Day 0, 05:50 | The IT on-call engineer finds encrypted files and a ransom note on several servers. The note claims that 400 GB of patient and staff data have been copied, and demands payment in cryptocurrency within five days, otherwise the data will be published. |
| Day 0, 06:30 | The crisis team meets. You are present. IT disconnects the hospital network from the internet. |
| Day 0, 08:00 | The hospital near the border stops accepting ambulances for emergency patients. Ambulances are redirected, some to a hospital in Bavaria. Planned operations at all three hospitals are postponed. |
| Day 1, 11:00 | The group behind the attack lists KVA on its leak site and publishes a sample of 50 scanned patient documents. |
| Day 1, 15:00 | A journalist from a regional newspaper calls the press office. |
| Day 4 | The external forensics provider reports that the attackers used tools and infrastructure that overlap with a group publicly attributed by several governments to a foreign military intelligence service. The provider adds that the encryption on some servers cannot be reversed even with the attackers' key: the data was overwritten, not encrypted. |

## Tasks

### 1. Agency map

Identify every authority and organisation KVA should contact in the first week. For each one, state in a table:

- the name of the body and which of the three pillars from Lecture 1 it belongs to (cyber defence and CERTs, intelligence, law enforcement), or that it belongs to none of them
- the level: national, European or international
- why KVA contacts it, and whether this is a legal obligation or a choice
- when KVA contacts it, relative to the scenario timeline
- what KVA tells it and what KVA can expect in return

Cover at least the competent NIS authority or CSIRT under the current Austrian law, CERT.at, the police, and any body that becomes relevant because patients were redirected to Germany. Include bodies that KVA does *not* contact directly but that will probably become involved, such as Europol, and explain how they get involved. Data protection obligations exist alongside NIS2 because patient data were stolen; mention which body receives that report, but you do not need to analyse data protection law in detail.

### 2. NIS2 reporting timeline

1. Decide whether this is a *significant incident* in the sense of NIS2 and justify your answer with the criteria from Lecture 2.
2. Decide at which moment KVA *became aware* of the incident: the 02:40 alert, the 05:50 ransom note, or another point. Your choice moves every deadline, so justify it and discuss what a supervisory authority might argue.
3. Draw the reporting timeline from that moment: early warning (24 hours), incident notification (72 hours) and final report (one month after the notification). Mark the actual date and time of each deadline in Day/hour notation, and show where intermediate reports might be requested.
4. Name who inside KVA writes, approves and sends each report. Remember that NIS2 makes the management body accountable.

### 3. Draft the early warning and the incident notification

Write both reports as KVA would send them, as an appendix to your PDF. Each fits on one page. Use the national reporting form if one exists; otherwise structure the report yourself using the content NIS2 requires.

- **Early warning:** what is known at that point, whether a malicious act is suspected, and whether there may be cross-border impact. Think about what KVA actually knew at the time it had to send this report. Do not put information in it that only appears later in the timeline.
- **Incident notification:** an update of the early warning with an initial assessment of severity and impact, and indicators of compromise where available. Invent plausible but clearly fictional indicators (for example, documentation IP ranges such as `192.0.2.0/24`) rather than real ones.

Below each draft, add a short paragraph explaining what you left out and why.

### 4. Criminal complaint

Decide whether KVA files a criminal complaint, when, and with whom. Justify your decision. Address:

- who leads the investigation in Austria and which police unit KVA contacts first
- how the complaint relates to the NIS2 reports: different recipients, purposes and deadlines
- what evidence KVA must preserve, and how the crisis team's decision at 06:30 to disconnect the network affects that
- whether reporting to the police makes the incident public, and how that interacts with the journalist's call on Day 1
- the police's position on paying the ransom, and why the answer may change after Day 4

### 5. The state-actor angle

The forensic findings on Day 4 suggest that this may not be ordinary crime. Discuss what changes:

- How reliable is attribution based on overlapping tools and infrastructure? What would it take for a government to attribute the attack officially?
- What does it mean that the data were overwritten rather than encrypted? Compare with a case from Lecture 3.
- Which agencies now become interested in the case, through which channels does KVA learn anything from them, and what will it probably never learn?
- What does the finding mean for a ransom payment, given the EU's cyber sanctions framework?
- How should KVA's threat model change for the rebuild?

### 6. Reflection: three separate pillars

In about one page, reflect on the separation of the three pillars from the point of view of KVA. Use your scenario: KVA reported to a CERT or NIS authority, to the police, and may have ended up in an intelligence matter. Would KVA have reported as openly to the CSIRT if it knew that every report went automatically to the police or to an intelligence service? What does the German *Trennungsgebot* protect against, and what does Austria's model of a domestic intelligence service inside the police structure mean for a victim like KVA? Take a position and argue for it.

## Report

Structure your report as follows:

1. Introduction, including the Austrian NIS law you checked and the date
2. One section for each of tasks 1, 2, 4, 5 and 6
3. Conclusion: the three things KVA's incident response plan must contain before the next incident, based on what you found
4. Bibliography
5. Appendix: the two report drafts from task 3

Cite the lectures and every external source you use. Prefer primary sources: the NIS2 Directive on EUR-Lex, the Austrian law in the Rechtsinformationssystem (RIS), and the websites of the authorities themselves.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Agency map** | 20% | All relevant bodies identified with correct pillar and level; obligations clearly separated from choices; the path to European and international bodies explained. |
| **NIS2 timeline** | 20% | Significance and the moment of awareness argued from the criteria; deadlines correct for the chosen moment; responsibilities inside KVA named. |
| **Report drafts** | 15% | Both drafts contain what NIS2 requires, contain only what KVA knew at that time, and are short enough to send under pressure. |
| **Criminal complaint** | 15% | A justified decision; correct roles of prosecutor and police; evidence preservation and the ransom question handled with reference to the scenario. |
| **State-actor angle** | 15% | Realistic view of attribution; correct use of examples from Lecture 3; concrete consequences for KVA. |
| **Reflection** | 5% | A clear position on the separation of the pillars, argued from the scenario. |
| **Report quality** | 10% | Clear structure, current law checked and dated, correct citations, no invented legal details. |
| **Bonus** | +15% | See below. |

## Bonus: the same attack in Germany

Assume KVA were a hospital operator in Bavaria instead of Upper Austria, with the Austrian hospital receiving the redirected patients. Write a section of about two pages titled "Bonus: The Same Attack in Germany" that redoes the agency map and the reporting path for this case. Use the German bodies from Lectures 2 and 4 (BSI, the Zentrale Ansprechstelle Cybercrime of the Bavarian state police, the relevant prosecutor's office) and check the current status of the German NIS2 implementation in the same way as for Austria. Point out the differences that would matter to the information security officer on Day 0.
