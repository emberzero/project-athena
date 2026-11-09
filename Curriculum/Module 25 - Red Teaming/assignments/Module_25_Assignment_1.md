# Assignment: Red Team Engagement Plan for an Austrian Logistics Company

## Objective

In this assignment you act as the control team lead of a fictional Austrian logistics company that has decided to commission its first red team engagement. You do not attack anything. Your task is to write the engagement plan that management will sign and that a red team provider would work from: scope, rules of engagement, threat-based scenarios mapped to MITRE ATT&CK tactics, success criteria and a plan for reporting and closure. The goal is to practise the governance side of red teaming from Lectures 1 to 5: deciding what a test should prove, keeping it lawful and safe, and making sure the results lead to improvement.

## Logistics

- **Work:** individual.
- **Deadline:** _set by your instructor_.
- **Submission:** one PDF, named `Lastname_Firstname_Module25_Assignment1.pdf`.
- **Length:** 8-12 pages, excluding the cover page; templates and tables may go in an appendix.

### Ground rules

- **This is a planning exercise only.** Do not scan, probe, test or contact any real system, company or person. Do not carry out any reconnaissance, including passive OSINT, against real organisations, even ones with a similar name or business.
- **The company is fictional.** Any resemblance to a real company is unintended. Everything you need is in the description below.
- **Stay at the planning level.** Describe scenarios with ATT&CK tactics and in plain language. Do not include technique IDs, tool names, commands, exploit code or payloads. A plan that contains them loses marks, because it is not what a control team needs.
- Where the description leaves something open, make a reasonable assumption and state it explicitly.

## The Company: Hollerberg Logistik GmbH

- **Business:** contract logistics and road freight for retail and pharmaceutical wholesale customers. Warehousing, order picking, and transport to around 1,200 delivery points in Austria and southern Germany.
- **Locations:** head office and main warehouse near Wels (Upper Austria), a second warehouse near Graz, and a small transport office in Passau (Germany).
- **Size:** about 650 employees, of whom about 80 work in offices; annual turnover about 140 million euros.
- **Regulatory status:** Hollerberg considers itself an important entity under NIS2 in the transport sector. It is **not** a financial entity, so DORA does not apply, and nothing requires it to carry out a red team test. Management has decided to do one voluntarily and wants it structured along the lines of TIBER-EU so that customers and auditors recognise the method.
- **IT and operations:**
  - Warehouse management system (WMS) in the head office data centre; it controls stock, picking and the automated small-parts warehouse in Wels.
  - Transport management system (TMS) provided as software-as-a-service by an external provider; it plans routes and sends orders to drivers' tablets.
  - Microsoft 365 for email and documents, Active Directory on premises, around 450 user accounts.
  - Customer portal where retail and pharma customers place orders and track shipments; developed in-house and hosted in the head office.
  - Temperature monitoring for pharmaceutical goods in both warehouses, with sensors and an alarm system run by a specialised supplier.
  - Payroll and accounting are outsourced to a tax consultancy, which has remote access to a file share.
- **Security organisation:** a CISO (part-time, also responsible for data protection coordination), an IT team of 14, and a managed security operations centre (SOC) contracted 18 months ago from an external provider, which monitors the Microsoft 365 tenant, the domain controllers and the firewalls around the clock. The SOC has never been tested.
- **History:** last year a competitor in the region was hit by ransomware and could not deliver for nine days. In the same year, Hollerberg's accounting department received a fake email from a "customer" asking to change the bank account for future payments; it was noticed by chance.
- **Management's question:** "We pay for a SOC. If a ransomware group or a fraudster came after us, would anyone notice before it was too late, and could we stop them?"

## Instructions

### 1. Purpose and test type

- State in a few sentences what the engagement should prove, in terms management will understand.
- Explain why a red team engagement fits management's question better than a vulnerability scan or a penetration test, and name one thing it will _not_ tell Hollerberg. Refer to Lecture 1.
- Explain how you will use the TIBER-EU structure even though Hollerberg is not subject to TLPT, and which elements you would simplify for a company of this size. Refer to Lecture 2.

### 2. Organisation of the engagement

- Define the control team: which roles (not names) are members, who leads it, and why it is kept small. Explain who in management must approve the engagement and be informed.
- Describe the other parties: red team provider, threat intelligence (external provider or a simplified internal analysis; justify your choice), blue team. Explain how you treat the managed SOC provider: is it informed, and who at the provider must agree to the test?
- List at least **four** selection criteria you would use when choosing the red team provider.

### 3. Scope

- Define the critical functions in scope and at least **two** flags. Each flag describes a business outcome and how it is proven without harm.
- Write an explicit out-of-scope list of at least **five** systems, locations, people or activities, each with a reason. Consider in particular the SaaS TMS, the temperature monitoring, the tax consultancy, the German site and denial of service.
- State which third parties must give written consent before their systems or services could be included, and what you do if they refuse.
- Set the time window, including periods you exclude, and justify its length.

### 4. Legal basis and rules of engagement

- Describe the authorisation: who signs it, what it must contain, and what the authorisation letter for testers in the warehouses says. Refer to the relevant provisions of the StGB from Module 01 and explain why the authorisation is necessary.
- Address social engineering: is it in scope, what limits apply, how personal data is handled under the GDPR, and whether the works council has to be involved (state this as a question for the legal department if you are unsure).
- Write the rules of engagement, covering at least: communication channels and frequency, identity confirmation, emergency contacts (as a table of roles), at least **five** stop conditions, leg-ups, data handling and deletion, and clean-up at the end.
- Describe the deconfliction procedure step by step, including what happens if the SOC or the IT team wants to report the incident to CERT.at, the police or a customer.

### 5. Risk management for the test

- Identify at least **five** risks that the engagement itself creates for Hollerberg (for example disruption of the WMS during peak season, a real incident at the same time, leaked test data).
- For each, give a measure that prevents or limits it and who is responsible.

### 6. Threat-based scenarios

- Based on the case description and on public, general sources such as the ENISA Threat Landscape (not on research about real companies), describe the threat actors that are realistic for Hollerberg and their motivation.
- Write at least **two** scenarios using the structure from Lecture 4: threat actor, motivation, starting point (full scenario or assumed breach, with justification), flag, expected path, relevance.
- For each scenario, map the expected path to **MITRE ATT&CK Enterprise tactics** (tactic names only, no techniques). State the ATT&CK version you used. Present the mapping as a table with one row per tactic, a one-sentence description of the attacker's goal in that step, and which system or team would be expected to notice it.

### 7. Success criteria

- Define how you will judge the engagement. Include criteria for the attack side (flags reached, time needed) and for the defence side (detection and response per tactic, time to detect, time to respond, escalation within the SOC contract).
- Use the detection outcome scale from Lecture 4 or a justified variant of it.
- Explain why "the red team did not reach the flag" is not automatically a good result, and "the red team was caught" is not automatically a failed test.

### 8. Closure and reporting plan

- Describe how and when the blue team (internal IT and the SOC provider) is informed, and how you avoid blaming individuals.
- Plan the replay and a purple teaming session: who takes part, which topics you expect to cover, and how long after the active test it happens.
- Describe the reports: what the executive summary for management contains, what the technical report contains, who receives which, and how they are classified.
- Describe how remediation is tracked: format of the remediation plan, owners, deadlines, verification, and how progress is reported to management.

## Submission Guidelines

1. **Report:**
   - Submit your plan as a single PDF document.
   - Include your name, date and the title of the assignment on the cover page.
   - Write it as a document that Hollerberg's management could actually sign: clear headings, tables where they help, no filler.
1. **Sources:**
   - Cite any sources you use, such as the lectures, the TIBER-EU guidance documents, the ENISA Threat Landscape or MITRE ATT&CK.

## Evaluation Criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Purpose and test type** | 10% | Clear purpose in business terms; sound reasoning for a red team over other test types; sensible adaptation of TIBER-EU to a non-financial company. |
| **Organisation** | 10% | Small, senior control team with a clear lead; SOC provider and third parties handled realistically; useful provider selection criteria. |
| **Scope** | 15% | Flags are business outcomes with safe proof; exclusions are complete and justified; third-party consent is addressed. |
| **Legal basis and rules of engagement** | 20% | Authorisation is correct and specific; social engineering limits and GDPR are addressed; RoE are complete and usable at 02:00; deconfliction covers external reporting. |
| **Risk management for the test** | 10% | Realistic risks created by the test itself, with concrete measures and owners. |
| **Scenarios and ATT&CK mapping** | 15% | Scenarios are realistic for Hollerberg and grounded in the case; starting points are justified; mapping uses correct tactic names, states the version, and contains no techniques or tools. |
| **Success criteria** | 10% | Measurable criteria for attack and defence; correct interpretation of reaching or not reaching flags. |
| **Closure and reporting** | 10% | Respectful blue team debrief; replay and purple teaming planned; reports fit their audiences; remediation is tracked and verified. |
| **Bonus** | +10% | See below. |

## Bonus Points: Briefing the Management Board

### Objective

Earn bonus points by preparing the decision for Hollerberg's managing directors.

### Instructions

1. Write a one-page briefing that asks management to approve the engagement. It must explain in plain language what will happen, why, what it costs in time and stress for the organisation (no exact prices needed), what the main risks are and how they are controlled, and what management will receive at the end.
1. Add a short list of the three decisions management must take before the test can start.
1. Add this as a separate section titled "Bonus: Management Briefing".

### Evaluation Criteria for Bonus Points

- The briefing is understandable without any technical background.
- It is honest about risks and limits and consistent with the rest of your plan.
