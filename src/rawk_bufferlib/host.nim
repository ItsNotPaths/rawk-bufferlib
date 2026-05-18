## Host-injection contract: behavior knobs and notification callbacks the
## buffer/editor reads from. The host (e.g. an IDE) wires its config and
## tab-strip notifier through here; bufferlib itself stays config-agnostic.

type
  LineNumberMode* = enum lnmOff, lnmGlobal, lnmRelative
  CursorMode*     = enum cmInsert, cmNormal

  EditorHost* = ref object
    ## All callbacks may be nil; the editor null-checks before invoking.
    indentString*:    proc(): string         {.closure.}
    lineNumbers*:     proc(): LineNumberMode {.closure.}
    cursorMode*:      proc(): CursorMode     {.closure.}
    cursorJumpLines*: proc(): int            {.closure.}
    recordOpen*:      proc(path: string)     {.closure.}
      ## Called when the editor successfully opens a real (non-synthetic) file.
      ## Host typically uses this to update a recent-files list.
    onTabsChanged*:   proc()                 {.closure.}
      ## Called when the tab set changes (add / close / reorder / dirty flip).
      ## Host typically uses this to repaint its tab-strip widget.
    scopeGuides*:     proc(): bool           {.closure.}
      ## Returns true if the editor should overlay indent / brace scope
      ## guides on each row. Nil-treated-as-true so existing hosts opt in
      ## automatically.

# --- defaults ---------------------------------------------------------------
# A minimal host with sane defaults so consumers can `let h = defaultHost()`
# and override fields they care about, instead of filling every callback.

proc defaultHost*(): EditorHost =
  EditorHost(
    indentString:    proc(): string         = "    ",
    lineNumbers:     proc(): LineNumberMode = lnmGlobal,
    cursorMode:      proc(): CursorMode     = cmInsert,
    cursorJumpLines: proc(): int            = 10,
    recordOpen:      proc(path: string)     = discard,
    onTabsChanged:   proc()                 = discard,
    scopeGuides:     proc(): bool           = true)
