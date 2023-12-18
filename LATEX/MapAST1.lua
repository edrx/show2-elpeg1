-- This file:
--   http://anggtwu.net/LUA/MapAST1.lua.html
--   http://anggtwu.net/LUA/MapAST1.lua
--          (find-angg "LUA/MapAST1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- A tool for simplifying ASTs.
-- Used by:
--   (find-angg "LUA/CME2.lua" "grammar-tests")
-- Inspired by:
--   (find-angg "LUA/ParseTree2.lua" "ParseTree")
--
-- (defun e () (interactive) (find-angg "LUA/MapAST1.lua"))

-- «.MapAST»		(to "MapAST")
-- «.MapAST-tests»	(to "MapAST-tests")

require "ELpeg1"     -- (find-angg "LUA/ELpeg1.lua")



--  __  __               _    ____ _____ 
-- |  \/  | __ _ _ __   / \  / ___|_   _|
-- | |\/| |/ _` | '_ \ / _ \ \___ \ | |  
-- | |  | | (_| | |_) / ___ \ ___) || |  
-- |_|  |_|\__,_| .__/_/   \_\____/ |_|  
--              |_|                      
-- «MapAST»  (to ".MapAST")

MapAST = Class {
  type    = "MapAST",
  __index = {
    trivs = Set.new(),
    mkast = function (m, o0, ...) return mkast(o0, ...) end,
    mkf = function (m) return function (o) return m:f(o) end end,
    f = function (m, o)
        if type(o) ~= "table" then return o end
        if m.trivs:has(o[0]) then return m:f(o[1]) end
        if m.heads[o[0]] then return m.heads[o[0]](m, o) end
        return m:mkast(o[0], unpack(map(m:mkf(), o)))
      end,
  },
}

-- «MapAST-tests»  (to ".MapAST-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "MapAST1.lua"
ma = MapAST {
  trivs = Set.from(split("() fun var num")),
  trivs = trivs1,
  heads = { 
    ["ap"] = function(m, o) return m:mkast(m:f(o[1]), m:f(o[2])) end,
  },
}

  o = mkast("var", "y")
  o = mkast("ap", "f", 42)
  o = mkast("ap", "f", mkast("ap", "g", 99))
  o = mkast("ap", "f", mkast("ap", "g", mkast("num", 99)))
= o
= ma:f(o)


--]==]



-- Local Variables:
-- coding:  utf-8-unix
-- End:
