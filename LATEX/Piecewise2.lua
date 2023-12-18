-- This file:
--   http://anggtwu.net/LUA/Piecewise2.lua.html
--   http://anggtwu.net/LUA/Piecewise2.lua
--          (find-angg "LUA/Piecewise2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- Piecewise functions, version for Pict3.lua.
-- Supersedes:
--   (find-angg "LUA/Piecewise1.lua")
--
-- (defun e   () (interactive) (find-angg "LUA/Piecewise2.lua"))
-- (defun o   () (interactive) (find-angg "LUA/Piecewise1.lua"))
-- (defun pw2 () (interactive) (find-angg "LUA/Piecewise2.lua"))
-- (defun pw1 () (interactive) (find-angg "LUA/Piecewise1.lua"))
-- (defun p2  () (interactive) (find-angg "LUA/Pict2e2.lua"))
-- (defun p3  () (interactive) (find-angg "LUA/Pict3.lua"))
-- (defun i2  () (interactive) (find-angg "LUA/Indent2.lua"))
-- (defun ps1 () (interactive) (find-angg "LUA/PictShow1.lua"))

require "Indent2"    -- (find-angg "LUA/Indent2.lua")
                     -- (find-angg "LUA/Indent2.lua" "Pict")
require "MiniV1"     -- (find-angg "LUA/MiniV1.lua"  "MiniV-tests")
require "Pict3"      -- (find-angg "LUA/Pict3.lua")

-- «.PwSpec»			(to "PwSpec")
-- «.PwSpec-test1»		(to "PwSpec-test1")
-- «.PwSpec-test2»		(to "PwSpec-test2")
-- «.PwSpec-testmtint»		(to "PwSpec-testmtint")
-- «.PwFunction»		(to "PwFunction")
-- «.PwFunction-Riemann»	(to "PwFunction-Riemann")
-- «.PwFunction-tests»		(to "PwFunction-tests")
-- «.PwFunction-testpoles»	(to "PwFunction-testpoles")
-- «.PwFunction-intfig»		(to "PwFunction-intfig")
-- «.Partition»			(to "Partition")
-- «.Partition-tests»		(to "Partition-tests")
-- «.Riemann»			(to "Riemann")
-- «.Riemann-tests»		(to "Riemann-tests")
-- «.Riemann-tests-sc»		(to "Riemann-tests-sc")
-- «.TFC1»			(to "TFC1")
-- «.TFC1-tests»		(to "TFC1-tests")
-- «.Xtoxytoy»			(to "Xtoxytoy")
-- «.Xtoxytoy-test1»		(to "Xtoxytoy-test1")
-- «.Xtoxytoy-test2»		(to "Xtoxytoy-test2")
-- «.Xtoxytoy-test3»		(to "Xtoxytoy-test3")
-- «.ChangeVar»			(to "ChangeVar")
-- «.ChangeVar-test1»		(to "ChangeVar-test1")



--  ____            ____                  
-- |  _ \__      __/ ___| _ __   ___  ___ 
-- | |_) \ \ /\ / /\___ \| '_ \ / _ \/ __|
-- |  __/ \ V  V /  ___) | |_) |  __/ (__ 
-- |_|     \_/\_/  |____/| .__/ \___|\___|
--                       |_|              
--
-- «PwSpec»  (to ".PwSpec")
-- A "spec" for a piecewise function is something like this:
--
--   "(0,1)c--(2,3)o (2,2)c (2,1)o--(4,1)--(5,2)"
--
-- Note that its segments can be non-horizontal.
--
-- An object of this class starts with a spec, immediately calculates
-- its lists of "dxyoc"s, and from that it can generate lots of other
-- data. The list of "dxyoc"s for the spec above is:
--
--   PwSpec.from("(0,1)c--(2,3)o (2,2)c (2,1)o--(4,1)--(5,2)").dxyocs
--     = { {"dash"="" , "x"=0, "y"=1, "oc"="c"},
--         {"dash"="-", "x"=2, "y"=3, "oc"="o"},
--         {"dash"="" , "x"=2, "y"=2, "oc"="c"},
--         {"dash"="" , "x"=2, "y"=1, "oc"="o"},
--         {"dash"="-", "x"=4, "y"=1, "oc"="" },
--         {"dash"="-", "x"=5, "y"=2, "oc"="" } }
--
PwSpec = Class {
  type = "PwSpec",
  from = function (src)
      return PwSpec({src=src, dxyocs={}}):add(src)
    end,
  fromep = function (spec0)  -- ep means "eval, topict"
      local exprang = function (str) return expr(str:sub(2,-2)) end
      local spec = spec0:gsub("%b<>", exprang)
      local pws = PwSpec.from(spec)
      local p = pws:topict()
      if color then p = p:Color(color) end
      return p
    end,
  dxyoc_to_string = function (dxyoc)
      return format("%s(%s,%s)%s",
                    (dxyoc.dash == "-" and "--" or " "),
                    dxyoc.x, dxyoc.y, dxyoc.oc or "")
    end,
  __tostring = function (pws) return pws:tostring() end,
  __index = {
    npoints = function (pw) return #pw.points end,
    --
    -- Add points and segments.
    -- Example: pws:add("(0,1)o--(1,1)o (1,2)c (1,3)o--(2,3)c--(3,2)--(4,2)c")
    add = function (pws, str)
        local patn = "%s*([-+.%d]+)%s*"
        local pat = "(%-?)%("..patn..","..patn.."%)([oc]?)"
        for dash,x,y,oc,_ in str:gmatch(pat) do
          table.insert(pws.dxyocs, {dash=dash, x=x+0, y=y+0, oc=oc})
        end
        return pws
      end,
    --
    tostring = function (pws)
        return mapconcat(PwSpec.dxyoc_to_string, pws.dxyocs, "")
      end,
    --
    -- Express a piecewise function as a Lua function.
    conds_tbl = function (pws)
        local conds = {}
        for i=1,#pws.dxyocs do
          local P0,P1,P2 = pws.dxyocs[i], pws.dxyocs[i+1], pws.dxyocs[i+2]
          local p0,p1,p2 = P0, P1 or {}, P2 or {}
          local x0,y0,oc0       = p0.x, p0.y, p0.oc
          local x1,y1,oc1,dash1 = p1.x, p1.y, p1.oc, p1.dash
          local x2,y2,oc2,dash2 = p2.x, p2.y, p2.oc, p2.dash
          if oc0 ~= "o" then
            local cond = format("(%s == x)          and %s", x0, y0)
            table.insert(conds, cond)
          end
          if dash1 == "-" then
            local cond = format("(%s < x and x < %s)", x0, x1)
            if y1 == y0 then
              cond = format("%s and %s", cond, y0)
            else
              cond = format("%s and (%s + (x - %s)/(%s - %s) * (%s - %s))",
                             cond,   y0,       x0,  x1,  x0,    y1,  y0     )
            end
            table.insert(conds, cond)
          end
        end
        return conds
      end,
    conds = function (pws) return table.concat(pws:conds_tbl(), "  or\n") end,
    fun0 = function (pws) return "function (x) return (\n"..pws:conds().."\n) end" end,
    fun = function (pws) return expr(pws:fun0()) end,
    --
    -- Get lines and open/closed points, for drawing.
    getj = function (pws, i)
        return (pws.dxyocs[i+1]
                and (pws.dxyocs[i+1].dash == "-")
                and pws:getj(i+1)) or i
      end,
    getijs = function (pws)
        local i, j, ijs = 1, pws:getj(1), {}
        while true do
          if i < j then table.insert(ijs, {i, j}) end
          i = j + 1
          j = pws:getj(i)
          if #pws.dxyocs < i then return ijs end
        end
      end,
    getpoint = function (pws, i) return v(pws.dxyocs[i].x, pws.dxyocs[i].y) end,
    getpoints = function (pws, i, j)
        local ps = Points2.new()
        for k=i,j do ps:add(pws:getpoint(k)) end
        return ps
      end,
    topict = function (pws)
        cmds = Pict {}
        for _,ij in ipairs(pws:getijs()) do
          cmds:add(pws:getpoints(ij[1], ij[2]):Line())
        end
        for i,p in ipairs(pws.dxyocs) do
          if p.oc == "o" then
            cmds:addopendotat(pws:getpoint(i))
          elseif p.oc == "c" then
            cmds:addcloseddotat(pws:getpoint(i))
          end
        end
        return cmds
      end,
    --
    topwfunction = function (pws)
        local spec,f = pws.src, pws:fun()
        local pwf = PwFunction.from(f)
        for x,y in spec:gmatch("%( *([-.0-9]+) *, *([-.0-9]+) *%)") do
          pwf:addpoint(tonumber(x))
        end
        return pwf
      end,
  },
}

-- «PwSpec-test1»  (to ".PwSpec-test1")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
spec = "(0,1)c--(2,3)o (2,2)c (2,1)o--(4,1)--(5,2)"
PPPV(PwSpec.from(spec).dxyocs)
spec = "(0,1)o--(1,1)o (1,4)c (1,3)o--(2,3)c--(3,2)--(4,2)c"
spec = "(0,1)c--(2,3)o (2,2)c (2,1)o--(4,1)c"
pws = PwSpec.from(spec)
= pws
= pws:conds()
= pws:fun0()
= pws:topict()
= pws:topict():predotdims ("0.4", "0.2")
= pws:topict():predotdims1("0.4    0.2")
= pws:topict():show("pgat")
= pws:topict():show("pgat", {dotdims="0.4 0.2"})
= pws:topict():show("pgat", {dotdims="0.2 0.1"})
 (etv)

f = pws:fun()
= f(0.1)
= f(1.9)
= f(2)
= f(2.1)
= f(2.2)

--]==]


-- «PwSpec-test2»  (to ".PwSpec-test2")
--[[
-- (c2m212isp 11 "uma-figura")
-- (c2m212isa    "uma-figura")
-- (c2m221isp 2 "uma-figura")
-- (c2m221isa   "uma-figura")

 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
fromep    = PwSpec.fromep
thick     = function (th) return "\\linethickness{"..th.."}" end
putcellat = function (xy, str) return pformat("\\put%s{\\cell{%s}}", xy, str) end
= fromep("(0,0)--(2,<1+2>)c")
= putcellat(v(2,3), "foo")

_minfy,_pinfy = -3,10  
_xD,_xL,_xU = -0.4,-0.8,-1.0

p = Pict {
  fromep(" (0,<_pinfy-1>)--(0,<_pinfy>)c "),
  fromep(" (0,<_minfy+1>)--(0,<_minfy>)c "),
  putcellat(v(1.2, _pinfy), "+\\infty"),
  putcellat(v(1.2, _minfy), "-\\infty"),
  thick("1pt"),
  fromep(" (-1,2)--(3,6)--(8,1)--(11,4)  "),
  thick("2pt"),
  fromep(" (1,0)c--(2,0)o                "):color("red"),
  fromep(" (1,4)c--(2,5)o                "):color("orange"),
  fromep(" (0,4)c--(0,5)o                "):color("green"),
  fromep(" (<_xL>,<_minfy>)c--(<_xL>,4)c "):color("blue"),
  fromep(" (<_xD>,4)c--(<_xD>,5)o        "):color("SpringDarkHard"),
  fromep(" (<_xU>,5)c--(<_xU>,<_pinfy>)c "):color("violet"),
}
= p:pgat("gat")
= p:setbounds(v(-1,0), v(11,7))
= p:pgat("p")
= p:scalebox("0.4")

q = (p
      :setbounds(v(-1,0), v(11,7))
      :pgat("gat")
      :setbounds(v(-1,_minfy), v(11,_pinfy))
      :pgat("p")
    )
= q
= q:show0("", {ul="12pt", scale="0.8"})
= q:show ("", {ul="12pt", scale="0.8"})
= Show.log
 (etv)

--]]


-- «PwSpec-testmtint»  (to ".PwSpec-testmtint")
-- (c2m221mt1p 2 "defs-figuras")
-- (c2m221mt1a   "defs-figuras")
--[==[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"

hx = function (x, y) return format(" (%s,%s)c--(%s,%s)o", x-1,y, x,y) end
hxs = function (...)
    local str = ""
    for x,y in ipairs({...}) do str = str .. hx(x, y) end
    return str
  end
mtintegralspec = function (specf, xmax, y0)
    local pws = PwSpec.from(specf)
    local f = pws:fun()
    local ys = {[0] = y0}
    for x=1,xmax do ys[x] = ys[x - 1] + f(x - 0.5) end
    local strx = function (x) return tostring(v(x, ys[x])) end
    local specF = mapconcat(strx, seq(0, xmax), "--")
    return specF
  end

= hxs(1, 2, -1)

specf = "(0,1)--(1,1)c (1,2)o--(3,2)o (3,-1)c--(4,-1)"
specF = mtintegralspec(specf, 4, -2)
pwsf  = PwSpec.from(specf)
pwsF  = PwSpec.from(specF)
pf    = pwsf:topict():setbounds(v(0,-2), v(4,3)):pgat("pgat")
pF    = pwsF:topict():setbounds(v(0,-2), v(4,3)):pgat("pgat")
p     = Pict { pf, "\\quad", pF }
= p:show("")
 (etv)

--]==]





--  ____           _____                 _   _             
-- |  _ \__      _|  ___|   _ _ __   ___| |_(_) ___  _ __  
-- | |_) \ \ /\ / / |_ | | | | '_ \ / __| __| |/ _ \| '_ \ 
-- |  __/ \ V  V /|  _|| |_| | | | | (__| |_| | (_) | | | |
-- |_|     \_/\_/ |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|
--                                                         
-- «PwFunction»  (to ".PwFunction")
-- An object of the class PwFunction starts with a function and with
-- its sets of "important points", and it can produce lots of data
-- from that.
--
-- The most typical use of "PwFunction" is like this:
--
--   f = function (x) if x < 2 then return x^2 else return 2 end end
--   pwf = PwFunction.from(f, seq(0, 2, 0.5), 4)
--   pict = pwf:pw(1, 3)
--   pict:bshow()
--
-- We convert the function f (plus its important points) to a
-- PwFunction, and then we generate a PwSpec that draws its graph in a
-- certain interval, and we convert that PwSpec to a Pict2e object and
-- we draw it. Note that the method ":pw(...)" does two conversions:
--
--   PwFunction -> PwSpec -> Pict2e
--
PwFunction = Class {
  type = "PwFunction",
  from = function (f, ...)
      return PwFunction({f=f}):setpoints(...)
    end,
  __index = {
    --
    -- The "important points" are stored in a "Set".
    -- Example: pwf:setpoints(seq(0, 4, 0.25), 5, 6, 7)
    setpoints = function (pwf, ...)
        pwf.points = Set.new()  -- (find-angg "LUA/lua50init.lua" "Set")
        return pwf:addpoints(...)
      end,
    addpoints = function (pwf, ...)
        for _,o in ipairs({...}) do
          if     type(o) == "number" then pwf:addpoint(o)
          elseif type(o) == "table"  then pwf:addlistofpoints(o) 
          else   PP("not a point or a list of points:", o); error()
          end
        end
        return pwf
      end,
    addpoint = function (pwf, p)
        if type(p) ~= "number" then PP("Not a number:", p); error() end
        pwf.points:add(p)
        return pwf
      end,
    addlistofpoints = function (pwf, A)
        for _,p in ipairs(A) do pwf:addpoint(p) end
        return pwf
      end,
    --
    -- All important points in the interval (a,b).
    pointsin = function (pwf, a, b)
        local A = {}
        for _,x in ipairs(pwf.points:ks()) do
          if a < x and x < b then table.insert(A, x) end
        end
        return A
      end,
    --
    -- Detect discontinuities using a heuristic.
    eps = 1/32768,
    delta = 1/128,
    hasjump = function (pwf, x0, x1)
        local y0,y1 = pwf.f(x0), pwf.f(x1)
        return math.abs(y1-y0) > pwf.delta
      end,
    hasjumpl = function (pwf, x) return pwf:hasjump(x - pwf.eps, x) end,
    hasjumpr = function (pwf, x) return pwf:hasjump(x, x + pwf.eps) end,
    --
    xy = function (pwf, x, y) return pformat("(%s,%s)", x, y or pwf.f(x)) end,
    xyl = function (pwf, xc) return pwf:xy(xc - pwf.eps) end,
    xyr = function (pwf, xc) return pwf:xy(xc + pwf.eps) end,
    jumps_and_xys = function (pwf, xc)
        local xyl, xyc, xyr = pwf:xyl(xc), pwf:xy(xc), pwf:xyr(xc)
        local jumpl = pwf:hasjumpl(xc) and "l" or ""
        local jumpr = pwf:hasjumpr(xc) and "r" or ""
        local jumps = jumpl..jumpr      -- "lr", "l", "r", or ""
        return jumps, xyl, xyc, xyr
      end,
    --
    xym = function (pwf, xc)
        local jumps, xyl, xyc, xyr = pwf:jumps_and_xys(xc)
        if     jumps == ""   then str = xyc
        elseif jumps == "l"  then str = format("%so %sc",     xyl, xyc)
        elseif jumps == "r"  then str = format(    "%sc %so",      xyc, xyr)
        elseif jumps == "lr" then str = format("%so %sc %so", xyl, xyc, xyr)
        end
        return str
      end,
    --
    piecewise_m = function (pwi, xc)   -- "m" is for "middle"
        local jumps, xyl, xyc, xyr = pwi:jumps_and_xys(xc)
        if     jumps == ""   then str = xyc
        elseif jumps == "l"  then str = format("%so %sc", xyl, xyc)
        elseif jumps == "r"  then str = format("%sc %so", xyc, xyr)
        elseif jumps == "lr" then str = format("%so %sc %so", xyl, xyc, xyr)
        end
        return str
      end,
    piecewise = function (pwi, a, b, method, sep)
        local method, sep = method or "piecewise_m", sep or "--"
        local f = function (x) return pwi[method](pwi, x) end
        local str = pwi:xyr(a)
        -- for _,x in ipairs(pwi.points:ks()) do
        --   if a < x and x < b then
        --     str = str..sep..f(x)
        --   end
        -- end
        for _,x in ipairs(pwi:pointsin(a, b)) do
	  str = str..sep..f(x)
	end
        str = str..sep..pwi:xyl(b)
        return str
      end,
    pw = function (pwi, a, b)
        return pictpiecewise(pwi:piecewise(a, b))
      end,
    --
    -- pwf:pwspec(a, b) converts a pwf to a "piecewise spec".
    -- This is tricky, so let's see an example. Suppose that:
    --
    --   pwf:pointsin(a, b) = {c}.
    --
    -- Then in the simplest case pwf:piecewise(a, b) would generate a
    -- piecewise spec like this,
    --
    --   "(a,f(a))--(c,f(c))--(b,f(b))"
    --
    -- but we have tricks for dealing with discontinuites and drawing
    -- closed dots and open dots... for example, we can generate
    -- something like this:
    --
    --   "(a,f(a))--(c-eps,f(c-eps))o (c,f(c))c--(b,f(b))"
    --
    -- The hard work to convert c to 
    --
    --             "(c-eps,f(c-eps))o (c,f(c))c"
    --
    -- is done by the function xym, defined above; the case "_o _c"
    -- corresponds to jumps == "l". Note that the "eps"s usually
    -- disappear when each coordinate of the "(x,y)"s is rounded to at
    -- most three decimals.
    --
    -- Btw, I think that the extremities are "(a+eps,f(a+eps))" and
    -- "(b-eps,f(b+eps))", not "(a,f(a))" and "(b,f(b))"... TODO:
    -- check that.
    --
    -- Btw 2: pwf:pwspec(...) can generate other kinds of output if
    -- it is called with the right hackish optional arguments.
    --
    pwspec = function (pwf, a, b, method, sep)
        local method = method or "xym"
        local sep = sep or "--"
        local xym = function (x) return pwf[method](pwf, x) end
        local str
	--
	-- Add points (including discontinuities) and "--"s to str.
        str = pwf:xyr(a)
        for _,x in ipairs(pwf:pointsin(a, b)) do str = str..sep..xym(x) end
        str = str..sep..pwf:xyl(b)
        return str
      end,
    --
    -- :pw(a,b) generates a Pict2e object that
    -- draws f in the interval [a,b].
    pw = function (pwf, a, b)
        return PwSpec.from(pwf:pwspec(a, b)):topict()
      end,
    --
    --
    --
    -- Methods that call pwspec in hackish ways.
    -- TODO: fix names, write tests.
    --
    -- :lineify(...) and :areaify(...) only work when
    -- there are no discontinuities. FIX THIS!
    --
    lineify00 = function (pwf, a, b)  -- new, 2022jun16
        local ps = Points2.new()
        local addp = function (x) ps:add(v(x, pwf.f(x))) end
        local hasjump = function (xl, xr) return pwf:hasjump(xl, xr) end
        local e = pwf.eps
        if hasjump(a, a+e) then addp(a+e) else addp(a) end
        for _,x in ipairs(pwf:pointsin(a, b)) do
          if hasjump(x-e, x+e) then addp(x-e); addp(x+e) else addp(x) end
        end
        if hasjump(b-e, b) then addp(b-e) else addp(b) end
        return ps
      end,
    lineify0 = function (pwf, a, b) return pwf:piecewise(a, b, nil, "") end,
    lineify = function (pwf, a, b)
        return Pict { pformat("\\Line%s", pwf:lineify00(a, b)) }
      end,
    areaify = function (pwf, a, b)
        local ly = pwf:lineify0(a, b)
        local poly = pformat("%s%s%s", v(a,0), pwf:lineify00(a, b), v(b,0))
        return Pict { "\\polygon*"..poly }
      end,
  },
}

-- «PwFunction-tests»  (to ".PwFunction-tests")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
f = function (x) if x < 2 then return x^2 else return 2 end end
pwf  = PwFunction.from(f, seq(0, 2, 0.5), 4)
PPPV(pwf)
spec = pwf:pwspec(0, 4)
PPPV(spec)
spec = pwf:pwspec(1, 3)
PPPV(spec)
pws = PwSpec.from(spec)
PPPV(pws)
pict = pws:topict()
PPPV(pict)
= pict

f = function (x) if x < 2 then return x^2 else return 2 end end
pwf  = PwFunction.from(f, seq(0, 2, 0.5), 4)
= pwf:lineify00(1.1, 3.1)
= pwf:lineify(1.1, 3.1)
= pwf:areaify(1.1, 3.1)
= pwf:pwspec(0, 4)
= pwf:pw    (0, 4)
= pwf:pwspec(1, 3)
= pwf:pw    (1, 3)
= pwf:pw    (1, 3):show()
 (etv)
= pwf:pw    (0, 4):show()
 (etv)

 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
PictBounds.setbounds(v(0,0), v(8,5))
f_parabola_preferida = function (x)
    return 4 - (x-2)^2
  end
f_parabola_complicada = function (x)
    if x <= 4 then return f_parabola_preferida(x) end
    if x <  5 then return 5 - x end
    if x <  6 then return 7 - x end
    if x <  7 then return 3 end
    if x == 7 then return 4 end
    return 0.5
  end
pwf = PwFunction.from(f_parabola_complicada, seqn(0, 4, 32), seq(4, 8))
p = Pict {
  pwf:areaify(2, 6.5):Color("Orange"),
  pwf:pw(0, 8),
}
= p:show()
 (etv)

--]]

