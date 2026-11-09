# Assignment 1: Linux Basics and the Shell

## Objective

You will find your way around a Linux system and write shell scripts that solve real problems. By the
end you will know where things live on a Linux filesystem, you will chain commands with pipes and
redirection, and you will write scripts that use variables, control flow and functions. This is the
foundation every later task in this module builds on.

## Logistics

- **Work:** individual.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF named `Lastname_Firstname_Module11_Assignment1.pdf`, plus your script files.
- Every piece of evidence must come from *your* portal machine. The hostname and your username appear
  in the output, so screenshots cannot be shared between students.

## Setup

- Your Linux machine is provided through the **Athena portal**. Log in there and start your machine,
  then connect to it as the portal instructs (SSH or an in-browser terminal).
- Use `bash`. Check with `echo $0` or `bash --version`.
- Your username and hostname are assigned by the portal and already appear in the prompt. Make sure
  `hostname` and `whoami` are visible in your captures so the work is identifiably yours.
- Nothing here costs money and no extra setup is required beyond logging in.

### Scope and legality

Work only on the machine the portal gave you. Do not point any command at another host, at the portal
itself, or at any classmate's machine. The one command here that reads network-related data
(task 1's `uname`) stays local.

## Tasks

### 1. Find your way around the filesystem

Using only the shell, answer each question below with the command you ran and its output.

```bash
uname -a
cat /etc/os-release
```

1. Which distribution and kernel version are you on?
2. List the contents of `/`. For each of these directories, write one sentence on what it holds:
   `/bin`, `/etc`, `/home`, `/tmp`, `/usr`, `/var`.
3. Show the first three lines of `/etc/passwd`. What does each colon-separated field mean? Name your
   own account's line and explain its fields.
4. Find where the `ls` program actually lives on disk (`which ls`), and say which FHS directory that is
   and why `ls` belongs there.

**In the report:** the four answers, each backed by command output.

### 2. Pipes, redirection and text tools

Create a file `names.txt` with at least eight lines, some names repeated, some with different cases.
Then build **one pipeline** for each task below. Each must be a single line using pipes.

1. Print the names sorted alphabetically.
2. Print each unique name once, with a count of how often it appears, most frequent first.
3. Count how many lines the file has, using a pipe into `wc`.
4. Save the sorted, de-duplicated list to a new file `sorted.txt` using redirection, then show that
   the file was created.

**In the report:** each pipeline and its output. For task 4, explain the difference between `>` and
`>>`, and what would have happened if you had used the wrong one.

### 3. Variables, substitution and arithmetic

Write the commands (not yet a script) that do the following, and show the output:

1. Store your name in a variable and print `Hello, <name>!` using `${}` parameter expansion.
2. Store the output of `date +%F` in a variable using command substitution, and print a line that
   includes it.
3. Compute `2 ** 10` with arithmetic expansion and print the result.
4. Compute `22 / 7` to three decimal places. Arithmetic expansion gives integers only, so explain in
   one sentence why you need `bc` here.

**In the report:** the commands and their output, plus the one-sentence explanation for task 4.

### 4. Your first script: a backup helper

Write an executable script `backup.sh` with a proper shebang. It takes one argument: a directory.

1. If no argument is given, print a usage message and exit with a non-zero code.
2. If the argument is not an existing directory, print an error and exit with a non-zero code.
3. Otherwise, create a copy of that directory named `<dirname>-backup-<today's date>` and print a
   confirmation.

Requirements:

- Use `$#` to check the number of arguments and `$1` for the directory.
- Use a `[` test for the directory check.
- Use command substitution for the date in the backup name.
- End by returning the right exit code, and show `echo $?` after a successful and a failed run.

**In the report:** the script, and three runs: with no argument, with a path that does not exist, and
with a real directory. Show `echo $?` after each.

### 5. Control flow and a function

Write a script `report.sh` that takes any number of filenames as arguments and, for each one, prints a
single line saying whether it exists and, if it does, how many lines it has.

Requirements:

- Loop over `$@`.
- Use an `if`/`else` with a `[ -f ... ]` test.
- Count the lines by piping the file into `wc -l` inside command substitution.
- Put the per-file logic in a **function** that takes the filename as its argument and `return`s a
  non-zero code for a missing file. Do not use `exit` inside the function; explain in one sentence why
  that would be wrong.

Run it on a mix of real files (including `sorted.txt` from task 2) and at least one name that does not
exist.

**In the report:** the script, its output on your mix of files, and the one-sentence explanation of
`return` versus `exit`.

### 6. Report

Structure: introduction, one section per task, conclusion. Every claim is backed by output you
produced on your portal machine. Attach `backup.sh` and `report.sh` as separate files as well as pasting
them into the report. Export the report to PDF.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Filesystem** | 15% | All four questions answered with correct FHS reasoning and the `/etc/passwd` fields explained. |
| **Pipes and redirection** | 20% | Four single-line pipelines that produce the right output, with `>` versus `>>` correctly explained. |
| **Variables and arithmetic** | 15% | All four tasks correct, including the `bc` explanation for floating point. |
| **backup.sh** | 25% | Correct shebang, argument and directory checks, correct backup name, right exit codes shown for all three runs. |
| **report.sh** | 20% | Correct loop, test, function with `return`, and the `return` versus `exit` explanation. |
| **Report quality** | 5% | Clear structure, readable, every claim backed by evidence from the student's own machine. |
| **Bonus** | +30% | See below. |

## Bonus: harden a Linux server

Label the section **"Bonus Points Task"**. This bonus takes the basics above and applies them to a
real server: you will turn a default installation into a defensible one and prove each control is in
effect. It is larger than the tasks above, so it is worth more.

### Setup

- Use the Linux machine assigned to you in the **Athena portal**. You need `sudo`/root on it to apply
  the controls; the portal machine grants this.
- **Baseline it before you change anything** (task B1 below) so you have a before-and-after comparison.
  If the portal offers a reset to a fresh state, do the baseline right after resetting.

Work only on your portal machine. Do not point any command at the school network, a classmate's
machine, the portal itself or any host on the internet; Module 01 covers why.

### B1. Baseline the fresh installation

Before changing anything, record what the default installation exposes.

```bash
ss -tulpn
systemctl list-units --type=service --state=running
uname -a
cat /etc/os-release
```

Report a table of every listening socket with its port, protocol, the process behind it, and a column
saying whether the server actually needs it.

### B2. Harden the server

Apply the controls below. For **each** one, show both the change you made and a command whose output
proves it is in effect afterwards. A copy of the config line alone is not proof.

1. SSH: public-key authentication working, `PasswordAuthentication no`, root login disabled.
2. `sudo` restricted to a dedicated group, with your own user in it.
3. `su` restricted to a dedicated group.
4. Password quality enforced through `pam_pwquality`.
5. Firewall: default deny incoming, SSH allowed, `ufw` enabled.
6. `rsyslog` running and enabled.
7. Kernel settings: `kernel.dmesg_restrict`, `kernel.kptr_restrict`, `kernel.randomize_va_space`.
8. Network settings in a single `sysctl.d` file: `tcp_syncookies`, `accept_source_route`,
   `accept_redirects`, `icmp_echo_ignore_broadcasts`.
9. GRUB config files owned by root and not readable by others.

For each of the nine controls, give the command or config edit, the verification output, and one
sentence naming the attack it makes harder.

Three things must appear explicitly:

- A password login attempt against your hardened SSH, refused, next to a successful key-based login.
- The content of your network `sysctl.d` file. This assignment's task 2 warns about `>` versus `>>`;
  if your file has one line in it, you hit exactly that trap.
- One control you deliberately did **not** apply, with two sentences on why.

Full bonus marks require working evidence from your portal machine for every control, not just the idea.
