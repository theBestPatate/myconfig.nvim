# Treesitter Text Objects -> Interactive Tutorial

This file is vimtutor but for text-objects. Open it in Neovim, move your cursor onto any code
block, and try the commands described above it. Each section explains one
feature and gives you real code to practice on.

Prerequisites: parsers installed for Python and Lua (both ship with this config and are installed on startup).

Sad statement (... yes, I intentionally wrote this, this is not AI.)
Unfortunately, as things stand currently, not all text-objects work directly inside markdown code blocks. The most reliable way to test them is to copy the code block into an external buffer — e.g. `:e test.py`, paste the section there. I'm working on making this more convenient. For text-objects that don't work in markdown, I will warn you so you don't think your config is broken. Have fun :)


---

## 1. Select -> text objects in visual / operator-pending mode

Text objects work in two contexts:
- **Visual mode** (`v`, `V`, `<C-v>`): select first, then act.
- **Operator-pending** (`d`, `c`, `y`, ...): type the operator, then the object.

### Functions  `af` / `if`

`af` -> **a function** (entire definition including signature)
`if` -> **inner function** (body only, no signature line)

```python
def greet(name, greeting="Hello"):
    message = f"{greeting}, {name}!"
    print(message)
    return message


def farewell(name):
    print(f"Goodbye, {name}!")
```

> Tip: to reset after experimenting, just undo with `u`.

Exercises:
- Put cursor anywhere inside `greet`.
    - Press `vaf` -> the whole function is selected.
    - Press `vif` -> only the body (the three indented lines) is selected.
- Put cursor on `farewell`.
    - Press `daf` -> delete the entire function.
    - Press `cif` on `farewell` -> replace just the body, leaving `def farewell(name):` intact.

---

### Classes  `ac` / `ic`
@Python stuff, Open a python buffer

`ac` -> **a class** (entire class block)
`ic` -> **inner class** (everything inside, excluding the `class` line itself)

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
- Cursor anywhere in `Dog`.
    - Press `vac` -> selects the whole `Dog` class.
    - Press `vic` -> selects everything inside `Dog` (the method, not the `class` line).
    - Press `yac` on `Animal` -> yank the whole class so you can paste a copy.

---

### Conditionals  `ai` / `ii`
@Python stuff, Open a python buffer

`ai` -> **a conditional** (entire if/elif/else block)
`ii` -> **inner conditional** (body only)

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
- Cursor on `if score >= 90:`. Press `vii` -> selects the two lines inside that branch.
- Press `vai` -> selects the entire if/elif/else chain.
- Press `dii` -> delete the body of the branch your cursor is in, keep the condition.

---

### Loops  `al` / `il`
@Python stuff, Open a python buffer

`al` -> **a loop** (for/while including the header line)
`il` -> **inner loop** (body only)

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
- Cursor inside the `for` loop body. Press `vil` -> selects the loop body.
- Press `val` -> selects the whole `for` block including the header.
- Press `dal` on the `while` loop -> deletes the entire loop.
- Press `>il` on the `for` loop -> indent the loop body one level.

---

### Blocks  `ab` / `ib`
@Python stuff, Open a python buffer

`ab` -> **a block** (any syntactic block: function body, if body, with body...)
`ib` -> **inner block** (same, slightly tighter -> language dependent)

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
- Cursor inside the `with` block. Press `vab` -> selects the with block.
- Cursor inside the `try` block. Press `dib` -> delete contents of just the `try`.
- Press `yab` on the `finally` block -> yank the entire block.

---

### Calls  `aC` / `iC`
@Python stuff, Open a python buffer

`aC` -> **a call** (entire function call expression)
`iC` -> **inner call** (the argument list only, inside the parentheses)

```python
output = sorted(filter(lambda x: x > 0, raw_data), key=lambda x: -x)

print(repr(output))

result = max(len(output), len(raw_data))
```

Exercises:
- Cursor on `filter(...)`. Press `viC` -> selects everything inside the parens.
- Press `vaC` -> selects the whole `filter(...)` call.
- Press `ciC` on `repr(output)` -> change the argument to something else.
- Press `daC` on `len(raw_data)` inside `max(...)` -> removes that argument.

---

## 2. Combining objects with operators

You can pair any text object with any operator. The pattern is always:
`{operator}{object}` -> e.g. `daf` = "delete a function", `yic` = "yank inner class".

| Operator | Action | Mnemonic |
|----------|--------|----------|
| `d` | delete | **d**elete |
| `c` | change (delete + enter insert) | **c**hange |
| `y` | yank (copy) | **y**ank |
| `>` | indent right | shift right |
| `<` | indent left | shift left |
| `=` | auto-indent / format | **=** lign |
| `gq` | format lines | **g** **q** (format) |
| `gu` | lowercase | **gu** (go under) |
| `gU` | uppercase | **gU** (go upper) |
| `v` | visually select | **v**isual |

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

