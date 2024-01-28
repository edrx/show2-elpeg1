-- This file:
--   http://anggtwu.net/LUA/Co1.lua.html
--   http://anggtwu.net/LUA/Co1.lua
--          (find-angg "LUA/Co1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This class implements a Lua version of the "poor man's code" macro
-- that I wrote for my article on Dednat6. For more on it, see:
--
--   (find-es "tex" "co")
--   (find-es "tex" "poor-mans-code")
--
-- Here's an (artificial) example of how to use this class:
--
--   Lua 5.1.5  Copyright (C) 1994-2012 Lua.org, PUC-Rio
--   > dofile "Co1.lua"
--   > co = Co.new("bc", "de")
--   > = co
--   { "b"="\\b",
--     "c"="\\c",
--     "d"="\\char100 ",
--     "e"="\\char101 "
--   }
--   > = co:translate("abcdef")
--   a\b\c\char100 \char101 f
--   >
--
-- The `Co.new("bc","de")' constructs a Co object that treats `b' and
-- `c' as characters that have to be backslashed, and `d' and `e' as
-- characters that have to be translated to \char<nnn>; the `= co'
-- prints its translation table, and the `= co:translate("abcdef")'
-- returns the string "abcdef" after the translations.
--
-- For more realistic examples, see:
--   (find-angggrep "grep --color=auto -nH --null -e Co.new LUA/*.lua")
--
-- «.Co»		(to "Co")
-- «.Co-tests»		(to "Co-tests")



--   ____      
--  / ___|___  
-- | |   / _ \ 
-- | |__| (_) |
--  \____\___/ 
--             
-- «Co»  (to ".Co")
-- Support for \co, i.e., poor man's \code
-- See: (find-angg "LUA/Verbatim1.lua" "Verbatim")
--      (find-es "tex" "co")

Co = Class {
  type = "Co",
  new = function (bsls, chars)
      return Co {T=VTable{}}:addbsls(bsls or ""):addchars(chars or "")
    end,
  __tostring = function (co) return tostring(co.T) end,
  __index = {
    pat       = ".",
    translate = function (co, str) return (str:gsub(co.pat, co.T)) end,
    add       = function (co, c, transl) co.T[c] = transl; return co end,
    addbsls   = function (co, bsls)
        for c in bsls:gmatch"." do co:add(c, "\\"..c) end
        return co
      end,
    addchars = function (co, bsls)
        for c in bsls:gmatch"." do co:add(c, "\\char"..string.byte(c).." ") end
        return co
      end,
    --
    translator = function (co)
        return function (str) return co:translate(str) end
      end,
    --
    translateshow = function (co, str)
        return ("\\texttt{"..co:translate(str).."}"):show()
      end,
  },
}

-- «Co-tests»  (to ".Co-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Co1.lua"
co = Co.new("bc", "de")
= co
= co:translate("abcdef")
cot = co:translator()
= cot("abcdef<foo>")
  co:add("<", "〈"):add(">", "〉")
= cot("abcdef<foo>")

 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Co1.lua"
require "Show2"
co = Co.new("#$", " %&\\^_{}~"):add("\n", "\\\\\n")
= co:translate     [[Foo#$ %&\^_{}~]]
= co:translateshow [[Foo#$ %&\^_{}~]]
 (etv)

--]==]



-- Local Variables:
-- coding:  utf-8-unix
-- End:
