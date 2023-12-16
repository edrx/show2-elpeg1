-- This file:
--   http://anggtwu.net/LUA/addoverrides1.lua.html
--   http://anggtwu.net/LUA/addoverrides1.lua
--          (find-angg "LUA/addoverrides1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- Introduction
-- ============
-- A class BB is an "overclass" over a class CC when the methods in
-- BB.__index are intended to be used as overrides for some methods in
-- CC.__index. An object of this overclass BB is typically created by
-- running something like this:
--
--   o = addoverrides(CC.from(args), BB.__index)
--
-- See the test block for an example.
--
-- At this moment this is only used by:
--   (find-angg "ToTeX1.lus")
--
-- (defun ao () (interactive) (find-angg "LUA/addoverrides1.lua"))

-- «.addoverrides»		(to "addoverrides")
-- «.addoverrides-tests»	(to "addoverrides-tests")




-- Low-level logic:
--    From: A -----------------> mt1 --> C
--      to: A --> mt3 --> B2 --> mt2 --> C
--   where:                      mt2 = { __index = C }
--                        B2 = shallowcopy(B)
--                        B2.__mt = C
--                mt3 = shallowcopy(mt1)
--                mt3.__index = B2
--          A.__mt = mt3
--
-- «addoverrides»  (to ".addoverrides")

addoverrides = function (A, B)
    local mt1 = getmetatable(A)
    local C   = getmetatable(A).__index
    local mt2 = { __index = C }
    local B2  = setmetatable(shallowcopy(B), mt2)
    local mt3 = shallowcopy(mt1); mt3.__index = B2
    return setmetatable(A, mt3)
  end

-- «addoverrides-tests»  (to ".addoverrides-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "addoverrides1.lua"

CC = Class {
  type    = "CC",
  from    = function (str) return CC {str=str} end,
  __index = {
    foo   = function (o) return "foo:"..o.str end,
  },
}
BB = Class {
  type    = "BB",
  from    = function (str) return addoverrides(CC.from(str), BB.__index) end,
  __index = {
    bar = function (o) return "bar:"..o:foo() end,
  },
}

  a1 = CC.from("_a1_")
  a2 = BB.from("_a2_")
= a1:foo()             --> foo:_a1_
= a2:foo()             --> foo:_a2_
= a1:bar()             --> <error>
= a2:bar()             --> bar:foo:_a2_
= otype(a1)            --> CC
= otype(a2)            --> CC

gm  = function (o) return getmetatable(o)         end
gmi = function (o) return getmetatable(o).__index end

PPV(    gm (a2))
PPV(    gmi(a2))
PPV(gm (gmi(a2)))
PPV(gmi(gmi(a2)))

require "Tos2"
PPC(    gm (a2))
PPC(    gmi(a2))
PPC(gm (gmi(a2)))
PPC(gmi(gmi(a2)))

--]]




-- Local Variables:
-- coding:  utf-8-unix
-- End:
