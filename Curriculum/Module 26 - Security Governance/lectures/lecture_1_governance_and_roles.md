# Governance, Roles and the Security Organisation

A company can buy the best firewall on the market and still be breached through an unpatched server that nobody felt responsible for. Many large incidents are not caused by missing technology but by missing ownership: a risk that was known but never escalated, a patch that was nobody's job, a warning that never reached the people who could approve the budget. Security governance is the part of security that deals with these questions. It defines who decides, who is accountable and how the organisation knows whether its security works.

This lecture separates governance from management, introduces the roles in a typical security organisation, and shows how they fit together in Austrian and German companies.

## Governance versus Management

The two terms are often mixed up. The distinction comes from corporate governance in general and is described for information security in ISO/IEC 27014 (*Governance of information security*):

| | Governance | Management |
| --- | --- | --- |
| **Question** | Are we doing the right things? | Are we doing things right? |
| **Who** | Management body (board, Geschäftsführung, Vorstand), supervisory board | CISO, security team, IT operations |
| **Activities** | Set direction and risk appetite, approve strategy and budget, assign responsibility, oversee results | Plan and run the security programme, implement controls, measure, report upwards |
| **Output** | Security strategy, top-level policy, decisions on major risks | Procedures, controls, metrics, incident handling |

Governance sets the frame, management works inside it. A board that decides "we accept no risk that could stop production for more than one day" is doing governance. A team that designs backups and failover to meet that target is doing management.

The point that matters most: **accountability for security sits with top management and cannot be delegated**. Tasks can be delegated to a CISO; the responsibility stays with the management body. Regulation now says this explicitly. NIS2 Article 20 requires the management body of a covered entity to approve the cybersecurity risk-management measures, oversee their implementation and undergo training, and allows member states to hold managers personally liable (see Module 24, Lecture 2). DORA contains similar rules for the financial sector (Lecture 4).

## The Roles

Names and exact duties vary between organisations. The following roles appear in most medium-sized and large companies.

### Management body

In an Austrian or German GmbH this is the *Geschäftsführung*, in an AG the *Vorstand*, overseen by the *Aufsichtsrat* (supervisory board). It decides on the security strategy, the risk appetite and the budget, and it signs the top-level information security policy. In a small company the managing director may be the only person in this role.

### Chief Information Security Officer (CISO)

The CISO leads the security programme. Typical responsibilities:

- Develop the security strategy and propose it to the management body
- Run the ISMS (Lecture 2) and the risk-management process (Lecture 3)
- Report the security situation, major risks and incidents to management
- Lead or coordinate the security team, incident response and awareness
- Act as the contact point for auditors and authorities

A CISO is a management role. In large organisations the CISO rarely configures systems personally; the job is to make sure risks are known, owned and treated.

### Information security officer (ISB)

German-speaking organisations often use the title *Informationssicherheitsbeauftragter* (ISB), especially in the public sector and in companies that follow BSI IT-Grundschutz. The BSI standards describe the ISB as the person who coordinates the information security process, advises management, and checks that measures are implemented. In a large organisation the ISB may report to the CISO; in a smaller one the two roles are the same person. This module uses "ISB" for the role to avoid confusion with ISO, the standards body.

### Data protection officer (DPO)

The data protection officer (*Datenschutzbeauftragter*) is defined by the GDPR, not by a security standard. Under Article 37 GDPR a controller or processor must appoint one if:

- it is a public authority or body (except courts acting in their judicial capacity), or
- its core activities involve regular and systematic monitoring of people on a large scale, or
- its core activities involve large-scale processing of special categories of data (for example health data) or data on criminal convictions.

Germany adds a national rule: under § 38 of the Federal Data Protection Act (BDSG), a DPO is also required if as a rule at least 20 persons are constantly engaged in the automated processing of personal data. Austria has no comparable additional threshold, so many Austrian SMEs do not need a DPO where a German company of the same size would.

The DPO has a special position (Articles 38 and 39 GDPR). The DPO advises and monitors compliance, must not receive instructions on how to perform these tasks, may not be dismissed or penalised for performing them, and reports directly to the highest management level. The DPO must not hold a position that creates a conflict of interest. For that reason the head of IT or the CISO is usually a poor choice as DPO: they would be monitoring their own decisions.

Security and data protection overlap but are not the same. The ISB protects all information, including trade secrets and production data, against loss of confidentiality, integrity and availability. The DPO protects people whose personal data is processed, including against the company itself.

### Other roles

- **Risk owners and asset owners**: managers who are accountable for a specific risk or asset, for example the head of production for the production network. Security decisions about that asset need their agreement.
- **IT operations**: implement and run most technical controls.
- **Internal audit**: independently checks whether controls work (Lecture 5).
- **Security committee**: many companies have a committee in which management, the CISO, the DPO, IT and the business units meet regularly to decide on risks and priorities.

## The Three Lines Model

A common way to organise these roles is the **Three Lines Model** of the Institute of Internal Auditors (updated in 2020 from the older "three lines of defence"):

| Line | Who | Role in security |
| --- | --- | --- |
| First line | Business units, IT operations, developers | Own and manage risks, run the controls day to day |
| Second line | CISO / ISB, risk management, compliance, DPO | Set methods and policies, support and challenge the first line, monitor |
| Third line | Internal audit | Independent assurance to the management body |

The management body oversees all three, and external auditors and regulators look at the organisation from the outside. The model makes one point clear: the team that runs a control should not be the only one that judges whether it works.

## Where the CISO Reports

The reporting line of the CISO is a long-running debate. Three common options:

- **To the CIO (head of IT):** close to the technology, but there is a conflict of interest. The CIO is measured on uptime, features and cost, and security often competes with all three.
- **To the CEO or the management body directly:** independent and visible, but further from day-to-day IT.
- **To the chief risk officer, the CFO or legal:** common in banks and insurance companies, where security is treated as one type of operational risk.

There is no single right answer. What matters is that the CISO can escalate a risk to the management body without it being filtered by the people who caused it.

## Responsibilities in Practice: RACI

A RACI matrix is a simple tool to make responsibilities explicit. For each task it records who is **R**esponsible (does the work), **A**ccountable (decides and answers for it, exactly one person), **C**onsulted and **I**nformed.

| Task | Management | CISO | IT ops | DPO |
| --- | --- | --- | --- | --- |
| Approve the security policy | A | R | C | C |
| Patch servers | I | C | A/R | - |
| Assess a new cloud service | A | R | C | C |
| Report a personal data breach to the DSB | A | C | I | R |

Writing such a table often reveals gaps: tasks that everyone assumed someone else was doing.

## Conclusion

Governance decides the direction and the acceptable risk; management implements it. Accountability for security stays with the management body, a principle that NIS2 and DORA have turned into law. Around it sits a security organisation with a CISO or ISB who runs the programme, a data protection officer with an independent, legally protected position, risk owners in the business, and an internal audit function that checks the result. Without clear roles and reporting lines, the best technical controls decay. The next lecture looks at the management system that holds all of this together.

## Resources

- **ISO/IEC 27014:2020**: Information security, cybersecurity and privacy protection - Governance of information security
- **GDPR**: Regulation (EU) 2016/679, Articles 37-39 on the data protection officer, available on EUR-Lex
- **Austrian Data Protection Authority (DSB)**: <https://www.dsb.gv.at/>
- **IIA Three Lines Model**: <https://www.theiia.org/en/content/position-papers/2020/the-iias-three-lines-model-an-update-of-the-three-lines-of-defense/>
