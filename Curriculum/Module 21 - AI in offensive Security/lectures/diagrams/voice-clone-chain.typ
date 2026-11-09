#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (14mm, 10mm),
    dbad((0, 0), [Public audio\ (talk, podcast,\ voicemail)], shape: rect),
    dbad((0, 1), [Cloned voice\ + pretext\ from OSINT], shape: rect),
    dbad((0, 2), [Live call to\ finance staff], shape: rect),
    dbox((0, 3), [Payment\ released], shape: rect),
    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->"),
    edge((0, 2), (0, 3), "->", label: [urgency]),
    dgood((1, 3), [Call back on a\ number from the\ directory +\ second approver], shape: rect),
    edge((1, 3), (0, 3), "->", label: [breaks\ the chain]),
  )

  #block(width: 330pt, dnote[Cloning removes the accent and hesitation that used to betray the\
  caller. The control is procedural, not perceptual: verification\
  happens on a channel the caller did not choose.])
]
