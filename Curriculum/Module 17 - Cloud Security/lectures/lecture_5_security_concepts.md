# Cloud Computing Security Concepts

Cloud security is a set of overlapping controls. This lecture walks through the eight areas that matter most in practice.

## 1. Network Security

### Overview

Network security in the cloud covers protecting data while it crosses a network and keeping the communication between cloud components secure.

### Best Practices

- **Virtual Private Clouds (VPCs):** Implement VPCs to isolate resources logically and control network traffic.
- **Network Access Control Lists (NACLs):** Define rules at the subnet level to control incoming and outgoing traffic.
- **Encryption:** Encrypt data in transit with TLS for web traffic and VPNs or private interconnects for network links. Note that SSL and TLS 1.0/1.1 are deprecated and should be disabled. "SSL" in product names and documentation almost always means TLS today.
- **DDoS Mitigation:** Deploy measures to mitigate Distributed Denial of Service (DDoS) attacks through traffic filtering and load balancing.

### Tools

- **Virtual Private Clouds (VPCs):**

  - AWS Virtual Private Cloud (VPC)

  - Azure Virtual Network
  - Google Cloud Virtual Private Cloud (VPC)

- **Network Access Control Lists (NACLs):**

  - AWS Network ACLs

  - Azure Network Security Groups (NSGs)
  - Google Cloud VPC Firewall Rules

- **DDoS Mitigation:**

  - AWS Shield

  - Azure DDoS Protection
  - Google Cloud Armor

## 2. Logging and Monitoring

### Overview

Logging and monitoring are how you see what is happening in a cloud environment. Both mean collecting data from the services in use and then analysing and interpreting it, which is what gives you a view of the security and the operation of the infrastructure.

Five things depend on it:

- Threat detection and prevention. Monitoring in real time identifies anomalies, unauthorized access and suspicious activity early enough to react to it.
- Incident response. Detailed logs and live monitoring show the sequence of events leading up to and during an incident, which is what makes the impact of a breach understandable and containable.
- Compliance and forensic analysis. Audit trails are a regulatory requirement, and the same logs are the evidence base for an investigation during and after an incident.
- Performance. Monitoring tracks how cloud services and applications behave, which is how bottlenecks and resource use are found.
- Operational insight. Logs and metrics show how users behave, how applications perform and how healthy the system is, which is what operational decisions should be based on.

### Best Practices

- **Centralized Logging:** Aggregate logs from various cloud services to a central location for analysis.
- **Real-time Monitoring:** Implement real-time monitoring to detect anomalies, unauthorized access, or unusual behavior.
- **Security Information and Event Management (SIEM):** Utilize SIEM tools to correlate and analyze log data for security events.
- **Audit Trails:** Maintain detailed audit trails for compliance and forensic analysis.

### Tools

- **Centralized Logging:**

  - AWS CloudWatch Logs
  - Azure Monitor Logs
  - Google Cloud Logging
  - Grafana Loki

- **Real-time Monitoring:** (metrics rather than logs, a different data type)

  - Prometheus
  - AWS CloudWatch
  - Azure Monitor
  - Google Cloud Monitoring
  - Uptime Kuma
  - Grafana (visualises both metrics and logs; it does not store them)

- **Security Information and Event Management (SIEM):**

  - Splunk

  - ELK Stack (Elasticsearch, Logstash, Kibana)
  - IBM QRadar

- **Audit Trails:**

  - AWS CloudTrail

  - Azure Activity Log
  - Google Cloud Audit Logging

## 3. Incident Response Planning

### Overview

Incident response planning involves preparing for and responding to security incidents promptly to minimize damage and recover from potential breaches. It is a cycle, not a checklist: the output of one incident is the input to the next round of preparation.

```text
  +-> 1 Preparation      playbooks, on-call rota, tabletop exercises
  |        |
  |        v
  |   2 Detection        monitoring alerts, log review, triage
  |        |
  |        v
  |   3 Containment      isolate the resource - but snapshot it
  |        |             first, or you destroy the evidence
  |        v
  |   4 Eradication      remove the foothold, rotate every exposed
  |        |             credential and key
  |        v
  |   5 Recovery         rebuild from a known-good state and
  |        |             verify it is clean before reconnecting
  |        v
  +-- 6 Lessons learned  post-mortem feeds back into preparation
```

The order matters. Shutting down a compromised instance before taking a
snapshot is the most common mistake: it stops the attacker and also removes
any chance of finding out how they got in.

### Best Practices

- **Incident Response Team:** Establish an incident response team with defined roles and responsibilities.
- **Incident Playbooks:** Develop incident response playbooks detailing step-by-step procedures for various types of incidents.
- **Tabletop Exercises:** Conduct regular tabletop exercises to simulate and test incident response plans.
- **Post-Incident Analysis:** Perform post-incident analysis to identify lessons learned and improve response processes.

### Tools

- **Incident Response Team:**

  - PagerDuty

  - ServiceNow Security Incident Response
  - IBM Resilient

- **Incident Playbooks:**

  - Atlassian Jira

  - Swimlane
  - Tines

- **Tabletop Exercises:**

  - AttackIQ

  - Cyberbit Range
  - Scythe

- **Post-Incident Analysis:**

  - FireEye Helix

  - Varonis Incident Response
  - Cybereason

## 4. Data Backup and Recovery

### Overview

Backup and recovery strategies protect data against accidental deletion, corruption, and malicious activity.

### Best Practices

- **Regular Backups:** Schedule regular backups of critical data and ensure their integrity.
- **Offsite Backups:** Store backups in geographically separate locations to mitigate risks of localized disasters.
- **Automated Backup Policies:** Implement automated backup policies to streamline the backup process.
- **Data Encryption:** Encrypt backup data to protect it from unauthorized access.

### Tools

- **Regular Backups:**

  - AWS Backup

  - Azure Backup
  - Google Cloud Storage Transfer Service

- **Offsite Backups:**

  - Backblaze B2 Cloud Storage

  - Veeam Backup & Replication
  - Druva

- **Automated Backup Policies:**

  - Commvault

  - Rubrik
  - Acronis

- **Data Encryption:**

  - Symantec Data Loss Prevention

  - Varonis Data Security Platform
  - McAfee Total Protection for Data Loss Prevention

## 5. Patch Management

### Overview

Patch management involves keeping software and systems up-to-date with the latest security patches to address vulnerabilities.

### Best Practices

- **Automated Patching:** Utilize automated patch management tools to apply updates promptly.
- **Patch Testing:** Test patches in a non-production environment before deploying to production.
- **Regular Audits:** Conduct regular audits to identify and remediate vulnerabilities.
- **Vendor Notifications:** Stay informed about security updates and patches from cloud service providers and software vendors.

### Tools

- **Automated Patching:**

  - AWS Systems Manager

  - Azure Update Management
  - Google Cloud OS Patch Management

- **Patch Testing:**

  - Jenkins

  - Ansible
  - GitLab CI/CD

- **Regular Audits:**

  - Nessus

  - Qualys
  - OpenVAS

- **Vendor Notifications:**

  - National Vulnerability Database (NVD)

  - CISA advisories (the former US-CERT alerts)
  - Common Vulnerabilities and Exposures (CVE)

## 6. Threat Intelligence

### Overview

Threat intelligence involves gathering and analyzing information about potential threats to anticipate and prevent security incidents.

### Best Practices

- **Threat Feeds:** Subscribe to threat intelligence feeds to stay informed about emerging threats.
- **Integration with Security Tools:** Integrate threat intelligence into security tools for proactive threat detection.
- **Continuous Monitoring:** Continuously monitor and update threat intelligence sources for relevance.
- **Information Sharing:** Collaborate with industry peers and share threat intelligence for collective defense.

### Tools

- **Threat Feeds:**

  - AlienVault Open Threat Exchange (OTX)

  - IBM X-Force Exchange
  - Anomali ThreatStream

- **Integration with Security Tools:**

  - ThreatConnect

  - Recorded Future
  - Palo Alto Networks AutoFocus

- **Continuous Monitoring:**

  - MISP (Malware Information Sharing Platform & Threat Sharing)

  - ThreatQ
  - ThreatCrowd

- **Information Sharing:**

  - ISACs (Information Sharing and Analysis Centers)

  - Cyware Threat Intelligence eXchange (CTIX)
  - FS-ISAC (Financial Services Information Sharing and Analysis Center)

## 7. Testing

### Overview

Testing is how a security plan for a cloud system gets checked against reality. Red teaming, penetration testing, vulnerability scanning and audits each examine the environment in a different way. Finding the weaknesses is the first half of the work; feeding them back into the configuration is what actually strengthens the environment.

### The Role of Testing Methodologies

1. **Red Teaming:**

   - *Objective:* Test whether the defenders and their tooling actually detect and stop an attack, by imitating a real adversary over a longer campaign.
   - *Approach:* Work towards a defined goal (for example: reach the production database) using whatever path works, usually without warning the defenders.

1. **Penetration Testing:**

   - *Objective:* Find and report exploitable vulnerabilities in a defined scope: a system, an application, or a network segment.
   - *Approach:* Authorised, time-boxed, scope-limited attacks. Breadth of findings matters more than stealth. Check the provider's testing policy first: scanning or attacking cloud resources you do not own is out of scope and may breach the terms of service.

1. **Vulnerability Scanning:**

   - *Objective:* Automatically identify *known* vulnerabilities and misconfigurations across infrastructure and applications, continuously.
   - *Approach:* Scheduled automated scans. A scanner finds known issues cheaply but cannot chain them together the way a tester can, so it complements rather than replaces testing.

1. **Security Audits:**

   - *Objective:* Check compliance with security policies and industry standards.
   - *Approach:* Review controls and configuration against a defined baseline (for example CIS benchmarks) rather than attacking the system.

### Best Practices

- **Combine the methods:** each one finds a different class of problem; none of them alone gives a full picture.
- **Test repeatedly:** infrastructure and threats both change, so a single annual test only describes the day it was run.
- **Scenario-Based Testing:** base tests on threats that are realistic for your systems, rather than on a generic checklist.
- **Collaborative Red and Blue Teaming:** Have the red and blue teams work together. Each side sees what the other misses, which improves both the testing and the incident response built on it.

### Tools

- **Red Teaming:**

  - Cobalt Strike
  - Red Team Toolkit (RTT)
  - Atomic Red Team

- **Penetration Testing:**

  - Metasploit
  - Burp Suite
  - OWASP ZAP (Zed Attack Proxy)

- **Vulnerability Scanning:**

  - Nexpose
  - OpenVAS
  - Qualys Vulnerability Management

- **Security Audits:**

  - Lynis
  - OpenSCAP
  - Nessus Compliance Checks

### Continuous Improvement

Testing is not a one-off exercise. Re-run it after significant changes to the infrastructure and feed the findings back into configuration baselines and playbooks.

## 8. Shared Responsibility Model

### Overview

The shared responsibility model is a foundational concept in cloud computing: it defines which security responsibilities belong to the cloud service provider (CSP) and which stay with the customer. Providers usually summarise it as security *of* the cloud versus security *in* the cloud.

```text
            Provider's side        |        Your side
  ---------------------------------+--------------------------------
  "Security OF the cloud"          | "Security IN the cloud"
                                   |
  - physical data centres          | - IAM users, roles, keys
  - host OS and hypervisor         | - guest OS patches (IaaS)
  - network backbone               | - firewall / security group rules
  - hardware decommissioning       | - bucket and database access rules
  - availability of the service    | - encryption choices, key handling
  - patching managed services      | - application code and its bugs
                                   |
  Failures here are rare and are   | Most publicly reported cloud data
  handled by the provider.         | breaches start here: a public
                                   | bucket, an over-broad role, or a
                                   | leaked access key.
```

Where the dividing line sits depends on the service model (see the IaaS /
PaaS / SaaS stack in the overview lecture). Moving to a managed service
moves the line, it never removes it.

### Key Components of the Shared Responsibility Model

1. **Infrastructure Security:**

   - *CSP Responsibility:* Secure physical data centers, networking infrastructure, and overall service availability.
   - *Customer Responsibility:* Configure and secure virtual machines, networks, and other resources deployed in the cloud.

1. **Platform Security:**

   - *CSP Responsibility:* Manage and secure the underlying cloud infrastructure, including hypervisors and host operating systems.
   - *Customer Responsibility:* Secure and update operating systems, middleware, and runtime environments within their virtual machines or containers.

1. **Identity and Access Management (IAM):**

   - *CSP Responsibility:* Provide tools for identity management, authentication, and access control.
   - *Customer Responsibility:* Manage user access, permissions, and authentication processes for applications and data.

1. **Data Security:**

   - *CSP Responsibility:* Ensure security and durability of underlying storage infrastructure.
   - *Customer Responsibility:* Encrypt sensitive data, set access controls, and manage data retention policies.

1. **Applications and Endpoints:**

   - *CSP Responsibility:* Offer a secure platform for hosting applications and may provide security features.
   - *Customer Responsibility:* Develop, secure, and monitor applications, as well as ensure endpoint security.

1. **Security Monitoring and Incident Response:**

   - *CSP Responsibility:* Monitor overall infrastructure health and security, provide tools for incident detection.
   - *Customer Responsibility:* Monitor applications, data, and user activities, and respond to security incidents related to their resources.

### Best Practices

Keep the communication channels between provider and customer open, so both sides agree on who owns which control. Track the changes a provider makes to its model and pass them on to the people affected. Write the resulting split into security policies and enforce them.

### Advantages of the Shared Responsibility Model

The model splits security responsibilities between provider and customer along the lines of who has the expertise for each part. Customers keep the freedom to adapt their own controls to their needs, and neither side duplicates work the other is already doing.

### Challenges and Considerations

Both the provider and the customer need a clear understanding of where the demarcation lines for their responsibilities run. Security measures also need regular reassessment, because the threats they were chosen against keep changing.

## Sources

- [Trend Micro](https://www.trendmicro.com/vinfo/us/security/news/virtualization-and-cloud/cloud-security-key-concepts-threats-and-solutions)
- [GCP Network Security](https://cloud.google.com/learn/what-is-cloud-network-security?hl=en)
- [Java Challengers Logging & Monitoring](https://javachallengers.com/logging-and-monitoring/)
- [eccouncil (general)](https://www.eccouncil.org/cybersecurity/what-is-cloud-security/)
- [opentext backup](https://www.opentext.com/what-is/cloud-backup)
- [ibm backup](https://www.ibm.com/topics/backup-disaster-recovery)
- [thenewstack patching](https://thenewstack.io/what-is-cloud-patch-management/)
- [bearingpoint pentesting](https://bearingpoint.services/besecure/en/pentests/)
