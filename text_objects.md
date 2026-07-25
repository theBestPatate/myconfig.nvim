# Treesitter Text Objects — Interactive Tutorial

This file is vimtutor but for text-objects (with my setup). Open it in Neovim, move your cursor onto any code
block, and try the commands described above it. Each section explains one
feature and gives you real code to practice on.

Prerequisites: parsers installed for Python and Lua (both ship with this config).
Open this file, then `:set filetype=python` to activate Python treesitter for
the Python blocks, or use the dedicated Lua block at the end.

> Tip: to reset after experimenting, just undo with `u`.

---

## 1. Select — text objects in visual / operator-pending mode

Text objects work in two contexts:
- **Visual mode** (`v`, `V`, `<C-v>`): select first, then act.
- **Operator-pending** (`d`, `c`, `y`, ...): type the operator, then the object.

### Functions  `af` / `if`

`af` — **a function** (entire definition including signature)
`if` — **inner function** (body only, no signature line)

```python
def greet(name, greeting="Hello"):
    message = f"{greeting}, {name}!"
    print(message)
    return message


def farewell(name):
    print(f"Goodbye, {name}!")
```

Exercises:
- Put cursor anywhere inside `greet`. Press `vaf` — the whole function is selected.
- Press `vif` — only the body (the three indented lines) is selected.
- Put cursor on `farewell`. Press `daf` — delete the entire function.
- Press `cif` on `greet` — replace just the body, leaving `def greet(...):` intact.

---

### Classes  `ac` / `ic`

`ac` — **a class** (entire class block)
`ic` — **inner class** (everything inside, excluding the `class` line itself)

```python
class Animal:
    species = "unknown"

    def __init__(self, name):
        self.name = name

    def speak(self):
        raise NotImplementedError


class Dog(Animal):
    def speak(self):
        return f"{self.name} says woof!"
```

Exercises:
- Cursor anywhere in `Dog`. Press `vac` — selects the whole `Dog` class.
- Press `vic` — selects everything inside `Dog` (the method, not the `class` line).
- Press `yac` on `Animal` — yank the whole class so you can paste a copy.

---

### Parameters  `aa` / `ia`

`aa` — **an argument** (includes the surrounding comma/whitespace)
`ia` — **inner argument** (the value only)

```python
def configure(host, port=8080, debug=False, timeout=30):
    pass


result = configure("localhost", port=9000, debug=True, timeout=60)
```

Exercises:
- Put cursor on `port=8080` in the function definition. Press `via` — selects `port=8080`.
- Press `daa` — deletes the argument AND the trailing comma, leaving clean syntax.
- Put cursor on `9000` in the call. Press `cia` — change just the value.
- Press `vaa` on `debug=True` in the call — selects it with its comma.

---

### Conditionals  `ai` / `ii`

`ai` — **a conditional** (entire if/elif/else block)
`ii` — **inner conditional** (body only)

```python
def categorize(score):
    if score >= 90:
        grade = "A"
        label = "Excellent"
    elif score >= 70:
        grade = "B"
        label = "Good"
    else:
        grade = "F"
        label = "Failing"
    return grade, label
```

Exercises:
- Cursor on `if score >= 90:`. Press `vii` — selects the two lines inside that branch.
- Press `vai` — selects the entire if/elif/else chain.
- Press `dii` — delete the body of the branch your cursor is in, keep the condition.

---

### Loops  `al` / `il`

`al` — **a loop** (for/while including the header line)
`il` — **inner loop** (body only)

```python
def process_items(items):
    results = []
    for item in items:
        cleaned = item.strip()
        if cleaned:
            results.append(cleaned.upper())
    return results


def count_down(n):
    while n > 0:
        print(n)
        n -= 1
    print("Done!")
```

Exercises:
- Cursor inside the `for` loop body. Press `vil` — selects the loop body.
- Press `val` — selects the whole `for` block including the header.
- Press `dal` on the `while` loop — deletes the entire loop.
- Press `>il` on the `for` loop — indent the loop body one level.

---

### Blocks  `ab` / `ib`

`ab` — **a block** (any syntactic block: function body, if body, with body...)
`ib` — **inner block** (same, slightly tighter — language dependent)

```python
def heavy_task():
    with open("data.txt") as f:
        lines = f.readlines()
        for line in lines:
            process(line)

    try:
        finalize()
    except RuntimeError as e:
        handle(e)
    finally:
        cleanup()
```

