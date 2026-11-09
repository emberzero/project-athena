# Cyber Defence Bodies and CERTs

The first pillar is the one security professionals deal with most often. Cyber defence authorities publish warnings, coordinate the response to large incidents, certify products, and enforce the rules that oblige organisations to protect their networks and report attacks. Computer Emergency Response Teams (CERTs), also called Computer Security Incident Response Teams (CSIRTs), are their operational arm: the teams that answer the phone when something goes wrong.

This lecture introduces the main bodies in Germany, Austria and the EU, uses the US and UK as reference points, and then looks at NIS2, the EU directive that defines what an organisation owes the state after an incident.

## What a CERT Does

The first CERT was founded at Carnegie Mellon University in 1988, shortly after the Morris worm showed that nobody was responsible for coordinating the response to an internet-wide incident. Today almost every country has a national CERT, and many sectors, companies and universities have their own.

Typical services:

- **Warnings and advisories.** Information about new vulnerabilities, active attack campaigns and what to do about them.
- **Incident handling.** Helping an affected organisation understand and contain an attack, often by providing indicators of compromise or putting it in contact with others who saw the same attack.
- **Coordinated vulnerability disclosure.** Acting as a neutral go-between when a researcher finds a vulnerability and the vendor does not respond, or when many vendors are affected at once.
- **Notifying victims.** CERTs regularly receive data about compromised systems, for example from researchers or sinkholed botnets, and notify the network owners.
- **Situational awareness.** Collecting reports to see the overall picture, which no single organisation can see alone.

Most CERTs are not law-enforcement bodies. Reporting an incident to a CERT does not automatically start a criminal investigation, and good CERTs treat reports confidentially. This makes organisations more willing to report.

## Germany

### BSI

The **Bundesamt für Sicherheit in der Informationstechnik** (Federal Office for Information Security), founded in 1991, is Germany's national cyber security authority. It is subordinate to the Federal Ministry of the Interior. Its responsibilities are set out in the BSI Act (BSIG):

- **CERT-Bund**, the CERT for the federal administration, which also issues public warnings
- The **National IT Situation Centre** (Nationales IT-Lagezentrum), which monitors the threat situation around the clock
- **IT-Grundschutz**, a widely used methodology and catalogue of security measures
- Product certification, including Common Criteria evaluations
- Supervision of operators of critical infrastructure (KRITIS) and receiving their incident reports
- The annual report *Die Lage der IT-Sicherheit in Deutschland*

Because the BSI is part of the Interior Ministry, which also oversees the domestic intelligence service and the federal police, there is a long-running debate about whether it should be independent. Critics worry that a ministry interested in surveillance capabilities might not always push for vulnerabilities to be fixed.

### Nationales Cyber-Abwehrzentrum

The **National Cyber Defence Centre** (Cyber-AZ), set up in 2011, is not an authority but a cooperation platform. Representatives of the BSI, the domestic intelligence service (BfV), the Federal Criminal Police Office (BKA), the foreign intelligence service (BND), the Federal Police, the military and other bodies meet there to share information about incidents. It shows that the pillars of Lecture 1 cooperate, even where the law keeps them organisationally separate.

## Austria

### CERT.at

**CERT.at** is Austria's national CERT. It is operated by nic.at, the registry for `.at` domains. CERT.at publishes daily warnings, notifies Austrian network owners about compromised systems, coordinates during large incidents and is Austria's contact point in international CERT networks.

### GovCERT Austria

**GovCERT Austria** is the CERT for the public administration. It is run by the Federal Chancellery (Bundeskanzleramt) in cooperation with CERT.at. It supports public bodies and, together with CERT.at, coordinates the response to incidents of national significance.

### Sector CERTs and the authorities

There are also sector CERTs, such as **AEC** (Austrian Energy CERT) for the energy sector. Under Austria's NIS law, the Federal Ministry of the Interior is the competent authority that receives reports and supervises operators, and the Federal Chancellery is responsible for strategy. The details are changing with the implementation of NIS2 (see below).

## European Union

### ENISA

The **European Union Agency for Cybersecurity** (ENISA), founded in 2004 and based in Greece, does not run incident response for member states. Its job is to support them: it develops policy and best practice, organises EU-wide cyber exercises, publishes threat reports, runs the EU cybersecurity certification framework and acts as the secretariat of the CSIRTs network. The Cybersecurity Act of 2019 made its mandate permanent. Under NIS2, ENISA also maintains the **European Vulnerability Database** (EUVD).

### CERT-EU

**CERT-EU** is the CERT for the EU's own institutions, bodies and agencies, such as the European Commission and the European Parliament. It is a good example of an organisation-specific CERT at EU level.

### CSIRTs network

The **CSIRTs network** connects the national CSIRTs of all member states and CERT-EU. It is used to share information and coordinate the technical response to incidents that cross borders. For large-scale crises, NIS2 added **EU-CyCLONe**, a network of the national authorities responsible for crisis management.

## International Reference Points

Two agencies outside the EU publish material that security professionals everywhere use:

- **CISA** (Cybersecurity and Infrastructure Security Agency), part of the US Department of Homeland Security since 2018. Its *Known Exploited Vulnerabilities* (KEV) catalogue lists vulnerabilities that are being exploited in practice, and is a common way to prioritise patching.
- **NCSC** (National Cyber Security Centre), founded in 2016 as part of GCHQ, the British signals intelligence agency. Its guidance is widely read. Its position inside an intelligence agency is a deliberate British choice and the opposite of the German approach of keeping defence and intelligence apart.

## NIS2: What an Organisation Owes the State

The **NIS2 Directive** (Directive (EU) 2022/2555) replaced the first NIS Directive of 2016. It sets minimum cybersecurity requirements for a large part of the economy and the public sector. As a directive, it does not apply directly: each member state must transpose it into national law. The deadline was 17 October 2024.

### Who is covered

NIS2 distinguishes **essential** and **important** entities. Between them they cover sectors such as energy, transport, banking, health, drinking water, digital infrastructure, ICT service management, public administration and space, and also postal services, waste management, chemicals, food, manufacturing and digital providers. As a rule, it applies to medium-sized and large organisations in those sectors (from 50 employees or 10 million euros annual turnover). Some, such as DNS service providers, are covered regardless of size.

Many more organisations are covered than under the first NIS Directive. Estimates for Austria and Germany run into the thousands, and many of them had no reporting obligations before.

### Obligations

- **Risk management (Article 21):** appropriate technical and organisational measures, including incident handling, business continuity, supply-chain security, secure development, access control, encryption and multi-factor authentication.
- **Management accountability (Article 20):** the management body must approve the security measures, oversee their implementation and undergo training. Managers can be held personally liable.
- **Reporting (Article 23):** significant incidents must be reported to the national CSIRT or competent authority.

### The reporting timeline

An incident is significant if it has caused or can cause severe operational disruption or financial loss, or considerable damage to others. For such an incident the organisation must submit:

| Deadline | Report | Content |
| --- | --- | --- |
| 24 hours after becoming aware | Early warning | Whether a malicious act is suspected and whether there may be cross-border impact |
| 72 hours after becoming aware | Incident notification | Initial assessment: severity, impact, indicators of compromise where available |
| One month after the notification | Final report | Detailed description, root cause, mitigations, cross-border impact |

Intermediate reports can be requested in between. These deadlines are the reason why incident response plans (Module 13) now need a step "notify the authority", with a named person responsible and the contact details ready before an incident happens.

### Sanctions

Member states must be able to fine essential entities up to 10 million euros or 2 % of worldwide annual turnover, whichever is higher, and important entities up to 7 million euros or 1.4 %.

### Status in Austria and Germany

Both countries missed the October 2024 deadline. In Austria, a first implementation law (NISG 2024) failed in parliament in 2024 and a replacement was still in preparation afterwards. Germany's implementation act (NIS2UmsuCG) was also delayed by the end of the governing coalition in late 2024. Because these laws were still changing while this lecture was written, check the current status of the Austrian NISG and the German NIS2 implementation before relying on details such as the competent authority or exact thresholds.

## Conclusion

Cyber defence authorities and CERTs warn, help and regulate. In Germany the BSI combines all three roles; in Austria CERT.at and GovCERT Austria provide the CERT services while the ministries act as authorities. At EU level, ENISA supports the member states and the CSIRTs network connects their teams. NIS2 turns all of this into concrete obligations: thousands of organisations must manage their cyber risks, and report significant incidents within 24 hours, 72 hours and one month. A security professional who works for one of them needs to know the reporting path before the first incident, not after it.

## Resources

- **CERT.at warnings**: <https://cert.at/de/warnungen/>
- **BSI**: <https://www.bsi.bund.de/>
- **ENISA**: <https://www.enisa.europa.eu/>
- **CISA KEV catalogue**: <https://www.cisa.gov/known-exploited-vulnerabilities-catalog>
- **NCSC (UK)**: <https://www.ncsc.gov.uk/>
- **NIS2 Directive**: Directive (EU) 2022/2555, available on EUR-Lex
