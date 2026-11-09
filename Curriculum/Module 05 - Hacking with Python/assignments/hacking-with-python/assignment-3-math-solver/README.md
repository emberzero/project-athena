# Assignment 3: Automated Math Challenge Solver

**Difficulty:** Intermediate
**Estimated Time:** 3-4 hours
**Points:** 150

## Learning Objectives

By completing this assignment, you will:

- Master the `pwntools` library for remote service interaction
- Learn to parse and extract data from unstructured text output
- Implement automated problem-solving algorithms
- Handle time-constrained challenges programmatically
- Use regular expressions for pattern matching
- Implement error recovery and connection handling
- Work with different mathematical operations (arithmetic, modular arithmetic, algebra)
- Handle binary, hexadecimal, and other number bases

## Scenario Description

### The Challenge: "The Math Gauntlet"

You've discovered a mysterious server at `nc localhost 9999` that promises a flag to anyone who can solve **50 random mathematical equations in under 30 seconds**. No human could solve them that fast, so this is a job for automation.

The server sends equations in various formats:

```text
Challenge 1/50: Calculate: 234 * 567 + 891
Challenge 2/50: Solve for x: 3x + 7 = 28
Challenge 3/50: What is pow(123, 456, 789)?
Challenge 4/50: Convert 0xDEADBEEF to decimal
Challenge 5/50: Compute: 0b1010 XOR 0b1100
...
```

**Your Mission:**

1. Connect to the remote challenge server
2. Parse each equation from the server output
3. Automatically solve the equation
4. Send the answer back within time limit
5. Complete all 50 challenges to receive the flag

**The Flag Format:** `FLAG{Automation_Beats_Manual_<random_hex>}`

Where `<random_hex>` is a 16-character hexadecimal string randomly generated when the server starts. Each instance has a unique flag.

### Real-World Context

This simulates real CTF challenges where you must:

- **Automate repetitive tasks:** Manual solving is too slow
- **Parse dynamic output:** Each run has different equations
- **Handle errors gracefully:** Network issues, parsing errors
- **Work within constraints:** Time limits, connection limits

Similar challenges appear in:

- **DEF CON CTF:** Proof-of-work challenges
- **PicoCTF:** Math gauntlet problems
- **HackTheBox:** Authentication bypass via computation
- **OverTheWire:** Remote service exploitation

## Requirements

### Python Libraries

```txt
pwntools==4.11.0
sympy==1.12
```

### System Requirements

- Python 3.10+
- Docker and Docker Compose (for challenge server)
- Netcat (nc) for manual testing

### Installation

```bash
# Install Python dependencies
pip install -r requirements.txt

# Start the challenge server
docker-compose up -d

# Test manual connection
nc localhost 9999
```

## Equation Types

The challenge server generates these equation types with **consistent, easy-to-parse formats**:

### 1. Basic Arithmetic (Easy)

**Format:** `CALC: <expression>`

```text
CALC: 234 * 567 + 891
CALC: 1024 / 32 - 15
CALC: (123 + 456) * 2
```

**Parsing:** Extract everything after `CALC:`, evaluate with `eval()` (after validation)

**Solution approach:** Use Python's `eval()` (carefully!) or parse and compute

### 2. Modular Arithmetic (Medium)

**Format:** `POW: <base> <exponent> <modulus>`

```text
POW: 123 456 789
POW: 987 654 321
POW: 12345 67890 11111
```

**Parsing:** `parts = line.split()[1:]` → `pow(int(parts[0]), int(parts[1]), int(parts[2]))`

**Solution approach:** Use Python's built-in `pow(base, exp, mod)`

### 3. Algebra (Medium)

**Format:** `ALGEBRA: <coefficient>x + <constant> = <result>` or `ALGEBRA: <coefficient>x - <constant> = <result>`

```text
ALGEBRA: 3x + 7 = 28
ALGEBRA: 5x - 12 = 33
ALGEBRA: 2x + 15 = 45
```

