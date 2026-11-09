#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (14mm, 9mm),
    node-stroke: none,
    dbox((1, 0), [`cmp rax, 10`\ `jl .less`]),
    dbox((0, 1), [`.less:`\ taken path]),
    dbox((2, 1), [fall-through\ path]),
    dbox((1, 2), [`.end:`\ joins again]),
    edge((1, 0), (0, 1), "->", label: text(size: 7.5pt)[SF != OF], label-pos: 0.35),
    edge((1, 0), (2, 1), "->", label: text(size: 7.5pt)[otherwise], label-pos: 0.35),
    edge((0, 1), (1, 2), "->", label: text(size: 7.5pt)[`jmp`], label-pos: 0.4),
    edge((2, 1), (1, 2), "->"),
  )
  #dnote[`cmp` sets flags, the conditional jump reads them. Every `if`, loop and
  `switch` in a compiled program reduces to this shape -- a basic block ending in one
  flag-driven branch.]
]
