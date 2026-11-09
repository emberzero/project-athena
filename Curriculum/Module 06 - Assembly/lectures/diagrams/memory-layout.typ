#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (6mm, 4mm),
    node-stroke: none,
    node((0, 0), text(size: 7.5pt, fill: muted)[high addresses]),
    dbox((0, 1), [stack -- frames, saved return\ addresses, locals (grows down)], width: 62mm),
    node((0, 2), text(size: 7.5pt, fill: muted)[$arrow.b$ ... unmapped gap ... $arrow.t$]),
    dbox((0, 3), [heap -- `malloc` (grows up)], width: 62mm),
    dbox((0, 4), [`.bss` -- zero-initialised data], width: 62mm),
    dbox((0, 5), [`.data` -- writable initialised data], width: 62mm),
    dbox((0, 6), [`.rodata` -- read-only constants], width: 62mm, fill: fill-neutral),
    dbox((0, 7), [`.text` -- machine code, read + execute], width: 62mm, fill: fill-accent),
    node((0, 8), text(size: 7.5pt, fill: muted)[low addresses]),
  )
  #dnote[Permissions matter more than position: `.text` is executable but not writable,
  the stack and heap are writable but not executable. Addresses are randomised by ASLR,
  so only the relative order is stable.]
]
