# WiFi Authentication and Encryption Mechanisms

## 3.1 Introduction

WiFi security rests on two separate mechanisms. Authentication decides which devices are allowed to join the network, and encryption keeps the traffic unreadable to anyone listening on the same channel. This lecture works through both, in the order they were introduced, so that the weaknesses of each generation explain the design of the next.

## 3.2 Authentication Fundamentals

Authentication is the first check a WiFi network applies. It establishes the identity of a device that wants to connect and decides whether that device is allowed onto the network.

### 3.2.1 OSA: Open System Authentication

Open System Authentication (OSA) is one of the simplest forms of authentication mechanisms used in WiFi networks. Despite its name, it offers minimal actual authentication and is primarily a legacy method introduced during the early days of wireless networking.

- **Basic Concept:** Open System Authentication is a process where any WiFi device can connect to an Access Point without providing any credentials. In OSA, the authentication process doesn't verify the identity of the device; rather, it simply acknowledges the request to join the network.

#### Process Flow

1. **Authentication Request:** The client device sends an authentication request frame to the AP.
1. **Authentication Response:** The AP replies with an authentication response frame, indicating acceptance.

#### Functionality

- **Minimal Security:** OSA does not provide any form of secure authentication. It does not encrypt the data or protect the network from unauthorized access. The AP accepts all devices that request access, making it akin to a no password scenario.
- **Ease of Access:** The primary advantage of OSA is its simplicity and ease of access. It allows for quick and hassle-free connection to the network, suitable for environments where security is not a concern, such as public WiFi hotspots.
- **Legacy Compatibility:** OSA remains in use primarily for compatibility with older devices that may not support more advanced authentication methods. It ensures that these devices can still connect to modern networks.

#### Security Implications

- **Vulnerability to Attacks:** Given that OSA does not provide any form of data encryption or secure authentication, networks using this method are highly vulnerable to eavesdropping and various types of attacks, including man-in-the-middle attacks.
- **Usage Consideration:** In current times, the use of OSA is generally discouraged unless absolutely necessary for compatibility reasons. It is recommended to use it in conjunction with other security measures like VPNs, especially in public or semi-public settings.

### 3.2.2 SKA: Shared Key Authentication

Shared Key Authentication (SKA) is a more secure alternative to OSA in WiFi networks, yet it still presents significant security limitations. It was introduced in the earlier WiFi protocols to provide a basic level of security.

- **Basic Concept:** Shared Key Authentication is a process that requires a WiFi device to prove that it possesses a secret key that is also known to the Access Point. This is typically the WEP key in networks where SKA is implemented.

#### Process Flow

1. **Authentication Request:** The client sends an authentication request to the AP.
1. **Challenge Text:** The AP responds with a clear-text challenge frame.
1. **Response:** The client encrypts the challenge text using the shared WEP key and sends it back to the AP.
1. **Verification:** The AP decrypts the response. If it matches the original challenge text, the AP sends a positive authentication response, completing the authentication process.

#### Functionality

- **Use of WEP Key:** SKA relies on the WEP key for authentication. Both the client and the AP must have the same WEP key configured for the authentication to be successful.
- **Encryption of Challenge Text:** The challenge-response mechanism involves encryption, which, in theory, should provide better security than OSA. However, the weaknesses in the WEP encryption algorithm significantly undermine this security.
- **Four Frames, Not the WPA2 Handshake:** The exchange above consists of four frames and is sometimes called a four-way handshake, but it is unrelated to the WPA2 four-way handshake described later. It is also not mutual authentication: only the client proves knowledge of the key, and the AP is never authenticated to the client.

#### Security Implications

- **Weaker Than Open System Authentication:** Counterintuitively, enabling SKA makes a WEP network easier to attack than leaving it on OSA. The challenge is sent in the clear and the response is that same challenge encrypted, so capturing one exchange hands the attacker a known plaintext/ciphertext pair and the corresponding RC4 keystream, which can be replayed to authenticate without ever recovering the key.
- **Vulnerabilities:** The use of WEP in SKA is a major security flaw. WEP has well-known vulnerabilities that make it susceptible to various attacks, including key recovery attacks. Therefore, SKA is not considered secure by modern standards.
- **Limited Use in Modern Networks:** Due to its vulnerabilities, SKA is rarely used in modern WiFi networks. It has been largely replaced by more secure methods in WPA and WPA2, which use stronger encryption and authentication mechanisms.

**Note:** This authentication flow requires the use of WEP encryption, which is covered later in this lecture.

### 3.2.3 PSK: Pre-Shared Key Authentication

Pre-Shared Key (PSK) Authentication represents a significant step forward in WiFi security compared to earlier methods like Open System and Shared Key Authentication. Predominantly used in home and small business networks, PSK is a fundamental component of WPA and WPA2 protocols.

- **Basic Concept:** PSK authentication involves the use of a shared secret key, known to both the WiFi device and the Access Point. This key is used to authenticate the device to the network and to encrypt data communications.

#### Process Flow

1. **Key Establishment:** Before authentication, a pre-shared key is established and configured on both the client device and the AP.
1. **Authentication Request:** When a client attempts to connect to the network, it sends an authentication request to the AP.
1. **Four-Way Handshake:** A four-way handshake process is initiated where the client and the AP exchange a series of messages to confirm that both have the correct PSK and to establish encryption keys for securing data transmission.

The passphrase itself is never transmitted. Both sides derive a Pairwise
Master Key (PMK) from the passphrase and the SSID, and the handshake proves
that each side holds it while deriving the per-session Pairwise Transient
Key (PTK) used for encryption:

```text
  Supplicant (client)                        Authenticator (AP)
  PSK + SSID --> PMK                         PSK + SSID --> PMK
       |                                               |
       |      M1: ANonce (unencrypted)                 |
       |<----------------------------------------------|
   derives PTK from                                    |
   PMK, ANonce, SNonce, both MAC addresses             |
       |  M2: SNonce + MIC                             |
       |---------------------------------------------->|
       |          derives the same PTK, checks the MIC |
       |      M3: GTK (encrypted) + MIC                |
       |<----------------------------------------------|
       |  M4: acknowledgement + MIC                    |
       |---------------------------------------------->|
       |      PTK installed, data frames encrypted     |

   M1 + M2 are enough for an offline dictionary attack: the MIC
   in M2 can be tested against guessed passphrases, so no further
   contact with the network is needed.
```

#### Functionality

- **Encryption and Key Management:** PSK works in tandem with encryption protocols like TKIP in WPA and AES in WPA2. The PSK is used to derive temporary encryption keys used in the communication session.
- **Ease of Setup:** PSK is relatively simple to set up, making it a popular choice for personal and small business networks. The key can be a passphrase, making it easier for users to remember and configure.
- **Scalability and Security Considerations:** While PSK provides a significant security upgrade over WEP-based methods, it has limitations in scalability and security management, particularly in larger networks. The same key is shared among all users, which can be a security risk if the key is compromised.

#### Security Implications

- **Vulnerability to Offline Attacks:** An attacker who captures the first two handshake messages can test passphrase guesses offline, at whatever speed their hardware allows, with no further contact with the network and no failed-login counter to stop them. Nor do they have to wait for a client to connect: a deauthentication frame forces a reconnect and so produces a fresh handshake on demand. This makes passphrase strength the only real defence under WPA2-PSK, and it is the attack WPA3's SAE handshake was designed to eliminate.
- **Best Practices for Using PSK:** Regularly updating the PSK and maintaining its confidentiality are critical for maintaining network security.

**Note:** This authentication flow requires the use of encryption protocols, such as WPA or AES, which are covered later in this lecture.

### 3.2.4 EAP: Extensible Authentication Protocol

Extensible Authentication Protocol is a flexible authentication framework widely used in larger and more secure WiFi environments, particularly within the WPA2-Enterprise and WPA3-Enterprise frameworks.

- **Basic Concept:** EAP provides a method for two parties to perform authentication over a network. It is not tied to any specific authentication method, allowing a variety of authentication techniques to be used, such as token cards, Kerberos, One-Time Passwords, certificates, and Public Key Infrastructure.

#### Process Flow

- **Initiation:** An EAP conversation starts when a client device attempts to connect to a network and the Access Point, acting as an authenticator, requests the identity of the client.
- **EAP Exchange:** The client responds with an EAP response packet containing its identity. The AP then forwards this response to an authentication server.
- **Authentication Process:** The authentication server determines the specific EAP method to use and exchanges EAP messages with the client to authenticate.
- **Completion:** Upon successful authentication, the authentication server sends a success message to the AP, which then allows the client to access the network.

```text
  Supplicant        Authenticator (AP)      Server (RADIUS)
      |                     |                      |
      | EAPOL-Start         |                      |
      |-------------------->|                      |
      | EAP identity req.   |                      |
      |<--------------------|                      |
      | EAP identity resp.  | Access-Request       |
      |-------------------->|--------------------->|
      |  EAP method exchange (EAP-TLS, PEAP, ...)  |
      |<------------------------------------------>|
      |                     | Access-Accept + MSK  |
      |                     |<---------------------|
      | EAP-Success         |                      |
      |<--------------------|                      |
      |                     |                      |

   The AP only relays EAP messages; it never sees the user's
   password. The MSK from the server seeds the 4-way handshake.
```

Because the AP is only a relay, the client must verify the server's
certificate during the EAP method exchange. If certificate validation is
switched off on the client, a rogue AP with its own RADIUS server can accept
the connection and capture the credentials, which is the standard attack
against misconfigured WPA2-Enterprise networks.

#### Functionality

- **Flexibility and Versatility:** EAP is designed to be flexible and can support multiple authentication methods, making it adaptable to various security requirements and scenarios.
- **Interaction with RADIUS Server:** In most implementations the authentication server *is* a RADIUS server, and the AP acts purely as a relay (the "authenticator") between the client and that server. Keeping the credential database off the AP means a compromised AP does not expose it.
- **Use in Enterprise Environments:** Because EAP supports advanced authentication methods, it suits enterprise environments that need strong security and individual user credentials.

#### Security Implications

- **Enhanced Security:** EAP provides a higher level of security compared to PSK, as it allows for individualized authentication. This means each user can have unique credentials, significantly reducing the risk of network compromise if one user's credentials are breached.
- **Best Practices for EAP Usage:** Regularly updating and managing user credentials and certificates, and ensuring the secure configuration of the RADIUS server are essential for maintaining the integrity of an EAP-based authentication system.
- **Contrast with PSK:** Unlike PSK, which uses a single shared key for all users, EAP provides a framework for individualized and diverse authentication methods. This makes EAP more suitable for larger networks with higher security requirements.

### 3.2.5 Enterprise Authentication

Enterprise WiFi authentication with RADIUS and TACACS+ is designed for large-scale, high-security environments. These protocols manage authentication, authorization and accounting in enterprise WiFi networks.

- **Basic Concept:** These are server-based networking protocols used for centralized Authentication, Authorization, and Accounting (AAA) of users. RADIUS is more commonly used in WiFi networks, while TACACS+ is often employed in controlling access to network devices.

#### Process Flow

1. **Authentication Request:** When a user attempts to connect to a WiFi network, the Access Point acts as a client to the RADIUS/TACACS+ server and forwards the user's credentials to the server.
1. **Server Processing:** The RADIUS/TACACS+ server verifies the credentials against its database. It may use various authentication methods, such as EAP, LDAP, or Kerberos.
1. **Access Approval or Denial:** Based on the verification, the server responds to the AP, either granting or denying access to the user.
1. **Authorization and Accounting:** Once authenticated, the user's activities can be tracked for billing, auditing, or reporting purposes.

#### Functionality

- **Centralized User Management:** Both RADIUS and TACACS+ allow for centralized management of user credentials, making it easier to handle a large number of users and different access levels.
- **Enhanced Security:** These protocols offer enhanced security features, including the ability to encrypt entire authentication packets or only passwords.
- **Flexibility and Scalability:** They integrate with various user databases and scale to a large number of authentication requests, which is what enterprise settings require.

#### Security Implications

- **Robust Against Attacks:** The centralized nature and the ability to use advanced encryption and authentication methods make RADIUS and TACACS+ robust against common network attacks.
- **Best Practices for Implementation:** Regular updates, secure configuration, and monitoring of the RADIUS/TACACS+ servers are vital to maintain the security and efficiency of the network.
- **Contrast with PSK and EAP:** Unlike PSK, which uses a shared key for all users, or EAP, which is a framework for individual user authentication, RADIUS and TACACS+ cover authentication, authorization and accounting together, which gives the level of control and security enterprise environments need.

## 3.3 Basic WiFi Encryption

Once a device is authenticated and granted access, encryption takes over. It makes the data sent over the WiFi network unreadable to anyone who intercepts it.

### 3.3.1 WEP: Wired Equivalent Privacy

WEP, which stands for Wired Equivalent Privacy, was one of the first security protocols introduced for wireless networks. It was designed to provide a level of confidentiality comparable to that of a traditional wired network, but it has been found to have several significant vulnerabilities.

#### Functionality

- **Encryption Mechanism:** WEP uses the RC4 stream cipher for encryption. The basic idea is to combine a secret key with an Initialization Vector to encrypt data.
- **Static Key Usage:** In WEP, the same key, shared between all devices on the network, is used for both encryption and decryption. This key is typically entered manually by the network administrator and sometimes by the end-users.
- **IV and Key Concatenation:** An Initialization Vector is combined with the WEP key to encrypt data. The IV is a 24-bit value, which adds some randomness to the encryption process.
- **Integrity Check:** WEP uses a checksum method called CRC-32 (Cyclic Redundancy Check) to ensure data integrity. It checks whether the data was altered during transmission.

