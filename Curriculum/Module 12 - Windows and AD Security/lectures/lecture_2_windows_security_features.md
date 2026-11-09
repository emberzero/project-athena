# Windows Security Features

The previous lecture described the model Windows uses to make access decisions. This one covers the
features built on top of it: what each control actually stops, what it does not stop, and how to
check whether it is switched on.

A recurring theme: most of these features ship with Windows but sit at a permissive default in a
typical domain. A large part of a real Windows assessment is confirming which of them are in effect,
rather than discovering something exotic.

## Boot and Disk Integrity

### Secure Boot and TPM

Secure Boot has the firmware verify the signature of the bootloader, which verifies the kernel,
which verifies early-launch drivers. It stops an attacker who can write to disk from replacing the
boot chain. It does nothing about code that runs after boot.

A TPM is a chip that stores keys and records measurements of the boot path. It releases a key only
if the measurements match, which is how BitLocker unlocks without anyone typing a recovery key.

### BitLocker

Full-volume encryption. Its purpose is narrow and worth stating precisely: it protects data on a
**powered-off** machine against someone with physical access. It does not protect a running machine
from a logged-on attacker, because the volume is already decrypted for every process on it.

```powershell
Get-BitLockerVolume
manage-bde -status
```

With TPM-only unlock and no PIN, an attacker holding the physical machine reaches an unlocked disk
at the logon screen. Requiring a startup PIN closes that gap.

## Memory-Safety Mitigations

These do not prevent bugs; they raise the cost of turning a bug into reliable code execution.

- **DEP / NX**: data pages are not executable, so shellcode placed in a buffer will not run.
- **ASLR**: images, stacks and heaps are placed at addresses that vary, so an exploit cannot
  hard-code one.
- **CFG (Control Flow Guard)**: indirect calls are validated at run time against a bitmap of legal
  targets, constraining what a corrupted function pointer can reach.
- **CET shadow stacks**: on supported CPUs the hardware keeps a protected copy of return addresses
  and faults when the two disagree.

Module 07 covers exploitation itself. What matters here is that most of these are per-binary
opt-ins. One legacy DLL built without ASLR reintroduces a predictable address into an otherwise
randomized process. Exploit Protection lets you force several of them on per executable.

```powershell
Get-ProcessMitigation -Name notepad.exe
```

## Application Control

### AppLocker

Policy-based allow-listing of what may execute, by publisher signature, by path, or by file hash.
Publisher rules are the useful kind, because they survive updates. Path rules are the common kind,
and the common mistake is allowing a directory tree that contains a user-writable subdirectory.
Auditing a path rule means checking the ACL of every folder it covers.

### WDAC (Windows Defender Application Control)

Kernel-enforced code integrity policy. Stronger than AppLocker: it covers drivers as well as
user-mode binaries and can be enforced before the user session starts. It is also considerably more
work to deploy, because every legitimate signer has to be enumerated first. WDAC also supports
blocking known-abusable Microsoft-signed binaries, which matters for the reason covered in the next
lecture.

## Script and Command-Line Visibility

PowerShell is the most-used administration and post-exploitation environment on Windows, and the
most observable one, provided the logging is enabled.

| Feature                 | What it records                                   | Event ID |
| ----------------------- | ------------------------------------------------- | -------- |
| Script block logging    | The decoded text of every script block executed    | 4104     |
| Module logging          | Pipeline execution details per module              | 4103     |
| Transcription           | A full text transcript of each session, to a file  | —        |

Script block logging is the valuable one, because it records the script after decoding, so an
encoded command appears in the log as readable PowerShell.

**AMSI** (Antimalware Scan Interface) lets PowerShell, scripting hosts, Office macros and .NET hand
a buffer to the installed antivirus immediately before it executes. This closes the gap left by
file-based scanning, which never sees a payload that only exists in memory. AMSI runs inside the
scripted process, so treat it as a strong detection aid rather than a boundary.

**Constrained Language Mode** restricts PowerShell to a safe subset: no arbitrary .NET type access
and no direct Win32 calls. It is effective when paired with WDAC, which is what prevents a
full-language engine being introduced alongside it.

Hardening checklist for this area:

- Enable script block logging, module logging and transcription by Group Policy.
- Remove the optional Windows PowerShell 2.0 engine feature; it predates these logging facilities.
- Enable the "Include command line in process creation events" audit policy so event 4688 is useful.
- Ship the resulting events to a SIEM. Logs that stay on the compromised host are evidence, not
  detection.

## Microsoft Defender Antivirus

Defender is signature plus behavioural detection plus cloud lookup. Two parts are worth separating
out because they block whole attack classes rather than specific files:

- **Attack Surface Reduction (ASR) rules**: targeted behavioural blocks, such as preventing Office
  applications from spawning child processes, blocking executable content from mail clients, or
  blocking credential theft from LSASS. Each rule can run in audit mode first.
- **Tamper Protection**: stops local configuration changes that would disable Defender's own
  settings, even from an administrator-level process.

```powershell
Get-MpComputerStatus
Get-MpPreference | Select-Object -ExpandProperty AttackSurfaceReductionRules_Ids
```

When Defender is managed centrally, exclusion paths are a standard assessment finding: an excluded
directory that ordinary users can write to is an un-scanned staging area. Enumerate exclusions and
check their ACLs.

## Virtualization-Based Security

VBS uses the hypervisor to carve out a memory region the normal kernel cannot touch, then runs small
trusted components inside it.

- **Credential Guard** moves NTLM and Kerberos secrets into that isolated world. The usual technique
  of reading LSASS memory returns nothing usable. This is the real structural fix for
  pass-the-hash on a workstation.
- **HVCI (Memory Integrity)** validates kernel-mode code in the isolated world, so an attacker who
  gets kernel write cannot simply map in unsigned code. It also forces attackers towards abusing
  legitimately signed but vulnerable drivers, which the Microsoft vulnerable driver blocklist exists
  to counter.

Credential Guard protects secrets created after it is enabled; it does not retroactively clean
anything, and it does not help against a keylogger capturing the password as it is typed.

## Network-Facing Settings

### SMB

```powershell
Get-SmbServerConfiguration | Select-Object EnableSMB1Protocol, RequireSecuritySignature
Get-SmbClientConfiguration | Select-Object RequireSecuritySignature
```

- **SMBv1 should be absent.** It has no modern integrity protections. Disabling it is not
  enough; remove the Windows feature.
- **SMB signing required** on both client and server. This is what stops an SMB session being
  relayed, as the next lectures describe. It is required by default on domain controllers and
  off by default on member servers and workstations. Enabling it there is one of the
  highest-value changes available in a domain.

### Windows Defender Firewall

Host firewalls in a domain are often set to allow anything from the internal network, which makes
them irrelevant to lateral movement. The valuable configuration is to block inbound SMB and RPC
*between workstations*, since workstations normally have no reason to talk to each other. This
single rule removes most peer-to-peer lateral movement.

```powershell
Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction
Get-NetFirewallRule -Enabled True -Direction Inbound | Measure-Object
```

### Remote Desktop

Require Network Level Authentication, so a client authenticates before a session is created. Where
administrators must use RDP, Restricted Admin mode and Remote Credential Guard prevent reusable
credentials being left in the target's LSASS, though Restricted Admin mode has its own trade-off,
because the connection then authenticates with the client's existing credentials rather than typed
ones.

## Local Account Management

- **Windows LAPS** gives every machine a different, automatically rotated local administrator
  password, stored in Active Directory and readable only by explicitly permitted principals. Without
  it, one shared local admin password turns a single compromised workstation into access to every
  workstation. Deploying LAPS is the single most effective anti-lateral-movement measure in most
  domains.
- Disable the built-in Administrator account where LAPS is in use for a different account, or manage
  it with LAPS directly.
- Deny network logon to local accounts. Local accounts have no reason to authenticate across the
  network, and blocking that neutralises a stolen local hash.

## Verifying the Configuration

Nothing above is worth anything unmeasured. On a lab host, collect the actual state:

```powershell
# Windows version and patch level
Get-ComputerInfo -Property WindowsProductName, OsBuildNumber
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 10

# Defender, firewall, BitLocker, VBS
Get-MpComputerStatus | Select-Object AMServiceEnabled, RealTimeProtectionEnabled, IsTamperProtected
Get-NetFirewallProfile | Select-Object Name, Enabled
Get-BitLockerVolume | Select-Object MountPoint, ProtectionStatus
Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard

# Audit policy as actually applied
auditpol /get /category:*
```

Microsoft publishes security baselines as GPO backups through the Security Compliance Toolkit, and
the CIS Benchmarks cover the same ground with per-setting rationale. Comparing a host against one of
these is a far better use of assessment time than hunting for a novel misconfiguration.

## Key Takeaways

- Each feature has a specific threat it addresses. BitLocker protects powered-off machines; Secure
  Boot protects the boot chain; Credential Guard protects secrets in memory. Mixing them up produces
  false confidence.
- Memory-safety mitigations are per-binary opt-ins, and one unprotected module can undo them.
- Application control is only as strong as the weakest path rule and the set of signed binaries
  allowed to run.
- Script block logging plus command-line process auditing, shipped off-host, is the cheapest large
  improvement in Windows visibility.
- SMB signing, host firewall rules between workstations, and LAPS are the three settings that most
  reduce lateral movement in a domain.
- Measure the configuration against a published baseline rather than assuming the default is secure.

## Resources

- Microsoft Security Compliance Toolkit and baselines: <https://learn.microsoft.com/windows/security/operating-system-security/device-management/windows-security-configuration-framework/security-compliance-toolkit-how-to-use>
- CIS Benchmarks for Windows: <https://www.cisecurity.org/cis-benchmarks>
- Microsoft Learn, Attack Surface Reduction rules: <https://learn.microsoft.com/defender-endpoint/attack-surface-reduction-rules-reference>
- Microsoft Learn, Credential Guard: <https://learn.microsoft.com/windows/security/identity-protection/credential-guard/>
- Microsoft Learn, Windows LAPS: <https://learn.microsoft.com/windows-server/identity/laps/laps-overview>
- Microsoft Learn, PowerShell logging: <https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_logging_windows>
- Microsoft recommended driver block rules: <https://learn.microsoft.com/windows/security/application-security/application-control/app-control-for-business/design/microsoft-recommended-driver-block-rules>
