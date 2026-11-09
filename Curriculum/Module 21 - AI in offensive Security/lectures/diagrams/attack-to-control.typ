#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (22mm, 7mm),
    dbad((0, 0), [Fluent pretext\ at scale], shape: rect),
    dgood((1, 0), [Out-of-band\ verification,\ dual authorization], shape: rect),
    edge((0, 0), (1, 0), "->"),
    dbad((0, 1), [Cloned voice or\ video in a call], shape: rect),
    dgood((1, 1), [Challenge on a\ known channel], shape: rect),
    edge((0, 1), (1, 1), "->"),
    dbad((0, 2), [Credential\ phishing page], shape: rect),
    dgood((1, 2), [Phishing-resistant\ auth (FIDO2 /\ passkeys)], shape: rect),
    edge((0, 2), (1, 2), "->"),
    dbad((0, 3), [Agent-driven\ recon and\ exploitation], shape: rect),
    dgood((1, 3), [Patching, least\ privilege,\ behavioural\ detection], shape: rect),
    edge((0, 3), (1, 3), "->"),
  )

  #block(width: 330pt, dnote[AI changes the volume and the polish of the left column. The right column is the same security engineering as before, which is why it still holds.])
]