#### Major Vulnerabilities

- **Weak IV Implementation:** The short length of the IV in WEP (24-bit) leads to frequent repetition of the same IV, which makes it vulnerable to attack. Attackers can analyze these repetitions to crack the WEP key.
- **Key Management and Security:** WEP lacks a mechanism for automated key management. The static key must be manually changed and distributed, which is not practical and often leads to weak security practices.
- **Flawed Integrity Check:** The CRC-32 integrity check used by WEP is not cryptographically strong. It is susceptible to certain attacks that can allow data to be modified undetected.
- **Statistical Key Recovery:** WEP is not broken by brute force. Because the IV is sent in the clear and repeats, an attacker can collect enough frames to recover the key by statistical analysis of the RC4 keystream. Tools implementing these attacks need only a few minutes and a few tens of thousands of frames, and traffic can be generated artificially by replaying captured packets, so the key length makes no practical difference.

### 3.3.2 WPA: WiFi Protected Access

WiFi Protected Access (WPA) was developed as a response to the significant security weaknesses found in WEP. It was designed to give wireless networks better security and has since been succeeded by WPA2 and WPA3.

#### Functionality

- **Improved Encryption:** WPA introduced TKIP (Temporal Key Integrity Protocol) for encryption. TKIP was designed to be a more secure alternative to WEP's encryption mechanism, while still being able to operate on older hardware not designed for WPA.
- **Dynamic Key Encryption:** Unlike WEP's static key, TKIP generates a new key for each packet, reducing the risk of key compromise. It uses a key-mixing function that combines the secret root key with an initialization vector before each packet is encrypted.
- **Message Integrity Check:** WPA implemented an enhanced integrity check called Michael to replace WEP's flawed CRC-32 checksum. This was designed to prevent attackers from altering and resubmitting data packets.
- **Pre-shared Key (PSK) and Enterprise Modes:** WPA can be used in two modes:
  - **WPA-PSK (Personal):** This mode is designed for home and small office networks and uses a pre-shared key.
  - **WPA-Enterprise:** Intended for enterprise networks, it uses a RADIUS server for authentication and supports more advanced authentication methods through EAP.

#### Security Considerations

- **Improved Encryption Algorithm:** TKIP included features like per-packet key mixing, a re-keying mechanism, and an IV sequencing discipline to thwart known attacks on WEP.
- **Robust Authentication:** WPA-Enterprise provided a more robust authentication mechanism compared to WEP, allowing for individual user authentication in large-scale environments.
- **TKIP Limitations:** While TKIP was a significant improvement over WEP, it was still built on the framework of RC4, which eventually became vulnerable to advanced attacks. As a result, TKIP is no longer considered secure.

#### TKIP: Temporal Key Integrity Protocol

- **Dynamic Key Encryption:** TKIP employs a different encryption key for each data packet, addressing one of the major vulnerabilities of WEP, which used static keys. This dynamic key generation is achieved through a mixing function that combines the base key with an initialization vector.
- **Key Mixing Function:** The key mixing function takes the base key and the IV, along with the transmitter's MAC address, to produce a unique key for each packet. This approach significantly improves security over WEP's static key method.
- **IV Sequence Counter:** TKIP implements a sequence counter for IVs to prevent replay attacks. This counter ensures that old IVs are not reused, thereby thwarting an attack vector that was viable under WEP.
- **Message Integrity Check (MIC):** Known as "Michael", this feature provides a stronger integrity check compared to WEP's CRC-32. It helps in protecting against data tampering and forgery.
- **Re-Keying Mechanism:** TKIP includes a built-in re-keying mechanism that changes the encryption key periodically during the session, which shortens the window in which an attacker can compromise a key.

### 3.3.3 WPA2: WiFi Protected Access Version 2

WPA2 is an enhanced version of WPA and has been the standard for WiFi security since its introduction. It was developed to address the vulnerabilities of WPA and became the recommended choice for securing WiFi networks until the advent of WPA3.

#### Key Features

- **Advanced Encryption Standard (AES):** WPA2 introduced the use of AES for encryption, a significant upgrade over TKIP used in WPA. AES is a stronger encryption method and gives better protection against cryptographic attacks.
- **CCMP (Counter Cipher Mode with Block Chaining Message Authentication Code Protocol):** Replacing TKIP's Michael for integrity and confidentiality, CCMP offers enhanced protection against data tampering and forgery.

