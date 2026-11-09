# Memory Operations and Data Types

Assembly has no data types. Memory is a flat array of bytes, and "type" is nothing but the size an
instruction chooses to read and whether it treats the top bit as a sign. Every type system you have
used in a high-level language is a compile-time fiction layered over this.

That fiction is also where a large share of security bugs live. If types are only a convention, then
nothing at the machine level prevents reading eight bytes out of a four-byte variable, or writing
past the end of an array. This lecture covers how data is laid out, how instructions reach it, and
what goes wrong at the boundaries.

## 3.1 Sizes and Names

x86-64 operand sizes have both a NASM keyword and a traditional name:

| Bits | Bytes | NASM size | NASM reserve | Define directive | C equivalent (Linux) |
| ---- | ----- | --------- | ------------ | ---------------- | -------------------- |
| 8    | 1     | `byte`    | `resb`       | `db`             | `char`               |
| 16   | 2     | `word`    | `resw`       | `dw`             | `short`              |
| 32   | 4     | `dword`   | `resd`       | `dd`             | `int`                |
| 64   | 8     | `qword`   | `resq`       | `dq`             | `long`, any pointer  |

"Word" means 16 bits on x86 for historical reasons, even though the machine is 64-bit. This is a
permanent source of confusion when reading documentation across architectures, where "word" usually
means the native register width.

## 3.2 Endianness

x86-64 is **little-endian**: a multi-byte value is stored with its least significant byte at the
lowest address.

```text
    value 0x1122334455667788 stored at address 0x1000:

    address  0x1000 0x1001 0x1002 0x1003 0x1004 0x1005 0x1006 0x1007
    byte       88     77     66     55     44     33     22     11
               ^ least significant                        most significant ^
```

Two practical consequences:

- A hex dump of memory reads "backwards" relative to how you wrote the number. The address
  `0x00000000004011b6` appears in a dump as `b6 11 40 00 00 00 00 00`.
- The low byte of a value is at the same address as the whole value. That is why `mov al, [rsi]`
  and `mov rax, [rsi]` start at the same place, and why a one-byte overwrite at a pointer's lowest
  address changes the pointer by a small amount rather than a huge one, which is the basis of
  partial overwrite techniques.

In `gdb`, `x/8xb $rsi` shows the raw byte order and `x/1xg $rsi` shows the assembled 64-bit value.
Comparing the two outputs on the same address is the fastest way to make endianness stop being
confusing.

## 3.3 Addressing Modes

A memory operand is written in brackets and may combine up to four parts:

```text
    [ base + index * scale + displacement ]

    base         a register
    index        a register
    scale        1, 2, 4 or 8 only
    displacement a constant
```

Every part is optional, so all of these are valid:

```asm
        mov     rax, [rbx]                  ; dereference a pointer
        mov     rax, [rbx + 8]              ; field at offset 8 in a struct
        mov     rax, [rbx + rcx*8]          ; element rcx of an array of qwords
        mov     rax, [arr + rcx*4]          ; element rcx of a dword array at a fixed label
        mov     rax, [rbp - 24]             ; a local variable in the current stack frame
        mov     rax, [rip + 0x2f41]         ; position-independent reference to global data
```

The scale is restricted to 1, 2, 4 and 8 because those are the sizes of the primitive types. A
disassembled `[rbx + rcx*8]` therefore tells you two things at once: `rbx` is an array of 8-byte
elements, and `rcx` is an index, not a pointer. Reading element sizes out of the scale factor is one
of the fastest ways to reconstruct data structures from a stripped binary.

`[rip + disp]` is worth special attention. Position-independent executables, which are the default
on modern Linux, reach their own globals relative to the instruction pointer rather than by absolute
address. `objdump` helpfully resolves these and annotates the target.

## 3.4 Declaring Data

```asm
section .rodata                         ; read-only, mapped without write permission
pi:         dq  3.14159                 ; a double
greeting:   db  "hello", 0              ; NUL-terminated C string
primes:     dd  2, 3, 5, 7, 11          ; array of five dwords
nprimes:    equ ($ - primes) / 4        ; assembler-time arithmetic, not a variable

section .data                           ; writable, initialised
counter:    dq  0

section .bss                            ; writable, zero-filled at load, takes no file space
buffer:     resb 64                     ; 64 uninitialised bytes
table:      resq 16                     ; 16 qwords
```

