## Minimal standalone demo of rawk-bufferlib.
##
## Build (X11):       nim c -r examples/basic.nim [path/to/file]
## Build (Wayland):   nim c -d:wayland -r examples/basic.nim [path/to/file]

import std/os
import rawk_luigi
import rawk_bufferlib

initialise()
loadFont()
loadAllSyntaxes()

# Token-color slots luigi's UITheme doesn't expose. Pick anything; here we
# borrow gruvbox-material-dark roughly. Skip if you only edit plain text.
setHighlightTheme(ExtraTheme(
  codeKeyword:    0x83C092'u32,   # green
  codeType:       0xD8A657'u32,   # yellow
  codeReturnType: 0xE78A4E'u32,   # orange
  urgent:         0xEA6962'u32,   # red
  accent:         0x7DAEA3'u32))  # blue — focus border + cursor underline

let host = defaultHost()

let win = windowCreate(nil, 0, "rawk-bufferlib example", 900, 600)
let panel = panelCreate(addr win.e, PANEL_GRAY or PANEL_EXPAND)
let editor = editorCreate(addr panel.e, ELEMENT_V_FILL or ELEMENT_H_FILL, host)

if paramCount() > 0:
  editorOpenFile(editor, absolutePath(paramStr(1)))

elementFocus(addr editor.e)
quit messageLoop()
