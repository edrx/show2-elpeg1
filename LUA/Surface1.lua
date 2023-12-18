-- This file:
--   http://anggtwu.net/LUA/Surface1.lua.html
--   http://anggtwu.net/LUA/Surface1.lua
--          (find-angg "LUA/Surface1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/Surface1.lua"))
-- (defun o () (interactive) (find-LATEX "2021-1-C3-3D.lua"))
-- Supersedes: (find-LATEX "2020-2-C3-plano-tang.lua")
--             (find-LATEX "2021-1-C3-3D.lua")
--

-- «.V3»				(to "V3")
-- «.V3-tests»				(to "V3-tests")
-- «.Pgat3»				(to "Pgat3")
-- «.Pgat3-tests»			(to "Pgat3-tests")
-- «.Surface»				(to "Surface")
-- «.Surface-tests»			(to "Surface-tests")
-- «.test-piramide»			(to "test-piramide")
-- «.test-cruz»				(to "test-cruz")

require "Pict3"   -- (find-angg "LUA/Pict3.lua")



-- «V3»  (to ".V3")
-- (find-es "dednat" "V3")
--
V3 = Class {
  type    = "V3",
  __tostring = function (v) return v:tostring() end,
  __add      = function (v, w) return V3{v[1]+w[1], v[2]+w[2], v[3]+w[3]} end,
  __sub      = function (v, w) return V3{v[1]-w[1], v[2]-w[2], v[3]-w[3]} end,
  __unm      = function (v) return v*-1 end,
  __mul      = function (v, w)
      local ktimesv   = function (k, v) return V3{k*v[1], k*v[2], k*v[3]} end
      local innerprod = function (v, w) return v[1]*w[1] + v[2]*w[2] + v[3]*w[3] end
      if     type(v) == "number" and type(w) == "table" then return ktimesv(v, w)
      elseif type(v) == "table" and type(w) == "number" then return ktimesv(w, v)
      elseif type(v) == "table" and type(w) == "table"  then return innerprod(v, w)
      else error("Can't multiply "..tostring(v).."*"..tostring(w))
      end
    end,
  threeD = "3D",
  __index = {
    -- tostring = function (v) return v:v3string() end,
    tostring = function (v)
        if V3.threeD == "2D" then return v:v2string() end
        if V3.threeD == "3D" then return v:v3string() end
        error("V3.threeD is neither '2D' or '3D'")
      end,
    v3string = function (v) return pformat("(%s,%s,%s)", v[1], v[2], v[3]) end,
    v2string = function (v) return tostring(v:tov2()) end,
    tow  = function (A,B,t) return A+(B-A)*t end,
    --
    -- Convert v3 to v2 using a primitive kind of perspective.
    -- Adjust p1, p2, p3 to change the perspective.
    tov2 = function (v) return v[1]*v.p1 + v[2]*v.p2 + v[3]*v.p3 end,
    p1 = V{2,-1},
    p2 = V{2,1},
    p3 = V{0,2},
    --
    Line = function (A, v) return pformat("\\Line%s%s", A, A+v) end,
    Lines = function (A, v, w, i, j)
        local p = Pict {}
        for k=i,j do p:add((A+k*w):Line(v)) end
        return p
      end,
    --
    xticks = function (_,n,eps)
        eps = eps or 0.15
        return v3(0,-eps,0):Lines(v3(0,2*eps,0), v3(1,0,0), 0, n)
      end,
    yticks = function (_,n,eps)
        eps = eps or 0.15
        return v3(-eps,0,0):Lines(v3(2*eps,0,0), v3(0,1,0), 0, n)
      end,
    zticks = function (_,n,eps)
        eps = eps or 0.15
        return v3(-eps,0,0):Lines(v3(2*eps,0,0), v3(0,0,1), 0, n)
      end,
    axeswithticks = function (_,x,y,z)
        local p = Pict {}
	p:add(v3(0,0,0):Line(v3(x+0.5, 0, 0)))
	p:add(v3(0,0,0):Line(v3(0, y+0.5, 0)))
	p:add(v3(0,0,0):Line(v3(0, 0, z+0.5)))
        p:add(_:xticks(x))
        p:add(_:yticks(y))
        p:add(_:zticks(z))
        return p
      end,
    xygrid = function (_,x,y)
        local p = Pict {}
        p:add(v3(0,0,0):Lines(v3(0,y,0), v3(1,0,0), 0, x))
        p:add(v3(0,0,0):Lines(v3(x,0,0), v3(0,1,0), 0, y))
        return p
      end,
  },
}

v3 = function (x,y,z) return V3{x,y,z} end

-- Choose one:
-- V3.__index.tostring = function (v) return v:v2string() end
-- V3.__index.tostring = function (v) return v:v3string() end

-- «V3-tests»  (to ".V3-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Surface1.lua"

-- (c3m211cnp 15 "figura-piramide")
-- (c3m211cna    "figura-piramide")

fw = function (x) return max(min(x-2, 6-x), 0) end
FP = function (x,y) return min(fw(x), fw(y)) end
FC = function (x,y) return max(fw(x), fw(y)) end
sP = Surface.new(FP, 4, 4)
sC = Surface.new(FC, 4, 4)

-- \beginpicture(0,-2)(18,12)

= v3():xygrid(7,7)

= v3():axeswithticks(7,7,2)
sP:segment(v(0,2), v(7,2), nil, 7)
sP:segment(v(0,3), v(7,3), nil, 7)
sP:segment(v(0,4), v(7,4), nil, 7)
sP:segment(v(0,5), v(7,5), nil, 7)
sP:segment(v(0,6), v(7,6), nil, 7)

sP:segment(v(2,0), v(2,7), nil, 7)
sP:segment(v(3,0), v(3,7), nil, 7)
sP:segment(v(4,0), v(4,7), nil, 7)
sP:segment(v(5,0), v(5,7), nil, 7)
sP:segment(v(6,0), v(6,7), nil, 7)

sP:segment(v(2,2), v(6,6), nil, 4)
sP:segment(v(2,6), v(6,2), nil, 4)

V3.threeD = "2D"
= sP:segment(v(2,6), v(6,2), nil, 4)
V3.threeD = "3D"
= sP:segment(v(2,6), v(6,2), nil, 4)

--]]



--  ____             _   _____ 
-- |  _ \ __ _  __ _| |_|___ / 
-- | |_) / _` |/ _` | __| |_ \ 
-- |  __/ (_| | (_| | |_ ___) |
-- |_|   \__, |\__,_|\__|____/ 
--       |___/                 
--
-- «Pgat3»  (to ".Pgat3")
--
Pgat3 = Class {
  type      = "Pgat3",
  setbounds = function (maxx,maxy,maxz)
      Pgat3.maxx = maxx
      Pgat3.maxy = maxy
      Pgat3.maxz = maxz
    end,
  gat = function ()
      local maxx,maxy,maxz = Pgat3.maxx,Pgat3.maxy,Pgat3.maxz
      return Pict { v3():xygrid(maxx, maxy):Color("Gray"),
                    v3():axeswithticks(maxx, maxy, maxz) }
    end,
  pgat = function (p)
      local p2 = Pict { Pgat3.gat(), p }
      return p2:pgat("pc")
    end,
  set772 = function ()
      V3.__index.p1 = V {2.0, -0.2}
      V3.__index.p2 = V {0.5, 1.5}
      V3.__index.p3 = V {0, 0.75}
      Pgat3.setbounds(7,7,2)
      PictBounds.setbounds(v(0,-2), v(18,12))
    end,
  set433 = function ()
      V3.__index.p1 = V{2,   -0.5}
      V3.__index.p2 = V{0.5, 1.7}
      V3.__index.p3 = V{0,   0.5}
      Pgat3.setbounds(4,3,3)
      PictBounds.setbounds(v(0,-3), v(10,6))
    end,
  set433_2D = function ()
      PictBounds.setbounds(v(0,0), v(5,4))
    end,
  __index = {
  },
}

Pict.__index.pgat3 = function (p) return Pgat3.pgat(p) end

-- «Pgat3-tests»  (to ".Pgat3-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Surface1.lua"
V3.threeD = "2D"
Pgat3.set772()
p = Pict{} :pgat3()
= p
= p:show("", {scale=0.4})
 (etv)

= p:show("B", {scale=0.4})
 (etv)

Pgat3.set433()
p = Pict{} :pgat3()
= p
= p:show("", {scale=0.7})
 (etv)

--]]




