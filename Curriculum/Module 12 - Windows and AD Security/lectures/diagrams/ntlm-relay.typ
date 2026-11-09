#import "/utils/athena-diagram.typ": *

#let life(x) = edge((x, 0), (x, 9), "--", stroke: 0.5pt + muted)

#diagram-page[
  #diagram(
    spacing: (26mm, 8mm),
    node-stroke: none,
    label-size: 7.5pt,

    dbox((0, 0), [Victim host]),
    dbad((1, 0), [Attacker relay]),
    dbox((2, 0), [Target service\ SMB / LDAP / HTTP]),
    life(0), life(1), life(2),

    edge((1, 1), (0, 1), "->", label: [1. coerce auth]),
    edge((0, 2), (1, 2), "->", label: [2. NEGOTIATE]),
    edge((1, 3), (2, 3), "->", label: [3. relayed]),
    edge((2, 4), (1, 4), "->", label: [4. CHALLENGE]),
    edge((1, 5), (0, 5), "->", label: [5. passed back]),
    edge((0, 6), (1, 6), "->", label: [6. RESPONSE]),
    edge((1, 7), (2, 7), "->", label: [7. replayed]),
    edge((2, 8), (1, 8), "->", label: [8. session]),

    dgood((1, 9), [Stopped by\ signing, EPA,\ or no NTLM]),
  )

  #block(width: 128mm)[#dnote[
    1. The attacker coerces authentication or poisons name resolution. 2.-3. The
    victim's NTLM NEGOTIATE is forwarded verbatim to the target. 4.-5. The
    target's CHALLENGE is passed back to the victim. 6.-7. The RESPONSE, computed
    with the victim's key, is replayed to the target. 8. The target authenticates
    the session as the victim.

    Controls: SMB and LDAP signing, channel binding (EPA) on HTTPS, or removing
    NTLM entirely. The attacker never learns the password. NTLM binds nothing in
    the challenge and response to the channel it travels over, so a valid
    response is valid wherever it is delivered.
  ]]
]
