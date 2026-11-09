# Policies, Awareness and Audits

The previous lectures described the structure: roles, a management system, risk management and the rules that require it. This lecture is about the everyday work that makes the structure real. Policies tell people what is expected of them. Awareness programmes make sure they understand it. Audits check whether it actually happens. Most of what a junior security professional does in a governance role falls into one of these three areas.

## Policies

### The document hierarchy

Security documentation is usually organised in levels. The names vary, but the idea is the same everywhere:

| Level | Purpose | Approved by | Changes | Example |
| --- | --- | --- | --- | --- |
| **Policy** | States *what* the organisation wants and *why* | Management body | Rarely | "All access to company systems requires individual accounts and strong authentication." |
| **Standard** | Makes the policy measurable: mandatory rules | CISO / ISB | Occasionally | "Passwords have at least 12 characters; MFA is mandatory for remote access and administrator accounts." |
| **Procedure** | Describes *how*, step by step | Process owner | Often | "How to request a new account and how IT creates it." |
| **Guideline** | Recommendations, not mandatory | CISO / ISB | Often | "Tips for choosing a good passphrase." |

At the top sits the **information security policy**, which ISO/IEC 27001 clause 5.2 requires. It is short, signed by top management, and states the objectives, the commitment to meet requirements and to improve, and the main responsibilities. Below it come topic-specific policies. Annex A control A.5.1 expects both.

Typical topic-specific policies are acceptable use, access control, passwords and authentication, classification and handling of information, backup, cryptography, mobile devices and remote working, supplier security, incident reporting and secure development.

### Writing a good policy

A policy that nobody reads or that nobody can follow is worse than no policy, because it creates a false sense of control and an obvious audit finding. Practical rules:

- **Short and clear.** One to three pages for a topic-specific policy. Write for the people who must follow it, not for auditors.
- **Fixed structure.** Purpose, scope, the rules themselves, responsibilities, exceptions, consequences of violations, owner, version and review date.
- **Mandatory language where it is mandatory.** "Must" for rules, "should" for recommendations. Never hide a rule in a recommendation.
- **Realistic.** If the policy forbids USB sticks but the production line needs them for firmware updates, people will break the rule, and the policy loses authority. Define a controlled exception instead.
- **Owned and reviewed.** Every policy has an owner and a review date, usually once a year or after a major change.
- **Communicated and acknowledged.** Staff must know where to find the policy, and for key policies they confirm that they have read it.

In Austria and Germany, policies that regulate how employees use IT, especially those that allow monitoring of their behaviour, involve the **works council** (*Betriebsrat*). Measures that can control employee performance generally require a works agreement (*Betriebsvereinbarung*). Involve HR and the works council early; a technically perfect policy that ignores labour law cannot be enforced.

### Exceptions

Every policy needs an exception process. An exception is requested in writing, justified, assessed for risk, approved by someone with the authority to accept that risk (Lecture 3), time-limited and recorded. An exception without an expiry date becomes a permanent hole.

## Security Awareness

People are part of most attacks: they click on phishing links, approve fraudulent payments, reuse passwords or leave laptops in trains. Module 22 covers the attacks; governance is responsible for the counterpart. ISO/IEC 27001 requires awareness in clause 7.3 and Annex A control A.6.3, and NIS2 Article 21 lists cyber hygiene and training.

An effective awareness programme:

- **Targets roles.** Finance staff need training on CEO fraud and payment redirection, developers on secure coding, administrators on privileged access, management on their own accountability (NIS2 Article 20 requires training for the management body).
- **Is continuous.** A yearly one-hour video is quickly forgotten. Short, regular formats work better: monthly tips, a two-minute module, a short discussion in team meetings.
- **Makes reporting easy.** The most important behaviour is not "never click", but "report quickly". A "report phishing" button and a team that thanks reporters, including those who clicked, give the security team early warning.
- **Is measured.** Useful metrics are the reporting rate, the time from the first click to the first report, and training completion. A falling click rate alone says little.

**Phishing simulations** are common, but they need care. They must be agreed with management, HR and in Austria and Germany usually the works council; results should be evaluated in aggregate, not used to punish individuals; and the simulation must not damage trust, for example by promising bonuses or using real crises as a lure. A simulation that humiliates staff teaches them to hide mistakes, which is the opposite of the goal.

