#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (16mm, 10mm),
    node-stroke: none,

    dbox((0, 0), [Attacker \ 192.0.2.10], width: 36mm),
    dbad((0, 1), [DMZ host (compromised) \ 192.0.2.50 / 10.10.0.5], width: 46mm),
    dbox((0, 2), [Internal host \ 10.10.0.20], width: 36mm),

    edge((0, 0), (0, 1), "<->", label: text(size: 7.5pt)[session 1], label-side: left),
    edge((0, 1), (0, 2), "->", label: text(size: 7.5pt)[tunnelled via \ session 1], label-side: left),

    dgood((1, 1), [Firewall \ no route 192.0.2.0/24 \ to 10.10.0.0/24], width: 40mm),
    edge((1, 1), (0, 0), "--", label: text(size: 7.5pt)[blocks \ direct access], label-size: 7.5pt),
  )

  #block(width: 115mm)[#dnote[
    The attacker has no IP route to 10.10.0.0/24. Metasploit adds one through the
    compromised host's session, so later modules reach the internal network
    without the attacker's own packets crossing the firewall. The defence is not a
    bigger perimeter firewall but internal segmentation: the DMZ host should not
    be able to reach the internal subnet either.
  ]]
]
