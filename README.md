# rawk-bufferlib

Vendorable text-buffer + editor widget for the rawk Nim GUI suite.
Built on top of [rawk-luigi](https://github.com/ItsNotPaths/rawk-luigi)
(the Xrawk Nim binding to [wayluigi](https://github.com/ItsNotPaths/wayluigi)).

The editor pane originally written for [prawk](https://github.com/ItsNotPaths/prawk),
carved out so it can be reused by other Xrawk apps and external projects.

## Features

- Multi-tab text buffer with cursor, selection, multi-cursor (Alt+click),
  undo/redo, soft-wrap toggle, line numbers (off / global / relative).
- Syntax highlighting for: Nim, C, C++, Python, JS, diff, Markdown.
  Add a language by dropping a `.conf` into `src/rawk_bufferlib/syntax/`
  and registering it in `highlight.nim`.
- Synthetic buffers (e.g. for showing git diffs) — fully editable in
  memory, never written to disk.
- Word / page motion, Emacs-style char/line motion, Ctrl-arrow word
  jumps, jump-to-line.
- Reusable read-only accessors so external widgets (minimaps, tab strips)
  can paint over the same buffer state.

## Install

```sh
nimble install rawk_bufferlib
# or, for local development:
nimble develop
```

`rawk_bufferlib` depends on `rawk_luigi`. Make sure that's installed
(or `nimble develop`-linked) before building.

## Use

```nim
import rawk_luigi
import rawk_bufferlib

initialise()
loadFont()
loadAllSyntaxes()

# Token colours luigi's UITheme doesn't expose. Set whenever your palette swaps.
setHighlightTheme(ExtraTheme(
  codeKeyword: 0x83C092'u32, codeType: 0xD8A657'u32,
  codeReturnType: 0xE78A4E'u32, urgent: 0xEA6962'u32))

let host = defaultHost()    # or build an EditorHost with your own callbacks
let win  = windowCreate(nil, 0, "demo", 900, 600)
let pan  = panelCreate(addr win.e, PANEL_GRAY or PANEL_EXPAND)
let ed   = editorCreate(addr pan.e, ELEMENT_V_FILL or ELEMENT_H_FILL, host)
editorOpenFile(ed, "/path/to/file.nim")

quit messageLoop()
```

See [`examples/basic.nim`](examples/basic.nim) for the full demo.

## The `EditorHost` contract

The editor reads its behaviour knobs and emits its tab-change
notifications through an injected `EditorHost`:

```nim
type EditorHost* = ref object
  indentString*:    proc(): string         {.closure.}  # what Tab inserts
  lineNumbers*:     proc(): LineNumberMode {.closure.}  # off / global / relative
  cursorMode*:      proc(): CursorMode     {.closure.}  # insert / normal
  cursorJumpLines*: proc(): int            {.closure.}  # Ctrl+J/K jump distance
  recordOpen*:      proc(path: string)     {.closure.}  # called on file open
  onTabsChanged*:   proc()                 {.closure.}  # tab set changed
```

All callbacks may be nil — the editor falls back to sane defaults.
`defaultHost()` returns a fully populated host with: 4-space indent,
global line numbers, insert mode, 10-line jump, no-op recordOpen, no-op
onTabsChanged.

For palette-derived token colours (keyword / type / return type / urgent
that luigi's `UITheme` doesn't carry), call `setHighlightTheme(t)`
whenever you swap palettes.

## Layout

```
src/
  rawk_bufferlib.nim              # main re-export — `import rawk_bufferlib`
  rawk_bufferlib/
    editor.nim                    # the main widget
    host.nim                      # EditorHost, LineNumberMode, CursorMode
    highlight.nim                 # syntax engine + ExtraTheme + setHighlightTheme
    font.nim                      # font activation + glyphDims()
    clipboard.nim                 # xclip / wl-clipboard shell-out
    syntax/                       # embedded at compile time via staticRead
      *.conf
examples/
  basic.nim
```

## Runtime deps

Inherited from rawk-luigi (libX11 or libwayland-client + xkbcommon,
plus libfreetype) plus:

- **X11**: `xclip`
- **Wayland**: `wl-copy` / `wl-paste` (the `wl-clipboard` package)
- **fc-match** (for font discovery)

## License

GPL-3.0-only.
