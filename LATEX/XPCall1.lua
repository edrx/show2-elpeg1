-- This file:
--   http://anggtwu.net/LUA/XPCall1.lua.html
--   http://anggtwu.net/LUA/XPCall1.lua
--          (find-angg "LUA/XPCall1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- Version: 2023nov12
--
-- This class implements a modular wrapper around pcall and xpcall
-- that can be used in many ways. For example:
--
--   1) as an unwind/protect that sets global variables temporarily
--   2) as an xpcall that displays the error and a pretraceback
--   3) as an xpcall that returns the error and a pretraceback
--
-- The methods ":stb0()" and ":stb()" save a pretraceback in the
-- global variable ptb, but they only do that if the current value of
-- ptb is nil. (Explain clobbering)

-- ... as an unwind/protect. The xpcall methods save a
-- pretraceback that can be used for post-mortem debugging.
--
-- (defun xp () (interactive) (find-angg "LUA/XPCall1.lua"))
-- (defun pc () (interactive) (find-angg "LUA/PCall1.lua"))

-- This is more powerful than:
--   (find-angg "LUA/PCall1.lua")
-- but the classes here and there are disjoint and the
-- two files can be loaded at the same time.
-- Some of the methods in the XPCall class use pretracebacks:
--   (find-angg "LUA/PrintFunction1.lua" "PreTraceback")
--
-- See:
--   (find-angg "LUA/lua50init.lua" "pack-and-unpack")
--   (find-emlua "Repl1.lua" "WithFakePrint")
-- Used by:
--   (find-angg "LUA/Repl3.lua")

-- «.XPCall»		(to "XPCall")
-- «.XPCall-tests»	(to "XPCall-tests")
-- «.XPCall-tests-x»	(to "XPCall-tests-x")

require "PreTraceback1"    -- (find-angg "LUA/PreTraceback1.lua")




-- __  ______   ____      _ _ 
-- \ \/ /  _ \ / ___|__ _| | |
--  \  /| |_) | |   / _` | | |
--  /  \|  __/| |__| (_| | | |
-- /_/\_\_|    \____\__,_|_|_|
--                            
-- «XPCall»  (to ".XPCall")

XPCall = Class {
  type    = "XPCall",
  __tostring = function (pc) return mytostringv(pc) end,
  __index = {
    m = function (pc,f,...)
        if type(f) == "string" then f = pc[f] end
        if f then f(pc,...) end
        return pc
      end,
    --
    a = function (pc) return pc:m("before") end,
    b = function (pc,...)
        local fargs = pack(...)
        local g     = function () return pc.f(unpack(fargs)) end
        pc.presults = pack(pcall(g))
        return pc
      end,
    c = function (pc) return pc:m("after") end,
    --
    ok   = function (pc) return pc.presults[1] end,
    e    = function (pc) return pc.presults[2] end,
    r    = function (pc) return unpack(pc.presults, 2, pc.presults.n) end,
    re   = function (pc) return false,pc:e() end,
    rr   = function (pc) return true,pc:r() end,
    rre  = function (pc) if pc:ok() then return pc:rr() else return pc:re() end end,
    okr  = function (pc) if pc:ok() then return pc:r() end end,
    --
    pcall  = function (pc,...) return pc:a():b(...):c():rre() end,
    pcall0 = function (pc,...) return pc:a():b(...):c():okr() end,
    --
    eh = function (...) return false end,
    xb = function (pc, ...)
        local fargs = pack(...)
        local g   = function () return pc.f(unpack(fargs)) end
        local geh = function (...)
            pc.gehargs = pack(...)
            pc.errmsg = ...
            pc.traceback = debug.traceback()
            pc.pretraceback = PreTraceback.new(true,true)
            return pc:eh()
          end
        pc.presults = pack(xpcall(g, geh))
        return pc
      end,
    ptb00 = function (pc,a,b) return pc.pretraceback:tostring(a, b) end,
    ptb0  = function (pc,a,b) return pc:ptb00(a or #pc.pretraceback, b or 5) end,
    ptb   = function (pc,a,b) return pc:ptb0(a,b).."\n"..pc.errmsg end,
    stb0  = function (pc) ptb = ptb or pc.pretraceback; return pc end,
    stb   = function (pc) if not pc:ok() then pc:stb0() end; return pc end,
    xpe   = function (pc) if not pc:ok() then print(pc:ptb()) end; return pc end,
    --
    xpcall3 = function (pc,...) return pc:a():xb(...):c() end,
    xpcall5 = function (pc,...) return pc:a():xb(...):c():xpe():okr() end,
    xpcall6 = function (pc,...) return pc:a():xb(...):c():stb():xpe():okr() end,
    --
    clr = function (pc)
        pc = copy(pc)
        pc.traceback,pc.pretraceback = nil,nil
        return pc
      end,
  },
}

-- «XPCall-tests-x»  (to ".XPCall-tests-x")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "XPCall1.lua"
p = XPCall {
  f = function (a,b) print(a,b); return a+b,a*b end,
}
  p:xpcall3(2,3)
  p:xpcall5(2,3)
= p:xpcall5(2,3)
= p:clr()
= ptb
  p:xpcall3(2,false)
  p:xpcall5(2,false)
  p:xpcall6(2,false)
= ptb
= ptb[2]
= ptb[2].locals
= ptb[2].locals:inames()


= p.pretraceback
= p:ptb()
= p:ptb(nil, 0)
= p
= p:clr()


= p:xpcall3(2,false)
= p:xpcall4(2,false)

--]]



-- «XPCall-tests»  (to ".XPCall-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "XPCall1.lua"
p = XPCall {
  before = function ()    print "(before)" end,
  f      = function (a,b) print(a,b); return a+b,a*b end,
  after  = function ()    print "(after)" end,
}

= p:pcall (2,3)
= p:pcall0(2,3)
= p
= p:ok()
= p:r()
= p:rr()
= p:rre()
= p:okr()

= p:pcall(2,false)
= p
= p:e()
= p:re()
= p:rre()
= p:okr()

--]]


-- Local Variables:
-- coding:  utf-8-unix
-- End:
