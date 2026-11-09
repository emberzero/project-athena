#import "../../../typst-theme-emberzero/1.1.0/src/lib.typ": *

#show: athena-theme.with(
  font: "Berkeley Mono",
  config-info(
    title: [Module 06: Assembly],
    subtitle: [Reading x86-64 the way an analyst must],
    authors: [*Project Athena*],
    extra: [],
    footer: [Module 06 - Assembly],
  ),
  config-common(
    handout: false,
  ),
)

#title-slide()

#section-slide(title: "Introduction")

#slide(title: "Why Assembly in Security")[
  The machine code is the only version of a program guaranteed to
  exist. Source may be gone, comments may lie, the binary cannot.

  - *Reverse engineering* malware, firmware, commercial software
  - *Vulnerability analysis*: see which register holds the length
  - *Exploit and mitigation*: canaries, NX, ASLR live here
  - *Detection engineering*: signatures and YARA on instructions

  You read it fluently; you write short, deliberate pieces.
]

#slide(title: "The Machine Model")[
  An x86-64 user-space program sees a small world:

  - *Registers*: a few dozen 64-bit slots inside the CPU
  - A flat *address space* of bytes, reached by address
  - The *instruction pointer* `rip`: the next instruction
  - The *flags register* `rflags`: result of the last compare

  An instruction reads registers or memory, computes, and writes
  a register, memory, the flags, or `rip`. That is the whole
  machine. A Linux *syscall* takes its number in `rax` and
  arguments in `rdi`, `rsi`, `rdx`, `r10`, `r8`, `r9`.
]

#slide(title: "General-Purpose Registers")[
  #table(
    columns: (auto, auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*64-bit*], [*Low 32*], [*Conventional role*],
    [`rax`], [`eax`], [return value, syscall number],
    [`rdi`, `rsi`], [`edi`, `esi`], [1st and 2nd argument],
    [`rdx`, `rcx`], [`edx`, `ecx`], [3rd and 4th argument],
    [`rsp`], [`esp`], [stack pointer, never scratch],
    [`rbp`], [`ebp`], [frame pointer],
  )

  Writing a *32-bit* name zeroes the upper 32 bits: `mov eax, 1`
  leaves `rax` = 1. Writing 16- or 8-bit names does not.
]

#slide(title: "The Process Address Space")[
  #align(center, image("../lectures/images/memory-layout.svg", width: 36%))

  Permissions matter more than order: `.text` is executable, not
  writable; stack and heap are writable, *not executable* (NX).
  ASLR randomises addresses each run.
]

#slide(title: "The Toolchain")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [`nasm`], [assembler: source to object file],
    [`ld`, `gcc`], [linker: object files to executable],
    [`objdump`], [disassembler: executable to assembly],
    [`gdb`], [debugger: run one instruction at a time],
  )

  Two syntaxes for one ISA. This module uses *Intel* throughout
  (`mov rax, 60`, destination first), not AT&T. Configure every
  tool the same way, or you will misread operand order.
]

#slide(title: "What the Disassembler Cannot Recover")[
  Assembling discards information permanently.

  - Instructions recovered *exactly*
  - Label names, comments, variable names, types: *gone*
  - A stripped binary (`strip`, `gcc -s`) loses function names
    too, leaving you to name `sub_401136` by hand

  #cblock(title: [Compilation is not encryption])[
    "We compiled it, so nobody can read it" is a false sense of
    security. The behaviour is fully preserved.
  ]
]

#section-slide(title: "Basic Instructions")

#slide(title: "Moving Data")[
  ```asm
  mov     rax, 10         ; register <- immediate
  mov     rcx, [rsi]      ; register <- 8 bytes at [rsi]
  movzx   rax, byte [rsi] ; load, zero-extend (unsigned)
  movsx   rax, byte [rsi] ; load, sign-extend (signed)
  lea     rax, [rdi+rdi*2]; rax = rdi*3, no memory access
  ```

  At most *one* memory operand per instruction. `movzx` vs
  `movsx` encodes signedness; a mismatch with the later compare
  is a real bug class. `lea` computes an address as a *number*,
  which compilers abuse as an adder and multiplier: read it as a
  memory access and you misread half the arithmetic.
]

