# Best Practices for Securing Wireless Networks

## 6.1 Introduction

This final chapter turns from offence to defence. Each measure below exists because of a specific attack from the previous chapters, and no single one is sufficient on its own: a wireless network is defended in layers, so that defeating one still leaves an attacker facing the next.

```text
  +------------------------------------------------------+
  | Policy and people  acceptable use, training, IR plan |
  +------------------------------------------------------+
  | Monitoring         WIDS, rogue-AP detection, audits  |
  +------------------------------------------------------+
  | Segmentation       guest VLAN, client isolation      |
  +------------------------------------------------------+
  | Authentication     WPA2/WPA3-Enterprise, RADIUS, MFA |
  +------------------------------------------------------+
  | Link encryption    AES-CCMP or GCMP, PMF enabled     |
  +------------------------------------------------------+
  | Device hygiene     firmware patching, WPS disabled   |
  +------------------------------------------------------+

   An attacker who defeats one layer still faces the others.
```

## 6.2 Overview of Wireless Network Security

### 6.2.1 Recap of Wireless Threats and Vulnerabilities

Wireless networks are more exposed than wired ones because the medium is broadcast, which makes unauthorized access and eavesdropping possible from outside the building. The vulnerabilities that recur are weak encryption such as WEP, unsecured access points, and inadequate authentication. A breach leads to data theft, privacy violations and a loss of network integrity.

### 6.2.2 Importance of Implementing Security Measures

Securing a wireless network protects sensitive information and keeps data intact. It also keeps the network available, because the measures against disruptions such as DoS attacks are what make the service reliable. There are legal implications and compliance requirements for network security, and in a business that handles customer data, strong security is what customer trust rests on. Since the threats keep changing, the approach has to be proactive rather than a configuration done once.

## 6.3 Securing Against WEP and WPA Vulnerabilities

### 6.3.1 Weaknesses of WEP and Older WPA Protocols

WEP (Wired Equivalent Privacy) has fundamental flaws: it uses static keys and a weak encryption algorithm, which leaves it open to a range of practical attacks. The initial version of WPA (WiFi Protected Access) improved on WEP with the Temporal Key Integrity Protocol (TKIP), but still had vulnerabilities of its own.

### 6.3.2 Upgrading to WPA3

WPA3 is the current WiFi security protocol. SAE (Simultaneous Authentication of Equals) is not an encryption algorithm but a key-exchange and authentication method: it replaces WPA2-PSK's four-way handshake with a password-authenticated exchange that cannot be attacked offline from a capture, and it provides forward secrecy. WPA3 also mandates Protected Management Frames, which blocks forged deauthentication.

Because SAE requires a live exchange with the network for every password guess, guessing becomes rate-limited and detectable instead of running offline at GPU speed. A strong passphrase is still required, since SAE slows guessing rather than making a weak password safe.

### 6.3.3 Implementing Strong Encryption

Moving from an older protocol to WPA3 depends on hardware and software support, so the first step is establishing which access points and clients can do it at all. Configure the WPA3 settings on the network according to current best practice, so that the strongest available option is the one actually in use.

## 6.4 Defending Against Man-in-the-Middle and Packet Sniffing Attacks

### 6.4.1 Best Practices for Securing Network Traffic

HTTPS and other secure communication protocols encrypt data in transit, so intercepted traffic cannot be deciphered. A Virtual Private Network (VPN) creates a secure tunnel for data transmission and is worth using especially on public or untrusted networks.

### 6.4.2 Securing Data Transmission

Strong encryption is what protects data from a packet sniffer, so sensitive information should never travel unprotected. Network hardware and software, firmware included, needs updating regularly, because these attacks commonly exploit known vulnerabilities for which a fix already exists.

## 6.5 Protecting Against Deauthentication and Other Network Intrusions

### 6.5.1 Strategies to Detect and Prevent Attacks

Continuous monitoring with tools that detect unusual traffic patterns or unauthorized devices is what makes deauthentication attempts and intrusions visible. An intrusion detection system (IDS) takes the next step and alerts automatically on a potential security breach, deauthentication attacks included.

### 6.5.2 Implementing Advanced Intrusion Detection Systems

Which IDS solution fits depends on the size and complexity of the network. Whichever one is chosen has to be configured properly and kept updated, or it will not recognise newer intrusion tactics.

## 6.6 Strengthening Network Authentication Mechanisms

### 6.6.1 Implementing Robust Password Policies

What defeats an offline attack on a captured handshake is entropy, and length contributes far more of it than character-class rules do. A long random passphrase or a several-word random phrase beats a short one padded with substituted symbols, which is exactly the pattern cracking rules expand first.

Current guidance (for example NIST SP 800-63B) advises against forced periodic changes, because they push users towards predictable variations of an old password. Change the passphrase when someone with access leaves or when a compromise is suspected. For a shared WPA2-PSK key, note that every departure is such an event, which is one of the reasons enterprise networks use per-user credentials instead.

### 6.6.2 Deploying Multi-Factor Authentication

Multi-factor authentication (MFA) adds a layer by requiring two or more verification factors before a user is granted network access. The usual factors are text message codes, authentication apps and biometrics, each of which can be integrated into wireless network authentication.

### 6.6.3 Utilizing RADIUS for Enterprise-Level Security

RADIUS (Remote Authentication Dial-In User Service) is worth deploying in larger networks because it manages authentication, authorization and accounting centrally. Implementing it means running RADIUS servers and integrating them with the existing network infrastructure, which improves both security and management efficiency.

## 6.7 Regular Network Monitoring and Audits

### 6.7.1 Implementing Continuous Monitoring Solutions

Network monitoring tools actively scan for anomalies, unauthorized access attempts and unusual traffic patterns. Real-time alerts are what turn that into something usable, by notifying the network administrators of a potential security incident as it occurs.

### 6.7.2 Conducting Periodic Security Audits

Regular security audits establish whether the current measures are effective and where vulnerabilities remain. An audit covers the access controls, the encryption standards, the password policies, and the efficacy of the intrusion detection systems.

## 6.8 Ensuring Regular Updates and Patch Management

### 6.8.1 Keeping Network Devices Up to Date

Routers, access points and other network devices need their firmware updated regularly, because firmware updates are where their security vulnerabilities get addressed. The same applies to all network-related software, security tools and management software included.

### 6.8.2 Automating Updates for Consistency

Automated update tools apply security patches in time without depending on anyone remembering to do it. Either way there needs to be a schedule for regular checks and updates, and updates should be tested for stability before they are deployed everywhere.

## 6.9 Developing Comprehensive Security Policies

### 6.9.1 Crafting and Enforcing Network Security Policies

A network security policy is written for the specific needs and context of the organization, and covers acceptable use, access control, password management and the response protocol for a security incident. It has to be enforced consistently across the organization, with a defined way of handling violations, and reviewed and updated regularly as new threats appear.

### 6.9.2 Establishing Procedures for Incident Response

An incident response plan states clearly, and in advance, the steps to be taken when there is a security breach or an attack. Staff need training to recognize security threats and respond appropriately, and that training is what maintains a culture of security awareness in the organization.

## 6.10 Conclusion

This chapter covered the defensive counterpart of the previous ones: upgrading to a modern protocol such as WPA3, encrypting traffic in transit, strengthening authentication with RADIUS and MFA, monitoring the network and auditing it periodically, patching firmware and software, and writing a security policy that is enforced and backed by an incident response plan. Each measure answers a different attack, which is why they are deployed together rather than chosen between.

## Sources

- <https://en.wikipedia.org/wiki/Wireless_security>
- <https://networklessons.com/cisco/ccna-200-301/wireless-authentication-methods>
- <https://www.researchgate.net/publication/266005431_Vulnerabilities_of_Wireless_Security_protocols_WEP_and_WPA2>
