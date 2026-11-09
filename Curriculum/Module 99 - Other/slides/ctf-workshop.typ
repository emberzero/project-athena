#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Teachertraining],
    subtitle: [Using CTFs in Cybersecurity Classes],
    authors: [*Marcel Schnideritsch*],
    footer: [Project Athena - CTF Workshop],
    extra: [],
  ),
)

#title-slide()

#slide(title: "$: whoami")[
  #image("image.png")
]

// Agenda
#slide(title: "Workshop Agenda")[
  1. Introduction & Discussion
  2. What Are CTFs?
  3. Tools for CTFs
  4. CTF Platforms
  5. Hands-On with CyberLeague
  6. Wrap-Up & Resources
]

// Section 1: Intro & Discussion
#section-slide(title: "Introduction & Discussion")

#slide(title: "Warm-Up Question")[
  #set text(size: 22pt)

  #align(center)[
    *Do you already use CTFs in your teaching?*

    #v(2em)

    If yes, how?
  ]

  #v(2em)

  Let's collect:
  - Current methods
  - Pain points
  - Expectations for today
]

// Section 2: What Are CTFs?
#section-slide(title: "What Are CTFs?")

#slide(title: "CTF Definition")[
  #color-block(
    title: [CTF],
    [
      Capture the Flag (CTF) is a special kind of information security competitions. CTF games often touch on many aspects of information security: cryptography, stego, binary analysis, reverse engeneering, mobile security and others.
    ],
  )
]

#slide(title: "CTF Types")[
  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    [
      *Jeopardy Style*
      - Individual challenges
      - Categories: Web, Crypto, Pwn, Forensics
      - Points-based scoring
      - Most common in education
    ],
    [
      *Attack/Defense*
      - Team-based
      - Maintain services while attacking others
      - Real-time competition
      - Advanced level
    ],
  )
]

#slide(title: "Learning Benefits")[
  - *Active Learning*
    - Hands-on problem solving
    - Learning by doing

  - *Competency-Based Teaching*
    - Clear skill demonstration
    - Measurable progress

  - *Discovery-Driven Learning*
    - Exploration and experimentation
    - Creative thinking
]

#slide(title: "Gamification Elements")[
  *Why students engage with CTFs:*

  #v(2em)

  #grid(
    columns: (auto, 1fr),
    gutter: 1em,
    row-gutter: 1em,
    [🎯], [*Clear Goals* – Find the flag, earn points],
    [📊], [*Immediate Feedback* – Right or wrong, instant response],
    [🏆], [*Competition & Collaboration* – Scoreboards and teamwork],
    [🔄], [*Safe Failure* – Experiment without real-world consequences],
    [⚡], [*Motivation* – Challenging, rewarding, progressive],
  )
]

#slide(title: "CTFs in Cybersecurity Education")[


  *Why CTFs belong in the classroom:*

  - Bridge theory and practice
  - Develop problem-solving skills
  - Build technical toolbox
  - Encourage autonomous learning
  - Simulate real-world scenarios
  - Measurable learning outcomes

  #v(2em)

  #color-block(
    [
      CTFs transform passive learners into active security practitioners
    ],
  )
]

#slide(title: "CTF Learning Cycle")[
  #align(center)[
    #image("../figures/ctf_flow.png")
  ]
]

// Section 3: Tools
#section-slide(title: "Tools Every CTF Player Should Know")

#slide(title: "Networking & Basic Tools")[
  #set text(size: 15pt)


  *Essential network utilities:*

  - *netcat* – Network Swiss Army knife
  - *nmap* – Network scanner
  - *Wireshark* – Packet analyzer
  - *curl* – HTTP client

  #v(1em)

  *Example: Netcat basics*
  ```bash
  # Listen on port 1234
  nc -lvnp 1234

  # Connect to a service
  nc example.com 80

  # Send HTTP request
  echo -e "GET / HTTP/1.0\r\n\r\n" | nc example.com 80
  ```
]

#slide(title: "Web / AppSec Tools")[


  *Web security toolkit:*

  - *Burp Suite* – Intercept and modify HTTP traffic
  - *Browser DevTools* – Inspect, debug, modify
  - *Postman / HTTPie* – API testing
  - *SQLMap* – Automated SQL injection

  #v(1em)

  *Example: Burp Suite workflow*
  ```
  1. Configure browser proxy (127.0.0.1:8080)
  2. Intercept requests
  3. Modify parameters, headers, cookies
  4. Observe responses
  5. Use Repeater for testing
  ```
]

#slide(title: "Reverse Engineering Tools")[


  *Binary analysis tools:*

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    [
      *Disassemblers:*
      - Ghidra (NSA, free)
      - IDA Free
      - radare2 / Cutter

      *Basic utilities:*
      - `strings` – Extract text
      - `file` – Identify file type
      - `ltrace` / `strace` – Trace calls
    ],
    [
      *Example: Basic analysis*
      ```bash
      # Check file type
      file binary

      # Extract strings
      strings binary | grep flag

      # Run in Ghidra
      ghidra binary
      ```

      #v(1em)
    ],
  )
]

#slide(title: "Crypto & Misc Tools")[
  *Cryptography and general tools:*

  - *CyberChef* – The cyber Swiss Army knife (web-based)
  - *Hashcat* – Password cracking
  - *John the Ripper* – Hash cracking
  - *Python* – Scripting everything
]

#slide(title: "Scripting with Python")[
  *Example: Python brute force pattern*
  ```python
  import requests

  for pin in range(10000):
      payload = {'pin': f'{pin:04d}'}
      r = requests.post('http://target.com/check', data=payload)

      if 'success' in r.text:
          print(f'Found: {pin:04d}')
          break
  ```
]

#slide(title: "CyberChef Example")[
  *CyberChef – Decode, decode, decode*

  Common recipes:
  - Base64 decode
  - ROT13 / Caesar cipher
  - XOR brute force
  - Extract files from data
  - Analyze hashes

  #v(1em)

  🔗 *gchq.github.io/CyberChef*
]

// Section 4: Platforms
#section-slide(title: "CTF Platforms for Education")

#slide(title: "Popular Public Platforms")[
  *Global platforms:*

  - *picoCTF* – Beginner-friendly, CMU-hosted
  - *HackTheBox* – Realistic machines, certification paths
  - *TryHackMe* – Guided learning paths, very gamified
  - *pwn.college* – Academic, ASU-hosted

  #v(1em)

  *Austrian & Regional:*

  - CyberLeague 24/7 (ctf.cyberleague.at)
  - NodeZero SchoolCTF
  - _Coming Soon_: NodeZero Cyberskills
  - FuzzyLand (fuzzy.land)
]

#slide(title: "Choosing the Right Platform")[


  *Consider:*

  #grid(
    columns: (auto, 1fr),
    gutter: 1em,
    row-gutter: 0.8em,

    [📚], [*Curriculum alignment* – Does it match your topics?],
    [👥], [*Student level* – Beginner, intermediate, advanced?],
    [🎓], [*Teacher tools* – Progress tracking, class management?],
    [💰], [*Cost* – Free, freemium, or paid?],
    [🌍], [*Language* – English, German, localized?],
    [🔒], [*Privacy* – GDPR, student data protection?],
  )
]

// Section 5: Hands-On
#section-slide(title: "Hands-On with CyberLeague")

#slide(title: "CyberLeague Overview")[
  *What is CyberLeague?*

  - Austrian CTF platform
  - Hosted at *ctf.cyberleague.at*
]

#slide(title: "Getting Started")[


  *Step-by-step:*

  1. Visit *ctf.cyberleague.at*
  2. Create account
  3. Browse challenge categories
  4. Select a challenge
  5. Read description carefully
  6. Submit flag
  7. Check scoreboard

  #v(2em)

  #align(center)[
    *Let's do this together now!*
  ]
]

#slide(title: "Challenge Categories")[


  *Typical CyberLeague categories:*

  #grid(
    columns: (1fr, 1fr),
    gutter: 2em,
    [
      - *Web* – XSS, SQLi, CSRF
      - *Crypto* – Classic ciphers, modern crypto
      - *Pwn* – Buffer overflows, exploits
      - *Reverse Engineering* – Disassembly, patching
    ],
    [
      - *Forensics* – File analysis, memory dumps
      - *Misc* – Logic puzzles, OSINT
      - *Networking* – Packet analysis, protocols
      - *Steganography* – Hidden messages
    ],
  )

  #v(1em)

  *Recommended start:* Web, Crypto, Misc (usually easier entry points)
]

#slide(title: "Teacher Use Cases")[
  #set text(size: 18pt)

  1. *Weekly Assignments*
    - Assign 2–3 challenges per week
    - Match curriculum topics (Web security week → Web challenges)

  2. *Class Competitions*
    - Host internal CTF events
    - Group or individual scoring

  3. *Progress Tracking*
    - Identify struggling students early

  4. *Extra Credit*
    - Bonus points for challenge solves
    - Motivates self-directed learning
]

#slide(title: "Live Demo Time")[
  #set text(size: 24pt)

  #align(center + horizon)[
    *Let's solve a challenge together!*

    #v(2em)

    👨‍💻 → 🔍 → 💡 → 🏁

    #v(2em)

    _Instructor-led walkthrough_
  ]
]

// Section 6: Wrap-Up
#section-slide(title: "Wrap-Up & Resources")

#slide(title: "Benefits Summary")[


  *Why integrate CTFs into your teaching?*

  ✅ *Engagement* – Students love the gamification

  ✅ *Skill Development* – Practical, hands-on learning

  ✅ *Autonomous Learning* – Self-paced exploration

  ✅ *Real-World Relevance* – Industry-aligned skills

  ✅ *Assessment* – Clear, measurable outcomes

  ✅ *Scalability* – Works for 10 or 100 students
]

#slide(title: "Best Practices Checklist")[
  #set text(size: 18pt)


  *For teachers implementing CTFs:*

  - [ ] Start with beginner-friendly platforms (picoCTF, CyberLeague)
  - [ ] Align challenges with curriculum topics
  - [ ] Provide time in class for exploration
  - [ ] Offer hints but encourage struggle
  - [ ] Celebrate first solves and creative solutions
  - [ ] Mix individual and team challenges
  - [ ] Debrief challenges: discuss methods and tools
  - [ ] Gradually increase difficulty
  - [ ] Monitor student progress and frustration levels
  - [ ] Connect CTF skills to real-world scenarios
]

#slide(title: "Common Pitfalls to Avoid")[


  ⚠️ *Watch out for:*

  - *Too difficult too soon* – Build confidence first
  - *No guidance* – Provide scaffolding for beginners
  - *Grading pressure* – CTFs should be low-stakes initially
  - *Isolation* – Encourage collaboration and discussion
  - *Tool overload* – Introduce tools gradually
  - *Ignoring frustration* – Check in with struggling students
]

#slide(title: "Resource Links")[
  #set text(size: 18pt)
  *Platforms:*
  - CyberLeague: #link("https://ctf.cyberleague.at")[ctf.cyberleague.at]
  - picoCTF: #link("https://picoctf.org")[picoctf.org]
  - TryHackMe: #link("https://tryhackme.com")[tryhackme.com]
  - HackTheBox: #link("https://hackthebox.com")[hackthebox.com]

  *Tools:*
  - CyberChef: #link("https://gchq.github.io/CyberChef")[gchq.github.io/CyberChef]
  - Ghidra: #link("https://ghidra-sre.org")[ghidra-sre.org]
  - Burp Suite: #link("https://portswigger.net/burp/communitydownload")[portswigger.net/burp]

  *Learning Resources:*
  - CTF Field Guide: #link("https://trailofbits.github.io/ctf")[trailofbits.github.io/ctf]
  - CTF101: #link("https://ctf101.org")[ctf101.org]
]

#slide(title: "Q&A and Discussion")[
  #set text(size: 22pt)

  #align(center + horizon)[
    *Questions?*

    #v(2em)

    💬 Let's discuss!

    #v(3em)

    *Contact:*

    Marcel Schnideritsch

    NodeZero

    marcel\@nodezero.at
  ]
]
