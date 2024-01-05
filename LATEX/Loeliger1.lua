-- This file:
--   http://anggtwu.net/LUA/Loeliger1.lua.html
--   http://anggtwu.net/LUA/Loeliger1.lua
--          (find-angg "LUA/Loeliger1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This file draws a flipbook animation of how this git tree
--
--   G   H   I   J
--    \ /     \ /       G   H   I   J
--     D   E   F       	| /     | /  
--      \  |  / \	D   E   F    
--       \ | /   |	  \ | / |    
--        \|/    |	    B   C    
--         B     C	    | /	     
--          \   /	    A        
--           \ /
--            A
--
-- is built step by step, in this sense:
--
--   (find-git-intro "0. Introduction")
--   (find-git-intro "0. Introduction" "how do we")
--   (find-angg "bin/eevgitlib1.sh" "Time-tests")
--
-- The version of the tree at the left is from:
--
--   (find-gitdocfile "revisions.txt" "illustration, by Jon Loeliger")
--
-- and the version at the right is my simplification.
-- The resulting flipbook animation is here:
--
--   http://anggtwu.net/IMAGES/2023loeliger.gif
--   http://anggtwu.net/LATEX/2023loeliger.pdf
--   (find-LATEX "2023loeliger.tex")
--   (find-LATEX "2023loeliger.tex" "bigtts-and-bigtimes")
--
-- See:
--   (find-es "tikz" "tut-petri-nets")
-- Based on:
--   (find-angg "LUA/Tikz2.lua" "test-loeliger")
--
-- (defun e () (interactive) (find-angg "LUA/Loeliger1.lua"))

-- Index:
-- «.defs.loeliger»		(to "defs.loeliger")
-- «.defs.loeliger-tests»	(to "defs.loeliger-tests")
-- «.TikzTime»			(to "TikzTime")
-- «.TikzTime-tests»		(to "TikzTime-tests")
-- «.TikzTimes»			(to "TikzTimes")
-- «.TikzTimes-tests»		(to "TikzTimes-tests")
-- «.big»			(to "big")
-- «.big-tests»			(to "big-tests")



require "Tikz2"   -- (find-angg "LUA/Tikz2.lua")

usepackages.edrx21  = true
usetikzlibraries.my = [=[
  arrows, decorations.pathmorphing,
  backgrounds, calc, positioning, fit, petri
]=]

-- «defs.loeliger»  (to ".defs.loeliger")
-- Similar to: (find-LATEX "2023loeliger.tex" "defs.loeliger")

defs.loeliger = [=[
\def\loeligerbox#1#2{
  \scalebox{0.7}{
  \begin{tikzpicture}[ scale=2,
      commit/.style={circle,   draw=black,fill=yellow,thin},
      branch/.style={rectangle,draw=black,fill=orange,thin},
      mybackground/.style={fill=GrayPale!25,draw=none}
    ]
    \draw [mybackground] ($(1,0)-(.4,.4)$) rectangle ($(4,3)+(.4,.4)$);
    #1
  \end{tikzpicture}
  #2
  }
}
\def\loeliger#1{
  \loeligerbox{\ga{loeliger #1}}{#1}
}
\def\drawcommi #1#2{
  \node (#1) at (#2) [commit] {\phantom{A}}
}
\def\drawcommit#1#2{
  \node (#1) at (#2) [commit] {#1}
}
\def\drawwire#1#2{
  \draw [-] (#1)--(#2)
}
\def\drawbranch#1#2{
  \node (#1 r) at ($(#1)+(0.5,0)$) [branch,align=left] {#2}
}
\def\Red#1{{\color{red}#1}}
\def\HEAD{\ensuremath{\color{red}\bullet}}
]=]

-- «defs.loeliger-tests»  (to ".defs.loeliger-tests")
--[==[
 (find-angg "bin/eevgitlib1.sh" "MakeTree1")
 (show2-use "~/LATEX/Show2.lua")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Loeliger1.lua"

bigstr = [=[
  \loeligerbox{
    \drawcommit A {2,0};
    \drawcommi  B {3,1};
    \drawwire   A B;
    \drawbranch A {brA\\Fooo};
    \drawbranch B {brAB\HEAD};
  }{(Name)}
]=]
= bigstr:show00()
= bigstr:show0 ()
= bigstr:show  ()
 (etv)
= Show.log

--]==]


--  _____ _ _         _____ _                
-- |_   _(_) | __ ___|_   _(_)_ __ ___   ___ 
--   | | | | |/ /|_  / | | | | '_ ` _ \ / _ \
--   | | | |   <  / /  | | | | | | | | |  __/
--   |_| |_|_|\_\/___| |_| |_|_| |_| |_|\___|
--                                           
-- «TikzTime»  (to ".TikzTime")

TikzTime = Class {
  type = "TikzTime",
  from = function (li)
      local a,b = li:match"^(.-)::(.*)$"
      return TikzTime { li=li, a=(a and bitrim(a)), b=(b and bitrim(b)) }
    end,
  __tostring = function (tt) return mytostringv(tt) end,
  __index = {
    code = function (tt) return Code.ve(" t => "..tt.a) end,
    trueline = function (tt,time)
        if not tt.a then return nil end
        -- if not tt.a then return tt.b end
        if tt:code()(time) then return tt.b end
      end,
  },
}

-- «TikzTime-tests»  (to ".TikzTime-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Loeliger1.lua"

tt = TikzTime.from [[ t<="C"  :: \draw [-] (A)--(C); ]]
= tt
c = tt:code()
= c
= c"A"
= c"D"
= tt:trueline "A"
= tt:trueline "Z"

--]==]

--  _____ _ _         _____ _                     
-- |_   _(_) | __ ___|_   _(_)_ __ ___   ___  ___ 
--   | | | | |/ /|_  / | | | | '_ ` _ \ / _ \/ __|
--   | | | |   <  / /  | | | | | | | | |  __/\__ \
--   |_| |_|_|\_\/___| |_| |_|_| |_| |_|\___||___/
--                                                
-- «TikzTimes»  (to ".TikzTimes")

TikzTimes = Class {
  type = "TikzTimes",
  from = function (bigstr) return TikzTimes {bigstr=bigstr} end,
  __tostring = function (tts) return tts.bigstr end,
  __index = {
    at = function (tts,time)
        local A = VTable {}
        for _,li in ipairs(splitlines(tts.bigstr)) do
          local tli = TikzTime.from(li):trueline(time)
          if tli then table.insert(A, tli) end
        end
        return table.concat(A, "\n")
      end,
    loeligerbox = function (tts,time)
        return format("\\loeligerbox{%%\n%s%%\n}{%s}", tts:at(time), time)
      end,
    sa = function (tts,time)
        return format("\\sa{loeliger %s}{%s}", time, tts:loeligerbox(time))
      end,
    sas = function (tts,times)
        local f = function (time) return tts:sa(time) end
        return mapconcat(f, split(times), "\n")
      end,
    ga = function (tts,time)
        return format("\\ga{loeliger %s}", time)
      end,
    gas = function (tts,times)
        local f = function (time) return tts:ga(time) end
        return mapconcat(f, split(times), "  \\newpage\n")
      end,
    sasgas = function (tts,times)
        return tts:sas(times).."\n\n"..tts:gas(times)
      end,
  },
}

-- «TikzTimes-tests»  (to ".TikzTimes-tests")
--[==[
 (show2-use "~/LATEX/Show2.lua")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Loeliger1.lua"

tts = TikzTimes.from [=[
  t<="A" :: 
  t<="B" :: bar
  t<="B" and t<"C" :: blep
  t<="C" :: plic
]=]
= tts
= tts:at "B"

tts = TikzTimes.from [=[
  "A0"<=t and t<"A1" :: \drawcommi  A {2,0};
  "A1"<=t            :: \drawcommit A {2,0};
  "B0"<=t and t<"B1" :: \drawcommi  B {3,1};
  "B1"<=t            :: \drawcommit B {3,1};
  "B0"<=t            :: \drawwire   A B;
]=]
= tts
= tts:at "A0"
= tts:at "A1"
= tts:at "B0"
= tts:at "B1"
= tts:sa "B1"
= tts:sas "A0 A1 B0 B1"
= tts:gas "A0 A1 B0 B1"
= tts:sasgas "A0 A1 B0 B1"
= tts:sasgas("A0 A1 B0 B1"):show()
 (etv)

= Show.log

--]==]



--  _     _       
-- | |__ (_) __ _ 
-- | '_ \| |/ _` |
-- | |_) | | (_| |
-- |_.__/|_|\__, |
--          |___/ 
--
-- bigtts is a big TikzTimes structure.
-- bigtimes is used in bigtts:sasgas(bigtimes).
-- They are used here:
--
--   (find-LATEX "2023loeliger.tex" "bigtts-and-bigtimes")
--
-- The "\drawcommi"s, "\drawcommit"s and "\drawwire"s in bigtts were
-- generated by hand. The "\drawbranch"es and the bigtimes were
-- generated by these test blocks,
--
--   (find-angg "bin/eevgitlib1.sh" "Time-tests")
--   (find-angg "LUA/ParseTimeline1.lua" "test2")
--
-- and copied to this file with cut and paste.
--
-- «big»  (to ".big")
-- (to "big-tests")


bigtts = TikzTimes.from [=[
  "A0"<=t and t<"A1"  :: \drawcommi  A {2,0};
  "B0"<=t and t<"B1"  :: \drawcommi  B {2,1};
  "C0"<=t and t<"C1"  :: \drawcommi  C {3,1};
  "D0"<=t and t<"D1"  :: \drawcommi  D {1,2};
  "E0"<=t and t<"E1"  :: \drawcommi  E {2,2};
  "F0"<=t and t<"F1"  :: \drawcommi  F {3,2};
  "G0"<=t and t<"G1"  :: \drawcommi  G {1,3};
  "H0"<=t and t<"H1"  :: \drawcommi  H {2,3};
  "I0"<=t and t<"I1"  :: \drawcommi  I {3,3};
  "J0"<=t and t<"J1"  :: \drawcommi  J {4,3};
  "A1"<=t             :: \drawcommit A {2,0};
  "B1"<=t             :: \drawcommit B {2,1};
  "C1"<=t             :: \drawcommit C {3,1};
  "D1"<=t             :: \drawcommit D {1,2};
  "E1"<=t             :: \drawcommit E {2,2};
  "F1"<=t             :: \drawcommit F {3,2};
  "G1"<=t             :: \drawcommit G {1,3};
  "H1"<=t             :: \drawcommit H {2,3};
  "I1"<=t             :: \drawcommit I {3,3};
  "J1"<=t             :: \drawcommit J {4,3};
  "B0"<=t    :: \drawwire A B;
  "C0"<=t    :: \drawwire A C;
  "D0"<=t    :: \drawwire B D;
  "E0"<=t    :: \drawwire B E;
  "F0"<=t    :: \drawwire B F;
  "F0.5"<=t  :: \drawwire C F;
  "G0"<=t    :: \drawwire D G;
  "H0"<=t    :: \drawwire D H;
  "I0"<=t    :: \drawwire F I;
  "J0"<=t    :: \drawwire F J;
  "A1"<=t and t<"A2"  :: \drawbranch A {master\HEAD};
  "A2"<=t and t<"B0"  :: \drawbranch A {brAC\\master\HEAD};
  "B0"<=t and t<"B1"  :: \drawbranch A {brAC\\master\HEAD};
  "B1"<=t and t<"B2"  :: \drawbranch B {master\HEAD};
  "B1"<=t and t<"B2"  :: \drawbranch A {brAC};
  "B2"<=t and t<"B3"  :: \drawbranch B {brBDG\\master\HEAD};
  "B2"<=t and t<"B3"  :: \drawbranch A {brAC};
  "B3"<=t and t<"C0"  :: \drawbranch B {brBDG\\master};
  "B3"<=t and t<"C0"  :: \drawbranch A {brAC\HEAD};
  "C0"<=t and t<"C1"  :: \drawbranch B {brBDG\\master};
  "C0"<=t and t<"C1"  :: \drawbranch A {brAC\HEAD};
  "C1"<=t and t<"C3"  :: \drawbranch C {brAC\HEAD};
  "C1"<=t and t<"C3"  :: \drawbranch B {brBDG\\master};
  "C3"<=t and t<"D0"  :: \drawbranch C {brAC};
  "C3"<=t and t<"D0"  :: \drawbranch B {brBDG\HEAD\\master};
  "D0"<=t and t<"D1"  :: \drawbranch C {brAC};
  "D0"<=t and t<"D1"  :: \drawbranch B {brBDG\HEAD\\master};
  "D1"<=t and t<"D4"  :: \drawbranch C {brAC};
  "D1"<=t and t<"D4"  :: \drawbranch D {brBDG\HEAD};
  "D1"<=t and t<"D4"  :: \drawbranch B {master};
  "D4"<=t and t<"E0"  :: \drawbranch C {brAC};
  "D4"<=t and t<"E0"  :: \drawbranch D {brBDG};
  "D4"<=t and t<"E0"  :: \drawbranch B {brE\HEAD\\master};
  "E0"<=t and t<"E1"  :: \drawbranch C {brAC};
  "E0"<=t and t<"E1"  :: \drawbranch D {brBDG};
  "E0"<=t and t<"E1"  :: \drawbranch B {brE\HEAD\\master};
  "E1"<=t and t<"E3"  :: \drawbranch E {brE\HEAD};
  "E1"<=t and t<"E3"  :: \drawbranch C {brAC};
  "E1"<=t and t<"E3"  :: \drawbranch D {brBDG};
  "E1"<=t and t<"E3"  :: \drawbranch B {master};
  "E3"<=t and t<"F1"  :: \drawbranch E {brE};
  "E3"<=t and t<"F1"  :: \drawbranch C {brAC};
  "E3"<=t and t<"F1"  :: \drawbranch D {brBDG};
  "E3"<=t and t<"F1"  :: \drawbranch B {\HEAD\\master};
  "F1"<=t and t<"F2"  :: \drawbranch E {brE};
  "F1"<=t and t<"F2"  :: \drawbranch F {\HEAD};
  "F1"<=t and t<"F2"  :: \drawbranch D {brBDG};
  "F1"<=t and t<"F2"  :: \drawbranch C {brAC};
  "F1"<=t and t<"F2"  :: \drawbranch B {master};
  "F2"<=t and t<"F3"  :: \drawbranch E {brE};
  "F2"<=t and t<"F3"  :: \drawbranch F {\HEAD\\brFI};
  "F2"<=t and t<"F3"  :: \drawbranch D {brBDG};
  "F2"<=t and t<"F3"  :: \drawbranch C {brAC};
  "F2"<=t and t<"F3"  :: \drawbranch B {master};
  "F3"<=t and t<"G0"  :: \drawbranch E {brE};
  "F3"<=t and t<"G0"  :: \drawbranch F {brFI};
  "F3"<=t and t<"G0"  :: \drawbranch D {brBDG\HEAD};
  "F3"<=t and t<"G0"  :: \drawbranch C {brAC};
  "F3"<=t and t<"G0"  :: \drawbranch B {master};
  "G0"<=t and t<"G1"  :: \drawbranch E {brE};
  "G0"<=t and t<"G1"  :: \drawbranch F {brFI};
  "G0"<=t and t<"G1"  :: \drawbranch D {brBDG\HEAD};
  "G0"<=t and t<"G1"  :: \drawbranch C {brAC};
  "G0"<=t and t<"G1"  :: \drawbranch B {master};
  "G1"<=t and t<"G4"  :: \drawbranch G {brBDG\HEAD};
  "G1"<=t and t<"G4"  :: \drawbranch E {brE};
  "G1"<=t and t<"G4"  :: \drawbranch F {brFI};
  "G1"<=t and t<"G4"  :: \drawbranch C {brAC};
  "G1"<=t and t<"G4"  :: \drawbranch B {master};
  "G4"<=t and t<"H0"  :: \drawbranch G {brBDG};
  "G4"<=t and t<"H0"  :: \drawbranch E {brE};
  "G4"<=t and t<"H0"  :: \drawbranch F {brFI};
  "G4"<=t and t<"H0"  :: \drawbranch D {brH\HEAD};
  "G4"<=t and t<"H0"  :: \drawbranch C {brAC};
  "G4"<=t and t<"H0"  :: \drawbranch B {master};
  "H0"<=t and t<"H1"  :: \drawbranch G {brBDG};
  "H0"<=t and t<"H1"  :: \drawbranch E {brE};
  "H0"<=t and t<"H1"  :: \drawbranch F {brFI};
  "H0"<=t and t<"H1"  :: \drawbranch D {brH\HEAD};
  "H0"<=t and t<"H1"  :: \drawbranch C {brAC};
  "H0"<=t and t<"H1"  :: \drawbranch B {master};
  "H1"<=t and t<"H3"  :: \drawbranch H {brH\HEAD};
  "H1"<=t and t<"H3"  :: \drawbranch G {brBDG};
  "H1"<=t and t<"H3"  :: \drawbranch E {brE};
  "H1"<=t and t<"H3"  :: \drawbranch F {brFI};
  "H1"<=t and t<"H3"  :: \drawbranch C {brAC};
  "H1"<=t and t<"H3"  :: \drawbranch B {master};
  "H3"<=t and t<"I0"  :: \drawbranch H {brH};
  "H3"<=t and t<"I0"  :: \drawbranch G {brBDG};
  "H3"<=t and t<"I0"  :: \drawbranch E {brE};
  "H3"<=t and t<"I0"  :: \drawbranch F {brFI\HEAD};
  "H3"<=t and t<"I0"  :: \drawbranch C {brAC};
  "H3"<=t and t<"I0"  :: \drawbranch B {master};
  "I0"<=t and t<"I1"  :: \drawbranch H {brH};
  "I0"<=t and t<"I1"  :: \drawbranch G {brBDG};
  "I0"<=t and t<"I1"  :: \drawbranch E {brE};
  "I0"<=t and t<"I1"  :: \drawbranch F {brFI\HEAD};
  "I0"<=t and t<"I1"  :: \drawbranch C {brAC};
  "I0"<=t and t<"I1"  :: \drawbranch B {master};
  "I1"<=t and t<"I4"  :: \drawbranch I {brFI\HEAD};
  "I1"<=t and t<"I4"  :: \drawbranch H {brH};
  "I1"<=t and t<"I4"  :: \drawbranch G {brBDG};
  "I1"<=t and t<"I4"  :: \drawbranch E {brE};
  "I1"<=t and t<"I4"  :: \drawbranch C {brAC};
  "I1"<=t and t<"I4"  :: \drawbranch B {master};
  "I4"<=t and t<"J0"  :: \drawbranch I {brFI};
  "I4"<=t and t<"J0"  :: \drawbranch H {brH};
  "I4"<=t and t<"J0"  :: \drawbranch G {brBDG};
  "I4"<=t and t<"J0"  :: \drawbranch E {brE};
  "I4"<=t and t<"J0"  :: \drawbranch F {brJ\HEAD};
  "I4"<=t and t<"J0"  :: \drawbranch C {brAC};
  "I4"<=t and t<"J0"  :: \drawbranch B {master};
  "J0"<=t and t<"J1"  :: \drawbranch I {brFI};
  "J0"<=t and t<"J1"  :: \drawbranch H {brH};
  "J0"<=t and t<"J1"  :: \drawbranch G {brBDG};
  "J0"<=t and t<"J1"  :: \drawbranch E {brE};
  "J0"<=t and t<"J1"  :: \drawbranch F {brJ\HEAD};
  "J0"<=t and t<"J1"  :: \drawbranch C {brAC};
  "J0"<=t and t<"J1"  :: \drawbranch B {master};
  "J1"<=t and t<"zz"  :: \drawbranch I {brFI};
  "J1"<=t and t<"zz"  :: \drawbranch H {brH};
  "J1"<=t and t<"zz"  :: \drawbranch J {brJ\HEAD};
  "J1"<=t and t<"zz"  :: \drawbranch G {brBDG};
  "J1"<=t and t<"zz"  :: \drawbranch E {brE};
  "J1"<=t and t<"zz"  :: \drawbranch C {brAC};
  "J1"<=t and t<"zz"  :: \drawbranch B {master};
]=]

bigtimes = [=[ A0 A1 A2 B0 B1 B2 B3 C0 C1 C3 D0 D1 D4 E0 E1 E3
               F1 F2 F3 G0 G1 G4 H0 H1 H3 I0 I1 I4 J0 J1 ]=]

-- «big-tests»  (to ".big-tests")
-- (to "big")
--[==[
 (show2-use "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Loeliger1.lua"
times = "A0 A1 B0 B1"
times = bigtimes
= bigtts:sasgas(times)
= bigtts:sasgas(times):show00()
= bigtts:sasgas(times):show0 ()
= bigtts:sasgas(times):show  ()
 (etv)

= Show.bigstr
= Show.log

--]==]






-- Local Variables:
-- coding:  utf-8-unix
-- End:
