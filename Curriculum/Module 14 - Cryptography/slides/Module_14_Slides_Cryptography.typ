#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 14: Cryptography],
    subtitle: [Encryption, Hashing, Signatures and Attacks],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 14 - Cryptography],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "What Is Cryptography?")[
  - The science of protecting information from everyone but
    #linebreak() the intended parties
  - *Encryption:* plaintext to unreadable ciphertext
  - *Decryption:* ciphertext back to plaintext

  #cblock(title: [More than confidentiality])[
    Modern cryptography also provides *integrity* (unchanged?) and
    *authenticity* (really from the sender?).
  ]
]

#slide(title: "Key Terms")[
  - *Encryption:* algorithm + key turn plaintext into ciphertext
  - *Decryption:* the reverse, needs the matching key
  - *Hashing:* one-way, fixed-size output, irreversible by design
    #linebreak() used for password storage and integrity checks
]

#slide(title: "Cryptographic vs. Non-Cryptographic Hashes")[
  #table(
    columns: (auto, 1fr),
    table.header([*Kind*], [*Purpose*]),
    [Cryptographic], [Integrity and security; collisions made
    infeasible. e.g. SHA-256],
    [Non-cryptographic], [Hash tables, checksums; faster, no
    collision resistance. e.g. xxHash, CityHash],
  )

  #cblock(title: [Do not use], color: red.darken(20%))[
    MD5 and SHA-1 have practical collisions. Avoid where collision
    resistance matters.
  ]
]

#slide(title: "Symmetric vs. Asymmetric Use")[
  - *Symmetric:* fast, cheap; suits large data, embedded and IoT
  - *Asymmetric:* a key *pair*; used to set up a secure channel
    #linebreak() and to create digital signatures
  - In practice they are combined (*hybrid encryption*)
]

#section-slide(title: "Symmetric Cryptography")

#slide(title: "One Shared Key")[
  - A single key both encrypts and decrypts
  - Any bit string of the right length works, but it must come
    #linebreak() from a cryptographic RNG, or a KDF (Argon2, scrypt, PBKDF2)
  - Everyone who knows the key can read the messages

  #cblock(title: [The central problem])[
    The key has to reach the other side *before* communication can start.
    (See Diffie-Hellman.)
  ]
]

#slide(title: "Why an IV or Nonce?")[
  - Many modes chain blocks: block n needs block n-1
  - The *IV* seeds the very first block
  - Without it, equal plaintext gives equal ciphertext -- a leak
  - An IV / nonce is *not secret*; it travels with the ciphertext

  - CBC IV must be *unpredictable* (random)
  - CTR / GCM nonce need only be *unique* (may be a counter)
]

#slide(title: "Nonce Reuse Is Catastrophic")[
  #cblock(title: [Never reuse a nonce with the same key], color: red.darken(20%))[
    In CTR / GCM the attacker gets the XOR of the two plaintexts, and for
    GCM it also breaks the authentication.
  ]
]

#slide(title: "Block vs. Stream Ciphers")[
  #split(
    [
      *Block cipher*
      - Fixed block size (AES: 16 B)
      - Plaintext must be padded
      - Mode decides security
      - e.g. AES, Blowfish
    ],
    [
      *Stream cipher*
      - Keystream XORed byte-by-byte
      - No padding needed
      - e.g. ChaCha20
      - AES-CTR: a block cipher run as a stream
    ],
  )

  Neither category is inherently "weak" or "strong".
]

#slide(title: "ECB Leaks Structure")[
  #split(
    [
      - ECB encrypts each block independently
      - Equal blocks give equal ciphertext
      - The plaintext structure stays visible
      - *Do not use ECB*
    ],
    [
      #align(center)[
        plain / ECB / secure
        #linebreak()
        #box(image("../resources/images/Plain.png", height: 5cm))
        #box(image("../resources/images/ECB.png", height: 5cm))
        #box(image("../resources/images/Secure.png", height: 5cm))
      ]
    ],
  )
]

#slide(title: "Modes of Operation")[
  - *CTR:* parallel, random access; a bit flip flips one plaintext bit
  - *CFB:* self-synchronising; sequential encryption
  - *CBC:* general purpose, but only safe *with a MAC*; sequential

  #cblock(title: [None of these detect modification], color: red.darken(20%))[
    Integrity needs a MAC or an authenticated mode.
  ]
]

#slide(title: "Best Practice")[
  - Use an *authenticated* (AEAD) mode: AES-GCM or ChaCha20-Poly1305
  - If forced to use CBC/CTR/CFB, add an HMAC and verify it first
  - AES-128 is secure; AES-256 adds margin
  - Never reuse an IV / nonce with the same key
  - Do not roll your own; use a reviewed library

  #cblock(title: [Birthday bound])[
    64-bit block ciphers (3DES, Blowfish) collide near 32 GB -- the Sweet32
    attack. AES-128 blocks are not a practical concern.
  ]
]

#section-slide(title: "Asymmetric Cryptography")

#slide(title: "Two Related Keys")[
  - *Public key:* encrypts; shared with everyone
  - *Private key:* decrypts; kept secret
  - The pair is mathematically related, generated together

  To send to Bob: encrypt with Bob's public key; only Bob's private key
  decrypts it.
]

#slide(title: "Hybrid Encryption")[
  - Asymmetric is slow and limited to data smaller than the key
  - So it is not used on the message itself:
    + generate a random *symmetric* key
    + encrypt the message symmetrically
    + encrypt only that key asymmetrically

  This is what TLS, PGP and similar protocols do.
]

#slide(title: "RSA in Brief")[
  - Keygen: pick primes $p, q$; $N = p dot q$; $phi(N)=(p-1)(q-1)$
  - Choose $e$, compute $d$ with $e dot d equiv 1 space (mod space phi(N))$
  - Public key $(e, N)$, private key $(d, N)$
  - Encrypt $c = m^e mod N$; decrypt $m = c^d mod N$

  #cblock(title: [Textbook RSA is not secure], color: red.darken(20%))[
    It is deterministic. Real use adds padding: OAEP for encryption, PSS for
    signatures.
  ]
]

#slide(title: "Diffie-Hellman Key Exchange")[
  ```text
  public parameters: g, p     (known to everyone)

  Alice               Bob
  secret a            secret b
     |------ g^a mod p ----->|
     |<----- g^b mod p ------|
  (g^b)^a   ==shared==   (g^a)^b
  ```

  - Attacker sees $g, p, g^a, g^b$ -- recovering $a$ needs the discrete log
  - Plain DH has *no authentication*; TLS adds certificates
]

#slide(title: "Digital Signatures")[
  - Roles swap: sign with the *private* key, verify with the *public* key
  - Only a *hash* of the data is signed, so it stays fast
  - Valid signature = data unchanged and from the key owner

  #cblock(title: [Not "encryption with the private key"])[
    RSA-PSS, ECDSA and Ed25519 have no encryption step; ECDSA/Ed25519 cannot
    encrypt at all.
  ]
]

#slide(title: "HMAC vs. Signatures")[
  - *HMAC:* a *shared secret*, message + secret hashed into a tag
  - Receiver recomputes the tag and compares
  - Detects tampering, but proves nothing to a *third party*
    #linebreak() (both sides know the secret)

  A real signature gives *non-repudiation*; an HMAC does not.
]

#slide(title: "Public Key Infrastructure (PKI)")[
  - A certificate: a CA's signed statement that a public key
    #linebreak() belongs to an entity
  - Solves "a public key alone says nothing about its owner"
  - *Registration Authority:* verifies identity, forwards the CSR
  - *Certificate Authority:* issues the certificate
  - *Validation Authority:* publishes status via CRL or OCSP
]

#slide(title: "PKI in Practice")[
  - *Code signing:* Windows warns on an unknown publisher
    #linebreak() a certificate proves who released the program (can be costly)
  - *HTTPS certificates:* encrypt traffic, verify site ownership
    #linebreak() easy and free, e.g. Let's Encrypt
]

#section-slide(title: "Cryptographic Attacks")

#slide(title: "Keys vs. Passwords")[
  #cblock(title: [One distinction runs through everything])[
    A *key* from an RNG is attacked by trying the whole key space.
    A *password* chosen by a human is attacked by trying likely candidates
    first -- far cheaper.
  ]
]

#slide(title: "Brute Force and Dictionary")[
  - *Brute force:* try every combination; $A^n$ for alphabet $A$,
    #linebreak() length $n$. Each added character multiplies effort by $A$
  - Short keys fall in hours; long keys are out of reach
  - *Dictionary:* iterate likely candidates from breach wordlists,
    #linebreak() with rules applied (append digits, letter swaps)

  Predictability beats length: a long but guessable password falls quickly.
]

#slide(title: "Rainbow Tables")[
  - Precomputed tables mapping inputs to hash values
  - Store only chain start/end, recompute on lookup
    #linebreak() -- a time-memory trade-off
  - Less compute at attack time, less storage than a full table

  #cblock(title: [Defence: salt])[
    A random value *per password*, stored next to the hash. No two users
    share a precomputation, so any table is useless.
  ]
]

#slide(title: "Salting Is Not Enough")[
  - A salt stops precomputation; it does not slow a single guess
  - SHA-256, even salted, runs billions of times/sec on a GPU
  - Use a deliberately *slow* KDF: Argon2, scrypt or bcrypt
    #linebreak() (Argon2 and scrypt are additionally memory-hard)
]

#slide(title: "Side-Channel Attacks")[
  - Exploit information leaked during execution:
    #linebreak() timing, power consumption, electromagnetic radiation
  - Analysing the leak can reveal the key
  - Defence: explicit countermeasures, e.g. *constant-time* algorithms
]

#standout-slide(title: [Don't design your own cryptography.
Use reviewed libraries, authenticated modes, and slow KDFs for passwords.])
