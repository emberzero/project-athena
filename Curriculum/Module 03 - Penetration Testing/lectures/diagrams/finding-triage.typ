#import "/utils/athena-diagram.typ": *

// Why a scan report is not a pentest report: the funnel from raw scanner
// output down to the findings that reach the deliverable.
#diagram-page[
  #diagram(
    spacing: (16mm, 9mm),
    dbox((0, 0), [Raw scanner output]),
    dbox((0, 1), [Deduplicate]),
    dbox((0, 2), [Verify by hand]),
    dbad((0, 3), [Confirmed finding]),
    dbox((0, 4), [Rated and written up]),

    dbox((1, 2), [Discarded: \ false positive, \ out of scope], fill: fill-neutral),

    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->"),
    edge((0, 2), (0, 3), "->"),
    edge((0, 3), (0, 4), "->"),
    edge((0, 2), (1, 2), "->", label: text(size: 7pt)[no repro]),
  )

  #dnote[Discarded items still belong in the methodology section.]
]
