#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (14mm, 10mm),
    node-stroke: none,
    dbox((0, 0), [Operator\ (sets goal,\ holds mandate)], shape: rect),
    dbox((0, 1), [Language model\ (proposes next\ step)], shape: rect),
    dbox((0, 2), [Tool runner\ (shell, HTTP,\ scanner)], shape: rect),
    dbad((0, 3), [Authorized\ target\ (untrusted\ output)], shape: rect),
    edge((0, 0), (0, 1), "->", label: [goal]),
    edge((0, 1), (0, 2), "->", label: [command]),
    edge((0, 2), (0, 3), "->", label: [request]),
    edge((0, 3), (0, 1), "->", bend: -50deg, label: [output\ re-enters\ the context], label-side: right),
  )

  #block(width: 330pt, dnote[Red marks data the operator does not control. Everything the target\
  returns is attacker-influenced text that lands in the model's\
  context, so the loop needs a tool allow-list and operator approval\
  before any irreversible step.])
]