-- (find-LATEX "2021-1-C2-critical-points.lua" "Approxer")
-- (c2m212somas2p 42 "exercicio-16-defs")
-- (c2m212somas2a    "exercicio-16-defs")

-- «PwFunction-testpoles»  (to ".PwFunction-testpoles")
-- New: (c2m221atisp 5 "x^-2")
--      (c2m221atisa   "x^-2")
-- Old: (c2m212intsp 5 "x^-2")
--      (c2m212intsa   "x^-2")
-- (find-es "maxima" "TFC2-fails")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
PictBounds.setbounds(v(-4,-4), v(4,4))
plotdot = function (x, y) return Pict{}:addcloseddotat(v(x,y)) end
trunc = function (y) return min(max(-4,y),4) end
f = function (x) return x==0 and 4 or trunc(1/x^2) end
F = function (x) return x==0 and 4 or trunc(-1/x)  end
pwf = PwFunction.from(f, seqn(-4, 4, 64))
pwF = PwFunction.from(F, seqn(-4, 4, 64))
= f(2)
= F(2)
p = Pict {
  pwf:areaify(-1, 1):Color("Orange"),
  pwf:pw(-4, -1/2),
  pwf:pw(1/2, 4),
}
= p:show()
 (etv)
p = Pict {
  pwF:pw(-4, -1/4),
  pwF:pw(1/4, 4),
  plotdot(-1, F(-1)),
  plotdot(1,  F(1))
}
= p:show()
 (etv)

--]]

-- «PwFunction-intfig»  (to ".PwFunction-intfig")
-- Superseded by: (to "ChangeVar-test1")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
PictBounds.setbounds(v(0,0), v(4,3))
pi, sqrt, sin, cos = math.pi, math.sqrt, math.sin, math.cos
maxu = pi
maxx = sqrt(maxu)
fu = function (u) return math.sin(u)           end
fx = function (x) return math.sin(x^2) * 2*x   end
pwfu = PwFunction.from(fu, seqn(0, maxu, 64))
pwfx = PwFunction.from(fx, seqn(0, maxx, 64))
areau = function (a, b, color)
    return pwfu:areaify(a, b):color(color)
  end
areax = function (a, b, color)
    return pwfx:areaify(sqrt(a), sqrt(b)):color(color)
  end
areauorx = function(areaf)
    local p = Pict {}
    local colors = split("red orange yellow")
    local points = {0, 1, 2, 3}
    for i=1,#colors do table.insert(p, areaf(points[i], points[i+1], colors[i])) end
    return p
  end 
pu = Pict {
  areauorx(areau),
  pwfu:lineify(0, maxu),
}
px = Pict {
  areauorx(areax),
  pwfx:lineify(0, maxx),
}
pux = Pict {
  pu:pgat("pgatc"),
  "\\quad",
  px:pgat("pgatc"),
}
= pux:show("")
= pux
 (etv)
}

--]]





--  ____            _   _ _   _             
-- |  _ \ __ _ _ __| |_(_) |_(_) ___  _ __  
-- | |_) / _` | '__| __| | __| |/ _ \| '_ \ 
-- |  __/ (_| | |  | |_| | |_| | (_) | | | |
-- |_|   \__,_|_|   \__|_|\__|_|\___/|_| |_|
--                                          
-- «Partition»  (to ".Partition")

Partition = Class {
  type = "Partition",
  new  = function (a, b) return Partition {points={a,b}} end,
  __tostring = mytostringp,
  __index = {
    a = function (ptn) return ptn.points[1] end,
    b = function (ptn) return ptn.points[#ptn.points] end,
    N = function (ptn) return #ptn.points - 1 end,
    ai = function (ptn, i) return ptn.points[i] end,
    bi = function (ptn, i) return ptn.points[i+1] end,
    bminusa = function (ptn) return ptn:b() - ptn:a() end,
    splitn = function (ptn, N)
        local points = {}
        local Delta = ptn:bminusa()
        for k=0,N do table.insert(points, ptn:a() + Delta*(k/N)) end
        return Partition {points=points}
      end,
  },
}

-- «Partition-tests»  (to ".Partition-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"

= Partition.new(2, 10)
= Partition.new(2, 10):splitn(4)
= Partition.new(2, 10):splitn(4):N()

ptn = Partition.new(2, 10):splitn(4)
for i=1,ptn:N() do
  print(i, ptn:ai(i), ptn:bi(i))
end

-- Use this do draw semicircles
ptn = Partition { points={} }
for _,theta in ipairs(seqn(math.pi, 0, 8)) do
  print(theta, math.cos(theta))
  table.insert(ptn.points, math.cos(theta))
end
= ptn

--]]




--  ____  _                                  
-- |  _ \(_) ___ _ __ ___   __ _ _ __  _ __  
-- | |_) | |/ _ \ '_ ` _ \ / _` | '_ \| '_ \ 
-- |  _ <| |  __/ | | | | | (_| | | | | | | |
-- |_| \_\_|\___|_| |_| |_|\__,_|_| |_|_| |_|
--                                           
-- «Riemann»  (to ".Riemann")
Riemann = Class {
  type    = "Riemann",
  fromspec = function (spec)
      local pws = PwSpec.from(spec)
      local f   = pws:fun()
      local pwf = PwFunction.from(f)
      for x,y in spec:gmatch("%( *([-.0-9]+) *, *([-.0-9]+) *%)") do
        pwf:addpoint(tonumber(x))
      end
      return Riemann { spec=spec, f=f, pws=pws, pwf=pwf }
    end,
  frompwf = function (pwf)
      return Riemann { pwf=pwf, f=pwf.f }
    end,
  fromf = function (f, ...)
      local pwf = PwFunction.from(f, ...)
      return Riemann.frompwf(pwf)
    end,
  __tostring = mytostringvp,
  __index = {
    piecewise_pol1 = function (rie, xc) -- for polygons
        local jumps, xyl, xyc, xyr = rie.pwf:jumps_and_xys(xc)
        if jumps == ""  
        then return xyc
        else return format("%s%s", xyl, xyr)
        end
      end,
    piecewise_pol = function (rie, a, b)
        local a0, b0 = rie.pwf:xy(a, 0), rie.pwf:xy(b, 0)
        return a0..pwi:piecewise(a, b, "piecewise_pol1", "")..b0
      end,
    pol = function (rie, a, b, star)
        -- return "\\polygon"..(star or "")..pwi:piecewise_pol(a, b)
        return Pict { "\\polygon"..(star or "")..rie.pwf:piecewise_pol(a, b) }
      end,
    --
    inforsup = function (rie, maxormin, a, b)
        local y = rie.f(a)
        local consider = function (x) y = maxormin(y, rie.f(x)) end
        consider(a + rie.pwf.eps)
        for _,x in ipairs(rie.pwf:pointsin(a, b)) do
          consider(x - rie.pwf.eps)
          consider(x)
          consider(x + rie.pwf.eps)
        end
        consider(b - rie.pwf.eps)
        consider(b)
        return y
      end,
    inf = function (rie, a, b) return rie:inforsup(min, a, b) end,
    sup = function (rie, a, b) return rie:inforsup(max, a, b) end,
    max = function (rie, a, b) return max(rie.f(a), rie.f(b)) end,
    min = function (rie, a, b) return min(rie.f(a), rie.f(b)) end,
    zero = function (rie) return 0 end,
    method = function (rie, mname, a, b) return rie[mname](rie, a, b) end,
    rct = function (rie, mname1, mname2, a, b)
        local y1 = rie:method(mname1, a, b)
        local y2 = rie:method(mname2 or "zero", a, b)
        return pformat("(%s,%s)(%s,%s)(%s,%s)(%s,%s)", a,y1, a,y2, b,y2, b,y1)
      end,
    rects = function (rie, ptn, mname1, mname2, star)
        local p = Pict {}
        for i=1,ptn:N() do
          local ai,bi = ptn:ai(i), ptn:bi(i)
          local rct = rie:rct(mname1, mname2, ai, bi)
          table.insert(p, format("\\polygon%s%s", star or "*", rct))
        end
        return p
      end,
    --
    setab   = function (rie, a, b) rie.a = a; rie.b = b; return rie end,
    ptn     = function (rie, N) return Partition.new(rie.a, rie.b):splitn(N) end,
    lineify = function (rie, a, b) return rie.pwf:lineify(a, b) end,
    areaify = function (rie) return rie.pwf:areaify(rie.a, rie.b) end,
    area    = function (rie) return rie.pwf:areaify(rie.a, rie.b) end,
    areams  = function (rie, N, mname1, mname2)
        return rie:rects(rie:ptn(N), mname1, mname2, "*")
      end,
    areainf = function (rie, N) return rie:areams(N, "zero", "inf") end,
    areasup = function (rie, N) return rie:areams(N, "zero", "sup") end,
    areainfsup = function (rie, N) return rie:areams(N, "inf", "sup") end,
  },
}

-- «Riemann-tests»  (to ".Riemann-tests")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
f = function (x) if x < 2 then return x^2 else return 2 end end
rie = Riemann.fromf(f, seq(0, 4, 0.125))
= rie
= rie.pwf
= rie.pwf:pw(1,4)
= rie.pwf:pw(1,4):show()
 (etv)

ptn   = Partition.new(1, 4):splitn(4)
curve = rie.pwf:pw(1,4)
rects = rie:rects(ptn, "inf", "sup", "*"):Color("Orange")
p = Pict {
  rects,
  curve,
}
= p:show()
 (etv)

rie   = Riemann.fromspec("(1,2)c--(3,4)--(5,2)c")
ptn   = Partition.new(2, 5):splitn(4)
curve = rie.pwf:pw(1, 5)
curve = rie.pws:topict()
rects = rie:rects(ptn, "inf", "sup", "*"):Color("Orange")
p = Pict {
  rects,
  curve,
}
= p:show()
 (etv)

 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
PictBounds.setbounds(v(0,0), v(8,5))
rie = Riemann.fromspec("(0,3)--(2,5)--(6,1)--(8,3)"):setab(1, 7)
p   = Pict {
        rie:areasup(3):color("yellow"),
        rie:areasup(12):color("blue"),
        rie:area   (3):Color("Orange"),
        rie:areainf(3):Color("Red"),
        rie:lineify(0, 8),
      }
= p
= p:show()
 (etv)

 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
PictBounds.setbounds(v(0,0), v(11,7))
rie = Riemann.fromspec("(0,3)--(3,6)--(8,1)--(11,4)"):setab(2, 10)

ColorUpperA = "red!20!white"
ColorUpperB = "Gold1!20!white"
ColorUpperC = "Green1!20!white"
ColorUpperD = "Blue1!20!white"
ColorLowerA = "red!80!white"
ColorLowerB = "Gold1!80!white"
ColorLowerC = "Green1!80!white"
ColorLowerD = "Blue1!80!white"
ColorRealInt = "Purple0!90!white"

UpperA  = rie:areasup( 2):color(ColorUpperA)
UpperB  = rie:areasup( 4):color(ColorUpperB)
UpperC  = rie:areasup( 8):color(ColorUpperC)
UpperD  = rie:areasup(16):color(ColorUpperD)
LowerD  = rie:areainf(16):color(ColorLowerD)
LowerC  = rie:areainf( 8):color(ColorLowerC)
LowerB  = rie:areainf( 4):color(ColorLowerB)
LowerA  = rie:areainf( 2):color(ColorLowerA)
RealInt = rie:area     ():color(ColorRealInt)

p = Pict {
      UpperA,
      UpperB,
      UpperC,
      UpperD,
      RealInt,
      LowerD,
      LowerC,
      LowerB,
      LowerA,
      rie:lineify(0, 11),
    }
= p
= p:show()
 (etv)

 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
para = function (x) return 4*x - x^2 end
vex  = function (str) return Code.ve("x => "..str) end
rievex = function (str) return Riemann.fromf(vex(str), seq(0, 4, 0.125)) end
rievexa = function (str, a, b)
    local rie = rievex(str)
    return Pict {
      rie.pwf:areaify(a, b):Color("Orange"),
      rie:lineify(0, 4),
    }
  end
= vex("para(x)")(2)
= vex("para(x)/2")(2)
p = rievexa("para(x)/2", 3, 4)
= p:show()
 (etv)

--]]


-- «Riemann-tests-sc»  (to ".Riemann-tests-sc")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true

-- Semicircle:
scxs = {}
for _,theta in ipairs(seqn(math.pi, 0, 32)) do
  table.insert(scxs, math.cos(theta))
end

f     = function (x) return math.sqrt(1 - x^2) end
rie   = Riemann.fromf(f, scxs)
ptn   = Partition.new(-1, 1):splitn(8)
curve = rie.pwf:pw(-1, 1)
rects = rie:rects(ptn, "inf", "sup", "*"):Color("Orange")
p = Pict {
  rects,
  curve,
}
= p:show()
 (etv)

p2 = p:setbounds(v(-2,0), v(2,2)):pgat("pgat"):preunitlength("40pt")
= p2:show("")
 (etv)

--]]






--  _____ _____ ____ _ 
-- |_   _|  ___/ ___/ |
--   | | | |_ | |   | |
--   | | |  _|| |___| |
--   |_| |_|   \____|_|
--                     
-- «TFC1»  (to ".TFC1")
TFC1 = Class {
  type  = "TFC1",
  frompwf = function (pwf) return TFC1 {pwf=pwf, f=pwf.f} end,
  fromf = function (f, ...) return TFC1.frompwf(PwFunction.from(f, ...)) end,
  fromspec = function (spec)
      local pws = PwSpec.from(spec)
      local pwf = pws:topwfunction()
      return TFC1 {pws=pws, pwf=pwf, f=pwf.f}
    end,
  __index = {
    setxts = function (tfc1, x0, x1, x3, t1, scale)
        tfc1.x0 = x0
        tfc1.x1 = x1
        tfc1.x3 = x3
        tfc1.t1 = t1
        tfc1.scale = scale
        return tfc1
      end,
    ttox = function (tfc1, t2) return (t2 - tfc1.t1)/tfc1.scale + tfc1.x1 end,
    xtot = function (tfc1, x2) return (x2 - tfc1.x1)*tfc1.scale + tfc1.t1 end,
    setpwg = function (tfc1)
        local g = function (t2)
            return tfc1.f(tfc1:ttox(t2))
          end
        local pwg = PwFunction.from(g)
        for x in tfc1.pwf.points:gen() do pwg:addpoint(tfc1:xtot(x)) end
        tfc1.g = g
        tfc1.pwg = pwg
        return tfc1
      end,
    areaify_f = function (tfc1) return tfc1.pwf:areaify(tfc1.x1, tfc1.x1 + 1/tfc1.scale) end,
    areaify_g = function (tfc1) return tfc1.pwg:areaify(tfc1.t1, tfc1.t1 + 1      ) end,
    lineify_f = function (tfc1) return tfc1.pwf:lineify(tfc1.x0, tfc1.x3)     end,
    lineify_g = function (tfc1) return tfc1.pwg:lineify(tfc1.t1, tfc1.t1 + 1) end,
    --
    areaify_f = function (tfc1)  -- corrected version
        local a,b = tfc1.x1, tfc1.x1 + 1/tfc1.scale
        return tfc1.pwf:areaify(min(a, b), max(a, b))
      end,
  },
}

-- «TFC1-tests»  (to ".TFC1-tests")
-- (c2m212tfc1p 5 "exemplo-1")
-- (c2m212tfc1a   "exemplo-1")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
f = function (x) if x < 2 then return x^2 else return 2 end end
f = function (x) return 4*x - x^2 end
tfc1 = TFC1.fromf(f, 0.9, 1, 1.1, 1.2)
tfc1:setxts(0,1,4, 5, 2)
tfc1:setxts(0,1,4, 5, 2):setpwg()
PPPV(tfc1)
= tfc1.pwf.points
= tfc1.pwf.points:ksc()
= tfc1.f(0.9)
= tfc1.g(4.8)

PictBounds.setbounds(v(0,0), v(7,5))
= tfc1.pwf:areaify(0, 4)

f = function (x) return 4*x - x^2 end
tfc1 = TFC1.fromf(f, seqn(0, 4, 16))
scale = 2
scale = 4
tfc1:setxts(0,1,4, 5, scale):setpwg()
PPPV(tfc1.pwf)
PPPV(tfc1.pwg)
p = Pict {
  tfc1:areaify_f():Color("Orange"),
  tfc1:areaify_g():Color("Orange"),
  tfc1:lineify_f(),
  tfc1:lineify_g(),
}
= p
= p:show()
 (etv)

 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
PictBounds.setbounds(v(0,0), v(8,5))
spec = "(0,2)--(1,1)--(2,3)--(3,4)--(4,3)"
spec = "(0,2)--(1,0)--(2,1)o (2,2)c (2,3)o--(3,4)--(4,3)"
tfc1 = TFC1.fromspec(spec)
tfc1:setxts(0,2,4, 5,  1/2)
tfc1:setxts(0,2,4, 5, -1/2)
p = Pict {
  tfc1:areaify_f():Color("Orange"),
  tfc1.pws:topict(),
}
= p
= p:show()
 (etv)

--]]





-- __  ___                  _              
-- \ \/ / |_ _____  ___   _| |_ ___  _   _ 
--  \  /| __/ _ \ \/ / | | | __/ _ \| | | |
--  /  \| || (_) >  <| |_| | || (_) | |_| |
-- /_/\_\\__\___/_/\_\\__, |\__\___/ \__, |
--                    |___/          |___/ 
--
-- «Xtoxytoy»  (to ".Xtoxytoy")
-- Draw figures of the form (x,0)c--(x,y)c--(0,y)c,
-- where y=f(x).
--
Xtoxytoy = Class {
  type = "Xtoxytoy",
  from = function (f, xs)
      local vlines = Pict {}
      local hlines = Pict {}
      local xdots  = Pict {}
      local xydots = Pict {}
      local ydots  = Pict {}
      for _,x in ipairs(xs) do
        local y = f(x)
        vlines:addline(v(x,0), v(x,y))
        hlines:addline(v(x,y), v(0,y))
        xdots :addcloseddotat(v(x,0))
        xydots:addcloseddotat(v(x,y))
        ydots :addcloseddotat(v(0,y))
      end
      return Xtoxytoy {vlines=vlines, hlines=hlines,
                       xdots=xdots, xydots=xydots, ydots=ydots}
    end,
  __index = {
    topict = function (xt, options)
        local p = Pict {}
        if options:match("v") then p:add(xt.vlines) end
        if options:match("h") then p:add(xt.hlines) end
        if options:match("x") then p:add(xt.xdots)  end
        if options:match("p") then p:add(xt.xydots) end
        if options:match("y") then p:add(xt.ydots)  end
        return p
      end,
  },
}



-- «Xtoxytoy-test1»  (to ".Xtoxytoy-test1")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
PictBounds.setbounds(v(0,0), v(8,6))
spec = "(0,1)--(5,6)--(7,4)"
pws = PwSpec.from(spec)
= pws:topict()
f = pws:fun()
xtos = Xtoxytoy.from(f, {1, 2})
= xtos:topict("hvxpy")
= xtos:topict("v")

p = Pict { pws:topict(), xtos:topict("v") }
= p
= p:show("pgat")
 (etv)

--]]



-- «Xtoxytoy-test2»  (to ".Xtoxytoy-test2")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
PictBounds.setbounds(v(0,0), v(23,9))
spec   = "(0,1)--(5,6)--(7,4)--(11,8)--(15,4)--(17,6)--(23,0)"
xs     = {    1,3,    6,     9,  11, 13,   16,19,    21      }
labely = -1
pws    = PwSpec.from(spec)
xtos   = Xtoxytoy.from(pws:fun(), xs)
vlines = xtos:topict("v")
curve  = pws:topict()
labels = Pict {}
for i,x in ipairs(xs) do
  labels:putstrat(v(x,labely), "\\cell{x_"..(i-1).."}")
end
p = Pict { vlines, curve:prethickness("2pt"), labels }
= p
= p:show("pA", {ul="10pt"})
 (etv)

--]]



-- «Xtoxytoy-test3»  (to ".Xtoxytoy-test3")
-- (find-LATEX "2022-1-C2-somas-3.tex" "imagens-figuras")
--[==[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
PictBounds.setbounds(v(0,0), v(8,4))

cthick = "2pt"     -- curve
dthick = "0.25pt"  -- dots
sthick = "4pt"     -- segments

-- Curve:
cspec   = "(0,2)--(2,4)--(6,0)--(8,2)"
cpws    = PwSpec.from(cspec)
curve   = cpws:topict():prethickness(cthick)

p = Pict { curve }
= p:show(nil, {ul="20pt"})
 (etv)

-- Dots:
dotsn = function (nsubsegs)
    local xs    = seqn(1, 4, nsubsegs)
    local dots0 = Xtoxytoy.from(cpws:fun(), xs)
    local dots  = dots0:topict("vhxpy"):prethickness(dthick):Color("Red")
    return dots
  end
= dotsn(6)
= dotsn(12)
p = Pict { curve, dotsn(6)  }
p = Pict { curve, dotsn(12) }
= p:show(nil, {ul="20pt"})
 (etv)

-- Segments:
sspec = "(1,0)c--(2,0)--(4,0)c" ..
       " (1,3)c--(2,4)--(4,2)c" ..
       " (0,2)c--(0,4)c"
spws   = PwSpec.from(sspec)
segs   = spws:topict():prethickness(sthick):Color("Orange")
p = Pict { curve, segs }
= p:show(nil, {ul="20pt"})
 (etv)

--]==]




--   ____ _                          __     __         
--  / ___| |__   __ _ _ __   __ _  __\ \   / /_ _ _ __ 
-- | |   | '_ \ / _` | '_ \ / _` |/ _ \ \ / / _` | '__|
-- | |___| | | | (_| | | | | (_| |  __/\ V / (_| | |   
--  \____|_| |_|\__,_|_| |_|\__, |\___| \_/ \__,_|_|   
--                          |___/                      
--
-- Draw figures to explain changes of variables.
-- (c2m221atisp 12 "substituicao-figura")
-- (c2m221atisa    "substituicao-figura")

-- «ChangeVar»  (to ".ChangeVar")
ChangeVar = Class {
  type    = "ChangeVar",
  __index = {
    setxs = function (cv, xmin, xmax, xs)
        local xtou = function (x) return cv:xtou(x) end
        local umin,umax = xtou(xmin), xtou(xmax)
        local us = map(xtou, xs)
        cv.xmin, cv.xmax, cv.xs = xmin, xmax, xs
        cv.umin, cv.umax, cv.us = umin, umax, us
        return cv
      end,
    setus = function (cv, umin, umax, us)
        local utox = function (u) return cv:utox(u) end
        local xmin,xmax = utox(umin), utox(umax)
        local xs = map(utox, us)
        cv.xmin, cv.xmax, cv.xs = xmin, xmax, xs
        cv.umin, cv.umax, cv.us = umin, umax, us
        return cv
      end,
    setpwfs = function (cv, n)
        local fx = function (x) return cv:fx(x) end
        local fu = function (u) return cv:fu(u) end
        local xs = seqn(cv.xmin, cv.xmax, n or 64)
        local us = seqn(cv.umin, cv.umax, n or 64)
        local pwfx = PwFunction.from(fx, xs)
        local pwfu = PwFunction.from(fu, us)
        cv.pwfx = pwfx
        cv.pwfu = pwfu
        return cv
      end,
    setcolors = function (cv, colors)
        cv.colors = split(colors or "red orange yellow")
        return cv
      end,
    --
    curvex = function (cv) return cv.pwfx:lineify(cv.xmin, cv.xmax) end,
    curveu = function (cv) return cv.pwfu:lineify(cv.umin, cv.umax) end,
    areax = function (cv, x0, x1) return cv.pwfx:areaify(x0, x1) end,
    areau = function (cv, u0, u1) return cv.pwfu:areaify(u0, u1) end,
    color = function (cv, i) return cv.colors[i] end,
    subareax = function (cv, i) return cv:areax(cv.xs[i], cv.xs[i+1]):color(cv:color(i)) end,
    subareau = function (cv, i) return cv:areau(cv.us[i], cv.us[i+1]):color(cv:color(i)) end,
    areasx = function (cv)
        local p = Pict {}
        for i=1,#cv.colors do table.insert(p, cv:subareax(i)) end
        return p
      end,
    areasu = function (cv)
        local p = Pict {}
        for i=1,#cv.colors do table.insert(p, cv:subareau(i)) end
        return p
      end,
    --
    labelat = function (cv, xy, str) return pformat("\\put%s{\\cell{%s}}", xy, str) end,
    xlabels = function (cv, y)
        local p = Pict {}
        for i=1,#cv.xs do
          table.insert(p, cv:labelat(v(cv.xs[i], y), "x_{"..(i-1).."}"))
        end
        return p
      end,
    ulabels = function (cv, y)
        local p = Pict {}
        for i=1,#cv.us do
          table.insert(p, cv:labelat(v(cv.us[i], y), "u_{"..(i-1).."}"))
        end
        return p
      end,
    --
    rect = function (cv, a, b, y)
        return Pict({}):addregion0(v(a,0), v(a,y), v(b,y), v(b,0))
      end,
  },
}

-- «ChangeVar-test1»  (to ".ChangeVar-test1")
-- Supersedes: (to "PwFunction-intfig")
-- See: (c2m232ipp 9 "mv-figura")
--      (c2m232ipa   "mv-figura")
--[==[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Piecewise2.lua"
usepackages.edrx21 = true
pi, sqrt, sin, cos = math.pi, math.sqrt, math.sin, math.cos
xtou = function (x) return x^2 end
ve = Code.ve

cv = ChangeVar {
  xtou = ve " cv,x =>     x^2        ",
  fx   = ve " cv,x => sin(x^2) * 2*x ",
  fu   = ve " cv,u => sin( u )       ",
  utox = ve " cv,u =>  sqrt(u)       ",
}
cv:setus(0, pi, {0, 1, 2, 3})
PPPV(cv)
cv:setpwfs()
cv:setcolors()
PPPV(cv)
= cv:subareax(1)
= cv:areasx()
= cv:curvex()
= cv:xlabels(-0.5)
= cv:rect(1, 1.5, 0.5):color("blue")
= cv:rect(cv.xs[2], cv.xs[3], cv:fx(cv.xs[2])):color("blue")

Pict2e.bounds = PictBounds.new(v(0,0), v(4,3))
ppx = Pict {
  cv:areasx(),
  cv:curvex(),
  cv:rect(cv.xs[2], cv.xs[3], cv:fx(cv.xs[2])):color("blue"),
  cv:xlabels(-0.35),
}
ppu = Pict {
  cv:areasu(),
  cv:curveu(),
  cv:ulabels(-0.35)
}
pp2 = Pict {
  ppx:pgat("pgatc"),
  "\\qquad",
  ppu:pgat("pgatc"),
}
= ppu:show(nil, {ul="50pt", scale="0.7"})
= pp2:show("",  {ul="50pt", scale="0.7"})
 (etv)

--]==]







-- Local Variables:
-- coding:  utf-8-unix
-- End:
