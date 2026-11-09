# Security Information and Event Management (SIEM)

## Introduction

- SIEM combines **security information management (SIM)** and **security event management (SEM)**
- aggregates and analyzes event data from various sources like applications, endpoints, firewalls, and networks.
- assists in quick identification of cyber threats through real-time threat monitoring and alerting capabilities.

The value of a SIEM comes from the pipeline it puts the logs through. A single
log line from one system usually means nothing; it becomes an incident only
once events from several sources are brought into a common format and related
to each other:

```text
  Sources            Pipeline                Output
  ----------------------------------------------------------------
  firewalls     -+
  IDS / IPS     -+
  servers       -+--> [ Collection ]   agents, syslog, API pull
  endpoints     -+          |
  applications  -+          v
  cloud / IAM   -+    [ Normalise ]    one schema: time, user,
                            |          host, action
                            v
                      [ Correlate ]    rules and baselines
                            |          applied across sources
           +----------------+----------------+
           v                v                v
     alerts to the    dashboards and   long-term store
     analyst          reports          (forensics, compliance)
```

Note where the limitation lies: the SIEM only sees sources that are actually
forwarded to it, and correlation rules only find patterns someone has
described. Coverage and tuning, not the product, decide how useful it is.

_source: Security Information and Event Management \[1.\]_

## Core Functions

### Data Correlation and Analysis

Traditional SIEM systems were built around reactive logging and event
management. Recent products work more proactively by taking in new threat data
to identify issues earlier. AI tools narrow the alert window further and
automate parts of the response.

_source: Security Information and Event Management \[3.\]_

### Event Log Management

Log management covers the collection, normalization and analysis of log data,
which is what provides network visibility and makes security incidents
detectable. Current solutions put the emphasis on cloud-based deployment for
flexibility against changing threats. Integration with SOAR (Security
Orchestration, Automation, and Response) tools extends what a SIEM can do,
although the combination stays reactive.

_source: Security Information and Event Management \[3.\], Security Information and Event Management \[4.\]_

### Monitoring and Alerting

A SIEM provides the real-time monitoring and alerting for both cloud and
on-premise infrastructure. AI and automation are used increasingly in SIEM and
SOAR tools to save time in threat response, and there is a growing trend to
move both to the cloud for scalable resources and more automation.

_source: Security Information and Event Management \[4.\], Security Information and Event Management \[3.\]_

## Capabilities

- **Threat Analytics**
  - SIEM systems are evolving to address complex security threats, although they primarily focus on logging and event management
- **Cloud Security**
  - The advancement of cloud-based SIEM solutions since 2020 reflects the need for fast, flexible, and customizable security solutions
- **Integrated Compliance**
  - assists in regulatory compliance by continuously collecting and reporting network data in real-time
- **User Behavior Analytics (UBA)**
  - The integration of new threat data in SIEM systems aids in detecting potential phishing efforts and identifying compromise points, aligning with the user behavior analytics approach.
- **Alerting**
  - correlation rules raise an alert when a pattern matches; keeping the number of alerts low enough to be acted on is the main tuning problem of any SIEM deployment
- **Incident Response**
  - Combining SIEM with SOAR (Security Orchestration, Automation, and Response) extends the usability of these tools. However, even this combination is reactive rather than proactive, indicating a need for solutions that fill these gaps, such as extended detection and response (XDR).

_source: Security Information and Event Management \[3.\], Security Information and Event Management \[5.\]_

## Benefits

- **Rapid Detection and Response**
  - shortens the time required to detect and identify threats
- **Forensic Analysis**
  - forensic investigation by providing detailed logs and historical data
- **Diverse Applications**
  - SIEM can be used for operations support, troubleshooting, and other activities revolving around data or historical logs

_source: Security Information and Event Management \[5.\]_

## Challenges in Implementing SIEM

- Requirement of integration with other solutions
- Extensive oversight and control needed from security experts
- Initial and ongoing costs
- Difficulty in differentiating between regular activities and incidents.

_source: Security Information and Event Management \[5.\]_

## Solution Comparison

The prices and feature sets below are those listed in the source article when
it was written; licensing models in this market change often. Use the table to
see which kinds of products exist and what they optimise for, and get current
figures from the vendor before making any comparison that matters.

| SIEM Solution                     | Best For                        | Key Features                                                               | Deployment Options          | Pricing                                                     |
| --------------------------------- | ------------------------------- | -------------------------------------------------------------------------- | --------------------------- | ----------------------------------------------------------- |
| Splunk Enterprise Security        | IT Observability                | Risk classification, threat intelligence, flexible deployment              | Various                     | Starting at $150/month for 1GB data/day                     |
| IBM Security QRadar SIEM          | Global Reach, Large Enterprises | AI and UBA integration, compliance resources, extensive integrations       | On-premises/Cloud           | Community: Free; Software: ~$320/month; SaaS: ~$2,340/month |
| Securonix Unified Defense SIEM    | Future-Looking Vision           | Cloud-native platform, integrated SOAR, long-term search capabilities      | Cloud, On-premises, Hybrid  | Contact for pricing; SaaS available                         |
| Exabeam Fusion                    | Log Storage and Searchability   | UEBA for insider threats, smart timelines, full indexing for log ingestion | SaaS cloud offering         | Contact for pricing; SaaS available                         |
| LogRhythm SIEM Platform           | On-Premises SIEM                | Advanced analytics, prebuilt playbooks, threat detection                   | On-premises                 | Starts under $30,000                                        |
| ManageEngine Log360               | Small Businesses                | Automated security scanning, compliance auditing, threat intelligence feed | Windows Server environments | Contact for pricing                                         |
| Datadog Security Monitoring       | Customization                   | Real-time security monitoring, log management, 600+ integrations           | Cloud-native                | 14-day free trial                                           |
| Logpoint SIEM                     | -                               | AI-driven anomaly detection, UEBA, integrated SOAR                         | Linux, AWS, SaaS            | -                                                           |
| SolarWinds Security Event Manager | Log Aggregation                 | Wide range of log management features                                      | -                           | -                                                           |

_source: Security Information and Event Management \[2.\]_

## References

1. <https://www.selecthub.com/siem/siem/>
2. <https://www.esecurityplanet.com/products/siem-tools/#:~:text=,Premises>
3. <https://securityintelligence.com/articles/soar-and-siem-in-2023-key-trends-and-new-changes/>
4. <https://www.manageengine.com/log-management/siem/siem-functions.html>
5. <https://www.itsasap.com/blog/pros-cons-siem>
