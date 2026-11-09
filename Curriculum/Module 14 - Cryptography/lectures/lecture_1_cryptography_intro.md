# What is Cryptography?

Cryptography is the science of protecting information so that only the intended parties can use it, even when the storage medium or the communication channel is controlled by someone else.
"Encryption" is the act of transforming plaintext into an unreadable version (the ciphertext), whereas "Decryption" converts the ciphertext back into its readable form.

Modern cryptography covers more than confidentiality: integrity (has the data been changed?) and authenticity (does it really come from the claimed sender?) are equally important goals.

## Terms

- **Encryption**: transforms readable data (plaintext) into an unreadable form (ciphertext) using an algorithm and a cryptographic key. Only a party holding the matching decryption key can get the plaintext back.

- **Decryption**: the reverse operation. It needs the matching algorithm and the corresponding cryptographic key, so only holders of that key can read the original data.

- **Hashing:**
  Hashing is a one-way process of converting data into a fixed-size string of characters, known as a hash value. It is designed to be irreversible, making it suitable for tasks like password storage and data integrity verification, where the focus is on comparing hash values rather than retrieving the original data.

- **Cryptographic vs Non-Cryptographic Hashing:**

  - Hashing algorithms are separated into two categories: cryptographic and non-cryptographic hashes.
  - Cryptographic hashing is used for ensuring data integrity and security. It transforms input data of any size into a fixed-size hash value using a mathematical algorithm, where the focus lies on making hash-collisions as improbable as possible.
  - Examples:
    - SHA-256
    - MD5 and SHA-1 were designed as cryptographic hashes, but practical collisions are known for both. Do not use them where collision resistance matters (signatures, certificates, deduplication of untrusted data).
  - Non-cryptographic hashing is used for various purposes such as hash tables, data indexing, and checksums. While it's generally faster, it offers no resistance against an attacker who deliberately constructs collisions.
  - Examples:
    - CityHash
    - xxHash

## Usecases

- **Symmetric:**
  As symmetric encryption is way faster than asymmetric encryption, it is more suitable for encrypting larger blocks of data.
  As it also requires less computational resources, it may be preferred when it comes to embedded systems & IoT devices.
- **Asymmetric:**
  Asymmetric encryption is often used in the initial phase of communication to establish a secure channel.
  This is because asymmetric encryption involves a pair of keys (public and private), and only the recipient's private key can decrypt the data encrypted with their public key.
  Asymmetric encryption can be used to create digital signatures, providing a way to verify the authenticity and integrity of a message or data.
  The private key is used to sign the data, whereas the public key is used to verify the signature.
  Asymmetric encryption is widely used in Public-Key-Infrastructure.
  It is a hierarchical system for issuing, distributing and verifying digital certificates.
  The topic "PKI" in particular will be discussed later on.
  - DH-Key Exchange:
    The Diffie-Hellman key exchange establishes a shared secret between two parties over a channel that an eavesdropper can read.
    Both sides agree on public parameters (a generator g and a modulus p). Each side then picks a *private* value which it never transmits, and sends only the value derived from it.
    Each side combines its own private value with the value received from the other side; both arrive at the same shared secret, which is then used as a key for symmetric encryption.

```text
  public parameters: g, p          (known to everyone, incl. attacker)

  Alice                                                   Bob
  picks secret a                                          picks secret b
        |                                                       |
        |------------------ sends g^a mod p ------------------->|
        |<----------------- sends g^b mod p --------------------|
        |                                                       |
  computes (g^b)^a                                        computes (g^a)^b
        \______________ same shared secret g^ab ______________/

  The attacker sees g, p, g^a and g^b -- but deriving a or b from
  them is the discrete logarithm problem, which is hard for large p.
```

Plain Diffie-Hellman provides no authentication: it protects against passive eavesdropping, but an active attacker in the middle can run one exchange with each side. Protocols such as TLS therefore combine it with certificates or signatures.