-- «Surface»  (to ".Surface")
-- (find-dn6 "picture.lua" "V")
-- (find-dn6 "diagforth.lua" "newnode:at:")
--
Surface = Class {
  type = "Surface",
  new  = function (f, x0_, y0_)
      x0_ = x0_ or x0
      y0_ = y0_ or y0
      return Surface {f=f, x0=x0_, y0=y0_, xy0=v(x0_, y0_)}
    end,
  __tostring = function (s) return mytostringv(s) end,
  __index = {
    xyz = function (s, xy, zvalue)
        return v3(xy[1], xy[2], zvalue or s.f(xy[1], xy[2]))
      end,
    xyztow = function (s, xy1, xy2, zvalue, k)
        return s:xyz(xy1:tow(xy2, k), zvalue)
      end,
    segment = function (s, xy1, xy2, zvalue, n)
        local str = ""
        for i=0,n do
          str = str .. s:xyztow(xy1, xy2, zvalue, i/n):tostring()
        end
        return "\\Line"..str
      end,
    pillar = function (s, xy)
        return "\\Line" ..
	  s:xyz(xy,   0):tostring() ..
	  s:xyz(xy, nil):tostring()
      end,
    pillars = function (s, xy1, xy2, n)
        local p = Pict {}
        for i=0,n do p:add(s:pillar(xy1:tow(xy2, i/n))) end
        return p
      end,
    segmentstuff = function (s, xy1, xy2, n, what)
        local p = Pict {}
        if what:match"0" then p:add(s:segment(xy1, xy2, 0,   1)) end
        if what:match"c" then p:add(s:segment(xy1, xy2, nil, n)) end
        if what:match"p" then p:add(s:pillars(xy1, xy2,      n)) end
        return p
      end,
    --
    stoxy = function (s, str)
        return expr(format("MiniV {%s}", str))
      end,
    --
    -- The functions that use x0 and y0 start here
    squarestuff = function (s, dxy0s, dxy1s, n, what)
        local dxy0 = s:stoxy(dxy0s)
        local dxy1 = s:stoxy(dxy1s)
        local xy1 = s.xy0 + dxy0
        local xy2 = s.xy0 + dxy1
        return s:segmentstuff(xy1, xy2, n, what)
      end,
    squarestuffp = function (s, n, what, pair)
        local dxy0,dxy1 = unpack(split(pair))
	return s:squarestuff(dxy0, dxy1, n, what)
      end,
    squarestuffps = function (s, n, what, listofpairs)
        local p = Pict {}
        for _,pair in ipairs(listofpairs) do
          p:add(s:squarestuffp(n, what, pair))
        end
        return p
      end,
    --
    horizontals = function (s, n, what)
        return s:squarestuffps(n, what, {
          "-1,-1 1,-1", "-1,0 1,0", "-1,1 1,1"
          })
      end,
    verticals = function (s, n, what)
        return s:squarestuffps(n, what, {
          "-1,-1 -1,1", "0,-1 0,1", "1,-1 1,1"
          })
      end,
    diagonals = function (s, n, what)
        return s:squarestuffps(n, what, {
          "-1,-1 1,1", "-1,1 1,-1"
          })
      end,
    square = function (s, n, what)
        return Pict { s:horizontals(n, what),
                      s:verticals  (n, what) }
      end,
    squareanddiagonals = function (s, n)
        return Pict { s:square   (2, "p"):Color("Gray"),
                      s:square   (n, "0"),
                      s:square   (n, "c"),
                      s:diagonals(n, "c") }
      end,
  },
}


-- «Surface-tests»  (to ".Surface-tests")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Surface1.lua"

F = function (x, y) return 10*x + y end
srf = Surface.new(F, 3, 4)
= srf:xyz(v(2, 5))
= srf:xyz(v(2, 5), 0)

= srf:xyztow (v(2,5), v(22,25), nil,  0.5)
= srf:xyztow (v(2,5), v(22,25), 0,    0.5)
= srf:segment(v(2,5), v(22,25), 0,   2)
= srf:segment(v(2,5), v(22,25), nil, 2)
= srf:pillar(v(2,5))
= srf:segmentstuff(v(2,5), v(22,25), 2, "0cp")

= srf:stoxy("30,40")
= srf:squarestuff("0,0", "2,2", 2, "0")
= srf:squarestuff("0,0", "2,2", 2, "c")
= srf:squarestuff("0,0", "2,2", 2, "p")
= srf:squarestuffp(             2, "p",  "0,0 2,2")
= srf:squarestuffps(            2, "p", {"0,0 2,2", "0,0 2,2"})

= srf:square   (2, "p")
= srf:square   (4, "p")
= srf:square   (2, "c")
= srf:square   (4, "c")
= srf:square   (8, "c")
= srf:diagonals(2, "p")

