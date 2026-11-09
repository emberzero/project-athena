#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (10mm, 9mm),
    node-stroke: none,

    dbox((1, 0), [Unknown binary], fill: fill-accent),

    dbox((0, 1), [*Static*\ never executed]),
    dbox((2, 1), [*Dynamic*\ runs in a sandbox]),
    edge((1, 0), (0, 1), "->"),
    edge((1, 0), (2, 1), "->"),

    dbox((0, 2), [`file`, `strings`,\ `readelf`, Ghidra], fill: fill-neutral),
    dbox((2, 2), [`strace`, `ltrace`,\ `gdb`, Frida], fill: fill-neutral),
    edge((0, 1), (0, 2), "->"),
    edge((2, 1), (2, 2), "->"),

    dbox((0, 3), [sees every path,\ beaten by packing], fill: fill-warn),
    dbox((2, 3), [sees real values,\ one path per run], fill: fill-warn),
    edge((0, 2), (0, 3), "->"),
    edge((2, 2), (2, 3), "->"),

    edge((0, 3), (2, 3), "<->", label: text(7.5pt)[feed each other]),
  )

  #dnote[#block(width: 90mm)[
    Neither branch is sufficient on its own. Static analysis finds the address worth watching,
    dynamic analysis tells you what is actually in the register once you get there.
  ]]
]
