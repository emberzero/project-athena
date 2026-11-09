# Assignment 2: Static and Dynamic Analysis of a Binary You Choose

## Objective

You will pick an unfamiliar binary yourself, triage it, decide on the basis of that triage whether
to attack it statically or dynamically, and then solve it with both approaches. You will also
compile a program of your own twice, with and without symbols and optimisation, to see from the
other side what the compiler takes away. Afterwards you will be able to plan an analysis of a
binary nobody has prepared for you, and to justify the order in which you did things.

## Logistics

- **Work:** individual, or in pairs. A pair submits one report naming both authors and stating who
  did which task.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module07_Assignment2.pdf`. A pair uses the
  name of the first author listed.
- Do not submit binaries, patched copies, or an archive. The report is the deliverable.

## Setup

- **A disposable Linux x86-64 VM with networking off** for everything in Task 2 and Task 3. You did
  not write the target, so treat it as hostile: snapshot before the first run, no shared folders,
  no clipboard sharing, no host credentials inside the VM. Lecture 1, "Working Safely", is the
  standard you are held to here.
- **Ghidra** (free, <https://ghidra-sre.org/>) and **GDB**, plus `binutils` for `file`, `strings`,
  `nm`, `readelf` and `objdump`. `ltrace` and `strace` may need installing; `gcc` is needed for
  Task 1.
- **Your target:** one binary from <https://crackmes.one/>, which publishes binaries specifically
  for this purpose. Choose a **Linux x86-64** entry rated at the lower end of the difficulty scale.
  Several thousand are available, so pick one nobody else in the class is likely to pick.
- Nothing here costs money or needs hardware beyond the VM.

### Rules of engagement

- Your only targets are the program you compile yourself in Task 1 and the one crackme you
  downloaded. Nothing else, and in particular nothing belonging to the school, to a classmate, or
  to a company whose software happens to be on your laptop.
- Do not publish your solution, and do not post it to the crackmes.one entry before the deadline.
- Module 01 and the legal section of lecture 1 cover the boundary: Austrian StGB §118a, §126a and
  §126b apply the moment analysis stops being local, and the copyright exceptions for study and
  interoperability are narrow.

## Tasks

### 1. What the compiler destroys

Write a small C program - 20 to 40 lines - that reads a string and accepts it only if it satisfies
two conditions, at least one of which is arithmetic. Compile it twice:

```bash
gcc -O0 -g -o check_debug check.c
gcc -O2 -s -o check_stripped check.c
```

**In the report:**

- Your `check.c` source.
- The output of `file` and `nm -C` for both builds, and a short table of what each tool shows for
  one build and not the other.
- Three or four sentences on which of your two conditions survived recognisably into the `-O2`
  disassembly of `check_stripped`, and which one the optimiser rearranged beyond easy recognition.

### 2. Triage and a written plan

Triage your crackme with the command-line tools from lecture 3, before opening Ghidra: `file`,
`strings -n 6`, `nm`, `readelf -h`, `ldd`, and `objdump -d` on the entry point.

**In the report:**

- The crackme's title, author, and the URL of its crackmes.one entry.
- The output of `file`, the size of the binary, whether it is stripped, and whether the
  strings-to-size ratio suggests packing or encryption. Say which signal told you.
- The three strings or imported functions you decided to use as anchors, and why those three.
- **A written plan, before you continue:** three to six numbered steps saying what you will do and
  in what order, and whether you are starting static or dynamic. Then, at the end of Task 4, come
  back and add two sentences on where the plan turned out to be wrong. An accurate plan is not
  required; an honest post-mortem is.

### 3. Dynamic analysis

Inside the VM, run the binary under `ltrace` and `strace`, then under GDB.

**In the report:**

- The `ltrace` or `strace` output, trimmed to the interesting lines, and one sentence per line on
  what it tells you. Say explicitly what the program touches: files, environment variables,
  network, nothing.
- One GDB session: the breakpoint you set, the address it resolved to, and register or memory
  output at that breakpoint that shows a value you could not read statically. If the target is a
  PIE, show how you reconciled the static and runtime addresses.
- If the binary resists the debugger, document the check that detects it and how you worked around
  it or why you chose not to. Anti-debugging is covered in lecture 2 and finding one counts in your
  favour here.

### 4. Solve it, two ways

Solve the crackme twice.

1. **Legitimately:** supply an input the program accepts, and explain in plain language why it is
   accepted. Include the input and a session showing the success message.
2. **By patching:** on a copy, patch the check so that any input is accepted. State the virtual
   address, the file offset and how you derived it, the original bytes, the new bytes, and the
   re-disassembly of the patched instruction. Keep the patch the same length as the original
   instruction.

**In the report** also include the decompiled validation function from Ghidra with your renamed
variables, and the address it lives at.

### 5. Assessment

Half a page each.

- Static or dynamic: which carried more of the work on this target, and what property of the binary
  made that so?
- Name the one change to this program's design that would defeat both of your solutions, and
  explain why patching would no longer help.

## Deliverable checklist

Your PDF contains: both authors if a pair; your `check.c` and the two-build comparison; the
crackme's title, author and URL; the triage output; your numbered plan and its post-mortem; trimmed
`ltrace` or `strace` output; one GDB session with addresses; the renamed decompilation; a valid
input with evidence; a patch with address, offset and bytes; and the two assessment answers.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Compiler comparison (Task 1)** | 15% | Both builds compiled, a correct tool-by-tool comparison, and an accurate statement of which condition survived `-O2` and which did not. |
| **Triage and plan** | 20% | All triage commands run with output shown, packing and stripping correctly judged from a named signal, three anchors justified, and a plan written before the work with an honest post-mortem after it. |
| **Dynamic analysis** | 20% | Trace output interpreted line by line, and a GDB session that reads a value static analysis could not give, with addresses stated and PIE offsets reconciled. |
| **Legitimate solution** | 15% | A valid accepted input, with evidence, and a correct plain-language explanation of why the program accepts it. |
| **Patch** | 15% | Address, file offset with its derivation, original and new bytes, equal instruction length, and re-disassembly that matches the claim. |
| **Assessment and report quality** | 15% | Both questions answered concretely; safe-handling rules visibly followed; report structured and readable, with code and output formatted as code. |
| **Bonus** | +20% | See below. |

A report that solves the crackme but skips the plan, the traces or the post-mortem loses more marks
than one that fails to solve it and documents the attempt well. The method is what is being
assessed.

## Bonus: A second artefact type (up to +20%)

Native x86-64 is one of several things you may be handed. Pick **one** of the following and give it
its own section.

- **Bytecode.** Take a compiled Java class or a .NET assembly you wrote yourself, decompile it, and
  compare the result with your own source. Explain in half a page why the reconstruction is so much
  closer to the original than C decompilation is, in terms of what each format preserves.
- **A packed binary.** Pack one of your Task 1 builds with UPX, then show the before-and-after of
  `strings` and section headers, unpack or dump it, and explain what the packer changed and what
  the entry point looks like afterwards.
- **A file format.** Take a file produced by a program you use, in a format you do not know, and
  reverse enough of its structure to document the header: field offsets, sizes, and what at least
  four fields mean. Support each claim with hex from the file.

### Bonus evaluation

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Execution** | +12% | The chosen task carried out on a real artefact, with the evidence it calls for included. |
| **Explanation** | +8% | A correct explanation of why this artefact type behaves differently from a stripped native binary. |
