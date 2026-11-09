# WiFi Security Fundamentals

## 2.1 Introduction

A WiFi network transmits over the air, so anyone within radio range can receive its traffic without ever touching a physical port. This lecture gives a short overview of the resulting risks and the measures used against them.

## 2.2 Security Risks

The risks are the usual ones for a shared medium. People who are not authorized to use the network gain access to it. Data transmitted over the network is retrieved by someone else, which is particularly damaging when it carries sensitive information. Attacks disrupt the normal functioning of the network, steal data, or damage network infrastructure. And malicious software is introduced into the network.

**Note:** This lecture is only required to provide a basic understanding and brief overview of WiFi security fundamentals. Detailed security risks and attack vectors are covered in later lectures.

## 2.3 Security Protocols

Securing a WiFi network starts with the choice of security protocol. These protocols handle authentication (controlling access to the network) and encryption (protecting the integrity and confidentiality of the data).

- **WEP (Wired Equivalent Privacy):** Broken. The key can be recovered from captured traffic in minutes. Never use it.
- **WPA (WiFi Protected Access):** Deprecated. Its TKIP encryption is built on the same RC4 cipher as WEP and has known attacks.
- **WPA2 (WiFi Protected Access 2):** Still widely deployed and acceptable when configured with AES-CCMP and a strong passphrase, but a captured handshake allows an offline attack on that passphrase.
- **WPA3:** The current standard and the recommended choice. Its SAE handshake removes the offline passphrase attack and it mandates protection of management frames.

Where hardware allows it, use WPA3. Where it does not, use WPA2 with AES-CCMP
and disable the WPA/TKIP and WEP fallbacks, since a mixed-mode network can be
downgraded to its weakest option.

## 2.4 Further Considerations

- Use a complex password mixing letters, numbers and special characters. Avoid common words and anything guessable from public information about you.
- Change the default SSID to something unique but not personally identifiable, and avoid names that make the network a more attractive target.
- Disable WPS. Its PIN feature exists to make connecting easier and is open to brute force.
- Activate the router's built-in firewall, and consider additional firewall software where the router's own is limited.
- Update the router's firmware regularly to patch known vulnerabilities. Enable auto-updates if the router supports them.
- MAC address filtering keeps casual devices off the network, but it is not a security control. MAC addresses are sent in the clear in every frame and are trivial to copy, so an attacker simply adopts an address that is already allowed.
- Adjust the transmit power to limit coverage outside your premises, and think about where in the building the router sits.
- Create a separate guest network if the router supports it, with its own password and no access to the main network.
- Check the list of connected devices regularly and investigate unknown devices or unusual activity.
- Teach yourself and your colleagues what the risks are. Nobody can react to a threat they have never heard of.

## 2.5 Conclusion

The single most effective measure is choosing a current security protocol with a strong passphrase; the remaining items reduce exposure but do not substitute for it. The following lectures cover the authentication and encryption mechanisms behind these protocols, the attacks against them, and the defences in detail.

## Sources

- [https://en.wikipedia.org/wiki/Wireless_security](https://en.wikipedia.org/wiki/Wireless_security)
