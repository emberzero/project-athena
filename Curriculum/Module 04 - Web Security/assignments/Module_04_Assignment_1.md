# Assignment 1: Web Security Academy Lab Portfolio

## Objective

You will exploit ten web vulnerabilities in PortSwigger's Web Security Academy labs and document
each one to the standard a penetration test report expects: the flaw, the payload, the impact and
the fix. Afterwards you will be able to recognise a vulnerability class from how an application
behaves, exploit it with Burp Suite, and explain to a developer what to change. The portfolio you
hand in is something you can show an employer.

## Logistics

- **Work:** individual. You may discuss concepts with classmates, but the labs you solve, the
  payloads you use and the text you write must be your own.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module04_Assignment1.pdf`.

## Setup

- **A PortSwigger account** at <https://portswigger.net/web-security>. Free; the labs and all the
  learning material cost nothing.
- **Burp Suite Community Edition**, free from <https://portswigger.net/burp/communitydownload>.
  Community is enough for every lab in this assignment. The Professional scanner is not required
  and you must not rely on it.
- **A browser** with Burp's proxy certificate installed, or Burp's built-in browser.
- Lectures 1 to 5 cover every vulnerability class you need. Nothing here needs hardware or money.

### Rules of engagement

The lab instances PortSwigger hands you are the only systems in scope. They are hosted for exactly
this purpose and each instance belongs to your account. Out of scope: the PortSwigger website
itself, any other website, anything belonging to the school, and your classmates' lab instances.
Do not run scanners or automated tooling against anything that is not a lab instance assigned to
you. Module 01 and Austrian StGB §118a, §126a and §126b cover why this line matters.

## Tasks

### 1. Choose and solve ten labs

- Solve **ten labs** rated **PRACTITIONER or EXPERT**. APPRENTICE labs are good practice but do not
  count towards the ten.
- The ten must come from **at least five different categories** (for example SQL injection, XSS,
  access control, SSRF, JWT, CSRF, path traversal, GraphQL).
- At least **three** must come from the server-side or API material in lectures 4 and 5.
- Record each lab's exact title, category and difficulty as shown on the Academy site.

Using the official solution after a genuine attempt is allowed and expected sometimes. If you did,
say so in that lab's write-up and state what you had missed. An undeclared copied solution is
plagiarism; a declared one costs you a small part of one lab's marks.

### 2. Write up each lab

Each of the ten write-ups contains, in this order:

1. **Lab identification:** title, category, difficulty, and the vulnerability class.
2. **The flaw:** what is wrong in the application and why it is exploitable. Two or three
   sentences, in your own words, not the lab description reworded.
3. **Exploitation:** the steps you took, with the exact payload or HTTP request in a code block.
   Include the raw request where it is relevant, not just a description of it.
4. **Evidence:** a screenshot showing the solved banner for that lab in your own browser session.
5. **Impact:** what an attacker gains against a real application with this flaw. Be specific about
   the data or the action, not "it is dangerous".
6. **Remediation:** the concrete change a developer should make. Name the API, function, header or
   configuration. "Validate input" on its own earns nothing; "bind the parameter via
   `cursor.execute(sql, params)` so the value never reaches the parser" earns full marks.
7. **Reflection:** one short paragraph. What took you longest, what the mistake was, and whether
   you consulted the official solution.

Map each lab to its OWASP Top 10 or OWASP API Top 10 category.

### 3. Assemble the report

Front matter: your name, the date, and a one-page table listing all ten labs with their category,
difficulty and OWASP mapping. Then the ten write-ups. Then one page of closing analysis answering:

- Which two vulnerability classes did you find hardest, and what specifically made them hard?
- Across your ten labs, which single remediation technique would have prevented the most of them?
  Justify it against your own findings.

Finish with a screenshot of your Academy progress page showing your completed labs.

Aim for roughly one to two pages per lab. Padding is visible and does not help.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Lab coverage** | 15% | Ten PRACTITIONER or EXPERT labs, five or more categories, at least three server-side or API, all solved and evidenced by the progress screenshot. |
| **Exploitation evidence** | 20% | Every write-up has the working payload or raw request in a code block and a solved-banner screenshot from the student's own session. |
| **Technical explanation** | 20% | The flaw explained correctly in the student's own words for all ten labs, including why the exploit works rather than only what was typed. |
| **Impact analysis** | 15% | Each lab's impact tied to a specific asset or action in a realistic application, with a correct OWASP mapping. |
| **Remediation** | 20% | Each fix names the concrete mechanism, API or configuration, and would actually close that specific flaw. |
| **Report quality and honesty** | 10% | Summary table complete, closing analysis answered with reference to the student's own findings, code and requests formatted as code, any use of official solutions declared. |
| **Bonus** | +20% | See below. |

A portfolio of ten solved labs with vague remediation scores far worse than one with eight labs and
fixes a developer could act on. The write-up is the deliverable; the flags are only the evidence.

## Bonus: Expert labs (up to +20%)

Solve **three additional EXPERT-rated labs** from at least two categories, in a clearly marked
section titled "Bonus: Expert Labs". Use the same write-up structure, and add to each:

- What specifically made it harder than a PRACTITIONER lab in the same category - a filter, a chain
  of two flaws, a timing constraint, a required exploit server.
- Any technique the lectures did not cover that you had to learn, with the source you learned it
  from cited.

### Bonus evaluation

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Completion** | +10% | Three EXPERT labs from two or more categories, solved and evidenced. |
| **Analysis of difficulty** | +6% | A precise account of what made each one harder, not a restatement of the steps. |
| **New technique** | +4% | At least one technique beyond the lectures explained correctly and attributed. |

## Resources

- PortSwigger Web Security Academy: <https://portswigger.net/web-security>
- Burp Suite documentation: <https://portswigger.net/burp/documentation>
- OWASP Top 10: <https://owasp.org/www-project-top-ten/>
- OWASP API Security Top 10: <https://owasp.org/www-project-api-security/>
- OWASP Cheat Sheet Series: <https://cheatsheetseries.owasp.org/>
