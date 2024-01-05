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

-- «.test-loeliger»	(to "test-loeliger")

require "Show2"   -- (find-angg "LUA/Show2.lua")

-- (find-angg ".emacs.templates" "find-tikz2-links")
-- (find-angg "LUA/Show2.lua" "usepackages")
-- (find-angg "LUA/Show2.lua" "TeXSet-tests")

usetikzlibraries = TeXSet.create("usetikzlibraries", ",")
tikzoptions      = TeXSet.create("tikzoptions",      ",")
usepackages.tikz = Dang.from [=[
  \usepackage{tikz}
  \usetikzlibrary{<<usetikzlibraries>>}
]=]
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

]==]


-- «test-loeliger»  (to ".test-loeliger")
-- (find-angg "LUA/Loeliger1.lua")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Tikz2.lua"
usetikzlibraries.my = [=[
  arrows, decorations.pathmorphing,
  backgrounds, positioning, fit, petri, calc
]=]
tikzoptions.my = [=[
  scale=1.5,
  commit/.style={circle,   draw=black,fill=yellow,thin},
  branch/.style={rectangle,draw=black,fill=orange,thin}
]=]
tikzbody = Dang.from [=[
 %\draw [fill=GrayPale,draw=none] (1,0) rectangle (4,3);
  \draw [fill=GrayPale!25,draw=none] ($(1,0)-(.4,.4)$) rectangle ($(4,3)+(.4,.4)$);
  \node (A) at (2,0) [commit] {A};
  \node (B) at (2,1) [commit] {B};
  \node (C) at (3,1) [commit] {C};
  \node (D) at (1,2) [commit] {D};
  \node (E) at (2,2) [commit] {E};
  \node (F) at (3,2) [commit] {F};
  \node (G) at (1,3) [commit] {G};
  \node (H) at (2,3) [commit] {H};
  \node (I) at (3,3) [commit] {I};
  \node (J) at (4,3) [commit] {J};
  \draw [-] (A)--(B);
  \draw [-] (A)--(C);
  \draw [-] (B)--(D);
  \draw [-] (B)--(E);
  \draw [-] (B)--(F);
  \draw [-] (C)--(F);
  \draw [-] (D)--(G);
  \draw [-] (D)--(H);
  \draw [-] (F)--(I);
  \draw [-] (F)--(J);
 %\node (brAC) at ($(C)+(0.7,0)$) [branch] {brAC};
  \node (brAC) at ($(C)+(0.7,0)$) [branch,align=left] {brAC\\Foo};
]=]

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
