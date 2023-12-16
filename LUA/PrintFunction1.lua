-- This file:
--   http://anggtwu.net/LUA/PrintFunction1.lua.html
--   http://anggtwu.net/LUA/PrintFunction1.lua
--          (find-angg "LUA/PrintFunction1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This file defines the class PrintFunction, that prints functions
-- and stack frames either in a very compact format that looks like
-- this (that I took from a pretraceback),
--
--   [ C ]  C function (unknown name)
--   [Lua] stdin line 1
--   (find-luatb "~/LUA/lua50init.lua 2325 2329 global run_repl3_now")
--   (find-luatb "~/LUA/Repl3.lua 146 148 method repl")
--
-- or, with the method :v(), in a low-level "vertical" format that
-- looks like this:
--
--   { "currentline"=2329,
--     "func"=<function: 0x560195e1d770>,
--     "lastlinedefined"=2330,
--     "linedefined"=2325,
--     "name"="run_repl3_now",
--     "namewhat"="global",
--     "nups"=0,
--     "short_src"="/home/edrx/LUA/lua50init.lua",
--     "source"="@/home/edrx/LUA/lua50init.lua",
--     "what"="Lua"
--   }
--
-- debug.getinfo only fills the fields "name" and "namewhat" for stack
-- frames, so
--
--   PrintFunction.from(run_repl3_now)
--
-- returns just:
--
--   (find-luatb "~/LUA/lua50init.lua 2325 2330")
--
-- instead of:
--
--   (find-luatb "~/LUA/lua50init.lua 2325 2329 global run_repl3_now")
--
-- PrintFunction was inspired by the traceback in Prosody,
--
--   http://angg.twu.net/LUA/Prosody1.lua.html
--           (find-angg "LUA/Prosody1.lua")
--
-- but I changed the output format completely.
--
-- Based on/supersedes:
--   (find-angg "LUA/DGetInfo1.lua" "DGetInfo")
-- See:
--   (find-angg "LUA/PreTraceback1.lua")
--   (find-TH "Repl3" "PrintFunction1.lua")
--   (find-lua51manual "#pdf-debug.getinfo")
--   (find-lua51manual "#pdf-debug.getlocal")
--
-- (defun e () (interactive) (find-angg "LUA/PrintFunction1.lua"))


-- «.PrintFunction»		(to "PrintFunction")
-- «.PrintFunction-tests»	(to "PrintFunction-tests")


--  ____       _       _   _____                 _   _             
-- |  _ \ _ __(_)_ __ | |_|  ___|   _ _ __   ___| |_(_) ___  _ __  
-- | |_) | '__| | '_ \| __| |_ | | | | '_ \ / __| __| |/ _ \| '_ \ 
-- |  __/| |  | | | | | |_|  _|| |_| | | | | (__| |_| | (_) | | | |
-- |_|   |_|  |_|_| |_|\__|_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|
--                                                                 
-- Also here: (find-angg "LUA/lua50init.lua" "PrintFunction")
-- «PrintFunction»  (to ".PrintFunction")

PrintFunction = Class {
  type = "PrintFunction",
  from = function (f) return PrintFunction(debug.getinfo(f, "nSluf")) end,
  tostring = function (f) return tostring(PrintFunction.from(f)) end,
  __tostring = function (pf) return pf:tostring() end,
  __index = {
    v          = function (pf) return VTable(copy(pf)) end,
    tostring   = function (pf) return pf:_any() end,
    _shortsrc0 = function (pf) return ee_shorten(pf.short_src) end,
    _shortsrc0 = function (pf) return ee_shorten(pf.source:sub(2)) end,
    _shortsrc  = function (pf) return pf.short_src and pf:_shortsrc0() end,
    _name0     = function (pf) return pf.name and format("%q", pf.name) end,
    _name      = function (pf) return pf:_name0() or "(unknown name)" end,
    _linedef   = function (pf) return pf.linedefined end,
    _linelast  = function (pf) return pf.lastlinedefined end,
    _linecurr0 = function (pf) return pf.currentline end,
    _linecurr  = function (pf) return pf:_linecurr0()~=-1 and pf:_linecurr0() end,
    _line1     = function (pf) return pf:_linedef() end,
    _line2     = function (pf) return pf:_linecurr() or pf:_linelast() end,
    _tailcall0 = function (pf) return "[Lua] tail call" end,
    _main0     = function (pf) return "[Lua] "..pf:_shortsrc()
                                   .." line "..pf:_linecurr() end,
    _C0        = function (pf) return "[ C ] "..pf.namewhat
                                   .." C function "..pf:_name() end,
    _tbbody0   = function (pf) return (pf:_shortsrc() or "")
                               .." "..(pf:_line1() or "")
                               .." "..(pf:_line2() or "")
                               .." "..(pf.namewhat or "")
                               .." "..(pf.name or "") end,
    _tbbody    = function (pf) return rtrim(pf:_tbbody0()) end,
    _findluatb = function (pf) return format('(find-luatb \"%s\")', pf:_tbbody()) end,
    _any       = function (pf)
        if pf.short_src == "[C]"         then return pf:_C0() end
        if pf.what      == "main"        then return pf:_main0() end
        if pf.short_src == "(tail call)" then return pf:_tailcall0() end
        return pf:_findluatb()
      end,
  },
}

-- «PrintFunction-tests»  (to ".PrintFunction-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "PrintFunction1.lua"
= VTable(debug.getinfo(split, "nSluf"))
= VTable(debug.getinfo(print, "nSluf"))

pf = PrintFunction.from(split)
pf = PrintFunction.from(print)
pf = PrintFunction.from(PrintFunction.__index.v)
= pf:v()

= PrintFunction.from(split)
= PrintFunction.from(print)
= PrintFunction.from(PrintFunction.__index.v)

= DGetInfo.fromfunction(split)

DGetInfo.__index.method = "printfunction"
DGetInfo.__index.printfunction = function (dgi)
    return ":: "..PrintFunction(copy(dgi)):tostring()
  end


run_repl2_now()


-- (find-angg "LUA/DGetInfo1.lua" "DGetInfos-tests")

--]]








-- (find-angg "LUA/DGetInfo1.lua" "DGetInfos")






-- Local Variables:
-- coding:  utf-8-unix
-- End:
