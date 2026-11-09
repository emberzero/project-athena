#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (10mm, 9mm),
    // Enrolment: password + salt -> KDF -> stored verifier
    dbox((0, 1), [password], fill: fill-warn),
    dbox((1, 1), [random\ salt]),
    dbox((2, 1), [KDF\ (cost c)], fill: fill-accent),
    dgood((3, 1), [store\ salt, c, h]),
    edge((0, 1), (2, 1), "->"),
    edge((1, 1), (2, 1), "->"),
    edge((2, 1), (3, 1), "->", label: [h]),

    // Verification
    dbox((0, 3), [entered\ password], fill: fill-warn),
    dbox((1, 3), [salt, c\ from store]),
    dbox((2, 3), [same KDF], fill: fill-accent),
    dbox((3, 3), [h' == h ?]),
    edge((0, 3), (2, 3), "->"),
    edge((1, 3), (2, 3), "->"),
    edge((2, 3), (3, 3), "->", label: [h']),
    edge((3, 1), (1, 3), "-->", bend: -20deg),
  )

  #block(width: 100mm)[#dnote[
    The plaintext is never stored. The salt is public and only has to be
    unique per account; it defeats precomputation and makes identical
    passwords hash differently. The cost parameter c is what makes each
    guess expensive.
  ]]
]
