# Assignment 1: Writing and Reading x86-64 Assembly

## Objective

You will write, assemble and debug your own x86-64 assembly programs, and you will read machine code
back out of a compiled binary and explain what every instruction does. Afterwards you will be able to
hand-write a short routine that follows the System V calling convention, locate a stack frame and its
return address in `gdb`, and tell from a disassembly what the compiler did to the original source.

## Logistics

- **Work:** individual. Discussing concepts is fine; your code, your `gdb` output and your text must
  be your own.
- **Deadline:** *set by your instructor*.
- **Submission:** one PDF, named `Lastname_Firstname_Module06_Assignment1.pdf`, plus your `.asm` and
  `.c` source files (as a plain `.zip`, or inline in the PDF if your instructor prefers).
- Every program in this assignment is written and run **inside your own Linux VM**. Nothing here
  touches a network, a school system or anyone else's machine. The legal framing from Module 01 and
  StGB §118a, §126a and §126b applies anyway: run code you wrote on hardware you control.

## Your personal identifier

Several tasks below use **your username**, defined as the first letter of your first name plus your
last name, lowercase, no special characters.

Example: Max Mustermann becomes `mmustermann`.

Your username appears in your program output and in your debugger screenshots. This makes your
submission unique: an answer copied from a classmate will show the wrong string.

## Setup

Everything is free and open source.

1. A **Linux x86-64 VM** (Debian 12 or Ubuntu 24.04 is fine) in VirtualBox, VMware, UTM, WSL2 or a
   container. ARM Macs: use an x86-64 VM or a remote lab machine, because the instruction set
   matters here. If you only have an ARM machine and no lab access, tell your instructor before you
   start.
2. The toolchain from Lecture 1:

   ```bash
   sudo apt install nasm binutils gdb gcc
   echo 'set disassembly-flavor intel' >> ~/.gdbinit
   ```

3. Intel syntax everywhere: `nasm` for your own code, `objdump -d -M intel` for reading,
   `gcc -S -masm=intel` when you compile C to assembly.

No paid tools, no special hardware.

## Tasks

### 1. A program with no libc (20%)

Write `greet.asm`, assembled with `nasm -f elf64` and linked with `ld` (no `gcc`, no C runtime):

- It prints `hello, <your username>` followed by a newline, using the `write` syscall directly.
- It exits with the **length of your username** as the process exit status.
- The length must be computed by the assembler (`equ $ - label`), not typed in as a number.

**Report:** the full source, the exact build commands, and terminal output showing both the printed
line and `echo $?`.

### 2. A routine that follows the ABI (25%)

Write `vowels.asm` containing a function `count_vowels` that:

- takes a pointer to a null-terminated string in `rdi`, following the System V AMD64 convention
  (Lecture 5);
- returns the number of vowels (`aeiou`) in `rax`;
- uses at least one callee-saved register (`rbx` or `r12`) and saves and restores it correctly;
- is called from `_start` with your username as the argument, and the result is returned as the
  process exit status.

**Report:**

- the source, with a one-line comment per instruction block saying what it does;
- a `gdb` transcript proving the convention is honoured: break on `count_vowels`, show `rdi` with
  `info registers rdi` and `x/s $rdi` (your username must be visible), then `finish` and show the
  return value in `rax`;
- a second transcript showing your callee-saved register has the same value in the caller before and
  after the call;
- `echo $?` matching the vowel count of your username, computed by hand in one sentence.

### 3. Memory, endianness and the stack (20%)

In a program of your own (extend task 2 or write a third file):

1. Declare your username with `db` in `.rodata` and the constant `0xDEADBEEF` with `dd` in `.data`.
2. In `gdb`, print the four bytes of the constant with `x/4xb` and the string with `x/s`. Explain the
   byte order you see in two or three sentences.
3. Reserve a 16-byte buffer in `.bss` and copy your username into it with a loop using a single
   `[base + index]` memory operand.
