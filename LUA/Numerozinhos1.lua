-- This file:
--   http://anggtwu.net/LUA/Numerozinhos1.lua.html
--   http://anggtwu.net/LUA/Numerozinhos1.lua
--          (find-angg "LUA/Numerozinhos1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun n1 () (interactive) (find-angg "LUA/Numerozinhos1.lua"))
-- (defun p3 () (interactive) (find-angg "LUA/Pict3.lua"))
--
-- Used by:    (find-angg "LUA/ExprDxDy1.lua")
-- Supersedes: (find-angg "LUA/Pict2e1-1.lua" "Numerozinhos")

-- «.Numerozinhos»			(to "Numerozinhos")
-- «.Numerozinhos-test-basic»		(to "Numerozinhos-test-basic")
-- «.Numerozinhos-test-f»		(to "Numerozinhos-test-f")
-- «.Numerozinhos-test-spec»		(to "Numerozinhos-test-spec")
-- «.Numerozinhos-test-minus-0»		(to "Numerozinhos-test-minus-0")
-- «.Numerozinhos-test-piramide»	(to "Numerozinhos-test-piramide")
-- «.Numerozinhos-test-question-marks»	(to "Numerozinhos-test-question-marks")



require "Pict3"       -- (find-angg "LUA/Pict3.lua")
require "Piecewise2"  -- (find-angg "LUA/Piecewise2.lua")
require "StrGrid1"    -- (find-angg "LUA/StrGrid1.lua")

usepackages.edrx21 = true

-- «Numerozinhos»  (to ".Numerozinhos")
-- Based on this: (find-angg "LUA/Pict2e1-1.lua" "Numerozinhos")
-- but many methods were rewritten in incompatible ways!
--
Numerozinhos = Class {
  type = "Numerozinhos",
  from = function (xmin, ymin, bigstr)
      return Numerozinhos {xmin=xmin, ymin=ymin, bigstr=bigstr}
    end,
  fromf = function (xy_sw, xy_ne, f)
      local xmin,xmax,ymin,ymax = xy_sw[1], xy_ne[1], xy_sw[2], xy_ne[2]
      return Numerozinhos {xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, f=f}
    end,
  __tostring = function (ns) return mytostringpv(ns) end,
  __index = {
    --
    -- See: (find-angg "LUA/lua50init.lua" "minus-0")
    preprocs = {["."]="", ["?"]="\\ColorRed{?}"},
    preprocn = function (ns, n) return fix0(n) end,
    preproc  = function (ns, n)
        return type(n) == "number" and ns:preprocn(n) or (ns.preprocs[n] or n)
      end,
    --
    xyn = function (ns, x, y, n)
        local text = ns:preproc(n)
        return pformat("\\put(%s,%s){\\cell{\\text{%s}}}", x, y, text)
      end,
    xyf = function (ns, x, y)
        return ns:xyn(x, y, ns.f(x, y))
      end,
    --
    -- See: (find-angg "LUA/StrGrid1.lua")
    strgrid = function (ns)
        return StrGrid.from(ns.bigstr, ns.xmin, ns.ymin)
      end,
    strgridpict = function (ns)
        local p = Pict {}
        for x,y,c in ns:strgrid():xycs() do
          table.insert(p, ns:xyn(x, y, c))
        end
        return p
      end,
    puts = function (ns) return ns:strgridpict() end,
    fputs = function (ns)
        local p = Pict {}
        for y=ns.ymax,ns.ymin,-1 do
          for x=ns.xmin,ns.xmax do
            table.insert(p, ns:xyf(x, y))
          end
        end
        return p
      end,
    --
    setspec   = function (ns, spec) ns.spec = spec; return ns end,
    speclines = function (ns)
        return PwSpec.from(ns.spec):topict():prethickness("2pt"):Color("Orange")
      end,
    --
    topict = function (ns, Opts)
        Opts = Opts or {}
        local puts  = ns.f and ns:fputs() or ns:puts()
        local lines = ns.spec and ns:speclines()
        local u     = Opts.u or "11pt"
        local p     = Pict {}
        table.insert(p, lines)     -- lines first, below
        table.insert(p, puts)      -- numbers over the lines
        table.insert(p, ns.etc)    -- gradient vectors and other things
        p = p:pgat("Npc"):preunitlength(u)
        return p
      end,
    show0 = function (ns,Opts) return ns:topict(Opts) end,
    show  = function (ns,...)  return ns:show0(...):show("") end,
  },
}





-- «Numerozinhos-test-basic»  (to ".Numerozinhos-test-basic")
-- (c2m221isp 7 "exercicio-2-dica")
-- (c2m221isa   "exercicio-2-dica")
--[==[
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Numerozinhos1.lua"
PictBounds.setbounds(v(0,0), v(5,4))
printfun = function (f) print(DGetInfo.fromfunction(f)) end

Numerozinhos.__index.preprocs["."] = ""
Numerozinhos.__index.preprocs["."] = "$\\cdot$"
ns = Numerozinhos.from(2, 3, "24 34 44 \n 23 33")
ns = Numerozinhos.from(2, 0, "21 31 41 \n 20 30 .")
= ns
= ns:strgrid()
= ns:strgrid():printxycs()
= ns:strgridpict()
= ns:puts()
= ns:show0()
= ns:show0 {u="14pt"}
= ns:show  {u="14pt"}
 (etv)

= Show.log

documentclassoptions = "12pt"
defs = [[ \celllower=3.5pt ]]
= outertexbody.bigstr
= outertexbody
= ns:show  {u="14pt"}
= ns:show  {u="16pt"}
 (etv)

--]==]


-- «Numerozinhos-test-f»  (to ".Numerozinhos-test-f")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Numerozinhos1.lua"
PictBounds.setbounds(v(0,0), v(5,4))
ns = Numerozinhos.fromf(v(1,2), v(3,4), function (x,y) return 10*x+y end)
= ns
= ns:xyf(2, 3)
= ns:show {u="14pt"}
 (etv)

--]==]



-- «Numerozinhos-test-spec»  (to ".Numerozinhos-test-spec")
--[==[
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Numerozinhos1.lua"
PictBounds.setbounds(v(0,0), v(4,3))
ns = Numerozinhos.from(2, 1, 
       [[ a b c 
          d e f
          g h i ]])
= ns
= ns:show0()
  ns:setspec("(2,1)--(2,3)--(4,3)--(2,1)")
= ns:show0()
= ns:show()
= Show.log
= Show.bigstr
 (etv)

--]==]



-- «Numerozinhos-test-minus-0»  (to ".Numerozinhos-test-minus-0")
-- See: (find-angg "LUA/lua50init.lua" "minus-0")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Numerozinhos1.lua"
PictBounds.setbounds(v(0,0), v(6,5))

f1 = function (x1,y1)
    local Dx,Dy = x1-x0,y1-y0
    return Dx*Dy
  end
x0,y0 = 4,3
ns = Numerozinhos.fromf(v(x0-2,y0-2), v(x0+2,y0+2), f1)

= ns.f(2,3)
Numerozinhos.__index.preprocn = function (ns,n) return fix0(n) end
Numerozinhos.__index.preprocn = function (ns,n) return      n  end
= ns:xyf(2,3)

= ns:show()
 (etv)

--]==]



-- «Numerozinhos-test-piramide»  (to ".Numerozinhos-test-piramide")
-- (c3m221nfp 19 "piramide")
-- (c3m221nfa    "piramide")
--[==[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Numerozinhos1.lua"
PictBounds.setbounds(v(-1,-1), v(9,9))
ns = Numerozinhos.from(0, 0, 
    [[ 0 0 0 0 0 0 0 0 0
       0 0 0 0 0 0 0 0 0
       0 0 1 1 1 1 1 0 0
       0 0 1 2 2 2 1 0 0
       0 0 1 2 3 2 1 0 0
       0 0 1 2 2 2 1 0 0
       0 0 1 1 1 1 1 0 0
       0 0 0 0 0 0 0 0 0
       0 0 0 0 0 0 0 0 0]])
= ns:show()
 (etv)

pyr_spec  =   "(1,1)--(7,1)--(7,7)--(1,7)--(1,1)--(7,7) (1,7)--(7,1)"
pyr_spec2 = [[ (1,7)--(7,7)--(7,1)--(1,1)--(1,7)--(7,1)
               (1,1)--(2,2)  (3,3)--(7,7)
               (2,2)--(2,3)--(3,3)--(3,2)--(2,2)
               (2,3)--(3,2)
            ]]

= ns:setspec(pyr_spec) :show()
 (etv)
= ns:setspec(pyr_spec2):show()
 (etv)
= ns:setspec(nil)      :show()
 (etv)

--]==]


-- «Numerozinhos-test-question-marks»  (to ".Numerozinhos-test-question-marks")
-- (c3m221fhp 5 "exercicio-2-fig")
-- (c3m221fha   "exercicio-2-fig")
--[==[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Numerozinhos1.lua"
PictBounds.setbounds(v(-5,-5), v(5,5))
Numerozinhos.__index.preprocs["?"] = "\\tiny\\ColorRed{?}"

ns = Numerozinhos.from(-4, -4, 
    [[ . . ? . . . . . .
       . . . . ? . . ? .
       . . . ? ? . ? . ?
       . . . . 3 2 5 . .
       . . ? ? ? 8 ? ? .
       . . ? ? ? . . . .
       ? . ? . ? 4 . . .
       . . . . . . . . .
       . . . . . . ? . .]])
= ns
= ns:show()
 (etv)

--]==]


-- «Numerozinhos-test5»  (to ".Numerozinhos-test5")
-- (c3m221fhp 7 "exercicio-5")
-- (c3m221fha   "exercicio-5")
-- (c3m221fha   "exercicio-5" "nff \"Dx*Dy\"")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Numerozinhos1.lua"
PictBounds.setbounds(v(0,0), v(6,5))
x0,y0 = 4,3
nff = function (str)
    return Code.vc("x,y => local Dx,Dy = x-x0,y-y0; return "..str)
  end
ns = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), nff "Dx*Dy")
= ns:show()
 (etv)

-- (find-pdftoolsr-page "~/LATEX/2022-1-C3-VR.pdf" 2)
F = nff "Dy               "
G = nff "     Dx * (Dx+Dy)"
H = nff "Dy + Dx * (Dx+Dy)"
pF = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), F):pgat("pN")
pG = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), G):pgat("pN")
pH = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), H):pgat("pN")
= pH
sp = "\\quad"
p3 = Pict({ pF, sp, pG, sp, pH }):preunitlength("11pt")
= p3:bshow("")
 (etv)

= pH:preunitlength("25pt"):bshow("")
 (etv)

 (eepitch-maxima)
 (eepitch-kill)
 (eepitch-maxima)
[x0,y0] : [4,3];
[Dx,Dy] : [x-x0,y-y0];
G : Dy + Dx * (Dx+Dy);
subst([x=4,y=1], G);

--]]

-- «Numerozinhos-test6»  (to ".Numerozinhos-test6")
-- (find-angg "LUA/Pict2e1.lua" "Pict2eVector-tests")
-- (find-angg "LUA/lua50init.lua" "minus-0")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Numerozinhos1.lua"
truncn = function (n) return trunc0(string.format("%.3f", fix0(n))) end
nff = function (str)
    return Code.vc("x,y => local Dx,Dy = x-x0,y-y0; return "..str)
  end

PictBounds.setbounds(v(0,0), v(6,5))
x0,y0 = 4,3
p = Numerozinhos.fromf(v(x0-2,y0-2),v(x0+2,y0+2), nff "Dx*Dy")
p:adddv("\\color{Red2}", "\\linethickness{1.0pt}")
p:adddv({4,1}, {4,2,2,1})
PPPV(p)
= p
= p:pgat("pN"):preunitlength("12.5pt"):bshow("")
 (etv)

--]]



-- Local Variables:
-- coding:  utf-8-unix
-- End:
