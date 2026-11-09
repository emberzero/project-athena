# Active Directory Security Features

Active Directory ships with a substantial set of security controls. Most domains use few of them,
because the defaults were chosen in the early 2000s for compatibility and have been preserved ever
since. This lecture covers the controls that exist, what each one is for, and how to check whether
it is in effect.

The organising idea is **containment**. You cannot prevent every workstation compromise. What you
can decide is whether a compromised workstation leads to the forest.

## The Tiering Model

Microsoft's guidance, originally the tiered administration model and now folded into the Enterprise
Access Model, divides assets by what their compromise costs:

| Tier | Contents                                             |
| ---- | ---------------------------------------------------- |
| 0    | Domain controllers, AD itself, PKI, anything that can take control of Tier 0 |
| 1    | Member servers, applications, business data           |
| 2    | Workstations and the accounts used on them            |

The single rule: **a credential for a higher tier is never exposed on a lower-tier machine.** A
Domain Admin never logs on to a workstation, never to a file server, never anywhere a Tier 2 admin
could be reading memory. Tier 0 administration happens from dedicated Privileged Access Workstations
that run nothing else.

This is unglamorous and it is the control that matters more than everything else in this lecture
combined. Credential theft techniques require a credential to be present; tiering removes it.

Checking it is straightforward: look at where privileged accounts have logged on.

```powershell
Get-ADGroupMember -Identity 'Domain Admins' -Recursive |
  Get-ADUser -Properties LastLogonDate, PasswordLastSet, ServicePrincipalName |
  Select-Object SamAccountName, LastLogonDate, PasswordLastSet, ServicePrincipalName
```

A Domain Admin account with an SPN, or with a password set five years ago, is a finding on its own.

## Protecting Privileged Accounts

### The Protected Users group

Membership changes how an account may authenticate:

- NTLM is refused entirely.
- DES and RC4 Kerberos encryption are refused; only AES is used.
- Credentials are not cached, so there is no offline logon.
- The account cannot be delegated, constrained or otherwise.
- TGT lifetime is fixed at four hours and cannot be renewed.

That list is also a list of the things that go wrong when you add a service account to the group, so
test before deploying. Protected Users is for human administrators.

### Authentication Policies and Silos

A silo is a container holding users, computers and service accounts; a policy attached to it can
require that the users in the silo may only authenticate *from* the computers in the silo. This
enforces tiering in the KDC rather than by convention: a Tier 0 account that leaks is still unusable
from a workstation.

Silos require the Dynamic Access Control / Kerberos armoring (FAST) features to be enabled on the
domain and the clients.

### AdminSDHolder

Members of protected groups (Domain Admins, Enterprise Admins, the Operators groups and others)
have their security descriptor overwritten every hour from a template object called AdminSDHolder.
This stops an attacker quietly granting themselves rights over an administrator, since the change is
reverted.

Two consequences worth knowing:

- An account removed from a protected group keeps `adminCount = 1` and the inherited-ACL-disabled
  state. Stale `adminCount=1` objects are a reliable sign of former privilege.
- An attacker who modifies AdminSDHolder itself has modified the template applied to every protected
  group. It is a Tier 0 object and should be monitored for changes.

```powershell
Get-ADObject -LDAPFilter '(adminCount=1)' -Properties adminCount, memberOf |
  Select-Object Name, memberOf
```

## Managing Machine-Local Administrators

**Windows LAPS** stores a unique, randomly generated and automatically rotated local administrator
password per machine, as an attribute on that machine's computer object, readable only by explicitly
permitted principals. Newer versions can store it encrypted so that only the intended readers can
decrypt it, rather than relying on ACLs alone.

Without LAPS, one shared local administrator password means a single compromised workstation yields
administrative access to every workstation. With LAPS, it yields access to one machine.

When reviewing a LAPS deployment, check who can read the password attribute. Delegating that read to
a broad helpdesk group gives that group administrative access to every machine in scope.

## Service Accounts

- **Group Managed Service Accounts (gMSA)** have a long random password managed by AD and rotated
  automatically on a schedule. The password is retrieved by the machines permitted to use the
  account, so nobody ever knows it. gMSAs are the correct answer to Kerberoasting.
- **Standalone Managed Service Accounts** are the single-machine equivalent.
- Where a plain user account must hold an SPN, it needs a long random password, and it must not be a
  member of any privileged group.

```powershell
Get-ADServiceAccount -Filter * -Properties PrincipalsAllowedToRetrieveManagedPassword
```

Check that last attribute. The set of principals allowed to retrieve a gMSA password is effectively
the set of principals that can become that service account.

## Delegation

Delegation lets a service act on behalf of a user towards another service: a web front end reaching
a database as the browsing user, for example. There are three forms, in descending order of danger:

- **Unconstrained delegation.** The user's full TGT is placed inside the ticket sent to the service,
  so the service can impersonate that user to anything. A compromise of such a host yields the TGT
  of every user who connects to it, including administrators. There is no safe modern use for this
  setting; find it and remove it.
- **Constrained delegation.** The service may impersonate users only towards a listed set of SPNs,
  using the S4U2Self and S4U2Proxy extensions. Narrower, but control of the front-end account still
  means control of everything on the list.
- **Resource-based constrained delegation (RBCD).** The *target* resource names which accounts may
  delegate to it, in `msDS-AllowedToActOnBehalfOfOtherIdentity`. This is the right model, because
  the resource owner decides. It is also an attack path when an attacker can write that attribute on
  a computer object.

```powershell
# Unconstrained: every one of these is a finding
Get-ADComputer -Filter {TrustedForDelegation -eq $true} -Properties TrustedForDelegation

# Constrained
Get-ADObject -LDAPFilter '(msDS-AllowedToDelegateTo=*)' -Properties msDS-AllowedToDelegateTo
```

Mark genuinely sensitive accounts with "Account is sensitive and cannot be delegated", which
prevents their tickets being forwarded regardless of configuration elsewhere. Members of Protected
Users get this behaviour automatically.

## Hardening Authentication Protocols

### Retiring NTLM

NTLM has no channel binding and no mutual authentication, which is what makes relay attacks work.
Windows provides auditing before enforcement: the "Restrict NTLM" policies can log every NTLM
authentication, including the source and destination, so you can find out what would break before
turning it off. The sequence is audit, remediate the applications found, then block.

Where NTLM must remain:

- **Require SMB signing** on servers and clients. This prevents a relayed SMB session being used.
- **Require LDAP signing and LDAP channel binding** on domain controllers. This prevents relaying
  into LDAP, which is otherwise a direct path to modifying the directory.
- **Enable Extended Protection for Authentication (EPA)** on HTTP services that accept Windows
  authentication, binding the authentication to the TLS channel.

```powershell
# On a domain controller
Get-SmbServerConfiguration | Select-Object RequireSecuritySignature, EnableSMB1Protocol
```

### Kerberos settings

- Disable RC4 where the environment allows it, so tickets use AES and offline attacks are slower.
- Enable Kerberos armoring (FAST), which encrypts the pre-authentication exchange using the machine
  account's credentials and removes several offline attacks against user keys.
- Reset the `krbtgt` account password on a schedule, and twice with replication in between after any
  suspected Tier 0 compromise, because that is what invalidates forged TGTs.

## Machine Account Quota

By default any authenticated user may join up to ten computers to the domain, and becomes the
creator-owner of those computer objects. Several attack paths rely on creating a computer account
you control. Unless a deployment process depends on it, set it to zero and delegate domain-join to a
specific account.

```powershell
Get-ADDomain | Get-ADObject -Properties ms-DS-MachineAccountQuota
```

## Domain Controller Hygiene

- Domain controllers should run nothing else. No file shares, no web applications, no agents that
  are not required. Every additional service on a DC is a Tier 0 attack surface.
