# Assignment: Anatomy of a Darknet Takedown

## Objective

Lecture 4 argued that darknet operators are rarely caught because Tor breaks. In this assignment you test that claim on one real case. You will reconstruct how investigators identified the people behind a darknet platform, separate technical attacks from OPSEC failures, and judge what would have prevented them.

## Logistics

- **Work:** individual.
- **Deadline:** _set by your instructor_.
- **Submission:** one PDF, named `Lastname_Firstname_Module23_Assignment1.pdf`.
- **Length:** 6-10 pages excluding the bibliography.

**All research for this assignment uses normal, public sources:** court documents, indictments, police and Europol press releases, the Tor Project blog, academic papers, books and quality journalism. Do not visit darknet marketplaces, forums or leak sites, and do not search for or download leaked data. A report that cites darknet sites as sources will not be graded.

## Instructions

### 1. Choose a Case

Pick one of the following, or propose another to your instructor:

- Silk Road (2013)
- Silk Road 2.0 (2014)
- AlphaBay (2017)
- Hansa / Operation Bayonet (2017)
- Wall Street Market (2019)
- Welcome to Video (2019)
- DarkMarket (2021)
- Hydra Market (2022)
- Genesis Market (2023)

If you cannot find at least three independent, credible sources that explain _how_ the operators were identified, choose another case.

### 2. Reconstruct the Investigation

- Give a short overview of the platform: what it offered, its size, how long it ran, which technology it used (Tor, I2P, clearnet mirror, which cryptocurrency).
- Build a **timeline** of the investigation from the first lead to the arrests and seizure.
- For every step, state what investigators learned and from which source you know it. Mark clearly where sources disagree or where the official account was disputed (as in the Silk Road server case).

### 3. Classify the Failures

Create a table of every weakness that contributed to the takedown, sorted into these categories:

| Category | Examples |
| --- | --- |
| Attack on Tor / the anonymity network | Traffic correlation, malicious relays |
| Attack on the client or browser | NIT, exploit |
| Server or application weakness | Misconfiguration, IP leak, web vulnerability |
| Financial trail | Blockchain analysis, exchange records |
| OPSEC failure | Reused identity, metadata, unlocked device |
| Insider, informant or platform takeover | |

Then answer: **Does your case support or contradict the claim from Lecture 4 that Tor itself is rarely what fails?** Justify your answer with your table.

### 4. Counterfactual Analysis

For the two most important failures, explain what the operators could have done differently, and whether that would realistically have changed the outcome or only delayed it. Consider what the investigators would likely have tried next.

### 5. Reflection

Write half a page on the ethics of the investigation methods used in your case. Examples: police running a market (Hansa) or an abuse site (Playpen), mass hacking of visitors' computers with a NIT, or universities handing research data to law enforcement (CMU). Where would you draw the line, and why?

## Evaluation Criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Research** | 30% | Timeline built from at least three credible, cited sources. Primary sources (court documents, indictments, official press releases) count for more than news summaries. Disputed points are marked. |
| **Classification** | 25% | Every failure is in the right category, and the conclusion about Tor follows from the table. |
| **Counterfactual analysis** | 20% | Realistic, specific alternatives that account for how investigators would have adapted. |
| **Reflection** | 10% | A clear, reasoned position that considers both sides. |
| **Report quality** | 15% | Clear structure, readable prose, correct citations, professional formatting. |
| **Bonus** | +15% | See below. |

## Bonus: Comparing Two Cases

Choose a second case from the list and add a section titled **"Bonus: Comparison"**. Compare the two failure tables. Which failures recur across cases, and what does that tell you about where anonymity usually breaks? Did operators learn from earlier takedowns, and did investigators change their methods?
