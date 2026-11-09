# Scoping and Rules of Engagement

A red team engagement deliberately does things that would be crimes without permission, on production systems, while the people responsible for those systems are kept in the dark. That combination is only acceptable if the boundaries are written down, approved by the right people, and known to everyone who needs to know them. The documents that do this are the authorisation, the scope and the rules of engagement. They protect the organisation from damage, the testers from prosecution, and uninvolved third parties from being attacked by accident.

Module 03, Lecture 2 introduces rules of engagement and authorisation for penetration tests. This lecture builds on it and covers what is different in a red team engagement: the wider scope that includes people and buildings, the secrecy towards the blue team, and the control team that has to manage both.

## Authorisation

Testing without permission is a criminal offence. In Austria the relevant provisions of the Criminal Code are covered in Module 01, in particular **§ 118a StGB** (unauthorised access to a computer system), § 119 and § 119a (interception), § 126a (data damage), § 126b (disruption of a computer system) and § 126c (misuse of programs or access data). A red team only acts lawfully if the person who is entitled to dispose of the systems has agreed in advance.

The authorisation must therefore be:

- **written** and signed, never only verbal;
- **signed by someone who has the authority to grant it**, normally the management body. A CISO alone usually cannot authorise a test of the whole organisation, and certainly not a test that includes social engineering of staff or entering buildings;
- **specific** about the organisation, the scope, the time window and the permitted activities;
- **limited to what the organisation can authorise.** A company can permit a test of its own systems and premises. It cannot permit a test of systems that belong to someone else.

The last point causes most problems. Cloud services, outsourced data centres, managed service providers, shared office buildings and software-as-a-service platforms belong to third parties. They are out of scope unless the third party has agreed, or the contract and the provider's published testing policy allow it. The same applies to employees' private devices and private accounts, which are never part of the scope.

### The authorisation letter

Red teamers who test physical security or speak to staff in person carry an **authorisation letter**, informally called a "get out of jail letter". It states that the bearer is acting on behalf of the organisation, names a person in the control team who can confirm this by phone at any time, and is signed by management. If a tester is stopped by security staff or the police, the letter and the phone call settle the situation. The letter does not override the law. It only proves that the owner agreed. Whoever checks it should verify it by calling a number they look up themselves, because a forged letter is an obvious social engineering trick.

## Scope

The scope of a red team engagement is defined differently from that of a penetration test. A penetration test scope lists systems: IP ranges, URLs, applications. A red team scope starts from the **business**: which critical functions are tested, which flags represent success, and which ways of attack are permitted. The systems follow from that.

A scope specification typically records:

| Element | Example |
| --- | --- |
| Critical functions | Online banking, payment processing, customer data management |
| Flags | Read access to the customer database; ability to approve a payment in the payment system |
| Permitted attack surface | Internet-facing systems, email to staff, phone calls to the service desk, physical access to the head office lobby |
| Excluded systems | Systems of the outsourced card processor, the building management system, all systems in the branch offices |
| Excluded people | Members of the control team, staff on sick leave or parental leave, external visitors |
| Excluded activities | Denial of service, destruction or encryption of data, real financial transactions, anything affecting physical safety |
| Time window | Twelve weeks starting on an agreed date; no activity during the year-end closing |

Explicit exclusions are as important as inclusions. Systems are usually excluded because a failure would be dangerous (medical devices, industrial controls, safety systems), because they belong to a third party, or because they are so fragile that the risk outweighs the benefit. An exclusion should be recorded with its reason, because it also says something about the organisation: a critical system that nobody dares to test is a risk in itself.

### People in scope

Social engineering is part of most real attacks, so it is part of most red team engagements (see Module 22). Testing people raises questions that testing servers does not:

- **Personal data.** Collecting information about employees and sending them phishing emails is processing of personal data under the GDPR. The organisation needs a legal basis and must keep the data to the minimum required.
- **Works council.** In Austria and Germany, measures that monitor or assess employees can require the involvement of the works council. Whether a specific red team activity falls under these rules is a legal question; the control team should clarify it with the legal department before the test, without revealing more than necessary.
- **Fairness.** Results are reported in aggregate. No individual is named or disciplined because they clicked on a link or held a door open. People who fell for a well-made pretext are not the problem; missing processes and controls are.
- **Limits.** Pretexts that exploit fear, family emergencies, health or private life are excluded. Testers do not contact employees outside work or through private channels.

## Rules of Engagement

The rules of engagement (RoE) turn the scope into operating rules for the test. Module 03 lists the minimum content for a penetration test. For a red team engagement, the following points need particular care.

### Communication

