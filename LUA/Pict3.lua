-- This file:
--   http://anggtwu.net/LUA/Pict3.lua.html
--   http://anggtwu.net/LUA/Pict3.lua
--          (find-angg "LUA/Pict3.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This file defines the middle-level methods of the Pict class.
--
-- The Pict class has low-level methods, defined in this other file,
--   (find-angg "LUA/Indent2.lua" "Pict")
-- and medium-level methods, defined below, in these sections:
--   (to "Points2-methods")
--   (to "PictBounds-methods")
--   (to "Pict-show")
--
-- (defun p2  () (interactive) (find-angg "LUA/Pict2e2.lua"))
-- (defun p3  () (interactive) (find-angg "LUA/Pict3.lua"))
-- (defun i2  () (interactive) (find-angg "LUA/Indent2.lua"))
-- (defun ps1 () (interactive) (find-angg "LUA/PictShow1.lua"))
-- (defun pw2 () (interactive) (find-angg "LUA/Piecewise2.lua"))
--
-- Used by:
--   (find-angg "LUA/Piecewise2.lua")
--   (find-angg "LUA/Numerozinhos1.lua")
--   (find-angg "LUA/Surface1.lua")
--   (find-angg "LUA/ExprDxDy1.lua")

-- «.Points2»			(to "Points2")
-- «.Points2-tests»		(to "Points2-tests")
-- «.Points2-methods»		(to "Points2-methods")
-- «.Points2-methods-tests»	(to "Points2-methods-tests")
-- «.PictBounds»		(to "PictBounds")
-- «.PictBounds-tests»		(to "PictBounds-tests")
-- «.usepackages»		(to "usepackages")
-- «.PictBounds-methods»	(to "PictBounds-methods")
--   «.Pict-show»		(to "Pict-show")
-- «.PictBounds-methods-tests»	(to "PictBounds-methods-tests")
-- «.Pict-show-tests»		(to "Pict-show-tests")

require "Indent2"  -- (find-angg "LUA/Indent2.lua")
                   -- (find-angg "LUA/Indent2.lua" "Pict")
require "MiniV1"   -- (find-angg "LUA/MiniV1.lua"  "MiniV-tests")
require "Show2"    -- (find-angg "LUA/Show2.lua")

V = MiniV
v = V.fromab



--  ____       _       _       
-- |  _ \ ___ (_)_ __ | |_ ___ 
-- | |_) / _ \| | '_ \| __/ __|
-- |  __/ (_) | | | | | |_\__ \
-- |_|   \___/|_|_| |_|\__|___/
--                             
-- «Points2»  (to ".Points2")
--
Points2 = Class {
  type = "Points2",
  new  = function () return Points2 {} end,
  from = function (...) return Points2 {...} end,
  __tostring = function (pts) return pts:tostring() end,
  __index = {
    add = function (pts, pt) table.insert(pts, pt); return pts end,
    adds = function (pts, pts2)
        for _,pt in ipairs(pts2) do pts:add(pt) end
        return pts
      end,
    --
    tostring = function (pts, sep) return mapconcat(tostring, pts, sep or "") end,
    pict2e   = function (pts, prefix) return prefix..tostring(pts) end,
    Line     = function (pts) return pts:pict2e("\\Line") end,
    polygon  = function (pts,s) return pts:pict2e("\\polygon"..(s or "")) end,
    region0  = function (pts) return pts:polygon("*") end,
    rev      = function (pts) return table.reverse(pts) end,
    -- region0 = function (pts) return pts:pict2e("\\polygon*") end,
    -- region = function (pts, color) return pts:region0():color(color) end,
    -- region = function (pts, color) return pts:region0() end,
  },
}

-- «Points2-tests»  (to ".Points2-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict3.lua"

a = VTable {20, 30, 40}
= a
= table.reverse(a)

pts = Points2 {v(1,2), v(3,4), v(3,1)}
= pts
= pts:Line()
= pts:Line()
= pts:rev()
= pts:add(pts:rev())

pts = Points2 {v(1,2), v(3,4), v(3,1)}
PPP(pts:Line())
= pts:Line()
= pts:polygon()
= pts:region0()

= pts:Line():bshow()
 (etv)
= pts:polygon():bshow()
 (etv)
= pts:region0():bshow()
 (etv)

--]]

-- «Points2-methods»  (to ".Points2-methods")
-- Based on: (find-angg "LUA/Pict2e2.lua" "Pict")
--
table.addentries(Pict.__index,
  { addline    = function (p, ...) return p:add(Points2.from(...):Line())    end,
    addpolygon = function (p, ...) return p:add(Points2.from(...):polygon()) end,
    addregion0 = function (p, ...) return p:add(Points2.from(...):region0()) end,
    --
    addfmt     = function (p, ...)     return p:add(pformat(...)) end,
    putstrat   = function (p, xy, str) return p:addfmt("\\put%s{%s}", xy, str) end,
    putfmtat   = function (p, xy, ...) return p:putstrat(xy, pformat(...)) end,
    putcellat  = function (p, xy, str) return p:putfmtat(xy, "\\cell{%s}", str) end,
    puttcellat = function (p, xy, str) return p:putfmtat(xy, "\\cell{\\text{%s}}", str) end,
    --
    addopendotat   = function (p, xy) return p:putstrat(xy, "\\opendot")   end,
    addcloseddotat = function (p, xy) return p:putstrat(xy, "\\closeddot") end,
    predotdims = function (p, c, o)
        local fmt1 = "\\def\\closeddot{\\circle*{%s}}"
        local fmt2 = "\\def\\opendot  {\\circle*{%s}\\color{white}\\circle*{%s}}"
        return Pict { pformat(fmt1,c), pformat(fmt2,c,o), p }
      end,
    predotdims1 = function (p, co)
        local c, o = unpack(split(co))
        return p:predotdims(c, o)
      end,
  })

-- «Points2-methods-tests»  (to ".Points2-methods-tests")
--[[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict3.lua"
p = Pict {}
= p:addline   (v(1,2), v(3,4), v(3,1))
= p:addpolygon(v(1,2), v(3,4), v(3,1))
= p:addregion0(v(1,2), v(3,4), v(3,1))
q = p:color"Orange1"
q = p:color"Orange1":addopendotat(v(1,1))
= q
= q:pgat("pgat")
= q:show("pgat")
= Show.log
= outertexbody
 (etv)

--]]




