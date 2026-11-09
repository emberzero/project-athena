# Stages of a Social Engineering Attack

A social engineering attack runs through a sequence of stages, each producing
something the next stage needs. Disrupting any one stage breaks the chain.

```text
  recon   ─▶ select  ─▶ trust   ─▶ exploit ─▶ execute ─▶ evade
  gathers    picks      builds     makes      gets       covers
  a profile  a victim   a pretext  the ask    access     tracks
```

1. **Reconnaissance:**
   The attacker gathers information about the target from social media, company websites, and any available online repository, and assembles a profile. The more detail they collect, the more convincing the later stages become.
1. **Target Selection:**
   Using that profile, the attacker picks targets by how susceptible they are and how useful they are for the intended outcome. A target can be an individual employee, a department, or an entire organization.
1. **Developing Trust:**
   The attacker builds a facade of credibility, for example by posing as a colleague, a superior, or a trusted service provider. Without it, the request in the next stage has no reason to be followed.
1. **Exploitation:**
   With trust established, the attacker makes the request: a carefully crafted email, a seemingly innocent phone call, or a manipulated online interaction. The goal is to get the target to divulge sensitive information or to perform an action that compromises security.
1. **Execution:**
   The planned attack runs. Through phishing emails, deceptive websites, or other manipulative tactics, the attacker uses the established trust to reach the objective, which ranges from acquiring login credentials to gaining unauthorized access.
1. **Evasion:**
   The attacker covers their tracks: removing log entries where they can, abandoning the pretext accounts and infrastructure, and keeping the intrusion unnoticed for as long as possible. The longer the access goes undetected, the more it is worth.

Defences map onto these stages. Limiting what staff publish about internal structure raises the cost of reconnaissance; a verification procedure for unusual requests breaks the trust stage; and logging that an attacker cannot reach makes the evasion stage fail.

## Sources

- Krebs on Security - [https://krebsonsecurity.com/](https://krebsonsecurity.com/)
- SANS Institute - [https://www.sans.org/](https://www.sans.org/)
- Cybersecurity & Infrastructure Security Agency (CISA) - [https://www.cisa.gov/](https://www.cisa.gov/)
- Wikipedia -[https://en.wikipedia.org/wiki/Social_engineering\_(security)](<https://en.wikipedia.org/wiki/Social_engineering_(security)>)