#slide(title: "Arithmetic Wraps Silently")[
  Registers are fixed-width, so arithmetic is modular.

  ```asm
  mov     al, 255
  add     al, 1           ; al = 0, CF = 1, ZF = 1
  ```

  In C this is where integer-overflow bugs come from: a check
  like `if (len + 16 < bufsize)` passes when `len` wraps the
  addition, and the copy that follows is unbounded.

  *Fix:* check before computing (`len < bufsize - 16`), or use
  checked-arithmetic builtins and `-ftrapv` in testing.
]

#slide(title: "Flags and the cmp/test Idiom")[
  Most arithmetic updates `rflags`. Four flags carry the weight:
  `ZF` (zero), `SF` (sign), `CF` (unsigned overflow), `OF`
  (signed overflow).

  ```asm
  cmp     rax, rbx    ; rax - rbx, keep only flags
  test    rax, rax    ; rax AND rax, keep only flags
  ```

  `cmp` is a subtraction thrown away; `test rax, rax` + `jz` is
  the compiled `if (x == 0)`. Flags are volatile, so `cmp` and
  its jump are nearly always adjacent. `mov` leaves flags alone.
]

#section-slide(title: "Memory and Data Types")

#slide(title: "Sizes and Endianness")[
  #split(
    [
      *Sizes*
      - `db` byte, 1
      - `dw` word, 2
      - `dd` dword, 4
      - `dq` qword, 8

      "Word" is 16 bits on x86 for historical reasons.
    ],
    [
      *Little-endian*
      ```text
      0x1122...7788 at 0x1000:
      88 77 66 55 44 33 22 11
      ```
      Least significant byte at the lowest address, so a dump
      reads "backwards".
    ],
  )
]

#slide(title: "Addressing Modes")[
  ```text
  [ base + index * scale + displacement ]
      scale is 1, 2, 4 or 8 only
  ```

  ```asm
  mov     rax, [rbx + 8]        ; struct field at +8
  mov     rax, [rbx + rcx*8]    ; array of qwords
  mov     rax, [rbp - 24]       ; a local variable
  mov     rax, [rip + 0x2f41]   ; PIE global
  ```

  The scale reveals element size: `[rbx + rcx*8]` means `rbx` is
  an array of 8-byte elements and `rcx` is the index. Reading
  scale factors reconstructs data structures from stripped code.
]

#slide(title: "The Stack Grows Down")[
  ```asm
  push    rax         ; rsp -= 8, store rax at [rsp]
  pop     rbx         ; load [rsp], rsp += 8
  sub     rsp, 48     ; reserve 48 bytes of locals
  ```

  `push`/`pop` move `rsp` by 8 and must *balance*, or `ret`
  returns to garbage. The ABI requires `rsp` 16-byte aligned
  before a `call`: violate it and the program crashes *inside*
  libc on an SSE instruction, far from the real cause.
]

#slide(title: "A Buffer's Size Lives Nowhere")[
  ```asm
  copy_unbounded:        ; the bug, shown deliberately
  .loop:
          mov     al, [rsi]
          mov     [rdi], al
          inc     rsi
          inc     rdi
          test    al, al
          jnz     .loop
  ```

  Nothing knows how large the destination is. Size is not a
  property memory has. A too-long source overwrites other locals,
  the saved frame pointer, the return address. This is `strcpy`.
]

#slide(title: "What Stops the Overflow")[
  Name the layer each defence belongs to:

  - *Source*: size-taking APIs (`snprintf`, `strlcpy`). Removes
    the bug class.
  - *Compiler*: stack canaries, `-D_FORTIFY_SOURCE`, ASan
  - *Loader/hardware*: NX, ASLR, PIE, RELRO
  - *Audit*: `checksec --file=./prog` reports which are on

  None of the lower layers fixes the defect. They raise the cost.
  The fix is the bound.
]

#section-slide(title: "Control Structures")

#slide(title: "One Mechanism: Change rip")[
  #align(center, image("../lectures/images/branch-cfg.svg", width: 40%))

  A conditional jump tests flags set by a `cmp` or `test`. If the
  condition holds, `rip` becomes the target; else execution
  continues. There is no third option.

  Compiled conditionals *invert* the source: "if x == 10, do A"
  becomes "if x != 10, skip A". Read a branch as "skip the next
  block when ...".
]

#slide(title: "Signed and Unsigned Jumps")[
  After `cmp a, b`:

  #table(
    columns: (auto, auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [*Signed*], [*Unsigned*], [*Meaning*],
    [`je` / `jne`], [`je` / `jne`], [equal / not equal],
    [`jl` / `jg`], [`jb` / `ja`], [less / greater],
    [`jle` / `jge`], [`jbe` / `jae`], [less-eq / greater-eq],
  )

  Signed uses `l`/`g` and reads `SF`, `OF`; unsigned uses `b`/`a`
  and reads `CF`. Picking `jg` where `ja` was needed lets
  `0xFFFFFFFF` pass a length check as `-1`. That is a
  vulnerability, not a style issue.
]

#slide(title: "Branchless and Constant Time")[
  Compilers avoid jumps because a misprediction is expensive:

  ```asm
          cmp     dword [x], 0
          mov     rax, rbx        ; assume b
          cmovg   rax, rcx        ; take a if x > 0
  ```

  `cmovcc` and `setcc` never change `rip`.

  #cblock(title: [A security dimension])[
    A data-dependent *branch* leaks through timing; a
    data-dependent *move* does not. A plain `jne` inside a
    password or MAC compare is a genuine finding.
  ]
]

#slide(title: "Loops and Jump Tables")[
  - A *sentinel loop* (walking a NUL-terminated string) has no
    upper bound; a missing terminator reads out of bounds. This
    is a family of OOB-read bugs; length-taking APIs remove it.
  - A dense `switch` becomes a *jump table* guarded by one
    *unsigned* bounds check:

  ```asm
          cmp     edi, 3
          ja      .default        ; catches negatives too
          jmp     [table + rdi*8] ; indirect jump
  ```

  That one check is the whole safety. Indirect branches are what
  CFI and Intel CET constrain.
]

#section-slide(title: "Procedures and Functions")

#slide(title: "call and ret")[
  ```asm
          call    my_func   ; push return addr, then jmp
  my_func:
          ret               ; pop an address into rip
  ```

  `ret` does *not* verify anything. It transfers control to
  whatever 64-bit value is at `[rsp]`. If that was overwritten,
  control goes there instead. This is not a flaw in `ret`; it is
  the entire mechanism, and the reason the return address is the
  most valuable target on the stack.
]

#slide(title: "System V AMD64 Convention")[
  #table(
    columns: (auto, 1fr),
    inset: 6pt,
    stroke: 0.5pt + gray,
    [Integer args], [`rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`],
    [Return value], [`rax`],
    [Callee-saved], [`rbx`, `rbp`, `r12`--`r15`],
    [Caller-saved], [`rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`--`r11`],
  )

  Callee-saved registers must survive a call; caller-saved must
  be assumed destroyed. The *syscall* convention differs: 4th
  argument in `r10`, and `syscall` clobbers `rcx` and `r11`.
]

#slide(title: "The Stack Frame")[
  #align(center, image("../lectures/images/stack-frame.svg", width: 36%))

  Local buffers sit *below* the saved `rbp` and the return
  address, and an overflow grows *upward* toward them. Control
  data and user data share one writable region.
]

#slide(title: "Defences on the Return Address")[
  Each attacks a different step:

  - *Stack canaries*: a secret between locals and saved
    registers, checked before `ret`. Catch contiguous overwrites.
  - *NX/DEP*: injected code in a buffer cannot run
  - *ASLR/PIE*: no hardcoded target
  - *Shadow stacks* (Intel CET): `ret` finally authenticates
  - *RELRO*: the GOT is read-only after startup

  `checksec --file=./prog` reports which are enabled.
]

#slide(title: "Recursion Is a DoS Surface")[
  Each call consumes a frame; the stack is finite (about 8 MB).

  ```asm
  factorial:
          cmp     rdi, 1
          jbe     .base
          push    rdi         ; rdi is caller-saved
          dec     rdi
          call    factorial
          pop     rdi
          imul    rax, rdi
          ret
  ```

  Unbounded recursion on attacker-controlled input (nested JSON,
  deep XML) exhausts the stack and crashes. Fix with an explicit
  depth limit.
]

#standout-slide(title: [Control data and user data share one
  writable region, and ret does not authenticate its target.])