Exercises -> put cursor at the very start of `helper_one`:
- `>af` -> indent the entire `helper_one` function right.
- `<af` -> indent it back left.
- `=af` -> auto-indent the entire function.
- `yaf` -> yank the whole function, then `p` to paste a copy somewhere.
- `daf` -> delete the whole function.
- `gqaf` -> format the function body (respects `formatexpr`/`formatprg`; see `:help gq`).

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
- `vaf` on `M.setup` -> selects the whole function.
- `daf` on `internal_helper` -> deletes the entire function.
- `vii` on the first `if` inside `internal_helper` -> selects the inner condition.
- `val` on the `for` loop -> selects the entire loop.

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
| `aC` / `iC` | call outer / inner |

### Operators

| Key | Action |
|-----|--------|
| `d` | delete |
| `c` | change |
| `y` | yank |
| `>` | indent right |
| `<` | indent left |
| `=` | auto-indent |
| `gq` | format lines |
| `gu` / `gU` | lower / uppercase |

> Combine: `{operator}{object}` -> e.g. `daf`, `>if`, `yac`, `=ii`.

---

## 3. Argument swap -> `<leader>a` / `<leader>A`

Swap the function argument under (or nearest to) the cursor with the
next or previous argument. Works on both function definitions and calls.

- `<leader>a` -> swap current argument with the **next** one
- `<leader>A` -> swap current argument with the **previous** one

The implementation finds the nearest `@parameter.inner` node if the cursor
isn't directly on one -> more forgiving than the treesitter-textobjects swap.

```python
def connect(host, port, user, password, timeout=30):
    pass

connect("db.local", 5432, "admin", "secret", timeout=10)
```

Exercises:
- Cursor on `port` in the definition. Press `<leader>a` -> `port` and `user` swap.
- Cursor anywhere between `5432` and `"admin"`. Press `<leader>a` -> still works.
- Press `<leader>A` after a swap to swap back.

---

## 4. Vim native text-objects

These are built into Neovim — no treesitter required. Same operator-pending / visual mode rules apply.

### Words  `aw` / `iw`  and  `aW` / `iW`

| Key | Object | Boundaries |
|-----|--------|------------|
| `iw` | **inner word** | letters, digits, underscores (`iskeyword`) |
| `aw` | **a word** | like `iw` + trailing whitespace/punctuation |
| `iW` | **inner WORD** | non-whitespace (space-delimited) |
| `aW` | **a WORD** | like `iW` + trailing whitespace |

```
this is_a "weird" example.with.dots
```

Exercises:
- Cursor on `is_a`. Press `viw` -> selects `is_a`.
- Press `vaw` -> selects `is_a` plus the trailing space.
- Cursor on `"weird"`. Press `viW` -> selects `"weird"` (quotes included, no whitespace).
- Press `ciW` -> change the whole quoted token.

### Sentences  `as` / `is`

```txt
First sentence. Second sentence with, commas. Third!
```

Exercises:
- Cursor anywhere in the first sentence. `vis` -> selects "First sentence."
- `das` -> deletes the entire sentence including trailing space.

### Paragraphs  `ap` / `ip`

Paragraphs are delimited by blank lines. `ip` is the content between blanks; `ap` includes the trailing blank line.

As a matter of fact you can use this section.

### Quotes  `a"` / `i"`  and  `a'` / `i'`

Text objects for quoted strings. Use the quote character as the object key.

```
name = "hello world"
path = '/usr/local/bin'
```

Exercises:
- Cursor inside the double-quoted string. `vi"` -> selects `hello world` (no quotes).
- `va"` -> selects `"hello world"` (quotes included).
- `ci"` -> change the contents of the string.
- Cursor inside the single-quoted string. `vi'` -> selects `/usr/local/bin`.

### Brackets  `a)` / `i)`  ( `a]`, `a}`, `a>`, `a"`, `a'` ...)

Works for `()`, `[]`, `{}`, `<>`, `""`, `''`, backticks. `i` = inside, `a` = including the delimiters.

```python
result = func(arg1, (nested + 1), arg3)
data = {"key": [1, 2, "three"]}
```

Exercises:
- Cursor inside `(nested + 1)`. `vi)` or `vi(` -> selects `nested + 1`.
- `va)` -> selects `(nested + 1)` with parens.
- Cursor inside `[1, 2, "three"]`. `vi]` -> selects contents. `da]` -> deletes the whole list.
- Cursor on the `{` brace. `va}` -> selects the whole dict literal.

### Tag blocks  `at` / `it`  (HTML/XML/JSX/etc.)

Mainly active when `ft=html`, `ft=xml`, or similar. `it` = tag contents, `at` = including the opening/closing tags. (But it will work in the html code block below somehow)

```html
<div class="outer">
  <p>First paragraph</p>
  <span>inner text</span>
</div>
```

Exercises:
- Cursor inside the `<p>` element. `vit` -> selects `First paragraph`.
- `vat` -> selects the entire `<p>First paragraph</p>` element.

> **When to use which:** Treesitter objects (`af`/`if`, `ac`/`ic`, etc.) understand
> language structure. Native objects (`aw`/`iw`, `a"`/`i"`, `ap`/`ip`) work everywhere,
> on any filetype. 

---

## 5. Working inside code blocks -> `:CodeBlockEdit`

I will be updating this section soon. I still need more work on CodeBlockEdit.
