# Deanonymization and OPSEC

Tor's cryptography has held up well for over twenty years. Yet the operators of almost every large darknet market have been caught. The two facts fit together. Very few of these cases broke Tor itself. Most attacked something around it: the browser, a misconfigured server, a payment trail, or the oldest weak point of all, a person who made one mistake years earlier.

This lecture covers both sides. First the technical attacks on Tor and its users, then the real cases, and finally what OPSEC means in practice for anyone who needs anonymity, including security researchers and investigators doing legitimate work.

## Technical Attacks

### Traffic Correlation

As Lecture 2 explained, Tor does not protect against an adversary who can watch both ends of a connection. If you see packets entering the network at a user's guard and packets leaving towards a website at the same moments and in the same volumes, you can link the two without decrypting anything.

Doing this globally requires visibility into a large part of the internet. Some actors have parts of it:

- **Large network operators** (ISPs, internet exchanges, the backbone ASes) see a large share of traffic. Research such as the 2015 *RAPTOR* paper showed that a single large AS is often on both the client-to-guard and exit-to-website path.
- **Intelligence services** that tap internet cables.
- **Relay operators**, if they control the user's guard and the exit or the destination.

A real case: in 2024 German media reported that police had identified a user of a child-abuse platform by repeatedly monitoring Tor relays and matching timing over months. The Tor Project's analysis found that the target had used an outdated messenger (Ricochet) without the *vanguards-lite* protection that current Tor versions include.

### Malicious Relays

Anyone can run a Tor relay, including attackers. A **Sybil attack** means adding many relays to increase the chance of being chosen.

- **BTCMITM20 (2020):** an attacker ran a large number of exit relays, at the peak roughly a quarter of all exit capacity. They downgraded HTTPS connections to HTTP where possible (*SSL stripping*) and replaced Bitcoin addresses on cryptocurrency sites with their own.
- **KAX17 (2017-2021):** an unknown actor ran hundreds of mostly guard and middle relays over several years, consistent with an attempt to deanonymize users. The relays were removed after volunteer researchers documented them.
- **CMU "relay early" attack (2014):** researchers at Carnegie Mellon University ran relays that marked traffic with a hidden signal so that their guards could recognize it. The data later reached the FBI and was used in the case against a Silk Road 2.0 administrator.

The Tor Project and volunteers scan for misbehaving relays and remove them or flag them as `BadExit`. Fixed guards, HTTPS by default and the rule that two relays of the same operator never share a circuit all limit the damage.

### Website Fingerprinting

Even without seeing the exit side, an observer between you and your guard (your ISP, for example) sees the *pattern* of your encrypted traffic: how many cells go in which direction, and when. Every website has a characteristic pattern. A machine-learning classifier trained on many page loads can guess which of a set of known sites you are visiting. In lab conditions this is very accurate. On the real, open internet, with millions of possible sites, it is much harder, but it remains an active research topic and the reason why Tor adds padding.

### Browser Exploits

Instead of attacking the network, an attacker can attack the browser. A single exploit that runs code on the user's machine can simply open a connection *outside* Tor and reveal the real IP address. The FBI calls this a "network investigative technique" (NIT).

- **Freedom Hosting (2013):** the FBI seized a hosting provider for onion services and served JavaScript that exploited a bug in the Firefox version underlying Tor Browser at that time. Infected computers sent their real IP address, MAC address and hostname to a server in the US.
- **Playpen (2015):** the FBI took over a child-abuse site and ran it for about two weeks, delivering a NIT to visitors. Thousands of IP addresses were identified worldwide.

This is the main reason for Tor Browser's *Safest* security level, which disables JavaScript entirely, and for systems like Whonix (below) where even a fully compromised browser cannot learn the real IP address.

### Attacks on the Server

For onion services, the server is often the weakest point. As Lecture 3 showed, a web server that is also reachable on its public IP, a leaky status page or an outgoing connection is enough. Several takedowns began with investigators finding the real server through a misconfiguration or a web vulnerability, then getting the hosting provider to copy the disk.

## Case Studies: How Operators Were Caught

### Silk Road (2013)

Silk Road was the first large darknet drug market, run by Ross Ulbricht under the name "Dread Pirate Roberts".

- **Early forum posts.** In January 2011, before the site was known, a user called "altoid" advertised it on a drug forum and on the Bitcointalk forum. Months later, "altoid" posted on Bitcointalk looking for a programmer and asked people to reply to *<rossulbricht@gmail.com>*. An IRS investigator found this link by searching old forum posts.
- **Fake IDs.** In 2013 US customs intercepted a package of fake identity documents with Ulbricht's photo, addressed to his apartment.
- **The server.** Investigators located the Silk Road server in Iceland. The FBI stated that a misconfigured login page leaked its real IP address; the defence disputed this account.
- **The arrest.** Agents arrested Ulbricht in a San Francisco public library in October 2013. They distracted him so they could grab his laptop while it was unlocked, with the administrator panel open. The laptop held diaries and chat logs.

Ulbricht was sentenced to life in prison in 2015 and pardoned in January 2025. Nothing in the case required breaking Tor.

### AlphaBay and Hansa (2017)

AlphaBay was the largest market after Silk Road, run by Alexandre Cazes from Thailand.

- **The e-mail address.** In its first months, AlphaBay's welcome and password-reset e-mails were sent with a header containing Cazes's personal Hotmail address. That address linked to his real name, his LinkedIn profile and his company.
- **Money.** Investigators traced cryptocurrency from the market to his assets: cars, villas, bank accounts.
- **The arrest.** In July 2017 Thai police arrested Cazes at his home, again with his laptop unlocked and logged in to the servers. He died in custody a few days later.

At the same time Dutch police were running **Operation Bayonet** against Hansa, the second-largest market. They had found Hansa's servers and identified its administrators, but instead of shutting it down they **took over the market** and ran it secretly for about a month. When AlphaBay went offline, thousands of its users moved to Hansa, straight into a market controlled by police. The police changed the code to record passwords and collect delivery addresses that users had normally encrypted. Only then did they shut Hansa down and publish what they had collected.

The lesson is uncomfortable: a site you trust can already be run by someone else, and its own users cannot tell.

### More Takedowns

- **Welcome to Video (2019):** a child-abuse site traced through Bitcoin payments. Blockchain analysis linked deposits to cryptocurrency exchanges that knew their customers' identities.
- **Hydra Market (2022):** the largest Russian-language market. German police (BKA) seized its servers, which were hosted in Germany, together with Bitcoin worth about 23 million euros.
- **Genesis Market (2023):** a market for stolen browser sessions and cookies, taken down by an international operation ("Cookie Monster"). Its main site was reachable over the normal internet as well, which made it easier to find.

### The Pattern

| Failure | Cases |
| --- | --- |
| Identity linked to an old account, e-mail or username | Silk Road, AlphaBay |
| Cryptocurrency traced to an exchange or real assets | AlphaBay, Welcome to Video |
| Server misconfiguration or web vulnerability | Silk Road (disputed), many smaller markets |
| Server located and copied, then platform taken over | Hansa, Playpen |
| Browser exploit | Freedom Hosting, Playpen |
| Device seized while unlocked | Silk Road, AlphaBay |
| Weakness in Tor itself | CMU relay early attack (2014), the 2024 timing case |

## OPSEC: Operational Security

OPSEC means looking at your own activity the way an adversary would and removing the clues. It comes from the military, and it applies equally to journalists protecting sources, to penetration testers, and to threat-intelligence analysts who must not reveal their employer.

Core principles:

- **Know your threat model.** Hiding from advertisers, from your school network or from a national police force requires very different effort. Decide who you are protecting against before choosing tools.
- **Compartmentalize.** Keep identities completely separate: separate accounts, separate e-mail addresses, separate devices or VMs. A single login with your real account from your anonymous setup links the two forever.
- **Never reuse identifiers.** Usernames, e-mail addresses, PGP keys, wallet addresses, profile pictures and even phrases can be searched for years later.
- **Watch the metadata.** Documents and photos contain author names, GPS coordinates and software versions. The times you are active reveal your time zone. Your writing style can be compared with known texts (*stylometry*).
- **Assume every system can be compromised.** Design so that one failure (an exploited browser, a seized laptop) does not reveal everything: full-disk encryption, locked screens, amnesic systems.
- **Assume the past is permanent.** Forum posts, leaked databases and blockchain transactions do not go away. Ulbricht's mistake was a post he wrote years before he was caught.

### Hardening Tools

| Tool | Idea | Protects against |
| --- | --- | --- |
| **Tor Browser, Safest level** | JavaScript off everywhere | Most browser exploits and fingerprinting |
| **Tails** | Live OS from USB; all traffic through Tor; nothing written to disk; forgets everything at shutdown | Forensic traces on the computer, accidental non-Tor connections. Since 2024 Tails is part of the Tor Project |
| **Whonix** | Two VMs: a *Gateway* that runs Tor and a *Workstation* that can only reach the network through it | IP leaks even if the workstation is fully compromised, because it does not know the real IP |
| **Qubes OS** | Every task in its own isolated VM; can run Whonix inside | Compromise of one activity spreading to others |

None of these tools help if the user logs into a personal account or reuses a nickname. They solve technical problems, not OPSEC mistakes.

## Darknet Monitoring for Defenders

Companies, CERTs and law enforcement watch darknet sources to learn about threats early: their own company appearing on a ransomware leak site, employee credentials for sale, access to their network offered by an initial access broker, or a new exploit being traded. Module 02 introduced this as part of OSINT.

Most of this work does not mean browsing markets yourself:

- **Aggregators and feeds.** Public projects such as ransomware.live collect leak site posts; commercial threat-intelligence platforms monitor forums and markets and provide alerts.
- **Breach notification services.** Have I Been Pwned, and similar services run by national CERTs, tell you when accounts appear in leaked data.
- **Professional investigations.** Where direct access is necessary, it happens with a legal mandate, an approved process, isolated infrastructure (dedicated VMs, often Whonix), documented sock-puppet identities, and strict rules: never buy, never download leaked data without legal clearance, never interact in a way that encourages a crime, and report illegal content to the authorities.

For students the rule from Lecture 1 applies: the techniques in this module are for understanding and for your own lab. Accessing criminal sites, even passively, is not part of this course.

## Conclusion

Tor's protocol is rarely what fails. Traffic correlation, malicious relays and website fingerprinting are real, but most identified darknet operators were caught through browser exploits, misconfigured servers, cryptocurrency trails and, above all, ordinary human mistakes made years earlier. The Hansa takeover showed that even the platform itself cannot be trusted. Good OPSEC means a clear threat model, strict compartmentalization and the assumption that every system and every old post will eventually be examined. Defenders use the same understanding to monitor darknet threats legally, mostly through aggregators and professional processes rather than by visiting criminal sites themselves.

## Resources

- **Tor Project blog**: <https://blog.torproject.org/> - Analyses of attacks and relay incidents (including the 2014 relay early attack and the 2024 timing case)
- **nusenu on Medium**: Reports on KAX17 and BTCMITM20 malicious relay groups
- **Sun et al.**: *RAPTOR: Routing Attacks on Privacy in Tor* (USENIX Security 2015)
- **Andy Greenberg**: *Tracers in the Dark* (2022) - Book on cryptocurrency tracing, AlphaBay, Hansa and Welcome to Video
- **Nick Bilton**: *American Kingpin* (2017) - Book on the Silk Road investigation
- **Europol**: <https://www.europol.europa.eu/> - Press releases on darknet operations
- **Tails**: <https://tails.net/>
- **Whonix**: <https://www.whonix.org/>
