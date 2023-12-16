My [presentation](http://anggtwu.net/emacsconf2023.html) at the [EmacsConf2023](https://emacsconf.org/2023/talks/) was titled "REPLs in strange
places: Lua, LaTeX, LPeg, LPegRex, TikZ". Due to personal problems I
had to present it in a very incomplete form, and it ended up being
mainly about the design decisions behind some Lua programs - or
"modules", or "libraries" - that were not finished at the time of the
conference.

All those programs are built on top of two modules: [Show2.lua](http://anggtwu.net/LUA/Show2.lua.html#introduction) and
[ELpeg1.lua](http://anggtwu.net/LUA/ELpeg1.lua.html). After the conference I wrote this sandboxed tutorial -
[(find-show2-intro)](http://anggtwu.net/eev-intros/find-show2-intro.html) - with [executable](http://anggtwu.net/eepitch.html) instructions for installing this
version of the modules and testing most of their main parts.

Note that at some point I will create versions of Show2 and ELpeg1
that will be incompatible with the current ones, and that will have
names like Show3, Show4, ELpeg2, ELpeg3, etc - and the repository with
these other versions will have other names that are not
"show2-elpeg1".

