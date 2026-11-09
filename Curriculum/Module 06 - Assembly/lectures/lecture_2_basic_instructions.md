# Basic Assembly Instructions

The x86-64 instruction set documents well over a thousand instructions. A compiler emits perhaps
fifty of them for ordinary code, and roughly twenty account for the large majority of what you will
read. This lecture covers that working set: moving data, arithmetic, bitwise logic, shifts, and the
flags that comparisons leave behind.

## 2.1 Instruction Anatomy

Almost every instruction in this lecture has the same shape:

```text
    mnemonic   destination, source
    ^          ^            ^
    what to do  written to   read from
```

The destination is written first in Intel syntax, and in a two-operand instruction the destination
is usually also an input. `add rax, rbx` means `rax = rax + rbx`, not `rax = rbx`.

Operands come in three kinds: a **register** (`rax`), an **immediate** constant (`42`), or a
**memory reference** in brackets (`[rbx]`). x86-64 allows at most one memory operand per
instruction, which is why `mov [rax], [rbx]` is not a legal instruction and the assembler rejects
it. Copying memory to memory takes two instructions and a register in between.

## 2.2 Moving Data

`mov` is by far the most common instruction in any binary.

```asm
        mov     rax, 10         ; register <- immediate
        mov     rbx, rax        ; register <- register
        mov     rcx, [rsi]      ; register <- 8 bytes at the address in rsi
        mov     [rdi], rcx      ; memory <- register
        mov     byte [rdi], 0   ; memory <- immediate, size stated explicitly
```

The size qualifier (`byte`, `word`, `dword`, `qword`) is required whenever the operand sizes are
otherwise ambiguous, which in practice means whenever an immediate is written into memory. The
assembler cannot guess whether `mov [rdi], 0` should clear one byte or eight.

Two near-relatives of `mov` are worth knowing immediately:

```asm
        xchg    rax, rbx        ; swap the two, no temporary needed
        movzx   rax, byte [rsi] ; load one byte, zero-extend to 64 bits
        movsx   rax, byte [rsi] ; load one byte, sign-extend to 64 bits
```

The choice between `movzx` and `movsx` is a *type* decision made visible. `movzx` is an unsigned
load, `movsx` a signed one. Loading `0xFF` with `movzx` gives 255; with `movsx` it gives -1. When
you see one of these in disassembly, it tells you how the original source declared the variable:
`unsigned char` versus `char`. A mismatch between the load used and the comparison applied is a
classic source of sign-confusion bugs.

### 2.2.1 The Idioms You Will See Instead of `mov`

Compilers emit shorter encodings for common cases, and a reader who does not recognise them loses
time:

```asm
        xor     eax, eax        ; eax = 0. Shorter than "mov eax, 0" and sets ZF.
        test    rax, rax        ; compare rax against zero without changing it
        sub     rsp, 32         ; reserve 32 bytes of stack space
        lea     rax, [rbx+8]    ; rax = rbx + 8, with no memory access at all
```

`lea` ("load effective address") is the one to watch. It computes an address and stores the
*number*, never touching memory. Compilers abuse it as a three-operand adder and multiplier:

```asm
        lea     rax, [rdi + rdi*2]      ; rax = rdi * 3
        lea     rax, [rdi*8 + 7]        ; rax = rdi * 8 + 7
        lea     rax, [rdi + rsi*4]      ; rax = rdi + rsi*4, rdi and rsi preserved
```

If you read `lea` as a memory access you will misread half the arithmetic in an optimised binary.

## 2.3 Arithmetic

```asm
        add     rax, rbx        ; rax = rax + rbx
        sub     rax, 4          ; rax = rax - 4
        inc     rax             ; rax = rax + 1
        dec     rax             ; rax = rax - 1
        neg     rax             ; rax = -rax
        imul    rax, rbx        ; signed multiply, rax = rax * rbx
```

Division is the irregular one. `idiv` takes a single operand, the divisor, and uses a fixed
register pair as the dividend:

```asm
        mov     rax, 17
        cqo                     ; sign-extend rax into rdx:rax (128-bit dividend)
        mov     rcx, 5
        idiv    rcx             ; rax = quotient (3), rdx = remainder (2)
```

Forgetting `cqo` (or `xor edx, edx` for the unsigned `div`) leaves garbage in `rdx` and produces a
wrong result or a divide-error exception. This is the single most common mistake in handwritten
x86-64 arithmetic.

### 2.3.1 Arithmetic Wraps Silently (and That Is Exploitable)

Registers are fixed-width, so arithmetic is modular. An 8-bit addition of 255 + 1 gives 0; a 64-bit
addition of `0xFFFFFFFFFFFFFFFF + 1` gives 0. The CPU records the overflow in a flag and otherwise
carries on.

```asm
        mov     al, 255
        add     al, 1           ; al = 0, CF = 1, ZF = 1
```

In C this is where integer-overflow vulnerabilities come from. A length check written as
`if (len + 16 < bufsize)` can pass when `len` is large enough to wrap the addition, after which the
copy that follows is unbounded. At the assembly level the overflow is plainly visible: the `add`
sets the carry flag and the subsequent `jb`/`jae` ignores it.

The defensive counterpart is to check before computing, not after: compare `len` against
`bufsize - 16` rather than computing `len + 16`, use the compiler's checked-arithmetic builtins
(`__builtin_add_overflow`), or build with `-ftrapv` or UBSan's `-fsanitize=integer` during testing
so a wrap aborts instead of proceeding quietly.

## 2.4 Bitwise Logic

```asm
        and     rax, 0x0F       ; keep the low 4 bits, clear the rest  (mask)
        or      rax, 0x80       ; set bit 7                            (set flag)
        xor     rax, rbx        ; bitwise exclusive-or
        not     rax             ; invert every bit
        test    rax, 0x04       ; AND, set flags, discard the result   (test a bit)
```

`and` masks, `or` sets, `xor` toggles, `test` inspects. A permission check in compiled code is
almost always `test` followed by a conditional jump.

`xor` with a repeating key is also the most common obfuscation in malware, because it is one
instruction, self-inverse, and needs no library. A loop of `xor byte [rsi+rcx], 0x5A` over a region
is a strong hint you have found a decoding stub and that the plaintext appears in memory
immediately after it runs. That is why dynamic analysis in a sandbox beats static string
extraction on packed samples.

## 2.5 Shifts and Rotates

```asm
        shl     rax, 3          ; logical shift left  -> multiply by 8
        shr     rax, 1          ; logical shift right -> unsigned divide by 2
        sar     rax, 1          ; arithmetic shift right, keeps the sign bit
        rol     rax, 8          ; rotate left, bits wrap around
        ror     rax, 8          ; rotate right
```

`shr` and `sar` differ only in what fills the vacated high bits: `shr` fills with zeros, `sar`
copies the sign bit. For a negative number they give different answers, so seeing `sar` tells you
the source variable was signed.

Compilers replace multiplication and division by powers of two with shifts, so `shl rax, 5` in a
disassembly is usually a `* 32` in the original source. Rotates are rare in compiled C and common
in cryptographic code: `rol`/`ror` in a tight loop over a 32-bit state is a reasonable fingerprint
for a hash or block cipher implementation.

## 2.6 The Flags Register

Most arithmetic and logic instructions update `rflags` as a side effect. Four flags carry nearly all
the weight:

| Flag | Name      | Set when                                                     |
| ---- | --------- | ------------------------------------------------------------ |
| `ZF` | Zero      | The result was exactly zero                                  |
| `SF` | Sign      | The most significant bit of the result is 1 (negative if signed) |
| `CF` | Carry     | An unsigned operation carried or borrowed out of the top bit |
| `OF` | Overflow  | A signed operation produced a result of the wrong sign       |

`CF` is the unsigned overflow indicator and `OF` the signed one. They are separate flags because the
same bit pattern means different things depending on signedness, and the CPU does not know which
interpretation the programmer intended.

### 2.6.1 Setting Flags Without Keeping a Result

Two instructions exist purely to set flags:

```asm
        cmp     rax, rbx        ; computes rax - rbx, keeps only the flags
        test    rax, rax        ; computes rax AND rax, keeps only the flags
```

`cmp` is a subtraction whose result is thrown away; `test` is an `and` whose result is thrown away.
`cmp a, b` followed by a conditional jump is the compiled form of every relational operator in a
high-level language, and `test rax, rax` followed by `jz` is the compiled form of `if (x == 0)` or a
null-pointer check.

Flags are volatile. Any intervening arithmetic instruction overwrites them, so a `cmp` and the jump
that reads it are nearly always adjacent. `mov` is the useful exception: it does **not** touch
flags, which is why a compiler can legally schedule a `mov` between a `cmp` and its `jcc`.

Lecture 4 uses these flags to build every control structure.

## 2.7 Reading Flags in the Debugger

The fastest way to internalise flags is to watch them change.

```asm
; flags.asm -- build: nasm -f elf64 flags.asm -o flags.o && ld flags.o -o flags
section .text
global _start
_start:
        mov     rax, 5
        mov     rbx, 5
        cmp     rax, rbx        ; expect ZF set
        mov     rax, 3
        cmp     rax, rbx        ; expect SF set, ZF clear
        mov     al, 255
        add     al, 1           ; expect CF set, ZF set
        mov     rax, 60
        xor     edi, edi
        syscall
```

```bash
nasm -f elf64 flags.asm -o flags.o && ld flags.o -o flags
gdb ./flags
(gdb) starti
(gdb) info registers eflags
(gdb) stepi            # repeat, watching eflags after each cmp and add
```

`gdb` prints the flags symbolically as `[ ZF PF ]` and similar, which is easier to read than the raw
hex value. Step until you have seen `ZF`, `SF` and `CF` each appear and disappear.

## 2.8 Exercises

Run all of these in your own lab VM.

1. Write a program that computes `(7 * 6) - 2` using `imul` and `sub`, and returns the result as
   the process exit status. Verify with `echo $?`.
2. Replace the `imul` with a sequence of `lea` and/or `shl` instructions that computes the same
   value. Compare the instruction counts with `objdump -d`.
3. Write the smallest program you can that sets `CF` and `OF` at the same time, and confirm both in
   `gdb`.
4. Compile this C function with `gcc -O2 -S -masm=intel -c`, then explain every instruction:

   ```c
   int f(unsigned x) { return (x * 9) >> 2; }
   ```

   Where did the multiply go?
5. Take a small C function of your own, build it at `-O0` and at `-O2`, and diff the two
   disassemblies. Which of the idioms from section 2.2.1 appeared only at `-O2`?

## Key Takeaways

- Intel syntax is `mnemonic destination, source`, and in two-operand arithmetic the destination is
  also an input.
- At most one operand may be a memory reference; memory-to-memory moves require a register.
- `lea` computes an address as a number and never accesses memory. Compilers use it for arithmetic.
- `movzx` and `movsx` encode signedness in the load. A mismatch with the later comparison is a real
  bug class.
- `idiv` and `div` need `rdx` prepared first, with `cqo` or `xor edx, edx` respectively.
- Register arithmetic wraps silently. `CF` records unsigned overflow, `OF` signed overflow, and
  ignoring them is how integer-overflow vulnerabilities reach a memory copy.
- `cmp` and `test` exist only to set flags; `mov` is notable for leaving flags alone.
- `xor` loops and `rol`/`ror` loops are useful fingerprints for obfuscation and cryptography
  respectively.

## Resources

- Felix Cloutier's x86 and amd64 instruction reference: <https://www.felixcloutier.com/x86/>
- Intel 64 and IA-32 Architectures Software Developer Manual, Volume 2: <https://www.intel.com/sdm>
- NASM Manual, chapter 3 (the NASM language): <https://www.nasm.us/doc/>
- *Compiler Explorer*, for watching C turn into instructions interactively: <https://godbolt.org>
- CWE-190, Integer Overflow or Wraparound: <https://cwe.mitre.org/data/definitions/190.html>
