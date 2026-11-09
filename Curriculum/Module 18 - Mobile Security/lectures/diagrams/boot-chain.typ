#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (6mm, 7mm),
    dgood((0, 0), [Boot ROM\ (mask ROM, immutable)]),
    dbox((0, 1), [Second-stage bootloader]),
    dbox((0, 2), [Kernel + verified\ system image]),
    dbox((0, 3), [Signed applications]),
    edge((0, 0), (0, 1), "->", label: [verifies signature]),
    edge((0, 1), (0, 2), "->", label: [verifies signature]),
    edge((0, 2), (0, 3), "->", label: [checks code signature]),
    dbad((1, 1), [Unlocked bootloader\ breaks the chain here]),
    edge((1, 1), (0, 1), "->"),
  )
  #dnote[Each stage verifies the next before handing over control. Green: the hardware root of trust.]
]