--  ____  _      _   ____                        _     
-- |  _ \(_) ___| |_| __ )  ___  _   _ _ __   __| |___ 
-- | |_) | |/ __| __|  _ \ / _ \| | | | '_ \ / _` / __|
-- |  __/| | (__| |_| |_) | (_) | |_| | | | | (_| \__ \
-- |_|   |_|\___|\__|____/ \___/ \__,_|_| |_|\__,_|___/
--                                                     
-- «PictBounds»  (to ".PictBounds")
-- (find-LATEX "edrxpict.lua" "pictp0-pictp3")
-- (find-es "pict2e" "picture-mode")
-- (find-kopkadaly4page (+ 12 288) "\\begin{picture}(x dimen,y dimen)")
-- (find-kopkadaly4text (+ 12 288) "\\begin{picture}(x dimen,y dimen)")
-- (find-kopkadaly4page (+ 12 301) "13.1.6 Shifting a picture environment")
-- (find-kopkadaly4text (+ 12 301) "13.1.6 Shifting a picture environment")
-- (find-kopkadaly4page (+ 12 302) "\\begin{picture}(x dimen,y dimen)(x offset,y offset)")
-- (find-kopkadaly4text (+ 12 302) "\\begin{picture}(x dimen,y dimen)(x offset,y offset)")

PictBounds = Class {
  type = "PictBounds",
  new  = function (ab, cd, e)
      local a,b = ab[1], ab[2]
      local c,d = cd[1], cd[2]
      local x1,x2 = min(a,c), max(a,c)
      local y1,y2 = min(b,d), max(b,d)
      return PictBounds {x1=x1, y1=y1, x2=x2, y2=y2, e=e or .2}
    end,
  --
  -- (find-angg "LUA/Pict2e1.lua" "Pict2e" "getbounds =")
  getbounds = function ()
      return PictBounds.bounds or PictBounds.new(v(0,0), v(3, 2))
    end,
  setbounds = function (...)
      PictBounds.bounds = PictBounds.new(...)
    end,
  --
  __tostring = function (pb) return pb:tostring() end,
  __index = {
    x0 = function (pb) return pb.x1 - pb.e end,
    x3 = function (pb) return pb.x2 + pb.e end,
    y0 = function (pb) return pb.y1 - pb.e end,
    y3 = function (pb) return pb.y2 + pb.e end,
    p0 = function (pb) return v(pb.x1 - pb.e, pb.y1 - pb.e) end,
    p1 = function (pb) return v(pb.x1,        pb.y1       ) end,
    p2 = function (pb) return v(pb.x2,        pb.y2       ) end,
    p3 = function (pb) return v(pb.x2 + pb.e, pb.y2 + pb.e) end,
    tostring = function (pb)
        return pformat("LL=(%s,%s) UR=(%s,%s) e=%s",
          pb.x1, pb.y1, pb.x2, pb.y2, pb.e)
      end,
    --
    beginpicture = function (pb)
        local dimen  =  pb:p3() - pb:p0()
        local center = (pb:p3() + pb:p0()) * 0.5
        local offset =  pb:p0()
        return pformat("\\begin{picture}%s%s", dimen, offset)
      end,
    --
    grid = function (pb)
        local p = Pict({"% Grid", "% Horizontal lines:"})
        for y=pb.y1,pb.y2 do p:addline(v(pb:x0(), y), v(pb:x3(), y)) end
        p:add("% Vertical lines:")
        for x=pb.x1,pb.x2 do p:addline(v(x, pb:y0()), v(x, pb:y3())) end
        return p
      end,
    ticks = function (pb, e)
        e = e or .2
        local p = Pict({"% Ticks", "% On the vertical axis:"})
        for y=pb.y1,pb.y2 do p:addline(v(-e, y), v(e, y)) end
        p:add("% On the horizontal axis:")
        for x=pb.x1,pb.x2 do p:addline(v(x, -e), v(x, e)) end
        return p
      end,
    axes = function (pb)
        local p = Pict({"% Axes"})
        return p:addline(v(pb:x0(), 0), v(pb:x3(), 0))
                :addline(v(0, pb:y0()), v(0, pb:y3()))
      end,
    axesandticks = function (pb)
        return Pict { pb:axes(), pb:ticks() }
      end,
    --
    -- 2023jun08:
    hticks = function (pb, e)
        e = e or .2
        local p = Pict {"% On the horizontal axis:"}
        for x=pb.x1,pb.x2 do p:addline(v(x, -e), v(x, e)) end
        return p
      end,
    vticks = function (pb, e)
        e = e or .2
        local p = Pict {"% On the vertical axis:"}
        for y=pb.y1,pb.y2 do p:addline(v(-e, y), v(e, y)) end
        return p
      end,
    haxis = function (pb)
        return Pict({}):addline(v(pb:x0(), 0), v(pb:x3(), 0))
      end,
    vaxis = function (pb)
        return Pict({}):addline(v(0, pb:y0()), v(0, pb:y3()))
      end,
    haxisandticks = function (pb)
        return Pict { "% Horizontal axis and ticks:", pb:haxis(), pb:hticks() }
      end,
  },
}

-- «PictBounds-tests»  (to ".PictBounds-tests")
-- (find-LATEX "edrxpict.lua" "pictp0-pictp3")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict3.lua"

= PictBounds.new(v(-1,-2), v( 3, 5))
= PictBounds.new(v( 3, 5), v(-1,-2))
= PictBounds.new(v( 3, 5), v(-1,-2), 0.5)
pb = PictBounds.new(v(-1,-2), v( 3, 5))
= pb:p0()
= pb:p1()
= pb:p2()
= pb:p3()

= pb:grid()
= pb:ticks()
= pb:axes()
= pb:axesandticks()
= pb:grid():prethickness("0.5pt")
= pb:grid():prethickness("0.5pt"):color("gray")

= pb
= pb:beginpicture()

= pb:p0()
= (pb:p0() + pb:p3())
= (pb:p0() + pb:p3()) * 0.5

--]]


--                                  _                         
--  _   _ ___  ___ _ __   __ _  ___| | ____ _  __ _  ___  ___ 
-- | | | / __|/ _ \ '_ \ / _` |/ __| |/ / _` |/ _` |/ _ \/ __|
-- | |_| \__ \  __/ |_) | (_| | (__|   < (_| | (_| |  __/\__ \
--  \__,_|___/\___| .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/
--                |_|                         |___/           
--
-- «usepackages»  (to ".usepackages")
-- For ":show".
-- See: (find-angg "LUA/Show2.lua" "texbody")
--      (find-angg "LUA/Show2.lua" "usepackages")
--      (find-angg "LUA/Show2.lua" "usepackages" "usepackages_pict2e")
usepackages.pict2e = true



--  ____  _      _   ____                        _                  
-- |  _ \(_) ___| |_| __ )  ___  _   _ _ __   __| |___    _ __ ___  
-- | |_) | |/ __| __|  _ \ / _ \| | | | '_ \ / _` / __|  | '_ ` _ \ 
-- |  __/| | (__| |_| |_) | (_) | |_| | | | | (_| \__ \  | | | | | |
-- |_|   |_|\___|\__|____/ \___/ \__,_|_| |_|\__,_|___/  |_| |_| |_|
--                                                                  
-- This block "adds PictBounds methods to the class Pict".
-- More precisely, it adds to Pict.__index, that is the table of methods
-- for the class Pict, a bunch of new methods that call things from the
-- class PictBounds.
-- Based on: (find-angg "LUA/Pict2e1.lua" "PictBounds-methods")
--
-- «PictBounds-methods»  (to ".PictBounds-methods")
--   
table.addentries(Pict.__index,
  { gb        = function (p) return PictBounds.getbounds() end,
    getbounds = function (p) return PictBounds.getbounds() end,
    setbounds = function (p,...) PictBounds.setbounds(...); return p end,
    --
    bep0      = function (p) return p:gb():beginpicture(), "\\end{picture}" end,
    bep       = function (p) return p:wrapbe(p:bep0()) end,
    --
    grid0          = function (p) return p:gb():grid() end,
    axes0          = function (p) return p:gb():axes() end,
    axesandticks0  = function (p) return p:gb():axesandticks() end,
    haxisandticks0 = function (p) return p:gb():haxisandticks() end,
    --
    gridstyle  = function (p) return p:pre0("\\pictgridstyle"):wrap1() end,
    axesstyle  = function (p) return p:pre0("\\pictaxesstyle"):wrap1() end,
    naxesstyle = function (p) return p:pre0("\\pictnaxesstyle"):wrap1() end,
    --
    pregrid          = function (p) return p:pre0(p:grid0():gridstyle()) end,
    preaxes          = function (p) return p:pre0(p:axes0():axesstyle()) end,
    preaxesandticks  = function (p) return p:pre0(p:axesandticks0():axesstyle()) end,
    prehaxisandticks = function (p) return p:pre0(p:haxisandticks0():axesstyle()) end,
    prenaxesandticks = function (p) return p:pre0(p:axesandticks0():naxesstyle()) end,
    --
    -- "PGAT" means "Picture, Grid, Axes, Ticks".
    -- This method adds begin/end picture, grid, axes, and ticks to a
    -- Pict2e object, in the right order, and with a very compact syntax
    -- to select what will be added. It can also add a bhbox and a def.
    pgat = function (p, str, opts)
        opts = opts or {}
        if str:match("a") then p = p:preaxesandticks() end
        if str:match("A") then p = p:preaxes() end
        if str:match("N") then p = p:prenaxesandticks() end  -- for numerozinhos
        if str:match("h") then p = p:prehaxisandticks() end  -- for estatistica
        if str:match("g") then p = p:pregrid() end
        if str:match("p") then p = p:bep() end
        if str:match("c") then p = p:myvcenter() end
        if str:match("B") then p = p:bhbox() end
        if opts.dotdims   then p = p:predotdims1(opts.dotdims) end
        if opts.ul        then p = p:preunitlength(opts.ul) end
        if opts.scale     then p = p:scalebox(opts.scale) end
        if opts.def       then p = p:def(opts.def) end
        if opts.sa        then p = p:sa(opts.sa) end
        return p
      end,
    --
    -- «Pict-show»  (to ".Pict-show")
    -- The method ":show" for strings is described here,
    --   (find-angg "LUA/Show2.lua" "StringShow")
    -- and it works like this:
    --
    --   body,opts --:show00--> texbody --> tostring(outertexbody) --> status
    --          \ \--:show0----------------^                          ^
    --           \---:show-------------------------------------------/
    --
    -- The methods ":show" and ":show0" for pict objects work like this:
    --
    --   p,str,opts --:show0--> p2 --> texbody --> status
    --             \--:show-----------------------^
    --
    -- the method ":show0" converts a first pict object, p, to another
    -- pict object, p2, by calling ":pgat" with the arguments "str"
    -- and "opts" (see above); ":show" does that and also converts p2
    -- to a string, sets the global variable "texbody", and calls
    -- Show.try.
    --
    -- Note that the conversion "p2 --> texbody" converts a pict
    -- object to an indent obejct as an intermediate step. The details
    -- are here:
    --   (find-angg "LUA/Indent2.lua" "Pict")
    --
    show0 = function (p,str,opts)
        local p2 = p:pgat(str or "pgat", opts)
        return p2
      end,
    show = function (p,str,opts)
        texbody = p:show0(str,opts):tostring("%")
        return Show.try(tostring(outertexbody))
      end,

  })

-- «PictBounds-methods-tests»  (to ".PictBounds-methods-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict3.lua"
ab = Pict {"a", "b"}
= ab:bep0()
= ab:bep()
= ab:bep():wrap1()

= ab:   grid0()
= ab:   gridstyle()
= ab:pregrid()

= ab:   axes0()
= ab:   axesandticks0()
= ab:   axesstyle()
= ab:  naxesstyle()
= ab: preaxes()
= ab: preaxesandticks()
= ab:prenaxesandticks()

= ab:pgat("a")
= ab:pgat("A")
= ab:pgat("N")
= ab:pgat("g")
= ab:pgat("p")
= ab:pgat("c")
= ab:pgat("B")
= ab:pgat(" ", {def="foo"})
= ab:pgat(" ", {def="foo"}):tostring("%")
= ab:pgat(" ", {sa="a long name"})
= ab:pgat(" ", {sa="a long name", scale=0.5})
= ab:pgat("pgat")
= ab:pgat("pgat"):wrap1()

--]]


-- «Pict-show-tests»  (to ".Pict-show-tests")
--[[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Pict3.lua"

p = Pict{}:addline(v(1,1), v(2,2), v(3,1)):prethickness"2pt"
= p
= p:show0()
= p:show0("pg")
= p:show0("pg", {scale=2})
= p:show ("pg", {scale=2})
 (etv)

= Show.log
= Show.bigstr

--]]



-- Local Variables:
-- coding:  utf-8-unix
-- End:
