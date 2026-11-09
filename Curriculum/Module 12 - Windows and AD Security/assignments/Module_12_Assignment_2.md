# Assignment 2: Assess and Fix Your Own Active Directory Domain

## Objective

You will build a small Active Directory domain containing the misconfigurations that real domains
accumulate, assess it from an attacker's position, and then fix it and prove the attack paths are gone.
Afterwards you will be able to enumerate a domain with an ordinary user account, execute and explain the
two Kerberos attacks that need nothing but that account, read a BloodHound path, and write a finding in
the form a client can act on: the chain, the cheapest break, and the detection.

## Logistics

- **Work:** individual, or in pairs if your instructor allows it. In a pair, each member builds their
  own domain and the report names who did which task.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module12_Assignment2.pdf`.
- Your domain name is `<lastname>.lab`, lowercase, no special characters, so every piece of output is
  tied to you.

## Setup

- A domain controller: a Windows Server evaluation image from Microsoft's Evaluation Center, which is
  free and time-limited. Your instructor will say which version the class uses.
- An attack host: any Linux distribution with Impacket, `bloodhound-python`, `ldap-utils`, `nmap` and a
  password cracker. A security-oriented distribution ships all of these; otherwise install Impacket and
  `bloodhound-python` with `pip`. BloodHound Community Edition is free and runs in Docker.
- A hypervisor (VirtualBox, VMware Workstation Player or Hyper-V, all free) and a host-only network on
  an RFC 1918 range. Two VMs at once is the minimum; a Windows client VM is optional. Realistically the
  host needs about 16 GB RAM for the server plus the attack VM.
- **This is the one task in the module with a real hardware requirement.** If your machine cannot run
  two VMs, ask your instructor early: either for a lab host, or for the fallback described under task 1.
- Nothing here costs money.
- **Snapshot both VMs after task 1 and again before task 6.**

### Scope and legality

The domain you attack is the one you built, on an isolated virtual network. The school domain, school
workstations, classmates' domains and anything on the internet are out of scope and no task needs them.
Unauthorized access to a computer system is an offence under StGB §118a, and damaging data or a system
under §126a and §126b. An AD assessment of a real organisation additionally requires written
authorization covering the scope, the time window and the permission to attempt privilege escalation;
Module 01 covers this. Read it before you build the lab.

## Tasks

### 1. Build the domain

Promote the server to a domain controller for `<lastname>.lab`. Then create, by PowerShell script so it
is reproducible:

1. Six to eight user accounts with realistic names, all non-privileged except one you place in Domain
   Admins.
2. One ordinary user account that owns a `servicePrincipalName` and has a human-chosen password that
   appears in a common wordlist.
3. One account with "Do not require Kerberos preauthentication" set.
4. One computer or user account trusted for unconstrained delegation.
5. One non-administrative account granted an ACL edge over a privileged object, for example
   `ForceChangePassword` or `GenericAll` over a Domain Admin, or membership in a group nested into a
   privileged group.
6. Leave `ms-DS-MachineAccountQuota` at its default and note what that default is.

**In the report:** the full setup script, and `Get-ADUser` output confirming the five
misconfigurations exist. State which real-world cause each misconfiguration imitates.

*Fallback:* if your hardware cannot host the lab, your instructor may nominate a lab environment or
supply a BloodHound data set. In that case state clearly in the report which tasks were done against
which environment, and task 1 is marked on the setup script and the explanation rather than on a
running domain.

### 2. Unauthenticated reconnaissance

From the Linux host, with no credentials at all, establish the domain name, the domain controllers and
the password policy.

```bash
dig +short SRV _ldap._tcp.dc._msdcs.<lastname>.lab
nmap -p 53,88,135,139,389,445,464,636,3268 -sV <DC_IP>
ldapsearch -x -H ldap://<DC_IP> -s base -b '' defaultNamingContext dnsHostName
```

**In the report:** a table of the open AD ports with the service and its role from lecture 4, plus a
list of everything you obtained without a credential. If anonymous enumeration gave you a user list or
the password policy, say so and name the setting that would have prevented it. State the lockout
threshold and say whether password spraying would have been safe to attempt against this policy.

### 3. Authenticated enumeration

Using one ordinary user account, work the review checklist from lecture 5.

**In the report:** a findings table with the columns *check*, *command or LDAP filter used*, *result*,
*why it matters*. It must cover at least: members of the Tier 0 groups, accounts with an SPN and whether
any are privileged, accounts not requiring preauthentication, unconstrained and constrained delegation,
`ms-DS-MachineAccountQuota`, non-DC principals holding the directory replication extended rights, stale
`adminCount=1` objects, and the password policy. Add one sentence on why enumeration by an ordinary user
is not an exploit.

### 4. Two Kerberos attacks

Run both attacks that need nothing but an ordinary domain account.

1. **Kerberoasting** against your SPN account. Request the ticket, crack it offline, and report the
   recovered password.
2. **AS-REP roasting** against the account without preauthentication.

**In the report, per attack:** the exact command, the first 30 characters of the hash you retrieved (do
not paste the whole hash), the cracking command and the recovered password, and the event IDs that
appeared on the domain controller, including the ticket encryption type where the log shows it. Then
explain in two sentences why a computer account or a gMSA would not have been crackable, and why the
AS-REP attack needed no credential at all.

### 5. Map the domain with BloodHound

```bash
bloodhound-python -u <user> -p '<password>' -d <lastname>.lab -ns <DC_IP> -c All
```

Import the result and find a path from your ordinary user to Domain Admins.

**In the report:** a screenshot of the path, and the same path written out step by step as a chain of
edges, naming the specific objects and what each edge permits. Then say which single edge you would
remove to break the chain and why that is the cheapest break. Finally, one sentence on what the
collection itself looked like from the domain controller's point of view.

### 6. Fix the domain and re-test

Apply the remediations and then repeat tasks 4 and 5.

1. Give the SPN account a long random password, or convert it to a gMSA.
2. Clear the preauthentication flag.
3. Remove the unconstrained delegation setting.
4. Set `ms-DS-MachineAccountQuota` to zero.
5. Remove the ACL edge or the unintended group nesting from task 1.5.
6. Require SMB signing on the member hosts.

**In the report:** a table with the columns *finding*, *fix applied*, *evidence it is gone*. Then re-run
BloodHound collection and show which paths disappeared and which survived. If a path survives, say why
and what the next cheapest break would be.

### 7. Write the findings properly

Rewrite your five main findings in the format from lecture 6.7, one short block each:

1. The path, step by step, with the objects named.
2. The impact in terms a client cares about.
3. The single change that breaks the chain, and roughly what it costs to make.
4. Whether monitoring would have caught the step, with the event ID.

Order them by how many attack paths each fix removes, not by how severe they sound.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Lab build** | 10% | A reproducible setup script creating all five required misconfigurations, confirmed by directory output, each mapped to a plausible real-world cause. |
| **Unauthenticated recon** | 10% | Correct port and service table, an honest list of what no credential yielded, the lockout threshold stated, and a defensible answer on spraying. |
| **Authenticated enumeration** | 20% | Every checklist item covered with the actual command or filter and its result, each with a correct reason why it matters. |
| **Kerberos attacks** | 20% | Both attacks executed against the student's own domain, passwords recovered, correct DC event IDs reported, and the gMSA and preauthentication explanations correct. |
| **BloodHound path** | 15% | A real path from the student's own collection, written out edge by edge with the objects named, and the cheapest break identified with a reason. |
| **Remediation and re-test** | 20% | All six fixes applied with evidence, collection re-run, and the change in paths shown and explained, including any surviving path. |
| **Finding write-up** | 5% | Five findings in the lecture 6.7 format, ordered by how many paths each fix removes. |
| **Bonus** | +20% | See below. |

## Bonus: detection

Finding the path is the easy half. Prove you can see it happen.

1. Enable the audit subcategories from lecture 5 on your domain controller: Directory Service Changes,
   Kerberos Authentication Service, Kerberos Service Ticket Operations, Credential Validation, Security
   Group Management and Sensitive Privilege Use.
2. Grant the directory replication extended rights to a non-DC account you control, then use that
   account to retrieve a single hash with `secretsdump`. Show the hash retrieval succeeded, with the
   hash itself redacted. Remove the rights again afterwards.
3. Produce the raw events your two actions generated, including the event 4662 record for the
   replication rights and the group membership change.
4. Write one detection rule in plain words for each, naming the event ID, the field that matters, and
   the condition that separates your activity from legitimate domain controller behaviour.

Label the section **"Bonus Points Task"**. Full bonus marks require the raw events, not only the rules.
