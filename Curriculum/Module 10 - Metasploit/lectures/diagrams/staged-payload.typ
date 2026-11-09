#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (38mm, 13mm),
    node-stroke: none,

    dbox((0, 0), [Attacker \ handler on LPORT], width: 34mm),
    dbad((1, 0), [Target \ vulnerable service], width: 34mm),

    edge((0, 0), (1, 0), "->", label: text(size: 7.5pt)[1. exploit carries \ the stager]),
    edge((1, 0), (1, 1), "->"),

    dbox((0, 1), [Handler accepts, \ sends the stage], width: 34mm),
    dbad((1, 1), [Stager running \ small: connect, read], width: 34mm),

    edge((1, 1), (0, 1), "->", label: text(size: 7.5pt)[2. reverse TCP \ to LHOST]),
    edge((0, 1), (0, 2), "->"),
    edge((1, 1), (1, 2), "->", label: text(size: 7.5pt)[3. stage \ loaded]),

    dbox((0, 2), [Session 1 open], width: 34mm),
    dbad((1, 2), [Meterpreter \ in memory only], width: 34mm),

    edge((0, 2), (1, 2), "<->", label: text(size: 7.5pt)[4. encrypted \ session traffic]),
  )

  #block(width: 135mm)[#dnote[
    A staged payload splits the work: a tiny stager fits inside the exploit's
    limited buffer, then pulls the much larger Meterpreter stage over the same
    connection. The stage lives only in memory, which is why scanning files on
    disk does not see it. Egress filtering and endpoint behaviour monitoring do.
  ]]
]
