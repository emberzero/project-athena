#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (14mm, 10mm),
    node-stroke: none,

    dbox((0, 0), [Winlogon /\ LogonUI]),
    dbox((1, 0), [LSASS\ auth packages]),
    dbox((2, 0), [SAM hive (local)\ or DC (domain)]),

    edge((0, 0), (1, 0), "->", label: [credentials], label-size: 7.5pt),
    edge((1, 0), (2, 0), "<->", label: [verify,\ get group SIDs], label-size: 7.5pt),

    dbox((1, 1), [Access token\ user SID + group SIDs\ + privileges + integrity], fill: fill-accent),
    edge((1, 0), (1, 1), "->", label: [builds], label-size: 7.5pt),

    dbox((1, 2), [User process\ (inherits token)]),
    edge((1, 1), (1, 2), "->"),

    dbox((2, 2), [Securable object\ owner + DACL + SACL]),
    edge((1, 2), (2, 2), "->"),

    dgood((2, 3), [Access check:\ token SIDs vs ACEs]),
    edge((2, 2), (2, 3), "->"),
  )

  #block(width: 128mm)[#dnote[
    Every authorisation decision in Windows compares the SIDs in the caller's
    access token against the ACEs in the object's DACL. Stealing a token, or
    adding a SID to one, is therefore equivalent to stealing an identity.
  ]]
]
