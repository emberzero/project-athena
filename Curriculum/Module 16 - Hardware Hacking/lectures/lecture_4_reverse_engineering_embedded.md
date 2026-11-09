# Reverse Engineering of Embedded Systems

Reverse engineering an embedded system means recovering enough of its design to reason about
its security without the vendor's documentation. In practice that is three questions in order:
what is on the board, how do I get the firmware, and what does the firmware do?

This lecture covers the workflow end to end on a device you own. Everything here is read-only
analysis; writing to the target is Lecture 5.

## Stage 1: Board Recon

Start with the parts list, because every later step depends on it.

```text
  SoC marking  ->  datasheet  ->  boot modes, pin functions, debug interface
  flash marking ->  datasheet  ->  package, voltage, SPI command set, capacity
  PMIC / RTC / EEPROM markings  ->  what else holds state
```

Write down, for each IC: the manufacturer logo, the full part number, the package, and what
the datasheet says it is. A board with an SPI NOR flash in SOIC-8 next to an ARM SoC is a
very different problem from one where the firmware lives in internal flash on a
microcontroller with the debug port fused shut.

Then find the interfaces, using the multimeter-and-logic-analyser routine from Lecture 1.
Unpopulated headers, rows of four or five test pads, and vias near the SoC are all candidates.

## Stage 2: Getting the Firmware

Ordered from least to most invasive. Try them in this order; the easy path works more often
than you would expect.

### From the Vendor

Many manufacturers publish firmware update images. Download them, and you have an image
without touching the hardware. They may be encrypted, obfuscated or packed in a proprietary
container, but they are the cheapest possible starting point. Capturing an over-the-air update
from the device's own update traffic is the same idea by another route.

### From the Bootloader Console

If a U-Boot or vendor bootloader prompt is reachable over UART, it usually offers memory and
flash commands. Dumping over a serial console is slow but needs no extra hardware.

```text
=> printenv          # boot arguments, update URLs, board configuration
=> bdinfo            # memory layout
=> md 0x80000000 20  # read 0x20 words of memory
```

### Over JTAG or SWD

With a probe and OpenOCD you can halt the CPU and read internal flash and RAM directly.

```bash
openocd -f interface/stlink.cfg -f target/stm32f1x.cfg
# in a second terminal:
telnet localhost 4444
> halt
> dump_image firmware.bin 0x08000000 0x20000
```

The target configuration files shipped with OpenOCD cover a large range of parts; pick the one
matching your SoC. If the debug port has been locked by a fuse, this path is closed, which is
itself a useful finding about the product.

### From External Flash

The most reliable route for Linux-class devices. With a SOIC-8 clip and a CH341A programmer:

```bash
flashrom -p ch341a_spi                        # probe: does it see the chip?
flashrom -p ch341a_spi -c "W25Q64.V" -r dump.bin
sha256sum dump.bin                            # read twice, compare hashes
```

Two practical notes. Read the chip at least twice and compare, because a bad clip contact produces
a corrupt image that looks plausible. And in-circuit reads can fail when the SoC holds the bus
or the rail cannot be powered in isolation; then the chip comes off with hot air.

For ESP32/ESP8266 targets the vendor tool does the same job over UART:

```bash
esptool.py --port /dev/ttyUSB0 flash_id
esptool.py --port /dev/ttyUSB0 read_flash 0 0x400000 flash.bin
```

## Stage 3: Understanding the Image

### Is It Even Readable?

```bash
file dump.bin
binwalk -E dump.bin        # entropy plot: flat and high means compressed or encrypted
strings -n 8 dump.bin | less
```

High, uniform entropy across the whole image with no recognisable strings means encryption or
a compressed container. Mixed entropy with readable strings and recognisable headers means you
can proceed.

### Carving the Filesystem

```bash
binwalk dump.bin           # signature scan: headers and offsets
binwalk -e dump.bin        # extract what it recognises
```

A typical Linux device image contains a bootloader, a kernel (`uImage`/`zImage`), a SquashFS or
JFFS2/UBIFS root filesystem, and a writable configuration partition. If `binwalk` finds the
SquashFS but cannot unpack it, extract the region by hand and unpack it separately:

```bash
dd if=dump.bin of=rootfs.sqfs bs=1 skip=<offset>
unsquashfs rootfs.sqfs
```

### What to Look For in the Filesystem

```bash
cd squashfs-root
cat etc/passwd etc/shadow 2>/dev/null       # hashes, and whether root has a password
grep -rIn "BEGIN .*PRIVATE KEY" .            # embedded keys
grep -rIn -e "password" -e "secret" -e "token" etc/ usr/ 2>/dev/null
ls -l etc/init.d/ etc/rc.d/ 2>/dev/null     # what starts at boot
ls -l usr/sbin usr/bin bin sbin             # the actual attack surface
```

Findings that come up over and over: a root password hash that cracks in seconds, a TLS
private key shared by the whole product line, hardcoded credentials in a CGI script, a
`telnetd` started unconditionally, and an update script that fetches over plain HTTP.

### Bare-Metal Images

A microcontroller image has no filesystem. It is a flat binary with a vector table at a known
address. The workflow shifts to static analysis:

1. Identify the architecture and the load address from the datasheet, and the reset vector at
   the start of the image.
2. Load into a disassembler with that architecture and base address. Ghidra and radare2 both
   handle ARM, MIPS, AVR, RISC-V and more.
3. Locate the interrupt handlers and the peripheral register accesses. The memory-mapped
   peripheral addresses from the datasheet tell you which code talks to which pin, which is how
   you find the part that drives the door relay or reads the sensor.
4. Work outward from the strings and the peripheral code to the logic you care about.

```bash
# first orientation on a flat image
readelf -h firmware.elf 2>/dev/null || echo "not ELF: flat image"
strings -n 6 firmware.bin | grep -i -e version -e http -e error | head
```

### Emulation

Running the firmware without the hardware shortens the loop considerably. User-mode QEMU can
execute a single cross-architecture binary from an extracted filesystem:

```bash
cp "$(which qemu-arm-static)" squashfs-root/
sudo chroot squashfs-root ./qemu-arm-static /usr/sbin/httpd -h
```

Full-system emulation of a router image is possible but fiddly, because peripherals the
firmware expects are not there. Expect to stub things out, and expect some devices to resist
emulation entirely.

## Keeping Notes

Reverse engineering is bookkeeping as much as analysis. Keep, per target:

- board photographs, with pin labels drawn on them;
- the part inventory with datasheet links;
- every flash dump, with its hash and how it was taken;
- a running log of findings, each with the file and offset it came from.

Six weeks later the log is the only thing that lets you pick the work back up, and in paid work
it is what the report is written from.

## Defensive Counterparts

Each extraction route has a direct mitigation:

| Extraction route            | What makes it fail                                        |
| --------------------------- | --------------------------------------------------------- |
| Vendor update image         | Signed and encrypted update packages                       |
| Bootloader console          | Console disabled, or locked behind a per-device secret      |
| JTAG/SWD                    | Debug port disabled by OTP fuse after provisioning         |
| External flash read         | Flash encryption with the key in on-die OTP                |
| Any image, once obtained    | No shared secrets in the image; per-device keys only        |
| Modified image written back | Secure boot verifying a signature chain (Lecture 5)         |

Note the last two rows. Preventing extraction is a delaying tactic; a determined attacker with
the die in hand wins eventually. What actually protects the fleet is that the extracted image
contains no secret worth having, and that a modified image will not boot.

## Exercises

Use a device you own, bought for the purpose.

1. Produce a part inventory for the board and identify where the firmware is stored.
2. Obtain the firmware by at least two independent routes (vendor download, UART bootloader,
   flash clip) and compare the hashes. Explain any difference.
3. Extract the root filesystem and audit it: password hashes, embedded keys, services started
   at boot, anything fetched over plain HTTP. Write it up as a findings list with file paths.
4. Pick one binary from the image, load it into Ghidra, and identify the function that handles
   its network input. Document how you found it.

## Key Takeaways

- Recon first: part numbers and datasheets determine every later option.
- Try the cheap firmware routes before the invasive ones: vendor downloads, bootloader
  consoles, then JTAG, then the flash chip.
- Verify every dump by reading twice and comparing hashes; a corrupt image wastes days.
- `binwalk` entropy tells you immediately whether the image is encrypted; `binwalk -e` plus
  `unsquashfs` gets you the filesystem when it is not.
- The recurring findings are boring and serious: shared keys, static root passwords, debug
  services, unauthenticated updates.
- Extraction cannot be prevented forever. Design so that an extracted image is worthless and a
  modified image will not run.

## Resources

- OWASP Firmware Security Testing Methodology: <https://github.com/scriptingxss/owasp-fstm>
- binwalk: <https://github.com/ReFirmLabs/binwalk>
- flashrom: <https://www.flashrom.org/>
- OpenOCD user guide: <https://openocd.org/doc/html/index.html>
- Ghidra: <https://ghidra-sre.org/>
- esptool documentation: <https://docs.espressif.com/projects/esptool/>
- Andrew Huang, *Hacking the Xbox* (board-level reverse engineering as a worked example)