Exercises:
- Cursor inside the `with` block. Press `vab` — selects the with block.
- Cursor inside the `try` block. Press `dib` — delete contents of just the `try`.
- Press `yab` on the `finally` block — yank the entire block.

---

### Calls  `aA` / `iA`

`aA` — **a call** (entire function call expression)
`iA` — **inner call** (the argument list only, inside the parentheses)

```python
output = sorted(filter(lambda x: x > 0, raw_data), key=lambda x: -x)

print(repr(output))

result = max(len(output), len(raw_data))
```

Exercises:
- Cursor on `filter(...)`. Press `viA` — selects everything inside the parens.
- Press `vaA` — selects the whole `filter(...)` call.
- Press `ciA` on `repr(output)` — change the argument to something else.
- Press `daA` on `len(raw_data)` inside `max(...)` — removes that argument.

---

### Scope  `as`

`as` — **a scope** (the enclosing named scope — function, class, module, etc.)
      (uses the `locals` query group rather than `textobjects`)

```python
class Outer:
    class Inner:
        def method(self):
            x = 1
            y = 2   # <-- cursor here
            return x + y

    def other(self):
        pass
```

Exercises:
- Cursor on `y = 2`. Press `vas` — selects the innermost scope (`method`).
- Press `vas` again (or `2vas`) — expands to `Inner`.
- Use with `d`/`y`/`c` to act on entire scopes at once.

---

## 2. Move — jump between text objects

All move mappings work in `n`ormal, `x` (visual), and `o`perator-pending modes,
so you can do things like `d]m` (delete to next function) or `v]M` (select to
end of current function).

### Functions

| Key | Jump |
|-----|------|
| `]m` | next function **start** |
| `]M` | next function **end** |
| `[m` | previous function **start** |
| `[M` | previous function **end** |

```python
def alpha():
    return 1


def beta():
    return 2


def gamma():
    return 3


def delta():
    x = 10
    y = 20
    return x + y
```

Exercises:
- Start at the top of this block. Press `]m` repeatedly — hops to each function start.
- Press `]M` — jumps to the end of the current/next function.
- Press `[m` to go back. Press `[M` to land on the end of the previous function.
- Press `v]M` from inside `alpha` — visually selects to end of `alpha`.
- Press `d]m` — deletes from cursor to start of next function.

---

### Classes

| Key | Jump |
|-----|------|
| `]]` | next class **start** |
| `][` | next class **end** |
| `[[` | previous class **start** |
| `[]` | previous class **end** |

```python
class First:
    value = 1

    def get(self):
        return self.value


class Second:
    value = 2

    def get(self):
        return self.value


class Third:
    value = 3
```

Exercises:
- Press `]]` from `First` — jumps to start of `Second`.
- Press `][` — jumps to end of current class.
- Press `[[` — jumps back to previous class start.
- Try `d][` — deletes from cursor to end of current class.

---

### Loops  `]o` / `[o`

```python
def compute(data):
    totals = []
    for row in data:
        subtotal = 0
        for value in row:
            subtotal += value
        totals.append(subtotal)

    i = len(totals) - 1
    while i >= 0:
        totals[i] *= 2
        i -= 1

    return totals
```

Exercises:
- Start above the first `for`. Press `]o` — jumps into the first loop.
- Press `]o` again — jumps to the nested loop.
- Press `]o` again — jumps to the `while`.
- Press `[o` to navigate back up through loops.

---

### Conditionals  `]i` / `[i`

Note: `]d`/`[d` are reserved by Neovim for diagnostics, so conditionals use `i`
(mnemonic: **i**f).

```python
def process(value, mode):
    if value < 0:
        value = abs(value)

    if mode == "double":
        value *= 2
    elif mode == "square":
        value **= 2
    else:
        pass

    if value > 1000:
        value = 1000

    return value
```

Exercises:
- Start at the top. Press `]i` — jumps to the first `if`.
- Press `]i` again — next conditional branch.
- Press `[i` to go backward.
- Try `c]i` from between two conditionals — change everything up to the next one.

---

## 3. Swap — reorder parameters

`<leader>a` — swap current parameter with the **next** one
`<leader>A` — swap current parameter with the **previous** one

Cursor must be ON or INSIDE a parameter node.

```python
def connect(host, port, user, password, timeout=30):
    pass


connect("db.local", 5432, "admin", "secret", timeout=10)
```

