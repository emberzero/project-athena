# Wireless Penetration Testing Tools and Techniques

## 5.1 Introduction

This chapter covers the practical side of wireless penetration testing through two representative attacks: cracking a WPA2 passphrase from a captured handshake, and the Evil Twin. Both are worth understanding from the defensive side too, because what makes them work is exactly what a hardened network has to remove.

## 5.2 Tools

There are many tools when it comes to WiFi hacking, with the most common ones being the Aircrack-ng Suite, Kismet and Wireshark. In this curriculum, we will focus on those three.

### 5.2.1 Aircrack-ng Suite

The Aircrack-ng suite covers monitoring, attacking, testing and cracking WiFi networks. The work is split across separate tools: `airmon-ng` puts the adapter into monitor mode, `airodump-ng` captures frames and handshakes, `aireplay-ng` injects or replays frames (deauthentication, for example), and `aircrack-ng` performs the offline cracking. Monitor mode requires an adapter and driver that support it, which is the usual practical obstacle. In practice the suite is used for cracking WiFi passwords, for deauthentication attacks, and for testing how well a network's encryption holds up.

### 5.2.2 Kismet

Kismet is an open-source WiFi stumbler, sniffer and intrusion detection system. It passively collects wireless data from supported hardware, detects network SSIDs, including hidden ones, and can identify potential network intrusions. Because it only listens, it is mainly used for network discovery, wardriving and the information gathering stage of a penetration test.

### 5.2.3 Wireshark

Wireshark is a network protocol analyzer. It captures the traffic running on a network and lets the user browse each packet in as much detail as possible, with filters to narrow the view down to specific packets or protocols. It is used for diagnosing network problems, for software and protocol development, and in security work and teaching, where sniffing and analyzing packets shows what the traffic actually contains and where a network is weak.

## 5.3 Attacking Wireless Networks

With these tools in hand, we can move on to attacking WiFi networks. Stay ethical: only attack wireless networks that you own or have permission to test.

### 5.3.1 Password Cracking

The process of password cracking in the context of WiFi networks typically involves the following steps:

1. **Monitoring and Capturing Packets**: Using tools like Aircrack-ng or Kismet, monitor and capture the packets from the targeted WiFi network. This involves setting the adapter to monitor mode to receive all wireless traffic in range, and locking it to the target's channel.
1. **Targeting a Network**: Identify the network whose passphrase you want to recover, and note its BSSID and channel. The goal is to capture the four-way handshake between a legitimate client and the access point.
1. **Capturing the Handshake**: Wait for a client to connect, or send a deauthentication frame to an associated client so that it reconnects immediately and produces a handshake. The handshake does **not** contain the passphrase in any form, encrypted or otherwise. What it contains is a Message Integrity Code computed with a key derived from the passphrase and the SSID, which is enough to test a guess against.
1. **Cracking the Password**: Feed the capture to `aircrack-ng` or `hashcat` with a wordlist. For each candidate passphrase the tool derives the key, recomputes the MIC and compares it with the captured one. This is a guessing attack: it only succeeds if the real passphrase is in the wordlist or within reach of the rules applied to it, so a long random passphrase simply does not fall to it.
1. **Accessing the Network**: Once the passphrase is recovered, the network can be joined with it, and any traffic captured earlier from that network can also be decrypted.

#### See it in action

\[VIDEO AVAILABLE AFTER PRESENTATION\]

### 5.3.2 Evil Twin Attack

An Evil Twin attack involves setting up a rogue access point that appears to be a legitimate part of the targeted WiFi network:

```text
  1. Recon              2. Rogue AP           3. Deauth burst
  scan for SSID,        same SSID, often      spoofed deauth
  channel, clients      a stronger signal     frames evict clients
         |                      |                      |
         +----------------------+----------------------+
                                |
                                v
   4. The client re-associates, picking the strongest AP with
      the expected SSID: the attacker's.
                                |
                                v
   5. Attacker is now the gateway: captive portal harvesting the
      passphrase or credentials, DNS spoofing, TLS downgrade
      attempts, full traffic capture (MITM).
```

1. **Setting Up a Rogue Access Point**: Use a tool like Kismet or `airodump-ng` to identify the SSID, BSSID, channel and security protocol of the target network. Then bring up a rogue access point with the same SSID, for instance with `airbase-ng` from the Aircrack-ng suite. Note that a rogue AP cannot reproduce a WPA2 or WPA3 network's passphrase, so it cannot complete a normal handshake; evil twins are therefore usually run as an open network with a captive portal that asks the victim for the passphrase or for credentials.
1. **Deauthentication Attack**: Force users off the legitimate network using a deauthentication attack. This can be done using packet injection tools to disrupt the communication between the user and the legitimate access point.
1. **Redirecting Users to the Rogue AP**: Users disconnected from the legitimate access point will often automatically try to reconnect. Since your rogue AP has the same SSID, some devices may connect to it instead.
1. **Capturing Information**: Once a user is connected to the rogue AP, their internet traffic goes through your network, allowing you to capture sensitive information like login credentials.
1. **MitM Capabilities**: With the user connected to your rogue AP, you can intercept or alter their communications, run DNS spoofing, and attempt to downgrade or strip TLS. Note the limit: correctly configured HTTPS with HSTS, and a VPN, still hold against a network-level MITM, so the attack usually targets the user through a convincing portal rather than the cryptography.

**Defences:** Protected Management Frames block the deauthentication step. WPA3-Enterprise or WPA2-Enterprise with server certificate validation enforced on clients means a rogue AP cannot complete authentication. For users, the practical rules are not to enter a network passphrase into a web page and to treat an unexpected captive portal on a known network as a warning sign.

#### See it in action

\[VIDEO AVAILABLE AFTER PRESENTATION\]

## Sources

- <https://resources.infosecinstitute.com/topics/penetration-testing/red-teaming-main-tools-for-wireless-penetration-tests/>
- <https://www.aircrack-ng.org/doku.php?id=cracking_wpa>
- <https://thecybersecurityman.com/2018/08/11/creating-an-evil-twin-or-fake-access-point-using-aircrack-ng-and-dnsmasq-part-2-the-attack/>
