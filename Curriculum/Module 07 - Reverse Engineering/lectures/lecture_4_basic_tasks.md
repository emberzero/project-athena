# Basic Reverse Engineering Tasks

The previous lectures covered what reverse engineering is and how a binary is put together. This
one is the hands-on half: disassembling, decompiling, debugging a live process, tracing what it
asks of the operating system, and patching bytes. Every example runs against a program you compile
yourself, which keeps the exercise both instructive and legal.

Build the lab target once and keep it around:

```bash
mkdir -p ~/re-lab && cd ~/re-lab
cat > check.c <<'EOF'
#include <stdio.h>
#include <string.h>

static int validate(const char *s) {
    size_t n = strlen(s);
    if (n != 8) return 0;
    int sum = 0;
    for (size_t i = 0; i < n; i++) sum += s[i];
    return sum == 800;
}

int main(int argc, char **argv) {
    if (argc != 2) { puts("usage: check <code>"); return 2; }
    if (validate(argv[1])) { puts("accepted"); return 0; }
    puts("rejected");
    return 1;
}
EOF
gcc -O0 -o check check.c
./check hello
```

Everything below refers to this binary.

## Task 1: Disassembling

Disassembly turns bytes back into instructions. It is mechanical and, for well-formed code,
reliable.

```bash
objdump -d -M intel ./check | less              # whole binary, Intel syntax
objdump -d -M intel --show-raw-insn ./check     # with the raw bytes next to each instruction
```

`--show-raw-insn` matters later: patching needs to know which bytes encode the instruction you
want to change.

Two complications are worth knowing about now. x86 instructions are variable length, so a
disassembler that starts at the wrong offset produces convincing nonsense until it happens to
resynchronise. And data stored inside `.text` - jump tables, for instance - will be decoded as
instructions unless the tool knows better. Ghidra's analysis follows control flow rather than
walking linearly through bytes, which is why its disassembly is usually cleaner than a flat
`objdump` dump.

## Task 2: Decompiling

Open `check` in Ghidra, accept the analysis defaults, and open `validate` in the Decompiler. The
output will not match your source - that is the point of lecture 1 - but it will be close enough to
read, because this binary was built at `-O0` and is not stripped.

Things to do immediately:

- Rename `param_1` to something meaningful with `L`.
- Retype it from `undefined8` to `char *` with `Ctrl+L`, and watch the pointer arithmetic in the
  loop collapse into an array index.
- Note the two constants, `8` and `800`. Constants in a validation function are the answer to the
  question you are asking.

Then recompile with optimisation and look again:

```bash
gcc -O2 -s -o check_opt check.c
```

In the optimised, stripped build the function names are gone, `validate` may have been inlined into
`main`, and the loop may be vectorised. The constants are still there. This is the realistic case,
and it is why "find the constant, then find who uses it" is such a durable technique.

## Task 3: Tracing System and Library Calls

Before reaching for a debugger, ask the cheap question: what does the program do to the outside
world?

```bash
strace ./check 12345678           # system calls
ltrace ./check 12345678           # calls into shared libraries
strace -f -e trace=openat,read,write,connect ./check 12345678
```

`strace` shows file opens, network connections, process creation. `ltrace` shows `strcmp`,
`strlen`, `malloc` and friends - and on a simple validation routine it sometimes hands you the
answer directly, because the comparison is a library call with the expected value as an argument.

This is also the first dynamic technique, so the lab rules from lecture 1 apply: for anything you
did not compile yourself, run it in a disposable VM with networking isolated.

## Task 4: Debugging

A debugger lets you stop the program mid-execution and read its real state. GDB is the standard on
Linux; the GEF and pwndbg extensions make it considerably more pleasant, but everything below is
plain GDB.

```bash
gdb ./check
```

```text
(gdb) set disassembly-flavor intel
(gdb) break main
(gdb) run 12345678
(gdb) disassemble
(gdb) info registers rdi rsi rax
(gdb) x/s $rsi             # show the string a register points at
(gdb) x/16bx $rsp          # 16 bytes of the stack in hex
(gdb) break validate
(gdb) continue
(gdb) finish               # run to the end of this function, print the return value
(gdb) stepi                # one instruction
(gdb) nexti                # one instruction, stepping over calls
(gdb) backtrace
(gdb) info functions
(gdb) quit
```

Commands worth committing to memory:

| Command | Effect |
| ------- | ------ |
| `break <fn>` / `break *0x...` | Breakpoint on a function or a raw address |
| `run <args>` / `starti` | Start the program, or stop at the very first instruction |
| `continue`, `stepi`, `nexti`, `finish` | Move execution forward |
| `info registers` | Every register, or the ones you name |
| `x/<n><fmt> <addr>` | Examine memory: `x/s`, `x/16bx`, `x/4gx`, `x/10i` |
| `set $rax = 1` | Overwrite a register |
| `info proc mappings` | Where everything is actually loaded this run |

That `info proc mappings` command solves the address problem from lecture 3. On a
position-independent executable the Ghidra address `0x1189` becomes `base + 0x1189` at run time,
and the mapping table gives you the base.

With `break validate` and `finish`, you can watch the return value in `rax` for different inputs,
and confirm the two conditions - length 8, byte sum 800 - without reading another instruction. Then
do the arithmetic and construct a valid code yourself. That is the intended solution; the next task
is the lazy one.

