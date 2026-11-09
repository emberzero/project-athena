#import "/utils/athena-diagram.typ": *

#let life(x) = edge((x, 0), (x, 6), "--", stroke: 0.5pt + muted)

#diagram-page[
  #diagram(
    spacing: (34mm, 8mm),
    node-stroke: none,
    label-size: 7.5pt,

    dbox((0, 0), [Client\ (user)]),
    dbox((1, 0), [KDC on the DC\ AS + TGS]),
    dbox((2, 0), [Service\ (SPN owner)]),
    life(0), life(1), life(2),

    edge((0, 1), (1, 1), "->", label: [1. AS-REQ, pre-auth with user key]),
    edge((1, 2), (0, 2), "->", label: [2. AS-REP: TGT + session key]),
    edge((0, 3), (1, 3), "->", label: [3. TGS-REQ: TGT + target SPN]),
    edge((1, 4), (0, 4), "->", label: [4. TGS-REP: service ticket]),
    edge((0, 5), (2, 5), "->", label: [5. AP-REQ: service ticket presented to the service]),
  )

  #block(width: 128mm)[#dnote[
    The TGT is encrypted with the krbtgt key; the service ticket is encrypted
    with the key of the account that owns the SPN. The service never contacts
    the KDC in step 5 — it simply decrypts the ticket. That property is what
    makes Kerberoasting, Silver Tickets and Golden Tickets possible.
  ]]
]
