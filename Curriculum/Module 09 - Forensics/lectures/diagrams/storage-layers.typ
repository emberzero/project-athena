#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (14mm, 7mm),
    dbox((0, 0), [Physical device -- sectors], width: 56mm),
    dbox((0, 1), [Volume layer -- partition table], width: 56mm),
    dbox((0, 2), [File system layer -- metadata], width: 56mm),
    dbox((0, 3), [File content -- allocated data], width: 56mm),
    dbad((0, 4), [Unallocated space, slack, journal], width: 56mm),

    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->"),
    edge((0, 2), (0, 3), "->"),

    dbox((1, 1), [`mmls`], stroke: none, fill: none),
    dbox((1, 2), [`fsstat`, `fls`], stroke: none, fill: none),
    dbox((1, 3), [`icat`], stroke: none, fill: none),
    dbox((1, 4), [`blkls`, carving], stroke: none, fill: none),
  )

  #block(width: 125mm)[#dnote[
    Each layer is an interpretation of the one above it. The bottom band is not
    reachable through the file system at all -- it is read by addressing blocks
    directly, which is where deleted data survives.
  ]]
]
