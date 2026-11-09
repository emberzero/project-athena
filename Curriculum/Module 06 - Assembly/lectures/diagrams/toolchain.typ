#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (10mm, 7mm),
    node-stroke: none,
    dbox((0, 0), [`hello.asm`\ source text]),
    dbox((1, 0), [`hello.o`\ object file]),
    dbox((2, 0), [`hello`\ ELF executable]),
    dbox((2, 1), [process image\ in memory]),
    dbox((0, 1), [`objdump -d`\ `gdb` / `ndisasm`]),
    edge((0, 0), (1, 0), "->", label: [`nasm`], label-size: 7.5pt),
    edge((1, 0), (2, 0), "->", label: [`ld`], label-size: 7.5pt),
    edge((2, 0), (2, 1), "->", label: [`execve`], label-size: 7.5pt),
    edge((2, 1), (0, 1), "->", label: [read back], label-size: 7.5pt),
    edge((0, 1), (0, 0), "-->", label: [compare], label-size: 7.5pt),
  )
  #dnote[Assembling is nearly lossless in one direction and lossy in the other: the
  disassembler recovers instructions, never your names or comments.]
]
