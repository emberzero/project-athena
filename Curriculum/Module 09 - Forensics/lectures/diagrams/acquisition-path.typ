#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (9mm, 9mm),
    dbox((0, 0), [Seized \ disk], width: 24mm),
    dgood((1, 0), [Hardware \ write blocker], width: 30mm),
    dbox((2, 0), [Examiner \ workstation], width: 30mm),
    dbox((3, 0), [Image file \ `.dd` / `.E01`], width: 30mm),

    edge((0, 0), (1, 0), "->", label: [read only]),
    edge((1, 0), (2, 0), "->"),
    edge((2, 0), (3, 0), "->", label: [`dd` / `ewfacquire`]),

    dgood((3, 1), [SHA-256 of source \ == SHA-256 of image], width: 44mm),
    edge((3, 0), (3, 1), "->"),
  )

  #block(width: 125mm)[#dnote[
    Nothing in the path may write to the seized disk. The verification hash is
    computed over the source device and over the finished image; the two values
    must match, and both go into the acquisition record.
  ]]
]