4. Then copy a string **longer than 16 bytes** into that same buffer with an unbounded loop. Set a
   `gdb` watchpoint on the first byte past the buffer and show the write that goes out of bounds.
5. Add the bound check, re-run, and show the copy stopping.

**Report:** the `x/4xb` and `x/s` output with your explanation, the two loop versions, and the
watchpoint hit with the address and the old and new value `gdb` prints.

### 4. Reading the compiler's output (25%)

Take this function, in a file `work.c`:

```c
int work(unsigned n) {
    int sum = 0;
    for (unsigned i = 0; i < n; i++) {
        if (i % 3 == 0) {
            sum += i * 9;
        } else {
            sum -= 2;
        }
    }
    return sum;
}
```

1. Build it twice, `gcc -O0 -c` and `gcc -O2 -c`, and disassemble both with `objdump -d -M intel`.
2. Annotate the `-O2` version **line by line**: every instruction gets one short comment mapping it
   back to the C source or naming the idiom (Lecture 2.2.1) it implements.
3. Answer in writing: where did the multiplication by 9 go, where did the division by 3 go, and which
   conditional jump corresponds to the loop condition? Name the flag each jump tests.
4. Draw the control-flow graph of the `-O0` version by hand, from `objdump` output only: one box per
   basic block, arrows for every branch (Lecture 4.6).
5. Add one sentence on what the disassembly no longer tells you that the C source did.

**Report:** both disassemblies, the annotated one, your four answers, and the CFG drawing.

### 5. The frame and its return address (10%)

Using the `-O0` build of task 4 called from a small `main`:

1. Break inside `work`, run `info frame`, and report the address that holds the return address.
2. Show the prologue and epilogue instructions and say what each one does to `rsp` and `rbp`.
3. Rebuild once with `-fstack-protector-strong` and once with `-fno-stack-protector`, diff the
   prologues, and point at the `fs:0x28` load and the `__stack_chk_fail` path.
4. Run `checksec --file=` on your binary (or `readelf -lW`) and write one sentence per protection on
   what it would stop.

**Report:** the addresses, the two prologues side by side, and your four sentences.

## Evaluation criteria

| Area | Weight | What earns full marks |
| --- | --- | --- |
| **Syscall program** | 20% | `greet.asm` assembles with `nasm` and links with `ld` alone, prints the correct username, and exits with the assembler-computed length; build commands and `echo $?` shown. |
| **ABI-correct routine** | 25% | `count_vowels` reads its argument from `rdi`, returns in `rax`, saves and restores a callee-saved register, and both `gdb` transcripts prove it with your own username visible. |
| **Memory and stack** | 20% | Endianness explained correctly from your own `x/4xb` output, both loop versions present, and the out-of-bounds write caught by a watchpoint with the addresses shown. |
| **Reading disassembly** | 25% | Every `-O2` instruction annotated correctly, multiply and divide strength reductions identified by name, the loop jump and its flag named, and a CFG that matches the branches in the listing. |
| **Frame analysis** | 10% | Return-address location read from `info frame`, prologue and epilogue explained, canary code identified in the diff. |
| **Bonus** | +20% | See below. |

Points are lost for output that is not reproducible from the commands you show, and for `gdb`
screenshots that do not contain your own username where the task asks for it.

## Bonus: a stripped binary (up to +20%)

Strip the symbol table from your task 2 binary (`strip ./vowels`) and then, **without** looking at
your own source:

1. Find the entry point and the start of `count_vowels` again, using only `objdump -d -M intel`,
   `readelf -h` and the function prologue pattern from Lecture 5.
2. Name the function `sub_<address>` as a disassembler would, and reconstruct its logic as C-like
   pseudocode.
3. Rewrite the vowel-counting loop to use `lea` and/or `shl` instead of at least one arithmetic
   instruction, and compare the instruction counts of both versions from `objdump` output.

**Report:** a section titled "Bonus: Stripped Binary Analysis" with the addresses you identified, how
the prologue gave them away, your pseudocode, and the two instruction counts.