V3.__index.p1 = V {2.0, -0.2}
V3.__index.p2 = V {0.5, 1.5}
V3.__index.p3 = V {0, 0.75}

V3.threeD = "2D"
V3.threeD = "3D"
= v3():xygrid(7,7)
= v3():axeswithticks(7,7,2)

-- Broken:
= sP:segment(v(0,4), v(6,4), nil, 6)

= v3():gat(7,7,2)
= v3():gat(7,7,2):show("p", {scale=0.4})
 (etv)

--]]


-- «test-piramide»  (to ".test-piramide")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Surface1.lua"
usepackages.edrx21 = true
V3.threeD = "2D"
Pgat3.set772()

fw = function (x) return max(min(x-2, 6-x), 0) end
FP = function (x,y) return min(fw(x), fw(y)) end
FC = function (x,y) return max(fw(x), fw(y)) end
sP = Surface.new(FP, 4, 4)
sC = Surface.new(FC, 4, 4)

p = Pict {}
for y=2,6 do p:add(sP:segment(v(0,y), v(7,y), nil, 7)) end
for x=2,6 do p:add(sP:segment(v(x,0), v(x,7), nil, 7)) end
p:add(sP:segment(v(2,2), v(6,6), nil, 4))
p:add(sP:segment(v(2,6), v(6,2), nil, 4))

= p:pgat3():show("", {scale=0.4})
 (etv)
= p:pgat3():show("", {ul="5pt", scale=2})
 (etv)

-- «test-cruz»  (to ".test-cruz")
p = Pict {}
for y=0,7 do p:add(sC:segment(v(0,y), v(7,y), nil, 7)) end
for x=0,7 do p:add(sC:segment(v(x,0), v(x,7), nil, 7)) end
p:add(sC:segment(v(2,2), v(6,6), nil, 4))
p:add(sC:segment(v(2,6), v(6,2), nil, 4))

= p:pgat3():show("", {scale=0.4})
 (etv)
= p:pgat3():show("", {ul="5pt", scale=2})
 (etv)

-- ^ Compare with
-- (c3m211cnp 15 "figura-piramide")
-- (c3m211cna    "figura-piramide")
-- (c3m211cnp 16 "cruz")
-- (c3m211cna    "cruz")

--]]


-- «QuadraticFunction-tests»  (to ".QuadraticFunction-tests")
-- Used by: (c3m211qp 2 "figuras-3D")
--          (c3m211qp 9 "figuras-3D")
--          (c3m211qa   "figuras-3D")
--          (c3m211qp 4 "point-of-view")
--          (c3m211qa   "point-of-view")
--[[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Surface1.lua"
usepackages.edrx21 = true
V3.threeD = "2D"
Pgat3.set433()
p = Pict {}
= p:pgat3()
= p:pgat3():show("", {scale=0.8})
 (etv)

 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
-- dofile "Surface1.lua"
dofile    "ExprDxDy1.lua"
usepackages.edrx21 = true
Pgat3.set433()
V3.threeD = "2D"
x0,y0 = 3,2
edd   = ExprDxDy.from("2+Dx^2-Dy^2")
srf   = Surface.new(edd.f, 3, 2)
srf   = Surface.new(edd.f)

p = srf:squareanddiagonals(8)
= p
= p:pgat3()
= p:pgat3():show("", {scale=0.8})
 (etv)

srf   = Surface.new(edd.f)

for y=3,0,-1 do
  for x=0,4 do
    -- printf("%03s", edd.f(x,y))
    printf("%03s", srf.f(x,y))
  end
  print()
end
= srf.f

= srf:square   (2, "p")
= srf:square   (8, "0")
= srf:square   (8, "c")
= srf:diagonals(8, "c")

p = Pict {}
= p:pgat3()
= Pict{}:pgat3()

p = Pict {
  srf:square   (2, "p"):Color("Gray"),
  srf:square   (8, "0"),
  srf:square   (8, "c"),
  srf:diagonals(8, "c")
  }
= p:pgat3()
= p:pgat3():show("", {scale=0.8})
 (etv)
= x0,y0

PPPV(Pgat3)


= v3():xygrid(4,3):Color("Gray")
= v3():axeswithticks(4,3,3)
F = function (x, y) return 10*x + y end

= srf:diagonals(8, "p")
= srf:square   (8, "c")


--]]




-- Local Variables:
-- coding:  utf-8-unix
-- End:
