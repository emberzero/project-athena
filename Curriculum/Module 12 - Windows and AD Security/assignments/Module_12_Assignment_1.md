# Assignment 1: Audit and Escalate on a Windows Host

## Objective

You will take a single Windows machine, read its security state the way an assessor does, measure that
state against the controls from the lectures, fix the weakest findings, and then escalate from a normal
user to SYSTEM through a service misconfiguration you plant yourself. Afterwards you will be able to
read an access token and a DACL, say what each Windows security feature does and does not protect
against, and explain a local privilege escalation in terms of the ACL that allowed it.

## Logistics

- **Work:** individual.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module12_Assignment1.pdf`.
- All evidence must come from your own machine. The hostname, your SID and your username appear in the
  output, so output cannot be shared between students.

## Setup

- A Windows virtual machine you control. Microsoft publishes time-limited evaluation images of Windows
  and Windows Server on its Evaluation Center at no cost; your instructor will tell you which one the
  class uses. Any Windows installation you own and can snapshot also works.
- A hypervisor: VirtualBox, VMware Workstation Player and Hyper-V are free. Budget about 4 GB RAM and
  60 GB disk for the VM, so the host needs roughly 8 GB RAM. **If your machine cannot run a Windows VM,
  ask your instructor for access to a lab host before the deadline rather than after it.**
- The Sysinternals suite, which is free, for `accesschk.exe`.
- Inside the VM create two local accounts: an administrator for yourself, and a standard user named
  `<first initial><lastname>`, all lowercase (Max Mustermann becomes `mmustermann`). You will need
  both.
- **Snapshot the VM before task 3.** Tasks 3 and 4 change the configuration and plant a vulnerability.

### Scope and legality

Every command in this assignment runs inside your own VM, on a host-only or NAT network. The school
domain, school workstations, classmates' machines and anything on the internet are out of scope, and no
part of this assignment requires them. Unauthorized access to a computer system is an offence under
StGB §118a, and damaging data or a system under §126a and §126b; Module 01 covers the detail.

## Tasks

### 1. Read your own access token

As your standard user, and then from an elevated prompt as your administrator:

```powershell
whoami /user
whoami /groups
whoami /priv
```

**In the report:**

- Your standard user's SID, broken into its parts, with the authority, the machine identifier and the
  RID labelled, and a sentence on why renaming the account would not change permissions.
- A table of the privileges held in each of the two tokens, marking which of them lecture 1 treats as
  equivalent to SYSTEM, and which of those the standard user holds.
- The administrator's token taken twice, once unelevated and once elevated. Name the group SID whose
  state differs between the two and explain, in terms of integrity levels, what UAC actually did.

### 2. Audit the configuration

Collect the real state of the machine using the commands from lecture 2. Cover at least: Windows build
and patch level, Defender (service, real-time protection, tamper protection), firewall profiles,
BitLocker, SMBv1 presence, SMB signing on server and client, PowerShell script block logging, VBS and
Credential Guard, LSA Protection (`RunAsPPL`), and the applied audit policy.

**In the report:** one table with the columns *control*, *command used*, *observed value*,
*assessment*, *threat it addresses*. The last column is the one that is marked hardest: BitLocker,
Secure Boot and Credential Guard each defend against a different thing, and writing "improves
security" in that column earns nothing. Finish with your three worst findings, ranked, with one
sentence of justification each.

### 3. Remediate three findings and prove it

Fix three of your findings. These three must be among them unless your audit shows they are already in
place:

1. Enable PowerShell script block logging.
2. Enable the "Include command line in process creation events" audit policy.
3. Require SMB signing on the server and the client side.

Then generate the evidence yourself:

```powershell
# After enabling script block logging, run something uniquely yours
Write-Output "audit marker <your username> $(Get-Date -Format o)"

# Then find your own command in the log
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational'; Id=4104} `
  -MaxEvents 20 | Where-Object { $_.Message -match '<your username>' } |
  Format-List TimeCreated, Message
```

**In the report:** before and after output for all three settings, the event 4104 record containing
your own marker string, and one event 4688 record showing a full command line. Add one sentence on why
logs that stay on this host are evidence rather than detection.

### 4. Plant and exploit a local privilege escalation

As administrator, create **one** service misconfiguration of one of the kinds from lecture 3.4: an
unquoted service path with a user-writable parent directory, a service whose binary or binary
directory is writable by `Users`, or a service whose configuration a normal user may change.

Then log in as your standard user and attack it:

1. Find it with enumeration, not from memory. Use `Get-CimInstance Win32_Service`, `accesschk.exe` or
   an automated tool such as WinPEAS, and show the output line that reveals the misconfiguration.
2. Exploit it to run code as SYSTEM.
3. Prove it:

   ```powershell
   whoami
   hostname
   whoami /priv
   ```

**In the report:** the administrator commands that created the misconfiguration, the enumeration output
that found it, the exploitation steps, and the `whoami` output showing `nt authority\system` together
with your hostname. Then fix it and show the same enumeration coming back clean.

### 5. Explain the ACL that allowed it

For the path or service object you abused, show `icacls` output from before and after the fix.

**In the report:** quote the single access control entry that made the escalation possible, decode its
rights abbreviation, and name the principal it was granted to. Then answer in two or three sentences:
which of the controls you audited in task 2 would have blocked this escalation, and which of them would
only have recorded it?

### 6. Report

Structure: introduction, token analysis, configuration audit table, remediation with evidence,
privilege escalation, ACL analysis, conclusion. Number your findings. Export to PDF.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Token analysis** | 15% | SID decomposed correctly, privilege tables for both accounts with the SYSTEM-equivalent ones identified, and the UAC difference explained via the deny-only group SID and integrity levels. |
| **Configuration audit** | 30% | All listed controls measured with real output, and a correct, specific threat named per control rather than a generic statement. |
| **Remediation** | 15% | All three settings changed with before and after output, plus the student's own marker string recovered from event 4104 and a usable 4688 command line. |
| **Privilege escalation** | 25% | Misconfiguration documented, found through enumeration output, exploited to `nt authority\system` on the student's own host, and then fixed with clean enumeration shown. |
| **ACL analysis** | 10% | The decisive ACE quoted and decoded, the principal named, and the preventive and detective controls correctly separated. |
| **Report quality** | 5% | Clear structure, numbered findings, every claim backed by output from the student's own VM. |
| **Bonus** | +20% | See below. |

## Bonus: catch a LOLBin

Prove that a signed Microsoft binary is not a trustworthy binary, and that behaviour is what gives it
away.

1. Serve a harmless text file from your own machine over HTTP, for example with
   `python -m http.server` on the host or on a second VM. No external host is involved.
2. Download it inside the Windows VM using a living-off-the-land binary from lecture 3.5 rather than a
   browser, and show it worked.
3. Find your own activity in the logs afterwards: the process creation event with the full command line,
   and the script block log if your technique went through PowerShell.
4. Write one detection rule in plain words, naming the process, the parent process and the network
   behaviour it would alert on, and say honestly what a legitimate administrator doing the same thing
   would look like in your rule.

Label the section **"Bonus Points Task"**. A rule that would fire on normal administration, with no
comment about it, does not earn full bonus marks.
