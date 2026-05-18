## rawk-bufferlib — vendorable text-buffer + editor widget for the Xrawk
## Nim GUI suite. Built on rawk-luigi (the Xrawk binding to wayluigi).
##
## Consumers usually want everything via `import rawk_bufferlib`; the
## individual submodules are also importable as `rawk_bufferlib/editor`,
## `rawk_bufferlib/highlight`, etc.

import rawk_bufferlib/[host, font, clipboard, highlight, editor]
export host, font, clipboard, highlight, editor
