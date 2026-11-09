# Assignment 1: Verified AI-Assisted Triage

## Objective

You will run a scanner against a vulnerable application you host yourself, hand the raw
findings to a locally running language model for triage, and then measure how much of what
the model told you is true. Afterwards you will be able to use model assistance on scanner
output without letting an unverified claim reach a report, and you will have a personal
number for how often the model is wrong.

## Logistics

- **Work:** individual.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module21_Assignment1.pdf`.
- **Length:** about four to six pages plus appendix. The appendix holds your raw command
  output and the model transcript.

## Setup

Everything runs on your own machine. Nothing costs money and no special hardware is needed.

- **Target:** one deliberately vulnerable web application you host yourself, on an
  RFC 1918 address. OWASP Juice Shop or DVWA in Docker is the simplest route, and your
  instructor may hand you a container image instead.

  ```bash
  # Example: Juice Shop in Docker, reachable only from your own machine.
  docker run --rm -p 127.0.0.1:3000:3000 bkimminich/juice-shop
  ```

- **Scanner:** Nuclei, from lecture 4. Keep structured output.

  ```bash
  nuclei -u http://127.0.0.1:3000 -jsonl -o findings.jsonl
  ```

- **Model:** a local model via `ollama`, as in lecture 1. Do not use a hosted API: lecture
  4.6 and 5.6 explain why lab and client data does not go to a third party, and a local
  model keeps this assignment free.

  ```bash
  ollama pull llama3.1      # or the smallest model your machine actually runs
  ```

  A model of this size wants roughly 8 GB of RAM and is slow on a CPU-only laptop. Slow is
  fine here; a weaker model makes the hallucinations easier to see, which is the point.

- **Helpers:** `jq`, and a proxy or `curl` for manual verification.

## Rules of engagement

- **In scope:** only the target you started yourself, on `127.0.0.1` or your own lab
  network.
- **Out of scope:** the school network, any live site, any classmate's machine, and the
  public internet. A hosted demo instance of Juice Shop that someone else runs is also out
  of scope.
- Scanning a system you do not own is unauthorized access under StGB §118a, and data
  interference and damage fall under §126a and §126b. The scanner does not care that you
  meant well. Module 01 has the detail.

## Tasks

### 1. Build and document the lab

Start the target and the model. Record in your report: the target application and version,
its address and port, the model name and size, and the output of `hostname` and `docker ps`
(or `ps`) on your machine. This ties the rest of the report to your own run.

**Deliverable:** a short Setup section with that output pasted in.

### 2. Establish the raw baseline before any summarisation

Scan the target, keep `findings.jsonl`, and record the counts *before* a model sees
anything:

```bash
wc -l findings.jsonl
jq -r '.info.severity' findings.jsonl | sort | uniq -c | sort -rn
```

**Deliverable:** the total finding count and the count per severity, as a table, with the
commands and their output in the appendix. Everything later is compared against this.

### 3. Model triage

Hand the findings to the local model and ask it to group them by probable root cause and to
draft one short paragraph per group.

**Deliverable:**

- The exact prompt you used.
- The groups the model produced, with the number of findings it placed in each.
- A one-line comparison: do the group sizes add up to your baseline total from task 2? If
  findings went missing, say how many and which severity they were. Lossy summarisation is
  the expected result, not a mistake on your part.

### 4. Verify five findings by hand

Pick five findings spanning the severity range, including the highest severity your scan
actually produced and at least one informational one. Verify each one yourself: reproduce it
against the target and capture the request and the response, or demonstrate it is a false
positive.

**Deliverable:** this table, filled in, plus the raw request and response for each row in
the appendix.

| Finding | Model's claim | What you did to verify | Verified result | Verdict |
| ------- | ------------- | ---------------------- | --------------- | ------- |

The verdict is one of *confirmed*, *false positive*, or *unverifiable with the evidence I
have*. The third verdict is a legitimate answer and must not be dressed up as either of
the others.

### 5. Resolve the model's references

Ask the model for a CVE identifier and a remediation step for at least three of the
findings or detected components. Then resolve each one yourself against the
[NVD](https://nvd.nist.gov/) or the vendor advisory.

**Deliverable:** a table with one row per reference: the identifier the model gave, whether
it exists, whether it applies to the version actually running, and the URL of the advisory
you checked. State the same for each remediation step: does that configuration directive or
patched version exist in that product?

### 6. Conclusions a reader can use

Two short sections:

- **Your hit rate.** Of the five verified findings and the references from task 5, how many
  did the model get right? Name the error pattern in one or two sentences. Over-confidence
  and under-confidence are different problems and have different fixes.
- **Your own verification rule.** Write, in your own words, the rule you will apply before
  a model's claim enters a report, and mark which of your own findings in this assignment
  would have failed it.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Lab and baseline** | 15% | Target, model and host documented from your own run, with raw total and per-severity counts captured before any summarisation. |
| **Triage** | 15% | Prompt shown, groups listed with sizes, and the comparison against the baseline done honestly, including findings the summary lost. |
| **Manual verification** | 30% | Five findings across the severity range, each with the request and response you captured and a defensible verdict, false positives included. |
| **Reference resolution** | 20% | Every model-supplied identifier and remediation step checked against the NVD or the vendor, with the advisory URL and the version it applies to. |
| **Conclusions and report** | 20% | A stated hit rate with a named error pattern, a usable verification rule, and a report that a classmate could repeat from. |
| **Bonus** | +20% | See below. |

A report whose findings rest only on the scanner or the model, with no captured request and
response, cannot score above half on the verification row, however well it is written.

## Bonus: variant hunting in source

Juice Shop and DVWA ship their own source code, so you can do the second half of lecture
4.4 as well.

1. Run a pattern-based static scan over the application source and keep the structured
   output:

   ```bash
   semgrep --config auto --json --output semgrep.json ./path-to-app-source
   ```

2. Pick one real flagged finding. Paste the surrounding code into the local model and ask
   the question that actually pays off: *what else in this codebase follows the same unsafe
   pattern that the rule did not match?*
3. Check every place it names. Report how many were real variants, how many were invented,
   and quote one genuine variant with its file and line.

Full bonus marks require that the variant you quote exists in the source and that you show
the rule did not already flag it.