Exercises:
- Cursor on `port` in the definition. Press `<leader>a` — `port` and `user` swap.
- Cursor on `user`. Press `<leader>A` — swaps back with `port`.
- In the call, cursor on `5432`. Press `<leader>a` — swaps `5432` with `"admin"`.
- Try swapping keyword arguments: cursor on `timeout=10`, press `<leader>A`.

---

## 4. Repeatable moves — `;` and `,`

After any move command (`]m`, `[m`, `]]`, `]o`, `]i`, ...) and after `f`/`F`/`t`/`T`:

`;` — repeat the last move in the **same direction**
`,` — repeat the last move in the **opposite direction**

This makes `;` and `,` universal — they work for both character searches and
treesitter jumps.

```python
def setup():
    pass


def load():
    pass


def run():
    pass


def teardown():
    pass
```

Exercises:
- Press `]m` to jump to the first function. Then press `;` three times — hops
  through all four function starts without retyping `]m`.
- Press `,` to jump back one function at a time.
- Now press `f(` to find the next `(`. Press `;` — finds the next `(`. Press `,` — goes back.
  Both character-find and treesitter moves share the same `;`/`,` repeat.

```python
text = "first(a, b) and second(c, d) and third(e, f)"
```

- Cursor at start of the line. Press `f(`, then `;` twice — visits each `(`.
- Press `,` — goes back to previous `(`. Same `;`/`,` keys as the treesitter jumps above.

---

## 5. Combining moves with operators

Because move mappings work in operator-pending mode, you can compose them with
any operator (`d`, `c`, `y`, `>`, `<`, `=`, `gq`, ...).

```python
def helper_one():
    x = 1
    return x


def helper_two():
    y = 2
    return y


def main():
    a = helper_one()
    b = helper_two()
    print(a + b)
```

Exercises — put cursor at the very start of `helper_one`:
- `d]M` — delete from cursor to end of `helper_one` (the function body).
- `y]m` — yank from cursor to start of next function (`helper_two`).
- `>]M` — indent from cursor to end of current function.
- `c[M` — change from cursor back to end of previous function.
- `v]]` then `d` — visually select to next class start, then delete.

---

## Lua examples

Set filetype to lua (`:set ft=lua`) to activate the Lua parser for this block.

```lua
local M = {}

function M.setup(opts)
    opts = opts or {}
    M.config = vim.tbl_deep_extend("force", M.defaults, opts)
end

function M.defaults()
    return {
        timeout = 1000,
        retries = 3,
    }
end

local function internal_helper(a, b, c)
    if a > b then
        return a
    elseif a == b then
        return c
    else
        return b
    end
end

for i = 1, 10 do
    local v = internal_helper(i, i + 1, i * 2)
    if v > 5 then
        print(v)
    end
end

return M
```

Exercises:
- `vaf` on `M.setup` — selects the whole function.
- `]m` from top — jumps through each function definition.
- `]i` — jumps between `if`/`elseif`/`else` branches inside `internal_helper`.
- `]o` — jumps to the `for` loop.
- `<leader>a` with cursor on `a` in `internal_helper(a, b, c)` — swaps `a` and `b`.

---

## Quick reference

### Selections (visual `v` / operator-pending)

| Key | Object |
|-----|--------|
| `af` / `if` | function outer / inner |
| `ac` / `ic` | class outer / inner |
| `aa` / `ia` | argument outer / inner |
| `ai` / `ii` | conditional outer / inner |
| `al` / `il` | loop outer / inner |
| `ab` / `ib` | block outer / inner |
| `aA` / `iA` | call outer / inner |
| `as` | enclosing scope |

### Jumps (normal, visual, operator-pending)

| Key | Jump |
|-----|------|
| `]m` / `[m` | next / prev function start |
| `]M` / `[M` | next / prev function end |
| `]]` / `[[` | next / prev class start |
| `][` / `[]` | next / prev class end |
| `]o` / `[o` | next / prev loop |
| `]i` / `[i` | next / prev conditional (`]d`/`[d` = diagnostics) |

### Swap (normal mode, cursor on a parameter)

| Key | Action |
|-----|--------|
| `<leader>a` | swap with next parameter |
| `<leader>A` | swap with previous parameter |

### Repeat

| Key | Action |
|-----|--------|
| `;` | repeat last move / find forward |
| `,` | repeat last move / find backward |
