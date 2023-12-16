-- This file:
--   http://anggtwu.net/LUA/StrGrid1.lua.html
--   http://anggtwu.net/LUA/StrGrid1.lua
--          (find-angg "LUA/StrGrid1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/StrGrid1.lua"))
-- Supersedes: (find-angg "LUA/Cabos2.lua")

-- «.XtoT»			(to "XtoT")
-- «.Xtot-tests»		(to "Xtot-tests")
-- «.StrGridLabels»		(to "StrGridLabels")
-- «.StrGridLabels-tests»	(to "StrGridLabels-tests")
-- «.StrGrid»			(to "StrGrid")
-- «.StrGrid-tests»		(to "StrGrid-tests")


-- __  ___      _____ 
-- \ \/ / |_ __|_   _|
--  \  /| __/ _ \| |  
--  /  \| || (_) | |  
-- /_/\_\\__\___/|_|  
--                    
-- «XtoT»  (to ".XtoT")
--
XtoT = Class {
  type  = "XtoT",
  from_ = function (x0, x1, t0, t1)
      return XtoT {x0=x0, x1=x1, t0=t0, t1=t1}
    end,
  from  = function (x0, x1, t0, t1)
      return XtoT.from_(x0, x1, t0, t1):functions()
    end,
  __tostring = mytostringp,
  __index = {
    xtot = function (xt, x)
        local x0,x1,t0,t1 = xt.x0, xt.x1, xt.t0, xt.t1
        return t0 + (x-x0)*(t1-t0)/(x1==x0 and 1 or x1-x0)
      end,
    ttox = function (xt, t)
        local x0,x1,t0,t1 = xt.x0, xt.x1, xt.t0, xt.t1
        return x0 + (t-t0)*(x1-x0)/(t1==t0 and 1 or t1-t0)
      end,
    functions = function (xt)
        local xtot = function (x) return xt:xtot(x) end
        local ttox = function (t) return xt:ttox(t) end
        return xt,xtot,ttox
      end,
  },
}

-- «Xtot-tests»  (to ".Xtot-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "StrGrid1.lua"
xt,xtot,ttox = XtoT.from(10, 20, 100, 200)
= xtot(12)
= ttox(120)

--]]



--  ____  _         ____      _     _ _          _          _     
-- / ___|| |_ _ __ / ___|_ __(_) __| | |    __ _| |__   ___| |___ 
-- \___ \| __| '__| |  _| '__| |/ _` | |   / _` | '_ \ / _ \ / __|
--  ___) | |_| |  | |_| | |  | | (_| | |__| (_| | |_) |  __/ \__ \
-- |____/ \__|_|   \____|_|  |_|\__,_|_____\__,_|_.__/ \___|_|___/
--                                                                
-- «StrGridLabels»  (to ".StrGridLabels")
StrGridLabels = Class {
  type = "StrGridLabels",
  new = function () return StrGridLabels {_=VTable{}} end,
  __tostring = function (sgl) return tostring(sgl._) end,
  __index = {
    add = function (sgl,c,x,y) sgl._[c] = {x,y}; return sgl end,
    subst = function (sgl,bigstr)
        local f = function (c)
            local xy = sgl._[c]
            local x,y = xy[1], xy[2]
            return format("(%s,%s)", x, y)
          end
        return (bigstr:gsub("[A-Z]", f))
      end,
  },
}

-- «StrGridLabels-tests»  (to ".StrGridLabels-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "StrGrid1.lua"
sgl = StrGridLabels.new()
sgl:add("A",2,3):add("B",3,4)
= sgl
= sgl:subst("fooBAr")

--]]



