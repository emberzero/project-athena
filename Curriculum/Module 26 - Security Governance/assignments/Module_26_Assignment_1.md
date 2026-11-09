# Assignment: Risk Assessment and Policy Set for an Austrian SME

## Objective

In this assignment you act as the newly appointed information security officer of a small Austrian company. You identify its most important assets, assess the risks to them, decide how to treat each risk, map your measures to the themes of ISO/IEC 27001:2022 Annex A, and write one policy that staff will actually read. The goal is to practise the core of security governance from Lectures 1, 2, 3 and 5: turning a messy real-world situation into documented, defensible decisions.

## Logistics

- **Work:** individual.
- **Deadline:** _set by your instructor_.
- **Submission:** one PDF, named `Lastname_Firstname_Module26_Assignment1.pdf`.
- **Length:** 8-12 pages, excluding the cover page; the risk register may go in an appendix.

The company below is fictional. Where the description leaves something open, make a reasonable assumption and state it explicitly. Assumptions are part of every real risk assessment; hidden assumptions are a weakness, stated ones are not.

## The Company: Alpentech Präzision GmbH

- **Business:** manufactures precision metal parts for machine builders and for a supplier to the automotive industry. Founded 1998, family-owned.
- **Location:** one site near Linz, with an office building and a production hall.
- **Size:** annual turnover about 8 million euros.
- **Staff:** 45 employees: 30 in production, 8 in office roles (sales, purchasing, accounting, HR), 4 in design and engineering, 2 managing directors, 1 IT administrator.
- **IT:**
  - About 25 Windows PCs and laptops, Microsoft 365 for email and files.
  - One on-premises Windows server running Active Directory, the file server and the ERP system with customer orders, prices and payroll data.
  - CAD workstations in engineering; customer drawings arrive by email and through a customer portal.
  - Five CNC machines in the production hall, connected to the office network so that engineering can send programs to them. Two run an operating system that is no longer supported.
  - Backups: a nightly copy to a NAS in the same server room.
  - Remote access: the managing directors and the IT administrator use a VPN with username and password.
- **Customers:** one of the main customers is a large Austrian machine builder that falls under NIS2. It has announced that it will send all suppliers a security questionnaire next year and expects "appropriate measures in line with ISO 27001".
- **History:** last year an employee in accounting almost paid a fake invoice after an email that appeared to come from a known supplier. The IT administrator is the only person who knows the server passwords.

## Instructions

### 1. Context and scope

- Describe the scope of your assessment and the most important internal and external factors (for example the NIS2 customer, the GDPR, dependence on one IT administrator).
- Explain briefly whether Alpentech is itself covered by NIS2 and why its customer's obligations still affect it. Refer to Module 24, Lecture 2 and Lecture 4 of this module; state any assumptions about the national implementation.
- Name who should own the security programme and who should be risk owners. Does Alpentech need a data protection officer under Austrian law? Justify your answer with Article 37 GDPR.

### 2. Assets

- List at least **eight** assets, including information, systems, people and at least one physical or production asset.
- For each, give the owner and rate its importance for confidentiality, integrity and availability (low, medium, high) with a one-line justification.

### 3. Likelihood and impact scales

- Define a three- or five-level scale for likelihood and for impact, with written definitions that fit a company of this size (see Lecture 3). Use concrete thresholds, for example downtime in days or cost in euros.
- Define your risk matrix and a risk appetite: which risk levels are accepted, which need a treatment plan, which must go to the managing directors.

### 4. Risk register

- Identify at least **ten** risks. Each risk names the asset, the threat and the vulnerability.
- Cover at least three different kinds of threat, for example cybercrime, insider error, technical failure, physical events and supplier problems.
- Rate likelihood and impact for each risk using your scales, and calculate the risk level.
- Present the result as a risk register table with at least these columns: ID, asset, threat / vulnerability, likelihood, impact, risk level, treatment option, measures, owner, residual risk.

### 5. Risk treatment

- For each risk, choose a treatment option (mitigate, transfer, avoid, accept) and justify it. Use each of the four options at least once across the register.
- For every accepted risk, state who accepts it and when it will be reviewed.
- Prioritise the measures: which five would you implement in the first six months, and why? Give a rough effort or cost estimate for each (low, medium, high is enough).

### 6. Mapping to ISO/IEC 27001:2022 Annex A

- Map each measure from step 5 to the Annex A theme it belongs to (organizational A.5, people A.6, physical A.7, technological A.8).
- Where you can identify it, name the specific control (for example A.8.13 Information backup). You do not need access to the standard: the control titles are public and widely listed, and ISO/IEC 27002 is optional reading.
- Write a short Statement of Applicability excerpt for at least **six** controls, including at least one control you exclude, with a justification.

### 7. Policy

- Write **one** topic-specific policy for Alpentech, for example an acceptable use policy, a password and authentication policy, or a backup policy.
- Use the structure from Lecture 5: purpose, scope, rules, responsibilities, exceptions, consequences, owner, version and review date.
- Keep it to one or two pages and write it for the staff who must follow it, including production workers.
- Add a short note (a few sentences) on who must approve the policy and whether the works council has to be involved.

## Submission Guidelines

1. **Report:**
   - Submit your report as a single PDF document.
   - Include your name, date and the title of the assignment on the cover page.
   - Tables may be created in a spreadsheet and inserted as images or tables, but they must be readable in the PDF.
1. **Sources:**
   - Cite any sources you use, such as the lectures, BSI or ENISA publications, or the GDPR text.

## Evaluation Criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Context and scope** | 10% | Scope and assumptions are explicit; NIS2 and DPO questions are answered correctly with justification. |
| **Assets** | 10% | At least eight relevant assets of different kinds, with owners and plausible CIA ratings. |
| **Scales and risk appetite** | 10% | Scales have concrete, company-appropriate definitions; the risk appetite clearly says who decides what. |
| **Risk register** | 25% | At least ten distinct, realistic risks tied to the case description; ratings follow the defined scales consistently. |
| **Risk treatment** | 20% | All four options used with sound justification; accepted risks have an owner and review date; priorities are realistic for a 45-person company. |
| **Annex A mapping and SoA** | 10% | Measures are mapped to the correct themes; named controls are accurate; the SoA excerpt includes a justified exclusion. |
| **Policy** | 15% | Complete structure, clear mandatory language, realistic rules, readable for non-technical staff, approval and works council addressed. |
| **Bonus** | +10% | See below. |

## Bonus Points: Answering the Customer Questionnaire

### Objective

Earn bonus points by preparing Alpentech for the security questionnaire its NIS2-covered customer has announced.

### Instructions

1. Pick **five** topics a customer is likely to ask about under NIS2 Article 21, for example incident handling, backups, access control, supplier security and training.
1. For each, write the answer Alpentech could honestly give **today** and the answer it could give **after** your six-month plan, in two or three sentences each.
1. Add this as a separate section titled "Bonus: Customer Security Questionnaire".

### Evaluation Criteria for Bonus Points

- The answers are honest and consistent with your risk register and plan.
- The topics are tied to specific NIS2 Article 21 measures.
