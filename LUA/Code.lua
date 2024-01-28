-- This file:
--   http://angg.twu.net/LUA/Code.lua.html
--   http://angg.twu.net/LUA/Code.lua
--           (find-angg "LUA/Code.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- Version: 2023apr15
-- Public domain.
--
-- (defun e () (interactive) (find-angg "LUA/Code.lua"))
-- Will be superseded by:
--   (find-angg "LUA/Code2.lua")


-- «.Code»		(to "Code")
-- «.Code-tests»	(to "Code-tests")


--   ____          _      
--  / ___|___   __| | ___ 
-- | |   / _ \ / _` |/ _ \
-- | |__| (_) | (_| |  __/
--  \____\___/ \__,_|\___|
--                        
-- «Code»  (to ".Code")
-- Also here: (find-angg "LUA/lua50init.lua" "Code")
--
-- The class Code "converts strings to executable code" in nice ways.
-- Initially there are two basic ways to do the conversion:
--
--    Code.ve [[ a,b =>                  10*a + b ]] (3, 4)
--    Code.vc [[ a,b => print(a); return 10*a + b ]] (3, 4)
--
-- roughly,
--
--    Code.ve interprets its argument as "var => expr", and
--    Code.vc interprets its argument as "var => code".
--
-- It is relatively easy to add other ways to interpret the "code".
-- An object of the class Code has two fields: .src, with the "code"
-- in the original received form, and .code, with it converted to Lua
-- code that can be run with loadstring. TA-DA: an object of the class
-- Code does NOT contain a compiled version of its .code field! 8-O

Code = Class {
  type = "Code",
  from = function (src) return Code {src=src} end,
  ve   = function (src) return Code.from(src):setcodeve() end,
  vc   = function (src) return Code.from(src):setcodevc() end,
  L    = function (src) return Code.ve(src):f() end,
  __tostring = function (c) return c.src end,
  __call     = function (c, ...) return c:f()(...) end,
  __index = {
    format    = function (c, fmt) return format(fmt, c:parse2()) end,
    setcode   = function (c, fmt) c.code = c:format(fmt); return c end,
    setcodeve = function (c) return c:setcode("local %s=...; return %s") end,
    setcodevc = function (c) return c:setcode("local %s=...; %s") end, 
    f         = function (c) return assert(loadstring(c.code)) end,
    --
    pat = "^%s*([%w_,]+)%s*[%-=]>(.*)$",
    parse2 = function (c)
        local vars,rest = c.src:match(c.pat)
        if not vars then error("Code.parse2 can't parse: "..c.src) end
        return vars, rest
      end,
  },
}

-- Convenience functions:
--   ve = Code.ve
--   vc = Code.vc


-- «Code-tests»  (to ".Code-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Code.lua"
PP(Code.from [[ a,b => 10*a + b ]] :parse2())

=    Code.ve [[ a,b => 10*a + b ]]
=    Code.ve [[ a,b => 10*a + b ]] :f()
=    Code.ve [[ a,b => 10*a + b ]] :f() (3, 4)
=    Code.ve [[ a,b => 10*a + b ]]      (3, 4)
=    Code.ve [[ a,b => 10*a + b ]] .src
=    Code.ve [[ a,b => 10*a + b ]] .code
PPV( Code.ve [[ a,b => 10*a + b ]] )

=    Code.vc [[ a,b => print(a); return 10*a + b ]]
=    Code.vc [[ a,b => print(a); return 10*a + b ]] :f()
=    Code.vc [[ a,b => print(a); return 10*a + b ]] :f() (3, 4)
=    Code.vc [[ a,b => print(a); return 10*a + b ]]      (3, 4)
=    Code.vc [[ a,b => print(a); return 10*a + b ]] .src
=    Code.vc [[ a,b => print(a); return 10*a + b ]] .code
PPV( Code.vc [[ a,b => print(a); return 10*a + b ]] )

L = Code.L
= L 'a,b=>100*a+b' (3,4)
= L 'a,b->100*a+b' (3,4)
= L 'a,b!>100*a+b' (3,4)   -- err

--]==]



-- Local Variables:
-- coding:  utf-8-unix
-- End:

