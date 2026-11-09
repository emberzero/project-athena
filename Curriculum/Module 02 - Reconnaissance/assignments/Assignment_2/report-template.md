# Module 02 Assignment 2: Server Enumeration Report

- **Name:** _your name_
- **Date:** _date_
- **Target IP:** _e.g. 10.10.0.100_

## 1. Introduction

_Briefly: what server enumeration is, and the goal of this assignment._

## 2. Scanning Process

_The commands you ran and the relevant output. Explain what each step was for._

```text
<paste your nmap commands and output here>
```

## 3. Discovered Services

| Port | Service | Version | Notes |
| --- | --- | --- | --- |
|  |  |  |  |

## 4. Enumeration

### 4.1 File sharing (SMB)

- **Share name:** _..._
- **Files in the share:** _..._
- **Quoted line from one file:** _..._

```text
<paste your smbclient / enum4linux commands and output here>
```

### 4.2 Network management (SNMP)

- **Community string:** _..._
- **System name:** _..._
- **Location:** _..._
- **Contact:** _..._

```text
<paste your snmpwalk / snmp-check commands and output here>
```

_Why is it a problem that these answer an anonymous client?_

## 5. Analysis

_For each service: what it does, its risks, and any known vulnerabilities. Cite NVD/CVE entries._

## 6. Conclusion

_The key findings of your enumeration._

---

## Bonus Points Task: Vulnerability Exploitation

_Remove this section if you did not attempt the bonus._

- **Vulnerability identified:** _service + CVE_
- **Flag:** `FLAG{...}`

_How you found the vulnerability, the exploitation steps (with screenshots/logs), and how it could be mitigated._
