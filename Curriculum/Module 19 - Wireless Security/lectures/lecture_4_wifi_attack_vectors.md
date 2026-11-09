# WiFi Attack Vectors

## 4.1 Introduction

An attack vector is the method or pathway an attacker uses to gain unauthorized access to a network or to compromise its data. In wireless networks these vectors exploit flaws in hardware and protocols as well as procedural and human weaknesses.

This chapter covers the common WiFi attack vectors, from passive eavesdropping to man-in-the-middle attacks, how each one works, and how to detect or prevent it.

## 4.2 Active vs Passive Attacks

Attacks on WiFi networks fall into two categories. They differ in how they are carried out and in how far they interact with the target network:

### 4.2.1 Passive Attacks

- Passive attacks involve monitoring or 'eavesdropping' on a network. The attacker intercepts data transmitted over the network without altering the data or affecting the network's operation. The goal is usually to gather information stealthily.
- They are harder to detect because they don't involve any alteration of the network's data or behavior. The network operates normally, unaware of the ongoing surveillance.
- Examples include sniffing to capture unencrypted data packets, listening for network traffic to identify network resources and configurations, and analyzing traffic patterns.
- Measures such as strong encryption (e.g., WPA3 for WiFi), VPNs, and secure protocols help mitigate the risk of passive attacks by ensuring that intercepted data cannot be easily understood.

### 4.2.2 Active Attacks

- Active attacks involve some form of alteration or intervention in the network's operation. The attacker injects, alters, or disrupts data to compromise the network. These attacks are often more aggressive and aim to directly damage, exploit, or disable the network.
- Active attacks are generally easier to detect compared to passive attacks because they involve noticeable changes in network performance or behavior.
- Examples include Man-in-the-Middle attacks, Denial of Service (DoS) attacks, session hijacking, creating rogue access points, and injecting malicious data into the network.
- Prevention strategies involve regular network monitoring, intrusion detection systems, strong authentication protocols, and network security policies to quickly identify and respond to active threats.

## 4.3 Attack Vectors

We will now have a look at the 7 most common WiFi attack vectors, explain how they work, give examples for them and suggest ways of detecting or preventing them.

### 4.3.1 Eavesdropping/Sniffing

- **Type**: Passive Attack
- **How it Works**: The attacker captures wireless data as it is transmitted over a network using a sniffer tool. This can include passwords, emails, and other sensitive information if not encrypted.
- **Example**: Using a tool like Wireshark to monitor unsecured WiFi network traffic at a coffee shop.
- **Detection and Prevention**: Encryption (like WPA2 or WPA3) makes sniffed data unreadable, but with one important caveat: on a WPA2-PSK network, anyone who knows the passphrase and has captured a client's four-way handshake can derive that client's keys and decrypt its traffic. A shared passphrase therefore protects the network from outsiders, not its users from each other. WPA3 and OWE derive per-client keys and remove this. Purely passive sniffing emits nothing and so cannot be detected over the air; defence is to assume it is happening and encrypt accordingly.

### 4.3.2 Man-in-the-Middle (MITM) Attacks

- **Type**: Active Attack
- **How it Works**: The attacker intercepts and potentially alters the communication between two parties without their knowledge. This can be done by infiltrating an unsecured WiFi network or using tools to create a false access point.
- **Example**: An attacker sets up an unsecured WiFi hotspot and intercepts data between connected users and the internet.
- **Detection and Prevention**: HTTPS usage, VPNs, and strong network authentication can help prevent MITM attacks. Users also have to pay attention to which network they are on.

### 4.3.3 Denial of Service (DoS)

- **Type**: Active Attack
- **How it Works**: Against a wireless network the cheapest DoS does not need traffic volume at all. Because 802.11 management frames are unauthenticated by default, an attacker can forge deauthentication or disassociation frames that appear to come from the AP and repeatedly throw clients off the network. Jamming the channel with radio noise and flooding the AP with bogus association requests are further variants.
- **Example**: A deauthentication flood sent with `aireplay-ng` against a target BSSID. Generic flooding tools aimed at an internet service are a different class of attack and are not what makes wireless specifically fragile.
- **Detection and Prevention**: Enable Protected Management Frames (802.11w), which are mandatory under WPA3 and optional under WPA2; they authenticate management frames and so block the forged-deauth attack outright. A wireless IDS can flag deauth floods and channel interference. Jamming at the radio layer cannot be prevented by any protocol, only detected and located.

### 4.3.4 Evil Twin Attacks

- **Type**: Active Attack
- **How it Works**: The attacker sets up a malicious WiFi access point that mimics a legitimate one, tricking users into connecting and transmitting their data through the rogue network.
- **Example**: Creating a WiFi access point with a name similar to a legitimate cafe network to capture customer data.
- **Detection and Prevention**: Users should verify network authenticity before connecting. Networks can use AP (Access Point) fingerprinting to detect rogue APs.

### 4.3.5 Packet Injection

- **Type**: Active Attack
- **How it Works**: The attacker injects arbitrary packets into a network. This can be used to disrupt or manipulate normal network operations.
- **Example**: Injecting packets to disrupt a client's connection or to exploit vulnerabilities in the network.
- **Detection and Prevention**: Encryption, strong network protocols, and intrusion detection systems can help identify and prevent packet injection.

### 4.3.6 WiFi Phishing

- **Type**: Active Attack
- **How it Works**: Similar to phishing on the internet, WiFi phishing involves creating a fraudulent network or portal to deceive users into entering sensitive information.
- **Example**: Setting up a fake WiFi login page that looks legitimate to capture user credentials.
- **Detection and Prevention**: User education is the main defence. SSL/TLS for websites can help. Networks should use security measures like WPA3 for authentication.

### 4.3.7 Cracking WiFi Passwords

- **Type**: Mostly passive. Capturing the handshake and cracking it are both passive and leave no trace; only the optional deauthentication used to force a client to reconnect is active and detectable.
- **How it Works**: The attacker captures a WPA2 four-way handshake and then tests passphrase guesses against it offline, by dictionary or brute force. A separate route is the WPS PIN: its eight-digit PIN is verified in two independent halves, which reduces the search space enough to be practical, so WPS is attacked directly rather than the passphrase.
- **Example**: Capturing a handshake with `airodump-ng` and cracking it with `aircrack-ng` or `hashcat`.
- **Detection and Prevention**: A long, random passphrase, since the attack scales with guessing speed and nothing else; WPS disabled; and WPA3, whose SAE handshake makes each guess require a fresh exchange with the network, removing the offline attack. Monitoring for failed logins does not help here, because no login attempt reaches the network.

## 4.4 Conclusion

Most of the vectors above are active attacks, which interact with the network and so leave something a defender can see. That cuts both ways: defenders get a monitoring strategy, while penetration testers must work carefully, because a deauthentication flood or a rogue AP in a production environment causes real disruption. The exceptions matter most, though. Passive sniffing and offline passphrase cracking produce no detectable event at all, so against those the only defence is a protocol and a passphrase that hold up even when the attacker has a full capture of the traffic.

## Sources

- <https://www.webtitan.com/blog/most-common-wireless-network-attacks/>
- <https://www.examcollection.com/certification-training/security-plus-wireless-attacks-and-their-types.html>
- <https://www.giac.org/paper/gsec/4116/wireless-ids-exposures-attack-vectors-detection/106559>
