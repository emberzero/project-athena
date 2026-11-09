# Assignment 1: Build It, Break It, Verify It

## Objective

You will use real cryptographic tooling on files you create yourself: show why ECB leaks, break a
ciphertext whose nonce was reused, run your own certificate authority and sign with it, and measure how
much a salt and a slow key derivation function actually cost an attacker. Afterwards you will be able to
pick a mode and a hash for a given job and defend the choice with numbers you produced yourself.

## Logistics

- **Work:** individual, or in pairs. Pairs submit one report and name who did which task.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module14_Assignment1.pdf`.
- Every file you encrypt, sign or hash must be one you made and that contains your own name. Generic
  sample files, or key material and hashes identical to another student's, earn no marks.

## Setup

Everything is free and already on most systems.

- The `openssl` command line tool. Preinstalled on Linux and macOS; on Windows use WSL or Git Bash.
- Python 3 for the short scripts in Task 2. Only the standard library plus `pillow` for the image task.
- A password cracking tool for Task 4: John the Ripper or hashcat. Both are free and open source, and
  both ship with Kali. A CPU is enough here; no GPU is required.
- A wordlist. Your instructor will name the one to use so that everyone's numbers are comparable.
- No paid service, no hardware, no cloud account is needed for any task.

Work in one directory and keep every file you produce. You will be asked for several of them.

## Rules of engagement

- Everything you encrypt, sign, hash or crack in this assignment is **yours**: your own files, your own
  keys, your own passwords, your own test certificate authority.
- Do not attack, crack or decrypt anything belonging to anyone else: no leaked hash dumps, no school
  accounts, no classmates' submissions, no certificate or key you did not generate. Cracking someone
  else's credentials is not an exercise, it falls under StGB **§118a** and **§126a**; Module 01 covers
  the detail.
- Your test CA is for this report only. Never install it into a browser or system trust store.

## 1. Symmetric modes, and what they leak

1. Take a photograph or drawing of your own, at least 400 by 400 pixels, with a large area of flat
   colour in it. Convert it to raw bitmap data, encrypt the pixel data with AES in **ECB** and again in
   **CBC**, then write both results back as viewable images.
1. Show all three images side by side and explain, in terms of how the two modes handle a block, why the
   shape is still visible in one and not in the other. Do not simply restate the lecture: point at the
   flat area in **your** image and say what an attacker learns from it.
1. Encrypt a short text file containing your full name twice with the same key, once in CBC with a fresh
   random IV each time and once in ECB. Paste both pairs of ciphertexts as hex and say which pair
   differs and why.
1. Take the CBC ciphertext, flip a single bit in the middle of it, and decrypt. Show the damaged
   plaintext and describe exactly which parts of it changed. Then do the same with an AES-GCM
   ciphertext and show what GCM does instead.
1. Conclude with one short paragraph: for storing a 2 GB backup file, which mode do you pick and what
   else do you need alongside it?

**Deliverable:** the three images, the four ciphertexts in hex, the two bit-flip results, and the
paragraph.

## 2. Breaking a reused nonce

The lecture says reusing a nonce in a stream mode is catastrophic. Prove it.

1. Write a short Python script that encrypts two different plaintexts with AES-CTR using the **same key
   and the same nonce**. One plaintext must contain your full name; the other must be a sentence of your
   choice of similar length.
1. Assume you are an attacker who has both ciphertexts and neither the key nor the nonce. Show that
   XORing the two ciphertexts gives the XOR of the two plaintexts.
1. Now recover the second plaintext completely, given that you know the first one. Show the recovered
   bytes and the code that did it.
1. Explain in three or four sentences why no amount of key length helps here, and what the correct fix
   is. State explicitly how a CBC IV and a CTR nonce differ in what they must guarantee.

**Deliverable:** the script, the two ciphertexts, the recovered plaintext, and the explanation.

## 3. Signatures and your own PKI

1. Generate an RSA key pair of at least 2048 bit, or an Ed25519 key pair. Print the public key and its
   fingerprint and include both. Keep the private key out of your report.
1. Write a short statement file containing your name, the date and one sentence. Sign it, verify the
   signature, then change one character in the statement and verify again. Show the success and the
   failure output.
1. Explain what the verification actually proved and what it did not. In particular: what does a valid
   signature tell a reader who has never met you?
1. Now build a two-level PKI with `openssl`:
   - create a self-signed root CA certificate of your own, named after you;
   - create a key and a certificate signing request for a server called `www.<yourlastname>.local`;
   - sign that CSR with your root CA;
   - verify the resulting chain against your root and include the output.
1. Map what you just did onto the PKI roles from the lecture. Which role did you play at each step, and
   which role did you **skip entirely**? Say what a real CA does at that step and what goes wrong
   without it.
1. Name one way your leaf certificate could have to be distrusted before it expires, and the two
   mechanisms from the lecture by which a client would learn about it.

**Deliverable:** public key and fingerprint, signature verify success and failure output, the chain
verification output, the role mapping including the skipped role, and the revocation paragraph.

## 4. What a salt and a KDF are worth

1. Choose four passwords and use them for nothing else ever. Two of them must be the kind of password a
   person actually picks, including a word from the wordlist with digits or symbol substitutions; two
   must be long and randomly generated. Record all four in your report, since this is a lab.
1. Produce, for each password, three hashes: unsalted SHA-256, SHA-256 with a random per-password salt,
   and bcrypt or Argon2.
1. Attack your own hashes with your cracking tool and the given wordlist, with rules enabled. Fill in
   this table:

   | Password (which kind) | Scheme | Cracked? | Time to crack | Guess rate reported by the tool |
   | --- | --- | --- | --- | --- |

   Cap each run at a time limit your instructor sets and record a run that hit the cap as "not cracked
   within N minutes" together with its guess rate. The rate matters more than the outcome.
1. Answer from your own numbers, not from the lecture:
   - Which cost more: adding the salt, or switching to bcrypt or Argon2? By roughly what factor?
   - Your long random password survived every scheme. What exactly protected it, and would it still be
     safe if stored as unsalted SHA-256 in a breached database?
   - A rainbow table for SHA-256 is available for download. Which of your hashes does it threaten, and
     why are the others immune?
1. One short paragraph: you are storing passwords for a new web application. State what you store per
   user, which function and which parameters, and why.

**Deliverable:** the four passwords, the twelve hashes, the completed table with real timings and rates,
the four answers, and the storage recommendation.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Symmetric modes** | 25% | All three images produced from your own picture, the ciphertext pairs correct and correctly explained, both bit-flip results shown with an accurate account of which blocks changed and of what GCM did, and a defensible mode choice. |
| **Nonce reuse** | 20% | Working script, the XOR relationship demonstrated, the second plaintext fully recovered, and a correct account of the IV-versus-nonce requirement. |
| **Signatures and PKI** | 25% | Key and fingerprint included, verify success and failure both shown, chain verifying against your own root, the skipped PKI role named with its consequence, and a correct revocation answer. |
| **Hashing and cracking** | 20% | Twelve hashes, a complete table with real measured times and guess rates, and four answers argued from your own measurements rather than from the lecture. |
| **Report quality** | 10% | Commands reproducible as written, outputs pasted rather than paraphrased, your own files and name throughout, clear structure. |
| **Bonus** | +20% | See below. |

A table of plausible numbers that your commands could not have produced is graded as not submitted.
Keep your working directory until the assignment is marked, in case you are asked to rerun a step.

## Bonus: go and break something harder

Pick **one**.

- **CryptoHack.** Solve the challenges your instructor assigns on <https://cryptohack.org>. Include a
  screenshot of your own profile showing them solved, and for each one a short write-up: what the
  underlying weakness was, which lecture topic it belongs to, and the code or steps you used. Solutions
  copied from a write-up site earn nothing; your explanation is what is graded.
- **Padding oracle.** Write a small server-side function of your own that decrypts AES-CBC and reports
  padding errors separately from other errors. Then write the client that recovers a plaintext block
  from it without the key. Explain which single line of your server made the attack possible and show
  the fixed version.
