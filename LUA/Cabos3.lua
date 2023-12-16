-- This file:
--   http://anggtwu.net/LUA/Cabos3.lua.html
--   http://anggtwu.net/LUA/Cabos3.lua
--          (find-angg "LUA/Cabos3.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e  () (interactive) (find-angg "LUA/Cabos3.lua"))
-- (defun c1 () (interactive) (find-angg "LUA/Cabos1.lua"))
-- (defun c2 () (interactive) (find-angg "LUA/Cabos2.lua"))
-- (defun p1 () (interactive) (find-angg "GNUPLOT/2022-2-C3-P1.dem"))
-- (defun sg () (interactive) (find-angg "LUA/StrGrid1.lua"))
-- See: (find-angg "LUA/Cabos1.lua" "CabosNaDiagonal")
--      (find-angg "LUA/Cabos1.lua" "XyGrid" "expandg =")
--      (find-angg "LUA/Cabos1.lua" "XyGrid" "altget =")
--      (find-angg "GNUPLOT/2023-2-C3-P1.dem")

-- «.Expand»			(to "Expand")
-- «.Expand-tests»		(to "Expand-tests")
-- «.CabosNaDiagonal»		(to "CabosNaDiagonal")
-- «.CabosNaDiagonal-tests»	(to "CabosNaDiagonal-tests")

require "StrGrid1"   -- (find-angg "LUA/StrGrid1.lua")

isint  = function (x) return math.floor(x) == x end
ishalf = function (x) return isint(x + 0.5) end



--  _____                            _ 
-- | ____|_  ___ __   __ _ _ __   __| |
-- |  _| \ \/ / '_ \ / _` | '_ \ / _` |
-- | |___ >  <| |_) | (_| | | | | (_| |
-- |_____/_/\_\ .__/ \__,_|_| |_|\__,_|
--            |_|                      
--
-- «Expand»  (to ".Expand")

Expand = Class {
  type = "Expand",
  from = function (bigstr)
      local strgrid = StrGrid.from(bigstr, 0, 0, 1)
      return Expand { bigstr=bigstr, strgrid=strgrid }
    end,
  __index = {
    get = function (ex, x, y) return ex.strgrid:get(x,y) end,
    z   = function (ex, x, y) return tonumber(ex:get(x,y)) end,
    xs  = function (ex, step) return HTable(seq(0, ex.strgrid.xmax, step)) end,
    ys  = function (ex, step) return VTable(seq(ex.strgrid.ymax, 0, -step)) end,
    zs  = function (ex) 
        local ytozs = function (y)
            return HTable(map(function (x) return ex:z(x,y) end, ex:xs(1)))
          end
        return VTable(map(ytozs, ex:ys(1)))
      end,
    --
    -- Based on: (find-angg "LUA/Cabos1.lua" "XyGrid" "altget =")
    altget = function (ex, x, y)
        if isint(x)  and isint (y) then return ex:get(x,y) end
        if isint(x)  and ishalf(y) then return "|" end
        if ishalf(x) and isint(y)  then return "-" end
        local nw,ne = ex:z(x-0.5, y+0.5), ex:z(x+0.5, y+0.5)
        local sw,se = ex:z(x-0.5, y-0.5), ex:z(x+0.5, y-0.5)
        if ne-nw == se-sw then return "." else return "?" end
      end,
    alttostring = function (ex, prefix)
        local xs,ys = ex:xs(0.5), ex:ys(0.5)
        local altytostring = function (y)
            return (prefix or "")
                .. mapconcat(function (x) return ex:altget(x, y) end, xs, " ")
          end
        return mapconcat(altytostring, ys, "\n")
      end,
    --
    -- Based on: (find-angg "LUA/Cabos1.lua" "XyGrid" "expandg =")
    expand0 = function (ex, prefix)
        return ex:alttostring((prefix or "").."  ")
      end,
    expand = function (ex, prefix)
        prefix = prefix or ""
        local body = ex:expand0(prefix)
        return prefix.."= CabosNaDiagonal.from [[\n"..body.."\n"..prefix.."]]"
      end,
    expandg = function (ex, prefix)
        return ex:expand(prefix or "#: ")
      end,
  },
}

-- «Expand-tests»  (to ".Expand-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Cabos3.lua"
bigstr = [[
  6 6 6 6 4 2 0 0 0 0
  6 6 6 6 4 2 0 0 0 0
  6 6 6 6 4 2 0 0 0 0
  5 5 5 5 4 2 0 0 0 0
  4 4 4 4 3 2 0 0 0 0
  3 3 3 3 2 1 0 0 0 0
  2 2 2 2 1 0 0 0 0 0
  1 1 1 1 0 0 0 0 0 0
  0 0 0 0 0 0 0 0 0 0
  0 0 0 0 0 0 0 0 0 0
  0 0 0 0 0 0 0 0 0 0
]]
ex = Expand.from(bigstr)
= ex
= ex:zs()
= ex:expand0()
= ex:expandg()
= ex:expandg("")

--]==]







--   ____      _                           
--  / ___|__ _| |__   ___  ___             
-- | |   / _` | '_ \ / _ \/ __|            
-- | |__| (_| | |_) | (_) \__ \  _   _   _ 
--  \____\__,_|_.__/ \___/|___/ (_) (_) (_)
--                                         
-- Based on: (find-angg "LUA/Cabos1.lua" "CabosNaDiagonal")
-- «CabosNaDiagonal»  (to ".CabosNaDiagonal")
--
CabosNaDiagonal = Class {
  type = "CabosNaDiagonal",
  from = function (bigstr)
      -- local xygrid = XyGrid.from(bigstr, 0.5)
      local strgrid = StrGrid.from(bigstr, 0, 0, 2)
      return CabosNaDiagonal { bigstr=bigstr, strgrid=strgrid }
    end,
  __tostring = function (c) return c:gnuplotbody() end,
  __index = {
    xmin = function (c) return c.strgrid.xmin end,
    ymin = function (c) return c.strgrid.ymin end,
    xmax = function (c) return c.strgrid.xmax end,
    ymax = function (c) return c.strgrid.ymax end,
    get  = function (c, x, y) return c.strgrid:get(x, y) end,
    z    = function (c, x, y) return tonumber(c:get(x,y)) end,
    --
    -- Generate gnuplot code
    zmax = function (c, x, y)
        local mz = 0
        for y=c:ymax(),c:ymin(),-1 do
          for x=c:xmin(),c:xmax() do
            mz = max(mz, c:z(x,y))
          end
        end
        return mz
      end,
    xyz = function (c, x, y)
        return format("%s,%s,%s", x, y, c:z(x, y))
      end,
    vertices = function (c, x, y)
        local nw, ne = c:xyz(x, y+1), c:xyz(x+1, y+1)
        local sw, se = c:xyz(x, y),   c:xyz(x+1, y) 
        middle = c:get(x+0.5, y+0.5)
        return nw, ne, sw, se, middle
      end,
    --
    square = function (c, nw, ne, sw, se)
        return format("%s to %s to %s to %s to %s", sw, se, ne, nw, sw)
      end,
    triangles = function (c, nw, ne, sw, se, middle)
        if middle == "/" then
          return format("%s to %s to %s to %s", sw, ne, nw, sw),
                 format("%s to %s to %s to %s", sw, se, ne, sw)
        elseif middle == "\\" then
          return format("%s to %s to %s to %s", sw, se, nw, sw),
                 format("%s to %s to %s to %s", se, ne, nw, se)
        else PP("bad middle", middle); error()
        end
      end,
    --
    sots0 = function (c, x, y)
        local nw, ne, sw, se, middle = c:vertices(x, y)
        if middle == "."
        then return c:square(nw, ne, sw, se)
        else return c:triangles(nw, ne, sw, se, middle)
        end
      end, 
    sots1 = function (c)
        local sots = VTable {}
        for y=c:ymax()-1,0,-1 do
          for x=0,c:xmax()-1 do
	    local o1,o2 = c:sots0(x, y)
            table.insert(sots, o1)
            table.insert(sots, o2)
          end
        end
        return sots
      end,
    sots2 = function (c)
        local sots = c:sots1()
        local f = function (n)
            return format("set obj %d polygon from %s", n, sots[n])
          end
        local bigstr = mapconcat(f, seq(1, #sots), "\n")
        return bigstr..format("\n\nn = %d", #sots)
      end,
    sots3 = function (c)
        local xmax,ymax,zmax = c:xmax(),c:ymax(),c:zmax()
        local fmt = "set xrange [0:%d]; set yrange [0:%d]; set zrange [0:%d]"
        return c:sots2().."\n"..format(fmt, xmax, ymax, zmax)
      end,
    gnuplotbody = function (c)
        return c:sots3()
      end,
  },
}


-- «CabosNaDiagonal-tests»  (to ".CabosNaDiagonal-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Cabos3.lua"
  run_repl3_now()
  ptb = nil

bigstr2 = [[
  10 - 11 - 12
  |  . |  \  |
  13 - 14 - 15
]]
c = CabosNaDiagonal.from(bigstr2)
= c.strgrid:get(0,0)
= c.strgrid:get(0,1)
= c:get(0,0)
= c:ymin()
= c:zmax()
=             c:vertices(0,0)
= c:square   (c:vertices(0,0))
=             c:vertices(1,0)
= c:triangles(c:vertices(1,0))
= c:sots0(0,0)
= c:sots0(1,0)
= c:sots1()
= c:sots2()
= c:sots3()
= c:gnuplotbody()

c = CabosNaDiagonal.from [[
  6 - 6 - 6 - 6 - 4 - 2 - 0 - 0 - 0 - 0
  | . | . | . | . | . | . | . | . | . |
  6 - 6 - 6 - 6 - 4 - 2 - 0 - 0 - 0 - 0
  | . | . | . | . | . | . | . | . | . |
  6 - 6 - 6 - 6 - 4 - 2 - 0 - 0 - 0 - 0
  | . | . | . | \ | . | . | . | . | . |
  5 - 5 - 5 - 5 - 4 - 2 - 0 - 0 - 0 - 0
  | . | . | . | . | \ | . | . | . | . |
  4 - 4 - 4 - 4 - 3 - 2 - 0 - 0 - 0 - 0
  | . | . | . | . | . | \ | . | . | . |
  3 - 3 - 3 - 3 - 2 - 1 - 0 - 0 - 0 - 0
  | . | . | . | . | . | / | . | . | . |
  2 - 2 - 2 - 2 - 1 - 0 - 0 - 0 - 0 - 0
  | . | . | . | . | / | . | . | . | . |
  1 - 1 - 1 - 1 - 0 - 0 - 0 - 0 - 0 - 0
  | . | . | . | / | . | . | . | . | . |
  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0
  | . | . | . | . | . | . | . | . | . |
  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0
  | . | . | . | . | . | . | . | . | . |
  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0
]]
= c

clabels = CabosNaDiagonal.from [[
  6 - 6 - 6 - A - 4 - 2 - B - 0 - 0 - 0
  | . | . | . | . | . | . | . | . | . |
  6 - 6 - 6 - 6 - 4 - 2 - 0 - 0 - 0 - 0
  | . | . | . | . | . | . | . | . | . |
  C - 6 - 6 - D - 4 - 2 - 0 - 0 - 0 - 0
  | . | . | . | \ | . | . | . | . | . |
  5 - 5 - 5 - 5 - 4 - 2 - 0 - 0 - 0 - 0
  | . | . | . | . | \ | . | . | . | . |
  4 - 4 - 4 - 4 - 3 - 2 - 0 - 0 - 0 - 0
  | . | . | . | . | . | \ | . | . | . |
  3 - 3 - 3 - 3 - 2 - 1 - E - 0 - 0 - 0
  | . | . | . | . | . | / | . | . | . |
  2 - 2 - 2 - 2 - 1 - 0 - 0 - 0 - 0 - 0
  | . | . | . | . | / | . | . | . | . |
  1 - 1 - 1 - 1 - 0 - 0 - 0 - 0 - 0 - 0
  | . | . | . | / | . | . | . | . | . |
  F - 0 - 0 - G - 0 - 0 - 0 - 0 - 0 - 0
  | . | . | . | . | . | . | . | . | . |
  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0
  | . | . | . | . | . | . | . | . | . |
  0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0 - 0
]]
  lbls = clabels.strgrid:labels()
= lbls
= lbls:subst("A--B--C B--E--G--F D--E")

--]==]







-- Local Variables:
-- coding:  utf-8-unix
-- End:
