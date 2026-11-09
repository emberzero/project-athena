# Information Gathering

Information Gathering is the systematic process of collecting, analyzing, and cataloging data about a target system, network, or organization. This critical phase transforms raw data into actionable intelligence by uncovering the target's architecture, identifying potential vulnerabilities, and mapping security mechanisms. Whether conducting a penetration test, security assessment, or threat analysis, effective information gathering determines the success of subsequent operations by providing the strategic and technical context needed for informed decision-making.

## The Information Gathering Process

Information gathering follows a structured methodology:

1. **Define Scope**: Establish clear boundaries for what information to collect
2. **Collect Data**: Use multiple techniques and tools to gather information
3. **Validate Information**: Verify accuracy through cross-referencing sources
4. **Analyze Findings**: Identify patterns, vulnerabilities, and opportunities
5. **Document Results**: Create organized reports for future reference
6. **Continuous Monitoring**: Update information as the target evolves

## Types of Information to Gather

### Network Infrastructure

- IP address ranges and CIDR blocks
- Domain names and subdomains
- DNS server configurations
- Network topology and routing
- Firewall and security device placement
- Content Delivery Networks (CDNs)

### Systems and Services

- Operating systems and versions
- Running services and open ports
- Application versions and patch levels
- Web servers and frameworks
- Database systems
- API endpoints

### Organizational Information

- Company structure and departments
- Employee names, roles, and contact information
- Email address formats
- Physical locations and office addresses
- Business partners and vendors
- Technology stack and tools in use

### Security Posture

- Security products deployed (firewalls, IDS/IPS, antivirus)
- Authentication mechanisms
- Security policies and procedures
- Incident response capabilities
- Compliance requirements (PCI-DSS, HIPAA, GDPR)

## NMAP (Network Mapper)

NMAP is the industry-standard open-source tool for network discovery and security auditing, created by Gordon "Fyodor" Lyon. Originally released in 1997, NMAP has evolved into the most comprehensive and flexible network scanning tool available, used by security professionals, system administrators, and penetration testers worldwide. Its versatility stems from its extensive scanning techniques, scriptable interface (NSE), and cross-platform compatibility.

### Core Capabilities of NMAP

#### 1. Host Discovery

Identify which systems are online and reachable on a network without performing port scans.

**Techniques**:

- **Ping Scan**: ICMP echo requests
- **TCP SYN Discovery**: Sends SYN packets to common ports
- **TCP ACK Discovery**: Uses ACK packets to bypass simple firewalls
- **UDP Discovery**: Sends UDP packets to detect hosts
- **ARP Scan**: Layer 2 discovery for local networks (most reliable for LAN)

**Example**:

```bash
# Basic ping scan (no port scan)
nmap -sn 192.168.1.0/24

# Disable ping, assume all hosts are up
nmap -Pn 192.168.1.10

# ARP scan for local network (requires root/admin)
nmap -PR 192.168.1.0/24
```

```text
  nmap -sn (no root)   IP-level probes only
    you  --probe-->         host
                            host firewall silently drops it
    you  <---- nothing ---- host     => reported as "down"

  nmap -PR   ARP, same LAN segment only
    you  --"who has 192.168.1.42?"-->  broadcast
    you  <--"that is me, aa:bb:cc"---  host

  A host may refuse to answer an IP probe. It cannot refuse ARP
  and still use IPv4 on the segment, which is why -PR finds
  hosts that -sn misses - and only on the local network.
  As root on the same LAN, -sn already uses ARP by itself.
```

#### 2. Port Scanning

Determine which ports are open, closed, or filtered on target systems.

**Scan Types**:

- **TCP SYN Scan** (`-sS`): Stealthy, doesn't complete TCP handshake (requires root)
- **TCP Connect Scan** (`-sT`): Completes full TCP connection (works without root)
- **UDP Scan** (`-sU`): Scans UDP ports (slower, often filtered)
- **Comprehensive**: `-sS -sU` scans both TCP and UDP

```text
  TCP Connect scan (-sT)      full handshake, the service logs it
    you  --SYN-->      port
    you  <--SYN/ACK--  port   port is open
    you  --ACK-->      port   connection now established
    you  --RST/FIN-->  port   and immediately torn down
    => an entry in the application's own connection log

  TCP SYN scan (-sS)          half-open, no session is created
    you  --SYN-->      port
    you  <--SYN/ACK--  port   port is open
    you  --RST-->      port   aborted before completion
    => no application log entry, but the firewall, the IDS and
       any flow collector still see every packet

  Closed port: answers RST.  Filtered port: nothing, or an
  ICMP unreachable error.
```

**Port Specifications**:

- Specific ports: `-p 22,80,443`
- Port ranges: `-p 1-1000`
- All ports: `-p-` (1-65535)
- Top ports: `--top-ports 100`
- Protocol-specific: `-p T:80,443,U:53,161`

#### 3. Version Detection

Identify the specific application and version running on open ports by analyzing service responses and fingerprints.

**Example**:

```bash
# Service version detection
nmap -sV 192.168.1.10

# Aggressive version detection (more probes)
nmap -sV --version-intensity 9 192.168.1.10

# Light version detection (fewer probes)
nmap -sV --version-intensity 2 192.168.1.10
```

**Sample Output**:

```text
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.5
80/tcp   open  http    Apache httpd 2.4.41 ((Ubuntu))
3306/tcp open  mysql   MySQL 5.7.22-0ubuntu0.18.04.1
```

#### 4. Operating System Detection

Determine the operating system and hardware characteristics through TCP/IP stack fingerprinting.

**Example**:

```bash
# OS detection (requires root)
nmap -O 192.168.1.10

# Aggressive OS detection with version scanning
nmap -A 192.168.1.10

# OS detection without port scan
nmap -O -Pn --osscan-guess 192.168.1.10
```

### Essential NMAP Command Reference

#### Basic Scans

```bash
# Quick scan of most common 100 ports
nmap --top-ports 100 192.168.1.10

# Scan specific ports
nmap -p 80,443,8080 192.168.1.10

# Fast scan (T4 timing)
nmap -F -T4 192.168.1.10

# Comprehensive scan
nmap -p- -sV -sC -O 192.168.1.10
```

#### Timing Templates

NMAP offers timing templates (-T0 through -T5) to control scan speed:

- **T0 (Paranoid)**: Extremely slow, IDS evasion (5 minutes between probes)
- **T1 (Sneaky)**: Slow, IDS evasion (15 seconds between probes)
- **T2 (Polite)**: Slows down to use less bandwidth
- **T3 (Normal)**: Default timing
- **T4 (Aggressive)**: Fast scan, assumes reliable network
- **T5 (Insane)**: Very fast, may sacrifice accuracy

```bash
# Stealthy slow scan
nmap -sS -T1 192.168.1.10

# Fast aggressive scan
nmap -T4 192.168.1.0/24
```

#### Output Formats

```bash
# Normal output to file
nmap -oN scan_results.txt 192.168.1.10

# XML output (parseable)
nmap -oX scan_results.xml 192.168.1.10

# Grepable output
nmap -oG scan_results.gnmap 192.168.1.10

# All formats at once
nmap -oA scan_results 192.168.1.10

# Script kiddie output (just for fun)
nmap -oS scan_results.txt 192.168.1.10
```

#### Advanced Techniques

```bash
# Scan using decoy addresses (obfuscation)
nmap -D RND:10 192.168.1.10

# Fragment packets (IDS/firewall evasion)
nmap -f 192.168.1.10

# Spoof source port
nmap --source-port 53 192.168.1.10

# Scan through proxy
nmap --proxies http://proxy:8080 192.168.1.10

# IPv6 scanning
nmap -6 fe80::1
```

### NMAP Scripting Engine (NSE)

NSE extends NMAP's capabilities with hundreds of scripts for vulnerability detection, exploitation, and advanced enumeration.

#### Script Categories

- **auth**: Authentication testing
- **broadcast**: Network discovery via broadcast
- **brute**: Brute force attacks
- **default**: Default safe scripts (-sC)
- **discovery**: Additional network discovery
- **dos**: Denial of service testing
- **exploit**: Exploitation attempts
- **intrusive**: May crash services
- **malware**: Malware detection
- **safe**: Won't affect target
- **version**: Enhanced version detection
- **vuln**: Vulnerability detection

#### Using NSE Scripts

```bash
# Run default safe scripts
nmap -sC 192.168.1.10

# Run specific script
nmap --script=http-title 192.168.1.10

# Run multiple scripts
nmap --script=http-enum,http-headers 192.168.1.10

# Run all scripts in category
nmap --script=vuln 192.168.1.10

# Run scripts with wildcards
nmap --script="http-*" 192.168.1.10

# Pass arguments to scripts
nmap --script=http-brute --script-args userdb=users.txt,passdb=pass.txt 192.168.1.10
```

#### Popular NSE Scripts

```bash
# HTTP enumeration
nmap --script=http-enum -p 80 192.168.1.10

# SMB vulnerability detection
nmap --script=smb-vuln-* -p 445 192.168.1.10

# SSL/TLS analysis
nmap --script=ssl-enum-ciphers -p 443 192.168.1.10

# DNS zone transfer attempt
nmap --script=dns-zone-transfer --script-args=dns-zone-transfer.domain=example.com -p 53 ns1.example.com

# Database detection and enumeration
nmap --script=mysql-info,mysql-databases -p 3306 192.168.1.10
```

### Practical NMAP Workflow

```text
  Phase 1         Phase 2         Phase 3         Phase 4
  nmap -sn   -->  nmap -p-   -->  nmap -sV   -->  nmap
  (ping sweep)    --open -T4      -sC -O          --script=vuln
  |               |               |               |
  v               v               v               v
  discovery.      all_ports.*     service_scan.*  vuln_scan.*
  gnmap
  |
  +-- grep "Status: Up" --> live_hosts.txt
        feeds the -iL list of phases 2 and 3
```

#### Phase 1: Quick Discovery

```bash
# Find live hosts
nmap -sn 192.168.1.0/24 -oA discovery

# Extract live hosts
grep "Status: Up" discovery.gnmap | cut -d ' ' -f 2 > live_hosts.txt
```

#### Phase 2: Port Scanning

```bash
# Fast scan for open ports
nmap -iL live_hosts.txt -p- --open -T4 -oA all_ports

# Focus on specific hosts with many open ports
nmap -iL high_value_targets.txt -p- -T4 -oA detailed_ports
```

#### Phase 3: Service Enumeration

```bash
# Version detection on discovered ports
nmap -iL live_hosts.txt -sV -sC -O -oA service_scan

# Deep version scanning
nmap -p <discovered_ports> -sV --version-intensity 9 -oA deep_versions
```

#### Phase 4: Vulnerability Assessment

```bash
# Run vulnerability scripts
nmap -iL targets.txt --script=vuln -oA vuln_scan

# Target-specific vulnerability checks
nmap -p 445 --script=smb-vuln-ms17-010 192.168.1.10
```

### Hands-on Exercise

#### Exercise 1: Network Discovery

Scan a network you own, such as your home LAN or a lab you set up. **Not** the
school or company network: it is someone else's, and scanning it without asking
is exactly the thing the rest of this lecture tells you not to do.

1. Find active hosts: `nmap -sn 192.168.1.0/24` (adjust the range to your network)
2. Compare with an ARP scan: `sudo nmap -PR 192.168.1.0/24`
3. Document: which method found more hosts, and why?

The ARP scan usually wins on a local network, because a host can refuse to answer
a ping but cannot refuse ARP and still use the network.

#### Exercise 2: Service Fingerprinting

1. Identify a test system (your own VM or authorized lab)
2. Run: `nmap -p- -sV -sC <target>`
3. Analyze output:
   - What services are running?
   - Are any versions outdated?
   - What do the NSE scripts reveal?

#### Exercise 3: Comparing Scan Types

1. Run TCP SYN scan: `sudo nmap -sS <target>`
2. Run TCP Connect scan: `nmap -sT <target>`
3. Run UDP scan: `sudo nmap -sU --top-ports 20 <target>`
4. Document: Compare speed, results, and system logs

#### Exercise 4: NSE Script Exploration

1. List available HTTP scripts: `ls /usr/share/nmap/scripts/ | grep http`
2. Read script documentation: `nmap --script-help http-enum`
3. Run against test web server: `nmap --script=http-enum -p 80,443 <target>`
4. Analyze discovered paths and directories

