# Symmetric Cryptography

- For symmetric encryption, there exists one single key for encrypting & decrypting data. Unlike an asymmetric keypair, the key is not bound to any mathematical structure: any bit string of the required length works - but it has to come from a cryptographic random number generator, or be derived from a password with a key derivation function such as Argon2, scrypt or PBKDF2.

For instance, let there be Person A (Alice) and Person B (Bob).
Alice wants to send an encrypted message to Bob.
Alice uses the shared key for encrypting the message, whereas Bob uses the same shared key for decrypting the message.
Everyone aware of the shared key can encrypt & decrypt sent messages.
This is also the central problem of symmetric encryption: the key has to reach the other side over some channel before any encrypted communication can start (see the Diffie-Hellman key exchange).

For many block cipher modes, an IV (initialization vector) needs to be provided as well. There's a simple reason for that:
In several modes, blocks depend on each other, meaning block n cannot be en- or decrypted without having block (n-1).
In order to provide a dependency for the very first block, an IV is used.
Without it, encrypting the same plaintext twice under the same key would produce the same ciphertext twice, which already leaks information.

```text
  CBC (Cipher Block Chaining): the IV seeds the chain

   block 1            block 2            block 3
      IV                 C1                 C2    <- mixed in from
       |                  |                  |       the block before
       v                  v                  v
   P1 (XOR)           P2 (XOR)           P3 (XOR)
       |                  |                  |
       v                  v                  v
     [E K]              [E K]              [E K]
       |                  |                  |
       v                  v                  v
       C1                 C2                 C3

  Equal plaintext blocks give different ciphertext blocks, but
  encryption cannot be parallelised: block n needs C(n-1) first.

  ECB (Electronic Code Book): no chaining at all

   P1                 P2                 P3
    |                  |                  |
    v                  v                  v
  [E K]              [E K]              [E K]
    |                  |                  |
    v                  v                  v
   C1                 C2                 C3

  Equal plaintext blocks always give equal ciphertext blocks, which
  leaks the structure of the plaintext (see the image comparison
  under Best Practice).
```

A related concept is the nonce (number used once). An IV and a nonce serve the same purpose - making every encryption under a given key unique - but the requirements differ:

- A CBC IV must be **unpredictable**, so it has to come from a cryptographic random number generator.
- A CTR or GCM nonce only has to be **unique**; it may be a counter. Reusing a nonce with the same key in these modes is catastrophic: the attacker gets the XOR of the two plaintexts, and for GCM it also breaks the authentication.

Neither an IV nor a nonce is secret - both are transmitted alongside the ciphertext.

## Block Ciphers

A block cipher encrypts data blockwise instead of byte by byte. In contrast to stream ciphers, it always operates on blocks of a fixed size (16 bytes for AES), so the plaintext has to be padded to a multiple of the block size.
A block cipher on its own only encrypts a single block. How a longer message is split up and chained together is decided by the **mode of operation**, and the mode is what determines whether the result is secure.
Depending on the mode, a ciphertext block can be dependent on the previous block (as in CBC) or independent of it (as in ECB, which is why ECB should not be used - more on that below).

- Examples of block ciphers:
  - AES (block size 16 bytes; key 128, 192 or 256 bit)
  - Blowfish (block size 8 bytes; see the note on the birthday bound below)
- Examples of modes used with them:
  - ECB \[Electronic Code Book Mode\]
  - CBC \[Cipher Block Chaining Mode\]

## Stream Ciphers

A stream cipher generates a keystream which is combined (usually XORed) with the plaintext byte by byte. There is no fixed block size, so no padding needs to be applied to the plaintext.

- Examples:
  - ChaCha20 (a true stream cipher)
  - AES in CTR \[Counter Mode\] - a block cipher operated as a stream cipher: AES encrypts a counter to produce the keystream, so the plaintext itself never enters the block cipher

## Comparison - Stream Cipher vs Block Cipher

The two categories are not "weak" and "strong". Both can be secure or broken; what matters is the concrete algorithm, the mode and the implementation.

- **Stream ciphers (and stream modes such as CTR):**
  - No padding, so the ciphertext is exactly as long as the plaintext, and no padding-related attacks apply.
  - Suited to data that arrives in small pieces or of unknown length.
  - Keystream reuse is fatal: encrypting two different plaintexts with the same key *and* the same nonce reveals the XOR of both plaintexts.
- **Block ciphers with a chaining mode (such as CBC):**
  - Operate on whole blocks, so the plaintext must be padded, and faulty padding checks lead to padding-oracle attacks.
  - CBC encryption is strictly sequential; decryption can be parallelised. CTR can be parallelised in both directions.
- **Both:** none of these modes detect modification of the ciphertext. Integrity needs a MAC or an authenticated mode (see Best Practice).

In the following, you can see the encryption process of CTR \[Counter Mode\] compared to CFB \[Cipher Feedback Mode\]. Both are stream-style modes built from a block cipher (here AES).

![CTR](../resources/images/CTR.bmp)

## Best Practice

- Use an **authenticated** mode (AEAD): AES-GCM or ChaCha20-Poly1305. These encrypt and authenticate in one step, so a modified ciphertext is rejected instead of decrypted into garbage.
- If you have to use an unauthenticated mode (CBC, CTR, CFB), add a MAC such as HMAC over the ciphertext and the IV, and verify it *before* decrypting.
- AES-128 is considered secure; AES-256 adds margin, but a longer key does not compensate for a weak mode, a reused nonce or a key derived from a password without a proper key derivation function.
- Never reuse an IV/nonce with the same key. Generate CBC IVs randomly; nonces may be counters.
- Do not design your own mode or implement the primitives yourself; use a reviewed library.

A quick overview about modes & their use-cases:

- CTR \[Counter Mode\]: Suitable in cases where parallel processing is a priority, and random access to the ciphertext is required. (Note on error propagation: a flipped ciphertext bit flips exactly the corresponding plaintext bit and nothing else - which is also why CTR without a MAC lets an attacker make targeted changes to the plaintext.)
- CFB \[Cipher Feedback Mode\]: Suitable for applications where a self-synchronizing stream cipher is beneficial. (Disadvantage: encryption is sequential, so it cannot be parallelised like CTR. A corrupted ciphertext block damages that block and the following one, after which the stream resynchronizes.)
- CBC \[Cipher Block Chaining Mode\]: A common general-purpose mode, but only safe together with a MAC. (Disadvantage: encryption is possible only sequentially; a corrupted ciphertext block destroys that block and flips the corresponding bits in the next one.)

ECB counts as insecure, as visible in the following comparison (left=plaintext, middle=ecb, right=cbc).
As each block is encrypted independently of its position, every block consisting of the same bytes results in the same encrypted counterpart, so the structure of the plaintext remains visible in the ciphertext.

<img src="../resources/images/Plain.png" alt="image" width="100" height="auto"/> <img src="../resources/images/ECB.png" alt="image" width="100" height="auto"/> <img src="../resources/images/Secure.png" alt="image" width="100" height="auto"/>

CBC (with a MAC) is acceptable for data encryption, but the amount of data encrypted under one key has to be limited. After roughly 2^(n/2) blocks, where n is the block size in bits, colliding ciphertext blocks become likely (the birthday bound), and a collision reveals the XOR of the two corresponding plaintext blocks.
For a 64-bit block cipher such as Blowfish or 3DES that limit is around 2^32 blocks (about 32 GB), which is reachable in practice - this is the basis of the Sweet32 attack. For AES with its 128-bit blocks the bound is 2^64 blocks and therefore not a practical concern.
