# Assignment 1: Reverse Engineering a Keygen Checker

## Objective

You will reverse engineer a native x86-64 binary that validates a licence key for a given
username, reconstruct its key-checking algorithm, and compute a valid key for your own username.
Afterwards you will be able to take an unknown, unstripped ELF binary, locate the function that
makes a decision, read its logic in a decompiler, and verify your understanding by producing an
input that the program accepts.

## Logistics

- **Work:** individual. Your key is derived from your own name, so no two submissions are alike.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module07_Assignment1.pdf`.
- Submit the report only. Do not submit the binary or a patched copy of it.

## Setup

- **The target** is the file `main` in this `assignments/` folder. It is an unstripped ELF 64-bit
  PIE executable for x86-64 Linux. It prompts for a name, then for a key, and prints either
  `You win!` or `You lose!`.
- **A Linux x86-64 environment.** Any Linux VM works (the course Kali VM, a plain Debian or Ubuntu
  VM, or WSL2). The binary will not run natively on macOS or Windows.
- **Ghidra** (free, <https://ghidra-sre.org/>) for decompilation. It needs a JDK; the version
  required is stated in the Ghidra release notes. Lecture 3 covers the import and analysis
  workflow.
- **Command-line tools:** `file`, `strings`, `nm`, `readelf`, `objdump` - all part of `binutils`,
  which is installed on the course VMs. GDB for the bonus task.
- Nothing in this assignment costs money or needs hardware beyond a VM.

The binary is provided by your instructor for this course, so analysing it is authorised. That
authorisation covers this file only: do not point these techniques at software you neither own nor
were given. Module 01 and the legal section of lecture 1 cover why (Austrian StGB §118a, §126a and
§126b, plus the narrow copyright exceptions in UrhG and Directive 2009/24/EC).

## Your username

Your username is the first letter of your first name followed by your last name, all lowercase,
with special characters removed. Umlauts are transliterated (`ä` becomes `ae`, and so on).

- Max Mustermann becomes `mmustermann`
- Asa Mueller-Berg becomes `amuellerberg`

State your full name and the derived username at the top of the report. A key that is valid for a
different username earns no marks.

## Tasks

### 1. Triage

Run the command-line triage from lecture 3 before you open any GUI: `file`, `strings -n 6`, `nm`,
`readelf -h`, `ldd`.

**In the report:** the output of `file`, the three or four strings you expect to be anchors into
the code, and the names of the non-library functions that `nm` reveals. One sentence on whether the
binary is stripped or packed, and on what the symbol names already suggest about the algorithm.

### 2. Static analysis in Ghidra

Import the binary, run the default analysis, and find the comparison that decides between
`You win!` and `You lose!`. The fastest route is to cross-reference one of those strings.

**In the report:**

- The name and address of the function containing the decision.
- The decompiled pseudo-code of the key-checking logic, with your renamed variables. Ghidra's raw
  output with `uVar3` everywhere does not count as analysis; rename and retype as you read.
- A plain-language description of the algorithm: what the program does to the username to arrive at
  the expected key, step by step. This is the core of the assignment.
- Any transformation you had to confirm in the disassembly rather than in the pseudo-code, and why
  the pseudo-code was not enough.

### 3. Compute your key

Derive the valid key for *your* username. Do it by reimplementing the algorithm - a short Python or
C script is the expected route - not by brute force.

**In the report:**

- Your username, your key, and the script you used to generate it, as a code block.
- A terminal screenshot or a copy-pasted session showing the program accepting your username and
  key, with `You win!` visible.

### 4. Assessment

Answer each of these in at most half a page.

- The binary checks the key locally. Name one change to the design that would make your attack stop
  working, and explain why.
- Name one thing the developer could do that would raise your cost without fixing the underlying
  problem, and estimate how much longer it would have taken you.

## Deliverable checklist

Your PDF contains: your name, the date, your derived username, the triage output, the function
address and renamed decompilation, the algorithm description, your keygen script, your key, the
`You win!` evidence, and the two assessment answers.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Triage** | 10% | All five triage commands run with output shown, and a correct read of what the symbols and strings imply before any decompiler is opened. |
| **Algorithm description** | 30% | The key-checking algorithm described correctly and completely, step by step, so that a reader could reimplement it from the report alone. |
| **Decompilation evidence** | 20% | Correct function name and address, pseudo-code included with meaningfully renamed variables, and disassembly cited wherever the pseudo-code was ambiguous. |
| **Valid key** | 20% | The submitted key is valid for the submitted username, and the `You win!` evidence matches both. |
| **Keygen script** | 10% | A working script that derives the key from any username, not a hardcoded constant. |
| **Assessment and report quality** | 10% | Both assessment questions answered concretely; report structured and readable, with code and output formatted as code. |
| **Bonus** | +20% | See below. |

A key that is valid but unexplained scores the 20% for the key and little else. The explanation is
the assignment.

## Bonus: Debugger or patching (up to +20%)

Pick **one** of the two options.

### Option A: Dynamic confirmation with GDB

Use GDB to confirm your static reading without re-reading your Ghidra notes.

**In the report:** the breakpoint you set and why, `info registers` or `x/` output showing the
expected key in memory at the moment of the comparison, and the return value of the check for both
a wrong and a correct key. The binary is a PIE, so state how you reconciled the static addresses
with the runtime ones; lecture 4 covers `info proc mappings`.

### Option B: Patch the check

Work on a **copy** of the binary. Patch it so that any key is accepted.

**In the report:** the virtual address you changed, how you converted it to a file offset, the
original bytes, the new bytes, one sentence on why the change has that effect, and the
re-disassembly of the patched instruction. Show the patched copy accepting a deliberately wrong
key. Keep the patch the same length as the original instruction.

For either option, finish with two or three sentences: would your technique still work if the
validation ran on a server instead of on your machine?

### Bonus evaluation

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Technique** | +12% | The GDB session or the patch demonstrably works, with the evidence named above included. |
| **Precision** | +5% | Addresses, offsets and bytes stated exactly and internally consistent; PIE address reconciliation correct. |
| **Reflection** | +3% | The server-side question answered correctly and specifically. |