`equ` defines an assembler-time constant: `nprimes` exists only while assembling and occupies no
memory. `$` is the current address, so `$ - primes` is the byte length of what was just emitted.
This idiom keeps a length in sync with its data automatically, which beats hardcoding a number that
will later drift out of date.

Choosing the right section is a security decision, not a stylistic one. Constants in `.rodata` are
mapped read-only, so a bug elsewhere in the program cannot corrupt them; the same constants placed
in `.data` are writable for the whole life of the process. `readelf -S ./prog` prints the flags, and
the `W` flag is the one to look for.

## 3.5 The Stack

The stack is a region of memory that grows **downward**, toward lower addresses, and is managed by
`rsp`. Two instructions operate on it implicitly:

```asm
        push    rax             ; rsp -= 8, then store rax at [rsp]
        pop     rbx             ; load [rsp] into rbx, then rsp += 8
```

`push` and `pop` always move `rsp` by 8 in 64-bit mode. Pushing and popping must balance; a
function that pushes three registers and pops two leaves `rsp` wrong and will almost certainly crash
on `ret`, because the stale value at `[rsp]` is not a return address.

Space for several locals at once is allocated by adjusting `rsp` directly, which is what a compiler
emits:

```asm
        sub     rsp, 48                 ; reserve 48 bytes
        mov     qword [rsp], 0          ; use it
        mov     dword [rsp + 8], 7
        ...
        add     rsp, 48                 ; release it
```

### 3.5.1 Alignment

The System V AMD64 ABI requires `rsp` to be 16-byte aligned immediately before a `call`. Most
integer code does not care, but SSE instructions such as `movaps` fault on a misaligned address, and
the standard library uses them freely, including inside `printf`. A handwritten assembly program
that calls into libc with a misaligned stack crashes in a way that looks unrelated to its actual
cause. If an otherwise correct program segfaults inside a library function, check the alignment
first.

## 3.6 Working With Buffers

A string copy loop makes the type-free nature of memory concrete:

```asm
; copy the NUL-terminated string at rsi into the buffer at rdi.
; NOTE: no length limit. This is the bug, shown deliberately.
copy_unbounded:
.loop:
        mov     al, [rsi]               ; read one byte
        mov     [rdi], al               ; write one byte
        inc     rsi
        inc     rdi
        test    al, al                  ; was it the terminator?
        jnz     .loop
        ret
```

Nothing in this loop knows how large the destination is. The destination size is not represented
anywhere in the machine code, because size is not a property memory has. If the source string is
longer than the destination buffer, the loop keeps writing into whatever follows it: other locals,
a saved frame pointer, a return address. That is a stack buffer overflow, and it is the same
defect as C's `strcpy`.

The bounded version carries the limit explicitly, as a value in a register:

```asm
; copy at most rdx bytes from rsi to rdi, always NUL-terminating.
copy_bounded:
        test    rdx, rdx
        jz      .done                   ; a zero-size destination has no room even for NUL
        dec     rdx                     ; reserve one byte for the terminator
.loop:
        test    rdx, rdx
        jz      .terminate
        mov     al, [rsi]
        test    al, al
        jz      .terminate
        mov     [rdi], al
        inc     rsi
        inc     rdi
        dec     rdx
        jmp     .loop
.terminate:
        mov     byte [rdi], 0
.done:
        ret
```

The difference between the two is one register that the programmer chose to maintain. There is no
hardware support for it.

### 3.6.1 What Stops the Unbounded Version

Memory-safety defences work at several layers, and in a security assessment you should be able to
name which layer each belongs to:

- **Source level.** Use APIs that take a destination size (`snprintf`, `strlcpy`, `memcpy_s`) or a
  language with bounds checking. This removes the bug class rather than mitigating it.
- **Compiler level.** Stack canaries (`-fstack-protector-strong`) detect a linear overwrite of the
  return address before `ret` uses it. `-D_FORTIFY_SOURCE=3` adds runtime size checks to known
  libc calls, and `-fsanitize=address` catches out-of-bounds access in testing.
