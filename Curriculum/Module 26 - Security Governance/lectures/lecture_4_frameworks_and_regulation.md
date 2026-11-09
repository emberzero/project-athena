# Frameworks and Regulation

ISO/IEC 27001 is not the only way to organise security, and since the early 2020s security is no longer a voluntary matter for a large part of the European economy. This lecture looks at two other widely used frameworks, the NIST Cybersecurity Framework and BSI IT-Grundschutz, and then at the EU laws that a security professional in Austria or Germany has to know: NIS2, DORA, the GDPR and the Cyber Resilience Act.

The two parts belong together. Laws say *that* an organisation must manage its risks and take "appropriate" measures; frameworks and standards say *how*. A company that runs an ISMS according to ISO/IEC 27001 already meets a large part of what the laws require, and auditors and authorities regularly use the frameworks as a yardstick.

## Frameworks

### NIST Cybersecurity Framework 2.0

The **Cybersecurity Framework** (CSF) of the US National Institute of Standards and Technology was first published in 2014 for critical infrastructure. Version **2.0**, published in February 2024, is aimed explicitly at organisations of every size and sector. It is free and is used far beyond the US.

The core of the CSF is organised into six **functions**:

| Function | Question | Examples |
| --- | --- | --- |
| **Govern** (new in 2.0) | How do we set and oversee our cybersecurity strategy? | Risk-management strategy, roles and responsibilities, policy, oversight, supply-chain risk management |
| **Identify** | What do we have and what are our risks? | Asset management, risk assessment, improvement |
| **Protect** | How do we prevent incidents? | Identity and access management, awareness, data security, platform security |
| **Detect** | How do we notice attacks? | Continuous monitoring, analysis of adverse events |
| **Respond** | What do we do during an incident? | Incident management, analysis, reporting, mitigation |
| **Recover** | How do we return to normal? | Recovery plan execution, communication |

The new **Govern** function is the main change in 2.0. It moved governance topics that were previously spread across the framework into one place and placed them at the centre: the other five functions are carried out within the frame that Govern sets. This matches the shift in regulation towards management accountability (Lecture 1).

Each function is broken down into categories and subcategories that describe outcomes, not specific technologies. Organisations use the CSF to create **profiles**: a current profile describes where they are, a target profile where they want to be, and the gap between them becomes the roadmap. NIST publishes mappings from the CSF to other frameworks, including ISO/IEC 27001.

### BSI IT-Grundschutz

**IT-Grundschutz** is the methodology of the German Federal Office for Information Security (BSI, see Module 24). It is widely used in German public administration and by many companies in Germany and Austria. It consists of:

- **BSI-Standard 200-1:** requirements for an ISMS, compatible with ISO/IEC 27001
- **BSI-Standard 200-2:** the IT-Grundschutz methodology
- **BSI-Standard 200-3:** risk analysis (Lecture 3)
- **BSI-Standard 200-4:** business continuity management
- **IT-Grundschutz-Kompendium:** a catalogue of modules (*Bausteine*) for typical components and processes, for example Windows servers, web applications, Active Directory, industrial control systems or remote working. Each module lists threats and requirements.

The methodology differs from a pure ISO approach. Instead of a full risk analysis for every asset, the organisation models its IT landscape with the modules, determines the protection requirement (normal, high, very high) for each target object and applies the standard requirements. A separate risk analysis is only needed where the protection requirement is high or very high, or where no module fits. BSI-Standard 200-2 offers three levels of entry: *Basis-Absicherung* (basic protection across the whole organisation, a starting point), *Kern-Absicherung* (focus on the most critical assets) and *Standard-Absicherung* (the full approach, which can lead to ISO 27001 certification on the basis of IT-Grundschutz).

The advantage is concreteness: the Kompendium tells you what to check on a Windows server. The disadvantage is the volume: the catalogue is large, and adapting it to an organisation is work. The BSI revises the Kompendium regularly; check the current edition before using it.

In Austria, the Federal Chancellery publishes the **Österreichisches Informationssicherheitshandbuch**, a free handbook for public administration that is also used by companies. It is aligned with ISO/IEC 27001 and 27002.

### Comparison

| | ISO/IEC 27001 | NIST CSF 2.0 | BSI IT-Grundschutz |
| --- | --- | --- | --- |
| Origin | International standard | US government, voluntary | German government |
| Approach | Management system plus reference controls | Outcome-based functions and profiles | Methodology plus detailed catalogue |
| Certification | Yes, by accredited bodies | No | Yes, ISO 27001 on the basis of IT-Grundschutz |
| Cost | Standard must be purchased | Free | Free |
| Typical users | Companies worldwide, suppliers | US organisations, international companies | German public sector, KRITIS, some companies in AT and DE |

The frameworks are not competitors. A company might run an ISO 27001 ISMS, use the CSF to explain its maturity to management, and use Grundschutz modules as checklists for specific systems. For a narrower technical baseline, the **CIS Controls** of the Center for Internet Security are also common.

## Regulation

### NIS2

The NIS2 Directive (Directive (EU) 2022/2555) covers essential and important entities in a long list of sectors. Its reporting obligations, scope, sanctions and national status are covered in detail in **Module 24, Lecture 2**. From a governance perspective, two articles matter most:

- **Article 20 (governance):** the management body must approve the cybersecurity risk-management measures, oversee their implementation and undergo regular training. It can be held liable for infringements.
- **Article 21 (risk-management measures):** an all-hazards approach with a minimum list of measures, including risk analysis and security policies, incident handling, business continuity and crisis management, supply-chain security, security in acquisition, development and maintenance, assessment of the effectiveness of measures, cyber hygiene and training, cryptography, human resources security and access control, and multi-factor authentication.

Almost every item in Article 21 corresponds to one or more Annex A controls of ISO/IEC 27001. An organisation with a working ISMS has a head start, but a certificate does not automatically prove NIS2 compliance: the scope of the certificate must cover the services that fall under NIS2, and the national implementation laws may add requirements.

**Supply chain:** NIS2 also reaches companies that are not covered themselves. Covered entities must manage the security of their suppliers, so they pass requirements on in contracts, questionnaires and audits. A 30-person software company that supplies a hospital may never be an NIS2 entity, but it will still be asked about its security.

### DORA

The **Digital Operational Resilience Act** (Regulation (EU) 2022/2554) applies to the financial sector from **17 January 2025**. As a regulation, it applies directly in every member state without national transposition. It covers banks, insurance companies, investment firms, payment and e-money institutions, crypto-asset service providers and other financial entities, and for them it takes precedence over the general NIS2 rules as the more specific law.

DORA has five main areas:

| Area | Content |
| --- | --- |
| ICT risk management | A documented ICT risk-management framework; the management body bears ultimate responsibility |
| ICT incident management and reporting | Classify ICT-related incidents and report major ones to the financial supervisor |
| Digital operational resilience testing | Regular testing; for significant entities, threat-led penetration testing (TLPT) at least every three years |
| ICT third-party risk | Register of all ICT service contracts, mandatory contract clauses, exit strategies |
| Information sharing | Voluntary exchange of threat intelligence between financial entities |

A new element is the EU oversight of **critical ICT third-party providers**, such as large cloud providers, by the European Supervisory Authorities. The national supervisors are the **FMA** (Finanzmarktaufsicht) in Austria and **BaFin** in Germany. Many details are set out in technical standards adopted after the regulation, so check the current versions when working on DORA compliance.

### GDPR

The **General Data Protection Regulation** (Regulation (EU) 2016/679) has applied since May 2018 to anyone processing personal data. Module 01 covers it in detail. The articles most relevant for security governance:

- **Article 5:** principles, including integrity and confidentiality, and accountability: the controller must be able to demonstrate compliance.
- **Article 25:** data protection by design and by default.
- **Article 32:** security of processing, appropriate technical and organisational measures that take into account the state of the art, costs and risks, for example pseudonymisation, encryption, resilience and regular testing.
- **Articles 33 and 34:** a personal data breach must be reported to the supervisory authority within 72 hours of becoming aware of it, unless it is unlikely to result in a risk to people; if the risk is high, the affected people must also be informed.
- **Article 35:** data protection impact assessment for processing likely to result in a high risk.

Fines can reach 20 million euros or 4 % of worldwide annual turnover, whichever is higher. The supervisory authority in Austria is the **Datenschutzbehörde** (DSB). In Germany, the federal commissioner (BfDI) supervises federal bodies and some sectors such as telecommunications, while the data protection authorities of the federal states supervise most private companies.

A single incident can trigger several reports: a ransomware attack on a hospital that leaks patient data is a NIS2 incident and a GDPR personal data breach, with different recipients, deadlines and contents. Incident response plans must cover both.

### Cyber Resilience Act

The **Cyber Resilience Act** (CRA, Regulation (EU) 2024/2847) entered into force in December 2024. Unlike NIS2 and DORA, which regulate organisations, it regulates **products with digital elements**: hardware and software that is placed on the EU market, from smart home devices and routers to operating systems and business software. Manufacturers must, among other things:

- design products with security in mind and ship them without known exploitable vulnerabilities and with secure default settings,
- handle vulnerabilities throughout a support period and provide security updates,
- document the components they use, including a software bill of materials,
- report actively exploited vulnerabilities and severe incidents to the authorities,
- carry out a conformity assessment and affix the CE marking.

Products are divided into categories; for "important" and "critical" products the conformity assessment is stricter. Free and open-source software developed outside a commercial activity is largely excluded. The obligations are phased in: the reporting obligations (Article 14) have applied since 11 September 2026, including for products placed on the market before that date, and most other obligations, such as the essential requirements and conformity assessment, apply from 11 December 2027.

For a governance team, the CRA matters in two directions. A company that develops products must build vulnerability handling and secure development into its processes. A company that buys products gains a legal baseline it can refer to in procurement.

## Who Has to Comply with What

| Regulation | Applies to | Type | Key governance obligation |
| --- | --- | --- | --- |
| NIS2 | Essential and important entities in listed sectors | Directive, national laws | Management approval and oversight, risk-management measures, incident reporting |
| DORA | Financial entities, critical ICT providers | Regulation, directly applicable | ICT risk framework, incident reporting, resilience testing, third-party register |
| GDPR | Anyone processing personal data | Regulation, directly applicable | Security of processing, breach notification, accountability |
| CRA | Manufacturers, importers and distributors of products with digital elements | Regulation, directly applicable, phased in | Secure products, vulnerability handling, reporting |

## Conclusion

Frameworks describe how to organise security: ISO/IEC 27001 as a certifiable management system, NIST CSF 2.0 as an outcome-based model with the new Govern function at its centre, and BSI IT-Grundschutz as a detailed methodology with a catalogue of concrete requirements. Regulation makes risk management mandatory: NIS2 for a wide range of sectors, DORA for the financial sector since January 2025, the GDPR for anyone processing personal data, and the Cyber Resilience Act for products. They share a pattern: management is accountable, measures must be risk-based and appropriate, and incidents must be reported. A well-run ISMS is the most efficient way to meet all of them at once.

## Resources

- **NIST Cybersecurity Framework 2.0**: <https://www.nist.gov/cyberframework>
- **BSI IT-Grundschutz**: <https://www.bsi.bund.de/>
- **Österreichisches Informationssicherheitshandbuch**: <https://www.sicherheitshandbuch.gv.at/>
- **DORA**: Regulation (EU) 2022/2554, available on EUR-Lex
- **Cyber Resilience Act**: Regulation (EU) 2024/2847, available on EUR-Lex
- **CIS Controls**: <https://www.cisecurity.org/controls>
