-- This file:
--   http://anggtwu.net/LUA/PreTraceback1.lua.html
--   http://anggtwu.net/LUA/PreTraceback1.lua
--          (find-angg "LUA/PreTraceback1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- Version: 2023nov12
--
-- This file defines three classes: PreTraceback, DGetFrame and
-- DGetPairs. A pretraceback object is:
--
--   a) like the result of debug.traceback(), but before the
--      conversion to a string,
--   b) a table of stack frames, indexed by "levels",
--   c) shown as a series of lines like "lvl -> <f>", where the
--      "<f>" is produced by the class PrintFunction.
--
-- Each of these stack frames is a dgetframe object. Each dgetframe is
-- built by running debug.getinfo(lvl,"nSluf"), adding information
-- about the local variables and upvalues at that level, and
-- converting the result to the DGetFrame class.
--
-- The information about local variables in a dgetframe object is
-- stored in a dgetpairs object and the information about its upvalues
-- is stored in another dgetpairs object. Each "pair" in a dgetpairs
-- object is actually a triple made of an index (an "i"), a name, and
-- a value. The two main ways of printing these triples are:
--
--   1) dpg:ins(), that prints the "i"s and the names,
--   2) dpg:invs(), that prints the "i"s, the names, and the values.
--
-- The class DGetFrame can also be used to inspect the upvalues of
-- functions that are not in a stack frame. A dgetframe object created
-- with
--
--   dg = DGetFrame.fromfunction(f, true, true)
--
-- will have a field .upvalues but its field .locals will be dummy.
--
-- Uses:
--   (find-angg "LUA/PrintFunction1.lua")
-- Supersedes:
--   (find-angg "LUA/DGetInfo1.lua")
--
-- (defun e () (interactive) (find-angg "LUA/PreTraceback1.lua"))

-- «.DGetPairs»			(to "DGetPairs")
-- «.DGetPairs-tests»		(to "DGetPairs-tests")
-- «.DGetFrame»			(to "DGetFrame")
-- «.DGetFrame-tests»		(to "DGetFrame-tests")
-- «.PreTraceback»		(to "PreTraceback")
-- «.PreTraceback-tests»	(to "PreTraceback-tests")

require "PrintFunction1"     -- (find-angg "LUA/PrintFunction1.lua")



--  ____   ____      _   ____       _          
-- |  _ \ / ___| ___| |_|  _ \ __ _(_)_ __ ___ 
-- | | | | |  _ / _ \ __| |_) / _` | | '__/ __|
-- | |_| | |_| |  __/ |_|  __/ (_| | | |  \__ \
-- |____/ \____|\___|\__|_|   \__,_|_|_|  |___/
--                                             
-- «DGetPairs»  (to ".DGetPairs")

DGetPairs = Class {
  type = "DGetPairs",
  new = function (storevalues)
      return DGetPairs {names={}, values=(storevalues and {})}
    end,
  __tostring = function (dg) return dg:tostring() end,
  __index = {
    n   = function (dgp) return #dgp.names end,
    seq = function (dgp) return HTable(seq(1,dgp:n())) end,
    set = function (dgp,i,name,value)
        if not name then return end
        dgp.names[i] = name
        if dgp.values then dgp.values[i] = value end
        return dgp
      end,
    iname = function (dgp,i)
        return pformat("%d:%s", i, dgp.names[i])
      end,
    inamevalue = function (dgp,i)
        return pformat("%d:%s:%s", i, dgp.names[i], dgp.values[i])
      end,
    inames = function (dgp, sep)
        local f = function (i) return dgp:iname(i) end
        return mapconcat(f, dgp:seq(), sep or " ")
      end,
    inamesvalues = function (dgp, sep)
        if not dgp.values then return dgp:inames(sep) end
        local f = function (i) return dgp:inamevalue(i) end
        return mapconcat(f, dgp:seq(), sep or "\n")
      end,
    ins      = function (dgp, sep) return dgp:inames(sep) end,
    invs     = function (dgp, sep) return dgp:inamesvalues(sep) end,
    tostring = function (dgp, sep) return dgp:ins(sep) end,
  },
}

-- «DGetPairs-tests»  (to ".DGetPairs-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "PreTraceback1.lua"
dgp = DGetPairs.new()
dgp = DGetPairs.new("storevalues")
PPV(dgp)
= dgp:set(1,"a",10)
= dgp:set(2,"b",20)
= dgp:set(3)
= dgp:n()
= dgp:tostring()
= dgp:tostring("\n")
= dgp
= dgp:seq()

--]]


--  ____   ____      _   _____                         
-- |  _ \ / ___| ___| |_|  ___| __ __ _ _ __ ___   ___ 
-- | | | | |  _ / _ \ __| |_ | '__/ _` | '_ ` _ \ / _ \
-- | |_| | |_| |  __/ |_|  _|| | | (_| | | | | | |  __/
-- |____/ \____|\___|\__|_|  |_|  \__,_|_| |_| |_|\___|
--                                                     
-- «DGetFrame»  (to ".DGetFrame")

DGetFrame = Class {
  type    = "DGetFrame",
  atlevel = function (lvl, storevalues, storeupvalues)
      local  dg = debug.getinfo(lvl, "nSluf")
      if not dg then return end
      dg.locals   = DGetPairs.new(storevalues)
      dg.upvalues = DGetPairs.new(storeupvalues)
      for i=1,1000 do
	local name,value = debug.getlocal(lvl, i)
        if not dg.locals:set(i,name,value) then break end
      end
      return DGetFrame(dg):getupvalues()
    end,
  fromfunction = function (f, storevalues, storeupvalues)
      local dg    = debug.getinfo(f, "nSluf")
      dg.locals   = DGetPairs.new(storevalues)   -- dummy
      dg.upvalues = DGetPairs.new(storeupvalues)
      return DGetFrame(dg):getupvalues()
    end,
  getframes = function (storevalues, storeupvalues)
      local A = {}
      for i=0,1000 do
        A[i] = DGetFrame.atlevel(i, storevalues, storeupvalues)
        if not A[i] then return A end
        end
      end,
  __tostring = function (dgf) return dgf:tostring() end,
  __index = {
    getupvalues = function (dgf,n)
        for i=1,(n or dgf.nups) do
           local name,value = debug.getupvalue(dgf.func, i)
           if not dgf.upvalues:set(i,name,value) then break end
         end
         return dgf
      end,
    delpairs = function (dgf)
        dgf = copy(dgf)
        dgf.locals   = nil
        dgf.upvalues = nil
        return dgf
      end,
    toprintfunction = function (dgf) return PrintFunction(dgf:delpairs()) end,
    tostring = function (dgf) return tostring(dgf:toprintfunction()) end,
    pf = function (dgf) return dgf:toprintfunction() end,
    v  = function (dgf) return dgf:toprintfunction():v() end,
  },
}

-- «DGetFrame-tests»  (to ".DGetFrame-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "PreTraceback1.lua"
dg = DGetFrame.atlevel(2)
= dg
= dg:toprintfunction()      -- compact
= dg:toprintfunction():v()  -- vertical

-- Inspect upvalues:
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "PreTraceback1.lua"

mksetget = function ()
    local u,v -- new upvalues
    local set = function (a,b) u,v=a,b end
    local get = function () return u,v end
    return set,get
  end

set1,get1 = mksetget()
set2,get2 = mksetget()
set1(20,42); set2(99,200)
= get1()
= get2()

dgf = DGetFrame.fromfunction(set1, true, true)
= dgf
= dgf.locals
= dgf.upvalues
= dgf.upvalues:invs()

--]]


--  ____          _____                   _                _    
-- |  _ \ _ __ __|_   _| __ __ _  ___ ___| |__   __ _  ___| | __
-- | |_) | '__/ _ \| || '__/ _` |/ __/ _ \ '_ \ / _` |/ __| |/ /
-- |  __/| | |  __/| || | | (_| | (_|  __/ |_) | (_| | (__|   < 
-- |_|   |_|  \___||_||_|  \__,_|\___\___|_.__/ \__,_|\___|_|\_\
--                                                              
-- «PreTraceback»  (to ".PreTraceback")

PreTraceback = Class {
  type = "PreTraceback",
  new  = function (getvalues, getupvalues)
      local frames = DGetFrame.getframes(getvalues, getupvalues)
      return PreTraceback(frames)
    end,
  __tostring = function (pt) return pt:tostring() end,
  __index = {
    seq = function (pt, a, b, dir)
        a,b = (a or #pt),(b or 0)
        dir = dir or (a <= b and 1 or -1)
        return seq(a, b, dir)
      end,
    tostring = function (pt, a, b, dir)
        local f = function (i) return pformat("%s -> %s", i, pt[i]) end
        return mapconcat(f, pt:seq(a, b, dir), "\n")
      end,
  },
}

-- «PreTraceback-tests»  (to ".PreTraceback-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "PreTraceback1.lua"
  pt = PreTraceback.new()
= pt
= pt[5]:toprintfunction():v()
= pt[4]:toprintfunction():v()

--]]





-- Local Variables:
-- coding:  utf-8-unix
-- End:
