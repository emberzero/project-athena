#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (11mm, 7mm),
    node-stroke: none,
    dgood((0, 0), [Boot ROM\ (root of trust,\ masked in silicon)]),
    dbox((0, 1), [First-stage\ bootloader]),
    dbox((0, 2), [Kernel +\ device tree]),
    dbox((0, 3), [Root filesystem\ (dm-verity)]),

    edge((0, 0), (0, 1), "->", label: [verify sig\ with fused key]),
    edge((0, 1), (0, 2), "->", label: [verify sig]),
    edge((0, 2), (0, 3), "->", label: [verify hash]),

    dbad((1, 1), [Glitch the\ verify branch]),
    dbad((1, 3), [Rewrite flash\ contents]),
    edge((1, 1), (0, 1), "->"),
    edge((1, 3), (0, 3), "->"),
  )

  #dnote[Each stage verifies the next. Break one link and everything above it is attacker-controlled.]
]