**Parsing:** Regex `r'(\d+)x ([+-]) (\d+) = (\d+)'`

**Solution approach:** Parse coefficients, rearrange: `x = (result - constant) / coefficient`

### 4. Binary Operations (Medium)

**Format:** `BINARY: <binary1> <operation> <binary2>`

```text
BINARY: 1010 XOR 1100
BINARY: 11111111 AND 10101010
BINARY: 1010 OR 0101
```

**Parsing:** Split on spaces, convert binary strings to int with `int(binary, 2)`

**Solution approach:** Parse binary literals, use bitwise operators (`^`, `&`, `|`)

### 5. Base Conversions (Easy-Medium)

**Format:** `HEX: <value>` or `BIN: <value>` or `OCT: <value>`

```text
HEX: DEADBEEF
BIN: 11011011
OCT: 755
```

**Parsing:**

- `HEX: ABC` → `int('ABC', 16)`
- `BIN: 1010` → `int('1010', 2)`
- `OCT: 755` → `int('755', 8)`

**Solution approach:** Use Python's `int(value, base)` with appropriate base

### 6. Advanced Math (Hard)

**Format:** `<operation>: <arguments>`

```text
FACT: 10
GCD: 12345 67890
LCM: 123 456
SQRT: 144
```

**Parsing:** Split on `:` and spaces, apply appropriate function

**Solution approach:** Use `math` library functions (`math.factorial()`, `math.gcd()`, `math.sqrt()`)

## Starter Code Overview

The `starter.py` provides:

1. **connect_to_server()** - Establish connection using pwntools
2. **parse_equation()** - Extract equation from server output
3. **solve_equation()** - Determine equation type and solve
4. **send_answer()** - Submit answer to server
5. **run_challenge()** - Main loop for all 50 equations

## Your Tasks

### Task 1: Establish Connection (15 points)

Use pwntools to connect to the challenge server:

```python
from pwn import *

# Connect to remote service
conn = remote('localhost', 9999)

# Receive welcome banner
banner = conn.recvline()
print(banner.decode())
```

### Task 2: Parse Equations (25 points)

Extract equations from server output using regular expressions:

```python
import re

# Example output: "Challenge 1/50: Calculate: 234 * 567"
def parse_equation(line):
    # Extract the equation part after "Calculate:" or "Solve for x:"
    # Return the equation string
    pass
```

### Task 3: Solve Basic Arithmetic (20 points)

Implement safe evaluation for arithmetic expressions:

```python
def solve_arithmetic(equation):
    # Handle expressions like "234 * 567 + 891"
    # WARNING: Don't use eval() directly - validate first!
    pass
```

### Task 4: Solve Algebra (25 points)

Parse and solve simple linear equations:

```python
def solve_algebra(equation):
    # Parse "3x + 7 = 28"
    # Extract coefficient, constant, and result
    # Solve: x = (result - constant) / coefficient
    pass
```

### Task 5: Handle All Equation Types (40 points)

Implement solvers for all equation types and integrate into main loop.

### Task 6: Complete 50 Challenges (25 points)

Run the full automation and capture the flag.

## Hints

<details>
<summary>Hint 1: Using Pwntools (Click to reveal)</summary>

Basic pwntools operations:

```python
from pwn import *

# Connect to server
conn = remote('localhost', 9999)

# Receive until specific string
conn.recvuntil(b'Challenge')

# Receive a line
line = conn.recvline()

# Send data (automatically adds newline)
conn.sendline(b'42')

# Receive with timeout
try:
    data = conn.recv(timeout=2)
except EOFError:
    print("Connection closed")

# Close connection
conn.close()
```

</details>

<details>
<summary>Hint 2: Regex Patterns for Parsing</summary>

Useful regex patterns:

```python
import re

# Match arithmetic: "Calculate: 234 * 567"
arithmetic_pattern = r'Calculate: (.+?)$'

# Match algebra: "Solve for x: 3x + 7 = 28"
algebra_pattern = r'Solve for x: (\d+)x ([+-]) (\d+) = (\d+)'

# Match modular: "What is pow(123, 456, 789)?"
pow_pattern = r'pow\((\d+), (\d+), (\d+)\)'

# Match conversion: "Convert 0xDEADBEEF to decimal"
hex_pattern = r'Convert (0x[0-9A-Fa-f]+)'

# Extract number from binary: "0b1010"
binary_pattern = r'0b([01]+)'
```

</details>

<details>
<summary>Hint 3: Safe Arithmetic Evaluation</summary>

Instead of using `eval()` directly (security risk), validate and parse:

```python
import ast
import operator

# Allowed operations
ops = {
    ast.Add: operator.add,
    ast.Sub: operator.sub,
    ast.Mult: operator.mul,
    ast.Div: operator.truediv,
    ast.Mod: operator.mod,
    ast.Pow: operator.pow,
}

def safe_eval(expression):
    """Safely evaluate arithmetic expression."""
    try:
        node = ast.parse(expression, mode='eval')
        # Validate that only safe operations are used
        # Then evaluate
        return eval(compile(node, '', 'eval'))
    except:
        # Fallback to manual parsing
        pass
```

Or use a whitelist approach:

```python
def safe_eval(expr):
    # Remove spaces
    expr = expr.replace(' ', '')

    # Only allow numbers, operators, parentheses
    allowed = set('0123456789+-*/().')
    if not all(c in allowed for c in expr):
        raise ValueError("Invalid characters")

    return eval(expr)
```

</details>

<details>
<summary>Hint 4: Complete Solution Structure</summary>

```python
from pwn import *
import re

def solve_equation(equation):
    """Route equation to appropriate solver."""

    # Check for pow() - modular exponentiation
    if 'pow(' in equation:
        match = re.search(r'pow\((\d+), (\d+), (\d+)\)', equation)
        if match:
            base, exp, mod = map(int, match.groups())
            return pow(base, exp, mod)

    # Check for algebra
    if 'x' in equation:
        match = re.search(r'(\d+)x ([+-]) (\d+) = (\d+)', equation)
        if match:
            coef = int(match.group(1))
            op = match.group(2)
            const = int(match.group(3))
            result = int(match.group(4))

            if op == '+':
                x = (result - const) / coef
            else:  # op == '-'
                x = (result + const) / coef

            return int(x)

    # Check for base conversion
    if '0x' in equation:
        match = re.search(r'0x([0-9A-Fa-f]+)', equation)
        if match:
            return int(match.group(0), 16)

    if '0b' in equation:
        match = re.search(r'0b([01]+)', equation)
        if match:
            return int(match.group(0), 2)

    # Check for XOR, AND, OR operations
    if 'XOR' in equation:
        parts = re.findall(r'0b([01]+)', equation)
        if len(parts) == 2:
            return int(parts[0], 2) ^ int(parts[1], 2)

    # Default: try arithmetic evaluation
    try:
        # Extract just the mathematical expression
        expr = re.search(r'[\d\s\+\-\*/\(\)]+', equation)
        if expr:
            return eval(expr.group(0))
    except:
        pass

    return None
```

</details>

## Test Cases

```bash
# Test 1: Manual connection
nc localhost 9999
# You should see challenge prompts

# Test 2: Parse single equation
python solution.py --test parse "Calculate: 123 + 456"
# Expected: equation = "123 + 456"

# Test 3: Solve arithmetic
python solution.py --test solve "234 * 567"
# Expected: 132678

# Test 4: Solve algebra
python solution.py --test solve "3x + 7 = 28"
# Expected: x = 7

# Test 5: Full challenge
python solution.py
# Expected: FLAG{...}
```

## Extension Challenges

### Extension 1: Parallel Connections (30 points)

Some CTF challenges allow multiple simultaneous connections:

- Connect with multiple threads
- Solve challenges in parallel
- Aggregate results

### Extension 2: Machine Learning Solver (50 points)

