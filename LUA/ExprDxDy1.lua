-- This file:
--   http://anggtwu.net/LUA/ExprDxDy1.lua.html
--   http://anggtwu.net/LUA/ExprDxDy1.lua
--          (find-angg "LUA/ExprDxDy1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- Support for expressions like Dx^2-Dy^2, where:
--   Dx = x-x0
--   Dy = x-y0
-- each of these expressions generates a function, like this,
--   x0,y0 = 3,2
--   f = Expr.from("Dx^2-Dy^2").f
--
-- (defun e () (interactive) (find-angg "LUA/ExprDxDy1.lua"))

-- «.ExprDxDy»			(to "ExprDxDy")
-- «.ExprDxDy-tests-2D»		(to "ExprDxDy-tests-2D")
-- «.ExprDxDy-tests-3D»		(to "ExprDxDy-tests-3D")
-- «.ExprDxDy-tests-2D3D»	(to "ExprDxDy-tests-2D3D")
-- «.ExprDxDy-tests-abc»	(to "ExprDxDy-tests-abc")

require "Numerozinhos1"    -- (find-angg "LUA/Numerozinhos1.lua")
require "Surface1"         -- (find-angg "LUA/Surface1.lua")


--  _____                 ____       ____        
-- | ____|_  ___ __  _ __|  _ \__  _|  _ \ _   _ 
-- |  _| \ \/ / '_ \| '__| | | \ \/ / | | | | | |
-- | |___ >  <| |_) | |  | |_| |>  <| |_| | |_| |
-- |_____/_/\_\ .__/|_|  |____//_/\_\____/ \__, |
--            |_|                          |___/ 
--
-- «ExprDxDy»  (to ".ExprDxDy")
-- (find-angg "LUA/Code.lua" "Code")
ExprDxDy = Class {
  type = "ExprDxDy",
  from = function (expr)
      local fmt = "local x,y=...; local Dx,Dy=x-x0,y-y0; return %s"
      local f = Code {src=expr, code=format(fmt, expr)}
      return ExprDxDy {expr=expr, f=f}
    end,
  __tostring = function (edd) return mytostringv(edd) end,
  __index = {
    numerozinhos = function (edd, radius)
        radius = radius or 1
        local xy_sw = v(x0-radius, y0-radius)
        local xy_ne = v(x0+radius, y0+radius)
        return Numerozinhos.fromf(xy_sw, xy_ne, edd.f)
      end,
    --
    surface0 = function (edd) return Surface.new(edd.f) end,
    squareanddiagonals = function (edd, n)
        return edd:surface0():squareanddiagonals(n or 8)
      end,
    pgat3 = function (edd, n)
        return edd:squareanddiagonals(n):pgat3()
      end,
    --
    topict2D = function (edd, opts) return edd:numerozinhos():topict(opts) end,
    topict3D = function (edd, n)    return edd:pgat3(n) end,
    --
    topict2D_433 = function (edd, opts)
        Pgat3.set433_2D()
        return edd:topict2D(opts)
      end,
    topict3D_433 = function (edd, n)
        Pgat3.set433()
        return edd:topict3D(n)
      end,
    --
    a0  = function (edd) return (edd.expr:gsub("D", "\\Delta "):gsub("%*", "\\cdot ")) end,
    b0  = function (edd) return edd:topict2D_433({u="11pt"}) end,
    c0  = function (edd) return edd:topict3D_433(edd.n or 16):preunitlength("6pt") end,
    a   = function (edd) return Pict { edd:a0() } :sa(edd.expr.." 1D") end,
    b   = function (edd) return        edd:b0()   :sa(edd.expr.." 2D") end,
    c   = function (edd) return        edd:c0()   :sa(edd.expr.." 3D") end,
    abc = function (edd) return Pict { edd:a(), edd:b(b), edd:c() } end,
  },
}

-- «ExprDxDy-tests-2D»  (to ".ExprDxDy-tests-2D")
--[[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ExprDxDy1.lua"
x0,y0 = 3,2
edd = ExprDxDy.from("Dx")
= edd
= edd.f(4,3)
PPP(edd)

PictBounds.setbounds(v(0,0), v(5,4))
ns = edd:numerozinhos(2)
ns = edd:numerozinhos()
= ns
= ns:xyf(2, 3)
= ns:show {u="14pt"}
 (etv)

sg = StrGrid.from([=[
  . . A B C
  . . D E F
  . . G H I
  . . . . .
  ]=])
=      sg:labels()
=      sg:subst("A--C--I--G--A B--H")
spec = sg:subst("A--C--I--G--A B--H")
= ns:setspec(spec)
= ns:show {u="14pt"}
 (etv)

--]]


-- «ExprDxDy-tests-3D»  (to ".ExprDxDy-tests-3D")
--[[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ExprDxDy1.lua"
Pgat3.set433()
V3.threeD = "2D"
x0,y0 = 3,2
edd   = ExprDxDy.from("2+Dx^2-Dy^2")
= edd:surface0()
= edd:squareanddiagonals(8)
= edd:squareanddiagonals(8):pgat3()
= edd:pgat3()
= edd:pgat3():show("", {scale=0.9})
 (etv)

--]]


-- «ExprDxDy-tests-2D3D»  (to ".ExprDxDy-tests-2D3D")
--[[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ExprDxDy1.lua"
V3.threeD = "2D"
x0,y0 = 3,2
edd   = ExprDxDy.from("2+Dx^2-Dy^2")
p2D   = edd:topict2D_433({u="11pt"})
p3D   = edd:topict3D_433(16)
p3D   = edd:topict3D_433(8)
p3D   = edd:topict3D_433(2)
pboth = Pict { p2D, "\\quad", p3D }
= pboth:show("")
 (etv)

= p2D:pgat("", {def="foo"})
= p3D:pgat("", {sa="bar"})

--]]



-- «ExprDxDy-tests-abc»  (to ".ExprDxDy-tests-abc")
--[==[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ExprDxDy1.lua"
V3.threeD = "2D"
x0,y0 = 3,2
edd   = ExprDxDy.from("2+Dx^2-Dy^2")
edd.n = 2
= edd:abc()

foo = [=[
  \def\exprdxdyabc#1{\ensuremath{
    \ga{#1 1D} \quad
    \ga{#1 2D} \quad
    \ga{#1 3D}
    }}
  \exprdxdyabc{2+Dx^2-Dy^2}
]=]
p = Pict { edd:abc(), foo }
= p
= p:show("")
 (etv)

--]==]




-- Local Variables:
-- coding:  utf-8-unix
-- End:
