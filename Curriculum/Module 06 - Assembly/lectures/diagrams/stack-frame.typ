#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (6mm, 4mm),
    node-stroke: none,
    node((0, 0), text(size: 7.5pt, fill: muted)[higher addresses]),
    dbox((0, 1), [arguments 7, 8, ... (if any)], width: 56mm, fill: fill-neutral),
    dbox((0, 2), [return address], width: 56mm, fill: fill-warn),
    dbox((0, 3), [saved `rbp`], width: 56mm),
    dbox((0, 4), [local variables], width: 56mm),
    dbox((0, 5), [buffer `char buf[64]`], width: 56mm),
    node((0, 6), text(size: 7.5pt, fill: muted)[lower addresses -- stack grows this way]),
    node((1, 3), text(size: 7.5pt)[`rbp` points here]),
    node((1, 5), text(size: 7.5pt)[`rsp` points here]),
    edge((1, 3), (0, 3), "->"),
    edge((1, 5), (0, 5), "->"),
  )
  #dnote[A write into `buf` that runs past its end moves upward, toward the saved
  `rbp` and the return address. That direction is why an unchecked copy into a stack
  buffer can redirect `ret`.]
]
