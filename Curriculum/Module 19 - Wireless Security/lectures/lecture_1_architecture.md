# The Wireless Network Architecture

## 1.1 Introduction

Wireless networks carry data over radio frequencies instead of cables. This lecture covers the main families of wireless network, the technologies behind them, and the architecture and operation of WLANs, which are the focus of the rest of the module.

## 1.2 Types of Wireless Networks

- **WPAN (Wireless Personal Area Networks):** These are low-power, short-range networks, ideal for personal device connectivity.
- **WLAN (Wireless Local Area Networks):** Medium-sized networks, commonly utilized in homes and offices, operate primarily on 2.4 GHz and 5 GHz radio frequencies.
- **WMAN (Wireless Metropolitan Area Networks):** Large networks designed for city-wide communication.
- **WWAN (Wireless Wide Area Networks):** Extensive networks covering broad areas, often used for cellular communications.

## 1.3 Wireless Technologies

### 1.3.1 Bluetooth

Bluetooth is a WPAN technology for data exchange over short distances and is used in devices like smartphones and headphones.

- **BLE (Bluetooth Low Energy):** Optimized for low power consumption, it's suitable for devices requiring periodic small data exchanges.
- **BBR (Bluetooth Basic Rate):** The initial standard, offering fundamental connectivity.
- **EDR (Enhanced Data Rate):** Higher data transfer rates, useful for high-throughput needs like audio streaming.

### 1.3.2 WiMAX

Worldwide Interoperability for Microwave Access is a WMAN technology. It's designed for long-range communication, with a focus on providing broadband internet access over large areas.

### 1.3.3 Cellular

Cellular networks are a set of WWAN technologies providing long-range and mobile access to carriers using cell towers.

- **1G:** Introduced in the 1980s, first generation networks were analog and supported only voice calls.
- **2G/GSM:** Global System for Mobile Communications is providing features for digital communication with separate voice and data for both, calls and SMS. This standard also introduced SIM (Subscriber Identity Module) cards, which identify and authenticate subscribers.
- **3G, 4G/LTE and 5G:** The third generation, fourth generation with long term evolution and fifth generation of cellular protocols, each with improved bandwidth and more speed.

### 1.3.4 WLAN

WLAN refers to a wireless network that connects devices over a short distance, typically within a building such as a home, office, or school. It is powered by different versions of the WiFi (Wireless Fidelity) protocol family.

| Generation | Standard | Maximum Bandwidth | Radio Frequency |
| ---------- | -------- | ----------------- | --------------- |
| Wi-Fi 7    | 802.11be | 46120 Mbit/s      | 2.4, 5, 6 GHz   |
| Wi-Fi 6E   | 802.11ax | 9608 Mbit/s       | 6 GHz           |

**Note:** The "Wi-Fi N" generation labels were introduced by the Wi-Fi Alliance alongside Wi-Fi 6, and applied retroactively to 802.11n and 802.11ac as Wi-Fi 4 and Wi-Fi 5. The lower numbers in this table are informal names that the Alliance never adopted; the 802.11 letters are the names used in the standard itself. The bandwidth figures are theoretical maxima for the full channel width and number of spatial streams, not throughput you will measure on a real link.
| Wi-Fi 6    | 802.11ax | 9608 Mbit/s       | 2.4 GHz, 5 GHz  |
| Wi-Fi 5    | 802.11ac | 6933 Mbit/s       | 5 GHz           |
| Wi-Fi 4    | 802.11n  | 600 Mbit/s        | 2.4 GHz, 5 GHz  |
| Wi-Fi 3    | 802.11g  | 54 Mbit/s         | 2.4 GHz         |
| Wi-Fi 2    | 802.11a  | 54 Mbit/s         | 5 GHz           |
| Wi-Fi 1    | 802.11b  | 11 Mbit/s         | 2.4 GHz         |
| Wi-Fi 0    | 802.11   | 2 Mbit/s          | 2.4 GHz         |

**Note:** Even though there are many other wireless protocols that need to be secured, this module is only focused onto WLAN security.

## 1.4 WLAN Architecture

Wireless Local Area Networks (WLANs) let devices connect and communicate over radio frequencies. Unlike wired networks they give flexibility and mobility, since connectivity does not depend on where the cables run. A WLAN typically consists of an access point (AP) that broadcasts a signal, which client devices like laptops, smartphones, and tablets can connect to.

### 1.4.1 Topologies

- **Basic Service Set (BSS):** This is the basic building block of a WLAN. In a BSS, devices communicate with a single access point. It's akin to a simple, standalone network or a cell in the wireless network.
- **Extended Service Set (ESS):** An ESS is a series of interconnected BSSs. This setup allows a device to roam seamlessly from one AP to another within the same network, which is common in larger settings like campuses or office buildings.
- **Mesh Networks:** These networks do not rely on a central AP. Instead, each node in a mesh network can forward data to other nodes, making the network more resilient and flexible.
- **Ad-Hoc Networks (IBSS):** In an Independent Basic Service Set, devices connect directly without an AP, suitable for small, temporary setups.

### 1.4.2 Hardware

- **Access Points (APs):** An AP broadcasts the wireless signal that client devices connect to. They can vary in capabilities, from basic home routers to more sophisticated enterprise-grade APs.
- **WLAN Controllers:** These are used in larger WLANs to centrally manage multiple APs, handling tasks like load balancing, authentication, and security policies.
- **Client Devices:** Any device with a wireless networking capability can be a client device. This includes laptops, smartphones, and increasingly, IoT devices.

## 1.5 WLAN Operation

WLAN operation covers how the network carries data, shares access to the radio channel, and maintains the integrity and security of that communication.

### 1.5.1 SSIDs

The Service Set Identifier (SSID) is the primary identifier of a wireless network. It is the network's name, which distinguishes it from the other networks within range, and the administrator can set it freely.

- **Function of SSID:** When an access point (AP) broadcasts its presence, it includes the SSID in its beacon frames. This allows client devices to see the network's name when scanning for available connections.
- **SSID Broadcasting:** APs can either broadcast their SSID, making the network visible to all devices within range, or hide it, requiring users to know the SSID beforehand to connect.
- **Security Implications:** While hiding an SSID can seem like a security measure, it's not entirely effective as the SSID can still be discovered through other means, like sniffing data frames. The security of a WLAN depends far more on its encryption and authentication methods.

### 1.5.2 Channels

WLANs use radio frequencies, divided into channels, to transmit and receive data. The 2.4 GHz and 5 GHz bands are common, each with a set of channels.

- **Channel Bandwidth:** Refers to the frequency range that each channel occupies. For instance, in the 2.4 GHz band, channels are typically 20 MHz wide.
- **Channel Utilization:** Only one device can effectively transmit data on a channel at any given moment. When multiple devices attempt to use the same channel simultaneously, it leads to collisions and network inefficiencies.
- **Interference and Overlap:** In the 2.4 GHz band, channels often overlap, causing interference. Channels 1, 6, and 11 are widely used as they don't overlap.
- **Channel Selection:** The channel choice affects network performance. Neighboring networks, physical obstacles and device capabilities all influence which channel works best.

| Frequency Band | Channels | Typical Use               |
| -------------- | -------- | ------------------------- |
| 2.4 GHz        | 1 - 14   | General, broader coverage |
| 5 GHz          | 36 - 165 | High-speed data transfer  |

### 1.5.3 Frames

Frames are the units of data transmission in WLANs. Their structure shows how a WLAN manages data.

#### Frame Types

- **Management Frames:** Used for maintaining and managing the network.
  - **Beacon Frames:** Used for advertising and probing SSIDs.
  - **Authentication Frames:** Used for authenticating users to the network.
- **Control Frames:** Aid in the delivery of data.
- **Data Frames:** Carry the user data.

#### General Frame Structure

- **Header:** Contains source and destination addresses, frame control fields, and a sequence number.
- **Payload:** The actual data being transmitted.
- **Frame Check Sequence (FCS):** Used for error checking.

| Frame Part      | Description                | Length in Bytes |
| --------------- | -------------------------- | --------------- |
| Frame Control   | Type, sub-type, and flags  | 2               |
| Duration        | Time to occupy the channel | 2               |
| Address Fields  | Source, destination, etc.  | 6 each          |
| Sequence Number | Order of frames            | 2               |
| Payload         | User data                  | Variable        |
| FCS             | Error checking             | 4               |

### 1.5.4 CSMA/CA

CSMA/CA (Carrier Sense Multiple Access with Collision Avoidance) is a protocol used to reduce the risk of collision in WLANs.

- **Operation:** Before transmitting, a device listens to detect if any other device is transmitting (carrier sense). If the channel is clear, it will send a frame; if not, it waits for a random time period before retrying.
- **RTS/CTS Mechanism:** Request to Send (RTS) and Clear to Send (CTS) frames (Control Frames) are used to reserve the channel for a short duration, reducing the chance of collision in environments with high traffic. The client sends out RTS frames when desiring to transmit data, while the AP replies with CTS frames when ready to accept data from the client for a specific duration.

### 1.5.5 Device Association

This process involves several steps for a device to connect to a WLAN.

- **Discovery:** Devices either listen for beacon frames or send probe requests, to which APs reply with probe responses.
- **Authentication:** Authenticates the user to the network. More on this topic will be covered in later lectures.
- **Association:** After authentication, the device sends an association request to the AP. If accepted, the AP responds with an association response, and the device is connected.

```text
  Client (STA)                                  Access Point (AP)
       |                                               |
       |  1a. Beacon frames, sent periodically         |
       |<----------------------------------------------|
       |  1b. Probe request (active scan)              |
       |---------------------------------------------->|
       |      Probe response                           |
       |<----------------------------------------------|
       |                                               |
       |  2. Authentication request (OSA / SKA / SAE)  |
       |---------------------------------------------->|
       |      Authentication response                  |
       |<----------------------------------------------|
       |                                               |
       |  3. Association request                       |
       |---------------------------------------------->|
       |      Association response                     |
       |<----------------------------------------------|
       |                                               |
       |  4. Key exchange (WPA2 4-way / WPA3 SAE)      |
       |<--------------------------------------------->|
       |      encrypted data frames may now flow       |
```

Note that all of the frames up to step 4 are management frames sent in
the clear, whatever security protocol is in use. An attacker in range can
therefore see which SSIDs exist, which clients are associated to which AP,
and when they join or leave, without knowing the passphrase.

#### Discovery Options

- **Passive Scanning**

  - The client tunes to each channel in turn and simply listens for beacon frames, which an AP broadcasts at regular intervals and which normally contain the SSID.
  - The client sends nothing, so it does not reveal its own presence or which networks it is looking for.
  - This finds every AP that broadcasts its SSID, but it is slower, because the client must wait on each channel for the next beacon.

- **Active Scanning**

  - The client sends probe request frames and APs that match reply with probe responses.
  - This is faster and is the only way to find a network whose SSID is not broadcast, because the client must name the SSID in the probe request.
  - The cost is that the client leaks the list of SSIDs it remembers. An attacker can collect those probe requests and use them to set up a matching rogue AP, so a hidden SSID shifts the exposure from the AP to the client rather than removing it.

**Hidden SSIDs:** An AP can omit the SSID from its beacon frames. This does
not provide meaningful security: the SSID still appears in association
requests and in the probe exchange, so anyone capturing traffic recovers it
as soon as a legitimate client connects.

## 1.6 Conclusion

This lecture covered the families of wireless network (WPAN, WLAN, WMAN, WWAN), the technologies behind them, and the architecture and operation of WLANs: topologies, SSIDs, channels, frame types, CSMA/CA and the association process. The association sequence in particular is the foundation for the attacks and defences discussed in the following lectures, because much of it happens in plaintext regardless of the security protocol in use.

## Sources

- [https://en.wikipedia.org/wiki/IEEE_802.11](https://en.wikipedia.org/wiki/IEEE_802.11)
- [https://en.wikipedia.org/wiki/Wireless_LAN](https://en.wikipedia.org/wiki/Wireless_LAN)
- [https://en.wikipedia.org/wiki/Wi-Fi](https://en.wikipedia.org/wiki/Wi-Fi)
