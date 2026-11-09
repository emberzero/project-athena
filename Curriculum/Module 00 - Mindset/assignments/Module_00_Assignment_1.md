# Assignment 1: The Challenge Log

## Objective

This assignment is not about solving a hard challenge. It is about documenting *how* you work when you are
stuck, which is the part of offensive security that nobody shows you. You will work through challenges on an
authorized practice platform, keep a timestamped log of every hypothesis and dead end, and then turn that log
into an honest account of your own curiosity, creativity and persistence, plus a plan for not burning out.

## Logistics

- **Work:** individual. You may talk to classmates, but the log must be your own session.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module00_Assignment1.pdf`.

## Setup

You need a free account on **one** authorized practice platform. All of these have a free tier and all of them
explicitly allow you to attack their machines:

- [OverTheWire](https://overthewire.org/wargames/) - no account needed, SSH only, entirely free. The
  recommended default if you have nothing else.
- [picoCTF](https://picoctf.org/) - free account, browser-based challenges.
- [TryHackMe](https://tryhackme.com/) - free tier, browser-based machine, no payment required.
- [Hack The Box](https://www.hackthebox.com/) - free tier.

Cost: zero. Hardware: none beyond the computer you already use. A terminal and an SSH client are enough for
OverTheWire; the other three run in a browser. If you want a Linux environment, a free VirtualBox or VMware
Workstation Player VM is sufficient, but it is not required for this assignment.

Your instructor may name a specific starting point. If not, pick one platform and tell your instructor which
one you chose before you start.

## Boundary

Everything in this assignment happens on the practice platform you registered on, or on a VM you built
yourself. That is the whole permitted scope.

- **Not in scope:** the school network, school servers, classmates' machines and accounts, your ISP's
  equipment, or any system on the public internet that is not part of the platform you registered on.
- Legality is covered in Module 01. Until then the short version: overcoming a security measure on a system
  you were not authorized to touch is an offence under StGB §118a, with §126a and §126b covering damage and
  disruption, regardless of how good your intentions were.

Breaking this boundary fails the assignment. The platforms exist precisely so that you do not have to.

## Tasks

### 1. Pick and solve

Solve at least **five** challenges on your chosen platform. At least one of them must be a challenge that
took you **more than 45 minutes** and that you did not get on the first attempt. That one is your *primary
challenge* and the rest of the assignment is built on it.

In the report:

- The platform, your username, and a screenshot of your own profile or progress page with the username
  visible.
- A table of the five challenges: name, what the challenge was about in one line, time spent, solved
  yes/no.
- The flag, password or answer for each solved challenge, exactly as the platform gave it to you.

### 2. The log for your primary challenge

While working the primary challenge, keep a running log. Do not reconstruct it afterwards; it reads
differently and the difference is visible. Each entry has four parts:

```text
HH:MM  hypothesis  - what I think is true, or what I think will work
       action      - the exact command, request or click
       observation - what actually happened (output, error, nothing)
       conclusion  - what this ruled in or out, and what I try next
```

Requirements:

- At least **eight** entries.
- At least **three** of them must be dead ends: things you tried that did not work. An assignment with no
  dead ends in it was either too easy or the log is fiction.
- Include the real error messages. Paste them, do not paraphrase.

### 3. Your research trail

List every source you consulted while stuck: man pages, official documentation, a blog post, a video, an
AI assistant, a classmate, a published write-up. For each one: what question you had, and what you had
already tried before you went looking.

If you read a full write-up or took a hint, say so plainly and say at which point you gave in. Doing that
honestly earns marks; hiding it does not, and an instructor can tell.

### 4. The second route

After you have solved the primary challenge, find a *different* way to the same result: another tool, another
protocol, a manual version of something a tool did for you, or a one-liner replacing five steps.

Then actually try it. Report the commands, the output, and whether it worked. A second route that failed, with
the reason you think it failed, counts for full marks here. A second route you only described does not.

### 5. Reflection on the three traits

One short paragraph per trait: curiosity, creativity, persistence. Each paragraph must point at a specific
numbered entry in your own log and say what happened there. No general statements about the field. If a
sentence in this section would still be true if somebody else had written it about their own work, cut it.

### 6. Staying in this for longer than a semester

Lecture 3 lists habits that prevent burnout. Pick **three** that are realistic for you, and for each one:

- What you will actually do, concretely enough that someone could check it.
- One measurable checkpoint in the next eight weeks (for example: "by week 6 I have solved at least one
  challenge per week and logged it", or "no challenge work after 22:00 on school nights").

Then one paragraph: describe the moment in this assignment where you were most frustrated, what you did about
it, and whether that worked. If you were never frustrated, pick a harder primary challenge.

## Evaluation Criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Challenge evidence** | 15% | Five challenges solved, profile screenshot with your own username, correct flags or answers for each, time per challenge recorded. |
| **Log quality** | 30% | Eight or more entries in the four-part format, at least three genuine dead ends, real command output and error messages pasted in, and the sequence of entries actually explains how you got from stuck to solved. |
| **Research trail** | 15% | Every source named with the question behind it and what you had tried first; any hint or write-up used is declared openly and placed correctly in the timeline. |
| **The second route** | 15% | A genuinely different approach, attempted, with commands and output shown, and a clear statement of whether it worked and why. |
| **Reflection** | 15% | Each of the three traits tied to a specific log entry from your own session, no generic filler, and the frustration paragraph is specific about what you did. |
| **Sustainability plan** | 10% | Three habits chosen with concrete actions and checkpoints that someone else could verify in eight weeks. |
| **Bonus** | +20% | See below. |

A report that is clearly a cleaned-up story written after the fact, with every step working on the first try,
is marked down under **Log quality** even if the flags are correct.

## Bonus: Publish it, or fail it properly

Pick **one** of the two.

### Option A: The write-up

Turn your primary challenge into a write-up of the quality you would publish under your own name: it has to
be readable by someone who has not solved the challenge, explain *why* each step works rather than just
listing commands, and include the wrong turns. Add a screen recording of two to four minutes in which you
solve the challenge from scratch and narrate what you are doing. Link the recording or hand it in alongside
the PDF as your instructor prefers.

### Option B: The unsolved one

Pick a challenge on your platform that is clearly above your current level and spend at least 90 logged
minutes on it **without solving it**. Hand in the log, plus:

- What you learned about the system or protocol even though you never got in.
- The three most plausible next steps you have not tried yet, each with a reason.
- What specific knowledge gap is blocking you, and where you would go to close it.

Failing a challenge and knowing exactly why you failed is worth more than another easy flag. This option is
graded on the quality of the reasoning, not on the outcome.
