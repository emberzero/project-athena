#import "/utils/athena-diagram.typ": *

// A segmented lab network and the path post-exploitation takes through it.
#diagram-page[
  #diagram(
    spacing: (12mm, 12mm),
    dbad((0, 0), [Tester]),
    dbox((1, 0), [DMZ web app \ 10.10.1.20]),
    dgood((2, 0), [Internal \ firewall]),
    dbox((3, 0), [Database \ 10.10.9.5]),

    dgood((1, 1), [Egress filtering]),
    dgood((2, 1), [Segmentation rules]),

    edge((0, 0), (1, 0), "->", label: text(size: 7pt)[1 exploit]),
    edge((1, 0), (2, 0), "->", label: text(size: 7pt)[2 pivot]),
    edge((2, 0), (3, 0), "->", label: text(size: 7pt)[3 reuse creds]),
    edge((1, 0), (1, 1), "-"),
    edge((2, 0), (2, 1), "-"),
  )

  #dnote[Green boxes are the controls that stop steps 2 and 3.]
]