For challenges with pattern-based equations:

- Collect training data (equation → answer pairs)
- Train a model to predict equation types
- Use ML to optimize solving strategy

### Extension 3: Distributed Solving (40 points)

For computationally intensive challenges:

- Distribute work across multiple machines
- Use multiprocessing for parallel solving
- Implement work queue system

### Extension 4: Proof-of-Work Bypass (35 points)

Many challenges include proof-of-work to prevent spam:

```text
Find nonce where SHA256(nonce + "challenge_string") starts with "0000"
```

Implement efficient PoW solver using:

- Multiprocessing
- GPU acceleration (if available)
- Incremental hashing

## Common Pitfalls

### Issue: "Connection refused"

**Cause:** Challenge server not running
**Solution:**

```bash
docker-compose ps  # Check status
docker-compose up -d  # Start server
```

### Issue: "Timeout while receiving"

**Cause:** Server waiting for answer or network delay
**Solution:** Increase timeout or check what server is waiting for

```python
conn.recv(timeout=10)  # Increase timeout
```

### Issue: "Wrong answer!"

**Cause:** Parsing error or incorrect solution
**Solution:** Add debugging to see what you're sending:

```python
print(f"Equation: {equation}")
print(f"Answer: {answer}")
conn.sendline(str(answer).encode())
```

### Issue: eval() security warning

**Cause:** Using eval() with untrusted input
**Solution:** Validate input first or use ast.literal_eval() for safe evaluation

## Security Lessons Learned

1. **Input validation is critical:** Never eval() untrusted input without validation
2. **Regex is powerful:** Essential for parsing unstructured data
3. **Time constraints require automation:** Humans can't compete with scripts
4. **Error handling matters:** Network failures, parsing errors must be handled
5. **Testing incrementally:** Test each component before full integration

## Real-World Applications

These skills apply to:

- **CTF competitions:** Automated challenge solving
- **Bug bounty:** Scripting repetitive enumeration tasks
- **Pentesting:** Automating exploit chains
- **DevOps:** Interacting with remote services programmatically
- **Data extraction:** Parsing logs and unstructured data

## Resources

- **Pwntools Documentation:** <https://docs.pwntools.com/>
- **Regex101:** <https://regex101.com/> (test regex patterns)
- **Python re module:** <https://docs.python.org/3/library/re.html>
- **SymPy:** <https://www.sympy.org/> (symbolic mathematics)
- **CTF Time:** <https://ctftime.org/> (practice challenges)

## Grading Rubric

| Criteria | Points |
|----------|--------|
| Task 1: Connection handling | 15 |
| Task 2: Equation parsing | 25 |
| Task 3: Arithmetic solving | 20 |
| Task 4: Algebra solving | 25 |
| Task 5: All equation types | 40 |
| Task 6: Complete challenge | 25 |
| **Total** | **150** |
| Extension challenges | +155 |
| Code quality | +15 |
| Comprehensive writeup | +10 |

## Submission Requirements

Submit:

1. **solution.py** - Working automation script
2. **writeup.md** - Explanation of approach
3. **flag.txt** - The captured flag
4. **challenge_log.txt** - Sample run showing all 50 challenges

### Writeup Template

```markdown
# Assignment 3 Writeup

## Approach

[Describe your methodology]

## Parsing Strategy

[Explain regex patterns used]

## Solving Algorithms

### Arithmetic
[Your approach]

### Algebra
[Your approach]

### Other Types
[Your approach]

## Challenges Faced

[Problems and solutions]

## Flag

FLAG{...}

## Performance

- Time to complete: X seconds
- Success rate: Y/50
```

## Need Help?

1. Test connection with netcat first: `nc localhost 9999`
2. Print all server output to understand format
3. Test each equation type individually
4. Use pwntools logging: `context.log_level = 'debug'`
5. Add extensive print() statements for debugging

---

Good luck! Remember: automation is the key to solving challenges that would take humans hours to complete manually.
