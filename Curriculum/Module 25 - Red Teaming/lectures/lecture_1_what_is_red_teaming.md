# What Red Teaming Is

The term "red team" comes from military exercises, where one group plays the opponent so that the other side can practise against something that thinks and adapts. In IT security it has become a marketing word, attached to everything from an automated scan to a six-month covert operation. This lecture pins it down. It separates red teaming from vulnerability scanning and penetration testing, explains what "objectives-based" and "adversary emulation" mean, and introduces the teams that take part in an engagement.

The difference matters for more than vocabulary. A company that orders a red team engagement when it needed a penetration test pays a lot of money to learn that its unpatched servers are unpatched. A company that orders a penetration test when it wanted to know whether its security operations centre works gets a long list of findings and no answer to its actual question.

## Three Kinds of Security Test

Module 03, Lecture 1 compares test types from the tester's point of view. From the point of view of the organisation that commissions a test, the key differences are these:

| | Vulnerability scan | Penetration test | Red team engagement |
| --- | --- | --- | --- |
| **Question** | Which known weaknesses exist? | How far can an attacker get in this system? | Would we detect and stop a real attacker with a real goal? |
| **What is tested** | Systems | Systems and applications in a defined scope | People, processes and technology of the whole organisation |
| **Who knows** | Everyone | IT and usually the defenders | A small control team only; defenders are not told |
| **Approach** | Automated, broad | Manual, as many findings as possible in the scope | Covert, goal-driven, only what is needed to reach the objective |
| **Duration** | Hours | Days to a few weeks | Months, including preparation |
| **Result** | List of vulnerabilities | Findings ranked by risk | Story of the attack, detection and response gaps, lessons for the defence |
| **Good for** | Hygiene, regular checks | New systems, compliance, before go-live | Mature organisations that want to test detection and response |

The three are not a ladder that every organisation climbs in order, but a red team engagement makes little sense before the basics work. If a scan finds hundreds of critical issues, a red team will find an easy way in on the first day, and the expensive part of the engagement, observing detection and response, never happens. A common rule of thumb is that an organisation should have a functioning security monitoring capability and an incident response process (Module 13) before it orders a red team.

## Objectives-Based Testing

A penetration test asks "what is wrong with this system?". A red team engagement asks "can an attacker achieve *this specific outcome*?". The outcome is agreed in advance and is called an **objective** or, in TIBER-EU and the DORA standards, a **flag**. Typical flags describe business harm, not technical milestones:

- Read the customer database of the online banking platform
- Change a payment order before it is sent to the clearing system
- Gain the ability to stop the production line
- Obtain the source code of the flagship product

Flags make an engagement measurable. Either the red team reached the flag or it did not, and in both cases the interesting question is how far it got before anyone noticed. They also limit the engagement: a red team that found an unrelated weakness on the way does not keep digging there, because it does not bring it closer to the flag. Flags are usually set on **critical or important functions**, the business processes whose failure would hurt the organisation most. Under DORA this term has a legal meaning (Lecture 2).

Flags describe what the red team must *demonstrate*, not what it must *do*. Demonstrating that a payment order could be changed does not mean changing a real one. The rules of engagement define how a flag is proven safely, for example by placing a harmless marker file or by showing access to a test record (Lecture 3).

## Adversary Emulation

A red team does not attack "like a hacker" in general. It behaves like a specific type of attacker that is realistic for this organisation. This is called **adversary emulation**. A regional bank may be most threatened by financially motivated criminal groups that steal credentials and manipulate payments. An engineering company with valuable designs may be most threatened by state-sponsored espionage. A hospital may be most threatened by ransomware.

The type of attacker determines how the red team works: how patient it is, which ways in it tries, how much effort it puts into staying hidden, and what it does once inside. The input for this decision is **threat intelligence**: information about which actors target organisations like this one, with which goals and methods (Lecture 4). In regulated frameworks, an independent threat intelligence provider prepares this input before the red team starts.

Some sources distinguish *emulation* (reproducing the behaviour of a named, real group as closely as possible) from *simulation* (behaving like a plausible attacker without copying a specific group). Both are used in practice, and the distinction matters less than the principle: the scenario is chosen because it is realistic for this organisation, not because it is what the testers know best.

