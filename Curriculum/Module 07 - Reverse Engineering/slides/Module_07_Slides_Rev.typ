#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 07: Rev],
    subtitle: [Reverse Engineering 101],
    authors: [*Sebastian Felix*],
    extra: [],
    footer: [Sebastian Felix],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#slide(title: "Reverse Engineering 101")[
  As I like to call it:

  #image("./figures/intro.png", height: 85%)
]

#section-slide(title: "Assembly")

#slide(title: "Architecture")[
  #figure(image("figures/Von_Neumann_Architecture.svg.png"), caption: [Van Neumann Architecture])
]

#slide(title: "Assembly Recap")[
  CPUs work with registers and memory

  x86-64 has many registers such as ` rax, rbx, rcx, rdx, rdi, rsi, rsp, rip, r8-r15`

  Special registers:

  - `rip`: Current instruction pointer

  - `rsp`: Current stack pointer

  - `rbp`: Stack frame base pointer

  - `cr3`: Virtual memory selector for a process
]

#slide(title: "Assembly Recap")[
  We can access certain bits of registers individually:

  #image("./figures/multi-access-register.png")

  This allows for backwards compatability

  32-bit programs can just use `eax`
]

#slide(title: "Assembly Recap")[
  - Each thread has its own set of registers and dedicated stack memory
  - Registers are faster than memory
  - Registers are limited in size
  - Switch between threads:
    - CPU context switches
    - Exchange registers on the executing core
]

#slide(title: "Assembly Recap")[
  Instruction format:

  ```asm
  <instruction_mnemonic>  <destination>, <source>
  mov    rax,            rbx
  ```

  -> Means move rbx to rax

  -> The compiler turns assembly into actual opcodes

  ```asm
  mov rax, rbx``` => 0x48, 0x89, 0xd8

  Online (dis)assembler: https://defuse.ca/online-x86-assembler.htm#disassembly
]

#slide(title: "Data Movement")[
  ```asm
  // Moves rbx into rax
  mov rax, rbx
  // Moves 0x4000 into rax
  mov rax, 0x4000
  // Moves the 8-byte value at the address of rbx into rax
  mov rax, [rbx]
  ```
  => rbx = 0x400000 `mov rax, [0x400000]`

  C equivalent:

  => `rax = *0x400000;`
]

#slide(title: "Arithmetics")[
  ```asm
  // Adds rbx to rax
  add rax, rbx
  // Substracts rbx from rax
  sub rax, rbx
  // ...
  xor rax, rbx
  // ...
  and rax, rbx
  ...
  ```
]

#slide(title: "Control Flow")[
  ```asm
  // Calls a function
  call function
  // Returns from a function to the next instruction
  ret
  ```
]

#slide(title: "Control Flow")[
  Example:

  ```asm
  call target
  // in target:
  => mov rax, 3
  => ret
  // back in caller:
  mov rbx, rax
  ```
  rbx = 3
]

#slide(title: "Control Flow")[
  ```asm
  // Always jump to address
  jmp address
  // Jump if not zero
  jnz address
  // Jump if equal
  je address
  // Jump if less or equal
  jle address
  ```
  => Based on EFLAGS (special registers)
]

#slide(title: "Control Flow")[
  ```asm
  cmp rax, rbx
  jle error
  ret
  ```

  Jump to error IF RAX \<= RBX

  Otherwise return from the function
]

#slide(title: "C to assembly")[
  ```c
  int x;
  x = 10;
  ```
  Becomes:
  ```asm
  mov rax, 10
  ```
  Not every C line is atomic in asm:

  x = x + 10;

  ```asm
  mov rbx, rax // temporary value
  add rbx, 10  // add 10
  mov rax, rbx // move temp back to x
  ```
]

#slide(title: "C to assembly")[
  C to asm in the browser: https://godbolt.org/#

  #split[
    #image("./figures/hello_world_c.png")
  ][
    #image("./figures/hello_world_asm.png")
  ]
]

#slide(title: "C to assembly")[
  #image("./figures/assembly.png", height: 100%)
]

#slide(title: "Rev 101")[
  - Analysis of a system, program or (obfuscated) source code

  - Often binary analysis

  - Find out what it's doing

  - Revertible, Exploitable?
]

#slide(title: "Real world usage")[
  #split(columns: (2fr, 1fr), align: horizon)[
    - Malware research

    - Bug hunting in consumer software & operating systems

    - Modding games

    - Cracking

    - Debugging
  ][
    #image("./figures/keygen.png", height: 100%)
  ]
]

#slide(title: "Executables")[
  - ELF
    - Executable and Linking Format (UNIX)

  - PE
    - Portable Executable (WINDOWS)

  - Tells our OS how to load and execute it

  - Contains Imports (Libraries), Exports, Sections, Entrypoint
]

#slide(title: "Tools for executables")[
  - UNIX:

    - file: Tries to determine the filetype

    - strings: Print all ascii strings in the file

    - hexdump: See raw bytes of the file

    - readelf: Parses the elf file and prints info

    - objdump: ELF infos & disassembly

  - Windows:

    - CFF Explorer/ Explorer Suite by NTCore
]

#slide(title: "Concepts")[
  - Static analysis

  - Dynamic analysis

    - Emulation/Tracing

  - Diffing

  - Patching

  - Sidechannels

  - Symbolic execution
]

#slide(title: "Static analysis")[
  - "Offline" analysis

  - Binary is not executed

  - Disassembler

    - Turns opcodes into asm instructions

    - `68 6e 2f 73 68` => `push 0x68732f6e`

  - Decompiler

    - Turn asm instructions into somewhat readable code
]

#slide(title: "Static tools")[
  - Native binaries:

    - Ghidra (Free, works well on most arches + languages)

    - Gui sucks => Cutter Plugin

    - IDA: Gold standard for x86, okayish on other arches

    - BinaryNinja: Mix of IDA and Ghidra

      - Especially good for newer languages such as Go and Rust
]

#slide(title: "Static tools cont")[
  - Python:

    - Pyinstxtractor

      - Extract bundled python files

    - Pycdc

      - Disassemble/Decompile python bytecode
]

#slide(title: "Static tools cont")[
  - Android APKs

    - Essentially Java

    - Jadx: GUI for apktool essentially

    - apktool: CLI to decompile/compile apks

    - github/patrickfav/uber-apk-signer: Automatically sign apks
]

#slide(title: "Static tools cont")[
  - .NET

    - DotPeek: Disassembler/Decompiler for .NET

    - ILSpy/dnspy : Same as above

    - github/Droppers/SingleFileExtractor: Extract .NET from native libraries
]

#slide(title: "Dynamic analysis")[
  - Run/emulate the binary and attach a debugger/tracer

  - Breakpoints

    - Addresses in memory where execution shall be paused

    - PAUSE IF = rip == TARGET

  - Prints infos about current registers/memory

  - Static analysis to find breakpoints
]

#slide(title: "Dynamic analysis")[
  - Single stepping / tracing

    - One instruction at a time, print infos
]

#slide(title: "Dynamic tools")[
  - Native:

    - strace/ltrace: Traces syscalls/library calls

    - GDB

    - pwndbg, gef

    - Emulators

      - QEMU

      - qiling

    - Inbuilt debuggers of decompilers

      - Supports breaking in pseudocode
]

#slide(title: "Dynamic tools cont")[
  - Android APKs:

    - Android Studio for emulation

    - FRIDA

  - .NET

    - JetBrains RIDER

      - Supports binary debugging

      - Disassembles automatically
]

#slide(title: "'Just run it lmao' - analysis")[
  - Running unknown executables

  - *Bad idea*

  - Even dockerfiles can be malicious

  - Insomnihack 23 (https://cryptax.github.io/2023/03/25/shame.html)

  - Always emulate unknown binaries in a sandbox or use a VM
]

#slide(title: "'Just run it lmao' - done right")[
  - Emulation

    - Works cross OS

  - Full system emulation

    - Qiling, QEMU System/Usermode

  - Instruction emulation

    - *No syscall support*

    - e.g. Unicorn Engine

    - Lots of manual work
]

#slide(title: "Diffing")[
  - Prerequisite: Static analysis

  - Needs 2+ program databases (e.g. from IDA)

  - BinDiff databases

  - Find matching functions/patterns

  - See newly added functions
]

#slide(title: "Diffing")[
  #image("./figures/bindiff.png")
]

#slide(title: "Patching")[
  - Modify instructions to get different behaviour

    - e.g. `jnz address` => `jz address`

  - Remove instructions by using NOPs

    - `mov eax, ebx` => `nop nop`

  - Used to bypass checks or security

  - What happens if we leak some infos by doing this?
]

#slide(title: "Sidechannels")[
  - Leak infos

  - Bruteforce inputs much faster e.g 26\*6 instead of 26\*\*6

  - Timing attacks

  or

  - CPU metric attacks

  - perf-tools on Linux
]

#slide(title: "Symbolic execution")[
  - Execute a program

  - Find all paths and values that satisfy each branching condition

  - Output inputs that satisfy certain branches
]

#slide(title: "Symbolic execution")[
  Given this function, how many paths are there?

  ```c
  int get_sign(int x) {
  if (x == 0)
    return 0;
  if (x < 0)
    return -1;
  else
    return 1;
  }
  ```
]

#slide(title: "Symbolic execution")[
  Three branching conditions, which inputs satisfy each path?

  ```c
  int get_sign(int x) {
  if (x == 0)
  ...
  if (x < 0)
  ...
  if (x > 0)
  ...
  }
  ```
]

#slide(title: "Symbolic execution tools")[
  - angr
    - Black box (works on binary level)

  - klee
    - White box (requires source code)

  - manticore (unmaintained)
    - Like angr black box, requires more fine tuning
]

#slide(title: "How2Start")[
  1. Run strings and gather infos about the binary

  2. What's the goal?

    - Want a key/input?

    - Optimization problem?

  3. Optional: Can we cheese it?

    - Sidechannels? Do we have an oracle?

    - Symbolic execution

    - Patching or info leaks?
]

#slide(title: "How2Start cont")[
  4. *Actually* reverse the binary and figure out the *actual* solution

  5. ???

  6. Validate solution
]

#standout-slide(title: "Live demo - cracking")

#title-slide()