## Task 5: Patching a Binary

Patching changes the program's behaviour by rewriting its bytes. On your own binary it is a
legitimate and very instructive exercise. Against software you do not own, it may breach copyright
and licence terms - see lecture 1, and Module 01 for the detail.

The classic patch inverts or removes a conditional jump. On x86, the short forms are one byte of
opcode plus one byte of signed displacement:

| Instruction | Opcode | Meaning |
| ----------- | ------ | ------- |
| `je` / `jz` | `74` | jump if zero flag set |
| `jne` / `jnz` | `75` | jump if zero flag clear |
| `jmp` (short) | `eb` | unconditional |
| `nop` | `90` | do nothing |

So `74` to `75` inverts a test, and overwriting a two-byte conditional jump with `90 90` removes it
entirely. Patching to `eb` makes it always taken.

The workflow:

```bash
# 1. Find the instruction and its virtual address.
objdump -d -M intel --show-raw-insn ./check | grep -B 4 -A 2 'call.*validate'

# 2. Find which section contains that address, and that section's file offset.
readelf -S ./check | grep -A 1 '\.text'

# 3. file_offset = virtual_address - section_address + section_file_offset

# 4. Keep an original, inspect the bytes, then write the patch.
cp check check_patched
xxd -s <file_offset> -l 8 check_patched
printf '\x75' | dd of=check_patched bs=1 seek=<file_offset> conv=notrunc
./check_patched anything
```

Verify by disassembling the patched copy, not by trusting the `dd`. A hex editor with a
disassembly view, or Ghidra's own patch-instruction feature, is less error-prone than `dd` once the
patch is more than one byte.

Two rules keep this from going wrong. Never patch in place - always work on a copy. And never
change the length of the code: if a replacement instruction is shorter, pad with `90`, because
shifting everything after it by one byte breaks every address in the file.

## Putting It Together

A realistic session on an unknown binary, in order:

1. `file`, `strings`, `readelf -h`. Decide whether it is packed or stripped.
2. `ltrace` or `strace` in the lab VM. Find out what it touches.
3. Ghidra: import, analyse, find the string that matches the failure message, follow the
   cross-reference to the code that prints it.
4. Read the function that decides which message to print. Rename and retype as you go.
5. GDB: break on that function, run with sample input, inspect the arguments and the return value.
6. Confirm your understanding by producing an input that passes - or, on your own binary, by
   patching the check and observing the result.
7. Write it up: what the program does, which addresses matter, what you changed and why.

Step 7 is the one students skip and professionals do not. The report is the deliverable.

## The Defensive Side

Each task above has a counterpart for the developer:

- **Against patching:** sign your binaries and verify the signature at install and update time, so
  a modified copy is detectable even though it is not preventable. Self-checksumming inside the
  binary only works until the analyst finds the checksum routine, which is the same exercise as
  finding any other function.
- **Against debugging:** anti-debug checks (lecture 2) raise cost for minutes, not days.
- **Against client-side bypass in general:** move the decision to the server. A patched client can
  skip any check that executes on the client. It cannot skip a check it never reaches.
- **For your own defenders:** the techniques here are exactly what a malware analyst does with a
  sample from your network. Being fluent in GDB and Ghidra is a blue-team skill as much as a
  red-team one.

## Exercise

On your own machine, with your own binary:

1. Build `check.c` at `-O0` and at `-O2 -s`. Diff what `nm` and `strings` show for each.
2. Use GDB to determine the two conditions in `validate` without reading the C source again.
3. Construct an input that is accepted, and explain the arithmetic in one paragraph.
4. Patch a copy of the binary so that every input is accepted. State the address you changed, the
   original bytes, the new bytes, and why the change has that effect.
5. Explain which of the two solutions - the valid input or the patch - would still work if
   `validate` ran on a server, and why.

## Key Takeaways

- Disassembly is mechanical; decompilation is interpretation. Use the pseudo-C to navigate and the
  disassembly to be certain.
- `strace` and `ltrace` answer "what does it do" far faster than reading code, and are the right
  first dynamic step.
- GDB essentials - `break`, `run`, `continue`, `stepi`, `info registers`, `x/`, `finish` - cover
  most of what basic reverse engineering needs.
- On position-independent executables, static addresses differ from runtime addresses; use
  `info proc mappings` to reconcile them.
- Patching works on a copy, never changes code length, and is verified by re-disassembling.
- Everything in this lecture works because the check runs on the attacker's machine. Security
  decisions belong on the server.

## Resources

- **GDB documentation**: <https://sourceware.org/gdb/current/onlinedocs/gdb/>
- **GEF**: <https://github.com/hugsy/gef> and **pwndbg**:
  <https://github.com/pwndbg/pwndbg> - GDB extensions built for reverse engineering
- **Ghidra**: <https://ghidra-sre.org/>
- **"Practical Binary Analysis"** by Dennis Andriesse - binary patching and instrumentation
- **"Practical Malware Analysis"** by Sikorski and Honig - debugging hostile samples safely
- **crackmes.one**: <https://crackmes.one/> - binaries published specifically to be reversed
- **pwn.college**: <https://pwn.college/> - structured exercises in reversing and exploitation
