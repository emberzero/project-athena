#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 17: Cloud Security],
    subtitle: [Securing Someone Else's Computer],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 17 - Cloud Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Overview")

#slide(title: "What Cloud Security Is")[
  Policies, technologies and procedures that protect data, apps and infrastructure on *someone else's hardware*.

  - Same goals: confidentiality, integrity, availability
  - The difference: you no longer control the *whole stack*
  - How much is yours depends on the *service model*

  #cblock(title: [Key idea])[
    The provider runs part of the stack; you are responsible for the rest.
  ]
]

#slide(title: "Service Models")[
  #table(
    columns: (auto, 1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Model*], [*You get*], [*Example*],
    [IaaS], [Virtual machines on demand], [EC2, Azure VMs],
    [PaaS], [Runtime + OS managed for you], [App Engine, Heroku],
    [SaaS], [Finished applications], [Workspace, Salesforce],
  )

  Read the stack bottom-up: the higher the model, the more the provider runs.
]

#slide(title: "Who Is Responsible for What?")[
  ```text
  Layer                      IaaS      PaaS      SaaS
  -----------------------------------------------------
  Data + user accounts       you       you       you
  Application code           you       you       provider
  Runtime / libraries        you       provider  provider
  Operating system           you       provider  provider
  Hypervisor                 provider  provider  provider
  Servers, storage, network  provider  provider  provider
  ```

  The top row *never moves*: your data, access rules and accounts stay yours.
]

#slide(title: "Deployment Models")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Public*], [Third party owns it, sells to anyone (GCP, AWS, Azure)],
    [*Private*], [Resources dedicated to one organisation],
    [*Hybrid*], [Public and private used together (Outposts, Arc, Anthos)],
  )

  Common public-cloud services: serverless compute, object storage, managed databases, container orchestration, CDNs, ML APIs.
]

#section-slide(title: "Server Types and Trade-offs")

#slide(title: "Cloud, Dedicated, Shared")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Shared*], [One machine, many tenants. Cheapest; a noisy neighbour hits all],
    [*Dedicated*], [One machine, one tenant. No contention; you pay for idle],
    [*Cloud*], [Capacity as a service; instances added and removed on demand],
  )

  The type sets the ceiling for performance, security and scalability, and is hard to change later.
]

#slide(title: "Which One to Use?")[
  #table(
    columns: (1fr, auto, 1fr),
    inset: 5pt,
    stroke: 0.5pt + gray,
    [*Scenario*], [*Type*], [*Reason*],
    [Student project], [Shared], [Cheap, simple, low traffic],
    [High-traffic app], [Cloud], [Handles spikes, scales],
    [Sensitive data], [Dedicated], [Security, no sharing, full control],
    [Media-rich site], [Dedicated], [Fast media, many concurrent users],
  )

  Cloud scales but costs vary; dedicated is secure but inflexible; shared is simple but contended.
]

#section-slide(title: "Authentication and IAM")

#slide(title: "One Shape, Three Vocabularies")[
  All three providers solve the same problem: an *identity* is granted a named set of *permissions* on a *scoped resource*.

  ```text
  Who              may do what        on which resource
  user, group,  +  role: a named   +  org, folder,
  domain, or       set of             project, or
  service acct     permissions        one bucket
  ```

  Only the vocabulary differs between GCP, AWS and Azure.
]

#slide(title: "IAM Across the Providers")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*GCP*], [IAM: roles, policies, members (principals); Cloud Identity],
    [*AWS*], [Users, groups, roles; JSON policies; Organizations + SCPs],
    [*Azure*], [Entra ID; RBAC roles; scopes; Azure Policy, Blueprints],
  )

  - GCP basic roles (Owner, Editor, Viewer) are too broad for production
  - AWS roles are *assumed*, not tied to one user
]

#slide(title: "Inheritance Is the Trap")[
  #cblock(title: [IAM allow policies only add], color: red.darken(20%))[
    A role granted at the org or folder level applies to *every* project underneath. A broad grant higher up cannot be withdrawn by a narrower allow policy below.
  ]

  Restricting again needs a *separate* mechanism: a deny policy or an org policy constraint.
]

#section-slide(title: "Containerization")

#slide(title: "Containers vs Virtual Machines")[
  The decisive difference is the *kernel*. A VM brings its own; containers share the host's.

  ```text
  VMs                        Containers
  app + libs + guest OS      app + libs
  per VM                     container runtime
  hypervisor                 shared host kernel
  host OS / hardware         host OS / hardware
  ```

  Benefit: seconds to start, less overhead. Limit: *one kernel bug* can affect every container on the host.
]

#slide(title: "Container Security")[
  - Isolation is from kernel features (namespaces, cgroups, seccomp), *weaker* than a VM: not for untrusted code
  - Scan images (Trivy, Grype, Clair); minimise the base image
  - Harden the runtime: SELinux, AppArmor
  - Secure orchestration: Kubernetes RBAC, network policies, API access

  #cblock(title: [Secrets], color: red.darken(20%))[
    Never bake secrets into an image. Kubernetes Secrets are only *base64*, not encrypted: enable encryption at rest or use a secret manager.
  ]
]

#slide(title: "Container Best Practices")[
  - *Least privilege:* run as non-root, drop capabilities, read-only rootfs
  - Avoid `--privileged` and mounting the Docker socket (both = root on host)
  - Update and patch base images regularly
  - Network segmentation via network policies
  - Automated security testing in CI/CD
  - Continuous monitoring and incident response
]

#section-slide(title: "Security Concepts")

#slide(title: "Eight Areas That Matter")[
  #split(
    [
      1. Network security
      2. Logging and monitoring
      3. Incident response
      4. Backup and recovery
    ],
    [
      5. Patch management
      6. Threat intelligence
      7. Testing
      8. Shared responsibility
    ],
  )

  Cloud security is a set of *overlapping* controls, not a single switch.
]

#slide(title: "Network and Logging")[
  #split(
    [
      *Network*
      - VPCs isolate resources
      - NACLs / security groups
      - TLS in transit (SSL and TLS 1.0/1.1 deprecated)
      - DDoS mitigation
    ],
    [
      *Logging + monitoring*
      - Centralise logs
      - Real-time monitoring
      - SIEM correlation
      - Audit trails for compliance
    ],
  )

  Monitoring gives threat detection, incident response, compliance and operational insight.
]

#slide(title: "Incident Response Is a Cycle")[
  ```text
  1 Preparation   playbooks, on-call, tabletop
  2 Detection     alerts, log review, triage
  3 Containment   isolate - but snapshot FIRST
  4 Eradication   remove foothold, rotate creds
  5 Recovery      rebuild from known-good
  6 Lessons       post-mortem feeds preparation
  ```

  #cblock(title: [The common mistake], color: red.darken(20%))[
    Shutting down a compromised instance before snapshotting destroys the evidence of how they got in.
  ]
]

#slide(title: "Backup and Patch Management")[
  #split(
    [
      *Backup + recovery*
      - Regular, integrity-checked
      - Offsite / geo-separate
      - Automated policies
      - Encrypt backups
    ],
    [
      *Patch management*
      - Automated patching
      - Test before production
      - Regular audits
      - Track NVD, CVE, CISA
    ],
  )
]

#slide(title: "Testing Methodologies")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Red teaming*], [Imitate a real adversary; test if defenders detect],
    [*Pen testing*], [Find exploitable bugs in a defined scope, time-boxed],
    [*Vuln scanning*], [Automated, continuous, finds *known* issues],
    [*Security audit*], [Check config against a baseline (CIS benchmarks)],
  )

  Combine them, test repeatedly. Check the provider's policy: attacking resources you do not own breaches the terms.
]

#slide(title: "Shared Responsibility Model")[
  Security *of* the cloud (provider) vs security *in* the cloud (you).

  ```text
  Provider's side          Your side
  physical data centres    IAM users, roles, keys
  host OS, hypervisor      guest OS patches (IaaS)
  network backbone         firewall / SG rules
  service availability     bucket + DB access rules
  managed-service patches  app code and its bugs
  ```

  Most reported cloud breaches start on *your* side: a public bucket, an over-broad role, a leaked key.
]

#section-slide(title: "Secure DevOps")

#slide(title: "DevSecOps")[
  Build security into *every* pipeline stage, not a gate before release. The argument is cost: a flaw found while coding is cheap; in production it is not.

  ```text
  Plan -> Code -> Build -> Test -> Deploy -> Operate
  threat  secret  dep/img  DAST,   signed    runtime
  model   scan,   scan     IaC     images,   monitor,
          SAST             checks  least-    drift
                                   priv
  ```

  A failing check breaks the build. Each stage needs a named owner and a failure action.
]

#section-slide(title: "Certifications and Standards")

#slide(title: "Organisation vs Person")[
  #cblock(title: [Two different things])[
    A *standard* certifies an organisation. A *professional certification* attests to one person's knowledge.
  ]

  #table(
    columns: (1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Certifies an org*], [*Certifies a person*],
    [ISO/IEC 27001], [CISSP (broad management)],
    [NIST SP 800-53], [CISA (audit, ISACA)],
    [(a control catalogue)], [CCSP (cloud, (ISC)2 + CSA)],
  )
]

#slide(title: "The Main Standards and Certs")[
  - *ISO/IEC 27001:* an audited ISMS; risk management, controls, continuous improvement. Valid 3 years with annual audits
  - *NIST SP 800-53:* a control catalogue to build on, not a certification you obtain
  - *CISSP:* eight domains, broad, management-focused, experience required
  - *CCSP:* CISSP's ground narrowed to cloud: shared responsibility, multi-tenancy, data residency

  Be clear which question you are answering: "is this org trustworthy?" vs "does this person know the subject?"
]

#standout-slide(title: [Moving to a managed service moves the responsibility line. It never removes it.])
