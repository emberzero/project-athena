#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (4mm, 8mm),
    dgood((0, 0), [*1. Do not rely on the password alone*\ #text(size: 7.5pt)[MFA, passkeys, SSO]], width: 72mm),
    dgood((0, 1), [*2. Keep weak passwords out*\ #text(size: 7.5pt)[length minimum, breach blocklist, no forced rotation]], width: 72mm),
    dgood((0, 2), [*3. Make online guessing unprofitable*\ #text(size: 7.5pt)[throttling, backoff, logging and alerting]], width: 72mm),
    dgood((0, 3), [*4. Make offline cracking expensive*\ #text(size: 7.5pt)[Argon2id / scrypt / bcrypt, per-user salt, tuned cost]], width: 72mm),
    dbox((0, 4), [*5. Limit the damage of a leak*\ #text(size: 7.5pt)[no password reuse, scoped credentials, fast rotation on breach]], width: 72mm, fill: fill-neutral),
  )

  #block(width: 100mm)[#dnote[
    Each layer assumes the one above it has already failed. A control that
    only works while the hash file stays secret is not a layer.
  ]]
]