--  ____  _         ____      _     _ 
-- / ___|| |_ _ __ / ___|_ __(_) __| |
-- \___ \| __| '__| |  _| '__| |/ _` |
--  ___) | |_| |  | |_| | |  | | (_| |
-- |____/ \__|_|   \____|_|  |_|\__,_|
--                                    
-- «StrGrid»  (to ".StrGrid")
StrGrid = Class {
  type = "StrGrid",
  from = function (bigstr, x0, y0, shrink)
      x0 = x0 or 0
      y0 = y0 or 0
      shrink = shrink or 1
      local grid = {}
      for _,li in ipairs(splitlines(bigstr)) do
        local spl = split(li)
        if #spl > 0 then table.insert(grid, spl) end
      end
      local rows,cols = #grid, #grid[1]
      local xmin,ymin = x0, y0
      local xmax,ymax = x0+(cols-1)/shrink, y0+(rows-1)/shrink
      local _,rtoy,ytor = XtoT.from(1,rows, ymax,y0)
      local _,ctox,xtoc = XtoT.from(1,cols, x0,xmax)
      return StrGrid {grid=grid,
        x0=x0, y0=y0, shrink=shrink,
        xmin=xmin, ymin=ymin,
        xmax=xmax, ymax=ymax,
        rows=rows, cols=cols,
        rtoy=rtoy, ytor=ytor,
        ctox=ctox, xtoc=xtoc
      }
    end,
  __tostring = function (sg) return mytostringv(sg.grid) end,
  __index = {
    get = function (sg, x, y)
        local r,c = sg.ytor(y), sg.xtoc(x)
        if not sg.grid[r] then return end
        return sg.grid[r][c]
      end,
    labels = function (sg)
        local labels = StrGridLabels.new()
        for y=sg.ymax,sg.ymin,-1 do
          for x=sg.xmin,sg.xmax do
            local c = sg:get(x,y) or ""
            if c:match("[A-Z]") then labels:add(c,x,y) end
          end
        end
        return labels
      end,
    subst = function (sg, bigstr)
        return sg:labels():subst(bigstr)
      end,
    --
    xycs = function (sg)
        return cow(function ()
            for y=sg.ymax,sg.ymin,-1 do
              for x=sg.xmin,sg.xmax do
                local c = sg:get(x,y)
                if c then coy(x, y, c) end
              end
            end
          end)
      end,
    printxycs = function (sg)
        for x,y,c in sg:xycs() do print(x,y,c) end
      end,
  },
}

-- «StrGrid-tests»  (to ".StrGrid-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "StrGrid1.lua"

sg = StrGrid.from [[
  a b c d e f
  g h i j k l
  m n o p q r
]]
= sg
= sg:get(0,0)
= sg:get(1,0)
= sg:get(0,1)
= sg:get(10,0)

sg = StrGrid.from([[
  a b c d e f
  g h i j k l
  m n o p q r
]], -4, -1)
= sg

sg = StrGrid.from([[
  a - B - C
  | . | . |
  d - e - F
]], 0, 0, 2)
= sg
= sg:get(0,0)
= sg:get(1,0)
= sg:get(0,1)
= sg:get(0,0.5)
= sg:printxycs()
-- for x,y,c in sg:xycs() do print(x,y,c) end

  lbls = sg:labels()
= lbls
= sg:subst("aBaCaFa")

-- (find-angg "GNUPLOT/piramide-2.dem")
sg = StrGrid.from([[
   0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0
   | . | . | . | . | . | . | . | . |
   0 - A - 0 - 0 - 0 - 0 - 0 - B - 0
   | . | \ | . | . | . | . | / | . |
   0 - 0 - 1 - 1 - 1 - 1 - 1 - 0 - 0
   | . | . | \ | . | . | / | . | . |
   0 - 0 - 1 - 2 - 2 - 2 - 1 - 0 - 0
   | . | . | . | \ | / | . | . | . |
   0 - 0 - 1 - 2 - C - 2 - 1 - 0 - 0
   | . | . | . | / | \ | . | . | . |
   0 - 0 - D - E - 2 - 2 - 1 - 0 - 0
   | . | . | \ | . | . | \ | . | . |
   0 - 0 - F - G - 1 - 1 - 1 - 0 - 0
   | . | / | . | . | . | . | \ | . |
   0 - H - 0 - 0 - 0 - 0 - 0 - I - 0
   | . | . | . | . | . | . | . | . |
   0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0
]], 0, 0, 2)
= sg:labels()
= sg:subst("A--C--H")

--]==]



-- Local Variables:
-- coding:  utf-8-unix
-- End:
