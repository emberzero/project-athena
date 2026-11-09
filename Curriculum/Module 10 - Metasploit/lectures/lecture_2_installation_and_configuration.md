# Installation and Configuration

This lecture gets you from nothing to a working Metasploit installation with a
database behind it. The fastest path is to use Kali Linux, where Metasploit is
preinstalled, but it runs on any major platform. Just as important as
installing it is setting up a safe lab to point it at.

## Installing Metasploit

### On Kali Linux

Metasploit ships with Kali. It is already there; keep it current with the
normal system update:

```bash
sudo apt update && sudo apt full-upgrade
```

Kali is the recommended environment for this module. It also bundles the
vulnerable targets and supporting tools you will want.

### On Debian or Ubuntu

Rapid7 publishes an installer script that adds their package repository and
installs the `metasploit-framework` package:

```bash
# The installer lives in the metasploit-omnibus repo at the path below.
BASE=https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master
SCRIPT=config/templates/metasploit-framework-wrappers/msfupdate.erb
curl -L -o msfinstall "$BASE/$SCRIPT"
chmod 755 msfinstall
less msfinstall   # read it before running anything from the internet
./msfinstall
```

Piping a script straight from the internet into a shell is a habit worth
breaking. Download it, read it, then run it. That is why the command above
saves the file and pages through it first instead of piping it. The same caution
you teach users about is the caution you should model.

### On macOS and Windows

Rapid7 provides native installers for both. On Windows, exclude the Metasploit
directory from Microsoft Defender or the antivirus will quarantine the payload
files as malware, which from Defender's point of view they are. Do this only
on a machine dedicated to lab work, never a daily driver, because you are
deliberately disabling a protection.

## Keeping It Updated

New modules land constantly as vulnerabilities are disclosed. On Kali, update
through `apt` as shown above. The `msfupdate` command exists but on Kali the
packaged `apt` path is preferred and more reliable. Run an update before any
engagement so you have the latest modules.

## The Database

Metasploit works without a database, but with one it becomes far more useful:
scan results, discovered hosts and services, cracked credentials, and collected
loot all persist and can be queried. On a multi-day engagement this is the
difference between organised work and a pile of scrollback.

### Starting It

Kali wires up PostgreSQL for Metasploit with one command:

```bash
sudo msfdb init
```

This creates the database, a role, and the configuration file Metasploit reads
on startup. Related commands:

```bash
sudo msfdb status     # is the database running?
sudo msfdb start      # start it
sudo msfdb reinit     # wipe and recreate (destroys stored data)
```

Start PostgreSQL before launching the console so the connection is ready:

```bash
sudo systemctl start postgresql
msfconsole
```

### Checking the Connection

Inside `msfconsole`, confirm the database is connected:

```text
db_status
```

A connected database reports the driver and that it is connected. If it says it
is not connected, exit, run `sudo msfdb init`, make sure PostgreSQL is running,
and try again.

### Workspaces

A workspace is a named container for the data from one engagement or one
target. Keeping each job in its own workspace stops the hosts from one
assessment bleeding into another.

```text
workspace                    list workspaces (* marks the current one)
workspace -a lab_internal    add and switch to a new workspace
workspace lab_internal       switch to an existing workspace
workspace -d old_job         delete a workspace
```

Once a workspace holds data you can query it:

```text
hosts            list discovered hosts
services         list discovered services and ports
vulns            list identified vulnerabilities
creds            list captured credentials
loot             list collected files
```

Modules such as `db_nmap` (an Nmap wrapper that stores results straight into
the database) populate these tables for you:

```text
db_nmap -sV 10.10.10.0/24
hosts
services
```

Use RFC 1918 ranges like `10.10.10.0/24` because that is what your lab should
live on. Scanning anything else needs authorization.

## Configuration Worth Knowing

### Global vs Module Options

You can set an option globally so it applies to every module, which saves
retyping `LHOST` constantly:

```text
setg LHOST 10.10.10.5     # set globally
setg RHOSTS 10.10.10.20   # applies until you unset it
unsetg LHOST              # clear a global
```

Global options are convenient and dangerous: forgetting a stale global `RHOSTS`
is a classic way to fire a module at the wrong host. Check `show options`
before every run.

### Resource Scripts

A resource script is a plain text file of console commands that `msfconsole`
replays on startup, so a repetitive setup becomes one file:

```bash
msfconsole -r setup.rc
```

A `setup.rc` might select a workspace, set globals, and load a module. This is
also how you make repeatable, documented steps for a report.

## Setting Up a Lab Target

You need something legal to attack. The standard practice targets:

- **Metasploitable 2 / 3**: Linux VMs built by Rapid7 to be deliberately
  vulnerable. Metasploitable 2 is the simplest to start with.
- **Vulnerable VMs** from VulnHub, or purpose-built training VMs.
- **Your own VMs** running old, unpatched software on purpose.

Run every target in a **host-only or internal virtual network** so it cannot
reach the internet or your real LAN. A deliberately vulnerable machine exposed
to the network is a machine someone else will compromise. The isolation is not
optional.

A minimal lab layout:

```text
  host-only network 10.10.10.0/24
  +----------------------------+        +----------------------------+
  | Kali attacker              |        | Metasploitable target      |
  | 10.10.10.5                 |------->| 10.10.10.20                |
  | msfconsole, database       |        | deliberately vulnerable    |
  +----------------------------+        +----------------------------+
          no route out to the internet or the real LAN
```

## Key Takeaways

- On Kali, Metasploit is preinstalled; keep it current with `apt`.
- Initialise the database with `sudo msfdb init`, confirm with `db_status`, and
  organise work with workspaces.
- `db_nmap` stores scan results into the database so `hosts`, `services`, and
  `vulns` can be queried later.
- Global options (`setg`) save typing but cause wrong-target mistakes; verify
  `show options` before every run.
- Build an isolated host-only lab with a vulnerable target before attacking
  anything; never expose a vulnerable VM to a real network.

## Resources

- Rapid7, *Installing Metasploit*: <https://docs.metasploit.com>
- Metasploitable project: <https://github.com/rapid7/metasploitable3>
- VulnHub training VMs: <https://www.vulnhub.com>
- Module 01 (Ethics and Legal) for authorization requirements.
