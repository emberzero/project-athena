# Risk Management

No organisation can protect everything against every threat. Budgets are limited, every control has a cost, and some controls get in the way of the work they are supposed to protect. Risk management is the process of deciding where to spend the effort: which risks are serious enough to act on, which can be passed on to someone else, and which the organisation consciously accepts. It is the core of every ISMS (Lecture 2) and of every regulation in Lecture 4, which almost all demand "appropriate" measures based on risk.

This lecture defines the vocabulary, walks through a qualitative risk assessment, explains the four treatment options and shows how the results are recorded in a risk register.

## Vocabulary

| Term | Meaning | Example |
| --- | --- | --- |
| **Asset** | Anything of value to the organisation | Customer database, production line controller, laptop of the CFO, company reputation |
| **Threat** | A potential cause of an unwanted incident | Ransomware group, disgruntled employee, flood, power failure |
| **Vulnerability** | A weakness that a threat can exploit | Unpatched VPN appliance, no offline backup, server room in the basement |
| **Impact** | The consequence if the incident happens | Production stops for a week, fine under the GDPR, loss of a key customer |
| **Likelihood** | How probable it is that the incident happens in a given period | Rated on a scale, or estimated as a frequency |
| **Risk** | The combination of likelihood and impact | High likelihood, high impact: ransomware encrypts the file server |
| **Control** | A measure that reduces likelihood or impact | Patch management, offline backups, MFA |

A threat alone is not a risk, and neither is a vulnerability alone. A risk exists where a threat can exploit a vulnerability of an asset and cause an impact. A flood is not a risk for a server in the third floor of a building on a hill; an unpatched vulnerability on a system that is switched off and disconnected is not much of a risk either.

## The Risk-Management Process

ISO 31000, the general risk-management standard, and ISO/IEC 27005, its application to information security, describe the same basic loop:

1. **Establish the context:** scope, risk criteria (scales for likelihood and impact), risk appetite.
1. **Identify risks:** which assets, threats and vulnerabilities, which scenarios.
1. **Analyse risks:** rate likelihood and impact.
1. **Evaluate risks:** compare against the risk criteria and decide which risks need treatment.
1. **Treat risks:** choose and implement a treatment option.
1. **Monitor and review:** repeat regularly and after major changes or incidents.

Communication runs through all steps: risk owners, management and staff must understand the results. The current edition, **ISO/IEC 27005:2022**, describes two ways to identify risks. The **asset-based** approach starts from the asset inventory and asks what could happen to each asset. The **event-based** approach starts from scenarios ("a ransomware attack on the production network") and asks which assets they affect. Both are valid; event-based assessments are often faster and easier to explain to management.

## Rating Likelihood and Impact

Most organisations use a **qualitative** method: likelihood and impact are each rated on a small scale with defined meanings. The definitions matter more than the numbers. Without them, one person's "high" is another person's "medium".

A three-level scale, suitable for a small organisation:

| Rating | Likelihood | Impact |
| --- | --- | --- |
| 1 Low | Not expected within the next three years | Minor disruption, fixed within a day, no external effect |
| 2 Medium | Could happen within the next three years | Disruption of several days, some customers affected, cost below 50,000 EUR |
| 3 High | Expected within the next year or has already happened | Business stops for more than a week, legal consequences, cost above 50,000 EUR |

The euro amounts are an example; each organisation sets its own thresholds based on its size. Larger organisations often use five levels.

The **risk level** is then derived from both ratings, often as the product of the two numbers, and shown as a matrix:

| Likelihood \ Impact | 1 Low | 2 Medium | 3 High |
| --- | --- | --- | --- |
| **3 High** | 3 Medium | 6 High | 9 High |
| **2 Medium** | 2 Low | 4 Medium | 6 High |
| **1 Low** | 1 Low | 2 Low | 3 Medium |

The **risk appetite** set by management decides what happens next, for example: low risks may be accepted by the risk owner, medium risks need a treatment plan or a documented acceptance, high risks must be treated and reported to management.

### Quantitative methods

A **quantitative** analysis expresses risk in money. The classic formula is the annualised loss expectancy: ALE = SLE x ARO, where SLE (single loss expectancy) is the cost of one incident and ARO (annual rate of occurrence) is how often it is expected per year. A laptop theft that costs 3,000 EUR and happens four times a year gives an ALE of 12,000 EUR, so a control that costs less per year and prevents most thefts is worth it.

Quantitative methods are attractive to management because they speak the language of budgets. Their weakness is the input data: for rare, high-impact events such as a targeted attack, nobody has reliable frequencies, and precise-looking numbers hide guesswork. Many organisations therefore use qualitative ratings and add rough money estimates only for the largest risks.

## Risk Treatment

For each risk that needs treatment, there are four options. ISO/IEC 27005 uses different names for them, which you will also meet in audits:

| Option | ISO/IEC 27005 term | What it means | Example |
| --- | --- | --- | --- |
| **Mitigate** | Modify | Implement controls that reduce likelihood or impact | Introduce MFA for the VPN, keep offline backups |
| **Transfer** | Share | Pass part of the risk to another party | Cyber insurance, outsourcing to a provider with contractual liability |
| **Avoid** | Avoid | Stop the activity that causes the risk | Stop storing credit card numbers, switch off an unused internet-facing service |
| **Accept** | Retain | Consciously take the risk without further action | Accept that a non-critical test server may be down for a day |

Some points about the options:

- **Transfer does not remove responsibility.** Insurance pays money; it does not restore lost customer trust, and the GDPR and NIS2 obligations stay with the organisation. Cyber insurers also increasingly require controls such as MFA and offline backups before they offer cover.
- **Acceptance must be a decision, not a default.** An accepted risk is documented, signed by someone with the authority to accept it (usually the risk owner or management, depending on the level) and reviewed regularly. A risk that nobody looked at has not been accepted; it has been ignored.
- **Treatment usually combines options.** Backups (mitigate) plus insurance (transfer) is a typical combination for ransomware.

After treatment, the **residual risk** is rated again. The risk before treatment is often called the inherent risk. Management must accept the residual risks; ISO/IEC 27001 requires risk owners to approve the risk treatment plan and the residual risks.

## The Risk Register

The results are recorded in a **risk register**, a table that is the working document of risk management. A simplified excerpt:

| ID | Asset | Threat / vulnerability | L | I | Risk | Treatment | Owner | Residual |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R-01 | File server | Ransomware via phishing; no offline backup | 3 | 3 | 9 | Mitigate: offline backup, awareness, EDR. Transfer: insurance | Head of IT | 3 |
| R-02 | Customer database | SQL injection in web shop | 2 | 3 | 6 | Mitigate: code review, WAF, pentest | Head of e-commerce | 3 |
| R-03 | Office laptops | Theft; disks not encrypted | 2 | 2 | 4 | Mitigate: full-disk encryption | Head of IT | 2 |
| R-04 | Legacy fax server | Unsupported OS | 2 | 1 | 2 | Avoid: decommission | Office manager | 0 |
| R-05 | Test server | Outage | 2 | 1 | 2 | Accept, review yearly | Head of development | 2 |

Typical additional columns are the date of the last review, the related Annex A controls, the deadline for the planned measures and the status. A spreadsheet is enough for a small company; larger organisations use governance, risk and compliance (GRC) tools.

## Common Mistakes

- **Rating without definitions.** Scales without written meanings produce numbers that cannot be compared between assessors or years.
- **Only technical risks.** Supplier failure, loss of key staff and physical risks are left out because the assessment was done by IT alone.
- **Assess once, never again.** The register is written for the certification audit and then not touched. Risks change with every new system, supplier and incident.
- **No owner.** A risk owned by "IT" or "everyone" is owned by nobody.
- **Treatment without follow-up.** Measures are planned but never implemented or verified.

## Alternative Approaches

Not every methodology starts with a full risk analysis. **BSI IT-Grundschutz** (Lecture 4) first assigns each asset a protection requirement (normal, high, very high) and applies a catalogue of standard measures for typical components. A separate risk analysis following BSI-Standard 200-3 is only required for assets with high or very high protection requirements, or for components the catalogue does not cover. This saves effort for typical IT and is one reason the approach is popular in the German and Austrian public sector.

## Conclusion

Risk management decides where security effort goes. A risk exists where a threat can exploit a vulnerability of an asset; it is rated by likelihood and impact on scales with written definitions, compared against the risk appetite and treated by mitigating, transferring, avoiding or accepting it. The risk register records the decisions, the owners and the residual risk, and it is only useful if it is reviewed regularly. ISO/IEC 27005 gives guidance on the process; ISO/IEC 27001 requires that it exists and is followed. The next lecture looks at the frameworks and laws that make risk management mandatory.

## Resources

- **ISO/IEC 27005:2022**: Guidance on managing information security risks
- **ISO 31000:2018**: Risk management - Guidelines
- **BSI-Standard 200-3**: Risk analysis based on IT-Grundschutz, <https://www.bsi.bund.de/>
- **ENISA risk management resources**: <https://www.enisa.europa.eu/>
