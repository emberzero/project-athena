#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (6mm, 7mm),
    node-stroke: none,

    dbox((0, 0), [msfconsole], fill: fill-accent),
    dbox((1, 0), [msfvenom], fill: fill-accent),
    dbox((2, 0), [RPC / API], fill: fill-accent),

    dbox((1, 1), [Framework core \ module loader, \ session manager, \ handlers], fill: fill-normal, width: 48mm),

    dbox((0, 2), [exploit \ payload \ encoder], fill: fill-neutral),
    dbox((1, 2), [auxiliary \ post \ nop], fill: fill-neutral),
    dbox((2, 2), [evasion], fill: fill-neutral),

    dbox((1, 3), [Rex library \ sockets, protocols, encoding], fill: fill-normal, width: 48mm),

    dbox((3, 1), [PostgreSQL \ hosts, services, \ creds, loot], fill: fill-ok),

    edge((0, 0), (1, 1), "->"),
    edge((1, 0), (1, 1), "->"),
    edge((2, 0), (1, 1), "->"),
    edge((1, 1), (0, 2), "->"),
    edge((1, 1), (1, 2), "->"),
    edge((1, 1), (2, 2), "->"),
    edge((0, 2), (1, 3), "->"),
    edge((1, 2), (1, 3), "->"),
    edge((2, 2), (1, 3), "->"),
    edge((1, 1), (3, 1), "<->"),
  )

  #block(width: 115mm)[#dnote[
    Blue: user interfaces. Grey: the module tree, where the actual attack code
    lives. Green: the optional database that persists scan results between runs.
  ]]
]
