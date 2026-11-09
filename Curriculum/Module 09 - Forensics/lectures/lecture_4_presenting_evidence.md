# Presenting Digital Evidence

An investigation that nobody can follow has produced nothing. The report is the deliverable: it is
what management acts on, what counsel reads, and what the opposing expert attacks. This lecture
covers how to write it, how to keep claims proportionate to the evidence, and what happens when the
findings are presented to people who are not technical.

## 4.1 Know the Audience

The same investigation produces different documents.

| Audience | Wants | Length |
| -------- | ----- | ------ |
| Management | Impact, scope, what to do now, cost | One page |
| IT and security staff | Indicators, affected systems, remediation steps | A few pages |
| Legal counsel | What is provable, by which artefact, and how solid it is | Full report |
| Court or arbitration | Method, reproducibility, limitations, qualifications | Full report plus appendices |

Write one report with a layered structure rather than four separate documents that will drift apart.
Executive summary first, findings next, method and raw output in appendices. Each layer must be
consistent with the others, because somebody will read only one of them.

## 4.2 Report Structure

A structure that works, and that a reader can navigate without being told how:

1. **Cover and case identification.** Case number, examiner, dates, who requested the work.
2. **Authorisation and scope.** Who authorised it, in writing, when; which systems and which time
   window; what was explicitly out of scope.
3. **Executive summary.** The answer, in plain language, in under a page. No tool names, no hex.
4. **Evidence inventory.** Every item: identifier, description, serial number, acquisition hash,
   acquisition method, who held it when.
5. **Method.** Tools with versions, and what each was used for. Enough that a reader with the same
   image can repeat it.
6. **Findings.** Observations, each tied to the artefact it came from, in a sensible order,
   usually chronological.
7. **Timeline.** The consolidated sequence of events, in UTC.
8. **Conclusions.** What the findings support, with the confidence stated.
9. **Limitations.** What could not be determined, and why.
10. **Appendices.** Tool output, hash lists, photographs, full timeline exports.

### 4.2.1 The Executive Summary

Four questions, answered directly:

- What happened?
- What was affected?
- What is still unknown?
- What should be done now?

A summary that requires the reader to understand NTFS has failed. Write it last, when you know what
the answer is.

## 4.3 Writing a Finding

A finding separates three things that get fatally mixed together in bad reports: the observation,
the interpretation, and the confidence.

```text
  Observation      what the artefact literally contains
  Interpretation   what that means, and why
  Confidence       how firmly the observation supports the interpretation
```

Weak:

> The attacker exfiltrated the customer database on 2 March using a backdoor they had installed
> earlier.

Strong:

> **Observation.** The Prefetch file `ARCHIVER.EXE-1A2B3C4D.pf` on item 09-001 records a last run
> time of 2026-03-02 14:11:07 UTC. An NTFS `$MFT` entry for `C:\Temp\export.7z` has a creation
> timestamp of 2026-03-02 14:11:22 UTC and a recorded logical size of 1.4 GB. The Zeek `conn.log`
> for the same host shows an outbound TLS connection to 203.0.113.x beginning 2026-03-02 14:26:40
> UTC with approximately 1.4 GB sent.
>
> **Interpretation.** An archive was created on the host and a comparable volume of data was
> transferred outbound shortly afterwards. The content of the transfer could not be recovered
> because the connection was encrypted and no decryption material was available.
>
> **Confidence.** Moderate-to-high that data of this size left the host. The identity of the data is
> inferred from the archive's size and creation time, not from its content, which was not recovered.

The second version is longer, and it is the one that survives cross-examination. It also makes the
weak link, the identity of the transferred data, explicit instead of letting a reader assume it was
established.

### 4.3.1 Language

- Use the artefact's name, not a vague category: "`$UsnJrnl` entry", not "file system records".
- Attribute to accounts and hosts, not to people, unless you have evidence about the person. "The
  `jdoe` account" is a fact; "Jane Doe" is a conclusion about who was using it.
- Quantify where you can, qualify where you cannot. "Approximately 1.4 GB" is honest; "a large
  amount of data" is not useful.
- Say "could not be determined" when that is the case. It is a legitimate result.
- Avoid words that carry conclusions you have not proven: *stolen*, *hacker*, *obviously*,
  *clearly*, *deliberately*.
- Do not hedge everything into mush either. A finding you are confident about should read confident.

### 4.3.2 Confidence

Use a scale and define it in the report. Three levels are enough:

- **High**: multiple independent artefacts agree, and no plausible benign explanation fits.
- **Moderate**: the evidence supports the conclusion, but rests on one source or admits another
  reading.
- **Low**: consistent with the conclusion but equally consistent with something else; stated as a
  possibility, not a result.

Tie confidence to corroboration, not to how strongly you feel about it.

## 4.4 Limitations

The limitations section is where credibility is earned. Reporting what you could not do makes the
rest believable. Common entries:

- **Encryption.** Content was encrypted; no key was available.
- **Volatile data lost.** The host was powered off before acquisition, so memory could not be
  captured.
- **Log retention.** Logs covered only N days; the relevant window is partly outside it.
- **Clock skew.** The host's clock was measured as X seconds off; timestamps from it were adjusted,
  or not, and this is which.
- **Scope.** Systems that were likely relevant but outside the authorisation.
- **Acquisition method.** The image was taken live and is therefore not internally consistent.
- **Carved data.** Recovered content has no filename, path or timestamp.
- **Attribution.** Evidence shows account activity, not who was at the keyboard.

Attribution is the limitation that gets overstated most often. Shared credentials, unattended
sessions, stolen tokens and spoofed source addresses all break the chain between an account and a
human being.

## 4.5 Visual Presentation

Use a figure when it shows a relation prose cannot. A timeline chart, a diagram of how hosts
connect, a comparison of two timestamp sources. Not a screenshot of a tool window because it looks
technical.

Rules for figures in a forensic report:

- Caption with the source: which image, which artefact, which tool.
- Keep the data readable, including in black and white, and do not rely on colour alone.
- Never crop a screenshot in a way that removes context. That is the sort of thing an opposing
  expert will find.
- Put full tool output in an appendix, extract the relevant lines into the body.

For a presentation rather than a document: one idea per slide, the timeline as the spine, and no
reading of hex dumps aloud. Keep the deep technical material in reserve for questions.

## 4.6 Peer Review Before Release

Every report should be read by a second examiner before it leaves the team. The reviewer checks:

- Does every finding cite an artefact?
- Does the executive summary say anything the findings do not support?
- Are the hashes in the inventory the ones in the acquisition records?
- Are times consistent, and all in the stated zone?
- Is interpretation separated from observation?
- Would somebody with the image and the method section get the same result?

This is cheap, and it catches the two most common failures: a conclusion that grew stronger between
the findings section and the summary, and a timestamp converted twice.

## 4.7 Testifying and Being Challenged

In Austria, technical questions in court are usually put to a court-appointed sworn expert
(*allgemein beeideter und gerichtlich zertifizierter Sachverständiger*). As an internal examiner you
are more likely to be the person whose report that expert reviews, or to be questioned about your
own work. Either way the exposure is the same: your conclusion gets examined and so does the method behind it.

What challenges target:

- **Chain of custody.** Gaps, broken seals, unsigned transfers.
- **Integrity.** A hash that does not verify, or was never taken.
- **Tool validity.** Whether the tool does what you say. Answer by explaining the artefact, not by
  citing the tool's output as authority.
- **Alternative explanations.** A benign reading of the same data. Address the plausible ones in the
  report yourself, before someone else does.
- **Competence and bias.** Your qualifications, and who pays you.

Practical conduct: answer the question asked, say "I do not know" when you do not, do not speculate
beyond the report, correct an error immediately and visibly. A corrected mistake costs one finding.
A defended mistake costs the report.

## 4.8 Data Protection in the Report Itself

The report is itself a processing of personal data.

- Include what the finding needs. A whole mailbox in an appendix because it was easy to export is
  not proportionate.
- Pseudonymise third parties who are not subjects of the investigation.
- Distribute on a need-to-know basis, store it encrypted, and set a retention period for the report
  and the images both.
- Keep in mind that the person investigated may have data subject rights in respect of the report.

Module 01 covers the legal detail; the practical consequence here is that the appendix is curated,
not a data dump.

## 4.9 Exercise

Using the analysis you did in Lecture 3's exercise on your own lab image:

1. Write a one-page executive summary answering the four questions in 4.2.1. No tool names.
2. Write three findings in observation / interpretation / confidence form. At least one must end up
   at low or moderate confidence; if everything is high, you are overstating.
3. Write the limitations section. Aim for at least four honest entries.
4. Build the evidence inventory with real hashes from your acquisition.
5. Swap reports with another student and run the 4.6 checklist against theirs. Report back on which
   check caught something.

## Key Takeaways

- Layer the report: summary for management, findings for engineers, method and appendices for
  reviewers and counsel. One document, consistent at every layer.
- Keep observation, interpretation and confidence visibly separate in every finding.
- Cite the specific artefact, not a vague category. Attribute to accounts and hosts, not to people.
- State confidence on a defined scale, tied to corroboration, and be willing to write "could not be
  determined".
- The limitations section builds credibility rather than undermining it. Attribution is the limit
  most often overstated.
- Have a second examiner review the report before release; it reliably catches overreach in the
  summary and double-converted timestamps.
- Under challenge, defend the method and the artefact, not the tool's verdict. Correct errors
  immediately.
- The report contains personal data. Include what is proportionate, pseudonymise bystanders, and set
  a retention period.

## Sources

- ISO/IEC 27042, *Guidelines for the analysis and interpretation of digital evidence*
- ISO/IEC 27043, *Incident investigation principles and processes*
- NIST SP 800-86, *Guide to Integrating Forensic Techniques into Incident Response*, on reporting
- SWGDE, *Best Practices for Digital Forensic Examination* and reporting documents:
  <https://www.swgde.org/documents>
- ENISA, *Electronic evidence: a basic guide for First Responders*:
  <https://www.enisa.europa.eu/publications/electronic-evidence-a-basic-guide-for-first-responders>
- Austrian register of court-certified experts: <https://sdgliste.justiz.gv.at/>
- Casey, *Digital Evidence and Computer Crime* (Academic Press)
