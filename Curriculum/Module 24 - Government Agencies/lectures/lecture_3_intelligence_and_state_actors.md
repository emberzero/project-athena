# Intelligence Services and State Actors

Intelligence services are the pillar students know least about and the media discuss most. They collect information for their governments, protect the state against espionage and extremism, and in some countries carry out offensive cyber operations. For a security professional they matter in three ways: as the source of some of the most capable attacks, as a source of warnings and attribution, and as institutions whose powers to intercept and hack are a political and legal question that affects every user.

This lecture covers signals intelligence, the intelligence services of Germany and Austria, state-attributed threat actors, lawful interception, and the oversight that is supposed to keep all of this in check.

## Types of Intelligence

Intelligence services collect information in several ways:

| Discipline | Source | Example |
| --- | --- | --- |
| **HUMINT** (human intelligence) | People: agents, informants | Recruiting an employee at a foreign ministry |
| **SIGINT** (signals intelligence) | Intercepted communications and electronic signals | Tapping internet cables, intercepting satellite links |
| **OSINT** (open source intelligence) | Public information | Social media, publications, satellite images (Module 02) |
| **Cyber operations** | Access to computer systems | Breaking into a network to read data directly |

SIGINT and cyber operations have become central. Most communication is digital, and access to a single network can yield more than years of human sources.

## Signals Intelligence and the Five Eyes

The best-known SIGINT alliance is the **Five Eyes**, based on the UKUSA Agreement of 1946. Its members are:

- **NSA** (National Security Agency), United States
- **GCHQ** (Government Communications Headquarters), United Kingdom
- **CSE** (Communications Security Establishment), Canada
- **ASD** (Australian Signals Directorate), Australia
- **GCSB** (Government Communications Security Bureau), New Zealand

The members share intercepted material and divide up the world between them.

Most of what the public knows about modern SIGINT comes from the documents Edward Snowden, an NSA contractor, leaked in 2013. They described programmes such as **PRISM** (data collected from large US technology companies), **Tempora** (GCHQ's tapping of transatlantic fibre-optic cables) and **XKeyscore** (a system for searching through intercepted internet traffic). The revelations changed the industry: the share of encrypted web traffic rose sharply in the following years, and end-to-end encryption became standard in messengers.

The Snowden documents also affected Germany directly. In 2015 it emerged that the BND had for years run search terms (*selectors*) supplied by the NSA through its own interception systems, including selectors that targeted European companies and institutions. The affair led to a parliamentary inquiry and to new rules for the BND.

## Germany

Germany has three federal intelligence services, kept separate from the police (Lecture 1):

- **BND** (Bundesnachrichtendienst): the foreign intelligence service, under the Federal Chancellery. It carries out strategic SIGINT on communications abroad. In 2020 the Federal Constitutional Court ruled that the BND is bound by fundamental rights even when it monitors foreigners abroad. A new BND law followed in 2021.
- **BfV** (Bundesamt für Verfassungsschutz): the domestic intelligence service, under the Federal Ministry of the Interior, responsible among other things for counter-espionage and therefore for detecting foreign cyber espionage in Germany. Each federal state has its own Landesamt für Verfassungsschutz.
- **MAD** (Militärischer Abschirmdienst): military counter-intelligence.

Two further bodies are relevant to cyberspace:

- **ZITiS** (Zentrale Stelle für Informationstechnik im Sicherheitsbereich), founded in 2017, develops technical capabilities such as forensic and decryption tools for police and intelligence services. It does not carry out operations itself.
- The **Cyber- und Informationsraum** (CIR), the Bundeswehr's cyber and information domain branch since 2017, responsible for military cyber operations and the protection of the armed forces' own networks.

## Austria

Austria's intelligence landscape changed considerably in 2021:

- **DSN** (Direktion Staatsschutz und Nachrichtendienst): the domestic intelligence and state protection service, part of the Federal Ministry of the Interior. It replaced the **BVT** (Bundesamt für Verfassungsschutz und Terrorismusbekämpfung) in December 2021. The BVT had lost public trust after a controversial police raid on its own offices in 2018, and foreign partner services had reportedly become reluctant to share information with it. The DSN is split into a state protection part with police powers and an intelligence part.
- **Heeresnachrichtenamt** (HNaA): the military foreign intelligence service, under the Ministry of Defence. It is Austria's main SIGINT service.
- **Abwehramt**: military counter-intelligence, which also protects the armed forces' networks.

Unlike Germany, Austria places its domestic intelligence service inside the police structure. The 2021 reform tried to separate the two functions more clearly within the DSN.

## State-Attributed Threat Actors

Threat-intelligence companies track groups that carry out targeted, long-running intrusions as **APTs** (advanced persistent threats). Many of them have been attributed by governments to intelligence services or military units.

| Group | Attributed to | Known for |
| --- | --- | --- |
| **APT28** (Fancy Bear) | Russia, GRU military intelligence, unit 26165 | The 2015 hack of the German Bundestag; Germany issued an arrest warrant for a GRU officer in 2020 |
| **APT29** (Cozy Bear) | Russia, SVR foreign intelligence | The 2020 SolarWinds supply-chain compromise |
| **Sandworm** | Russia, GRU unit 74455 | Attacks on the Ukrainian power grid (2015, 2016) and the NotPetya malware (2017) |
| **APT1** | China, PLA unit 61398 | Large-scale industrial espionage, exposed by Mandiant in 2013 |
| **Lazarus Group** | North Korea | The Sony Pictures hack (2014), WannaCry (2017) and large cryptocurrency thefts |
| **Equation Group** | Linked by researchers to the NSA | Highly sophisticated malware, documented by Kaspersky in 2015 |

Two cases show how state and criminal activity are connected:

- **Stuxnet**, discovered in 2010, sabotaged centrifuges in Iran's uranium enrichment programme. It is widely attributed to the US and Israel, which have never officially confirmed it. It showed that malware could cause physical damage.
- In 2016 and 2017 a group calling itself the **Shadow Brokers** published hacking tools attributed to the Equation Group. One of them, the exploit **EternalBlue**, was used shortly afterwards in WannaCry and NotPetya, which together caused damage estimated in the billions. A vulnerability kept secret by one state ended up in the hands of others.

### Attribution

Attributing an attack to a state is difficult and partly political. Technical evidence (malware code, infrastructure, working hours, language artefacts) can point to a group, but it can also be faked. Governments therefore combine technical analysis with intelligence they usually do not publish. Official attributions are often made jointly by several states. Since 2019 the EU has had a legal framework for **cyber sanctions**, and in 2020 it imposed its first sanctions, including against the GRU unit behind NotPetya.

## Lawful Interception and State Hacking

Police and intelligence services can be authorised by law to monitor communications. Telecom providers must provide technical interfaces for this, standardised by ETSI.

Encryption has made classic interception less useful: a provider can hand over the encrypted traffic of a messenger, but not its content. States have responded in two ways:

- **Source interception** (Quellen-TKÜ in Germany): monitoring software is installed on the target's device and reads messages before they are encrypted or after they are decrypted. The software is often called a *state trojan* (Staatstrojaner, Bundestrojaner).
- **Online searches** (Online-Durchsuchung): covert access to the entire device, not only to ongoing communication.

Both require access to the device, which usually means exploiting a vulnerability. This creates a conflict that runs through the whole field: a vulnerability a state keeps secret to use for surveillance is also a vulnerability that criminals and other states can find and exploit. The EternalBlue case above is the classic example. Some states use a formal **vulnerabilities equities process** to decide case by case whether to disclose a vulnerability to the vendor or keep it.

The legal situation is contested in both countries. In Germany the Federal Constitutional Court set strict limits on online searches in 2008, and the rules for state trojans have been challenged several times since. In Austria, the Constitutional Court struck down a 2018 law that would have allowed police to monitor encrypted messengers, ruling in 2019 that it violated fundamental rights. New proposals for messenger surveillance by the DSN have been debated since. Check the current legal status before discussing specific powers.

Data retention, the blanket storage of everyone's connection data, has a similar history. The EU's Data Retention Directive was annulled by the Court of Justice of the EU in 2014, and national retention laws in Austria and Germany were struck down or suspended.

## Oversight

Intelligence services work in secret, so oversight is essential and difficult. Both countries combine parliamentary and independent control.

**Germany:**

- The **Parlamentarisches Kontrollgremium** (PKGr), a committee of the Bundestag, oversees all three federal services.
- The **G10-Kommission** must approve measures that interfere with the privacy of correspondence and telecommunications (Article 10 of the Basic Law, hence the name).
- The **Unabhängiger Kontrollrat** (Independent Control Council), created in 2022 after the Constitutional Court ruling, supervises the BND's technical surveillance.

**Austria:**

- **Rechtsschutzbeauftragte** (legal protection officers) are independent officials who must approve certain surveillance measures and review them afterwards.
- **Standing subcommittees** of the parliamentary committees for internal affairs and for defence oversee the DSN and the military services.
- The 2021 reform added an independent **Kontrollkommission Verfassungsschutz** to review the DSN.

Whether this oversight is sufficient is a recurring public debate in both countries, usually revived by a scandal.

## Conclusion

Intelligence services collect information through human sources, open sources, signals intelligence and cyber operations. The Five Eyes form the largest SIGINT alliance, and the Snowden revelations showed its scale. Germany separates its services strictly from the police; Austria reorganised its domestic service as the DSN in 2021. Many of the most capable threat actors are units of intelligence services or armed forces, and leaked state tools such as EternalBlue have fuelled criminal attacks. Lawful interception and state trojans depend on vulnerabilities and therefore conflict with the goal of fixing them. Parliamentary and independent oversight bodies are meant to keep these powers in check.

## Resources

- **BND**: <https://www.bnd.bund.de/>
- **BfV**: <https://www.verfassungsschutz.de/>
- **DSN**: <https://www.dsn.gv.at/>
- **MITRE ATT&CK Groups**: <https://attack.mitre.org/groups/> - Profiles of APT groups and their techniques
- **Kim Zetter**: *Countdown to Zero Day* (2014) - Book on Stuxnet
- **Andy Greenberg**: *Sandworm* (2019) - Book on the GRU unit behind NotPetya
