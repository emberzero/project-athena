#import "/utils/athena-diagram.typ": *

#let pillar(title, examples) = [
  #strong(title) \
  #text(size: 7.5pt, fill: muted, examples)
]

#diagram-page[
  #diagram(
    spacing: (8mm, 14mm),
    dgood((1, 0), [Security \ professional], width: 32mm),

    dbox((0, 1), pillar([Cyber defence & CERTs], [BSI · CERT.at \ GovCERT · ENISA \ CISA · NCSC]), width: 36mm),
    dbox((1, 1), pillar([Intelligence services], [BND · BfV · DSN \ HNaA · NSA \ GCHQ]), width: 36mm),
    dbox((2, 1), pillar([Law enforcement], [BK / C4 · BKA \ Europol EC3 \ Interpol]), width: 36mm),

    edge((1, 0), (0, 1), "->", label: [incident reports], label-side: right),
    edge((1, 0), (1, 1), "->", label: [threats], label-side: left, label-pos: 0.72),
    edge((1, 0), (2, 1), "->", label: [crime reports], label-side: left, label-pos: 0.35),
  )

  #block(width: 135mm)[#dnote[
    The three pillars have different mandates and are deliberately kept apart.
    A professional reports incidents to cyber defence bodies, treats
    intelligence services as both a source of advisories and a possible
    attacker, and reports crimes to the police.
  ]]
]