### Interpreting NMAP Results

#### Port States

- **open**: Service is actively accepting connections
- **closed**: Port is accessible but no service listening
- **filtered**: Firewall/filter is blocking probe (inconclusive)
- **unfiltered**: Port is accessible but state undetermined
- **open|filtered**: Cannot determine if open or filtered (UDP scans)
- **closed|filtered**: Cannot determine if closed or filtered (rare)

**Seeing why**: add `--reason` and NMAP prints the packet that led to each verdict.
This is the difference between trusting the tool and understanding it:

```bash
nmap --reason -p 22,80,443 192.168.1.10
```

```text
PORT    STATE    SERVICE REASON
22/tcp  open     ssh     syn-ack ttl 64
80/tcp  closed   http    reset ttl 64
443/tcp filtered https   no-response
```

A RST came back from port 80, so the host is reachable and nothing is listening.
Port 443 produced silence, which is what a firewall that drops packets looks like.
"Filtered" is not a result, it is the absence of one.

#### Common Port Numbers

| Port | Service | Description |
|------|---------|-------------|
| 21 | FTP | File Transfer Protocol |
| 22 | SSH | Secure Shell |
| 23 | Telnet | Unencrypted remote access |
| 25 | SMTP | Email transmission |
| 53 | DNS | Domain Name System (TCP and UDP) |
| 80 | HTTP | Web traffic |
| 110 | POP3 | Email retrieval |
| 139 | NetBIOS | Legacy Windows file sharing |
| 143 | IMAP | Email retrieval |
| 161 | SNMP | Network management (**UDP only**) |
| 389 | LDAP | Directory services, Active Directory |
| 443 | HTTPS | Encrypted web traffic |
| 445 | SMB | Windows file sharing |
| 1433 | MSSQL | Microsoft SQL Server |
| 2049 | NFS | Unix/Linux file sharing |
| 3306 | MySQL | MySQL database |
| 3389 | RDP | Remote Desktop Protocol |
| 5432 | PostgreSQL | PostgreSQL database |
| 8080 | HTTP-ALT | Alternative HTTP port |

Most of these have an enumeration section later in this lecture. Note the
protocol: SNMP on 161 is **UDP only**, so a default TCP scan reports nothing at
all for it. DNS listens on both, and uses TCP mainly for zone transfers and
oversized responses.

### NMAP Best Practices

#### Performance Optimization

- Use `-T4` for most scans on reliable networks
- Scan top ports first: `--top-ports 1000`
- Parallelize: Scan multiple targets simultaneously
- Exclude unresponsive hosts with initial ping scan
- Use `--min-rate` and `--max-rate` for rate control

#### Stealth and Evasion

- Use SYN scans (`-sS`) instead of connect scans
- Randomize scan order: `--randomize-hosts`
- Fragment packets: `-f`
- Slow timing: `-T0` or `-T1`
- Decoy addresses: `-D RND:10` hides your IP among nine fake ones

**A reality check on "stealth".** These techniques are much weaker than their
names suggest:

- A SYN scan is only stealthy against *application* logs. It never completes the
  handshake, so the service never logs a connection, but the firewall, the IDS
  and any flow collector see it perfectly well. `-sS` does not make you invisible,
  it just means the web server's access log stays clean.
- Fragmentation and source-port tricks defeat simple packet filters from the
  1990s. Any modern stateful firewall reassembles fragments before inspecting them.
- Source-IP spoofing (`-S`) is *not* in the list above for a reason: the replies
  go to the address you spoofed, not to you, so you learn nothing. It is only
  useful in specific setups where you can also observe the spoofed host's traffic.
- Real stealth is slow timing plus patience. `-T0` across a week is harder to spot
  than any flag. That is rarely compatible with a time-boxed engagement, which is
  why most authorized tests simply do not bother hiding.

#### Legal and Ethical Considerations

- **Always obtain written authorization before scanning**
- Stay within defined scope (IP ranges, ports)
- Use appropriate timing to avoid DoS
- Document all scan activities with timestamps
- Respect bandwidth and system resources

**Scanning can break things.** This is not a theoretical risk. Embedded and
industrial devices (printers, IP cameras, building controls, medical equipment,
PLCs) often have fragile network stacks that were never tested against a port
scanner. A `-T5 -p-` sweep has knocked such devices offline, and in an industrial
network that can mean a stopped production line. Rules of thumb:

- Default to `-T3` on anything you do not recognize, and `-T4` only on ordinary
  IT networks you know are healthy
- Never scan OT, ICS or medical networks without the owner's explicit sign-off,
  and then only with timing they approve
- `--max-rate` caps packets per second when you need a hard ceiling
- If a host stops responding mid-scan, stop and tell someone. Do not scan it again
  to check

### Common Errors and Troubleshooting

#### "You requested a scan type which requires root privileges"

**Cause**: SYN scan, OS detection, or certain features require root
**Solution**: Use `sudo nmap` or run as administrator

#### "Note: Host seems down"

**Causes**: Host is actually down, firewall blocking, ICMP disabled
**Solutions**:

- Use `-Pn` to skip host discovery
- Try different discovery methods: `-PS`, `-PA`, `-PU`
- Check with `ping` and `traceroute`

#### Slow UDP Scans

**Cause**: UDP is connectionless, requires timeouts
**Solutions**:

- Scan only essential UDP ports: `--top-ports 20`
- Increase parallelism: `--min-parallelism 100`
- Use faster timing: `-T4`

#### No Version Information Detected

**Causes**: Service on non-standard port, custom software
**Solutions**:

- Increase version intensity: `--version-intensity 9`
- Try `-A` for aggressive detection
- Manual banner grabbing with Netcat

## Enumeration

Enumeration is the aggressive phase of information gathering where you extract granular details from identified services and systems. Unlike reconnaissance, which casts a wide net, enumeration drills deep into specific targets to extract user accounts, shares, configurations, and other sensitive data. This phase bridges scanning and exploitation by providing the specific details needed to compromise systems.

### The Enumeration Process

1. **Identify service/protocol** (from port scanning)
2. **Query service** for detailed information
3. **Extract data** systematically
4. **Validate findings** through cross-referencing
5. **Document** for exploitation phase

### Enumeration Techniques by Service

#### NetBIOS/SMB Enumeration (Windows Networks)

**Purpose**: Extract Windows network information including shares, users, groups, and policies.

**Ports**: 137 (NetBIOS Name), 139 (NetBIOS Session), 445 (SMB)

**Anonymous (null) sessions**: SMB allows a client to connect without supplying
credentials. Many servers still accept such a session and will happily answer
"which shares do you have?" and, if a share is marked guest-readable, "what is in
them?". That is what the `-N` flag in the commands below means: no password, no
account. An anonymous share listing is the single most common finding in an
internal engagement, because it needs no exploit and leaves an ordinary-looking
file-sharing connection in the logs.

**Tools and Commands**:

```bash
# Enum4linux - Comprehensive SMB enumeration
enum4linux -a 192.168.1.10

# Enum4linux with username/password
enum4linux -u admin -p password -a 192.168.1.10

# NBTscan - NetBIOS name scanning
nbtscan 192.168.1.0/24

# SMBClient - List shares
smbclient -L //192.168.1.10 -N

# SMBMap - Share enumeration
smbmap -H 192.168.1.10

# CrackMapExec - Multi-function SMB tool
crackmapexec smb 192.168.1.10 --shares
```

**Information Extracted**:

- Workgroup/domain name
- Operating system and version
- User accounts and groups
- Password policies
- Network shares and permissions
- Logged-in users
- RID cycling results

**Example enum4linux Output Analysis**:

```text
[+] Got OS info for 192.168.1.10 from smbclient
[+] Got domain/workgroup name: WORKGROUP
[+] Password Info for Domain: WORKGROUP
    [+] Minimum password length: 7
    [+] Password history length: None
    [+] Maximum password age: 42 Days

[+] Users on 192.168.1.10
    user:[Administrator] rid:[0x1f4]
    user:[Guest] rid:[0x1f5]
    user:[john.doe] rid:[0x3e8]
```

#### SNMP Enumeration

**Purpose**: Extract device configurations, network topology, and system information from SNMP-enabled devices.

**Port**: 161 (UDP)

**Why scans miss it**: SNMP speaks UDP only. The default `nmap` scan is TCP, so a
host running SNMP looks like it has no such service unless you explicitly scan UDP
(`-sU`). A full UDP sweep is slow, so in practice you scan the top ports
(`sudo nmap -sU --top-ports 20 <target>`) and accept that you may miss exotic ones.

**Tools and Commands**:

```bash
# SNMPwalk - Walk entire MIB tree
snmpwalk -v 2c -c public 192.168.1.1

# Enumerate specific OIDs
snmpwalk -v 2c -c public 192.168.1.1 1.3.6.1.2.1.1  # System info
snmpwalk -v 2c -c public 192.168.1.1 1.3.6.1.2.1.2  # Interfaces
snmpwalk -v 2c -c public 192.168.1.1 1.3.6.1.2.1.25 # Host resources

# onesixtyone - SNMP community string scanner
onesixtyone -c community.txt 192.168.1.0/24

# snmp-check - Comprehensive SNMP enumerator
snmp-check 192.168.1.1
```

**Common Community Strings** (try these):

- public (read-only, most common)
- private (read-write)
- manager
- admin

**Information Extracted**:

- Device hostnames and descriptions
- Network interface configurations
- Routing tables
- Running processes
- Installed software
- User accounts
- TCP/UDP connections

#### LDAP Enumeration (Directory Services)

**Purpose**: Extract organizational structure, user accounts, and configurations from LDAP directories (Active Directory).

**Ports**: 389 (LDAP), 636 (LDAPS), 3268 (Global Catalog)

**Tools and Commands**:

```bash
# ldapsearch - Query LDAP directory
ldapsearch -x -h 192.168.1.10 -s base namingcontexts

# Extract all users
ldapsearch -x -h 192.168.1.10 -b "dc=example,dc=com" "(objectClass=person)"

# Extract all groups
ldapsearch -x -h 192.168.1.10 -b "dc=example,dc=com" "(objectClass=group)"

# Authenticated search
ldapsearch -x -h 192.168.1.10 -D "cn=admin,dc=example,dc=com" -w password -b "dc=example,dc=com"

# NMAP NSE script
nmap -p 389 --script ldap-search --script-args 'ldap.base="dc=example,dc=com"' 192.168.1.10
```

**Information Extracted**:

- Domain structure and organization units
- User accounts with attributes (email, phone, title)
- Group memberships
- Computer accounts
- Password policies
- Service accounts
- Privileged user groups (Domain Admins, Enterprise Admins)

#### SMTP Enumeration (Mail Servers)

**Purpose**: Verify email addresses and extract user information from mail servers.

**Port**: 25 (SMTP), 587 (Submission)

**Techniques**:

```bash
# VRFY - Verify email address
telnet mail.example.com 25
> VRFY admin
> VRFY john.doe

# EXPN - Expand mailing list
> EXPN administrators

# smtp-user-enum - Automated enumeration
smtp-user-enum -M VRFY -U users.txt -t mail.example.com

# NMAP NSE script
nmap -p 25 --script smtp-enum-users --script-args smtp-enum-users.methods={VRFY,EXPN,RCPT} 192.168.1.10
```

**Information Extracted**:

- Valid email addresses
- Mail server version and configuration
- Mailing list memberships
- User account existence

#### DNS Enumeration

**Purpose**: Discover subdomains, map network infrastructure, and identify services.

**Port**: 53 (TCP/UDP)

**Tools and Commands**:

```bash
# Zone transfer attempt
dig @ns1.example.com example.com AXFR
host -l example.com ns1.example.com

# DNSenum - Comprehensive DNS enumeration
dnsenum example.com

# Fierce - DNS reconnaissance
fierce --domain example.com

# Sublist3r - Subdomain discovery
sublist3r -d example.com

# Amass - In-depth DNS enumeration
amass enum -d example.com

# NMAP NSE script
nmap --script dns-zone-transfer --script-args dns-zone-transfer.domain=example.com -p 53 ns1.example.com
```

**Information Extracted**:

- All DNS records (A, AAAA, MX, TXT, NS, CNAME, SOA)
- Subdomains and related domains
- Mail servers
- Name servers
- SPF, DKIM, DMARC records
- IPv4 and IPv6 addresses

#### NFS Enumeration (Network File System)

**Purpose**: Discover exported file systems and mount points on Unix/Linux systems.

**Port**: 2049

**Tools and Commands**:

```bash
# Show exported shares
showmount -e 192.168.1.10

# NMAP NSE scripts
nmap -p 2049 --script nfs-ls,nfs-showmount,nfs-statfs 192.168.1.10

# Mount NFS share
mount -t nfs 192.168.1.10:/share /mnt/nfs
```

#### Database Enumeration

**Purpose**: Extract database versions, schemas, users, and accessible data.

**Common Ports**: 1433 (MSSQL), 3306 (MySQL), 5432 (PostgreSQL), 1521 (Oracle)

**Tools and Commands**:

```bash
# MySQL
nmap --script mysql-info,mysql-databases,mysql-users -p 3306 192.168.1.10
mysql -h 192.168.1.10 -u root -p

# PostgreSQL
nmap --script pgsql-brute -p 5432 192.168.1.10
psql -h 192.168.1.10 -U postgres

# MSSQL
nmap --script ms-sql-info,ms-sql-config -p 1433 192.168.1.10
sqsh -S 192.168.1.10 -U sa -P password
```

### Comprehensive Enumeration Toolkit

#### Essential Tools

| Tool | Purpose | Best For |
|------|---------|----------|
| enum4linux | SMB/NetBIOS enumeration | Windows networks |
| ldapsearch | LDAP querying | Active Directory |
| snmpwalk | SNMP enumeration | Network devices |
| dnsenum | DNS enumeration | Domain reconnaissance |
| nikto | Web server scanning | Web applications |
| gobuster | Directory brute-forcing | Web paths |
| ffuf | Web fuzzing | Hidden resources |
| Nmap NSE | Multi-protocol enumeration | All services |

#### Enumeration Workflow Example

```bash
# 1. Identify services (from previous NMAP scan)
# 2. Enumerate each service methodically

# SMB/NetBIOS (if ports 139/445 open)
enum4linux -a 192.168.1.10 | tee enum4linux.txt

# SNMP (if port 161 open)
snmp-check 192.168.1.10 | tee snmp.txt

# LDAP (if port 389 open)
ldapsearch -x -h 192.168.1.10 -s base | tee ldap.txt

# HTTP/HTTPS (if ports 80/443 open)
nikto -h http://192.168.1.10 | tee nikto.txt
gobuster dir -u http://192.168.1.10 -w /usr/share/wordlists/dirb/common.txt | tee gobuster.txt

# SMTP (if port 25 open)
smtp-user-enum -M VRFY -U users.txt -t 192.168.1.10 | tee smtp.txt
```

### Hands-on Enumeration Exercises

#### Exercise 1: SMB Enumeration

Use the course lab target (see Assignment 2) or any host you are authorized to test.

1. List the shares without credentials: `smbclient -L //<target_ip> -N`
2. Open a share that allows it and list its contents:
   `smbclient //<target_ip>/<share> -N -c ls`
3. Run the broader sweep: `enum4linux -a <target_ip>`
4. Analyze the output:
   - What is the workgroup and the server name?
   - Which shares exist, and which answer an anonymous client?
   - What is in the readable share, and would you expect it to be public?
   - Does the server disclose users or a password policy, or only shares?

A server that reveals shares but no accounts is already a finding. Note what you
got *and* what stayed closed, because the difference tells you how the server is
configured.

#### Exercise 2: SNMP Enumeration

1. SNMP is UDP-only, so find it first: `sudo nmap -sU --top-ports 20 <target_ip>`
2. Guess the community string. Start with the defaults (`public`, `private`), or
   let a scanner try a list: `onesixtyone -c community.txt <target_ip>`
3. Read the system branch of the MIB tree:
   `snmpwalk -v 2c -c <community> <target_ip> 1.3.6.1.2.1.1`
4. Analyze the output:
   - What is the device's name, location and contact?
   - How much of this would help someone planning a phone-based pretext?
   - What else does the agent expose beyond the system branch?

#### Exercise 3: DNS Enumeration

1. Choose a domain (your organization or authorized target)
2. Run: `dnsenum example.com`
3. Attempt zone transfer: `dig @ns1.example.com example.com AXFR`
4. Document:
   - How many subdomains found?
   - Was zone transfer successful?
   - What services were identified?

#### Exercise 4: Web Enumeration

1. Identify a web server (authorized testing only)
2. Run: `nikto -h http://target.com`
3. Run: `gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt`
4. Analyze:
   - What directories/files were found?
   - What vulnerabilities were identified?
   - What server version is running?

### Enumeration Best Practices

#### Systematic Approach

- Enumerate every discovered service, including the ones that look dull
- Document all findings in structured format
- Cross-reference information from multiple sources
- Validate findings before relying on them

#### Stealth Considerations

- Enumeration is noisy and logged by target systems
- Use appropriate timing and rate limiting
- Consider detection risk vs. information value
- Authenticated enumeration blends in with normal traffic, but it is **fully
  attributable**: every query is tied to the account you used, with a username in
  the log. Anonymous enumeration is more likely to raise an alert and less likely
  to identify you. Neither is "safer" in general; they fail differently.

#### Legal and Ethical

- Enumeration often crosses from passive to active
- Always operate within authorized scope
- Some enumeration techniques may trigger security alerts
- Document all enumeration activities with timestamps

### Defensive Countermeasures

Organizations can limit enumeration effectiveness:

- Close SMB, SNMP and any other service that is not needed on public-facing systems.
- Change the default SNMP community strings to something that cannot be guessed.
- Block anonymous SMB enumeration by restricting null sessions.
- Require authentication for LDAP; refuse anonymous binds.
- Disable DNS zone transfers and use split-horizon DNS.
- Strip system details out of error messages.
- Monitor for enumeration attempts and alert on suspicious query patterns.

## Additional Tools for Information Gathering

### Subdomain Discovery

- **Sublist3r**: Python tool aggregating multiple search engines
- **Amass**: Comprehensive subdomain enumeration
- **Assetfinder**: Fast subdomain discovery
- **Subfinder**: Modern subdomain enumeration tool

### Web Application Analysis

- **Nikto**: Web server vulnerability scanner
- **Gobuster**: Directory and DNS busting tool
- **Ffuf**: Fast web fuzzer
- **WhatWeb**: Web technology identifier
- **Wappalyzer**: Technology profiler (browser extension)

### Credential Harvesting

- **theHarvester**: Email and subdomain harvester
- **LinkedIn2Username**: Generate username lists from LinkedIn
- **Hunter.io**: Email address finder (web service)

### Metadata Analysis

- **ExifTool**: Read metadata from images, PDFs, documents
- **FOCA**: Fingerprinting Organizations with Collected Archives
- **Metagoofil**: Metadata extractor for public documents

## Key Takeaways

- Information gathering is systematic, not random exploration
- NMAP is the foundational tool for network reconnaissance
- Enumeration provides the granular details needed for exploitation
- Different services require different enumeration techniques
- Always operate within legal and authorized boundaries
- Combine automated tools with manual verification
- Document everything for future reference and reporting
- Defenders should enumerate their own systems regularly

## Resources

### Books

- **"Nmap Network Scanning"** by Gordon Fyodor Lyon - The definitive NMAP guide
- **"The Web Application Hacker's Handbook"** by Dafydd Stuttard - Web enumeration techniques
- **"Penetration Testing"** by Georgia Weidman - Comprehensive methodology

### Official Documentation

- **NMAP Documentation**: <https://nmap.org/book/man.html>
- **NMAP NSE Scripts**: <https://nmap.org/nsedoc/>
- **Enum4linux**: <https://github.com/CiscoCXSecurity/enum4linux>
- **NET-SNMP Tools**: <http://www.net-snmp.org/>

### Online Resources

- **HackTricks**: <https://book.hacktricks.xyz/> - Enumeration cheatsheets
- **PayloadsAllTheThings**: <https://github.com/swisskyrepo/PayloadsAllTheThings>
- **Pentesting Tools Cheat Sheet**: <https://highon.coffee/blog/penetration-testing-tools-cheat-sheet/>

### Practice Platforms

- **HackTheBox**: Enumeration-heavy CTF challenges
- **TryHackMe**: Guided enumeration rooms
- **VulnHub**: Vulnerable VMs for practice
- **PentesterLab**: Web application enumeration exercises
