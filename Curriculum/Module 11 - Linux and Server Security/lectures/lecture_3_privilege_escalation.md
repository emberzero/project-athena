# Privilege escalation

## What is privilege escalation?

- "Privilege Escalation consists of techniques that adversaries use to gain higher-level permissions on a system or network." - MITRE Framework
- "Privilege Escalation is the act of exploiting a bug, a design flaw, or a configuration oversight in an operating system or software application to gain elevated access to resources that are normally protected from an application or user." - Wikipedia
- "Privilege Escalation is the process of gaining unauthorized access to higher-level permissions or privileges within a system or network." - ChatGPT

### What is the goal?

The goal of almost every privilege escalation is becoming root. The Root user is the administrator account on Linux, who has near limitless permissions.

This may be a sub goal of achieving persistence, credential dumping, lateral movement or of a CTF challenge (Boot 2 Root).

## Basics of Linux Security Model

- Users and Groups on a Linux system are identified by an ID
- Every File has an owner and permissions

![File Permissions](images/file_permissions.jpg)

### Sudo

- Sudo is used to execute commands in the context of another user, which can be the root user
- ```/etc/sudoers``` define who can execute what as who
- In privesc **always** check for sudo privileges
  - ```sudo -l```

## Common Vulnerabilities

Common vulnerabilities are as the name implies the most common way to get privesc on a system:

### File permissions

Sometimes file permissions are misconfigured, giving the attacker access to files that they shouldn't have

- System files like: ```/etc/passwd``` and ```/etc/shadow```
- Config files like: ```*.config``` and ```*.txt```
- User files like: ```.ssh``` and ```.bashrc```

### Credentials

The same applies to misconfigured credentials, giving the attacker access to passwords and keys that they shouldn't have

- Plaintext creds (hardcoded creds in scripts).
- SSH keys (`/home/user/.ssh/id_rsa`, `id_ed25519`)
- Bash history (`/home/user/.bash_history`)

### Sudo

Any sudo privilege is worth examining closely. Programs that look harmless are often enough, because many of them can run a shell, write an arbitrary file or load code:

- 7z
- apt-get
- gdb
- pandoc

To check allowed sudo commands for privesc used GTFOBins, more on it on the next lecture:
<https://gtfobins.github.io/#+sudo>

### SUID

Binaries with setuid bit set, run as owner instead of user
starting the process:

![SUID Example](images/suid_example.jpg)

### Docker/LXD Group

Membership in the `docker` or `lxd` group is effectively equivalent to root access, because a member can start a container that mounts the host filesystem. No exploit is needed; this is how the groups are designed to work, which is why they must be treated as administrative groups.

These containers can:

- Mount host file-system as root
- Read / Write system-files
- Fully compromise host

### Scheduled Tasks / Cron Jobs

Scheduled tasks are defined in ```/etc/crontab```, ```/etc/cron.d``` and the per-user crontabs, and systemd timers are a second place to look. They are interesting because they run on a schedule as another user, often as root: if the script a root cron job executes is writable by us, or if it calls a program by a relative path we can influence, we gain root the next time it fires.

![Crontab](images/crontab.jpg)

### Kernel / Software Exploits

Check versions and look for public exploits:

- Kernel
  - ```cat /proc/version```
- Software
  - ```sudo -V```

## Enumeration

Privilege escalation is rarely one exploit. It works as a loop: enumerate,
pick a vector from what the enumeration shows, and if it fails, go back and
enumerate again with the access gained so far.

```text
  low-privilege shell
       |
       v
  +----------------------------------------------------+
  | 1. Enumerate                                       |
  |    users and groups, sudo -l, SUID files,          |
  |    cron jobs and timers, kernel and pkg versions   |
  +----------------------------------------------------+
       | a candidate turns up
       v
  +----------------------------------------------------+
  | 2. Pick a vector                                   |
  |    sudo entry   -> look the binary up on GTFOBins  |
  |    SUID binary  -> look the binary up on GTFOBins  |
  |    script run by a root cron job, writable by us   |
  |    docker / lxd group membership                   |
  |    readable credentials, SSH key, bash history     |
  |    outdated kernel or service -> public exploit    |
  +----------------------------------------------------+
       | attempt
       +--> failed: go back to step 1 with whatever the
       |            attempt revealed, try the next vector
       v succeeded
  root shell -> persistence, credential dumping,
                lateral movement
```

So how do you find those vulnerabilities? By searching the system, looking for something that stands out.

- User Files
- Custom scripts and executables
- Version enumeration
- Scheduled Tasks / Cron Job
- Processes running on the system

### Tools

There are many tools that can automate this task in the background, like:

- [LinPeas](https://github.com/carlospolop/PEASS-ng/) - Automated enumeration
- [LinEnum](https://github.com/rebootuser/LinEnum) - Automated enumeration (older)
- [pspy](https://github.com/DominicBreuker/pspy) - List running processes
- [GTFOBins](https://gtfobins.github.io/) - Privesc via sudo/suid binaries
- [HackTricks](https://book.hacktricks.xyz/linux-hardening/privilege-escalation) - Checklists and information

## Resources

- This lecture is based on a presentation from [chr0x6eos](https://github.com/chr0x6eos).
- <https://delinea.com/blog/linux-privilege-escalation>
- <https://book.hacktricks.xyz/linux-hardening/privilege-escalation>