#### Security Considerations

- **Stronger Encryption:** The shift to AES encryption in WPA2 marked a significant improvement in terms of security, making it resilient to many attacks that could compromise WPA.
- **Enhanced Data Protection:** The introduction of CCMP provided better data integrity checks, ensuring that the data transmitted over the network is better protected from tampering and forgery.
- **Vulnerability to KRACK Attack:** The KRACK (Key Reinstallation Attack) family of flaws, disclosed in 2017, abused the retransmission of handshake messages to force a client to reinstall an already-used key and so reset its packet counter, allowing replay and decryption of traffic. These were implementation-level flaws in the handshake state machine and were fixed by patches, not by a change of protocol, which is why keeping client and AP firmware current matters as much as the choice of protocol.

#### AES: Advanced Encryption Standard

- **Symmetric Key Encryption:** AES is a symmetric key algorithm, meaning the same key is used for both encrypting and decrypting data.
- **Block Cipher:** It encrypts data in fixed-size blocks (128 bits). The key sizes used can be 128, 192, or 256 bits, with AES-256 being the strongest.
- **Security and Efficiency:** AES is known for its high level of security and efficiency in various hardware and software environments. It is widely considered immune to all known practical cryptographic attacks, provided a strong key is used.

### 3.3.4 WPA3: WiFi Protected Access Version 3

WPA3 is the latest generation of WiFi security, introduced to address the vulnerabilities in WPA2 and to offer enhanced security features.

#### Key Features

- **Improved Encryption:** WPA3-Personal uses AES-CCMP with a 128-bit key. WPA3-Enterprise additionally offers an optional 192-bit security mode, which mandates a stronger cipher suite (AES-GCMP-256) and matching EAP configuration; it is not enabled by default on every enterprise deployment.
- **Enhanced Protection against Brute-Force Attacks:** WPA3 includes features like Simultaneous Authentication of Equals (SAE), which replaces the Pre-Shared Key (PSK) in WPA2-Personal. SAE provides a more secure initial key exchange and protects against offline dictionary attacks.
- **Forward Secrecy:** WPA3 offers forward secrecy, meaning that if a session key is compromised, it does not compromise previously captured traffic.
- **Individualized Data Encryption:** For open networks, Opportunistic Wireless Encryption (OWE, marketed as Wi-Fi Enhanced Open) gives each client its own encryption keys, so one client on a public hotspot can no longer read another's traffic. OWE does not authenticate the access point, so it is no defence against an evil twin; it only removes passive eavesdropping.
- **SAE Key Exchange:** In WPA3-Personal, the SAE handshake replaces the WPA2's four-way handshake, offering improved security against guessing attacks by ensuring that each attempt to guess a network password must be carried out on the network itself, rather than offline.
- **Protected Management Frames (PMF):** WPA3 mandates the use of PMF, which protects against eavesdropping on and forging of management frames.

#### Security Considerations

- **Resistance to Common Attacks:** WPA3 addresses the vulnerabilities of WPA2, including those exposed by the KRACK (Key Reinstallation Attack) and makes it much more difficult to crack passwords.
- **Improved Public Network Security:** The use of OWE in open networks provides encrypted communication even on networks that do not use passwords.

## 3.4 Conclusion

The progression from OSA and SKA through WEP, WPA and WPA2 to WPA3 is a sequence of responses to specific, concrete breaks: no authentication at all, a keystream leaked by a challenge-response, a repeating IV, an RC4-based cipher, and an offline attack on a captured handshake. Authentication and encryption are separate choices, and a network is only as strong as the weaker of the two: WPA2-Enterprise with certificate validation disabled on the clients, or WPA3 with a guessable passphrase, both fail despite a sound protocol.

## Sources

- [https://en.wikipedia.org/wiki/IEEE_802.11](https://en.wikipedia.org/wiki/IEEE_802.11)
- [https://en.wikipedia.org/wiki/Wireless_LAN](https://en.wikipedia.org/wiki/Wireless_LAN)
- [https://en.wikipedia.org/wiki/Wi-Fi](https://en.wikipedia.org/wiki/Wi-Fi)
- [https://en.wikipedia.org/wiki/Pre-shared_key](https://en.wikipedia.org/wiki/Pre-shared_key)
- [https://en.wikipedia.org/wiki/Wi-Fi_Protected_Access](https://en.wikipedia.org/wiki/Wi-Fi_Protected_Access)
