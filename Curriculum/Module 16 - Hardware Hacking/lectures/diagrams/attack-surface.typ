#import "/utils/athena-diagram.typ": *

#diagram-page[
  #diagram(
    spacing: (10mm, 7mm),
    node-stroke: none,
    dbox((0, 0), [Application\ firmware]),
    dbox((0, 1), [RTOS / Linux\ userland]),
    dbox((0, 2), [Bootloader\ + secure boot], fill: fill-accent),
    dbox((0, 3), [SoC: CPU, ROM,\ fuses, crypto]),

    dbad((1, 0), [Network / radio\ RFID, Wi-Fi, BLE]),
    dbad((1, 1), [Debug ports\ UART, JTAG, SWD]),
    dbad((1, 2), [External flash\ SPI, I2C, eMMC]),
    dbad((1, 3), [Physical die\ glitch, probe]),

    edge((1, 0), (0, 0), "->"),
    edge((1, 1), (0, 1), "->"),
    edge((1, 2), (0, 2), "->"),
    edge((1, 3), (0, 3), "->"),
  )

  #dnote[
    Left: the device's own stack.\
    Right: the entry points an attacker with the board in hand can reach.
  ]
]
