# Law Enforcement and International Cooperation

Cybercrime is almost always international. The victim sits in Austria, the attacker in another country, the servers in a third and the stolen money moves through exchanges in a fourth. Police and prosecutors, on the other hand, are bound to their national territory. This lecture covers the law-enforcement bodies that investigate cybercrime in Austria and Germany, the European and international bodies that connect them, and the legal instruments that make cross-border investigations possible, and slow.

Module 23 (Lecture 4) describes how investigators took down darknet markets such as Silk Road, AlphaBay, Hansa and Hydra. This lecture explains the institutions behind those operations rather than retelling them.

## Who Leads an Investigation

In both Austria and Germany, criminal investigations are formally led by the **public prosecutor's office** (Staatsanwaltschaft). The police carry out the investigative work, such as interviewing witnesses, securing evidence and analysing seized devices, but measures that interfere with fundamental rights, like a house search or communications surveillance, require a prosecutor's application and usually a court order. When a company reports a cyberattack, it therefore starts a process in which police, prosecutors and courts all play a role.

## Austria

- **Bundeskriminalamt** (BK), part of the Federal Ministry of the Interior. Its **Cybercrime Competence Center** (C4) is the central unit for cybercrime: it carries out investigations, provides digital forensics and acts as the national contact point for international cooperation.
- **Landeskriminalämter** (state criminal police offices) investigate most cases in their region. Police reforms have also placed IT investigators closer to local police stations, because almost every crime now leaves digital traces.
- Companies and citizens can report cybercrime at any police station or by e-mail to the BK's reporting office at `against-cybercrime@bmi.gv.at`.

## Germany

- **Bundeskriminalamt** (BKA) in Wiesbaden, the Federal Criminal Police Office, with its own cybercrime division. It handles serious cases of national significance and international cooperation.
- **Landeskriminalämter** (LKA) in each federal state. Every LKA runs a **Zentrale Ansprechstelle Cybercrime** (ZAC), a dedicated contact point for companies and public bodies that have been attacked.
- **ZIT** (Zentralstelle zur Bekämpfung der Internetkriminalität) at the Generalstaatsanwaltschaft Frankfurt am Main, a specialised prosecutor's office that leads many of Germany's large cybercrime and darknet proceedings, including the cases against the Hydra and Genesis markets.

## Europe

### Europol and EC3

**Europol**, based in The Hague, is the EU agency for law-enforcement cooperation. Its **European Cybercrime Centre** (EC3), founded in 2013, supports national police forces with analysis, forensics, coordination and operational meetings. The **Joint Cybercrime Action Taskforce** (J-CAT) hosts liaison officers from EU and non-EU countries who work on the same cases side by side.

Europol has **no executive powers**: it cannot arrest anyone or search a building. Arrests and searches are always carried out by national police under national law. Europol's value is in connecting them, so that police in ten countries can act on the same morning.

### Eurojust

**Eurojust**, also in The Hague, does for prosecutors what Europol does for police. It coordinates judicial cooperation, helps resolve conflicts about which country should prosecute, and supports **Joint Investigation Teams** (JITs), in which investigators and prosecutors from several countries work on a case under a common agreement and share evidence directly.

### Large coordinated operations

Some of the best-known operations of recent years were coordinated through Europol and Eurojust:

- **Emotet (2021):** police from several countries, including Germany, took control of the infrastructure of Emotet, one of the most widespread malware families of its time.
- **Operation Cronos (2024):** led by the UK's National Crime Agency, an international operation took over the infrastructure of the LockBit ransomware group and published information about its members on the group's own leak site.
- **Operation Endgame (2024):** described by Europol as the largest operation against botnets so far, targeting several *dropper* malware families used to deliver ransomware.

## Beyond the EU

### Interpol

**Interpol**, headquartered in Lyon, connects the police forces of almost every country in the world. Like Europol, it has no powers of its own. Its best-known tool is the system of **notices**, such as the Red Notice, which asks police worldwide to locate and provisionally arrest a wanted person. Its innovation centre in Singapore focuses on cybercrime.

### The Budapest Convention

The **Council of Europe Convention on Cybercrime** of 2001, known as the Budapest Convention, is the first international treaty on cybercrime. It has three parts:

- **Harmonised offences:** illegal access, illegal interception, data and system interference, misuse of devices, computer-related fraud and forgery, child sexual abuse material and copyright offences. The Austrian and German computer-crime provisions covered in Module 01 implement these.
- **Procedural powers:** for example the expedited preservation of stored data, so that evidence is not deleted while the formal request is still being processed.
- **International cooperation**, including a 24/7 network of contact points.

Austria, Germany and many non-European states, including the US and Japan, are parties. Russia and China are not. A **Second Additional Protocol** (2022) allows authorities to request certain data directly from service providers in other member states.

In December 2024 the UN General Assembly also adopted a **UN Convention against Cybercrime**. It is controversial: human rights organisations and parts of the security community have criticised its broad definitions and the risk that it could be used against journalists and researchers.

## Getting Evidence Across Borders

Most digital evidence is held by service providers, often in another country. There are several routes to it:

| Instrument | Scope | How it works |
| --- | --- | --- |
| **MLAT** (Mutual Legal Assistance Treaty) | Worldwide, bilateral or multilateral | Formal request from one state to another, processed by ministries and courts. Often takes months. |
| **European Investigation Order** | Within the EU | A judicial order from one member state that the other must in principle execute within set deadlines |
| **e-Evidence Regulation** | Within the EU, adopted 2023, applicable from August 2026 | Orders sent directly to a service provider in another member state, which must produce data within 10 days, or 8 hours in emergencies |
| **CLOUD Act** (US, 2018) | US providers | US authorities can compel US providers to hand over data regardless of where it is stored; allows executive agreements with other states |

The slowness of the classic MLAT route is one of the main reasons why so much cybercrime goes unpunished. By the time a request has been processed, logs have often been deleted. This is why the expedited preservation of data and direct cooperation with providers have become so important.

## Reporting a Crime as a Company

When a company falls victim to a cyberattack, involving the police is a decision that should be prepared in the incident response plan (Module 13):

- **Report early.** Police can often connect a case to others and may know the attacker already. In Germany the ZAC of the state police, and in Austria the C4 or the local police, are the first contacts.
- **Preserve evidence.** Logs, images of affected systems and ransom notes are evidence. Forensically sound acquisition (Module 09) and a documented chain of custody make it usable in court.
- **Separate obligations.** A criminal complaint does not replace a NIS2 report (Lecture 2). Both may be required, with different deadlines and recipients.
- **Ransom payments.** Police generally advise against paying. Payment is not automatically illegal, but it can be if the recipient is subject to sanctions, and it finances further attacks.

Reporting a crime does not automatically make an incident public. Investigators are usually interested in keeping an ongoing investigation confidential.

## Conclusion

Prosecutors lead criminal investigations; police carry them out. In Austria the Bundeskriminalamt's C4 and the state criminal police handle cybercrime, in Germany the BKA, the state LKAs with their ZAC contact points and specialised prosecutors such as the ZIT. Europol and Eurojust coordinate across the EU but have no executive powers of their own, and Interpol does the same worldwide. The Budapest Convention harmonises cybercrime law and cooperation, while MLATs, European Investigation Orders, the new e-Evidence rules and the US CLOUD Act govern how evidence crosses borders. For a company, reporting to the police is a separate step from reporting to the NIS authority, and both belong in the incident response plan.

## Resources

- **BMI Cybercrime**: <https://bundeskriminalamt.at/> - Austrian Bundeskriminalamt
- **BKA Cybercrime**: <https://www.bka.de/>
- **ZAC contact points**: <https://www.polizei.de/> - Search for "Zentrale Ansprechstelle Cybercrime" for your federal state
- **Europol EC3**: <https://www.europol.europa.eu/about-europol/european-cybercrime-centre-ec3>
- **Eurojust**: <https://www.eurojust.europa.eu/>
- **Budapest Convention**: <https://www.coe.int/en/web/cybercrime/the-budapest-convention>
