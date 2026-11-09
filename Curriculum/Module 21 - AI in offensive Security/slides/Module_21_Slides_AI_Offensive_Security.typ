#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 21: AI in Offensive Security],
    subtitle: [What It Changes, What It Does Not],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 21 - AI in Offensive Security],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Introduction")

#slide(title: "Why LLMs Matter Here")[
  - ML has long been in security: spam filters, classifiers
  - LLMs made *text and code* cheap to produce and analyse
  - Offensive security is mostly reading, writing, correlating

  #cblock(title: [An LLM, briefly])[
    A next-token predictor. No state between calls except the text you
    pass it. Everything in its context is treated the same way.
  ]
]

#slide(title: "Vocabulary and Relationships")[
  #split(
    [
      *Terms*
      - *Context window:* all text seen for one call
      - *Agent:* an LLM in a tool-calling loop
      - *Prompt injection:* untrusted text acted on as instruction
      - *Hallucination:* confident, fluent, wrong
    ],
    [
      *AI and security*
      - *As a tool:* helps the attacker
      - *As a target:* the model is attack surface
      - *As a defender:* triage, detection
    ],
  )
]

#slide(title: "The Assisted Attack Loop")[
  #align(center + horizon, image("../lectures/images/assisted-attack-loop.svg", width: 50%))
]

#slide(title: "What AI Does and Does Not Change")[
  #split(
    [
      *Changes*
      - Cost of language collapses
      - Breadth without expertise
      - Triage and correlation scale
      - Repetitive work disappears
    ],
    [
      *Does not change*
      - The vulnerabilities
      - The controls
      - Verification of every claim
      - The law
    ],
  )

  "Look for bad grammar" is now obsolete, and teaching it is harmful.
]

#slide(title: "Failure Modes You Meet at Once")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Hallucinated fact*], [CVE, flag or API that does not exist],
    [*Confident wrong cmd*], [Right syntax, wrong, destructive semantics],
    [*Stale knowledge*], [Removed options, old default ports],
    [*Scope drift*], [An out-of-scope host gets scanned],
    [*Data leakage*], [Client data pasted to a third party],
  )

  Never pipe model output straight to a shell.
]

#slide(title: "Legal and Lab Ground Rules")[
  - Authorization *in writing* before anything runs (StGB §118a)
  - Sending client/personal data to a hosted model is a data transfer
  - §126c: build detection and labs, not deployable weapons
  - No deepfakes of real people without written consent

  #cblock(title: [Run a model locally])[
    `ollama run llama3.1` keeps lab data off third parties, and a weaker
    local model makes hallucinations easy to see.
  ]
]

#section-slide(title: "AI-Enhanced Malware")

#slide(title: "Three Claims, One Accelerator")[
  #split(
    [
      *"AI malware" means*
      - *Write it:* a model helps author code (common)
      - *Decide at runtime:* sample calls a model
      - *Evade ML:* adversarial input fools a classifier
    ],
    [
      *As a dev accelerator*
      - Translate techniques
      - Produce plumbing
      - Dodge static signatures
      - Lowers effort, not novelty
    ],
  )

  Packers dodged signatures since the 1990s: detection moved to behaviour.
]

#slide(title: "Runtime Calls Are Costly, Defences Hold")[
  #split(
    [
      *Why runtime calls are rare*
      - Bundled model: gigabytes
      - Public API: key + TLS egress
      - Self-hosted: infra, like C2

      All trade the attacker's main currency: staying quiet.
    ],
    [
      *What still stops it*
      - Patch, reduce attack surface
      - Application allow-listing
      - Least privilege, segmentation
      - Behavioural telemetry
      - Tested backups, egress control
    ],
  )
]

#slide(title: "On-Host Triage and ML Attacks")[
  #split(
    [
      *Triage after access*
      - "Which share holds contracts?"
      - Finds extortion-worthy files fast
      - Detectable as *access pattern*
      - Canary files fire on it
    ],
    [
      *Attacking defender ML*
      - Adversarial examples
      - Model extraction
      - Poisoning the retrain set
      - No single ML verdict as sole gate
    ],
  )
]

#section-slide(title: "AI in Social Engineering")

#slide(title: "Fluency Removes the Old Indicators")[
  #split(
    [
      *Dead indicators*
      - Broken grammar
      - Generic greeting
      - Wrong tone
      - Bad branding
    ],
    [
      *Still valid*
      - Mismatched sender domain
      - Unexpected credential/payment ask
      - Urgency plus secrecy
      - A channel the sender never uses
    ],
  )

  Spear-phishing quality now arrives at bulk phishing volume. Teach the
  *request* and the *channel*, not the *prose*.
]

#slide(title: "Voice Cloning and the Control")[
  #split(
    align: horizon,
    image("../lectures/images/voice-clone-chain.svg", width: 95%),
    [
      Cloning defeats *recognition*, not a process that never needed it.
      - *Call back* on a directory number
      - *Dual authorization* for payments
      - A non-scrapeable *verification question*
      - *No exceptions for seniority*
    ],
  )
]

#slide(title: "Video, Personas and Simulations")[
  - Real-time face/voice synthesis used in BEC fraud
  - Live-detection tricks are a moving target; treat video like a call
  - Fake recruiters, fake candidates, long-game relationship fraud
  - Defence: verify through the *organisation*, not the person

  #cblock(title: [Authorized phishing tests])[
    Written mandate; no real-person likeness without consent; collect
    *metrics, not credentials*; report in aggregate.
  ]
]

#section-slide(title: "AI-Assisted Vulnerability Scanning")

#slide(title: "The Pipeline and Where Models Fit")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Discovery / scanning*], [Mostly classic tools],
    [*Triage*], [Models help a lot (language work)],
    [*Verification*], [Humans and tools only, never the model],
    [*Prioritisation*], [Data beats models],
    [*Report*], [Models help a lot],
  )

  The model must not decide whether something is exploitable.
]

#slide(title: "Triage and Prioritisation")[
  #split(
    [
      *Triage: the honest win*
      - Cluster by root cause
      - Summarise scanner JSON
      - Cross-reference the SBOM

      ```bash
      nuclei -u http://192.168.56.10 \
        -jsonl -o f.jsonl
      ```
      Get raw counts first.
    ],
    [
      *Prioritise by data*
      - *CVSS:* abstract severity
      - *EPSS:* exploitation probability
      - *CISA KEV:* known exploited
      - *Your context:* exposure

      Let the model write sentences,
      not choose the order.
    ],
  )
]

#slide(title: "Source Analysis and Fuzzing")[
  - Tools find patterns precisely and lack context
  - Models have context and lack precision: *tool first, model second*
  - Best model use: *variant analysis*, the other places a bug appears
  - Fuzzing is the strongest automated finder; model writes the harness

  ```bash
  semgrep --config auto ./vulnerable-app
  afl-fuzz -i testcases/ -o findings/ -- ./target @@
  ```
]

#slide(title: "How It Goes Wrong, and the Rule")[
  #split(
    [
      *Common failures*
      - Hallucinated CVE identifiers
      - Hallucinated remediation
      - Non-working proof of concept
      - Confident false positives
      - Dropped findings (lossy)
    ],
    [
      #cblock(title: [A finding enters only if])[
        1. You reproduced it with request
          and response, or
        2. The vendor advisory for the
          exact version states it, or
        3. It is configuration shown in
          command output.
      ]
    ],
  )
]

#section-slide(title: "AI in Penetration Testing")

#slide(title: "Levels of Autonomy")[
  #table(
    columns: (auto, 1fr, auto),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*0 Reference*], [Ask, read, type it yourself], [Bad advice],
    [*1 Draft*], [Model writes, you review and run], [Unread cmd],
    [*2 Supervised*], [Approve each proposed step], [Approval fatigue],
    [*3 Autonomous*], [Loops on its own to a goal], [Scope breach],
  )

  Levels 0 and 1 hold almost all the honest value. Biggest gains: recall,
  reading output, report writing, the parts that decide nothing.
]

#slide(title: "The Agent Loop Fails Predictably")[
  - *No stopping condition:* runs until something else stops it
  - *Loops:* retries a dead path with cosmetic changes
  - *Destructive commands:* no model of what is irreversible
  - *Scope drift:* follows a redirect out of the engagement
  - *Lost evidence:* the summary survives, the raw proof is gone

  Every mitigation lives *outside* the model: allow-lists, approval
  gates, hard limits, full transcript logging.
]

#slide(title: "Prompt Injection Against Your Tooling")[
  #split(
    align: horizon,
    image("../lectures/images/prompt-injection-agent.svg", width: 90%),
    [
      - Your agent reads the target; the
        target may be attacker-controlled
      - A page, header, filename, PDF or
        review can address your agent
      - The model has *no channel
        separation*

      Scope and tool policy as code,
      outside the model.
    ],
  )
]

#slide(title: "Testing AI Systems as Targets")[
  Clients deploy LLM apps. Structure around the OWASP LLM Top 10:

  - Prompt injection, direct and *indirect* (the serious one)
  - Tool and plugin scope: with whose privileges?
  - Output handling: treat model output as untrusted input
  - Sensitive information disclosure; resource consumption; supply chain

  ```bash
  python -m garak --model_type huggingface \
    --model_name gpt2 --probes encoding
  ```
]

#section-slide(title: "Defending Against AI-Enhanced Attacks")

#slide(title: "What Shifts, and the Mapping")[
  #split(
    [
      *What shifts*
      - Personalisation is free
      - Voice/video identity unreliable
      - Attacker triage is faster
      - Entry bar is lower
      - You now run AI systems too

      Unchanged: unpatched services,
      flat networks, reused creds.
    ],
    image("../lectures/images/attack-to-control.svg", width: 98%),
  )
]

#slide(title: "Identity: Make Credentials Unphishable")[
  - *FIDO2 / passkeys* bind auth to the origin: a cloned page is useless
    - The single highest-value control against polished phishing
  - *Push MFA is not equivalent:* fatigue and relay; use number matching
  - *Conditional access* on device and location
  - *Short sessions and token binding* limit a stolen cookie
]

#slide(title: "Process and Detection")[
  #split(
    [
      *Process*
      - Second approver, independent channel
      - Call-back to a directory number
      - Blame-free "this call was fake"
      - Help-desk checks not based on voice
    ],
    [
      *Detection (behaviour)*
      - Look-alike domains, SPF/DKIM/DMARC
      - DMARC `p=reject` on your domains
      - Impossible-travel signals
      - Mass file reads, odd egress
    ],
  )

  AI detectors are unreliable: invest in *provenance* (C2PA), not detection.
]

#slide(title: "Rewrite the Awareness Training")[
  #table(
    columns: (1fr, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Remove*], [*Replace with*],
    [Spot spelling mistakes], [Look at what is being asked for],
    [Generic greetings are suspicious], [Unexpected asks are, however well written],
    [You will recognise colleagues], [Verify out-of-band for anything irreversible],
    [Annual slide deck], [Short, frequent, role-specific drills],
  )

  Measure the *reporting* rate, not just the click rate.
]

#slide(title: "Securing Your Own AI Systems")[
  - *Scope the tools:* narrowest actions, each least-privileged
  - *Authorization outside the model,* in code, on the caller's identity
  - *Human approval* for irreversible actions
  - *Treat output as untrusted:* encode before rendering
  - *Segregate retrieved content;* rate limits and budgets
  - *Log everything;* govern the supply chain; red-team it
]

#slide(title: "Synthetic-Media Fraud: First Hour")[
  1. *Stop the transaction* (outranks investigation)
  2. *Preserve evidence:* records, metadata, headers, logs
  3. *Verify through the real person* on a known channel
  4. *Report;* mind the GDPR breach clock
  5. *Communicate without blame*
  6. *Fix the process, not the person*
]

#standout-slide(title: [AI changes cost and scale, not the vulnerabilities, the controls, or the law.])
