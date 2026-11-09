#import "/utils/athena-diagram.typ": *

#let row = 62mm

#diagram-page[
  #diagram(
    spacing: (4mm, 1.5mm),
    node-stroke: none,

    node((0, -1), text(7.5pt, fill: muted)[high addresses]),

    dbox((0, 0), [stack -- locals, saved `rbp`,\ return addresses (grows down)], width: row),
    dbox((0, 1), [free space], width: row, fill: fill-neutral),
    dbox((0, 2), [heap -- `malloc` (grows up)], width: row),
    dbox((0, 3), [mapped libraries -- `libc`, loader], width: row),
    dbox((0, 4), [`.bss` -- zero-initialised globals], width: row),
    dbox((0, 5), [`.data` -- writable globals], width: row),
    dbox((0, 6), [`.rodata` -- string literals], width: row, fill: fill-accent),
    dbox((0, 7), [`.text` -- the instructions], width: row, fill: fill-accent),

    node((0, 8), text(7.5pt, fill: muted)[low addresses]),
  )

  #dnote[#block(width: 90mm)[
    A Linux process image. The two shaded regions are copied straight out of the ELF file and
    are what a disassembler shows you; everything above them only exists at run time, which is
    why `strings` finds a literal password but never a key that is decrypted in memory.
  ]]
]