- Restrict logon rights with the "Deny log on locally" and "Deny log on through Remote Desktop"
  policies for non-Tier-0 accounts.
- Read-Only Domain Controllers can be placed in branch offices: they hold no password hashes except
  those explicitly cached by policy, so physical compromise of a branch is survivable.
- Keep DCs patched promptly. Several of the most serious AD vulnerabilities of recent years were
  flaws in DC-side protocol handling, fixed only by patching.

## Visibility

A control you cannot observe is a control you cannot verify. The audit subcategories worth enabling
on DCs, beyond the defaults:

| What to audit                         | Why                                               |
| ------------------------------------- | -------------------------------------------------- |
| Directory Service Changes             | Produces before/after values for attribute changes |
| Kerberos Authentication Service (4768) | TGT requests                                       |
| Kerberos Service Ticket Operations (4769) | Service ticket requests, with encryption type   |
| Credential Validation (4776)          | NTLM authentication attempts                       |
| Security Group Management (4728, 4732) | Additions to privileged groups                    |
| Sensitive Privilege Use               | Use of the privileges listed in lecture 1          |

```powershell
auditpol /get /category:* | Select-String 'No Auditing'
```

Microsoft Defender for Identity reads DC traffic and event data and detects many of the techniques
in this module without requiring you to write the queries yourself. Where it is not available, the
same signals are available in the event log and need rules written against them.

## A Review Checklist

Run these against your lab domain and explain each result:

1. Who is in Domain Admins, Enterprise Admins, Schema Admins and the Operators groups?
2. Which accounts have an SPN? Which of those are privileged?
3. Which accounts do not require Kerberos pre-authentication?
4. Which computers or users are trusted for unconstrained delegation?
5. What is `ms-DS-MachineAccountQuota`?
6. Which non-DC principals hold the directory replication extended rights?
7. Is SMB signing required? Is LDAP signing and channel binding required?
8. Is LAPS deployed, and who can read the passwords?
9. When was `krbtgt` last reset?
10. Are DC security logs leaving the DC?

## Key Takeaways

- Tiering is the control that matters most: a credential that is never present on a workstation
  cannot be stolen from one.
- Protected Users, Authentication Silos and "sensitive and cannot be delegated" enforce tiering at
  the protocol level rather than by policy document.
- LAPS converts a workstation compromise from domain-wide to single-machine.
- gMSA removes Kerberoasting as a threat for service accounts.
- Unconstrained delegation has no safe modern use. Find it and remove it.
- NTLM retirement is a project with an audit phase; SMB signing, LDAP signing and channel binding are
  the interim mitigations.
- Set the machine account quota to zero unless something genuinely needs it.
- Every control above needs an audit setting behind it, and the logs need to leave the DC.

## Resources

- Microsoft Learn, securing privileged access and the Enterprise Access Model: <https://learn.microsoft.com/security/privileged-access-workstations/privileged-access-access-model>
- Microsoft Learn, Protected Users security group: <https://learn.microsoft.com/windows-server/identity/ad-ds/manage/how-to-configure-protected-accounts>
- Microsoft Learn, authentication policies and silos: <https://learn.microsoft.com/windows-server/identity/ad-ds/manage/how-to-configure-protected-accounts#authentication-policies-and-silos>
- Microsoft Learn, Windows LAPS: <https://learn.microsoft.com/windows-server/identity/laps/laps-overview>
- Microsoft Learn, Kerberos constrained delegation: <https://learn.microsoft.com/windows-server/security/kerberos/kerberos-constrained-delegation-overview>
- Microsoft Learn, auditing NTLM usage before restricting it: <https://learn.microsoft.com/windows/security/threat-protection/security-policy-settings/network-security-restrict-ntlm-audit-ntlm-authentication-in-this-domain>
- Microsoft Learn, events to monitor in AD: <https://learn.microsoft.com/windows-server/identity/ad-ds/plan/appendix-l--events-to-monitor>