- How and how often the red team reports to the control team. The DORA standards require at least weekly progress updates during the active test.
- Which channels are used. They must be out of band, so that a compromised mailbox or a monitored chat does not reveal the test to the blue team.
- How identities are confirmed, for example with an agreed code word, so that nobody can impersonate the control team or the red team.

### Emergency contacts

A contact list with names, roles and phone numbers for the control team lead, a deputy, the red team lead, and someone who can make business decisions at night and on weekends. The list says who may order a stop and who must be informed when one happens.

### Stop conditions

Situations in which the red team stops immediately and calls the control team. Typical stop conditions:

- evidence that a real attacker is or was present in the environment;
- an outage or unexpected behaviour of a production system, whether or not the red team caused it;
- access to data that is clearly out of scope, for example health data or the private files of employees;
- any risk to physical safety;
- a third party outside the scope being affected;
- the test being about to become public, for example through media enquiries.

After a stop, the control team decides with the red team whether, when and how the test continues. The decision and its reasons are documented.

### Risk management for the test

The DORA standards require the tested entity to manage the risks of the test itself. A risk assessment for the engagement covers questions such as: what happens if a production system fails during the test, if the blue team escalates to an authority, if test data leaks, or if the red team's own infrastructure is compromised? For each risk, the RoE define a measure, for example a restriction on certain actions, a backup check before the test, or a procedure for escalations.

### Leg-ups

A **leg-up** is help that the control team gives the red team so that the test can continue, for example an account on an internal system or a planted device, when the red team cannot get further in reasonable time. The DORA standards define a leg-up as assistance or information provided by the control team to the testers, used only where no reasonable alternative exists. A leg-up is not a failure of the test. It reflects that a real attacker may have more time or luck than a 12-week test allows. Every leg-up is documented and appears in the report, because it changes what the result means.

### Data handling

- The red team collects only the data it needs to prove progress towards a flag. "Proof of access" is usually a screenshot of a directory listing or a marker file, not a copy of the data.
- Any data that must be taken is encrypted, stored only on agreed systems, and deleted at an agreed date, with a written confirmation.
- Credentials that the red team obtains are used only within the scope and are reset at the end of the test.
- Reports are classified and distributed on a need-to-know basis. A red team report is a guide to attacking the organisation.

### Proving a flag safely

The RoE define how each flag is demonstrated without harm. "Approve a payment" may be proven by reaching the approval screen with a test transaction prepared by the control team, never by approving a real payment. "Stop the production line" may be proven by showing the access that would allow it, with the control team present, never by stopping it.

## Deconfliction

Sooner or later the blue team may notice something. It might be the red team, or it might be a real attacker who happens to be active at the same time. **Deconfliction** is the process of finding out which, without revealing the test unnecessarily.

A typical procedure:

1. The blue team escalates a suspected incident as usual. A member of the control team is in the escalation chain, or the escalation reaches the control team quickly.
1. The control team compares the alert with the red team's activity log, which records every action with a timestamp and the infrastructure used. For this reason the RoE require the red team to keep a complete and accurate log.
1. **If it is not the red team**, it is treated as a real incident. The red team pauses, and the blue team and incident response proceed normally.
1. **If it is the red team**, the control team decides. Often the best choice is to let the blue team continue its response for a while, because watching the response is part of the test. At a defined point, for example before the incident is reported externally or before significant costs arise, the control team steps in.

The external reporting point is critical. A blue team that believes it is facing a real attack may want to inform the police, the national CERT, the data protection authority or, under DORA and NIS2, the supervisor. The control team must stop a false report from leaving the organisation, and it must do so without blocking the report of a real incident. This requires that the control team is reachable at all times during the test and that someone senior enough to make the decision is part of it.

When a test is revealed, the control team decides whether it can continue in a modified form or ends early. Being caught is not a failed test. It shows that detection worked, and the closure phase will show how well.

## Conclusion

A red team engagement is lawful only with a written authorisation from someone entitled to give it, limited to systems and premises the organisation controls. The scope starts from critical functions and flags, and explicit exclusions protect fragile systems, third parties and people. The rules of engagement define communication, emergency contacts, stop conditions, risk management for the test, leg-ups, data handling and how flags are proven without harm. Deconfliction lets the control team tell the red team from a real attacker and keep false reports from reaching authorities. All of this is the control team's responsibility. The next lecture turns to the content of the test: which scenarios the red team plays and why.

## Resources

- Module 01, Lecture 2, for the Austrian criminal law provisions
- Module 03, Lecture 2, for rules of engagement in a penetration test
- **TIBER-EU Control Team Guidance**: <https://www.ecb.europa.eu/paym/cyber-resilience/tiber-eu/html/index.en.html>
- **GDPR**: Regulation (EU) 2016/679, available on EUR-Lex
