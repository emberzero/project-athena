#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (8mm, 10mm),
    node-stroke: none,

    dbox((0, 0), [C source\ `main.c`]),
    dbox((1, 0), [Compiler\ + linker]),
    dbox((2, 0), [Machine code\ `./main`]),

    edge((0, 0), (1, 0), "->"),
    edge((1, 0), (2, 0), "->", label: text(7.5pt)[build]),

    dbox((2, 1), [Disassembler\ instructions], fill: fill-accent),
    dbox((1, 1), [Decompiler\ pseudo-C], fill: fill-accent),
    dbox((0, 1), [Your model\ of the program], fill: fill-ok),

    edge((2, 0), (2, 1), "->"),
    edge((2, 1), (1, 1), "->"),
    edge((1, 1), (0, 1), "->", label: text(7.5pt)[reading]),

    dbox((1, 2), [discarded by the compiler:\ names, types, comments, macros], fill: fill-neutral),
    edge((1, 0), (1, 2), "-->", bend: 45deg),
  )

  #dnote[#block(width: 90mm)[
    The top row is the build, the bottom row is reverse engineering. The decompiler cannot
    recover what the compiler threw away, so the pseudo-C you read is a reconstruction, not
    the original source.
  ]]
]
