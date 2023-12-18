-- This file:
--   http://anggtwu.net/LUA/Repl3.lua.html
--   http://anggtwu.net/LUA/Repl3.lua
--          (find-angg "LUA/Repl3.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/Repl3.lua"))
-- Based on: (find-angg "LUA/Repl2.lua")
--           (find-angg "LUA/lua50init.lua" "Repl2.lua")
-- See:      (find-angg "LUA/lua50init.lua" "Repl3.lua")
--           (find-angg "LUA/Repl1.lua" "EdrxEmacsRepl")
--           (find-luarepl-links)

-- «.MultiLineCmd»		(to "MultiLineCmd")
-- «.MultiLineCmd-tests»	(to "MultiLineCmd-tests")
-- «.Repl»			(to "Repl")
-- «.Repl-tests»		(to "Repl-tests")
--
-- «.getmeaning»		(to "getmeaning")
--   «.printmeaning»		(to "printmeaning")
--   «.printpgfkey»		(to "printpgfkey")
--   «.printtikzkey»		(to "printtikzkey")
-- «.getmeaning-tests»		(to "getmeaning-tests")
-- «.texrun»			(to "texrun")
-- «.texrun-tests»		(to "texrun-tests")

require "PreTraceback1"      -- (find-angg "LUA/PreTraceback1.lua")
require "XPCall1"            -- (find-angg "LUA/XPCall1.lua")



--  __  __       _ _   _ _     _             ____               _ 
-- |  \/  |_   _| | |_(_) |   (_)_ __   ___ / ___|_ __ ___   __| |
-- | |\/| | | | | | __| | |   | | '_ \ / _ \ |   | '_ ` _ \ / _` |
-- | |  | | |_| | | |_| | |___| | | | |  __/ |___| | | | | | (_| |
-- |_|  |_|\__,_|_|\__|_|_____|_|_| |_|\___|\____|_| |_| |_|\__,_|
--                                                                
-- «MultiLineCmd»  (to ".MultiLineCmd")

MultiLineCmd = Class {
  type = "MultiLineCmd",
  from = function (line) return MultiLineCmd({line}) end,
  test = function (line1, ...)
      return PPV(MultiLineCmd({line1, morelines={...}}):addmorelines())
    end,
  __tostring = function (mlc) return mlc:concat() end,
  __index = {
    add = function (mlc, line) table.insert(mlc, line) end,
    prefix = function (mlc) return mlc[1]:match("^=?") end,
    concat = function (mlc) return table.concat(mlc, "\n") end,
    --
    luacode = function (mlc)
        return (mlc:concat():gsub("^=", "return "))
      end,
    luacodepr = function (mlc)
        return (mlc:concat():gsub("^=(.*)$", "print(%1\n  )"))
      end,
    --
    incomplete0 = function (mlc, f, err)
        return err and err:find(" near '?<eof>'?$")
      end,
    status0 = function (mlc)
        local f0,err0 = loadstring(mlc:luacode())
        local f1,err1 = loadstring(mlc:luacodepr())
        if mlc:incomplete0(f0, err0) then return "incomplete" end
        if not f0 then return "comp error",nil,err0 end
        return "complete",f1,err1
      end,
    compile = function (mlc)
        mlc.status, mlc.f, mlc.err = mlc:status0()
        return mlc
      end,
    incomplete = function (mlc)
        mlc:compile()
        return mlc.status == "incomplete"
      end,
    --
    -- For MultiLineCmd.test
    addmorelines = function (mlc)
        while mlc:incomplete() and #mlc.morelines>0 do
          mlc:add(mlc.morelines[1]); table.remove(mlc.morelines, 1)
        end
        return mlc
      end,
  },
}

-- «MultiLineCmd-tests»  (to ".MultiLineCmd-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Repl3.lua"
mlc = MultiLineCmd.from("print('foo')")
PPV(mlc)
mlc:compile()
PPV(mlc)
mlc.f()

test = MultiLineCmd.test
mlc = test("print(2+3)", "foo")
mlc = test("print(2+", "3)", "foo")
mlc = test("print(2+", "3!", "foo")
mlc = test("= 2", "+3", "foo")
mlc = test("= 2+", "3", "foo")
mlc = test("= 2+", "3+", "4", "foo")
PPV(mlc)
= mlc.f()

--]]


--  ____            _ 
-- |  _ \ ___ _ __ | |
-- | |_) / _ \ '_ \| |
-- |  _ <  __/ |_) | |
-- |_| \_\___| .__/|_|
--           |_|      
--
-- «Repl»  (to ".Repl")
-- A simple REPL. No redirection, default errorhandler, no coroutines.
--
Repl = Class {
  type    = "Repl",
  new     = function () return Repl({}) end,
  __index = {
    read00 = function (r, prompt) write(prompt); return io.read() end,
    read0 = function (r, prompt) return r:read00(prompt) end,
    read1 = function (r) return r:read0 ">>> " end,
    read2 = function (r) return r:read0 "... " end,
    read = function (r)
        r.mlc = MultiLineCmd.from(r:read1())
        while r.mlc:incomplete() do r.mlc:add(r:read2()) end
        return r
      end,
    --
    -- (find-es "lua5" "xpcall")
    comperror = function (r) return r.mlc.status == "comp error" end,
    printcomperror = function (r) print(r.mlc.err) end,
    evalprint = function (r)
        -- local errhandler = function(err)
        --     print(tostring(err) .. debug.traceback())
        --   end
        -- xpcall(r.mlc.f, errhandler)
        XPCall({f=r.mlc.f}):xpcall6()
      end,
    readevalprint = function (r)
        r:read()
        if r:comperror()
        then r:printcomperror()
	else r:evalprint()
        end
      end,
    repl = function (r)
        while not r.STOP do
          r:readevalprint()
        end
      end,
  },
}

-- «Repl-tests»  (to ".Repl-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Repl3.lua"
run_repl  = function () r = Repl.new(); r:repl() end
stop_repl = function () r.STOP = "please" end
run_repl()
print(2+
 3+
 4)
print(2+
 3!
print(2+
 nil)
stop_repl()

--]]



--             _                              _             
--   __ _  ___| |_ _ __ ___   ___  __ _ _ __ (_)_ __   __ _ 
--  / _` |/ _ \ __| '_ ` _ \ / _ \/ _` | '_ \| | '_ \ / _` |
-- | (_| |  __/ |_| | | | | |  __/ (_| | | | | | | | | (_| |
--  \__, |\___|\__|_| |_| |_|\___|\__,_|_| |_|_|_| |_|\__, |
--  |___/                                             |___/ 
--
-- Used by:  (find-angg "LUA/Show2.lua" "defs_repl")
-- Based on: (find-angg "LUA/Repl2.lua" "getmeaning")
--           (find-angg "LUA/tikz1.lua" "repl")
--
-- «getmeaning»      (to ".getmeaning")
--   «printmeaning»  (to ".printmeaning")
--   «printpgfkey»   (to ".printpgfkey")
--   «printtikzkey»  (to ".printtikzkey")
getmeaning0   = function (str) return token.get_meaning(str) end
getmeaning    = function (str) return token.get_meaning(str) or "" end
printmeaning0 = function (str) print(getmeaning(str)) end
printmeaning  = function (str) print(str..": "..getmeaning(str)) end
printpgfkey   = function (str) printmeaning("pgfk@"..str.."/.@cmd") end
printtikzkey  = function (str) printpgfkey("/tikz/"..str) end

-- «getmeaning-tests»  (to ".getmeaning-tests")
--[==[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
loadshow2()
defs.repl = true
= ([[HELLO \condrepl]]):show00()
= ([[HELLO \condrepl]]):show0 ()
= ([[HELLO \condrepl]]):save  ()
= ([[HELLO \condrepl]]):show  ()
 (etv)

 (eepitch-shell)
 (eepitch-kill)
 (eepitch-shell)
cd /tmp/ && REPL=1 lualatex Show2.tex
  require "Tos2"
  PPC(package.loaders)
  PPC(Tos.__index)
  printmeaning "newpage"
  printmeaning "@oddfoot"

 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
loadshow2()
require "Tikz2"
defs.repl = true
= ([[HELLO \condrepl]]):show00()
= ([[HELLO \condrepl]]):show0 ()
= ([[HELLO \condrepl]]):save  ()
= ([[HELLO \condrepl]]):show  ()
 (etv)

 (eepitch-shell)
 (eepitch-kill)
 (eepitch-shell)
cd /tmp/ && REPL=1 lualatex Show2.tex
-- See:  (find-fline "~/LUA/tikz1.lua")
printmeaning("pgfk@/tikz/rounded corners/.@cmd")
printpgfkey      ("/tikz/rounded corners")
printtikzkey           ("rounded corners")
printtikzkey           ("right")

--]==]



-- Local Variables:
-- coding:  utf-8-unix
-- End:
