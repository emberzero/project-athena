# Introduction to the Darknet

Few terms in IT security get misused as often as "darknet". News reports use it for everything from drug markets to leaked password lists, and the usual picture is a hidden layer of the internet where only criminals go. The reality is more ordinary and more interesting. A darknet is just an overlay network that needs special software to reach and that hides who is talking to whom. The same property that protects a whistleblower talking to a newspaper also protects someone selling stolen credit cards.

This lecture sorts out the terms, sketches the history of onion routing, and looks at who actually uses darknets and where the legal limits are.

## Surface Web, Deep Web, Darknet

The three terms describe different things and are often mixed up.

| Layer | What it is | Examples | How you reach it |
| --- | --- | --- | --- |
| Surface web | Pages a search engine can index | News sites, Wikipedia, public blogs | Any browser |
| Deep web | Content that exists on the normal internet but is not indexed | Webmail inboxes, online banking, school LMS, paywalled articles, company intranets | Any browser plus a login |
| Darknet | Overlay networks that need special software and hide endpoints | Tor onion services, I2P eepsites, Hyphanet freesites | Tor Browser, I2P router, Hyphanet client |

The deep web is by far the largest part, and almost all of it is boring: your e-mail is "deep web". The darknet is a small, separate set of networks. The popular iceberg image, where the darknet sits deep below the deep web, is misleading. A darknet is not a lower layer of the same web. It is a different network that happens to run over the same internet cables.

The word itself predates Tor. In the 1970s "darknet" meant networks cut off from ARPANET for security. It took on its current meaning with a 2002 paper by Microsoft researchers, *The Darknet and the Future of Content Distribution*, which used it for file-sharing networks that copyright holders could not control.

## Darknet Technologies

Tor is the best known, but not the only one.

**Tor** (The Onion Router) anonymizes connections by routing them through three volunteer relays. It can reach the normal internet anonymously and also host *onion services*, servers whose location is hidden. With about two million daily users and several thousand relays, it is by far the largest anonymity network. Lectures 2 and 3 cover it in depth.

**I2P** (Invisible Internet Project) is built for traffic that stays inside the network. Every participant is also a router, and tunnels are one-directional, so requests and replies take different paths. I2P bundles several messages together ("garlic routing"). It is popular for internal services and torrenting but has far fewer users than Tor.

**Hyphanet** (called Freenet until 2023) is a distributed data store rather than a way to connect to servers. Users donate disk space; published content is split, encrypted and spread across nodes, and stays available while people request it. There is no central server to take down, and a node operator does not know what they are storing.

**Friend-to-friend networks** (for example RetroShare, or Hyphanet in "darknet mode") only connect to peers you have explicitly added. They are small, but strangers cannot even see that they exist.

## A Short History of Onion Routing

Onion routing did not start with criminals or activists. It started at the US Naval Research Laboratory.

- **Mid-1990s:** Paul Syverson, Michael Reed and David Goldschlag at the NRL develop onion routing to protect US intelligence communications. The key insight: anonymity only works if many different people use the same network. A network used only by spies would reveal that its users are spies.
- **2002:** Roger Dingledine and Nick Mathewson, together with Syverson, deploy the second-generation design, called Tor.
- **2004:** Tor is released under a free licence and the design paper *Tor: The Second-Generation Onion Router* is published at USENIX Security. Hidden services (now onion services) are part of the design.
- **2006:** The Tor Project, Inc. is founded as a US non-profit. A large share of its funding has historically come from US government grants, alongside foundations and individual donors.
- **2008:** The Tor Browser Bundle makes Tor usable without manual configuration.
- **2011-2013:** Silk Road, the first large darknet drug market, operates as a Tor onion service and makes "darknet" a household word.
- **2013:** The Snowden documents show that the NSA found Tor hard to break ("Tor Stinks" slide) and attacked users' browsers instead.
- **2017-2021:** v3 onion services with stronger cryptography arrive; the old v2 addresses are switched off in 2021.
- **2022 onward:** The Tor Project builds *Arti*, a rewrite of Tor in Rust, and adds denial-of-service defences for onion services.

## Who Uses the Darknet?

Media coverage focuses on crime, but most Tor traffic goes to ordinary websites on the normal internet. Only a small fraction goes to onion services at all.

**Legitimate users include:**

- **Journalists and their sources.** SecureDrop, used by many large newsrooms, runs as an onion service so a source can submit documents without revealing their IP address.
- **People under censorship.** In countries that block news sites or social networks, Tor with bridges is often the only reliable way out. Usage spikes during protests and internet shutdowns.
- **Activists and human-rights workers** who are under state surveillance.
- **Ordinary privacy-conscious users** who do not want their ISP, employer or advertisers to profile their browsing.
- **Security researchers and threat-intelligence analysts** who monitor criminal forums without revealing their employer.
- **Law enforcement and the military.** Investigators use Tor so a suspect's web server does not log a police IP address.
- **Large organizations.** The BBC, Deutsche Welle, The New York Times, ProPublica, DuckDuckGo and Facebook all run official onion services so people in censored countries can reach them.

**Criminal use includes:**

- Marketplaces for drugs, stolen data, counterfeit documents and malware
- Ransomware leak sites where groups publish victims' data to pressure them into paying
- Forums for trading access to hacked company networks ("initial access brokers")
- Child sexual abuse material, which law enforcement prioritizes and which is the target of many of the largest operations

Both lists are real. Darknet technology is dual-use in the same way as encryption, cash or cars, and the debate about it is a debate about that trade-off.

## Legal Situation

This section is an overview, not legal advice. Module 01 covers the criminal law in detail.

**Using Tor is legal** in Austria, Germany and almost all of the EU. Installing Tor Browser, reading news through Tor or visiting a legitimate onion service is not a crime.

**What you do over Tor is judged like anything else.** Buying drugs is a crime under the Austrian Suchtmittelgesetz whether you buy on the street or on an onion service. Buying stolen login data or hacking tools to misuse them falls under the computer-crime provisions (for example §126c StGB in Austria, §202c StGB in Germany). Downloading child sexual abuse material is a serious crime everywhere, and "I was only curious" is not a defence.

**Running a platform is its own offence in Germany.** Since 2021 §127 StGB makes it a crime to operate an internet trading platform whose purpose is to enable crimes. This was aimed directly at darknet market operators.

**Running a relay is legal but not without risk.** Relays forward traffic they cannot read. Exit relays, though, appear in logs as the source of whatever their users do. In 2014 a court in Graz convicted a man who ran Tor exit relays from his home after illegal material passed through them, and German relay operators have had their homes searched. Anyone who wants to run an exit relay should do it through an organization, not from a home connection.

**For this course:** do not visit darknet marketplaces, forums or leak sites, not even "just to look". Downloading leaked data can itself be a crime, illegal content can load automatically, and these sites routinely serve malware. All assignments in this module work with legitimate onion services and your own lab setups.

## Conclusion

The darknet is not a hidden basement of the internet. It is a set of anonymity networks, of which Tor is by far the largest. It was designed by a navy research lab, it is used every day by journalists and people under censorship, and it is abused by criminals because it works. To judge that trade-off, or to investigate or defend against darknet crime, you need to understand how the technology works and where it breaks. The next lectures cover exactly that.

## Resources

- **Tor Project**: <https://www.torproject.org/> - Downloads, documentation and the design papers
- **Tor Metrics**: <https://metrics.torproject.org/> - Live statistics on users, relays and bandwidth
- **Dingledine, Mathewson, Syverson**: *Tor: The Second-Generation Onion Router* (USENIX Security 2004)
- **Biddle, England, Peinado, Willman**: *The Darknet and the Future of Content Distribution* (2002)
- **I2P**: <https://geti2p.net/>
- **Hyphanet**: <https://www.hyphanet.org/>
- **SecureDrop**: <https://securedrop.org/>
