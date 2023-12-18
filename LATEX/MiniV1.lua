-- This file:
--   http://anggtwu.net/LUA/MiniV1.lua.html
--   http://anggtwu.net/LUA/MiniV1.lua
--          (find-angg "LUA/MiniV1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/MiniV1.lua"))
--
-- (find-angggrep "grep --color=auto -nH --null -e MiniV LUA/*.lua")
-- Based on: (find-angg "LUA/Pict2e1.lua"     "MiniV")
--           (find-angg "LUA/PradPict2e1.lua" "MiniV")

-- «.MiniV»			(to "MiniV")
-- «.MiniV-tests»		(to "MiniV-tests")


--  __  __ _       ___     __
-- |  \/  (_)_ __ (_) \   / /
-- | |\/| | | '_ \| |\ \ / / 
-- | |  | | | | | | | \ V /  
-- |_|  |_|_|_| |_|_|  \_/   
--                           
-- «MiniV»  (to ".MiniV")
-- Based on: (find-dn6 "picture.lua" "V")
-- but with the code for ZHAs deleted.
--
MiniV = Class {
  type    = "MiniV",
  __tostring = function (v) return pformat("(%s,%s)", v[1], v[2]) end,
  __add      = function (v, w) return V{v[1]+w[1], v[2]+w[2]} end,
  __sub      = function (v, w) return V{v[1]-w[1], v[2]-w[2]} end,
  __unm      = function (v)    return v*-1 end,
  __div      = function (v, k) return v*(1/k) end,
  __mul      = function (v, w)
      local ktimesv   = function (k, v) return V{k*v[1], k*v[2]} end
      local innerprod = function (v, w) return v[1]*w[1] + v[2]*w[2] end
      if     type(v) == "number" and type(w) == "table" then return ktimesv(v, w)
      elseif type(v) == "table" and type(w) == "number" then return ktimesv(w, v)
      elseif type(v) == "table" and type(w) == "table"  then return innerprod(v, w)
      else error("Can't multiply "..tostring(v).."*"..tostring(w))
      end
    end,
  --
  fromab = function (a, b)
      if     type(a) == "table"  then return a
      elseif type(a) == "number" then return V{a,b}
      elseif type(a) == "string" then
        local x, y = a:match("^%((.-),(.-)%)$")
        if x then return V{x+0, y+0} end
	-- support for lr coordinates deleted
        error("V() got bad string: "..a)
      end
    end,
  __index = {
    todd = function (v) return v[1]..v[2] end,
    to12 = function (v) return v[1], v[2] end,
    to_x_y = function (v) return v:to12() end,
    xy = function (v) return "("..v[1]..","..v[2]..")" end,
    --
    norm = function (v) return (v[1]^2 + v[2]^2)^0.5 end,
    --
    -- From: (find-LATEXfile "edrxtikz.lua" "V.__index.tow")
    new  = function (v,...) return MiniV {...}     end,
    proj = function (u,v)   return ((u*v)/(u*u))*u end,
    tow  = function (A,B,t) return A+(B-A)*t       end,  -- towards
    mid  = function (A,B)   return A+(B-A)*0.5     end,  -- midpoint
    rotleft  = function (vv) return vv:new(-vv[2], vv[1]) end, -- 90 degrees
    rotright = function (vv) return vv:new(vv[2], -vv[1]) end, -- 90 degrees
    --
    unit = function (v, len)      -- unitarize (and multiply by len)
        return v*((len or 1)/v:norm())
      end,
    rot  = function (v, angle)    -- rotate left angle degrees
        local c, s = math.cos(math.rad(angle)), math.sin(math.rad(angle))
        return v*c + v:rotleft()*s
      end,
  },
}

-- V = V or MiniV
-- v = V.fromab



-- «MiniV-tests»  (to ".MiniV-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "MiniV1.lua"
V = MiniV
v = V.fromab
= v(1,2) + 0.1*v(3,4)

vv = v(3,4)
ww = vv + v(100,200)
= vv:tow(ww, 0.1)
= vv:mid(ww)
= vv:rotleft()
= vv:rotright()
= vv:unit()
= vv:unit(2)
= vv:rot(45)
= vv*10
= vv/10

--]]



-- Local Variables:
-- coding:  utf-8-unix
-- End:
