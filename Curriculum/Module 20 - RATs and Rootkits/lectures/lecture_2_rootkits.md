# Rootkits

A rootkit does not have to be malicious, one common definition is a piece of software with elevated privileges that enables access that is not normally possible.

A rootkit is a RAT with more privileges, operations wise that typically means it lives at least in ring 0.
Other than the difference in privilege, they typically serve a distinct purpose that justifies the higher cost of development.

## Purposes

There are actually a few legitimate purposes, perhaps the most well known and controversial one being Anticheat.
Having more access than anything else is just really useful for monitoring a system, that is just how things are.
Especially in modern systems architecture there is quite a lot of software that might benefit from running at elevated privileges.

## Variants

- Userland: Getting very rare now, but somewhat used to be the default long ago. Replacing libc to get a backdoor is a classic example.
- Mobile: Not that many known examples, possible use in state spyware.
- BIOS/UEFI: Firmware rootkits, requires high severity vuln to install but still happens occasionally. Functionally not too different from enterprise management or anti-theft solutions.
- Bootkits: Traditionally targeted Boot Sector but nowadays similar to BIOS/UEFI rootkits, sometimes used as name for firmware rootkits.
- Hypervisor: Difficult to categorize, otherwise relatively similar to firmware rootkits.

## Kernelspace

We have to touch a little bit on this topic, leaving this out doesn't really make sense if we want to actually understand rootkits and their variants.

Ring 0 means that code runs with kernel privileges, that means full access to all things used and managed by the kernel, which is why rootkits and ring 0 programs cannot really be detected or circumvented from userland.

The privilege levels the variants above live at, outermost first. Only
rings 3 and 0 are real x86 privilege levels; the negative numbers are
informal nomenclature used to describe code the kernel cannot see:

```text
  ring  3  user space       apps, libc         userland rootkits
  ring  0  kernel           drivers, syscalls  kernel rootkits
  ring -1  hypervisor       hosts the OS       hypervisor rootkits
  ring -2  SMM              firmware handler   SMM rootkits
  ring -3  platform engine  out-of-band core   hardware rootkits

  not a ring, a position in the boot chain:
  BIOS/UEFI firmware and boot sector code run BEFORE the kernel,
  so they can tamper with everything that loads after them.
```

Some of the most important kernel structures/operations are:

- Memory Management
- Process Management
- Networking
- Drivers
- Interrupts
- Syscalls

There are also some more specific structures in kernelspace such as the [IDT](https://wiki.osdev.org/Interrupt_Descriptor_Table) on x86, but to mention every relevant structures is far outside this scope, also because a lot of this is kernel and version specific.

Running at the typically elevated privileges means the rootkit gets full access to these structures, which is how they can hide so well. Kernels have tried to mitigate this by preventing writes to certain areas or checking for integrity but this ends up being just another cat and mouse game.

Especially on x86 there is a lot of, for the lack of a better word, [fuckery](https://wiki.osdev.org/Protected_Mode) that causes attacking and defending the kernel to be an entirely different beast than anything in userland.

Sometimes, through mistakes or possibly even backdoors, it is possible to run at levels that don't fit within the traditional ring model, such as [hypervisors](https://www.blackhat.com/docs/us-16/materials/us-16-Wilhelm-Xenpwn-Breaking-Paravirtualized-Devices-wp.pdf), [SMM](https://www.blackhat.com/docs/us-15/materials/us-15-Domas-The-Memory-Sinkhole-Unleashing-An-x86-Design-Flaw-Allowing-Universal-Privilege-Escalation-wp.pdf) or sometimes even [the hardware itself](https://invisiblethingslab.com/resources/bh09usa/Ring%20-3%20Rootkits.pdf).

## Reading

Rootkits are a very deep topic, far too deep to reasonably cover here, so here are some more resources:

- [Rootkit Arsenal](https://books.google.com/books/about/The_Rootkit_Arsenal.html?id=aJFVCnwNbMEC)
- [Rootkits and Bootkits](https://nostarch.com/rootkits)
