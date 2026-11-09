# Legal Framework

> **Disclaimer:** This lecture primarily focuses on the legal framework and considerations pertaining to IT security in Austria.

## Basic terms from Austrian Criminal Law (Strafgesetz)

- **Place of Crime (Tatort) (§ 62 StGB):**
  - Austrian criminal law applies to offenses committed **within** the country.
  - Where an offense counts as committed is defined in § 67 Abs 2 StGB: at the place of action OR at the place of result. For remote attacks this means the offender does not have to be in Austria for Austrian law to apply.
  - Note: For servers & infrastructure abroad, different laws may apply!
- **Intent (Vorsatz) (§ 5 Abs 1 StGB):**
  - Refers to the subjective side of the offense.
  - The thoughts or mental state of the offender at the time of the offense.
  - Believing the actions or results described in the section are possible and reconciling oneself with them.
- **Intention (Absicht) (§ 5 Abs 2 StGB):**
  - Deliberately aiming to realize the actions/results described in the regulation.

## Legal Definitions

- **Computer system (Computersystem):**
  - Both individual and connected devices which are used for automated data processing.
- **Data (Daten):**
  - Both personal and non-personal data, as well as programs.

### Legal Definitions - Critical Infrastructure

- **Facilities, installations, systems, or parts that are of significant importance for maintaining:**
  - Public safety
  - National defense
  - Protection of the civilian population against war dangers
  - Functionality of public information and communication technology
- **Facilities, installations, systems, or components that are essential for:**
  - Prevention or combat of disasters
  - Public health services
  - Public supply of water, energy, and essential goods
  - Public waste disposal and sewerage systems
  - Public transportation

## Relevant Sections

> **Disclaimer:** The names in the examples are not related to real individuals.

The sections below are easier to keep apart when sorted by what the offender actually does, rather than by section number:

```text
  what is done                       section
  --------------------------------   ---------------------------
  [ acquire or build tools,          126c  misuse of computer
    passwords, access codes ]              programs / access data

  [ break a security measure to      118a  unauthorised access to
    get into a system ]                    a computer system

  [ read messages in transit ]       119   telecom secrecy
                                     119a  misuse of intercepted
                                           data
                                     241h  spying on non-cash
                                           payment data

  [ record non-public speech ]       120   audio recording and
                                           eavesdropping devices

  [ change, delete or suppress       126a  data tampering
    data ]

  [ make the system stop working ]   126b  disruption of system
                                           functionality

  [ influence automated processing   148a  fraudulent misuse of
    for financial gain ]                   data processing

  Each of these is an offence in its own right. A real attack often
  chains several of them, but none of them requires § 118a first:
  an insider misusing access she legitimately has, or someone
  tapping a line without touching a computer system at all, is
  covered by the respective section on its own.
```

Within most of these sections the penalty is then graded along similar lines - the basic offence, a higher level once the damage or the number of affected systems grows, and the highest level for very large damage, critical infrastructure, or acting as part of a criminal association. The exact thresholds differ per section and are listed below.

### **Unauthorized Access to a Computer System (§118a StGB)**

> **German:** Widerrechtlicher Zugriff auf ein Computersystem

**Definition:**
Unauthorized access is defined as intentionally accessing a computer system or a part of it by overcoming its specific security measure(s) without the requisite permissions.

**Key Elements:**

- **System Intrusion:** Accessing a computer system, or a part of such system, which one does not have the right to use or control.
- **Security Breach:** Achieving this access by bypassing specific security measures established in the computer system.

#### **Intent:**

***Case 1:***

- **Data Acquisition Motive:** The intent to provide either oneself or another unauthorized person with:
  - **Knowledge of Personal Data:** Accessing data whose revelation infringes upon the legitimate confidentiality interests of the affected party.

***Case 2:***

- **Malicious Motive:** The intention revolves around causing harm or detriment to another individual either by:
  - **Misusing Data:** Utilizing data stored in the system, which is not intended for the perpetrator.
  - **System Misuse:** Directly using the computer system for harmful purposes.

**Penalties:**

- Standard offenses under this section can lead to imprisonment for up to **two years**.
- If the offense involves a computer system that is an essential part of the critical infrastructure, the penalty can be up to **three years** of imprisonment.
- Prosecution of the perpetrator can only proceed with the authorization of the victim.
- If the act is committed within the context of a criminal association, the penalty for the first scenario is up to **three years**. For the second scenario, it's a sentence of **six months to five years**.

### Example Case 1: Unauthorized Access to a Computer System (§118a StGB)

**Background:**
Lukas, a university student in Salzburg, always had a penchant for technology and hacking. Over casual conversations, he learned that his friend, Elena, was dating someone new. Curious and somewhat envious, Lukas wanted to know more about this individual, especially since Elena was always tight-lipped about her personal life.

**Action Taken:**
Using his knowledge of cyber vulnerabilities, Lukas targeted a local coffee shop's public Wi-Fi network, a place he knew Elena often visited. By exploiting weaknesses in the network, he gained unauthorized access to Elena's laptop. From there, he scoured her personal files, photos, and most importantly, her messages, looking for any details about her new romantic partner. He hoped to find personal information that might give him more insights into the person Elena was dating.

**Discovery:**
A week later, Elena found an unfamiliar file on her laptop, a sign that someone might have tampered with her device. Concerned, she took it to the university's IT department, where they discovered traces of Lukas's intrusion. Forensic analysis of her laptop indicated that Lukas had accessed personal data not meant for him.

**Legal Implications:**
Lukas's actions were in direct violation of § 118a StGB. Specifically:

- He intentionally accessed Elena's laptop to obtain knowledge of personal data.
- This data was private and confidential, meaning Elena had a legitimate confidentiality interest in it.
- His unauthorized access and data retrieval were clearly against her interests and privacy rights.

Regardless of his motivations, Lukas could face prosecution under Austrian law for unauthorized access to a computer system and infringing on personal privacy.

### Example Case 2: Unauthorized Access to a Computer System (§118a StGB)

**Background:**
Julia, a software engineer at a tech company in Vienna, had recently received negative feedback on her project from a colleague, Adrian. Feeling unfairly judged and seeking revenge, she decided to target Adrian's computer system to tarnish his reputation.

**Action Taken:**
Using her advanced technical skills, Julia managed to infiltrate the company's internal network and accessed Adrian's workstation. Once in, she located a confidential project Adrian was working on. Julia intentionally corrupted the project files and planted malicious software on his computer that would send out inappropriate emails to the company's top executives using Adrian's email account.

**Discovery:**
The next day, Adrian was horrified to find out about the emails sent from his account and the corrupted project data. The IT department was immediately alerted and began an investigation. Through digital forensics, they traced back the intrusion to Julia's computer.

**Legal Implications:**
Julia's actions clearly violated § 118a StGB:

- Her primary intention was to harm Adrian, both professionally and personally.
- She accessed data and resources on Adrian's computer that were not meant for her.
- She used his computer to send out damaging emails, turning his own system against him.

Given the clear evidence against her and the malicious intent, Julia is liable for unauthorized access and the consequent damage she inflicted on Adrian's reputation and work.

______________________________________________________________________

### **Violation of Telecommunication Secrecy (§ 119 StGB)**

> **German:** Verletzung des Telekommunikationsgeheimnisses

**Definition:**
The act pertains to the unauthorized intent to acquire knowledge of a message's content, transmitted via telecommunication or a computer system, which isn't intended for the perpetrator.

**Key Elements:**

- **Unauthorized Intent:** The primary motive to either personally or for another unauthorized person obtain the contents of a message.
- **Means of Communication:** The message in question has been conveyed through telecommunication or a computer system.
- **Use of Device:** The act of using a device or apparatus attached or otherwise made receptive to the telecommunication system or computer system.

**Intent:**

- **Message Intrusion:** The purpose revolves around gaining knowledge of a communication or message not meant for the individual, by using devices attached to the communication infrastructure.

**Penalties:**

- Individuals found guilty can face up to **six months** in prison or a fine of up to **360 daily rates**.
- Prosecution of the perpetrator can only proceed with the authorization of the victim.

### Example Case: Violation of Telecommunication Secrecy (§ 119 StGB)

**Background:**
In a mid-sized company in Vienna, Alicia, an employee in the IT department, became suspicious of certain executive decisions that seemed to favor a competitor. Believing there might be some shady dealings going on behind closed doors, she decided to take matters into her own hands to uncover any potential wrongdoing.

**Action Taken:**
Alicia discreetly installed a small device on the phone system in the boardroom. This device was capable of intercepting and recording any phone conversations made in that room. The device transmitted these recordings to Alicia's private computer using a hidden Wi-Fi connection.

**Discovery:**
A few weeks later, during a routine IT check, another team member stumbled upon unusual network traffic. After investigating, the telecommunication interception device was discovered. Alicia's activities were traced back to her, revealing the recordings she had accumulated.

**Legal Implications:**
Alicia's actions were a direct violation of § 119 StGB as she had:

- Installed a device to intercept telecommunications.
- Acted with the intention of obtaining knowledge of messages not meant for her.

While her suspicions might have stemmed from genuine concern, her method of gathering information was illegal and a breach of privacy. Thus, she could be prosecuted under Austrian law for violating telecommunication secrecy.

______________________________________________________________________

### **Misuse of Intercepted Data (§ 119a StGB)**

> **German:** Missbräuchliches Abfangen von Daten

**Definition:**
This act covers obtaining data from a computer system that is not meant for the perpetrator, as well as the unauthorized use, sharing, or publication of that data for material gain or to cause harm.

**Key Elements:**

- **Unauthorized Intent:** The main objective is to personally or for another unauthorized individual access the contents of data.
- **Means of Data Transfer:** The data in question has been transmitted through a computer system.
- **Use of Device or Electromagnetic Capture:** The act of using a device attached to the computer system, made receptive to it, or intercepting the electromagnetic emissions from the computer system.

**Intent:**

- **Data Intrusion:** The aim is to gain unauthorized access to data, use it for personal gain or harm, make it accessible to another unauthorized individual, or publish it.
- **Material Gain or Harm:** The purpose revolves around either obtaining a financial benefit for oneself or another or causing harm to another party by using the intercepted data.

**Penalties:**

- Offenders can face up to **six months** in prison or a fine of up to **360 daily rates**.
- Prosecution can only proceed with the authorization of the victim.

### Example Case for Unauthorized Interception of Data (§ 119a StGB)

**Background:**
Anna, a junior IT specialist at a prominent tech company, discovered a loophole in the office's internal communication system. Intrigued by the potential knowledge she could gain and possibly wanting to expose some internal company secrets to a competitor for financial gain, she decided to exploit this vulnerability.

**Action Taken:**
Anna attached a small device, which she had configured, to the company's central communication server. This device was designed to intercept and record all data being transmitted through the system without being detected.

**Discovery:**
A few weeks later, confidential product designs, financial reports, and strategic plans started appearing on competitor websites and insider forums. The company's IT department conducted a thorough investigation, eventually locating Anna's device.

**Legal Implications:**
Anna's actions are in direct violation of § 119a StGB as she had:

- Used a device attached to the computer system to intercept data transmissions without authorization.
- Acted with the intention to gain unauthorized knowledge of data not intended for her and use that data for financial gain or to inflict harm on the company.

By sharing the intercepted data with competitors for personal profit, Anna infringed upon the company's rights and can be prosecuted under Austrian law for illicitly intercepting data.

______________________________________________________________________

### **Misuse of Audio Recording or Eavesdropping Devices (§ 120 StGB)**

> **German:** Mißbrauch von Tonaufnahme- oder Abhörgeräten

**Definition:**
This provision deals with the misuse of audio recording or eavesdropping devices to illicitly capture non-public expressions not intended for the perpetrator's knowledge or to unlawfully distribute or publish such recordings.

**Key Elements:**

- **Use of Devices:** Utilizing audio recording or eavesdropping equipment.

- **Type of Expression:** The targeted expression is non-public and not meant for the perpetrator's awareness.

- **Telecommunication Transmission:** Recording a message transmitted via telecommunication which isn't intended for the listener.

**Intent:**

- **Unauthorized Knowledge Acquisition:** The goal is to obtain knowledge of someone else's non-public statement without authorization, either for oneself or another unauthorized person.

- **Unauthorized Distribution or Publication:** Making such recordings available to third parties without the speaker's consent, or publishing the same.

**Penalties:**

- **Direct Eavesdropping:** Those who directly eavesdrop can face a punishment of up to **one year** in prison or a fine of up to **360 daily rates**.

- **Unauthorized Distribution:** Making unauthorized recordings available to third parties or publishing them can lead to similar penalties as direct eavesdropping.

- **Telecommunication Misuse:** Illegally recording telecommunication transmissions not meant for the listener can result in up to **three months** in prison or a fine of up to **180 daily rates**.

- Prosecution can only proceed with the authorization of the victim.

### Example Case for Misuse of Audio Recording or Eavesdropping Devices (§ 120 StGB)

#### **Background:**

Julia is a journalist trying to break into the competitive world of investigative journalism. She believes that a particular politician has been involved in questionable deals and wants to gather evidence to support her story.

#### **Action Taken:**

To gather evidence, Julia discreetly places a small microphone under the table during a private meeting between the politician and a suspected lobbyist. The device records their entire conversation, which includes discussions about potential unethical arrangements and financial dealings.

#### **Discovery:**

Julia publishes her story, complete with audio evidence, making headlines and causing a major scandal. However, the politician, outraged and feeling violated, quickly determines that the audio must have been recorded without his knowledge. He files a complaint, and the authorities are able to trace the recording device back to Julia.

#### **Legal Implications:**

Julia's actions are a direct breach of § 120 StGB as she:

- Used an eavesdropping device to gain unauthorized knowledge of a private conversation.
- Published the audio recording without the consent of the recorded parties.

Even though Julia believed she was acting in the public interest, her methods of gathering evidence were illegal. She could face penalties under Austrian law for her unauthorized recording and dissemination of private conversations.

______________________________________________________________________

### **Data Tampering (§ 126a StGB)**

> **German:** Datenbeschädigung

**Definition:**
This provision deals with the intentional damage or alteration of computer data, either processed automatically, transmitted, or provided, which one does not have the right (or full right) to access or use.

**Key Elements:**

- **Illicit Action on Data:** This involves changing, deleting, rendering unusable, or suppressing computer data without appropriate authorization.

- **Extent of Damage:** The consequences of the tampering can range from minor damages to significant financial losses or impactful disruptions, especially if critical infrastructure is affected.

- **Means of Access:** In some cases, the manner in which the tampering is executed (using specific computer programs, passwords, access codes, and so on) decides the severity of the crime.

**Intent:**

- **Intent to Damage:** The main intent behind the act is to inflict harm by tampering with the data, whether through modification, deletion, or other methods.

**Penalties:**

- **Basic Offense:** Damaging data without any of the aggravating factors can lead to up to **six months** in prison or a fine of up to **360 daily rates**.

- **Significant Financial Loss:** If the tampering results in damage exceeding **5,000 Euro**, the perpetrator can face up to **two years** in prison.

- **Impacting Multiple Computer Systems:** Using specific tools or methods to tamper with many computer systems can result in up to **three years** in prison.

- **Major Violations:** Acts causing damage exceeding **300,000 Euro**, affecting essential parts of the critical infrastructure, or committed as a part of a criminal organization can result in a prison term ranging from **six months to five years**.

### Example Case for Data Tampering (§ 126a StGB)

#### **Background:**

Lukas, an employee at a bank, becomes disgruntled after being passed over for a promotion. Believing he has been unfairly treated and wanting to get back at his employer, he contemplates exploiting his IT privileges.

#### **Action Taken:**

Lukas manipulates the bank's transaction system to reroute small amounts of money from thousands of transactions into his personal account. He believes that the small amounts will go unnoticed. Over time, these amounts sum up to a considerable sum.

#### **Discovery:**

Customers start noticing discrepancies in their bank statements and raise concerns. The bank initiates an internal audit and identifies the irregularities in the transaction patterns. They trace the unauthorized changes back to Lukas through system logs.

#### **Legal Implications:**

Lukas's actions are in direct violation of § 126a StGB as he:

- Manipulated automation-supported data without the proper authorization.
- Acted with the intent to harm the bank and to unlawfully enrich himself.

Given the substantial financial loss to the bank and its customers due to Lukas's actions, he can be prosecuted under Austrian law for tampering with data and causing financial damage.

______________________________________________________________________

### **Disruption of Computer System Functionality (§ 126b StGB)**

> **German:** Störung der Funktionsfähigkeit eines Computersystems

**Definition:**
This provision addresses the significant disruption of the functionality of a computer system by introducing or transmitting data, especially when the disruptor does not have the right to control or access said system.

**Key Elements:**

- **Disruption:** It involves significant disturbance in the operational capability of a computer system.

- **Means of Disruption:** The act may be done through the input or transmission of data. This especially becomes severe when using specific computer programs, passwords, access codes, etc.

- **Extent of Disruption:** Consequences can vary, from short-term disturbances to long-term, lasting disruptions, and in some cases, substantial financial losses or impacts on critical infrastructure.

**Intent:**

- **Intent to Disrupt:** The primary objective is to seriously disrupt the functionality of a computer system.

**Penalties:**

- **Basic Offense:** Causing disruption without the aggravating circumstances can lead to up to **six months** in prison or a fine of up to **360 daily rates**.

- **Long-term Disruption:** Causing a disruption that lasts for an extended period can result in up to **two years** in prison.

- **Impacting Multiple Computer Systems:** If the disruption affects many computer systems using specific tools or methods, it can lead to up to **three years** in prison.

- **Major Violations:** Acts causing damage exceeding **300,000 Euro**, targeting systems that are a core component of the critical infrastructure, or committed as a part of a criminal organization can result in a prison term ranging from **six months to five years**.

### Example Case for Disruption of Computer System Functionality (§ 126b StGB)

#### **Background:**

Eva, a talented but disgruntled software developer, is unhappy with her company's new policies. In her displeasure, she decides to design a script that would disrupt the company's primary web service, hoping to create chaos and express her dissatisfaction.

#### **Action Taken:**

Eva deploys her script on the company's servers. The script automatically overloads the servers by making thousands of requests per second, causing the company's website to crash and become inaccessible to customers and other users.

#### **Discovery:**

The company's customers and partners begin reporting difficulties accessing the website. The IT department, in a frantic response, traces the source of the abnormal traffic and isolates Eva's malicious script. Further investigation into the system logs points towards Eva's involvement.

#### **Legal Implications:**

Eva's actions are in direct violation of § 126b StGB as she:

- Severely disrupted the functionality of a computer system without authorization.
- Created a prolonged disruption by making the company's primary service inaccessible.

Considering the potential financial and reputational loss for the company due to the disruption, Eva can be prosecuted under Austrian law for her deliberate actions against the computer system's functionality.

______________________________________________________________________

### **Misuse of Computer Programs or Access Data (§ 126c StGB)**

> **German:** Missbrauch von Computerprogrammen oder Zugangsdaten

**Definition:**
The law criminalizes actions related to computer programs, devices, passwords, or access data designed for or adapted to commit specific computer-related offenses.

**Key Elements:**

- **Types of Tools/Data:**

  - Specific **computer programs** or comparable devices designed for:
    - Data Tampering (§ 126a)
    - Disruption of Computer System Functionality (§ 126b)
    - Fraudulent Misuse of Data Processing (§ 148a)
  - **Computer passwords, access codes**, or similar data allowing access to computer systems or parts of it.

- **Prohibited Actions:** Creating, importing, distributing, selling, making accessible, procuring, or possessing the mentioned tools or data with intent for misuse.

**Intent:**
To use the mentioned tools or data in committing specific computer-related offenses.

**Penalties:**

- **Basic Offense:** For actions concerning computer programs or access data meant for Data Tampering, Disruption of Computer System Functionality, or Fraudulent Misuse of Data Processing: up to **six months** in prison or a fine of up to **360 daily rates**.

- **Grave Offenses:** If the act relates to:

  - Illegal computer system access (§ 118a)
  - Violation of telecommunication secrecy (§ 119)
  - Illicit data interception (§ 119a)
    the penalty can be up to **two years** in prison. Similarly, if the act is in relation to:
  - Severe Data Tampering (§ 126a Abs. 2 to Abs. 4)
  - Major Disruption of Computer System Functionality (§ 126b Abs. 2 to Abs. 4)
  - Grave Fraudulent Misuse of Data Processing (§ 148a Abs. 2 to Abs. 4)
    the same penalty applies.

- **Prevention:** No penalties if the perpetrator voluntarily prevents the misuse of the mentioned computer programs, devices, or data for the described offenses as per §§ 118a, 119, 119a, 126a, 126b, or 148a. If there's no threat of misuse or if it's eliminated without the perpetrator's involvement, they are exempt from punishment, provided they genuinely attempt to prevent misuse.

- **Critical Infrastructure:** For acts concerning tools or data capable of affecting essential parts of the critical infrastructure (§ 74 Abs. 1 Z 11): up to **three years** in prison.

### Example Case for Misuse of Computer Programs or Access Data (§ 126c StGB)

#### **Background:**

Lukas, an independent software developer, stumbles upon a powerful hacking tool on the dark web. Seeing an opportunity for personal financial gain, he decides to acquire and use this tool to gain unauthorized access to various online platforms, including e-commerce websites.

#### **Action Taken:**

Lukas uses the hacking tool, which exploits vulnerabilities in web platforms, to gain unauthorized access to e-commerce accounts. He then gathers users' personal and financial details. In addition, he sells a version of the hacking tool online, promoting its efficiency and capabilities.

#### **Discovery:**

After multiple reports of suspicious activities on their accounts, some users contact the affected e-commerce platforms. These platforms collaborate and conduct an investigation, tracing back the unauthorized access to Lukas's activities. Additionally, a cybersecurity firm identifies and exposes the sale of the hacking tool online, linking it back to Lukas.

#### **Legal Implications:**

Lukas's actions are in direct violation of § 126c StGB as he:

- Produced, distributed, and made accessible a computer program specifically designed to commit fraudulent data processing abuses and unauthorized access.
- Possessed and used unauthorized access codes and passwords to gain entry into e-commerce accounts, infringing on personal data.

Given the severity of his actions, Lukas can face prosecution under Austrian law for misuse of computer programs and access data, endangering personal and financial security of numerous individuals.

______________________________________________________________________

### **Fraudulent Misuse of Data Processing (§ 148a StGB)**

> **German:** Betrügerischer Datenverarbeitungsmißbrauch

**Definition:**
This section criminalizes the act of intentionally influencing the result of an automated data processing operation in order to illicitly enrich oneself or another, causing financial harm to someone else.

**Key Elements:**

- **Methods of Influence:**

  - Manipulating the program.
  - Inputting, altering, deleting, suppressing, or transmitting data.
  - Other interactions affecting the data processing operation.

- **Intent:**
  The primary motive should be unlawful enrichment of oneself or another.

**Penalties:**

- **Basic Offense:** For directly influencing data processing with the intent of illegal enrichment: up to **six months** in prison or a fine of up to **360 daily rates**.

- **Aggravated Offense:**

  - If the act is committed as a part of a business operation or causes financial damage exceeding **5,000 Euros**: up to **three years** in prison.
  - If the financial damage exceeds **300,000 Euros**: imprisonment ranging from **one to ten years**.

- **Unlawful Data Actions & System Disruptions:**
  If the offense involves illicitly inputting, altering, deleting, suppressing, or transmitting data, or unlawfully hindering or disrupting the functionality of a computer system: up to **three years** in prison.

- **Criminal Associations:**
  If the act is committed as a member of a criminal association: imprisonment ranging from **six months to five years**.

This section delineates the legal consequences for various forms of fraudulent misuse of data processing and ties into related offenses and penalties specified in other sections, like the misuse of computer programs (§ 126c StGB) and system disruptions (§ 126b StGB).

### Example Case for Fraudulent Misuse of Data Processing (§ 148a StGB)

#### **Background:**

Eva, an accountant at a well-established corporation, realizes the potential of manipulating the company's financial data to redirect funds to her personal account. Having knowledge of the company's financial software and inspired by her personal financial needs, she decides to manipulate the automated payment system.

#### **Action Taken:**

Eva designs a subtle script that skims a minor percentage from various transactions and accumulates these amounts into her own account. Given the vast number of daily transactions, she believes this would go unnoticed while resulting in a substantial amount over time.

#### **Discovery:**

After several months, discrepancies in financial reports are noticed by the company's auditors. A detailed forensic audit reveals the discrepancies in payment processing and traces back the irregularities to Eva's script.

#### **Legal Implications:**

Eva's actions are in direct violation of § 148a StGB as she:

- Influenced the result of an automated data processing procedure through unauthorized alterations.
- Acted with the intention to unlawfully enrich herself at the company's expense, causing financial damage to the corporation.

By tampering with the data processing system for personal gain, Eva has committed fraudulent misuse of data processing and can be prosecuted under Austrian law.

______________________________________________________________________

### **Unauthorized Access to Data of a Non-Cash Payment Method (§ 241h StGB)**

> **German:** Ausspähen von Daten eines unbaren Zahlungsmittels

**Definition:**
This provision criminalizes the act of accessing or 'spying' on non-cash payment data.

**Key Elements:**

- **Unauthorized Access:** The intentional act of accessing or spying on data associated with non-cash payment methods.

- **Intent:** The act must be committed with the intention of:

  - Illegally enriching oneself or another through the use of the accessed data.
  - Enabling oneself or another to forge non-cash payment methods.

**Penalties:**

- **Basic Offense:**

  - Unauthorized access with the intent to use the data for illegal enrichment or to facilitate forgery: up to **one year** in prison or a fine of up to **720 daily rates**.

- **Aggravated Offense:**

  - If the act is committed as a part of a business operation: up to **three years** in prison.
  - If committed as a member of a criminal association: imprisonment ranging from **six months to five years**.

- **Exemption from Penalty:**
  Offenders are not liable if they voluntarily prevent the illicit use of the accessed data by notifying the authorities or the rightful owner, or in any other manner, before the data is used illicitly. If there is no risk of illicit use or the risk has been eliminated without the offender's intervention, they won't be punished if they earnestly and voluntarily attempt to eliminate the risk, even if they're unaware that there's no risk.

This section elucidates the legal implications of unauthorized access to data associated with non-cash payment methods and ties into related offenses specified in other sections, such as the forgery of non-cash payment methods (§ 241a StGB).

### Example Case for Unauthorized Access to Data of a Non-Cash Payment Method (§ 241h StGB)

#### **Background:**

Lucas is a tech-savvy individual who frequents local coffee shops. He notices that many patrons use their credit cards for payments. Knowing about vulnerabilities in certain point-of-sale (POS) systems, Lucas hatches a plan to exploit these weaknesses.

#### **Action Taken:**

Lucas creates a discreet device that he secretly connects to a POS terminal in one of the coffee shops. This device is designed to capture and store the credit card details of every transaction made through the affected terminal.

Over the course of a month, Lucas accumulates a substantial list of credit card details. He uses some for personal online purchases and sells others in the dark web for a profit.

#### **Discovery:**

Several patrons of the coffee shop begin noticing unauthorized transactions on their credit card statements. Upon reporting this to their respective banks, an investigation is launched. The banks identify the common point of purchase for many affected cardholders as the particular coffee shop.

The coffee shop management then commissions a security review of their POS systems, during which Lucas's device is discovered.

#### **Legal Implications:**

Lucas's actions directly contravene § 241h StGB as he:

- Spied on data of non-cash payment methods with the explicit intention of illicitly enriching himself.
- Enabled fraudulent transactions and potentially the creation of counterfeit non-cash payment methods.

Given his capture and sale of the credit card data, Lucas could face prosecution under Austrian law, risking up to a year in prison for basic violations. However, his involvement in the commercial sale of the data might lead to a more severe sentence of up to three years or more if he's found to be part of an organized crime group.

## Resources

- <https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=bundesnormen&Gesetzesnummer=10002296>
