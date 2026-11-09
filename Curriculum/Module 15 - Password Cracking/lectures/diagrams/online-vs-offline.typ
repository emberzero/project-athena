#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (14mm, 9mm),
    dbad((1, 0), [attacker]),

    dbox((0, 1), [login service\ #text(size: 7pt)[rate limit, lockout,\ MFA, logging]], fill: fill-ok),
    dbox((2, 1), [stolen hash file\ #text(size: 7pt)[no limits,\ no logging]], fill: fill-danger),

    edge((1, 0), (0, 1), "->", label: text(size: 7.5pt)[online]),
    edge((1, 0), (2, 1), "->", label: text(size: 7.5pt)[offline]),

    dbox((0, 2), [guesses per second\ bounded by defender]),
    dbox((2, 2), [guesses per second\ bounded by hardware]),
    edge((0, 1), (0, 2), "->"),
    edge((2, 1), (2, 2), "->"),
  )

  #block(width: 100mm)[#dnote[
    The two attack positions have almost nothing in common. Online guessing
    is slow and noisy and is stopped by throttling and MFA. Offline cracking
    is fast and invisible, and only the choice of KDF and the strength of the
    password itself still defend the account.
  ]]
]
