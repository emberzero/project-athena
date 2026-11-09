#import "/utils/athena-diagram.typ": *

// Offline password cracking: what the attacker repeats per candidate, and
// where the defender's cost factor sits in that loop.

#diagram-page[
  #diagram(
    spacing: (9mm, 9mm),

    dbox((0, 0), [Wordlist\ entry]),
    dbox((1, 0), [Mangling\ rules]),
    dbad((2, 0), [Candidate\ password]),

    edge((0, 0), (1, 0), "->"),
    edge((1, 0), (2, 0), "->"),

    dgood((2, 1), [KDF\ salt + cost factor]),
    edge((2, 0), (2, 1), "->"),

    dbox((1, 2), [Computed\ digest]),
    dbox((0, 2), [Stolen\ digest]),
    edge((2, 1), (1, 2), "->"),
    edge((1, 2), (0, 2), "<->", label: [equal?], label-side: right),

    edge((0, 2), (0, 0), "->", label: [no: next candidate], label-side: left, bend: -35deg),
  )

  #block(width: 92mm, dnote[
    Red = attacker-controlled, green = the only step the defender controls.
    A fast digest (MD5, unsalted SHA-1) makes the loop cheap. A slow,
    per-user-salted KDF (bcrypt, scrypt, Argon2) makes it expensive and
    removes the shared-digest shortcut.
  ])
]
