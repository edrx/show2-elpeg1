-- This file:
--   http://anggtwu.net/LUA/Tikz2.lua.html
--   http://anggtwu.net/LUA/Tikz2.lua
--          (find-angg "LUA/Tikz2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This file extends Show2 with some support for TikZ.
-- Experimental.
--
-- (defun e () (interactive) (find-angg "LUA/Tikz2.lua"))

require "Show2"   -- (find-angg "LUA/Show2.lua")

-- (find-angg ".emacs.templates" "find-tikz2-links")
-- (find-angg "LUA/Show2.lua" "usepackages")
-- (find-angg "LUA/Show2.lua" "TeXSet-tests")

usepackages.tikz = true
usepackages.tikzlibraries = Dang.from [[<<usetikzlibraries>>]]
usetikzlibraries = TeXSet.create("usetikzlibraries")
tikzoptions      = TeXSet.create("tikzoptions", ",")
texbody_tikz     = Dang.from [=[
\begin{tikzpicture}[<<tikzoptions>>]
<<tikzbody>>%
\end{tikzpicture}%
]=]

show00 = function (...) return texbody_tikz:show00(...) end
show0  = function (...) return texbody_tikz:show0 (...) end
show   = function (...) return texbody_tikz:show  (...) end
save   = function (...) return texbody_tikz:save  (...) end


--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Tikz2.lua"
tikzbody = [[
  \draw[thick,rounded corners=8pt]
  (0,0) -- (0,2) -- (1,3.25) -- (2,2) -- (2,0) -- (0,2) -- (2,2) -- (0,0) -- (2,0);
]]
= show00()
= show0()
= show()
 (etv)

= Show.log
= Show.bigstr

--]==]

-- Local Variables:
-- coding:  utf-8-unix
-- End:
