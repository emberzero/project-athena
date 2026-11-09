#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (14mm, 10mm),
    dbad((0, 0), [Page in scope\ carries planted\ instructions], shape: rect),
    dbox((0, 1), [Agent fetches\ the page], shape: rect),
    dbad((0, 2), [Model context:\ data read as\ instruction], shape: rect),
    dbad((0, 3), [Tool call\ outside the\ engagement scope], shape: rect),
    edge((0, 0), (0, 1), "->"),
    edge((0, 1), (0, 2), "->", label: [appended]),
    edge((0, 2), (0, 3), "->"),
    dgood((1, 3), [Tool allow-list,\ scope check,\ operator approval], shape: rect),
    edge((1, 3), (0, 3), "->", label: [blocked\ here]),
  )

  #block(width: 330pt, dnote[The model cannot reliably tell retrieved content from your\
  instructions. Treat every tool call it proposes as untrusted input\
  to a policy check that runs outside the model.])
]