## Audits

An audit is a systematic, independent check of whether requirements are met, based on evidence. In security governance there are several kinds:

| Type | Who | Purpose |
| --- | --- | --- |
| **Internal audit** (first party) | The organisation's own auditors, independent of the audited area | Required by ISO/IEC 27001 clause 9.2; finds problems before external auditors do |
| **Supplier audit** (second party) | A customer auditing its supplier | Checks that a supplier meets contractual security requirements |
| **Certification audit** (third party) | An accredited certification body | ISO 27001 certification (Lecture 2) |
| **Regulatory audit** | Authority or an auditor on its behalf | Checks compliance with NIS2, DORA or sector rules |
| **Technical audit** | Penetration testers, configuration reviewers | Checks whether controls actually work technically (Modules 04, 05, 13) |

**ISO 19011** gives guidance on auditing management systems. The core of every audit is evidence: documents, records, interviews, observations and technical checks. Auditors work with **samples**. They do not check every user account, but pick a sample of leavers from the past year and check whether their accounts were disabled on time.

### The audit process

1. **Planning:** scope, criteria (which standard or policy), schedule, auditors.
1. **Opening meeting:** confirm scope and schedule with the audited area.
1. **Evidence collection:** interviews, document review, sampling, observation.
1. **Findings:** each deviation is described with the requirement, the evidence and the gap.
1. **Closing meeting and report:** findings are presented and documented.
1. **Corrective action:** the audited area analyses the root cause and fixes it; the auditor checks the fix.

A good finding is specific: "Of 15 leavers sampled between January and June, 4 accounts were still active more than 30 days after the leaving date (requirement: access control policy, section 4.2; Annex A control A.5.18)." A finding like "access management needs improvement" helps nobody.

### Typical findings

Experienced auditors find the same problems again and again:

- The risk assessment was last updated more than a year ago.
- Accounts of leavers are not disabled on time; access rights are never reviewed.
- Backups exist, but restores are never tested.
- Policies exist but are outdated or contradict each other.
- The asset inventory is incomplete, especially for cloud services and shadow IT.
- Suppliers with access to sensitive data were never assessed.
- Management reviews are documented but no decisions were taken.

## Compliance in Practice

### Compliant is not the same as secure

Compliance means meeting the requirements of a law, standard or contract. Security means actually withstanding attacks. The two overlap, but an organisation can pass an audit and still be easy to breach, for example because the audit scope excluded the critical system, or because a control exists on paper and is not lived. The opposite also happens: a technically strong team that documents nothing fails its audit. The goal is security that can be demonstrated.

### Supplier assessments and TISAX

Most companies are asked about their security by their customers, through questionnaires, contract clauses or audits. In the German and Austrian automotive industry, the common approach is **TISAX** (Trusted Information Security Assessment Exchange), run by the ENX Association on the basis of the VDA ISA catalogue of the German Association of the Automotive Industry. A supplier is assessed once by an approved audit provider and shares the result with all its customers through the exchange, instead of answering a separate questionnaire for every carmaker. The catalogue is based on ISO/IEC 27001 and adds automotive topics such as prototype protection.

### Metrics and reporting

Management needs a regular, understandable picture of security. Useful metrics relate to risks and controls, for example: share of critical vulnerabilities fixed within the target time, share of systems with MFA, results of restore tests, open high risks and their age, open audit findings, and phishing reporting rate. Numbers without a target or a trend are hard to interpret; a short traffic-light report with three to five key points is often more useful to a management body than a long dashboard.

## Conclusion

Policies, awareness and audits turn a governance structure into daily practice. Policies are short, owned, realistic and organised in a hierarchy from the top-level policy down to procedures, with a controlled exception process; in Austria and Germany they often need the works council. Awareness programmes target roles, run continuously and reward reporting. Audits check, based on evidence and samples, whether requirements are met, and their findings feed the improvement cycle of the ISMS. Compliance is the minimum; the aim is security that works and can be shown to work.

## Resources

- **ISO 19011:2018**: Guidelines for auditing management systems
- **ENX Association (TISAX)**: <https://enx.com/>
- **BSI awareness material**: <https://www.bsi.bund.de/>
- **Österreichisches Informationssicherheitshandbuch**: <https://www.sicherheitshandbuch.gv.at/>
