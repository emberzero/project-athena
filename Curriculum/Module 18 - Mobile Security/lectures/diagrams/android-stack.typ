#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (10mm, 8mm),
    dbox((0, 0), [App A\ UID 10123]),
    dbox((1, 0), [App B\ UID 10124]),
    dbox((0.5, 1), [Android framework:\ Binder IPC, ART runtime]),
    dgood((0.5, 2), [Linux kernel:\ per-app UID isolation\ + SELinux policy]),
    edge((0, 0), (0.5, 1), "->"),
    edge((1, 0), (0.5, 1), "->"),
    edge((0.5, 1), (0.5, 2), "->"),
  )
  #dnote[Two apps share the device but not an identity. Cross-app traffic goes\
    through Binder IPC; the kernel mediates every call.]
]