- **Loader and hardware level.** NX makes the stack non-executable, ASLR and PIE randomise
  addresses, and RELRO makes the relocation tables read-only after startup.
- **Audit level.** `checksec --file=./prog` (from the `pwntools` suite, or the standalone
  `checksec` script) reports which of these are enabled for a given binary. Running it on the
  binaries in your lab is a quick, concrete exercise.

None of the lower layers fixes the defect. They raise the cost of exploiting it. The fix is the
bound.

## 3.7 Inspecting Memory in the Debugger

`gdb`'s `x` command takes a repeat count, a format letter and a size letter:

```bash
(gdb) x/16xb $rsp        # 16 bytes, hex
(gdb) x/8xg $rsp         # 8 giant words (8 bytes each), hex
(gdb) x/4xw $rsp         # 4 words (4 bytes each), hex
(gdb) x/s  $rsi          # NUL-terminated string
(gdb) x/5i $rip          # 5 instructions
(gdb) x/8dg $rsp         # as signed decimal
```

Size letters are `b` (1), `h` (2), `w` (4) and `g` (8). Note that `w` is 4 bytes here, not the
x86 2-byte "word". Also useful:

```bash
(gdb) info proc mappings     # the real address space of the running process
(gdb) p sizeof(long)         # with debug info present
(gdb) watch -l *0x7ffd1234   # break when that address is written
```

A watchpoint on a stack address is the most direct way to find out *which instruction* corrupted a
value, rather than inferring it from the crash site.

## 3.8 Exercises

In your own lab VM only.

1. Store `0xDEADBEEF` as a `dd` in `.data`, then print its four bytes with `x/4xb` in `gdb`.
   Explain the order you see.
2. Build an array of ten qwords in `.bss` and write a loop that fills element `i` with `i*i`,
   using a single `[base + index*8]` operand. Verify with `x/10dg`.
3. Assemble the `copy_unbounded` routine above with a 16-byte destination in `.bss` and a 40-byte
   source string. Watch the write go past the end with a `gdb` watchpoint on the first byte beyond
   the buffer. Then do the same with `copy_bounded` and confirm it stops.
4. Run `checksec --file=/bin/ls` and `readelf -S /bin/ls`, and write one sentence per protection
   explaining what it would stop.
5. Deliberately leave `rsp` misaligned by 8 before calling `printf` from assembly, and record where
   it crashes. Then fix the alignment and compare.

## Key Takeaways

- Memory is untyped bytes. Size comes from the instruction, signedness from the choice of `movzx`
  versus `movsx`. There is no type checking at runtime.
- x86-64 is little-endian: the least significant byte sits at the lowest address.
- A memory operand is `[base + index*scale + disp]` with scale restricted to 1, 2, 4 or 8. The
  scale reveals element size when reconstructing data structures.
- `.rodata` is mapped read-only, `.data` is writable, `.bss` is zero-filled and costs nothing in
  the file. Section choice is a hardening decision.
- The stack grows downward. `push`/`pop` move `rsp` by 8, and they must balance or `ret` returns to
  garbage.
- The ABI requires 16-byte stack alignment at a `call`. Violating it crashes inside library
  functions, far from the real cause.
- A buffer's size exists nowhere in the machine code. Bounds are a value the programmer chooses to
  carry; canaries, NX, ASLR and RELRO only raise the cost of exploiting a missing bound.

## Resources

- *System V ABI, AMD64 Architecture Processor Supplement*, data layout and stack alignment rules:
  <https://gitlab.com/x86-psABIs/x86-64-ABI>
- NASM Manual, chapter 3.2 (pseudo-instructions `db`, `resb`, `equ`): <https://www.nasm.us/doc/>
- GDB manual, "Examining Memory": <https://sourceware.org/gdb/current/onlinedocs/gdb/>
- CWE-787: Out-of-bounds Write: <https://cwe.mitre.org/data/definitions/787.html>
- CWE-121: Stack-based Buffer Overflow: <https://cwe.mitre.org/data/definitions/121.html>
- `man 3 strlcpy`, `man 3 snprintf`, `man 7 feature_test_macros`
