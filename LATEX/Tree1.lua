-- This file:
--   http://angg.twu.net/LUA/Tree1.lua.html
--   http://angg.twu.net/LUA/Tree1.lua
--           (find-angg "LUA/Tree1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/Tree1.lua"))
-- From: (find-anggfile "LUA/Monkey1.lua")
-- Usage:
--   require "Tree1"    -- (find-anggfile "LUA/Tree1.lua")

treetor = function (o)
    if type(o) == "table" then return SynTree.from(o):torect() end
    return torect(tostring(o))
  end
treetos = function (o) return tostring(treetor(o)) end
trees = function (...)
    local conc = function (a, b) return a.."  "..b end
    return foldl1(conc, map(treetor, {...}))
  end

Tree = Class {
  type = "Tree",
  __tostring = function (o) return treetos(o) end,
  __index = {
  },
}


--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Tree1.lua"
= trees({1, 2, {3, 4}}, {22, 33})
= trees({1, 2, {3, 4}}, {22, 33}, true)
= trees({1, 2, {3, 4}}, {22, 33}, true, "foo")

--]]





-- Local Variables:
-- coding:  utf-8-unix
-- End:
