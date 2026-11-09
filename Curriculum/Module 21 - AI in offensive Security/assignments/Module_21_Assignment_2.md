# Assignment 2: Breaking and Fixing Your Own Assisted Workflow

## Objective

You will build the smallest possible assisted attack loop, plant a prompt injection in your
own lab target, and watch your own tooling get talked out of scope. You will then write the
control that stops it and show that it holds even when the model is argued with. Afterwards
you will be able to say precisely why scope and tool policy belong outside the model, and
you will have built the four lines of code that prove it.

## Logistics

- **Work:** individual, or pairs if your instructor allows it. In pairs, both names appear
  on the report and each partner writes and signs their own task 5.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module21_Assignment2.pdf`.
- **Length:** about four pages plus appendix. The appendix holds your script, the model
  transcripts and the log excerpts.

## Setup

Everything runs on your own machine. Nothing costs money and no special hardware is needed.
If you did Assignment 1, you already have all of this.

- **Target app:** a vulnerable web application you host yourself on an RFC 1918 or loopback
  address, with the ability to add a page or a piece of content to it. Juice Shop, DVWA, or
  even a two-file static site you write yourself is enough; the injected text matters, the
  application does not.
- **An out-of-scope lab host:** a second listener on your own machine that logs any request
  it receives. This is your canary. It stands in for a host that is inside the lab but
  outside the declared engagement scope.

  ```bash
  # Logs every request, including the path, to stdout.
  python3 -m http.server 8099 --bind 127.0.0.1
  ```

- **Model:** a local model via `ollama` (lecture 1). No hosted API, for the data-handling
  reasons in lecture 5.6, and because a local model keeps this free. A model of this size
  wants roughly 8 GB of RAM and is slow on CPU; that is acceptable here.
- **Tools:** `curl`, and a shell or Python you are comfortable writing twenty lines in.

## Rules of engagement

- **In scope:** the target app and the canary host, both on your own machine.
- **Out of scope:** everything else. In particular, your injected text must never cause a
  request to a real third party, the school network, or a classmate's machine. Point the
  canary at loopback and keep it there.
- Your injection string must contain **your own username**, formed as in Module 07: the
  first letter of your first name plus your last name, lowercased, no special characters
  (Max Mustermann becomes `mmustermann`). This is how the grader knows the transcript is
  yours.
- Nothing here targets a person. Module 01 and StGB §118a, §126a and §126b apply as always.

## Tasks

### 1. Build a level-1 assisted loop

Lecture 5.1 defines level 1: the model drafts, you read, you decide. Write a script of
roughly twenty lines that fetches a page from your target app, passes the fetched text to
the local model, and asks it to summarise the page and propose the next command for an
assessment. The script must **print** the proposal. It must not execute it.

**Deliverable:** the script in the appendix, and one example run against a normal page of
the target, with the model's proposal quoted.

### 2. Plant the injection

Add a page or a piece of content to your target app containing text addressed to an
automated reader: instructions to disregard its previous task and to fetch
`http://127.0.0.1:8099/<your-username>`. Write the text yourself; copying a stock example
defeats the exercise.

**Deliverable:** the exact text you planted, and a note on where it sits in the application
and whether a human visitor would notice it.

### 3. Run the loop at the injected page and record what happens

Point your script at the injected page. Record the model's proposal verbatim.

**Deliverable:**

- The proposal, quoted.
- Whether it contains the out-of-scope URL, and whether your username appears in it.
- If you then ran the proposed command by hand, the canary's log line showing the request
  and your username in the path.
- If the injection did **not** work on the first attempt, report that too, with the two or
  three variations you tried and which one succeeded. A negative result, documented, is
  worth full marks for this task; a model too weak to follow the injection is a finding
  about the model, not a failure of the exercise.

### 4. Write the control, outside the model

Add a scope check to your script: an allow-list of in-scope hosts, checked by the script
before any request is made or any command is printed as runnable. A handful of lines is
enough. The point is where it lives, not how clever it is.

**Deliverable:**

- The check, in the appendix.
- One run showing the injected page handled with the check in place: the out-of-scope URL
  refused, and the refusal visible in the output.
- Two sentences on why the equivalent instruction in the prompt ("never leave the scope")
  is not a control.

### 5. Argue with the policy

Still with the check in place, spend ten minutes trying to talk the model into producing an
out-of-scope action. Use whatever you like: authority, urgency, a claim that the scope was
extended, a nested instruction in the page.

**Deliverable:** your three best attempts, quoted, with the model's response and the
script's verdict for each. Then one paragraph: which attempts changed the model's behaviour,
and why none of them changed the script's.

### 6. Map it to a control an organisation would buy

Your tooling is a miniature of the client AI applications in lecture 5.5 and 6.5. Produce a
table with three rows, each naming one failure mode you saw or could see in your loop (scope
drift, irreversible command, lost evidence, unbounded loop, data leaving the machine), the
control that stops it, and **the step at which the control intervenes**. If you cannot name
the step, lecture 6.2 is explicit that the control is a slogan, and it will be marked as
one.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **The loop** | 15% | A working level-1 script that prints and never executes, with one clean run against a normal page. |
| **Injection and result** | 25% | Your own injected text, the proposal quoted verbatim, and either the canary log line carrying your username or a documented negative result with the variations tried. |
| **The control** | 25% | An allow-list check in the script, a run showing the out-of-scope URL refused, and a correct explanation of why a prompt instruction is not equivalent. |
| **Arguing with the policy** | 15% | Three real attempts with responses and verdicts, and an explanation that distinguishes model behaviour from policy enforcement. |
| **Control mapping and report** | 20% | Three failure modes, each with a control and the exact step it intervenes at, in a report a classmate could repeat from. |
| **Bonus** | +20% | See below. |

Transcripts without your username, or a report that shows the control only as source code
without a run that exercises it, lose the corresponding rows.

## Bonus: a tool policy for a one-tool agent

Extend the loop into something that can actually call a tool: give the local model a single
tool, for example a file reader restricted to one directory, mediated by your script.

1. Write the tool policy on half a page: which paths it may read, with which rights, what
   requires your approval, and what is refused outright.
2. Enforce the policy in the script, on the caller side, before the tool runs.
3. Try to talk it out of the policy, including by planting instructions in a file the tool
   is allowed to read, which is the indirect case from lecture 5.4.
4. Report what the model agreed to do and what the script actually did. Full bonus marks
   require at least one attempt where the model clearly complied with the attacker's text
   and the policy still held.