## The Teams

Engagements are described with colours. The names are not standardised everywhere, but the following use is common and matches the European frameworks.

| Team | Who | Role |
| --- | --- | --- |
| **Red team** | External testers or a dedicated internal team | Plays the attacker, tries to reach the flags within the rules of engagement |
| **Blue team** | Security operations centre, IT operations, incident responders | Defends the organisation as on any other day; is **not told** about the test |
| **White team / control team** | A few senior people in the tested organisation | Plans and steers the test, knows about it, keeps it secret, decides when to pause or stop |
| **Purple team** | Red and blue team working together | Not a separate team but a way of working: after the covert test, both sides go through the attack together to improve detection |

### Red team

The red team is usually an external provider, because it needs skills that few organisations have in-house and because an outside view is more independent. Some large organisations have their own internal red team. DORA allows internal testers under conditions (Lecture 2). Whoever does it, the red team works under a written authorisation and rules of engagement and reports to the control team throughout the test.

### Blue team

The blue team is everyone who would defend the organisation against a real attack. The point of the engagement is to see how they perform under realistic conditions, so they must not know about it. This is hard on the people involved: they may spend nights on what they believe is a real incident. Good engagements treat the blue team as a partner, not as a target. The goal is to find gaps in detection and response, not to blame individuals, and the blue team gets its own report and a full debrief at the end (Lecture 5).

### White team or control team

The term **white team** comes from exercises and is still widely used. The updated TIBER-EU framework and the DORA standards call the same group the **control team**, led by a **control team lead**. The control team consists of staff of the tested organisation who know the organisation well, are senior enough to make decisions, and have access to the management board. It should be as small as possible, because every additional person who knows about the test makes it less realistic.

The control team is the most important governance element of a red team engagement. It approves the scope and the test plan, is the red team's contact during the test, decides about pauses and stops, provides help to the red team when it is stuck (a **leg-up**, Lecture 3), and handles the situation when the blue team escalates a red team action as a real incident. In this module "control team" is used for this role; "white team" means the same thing.

### Purple teaming

Purple teaming means that red and blue work together openly: the red team shows what it did, the blue team checks what it saw, and together they improve detection. It is not a replacement for a covert red team test, because the blue team cannot show how it reacts to a surprise once it knows what is coming. TIBER-EU allows purple teaming in the testing or the closure phase; the DORA standards make it a mandatory part of closure, after the covert test has ended. Lecture 5 covers it in detail.

## Who Orders a Red Team, and Why

Red team engagements are commissioned by management, usually on the recommendation of the CISO, and the management body is informed about the test before it starts (see Module 26, Lecture 1 on accountability). Typical reasons:

- **Regulation:** significant financial entities in the EU must carry out threat-led penetration testing under DORA (Lecture 2).
- **Assurance:** the board wants evidence that the security investment of recent years actually works against a realistic attacker.
- **Testing the security operations centre:** a new SOC or a managed detection service is tested before the organisation relies on it.
- **After an incident:** to check whether the measures taken since then would stop the same attacker.

A red team engagement is expensive and puts stress on the organisation. It is the right tool when the question is about detection and response across the organisation. For finding vulnerabilities in a specific application, a penetration test is cheaper and more thorough.

## Conclusion

A vulnerability scan lists known weaknesses, a penetration test shows how far an attacker gets in a defined scope, and a red team engagement tests whether the organisation detects and stops a realistic attacker who pursues a business-relevant goal. Red teams work towards agreed flags and emulate attackers that threat intelligence shows to be realistic. Four groups take part: the red team attacks, the blue team defends without knowing about the test, the control team steers and protects the test, and in the end red and blue work together as a purple team. The next lecture shows how European regulators have turned this into a formal framework.

## Resources

- **TIBER-EU framework and guidance documents**: <https://www.ecb.europa.eu/paym/cyber-resilience/tiber-eu/html/index.en.html>
- **MITRE ATT&CK**: <https://attack.mitre.org/>
- Module 03, Lecture 1, for the tester's view of the different test types
- Module 13, Lecture 1, for the blue team's view of red teaming
