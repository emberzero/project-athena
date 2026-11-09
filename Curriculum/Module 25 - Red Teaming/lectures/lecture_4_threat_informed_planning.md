# Threat-Informed Planning

A red team could attack an organisation in countless ways. Which ones it chooses determines whether the engagement tells the organisation something useful. If the scenarios come from the testers' favourite methods, the result says more about the testers than about the threat. Threat-led frameworks therefore separate two jobs: an independent threat intelligence provider first works out who is likely to attack this organisation and how, and the red team then plans its test on that basis.

This lecture follows that path from threat intelligence to scenarios to a test plan, and introduces MITRE ATT&CK as the common language that lets threat intelligence analysts, red team, blue team and management talk about the same attack. It stays at the level of planning and reporting. How individual techniques work is the subject of the technical modules.

## Threat Intelligence as Input

Threat intelligence is analysed information about threats: who the attackers are, what they want, how they operate and how likely they are to target a given organisation. For a red team engagement it answers three questions.

**Who would attack us?** The provider identifies **threat actors** that are relevant for the organisation: groups that have attacked similar organisations in the same sector or region, or that pursue goals the organisation would serve. Module 24, Lecture 3 describes how state actors and criminal groups are tracked. Typical categories are organised crime, state-sponsored groups, hacktivists and insiders.

**What would they want?** Motivation links an actor to the organisation's flags. A criminal group wants money, so it goes for payment systems or for data it can use for extortion. An espionage group wants designs or negotiation documents. A hacktivist wants visibility, so a defaced website or a leak matters more than a quiet theft.

**What could they find out about us?** The provider also looks at the organisation from the outside, the way an attacker would: its public footprint, the people and roles that are visible, its suppliers and the technologies it uses. This uses only public sources and is itself part of the agreed scope. Module 02 covers the techniques; in a regulated test they are carried out by the contracted provider under the rules of engagement, not by anyone else.

In TIBER-EU and under the DORA standards, the result is the **targeted threat intelligence report**. Useful general sources that every security team can read include the annual ENISA Threat Landscape report, publications of national CERTs such as CERT.at, and sector-specific information sharing groups.

## From Threat to Scenario

A **scenario** describes one realistic attack in a few paragraphs: who the attacker is, what they want, where they start and which flag they aim for. A test usually contains two to four scenarios, chosen so that together they cover the most important threats and the agreed flags.

A scenario typically records:

| Element | Example |
| --- | --- |
| Threat actor | Financially motivated criminal group that has attacked several Central European banks |
| Motivation | Fraudulent payments, or extortion with stolen customer data |
| Starting point | No access; the attacker starts from the internet |
| Flag | Ability to approve a payment in the payment system |
| Expected path (tactics) | Initial access through staff, persistence, credential access, lateral movement towards the payment environment |
| Why it is relevant | Same sector and region as recent incidents; the organisation recently changed its payment platform |

### Starting points and assumed breach

A real attacker may try for months to get a foothold. A test has a fixed budget and time window, so the control team decides for each scenario where it starts. Two common choices:

- **Full scenario:** the red team starts from outside with no access and has to get in by itself. This tests prevention and detection at the perimeter, including staff.
- **Assumed breach:** the red team starts with access that a real attacker could plausibly obtain, for example a standard user account and a laptop, provided by the control team. This spends the test budget on what happens inside, which is often where detection is weakest.

Both are legitimate. The choice is a governance decision, recorded in the test plan with its reason, because it changes what the result proves. An assumed-breach scenario says nothing about whether an attacker could have got in; a full scenario that fails at the perimeter says nothing about the inside.

## The Red Team Test Plan

The red team turns the scenarios into a **red team test plan**. Under the DORA standards the testers prepare it in consultation with the control team, the threat intelligence provider and the test managers, and the control team and the authority approve it. It contains, for each scenario, the planned approach at tactic level, the flags, the expected timeline, the planned leg-ups if the red team gets stuck, and the risks of the planned actions with measures to control them.

For the governance side, the test plan is the document that management and the control team approve and the reference against which the test is later judged. It does not need to describe exact procedures; it needs to be clear enough that the control team understands what will happen and can recognise when the red team leaves the plan.

## MITRE ATT&CK as a Common Language

**MITRE ATT&CK** (Adversarial Tactics, Techniques and Common Knowledge) is a publicly available knowledge base of attacker behaviour observed in real incidents, maintained by the US non-profit MITRE. It is organised in levels:

- **Tactics** describe *why* an attacker does something: the goal of a step, such as getting in, staying in or moving around.
- **Techniques** and sub-techniques describe *how* the goal is reached.
- **Procedures** are the specific implementations used by a particular group.

ATT&CK also documents **groups** (threat actors and the techniques attributed to them) and **mitigations** and **detections** for each technique.

For planning and reporting at management level, the tactic level is usually enough. At the time of writing, the Enterprise matrix (ATT&CK content version 20.1) has 15 tactics:

| Tactic | The attacker's goal |
| --- | --- |
| Reconnaissance | Gather information to plan the attack |
| Resource Development | Set up infrastructure, accounts or capabilities for the attack |
| Initial Access | Get into the network |
| Execution | Run their own code |
| Persistence | Keep their foothold |
| Privilege Escalation | Gain higher permissions |
| Stealth | Avoid being noticed |
| Defense Impairment | Weaken or disable defences |
| Credential Access | Steal account names and passwords |
| Discovery | Learn about the environment |
| Lateral Movement | Move through the environment |
| Collection | Gather data of interest |
| Command and Control | Communicate with compromised systems |
| Exfiltration | Steal data |
| Impact | Manipulate, interrupt or destroy systems and data |

Older material, including other modules of this curriculum, shows 14 tactics with a single tactic called *Defense Evasion*. Recent versions of ATT&CK split it into *Stealth* and *Defense Impairment*. ATT&CK is updated regularly, so always state which version a plan or report refers to.

### Why a common language helps

- **Threat intelligence to plan:** the threat intelligence report describes what a group typically does in ATT&CK terms; the red team plans its scenario in the same terms. Anyone can check that the plan matches the threat.
- **Plan to report:** the red team reports each step it took against the tactic it served. The control team can see where the test followed the plan and where it deviated.
- **Red to blue:** the blue team can map each step to what it saw, which turns "we did not notice" into a precise statement about which part of the attack was invisible.
- **Comparison over time:** if every test is reported against ATT&CK, the organisation can see whether detection improves from one engagement to the next.

ATT&CK is a catalogue, not a test methodology and not a checklist. A red team that tries to "cover every technique" is not emulating a realistic attacker. The scenarios come from threat intelligence; ATT&CK is how they are described.

## Measuring Detection Coverage

The main value of a red team engagement is what it reveals about detection and response. To make that measurable, every step of the attack is assessed from the defender's side. A simple scale:

| Outcome | Meaning |
| --- | --- |
| **Prevented** | A control blocked the step |
| **Detected and responded** | An alert fired, an analyst investigated, and action was taken |
| **Detected, no response** | An alert fired but was closed, ignored or not escalated |
| **Logged only** | The activity is in the logs, but nothing raised an alert |
| **Not visible** | No log or sensor captured the activity |

Summarised per tactic and per scenario, this shows where the defence is strong and where it is blind. Two further numbers are often reported: the **time to detect** (from the first action of a step to the first alert) and the **time to respond** (from the alert to containment).

Three cautions apply:

- **Coverage is not a count of rules.** A heat map that colours a technique green because a detection rule exists says nothing about whether the rule fires in this environment, whether anyone looks at the alert, and whether the response works. A red team engagement tests exactly that.
- **One test is one sample.** A step that went undetected once may be detected next time, and vice versa. Results show tendencies, not guarantees.
- **"Logged only" is the most useful result.** It means the data is there and a detection can be built quickly. "Not visible" means a sensor or log source is missing, which takes longer to fix.

## Conclusion

Threat-informed planning starts with threat intelligence about the actors that are relevant for the organisation, their motivation and what they could learn about it. From that come a small number of realistic scenarios, each with an actor, a starting point and a flag, and a red team test plan that the control team approves. MITRE ATT&CK provides a common language at tactic level that connects threat intelligence, plan, report and blue team observations, and allows detection coverage to be measured per tactic and compared over time. The final lecture covers what happens after the covert test ends.

## Resources

- **MITRE ATT&CK**: <https://attack.mitre.org/>
- **MITRE ATT&CK Enterprise tactics**: <https://attack.mitre.org/tactics/enterprise/>
- **ENISA Threat Landscape**: <https://www.enisa.europa.eu/>
- **CERT.at**: <https://www.cert.at/>
- **TIBER-EU guidance on the targeted threat intelligence report and the red team test plan**: <https://www.ecb.europa.eu/paym/cyber-resilience/tiber-eu/html/index.en.html>
