-- This file:
--   http://anggtwu.net/LUA/Re2.lua.html
--   http://anggtwu.net/LUA/Re2.lua
--          (find-angg "LUA/Re2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This file implements a :pm(...) "method" for re.lua that lets us
-- compare the syntax of Lua patterns, lpeg, and re. See this test
-- block:
--   (find-angg "LUA/ELpeg1.lua" "lpeg.pm-tests")
--
-- The long story
-- ==============
-- In 2012 I had a project that needed a "precedence parser" that
-- could parse arithmetical expressions. At that point I (still)
-- couldn't wrap my mind around "pure" lpeg, so I tried to learn
-- re.lua instead, and I wrote this class:
--   (find-angg "LUA/Re.lua")
--   (find-angg "LUA/lua50init.lua" "Re")
--   (find-angg "LUA/lua50init.lua" "re_expand_INFIX")
--   (find-angg "LUA/lua50init.lua" "math-grammar")
-- that allowed me to use a preprocessor on patterns for re.lua. Using
-- that was very clumsy, though.
--
-- In 2022 I tried to learn lpegrex. It was much more powerful that
-- re.lua, but after a while I realized that it had the same defects
-- as re.lua:
--
--   1. it didn't have some features that I needed,
--   2. it didn't let us explore the lpeg patterns that it generated
--      from its input string,
--   3. I couldn't modify parts of its code from a REPL,
--   4. it was hard to explore, hack, and extend (IMO),
--   5. its docs weren't very clear (IMO),
--   6. its developer was too busy to help me =(.
--
-- In 2023 I wrote ELpeg1.lua, that was an attempt to write a
-- hacker-friendly version of (the back-end parts of) re.lua and
-- lpegrex.lua, without the front-end part that parses a grammar given
-- as a string. In dec/2023 I mentioned ELpeg1.lua in my presentation
-- at the EmacsConf2023, and I wrote :pm(...) methods for re.lua and
-- lpegrex.lua to let me compare their input languages. See:
--   (find-angg "LUA/LpegRex3.lua")
--
-- (defun r2 () (interactive) (find-angg "LUA/Re2.lua"))
-- (defun r1 () (interactive) (find-angg "LUA/Re.lua"))
-- (defun rq () (interactive) (find-es "lpeg" "re-quickref"))
-- (find-lpegremanual "")
-- (find-lpegremanual "#ex")

-- «.Re»	(to "Re")
-- «.Re-tests»	(to "Re-tests")

re = require "re"

--  ____      
-- |  _ \ ___ 
-- | |_) / _ \
-- |  _ <  __/
-- |_| \_\___|
--            
-- «Re»  (to ".Re")

Re = Class {
  type = "Re",
  from = function (str) return Re {str=str} end,
  __index = {
    defs = {},
    compile = function (r)           return re.compile(r.str, r.defs) end,
    find    = function (r,subj,init) return re.find(subj, r:compile(), init) end,
    match   = function (r,subj)      return re.match(subj, r:compile()) end,
    gsub    = function (r,subj,repl) return re.gsub(subj, r:compile(), repl) end,
    pm      = function (r,subj)      return PP(r:match(subj)) end,
  },
}

rre = Re.from

-- «Re-tests»  (to ".Re-tests")
-- See: (find-angg "LUA/Re.lua" "Re-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Re2.lua"

print(re.find ("the number 423 is odd", "[0-9]+"))           --> 12  14
print(re.match("the number 423 is odd", "({%a+} / .)*"))     --> the  number  is  odd
print(re.match("the number 423 is odd", "s <- {%d+} / . s")) --> 423
print(re.gsub ("hello World", "[aeiou]", "."))               --> h.ll. W.rld

= Re.from "[0-9]+"            :find  "the number 423 is odd"
= Re.from "({%a+} / .)*"      :match "the number 423 is odd"
= Re.from "s <- {%d+} / . s"  :match "the number 423 is odd"
= Re.from "[aeiou]"           :gsub ("hello World", ".")

  Re.from "({%a+} / .)*"      :pm "the number 423 is odd"
  Re.from "s <- {%d+} / . s"  :pm "the number 423 is odd"

rre       "({%a+} / .)*"      :pm "the number 423 is odd"
rre       "s <- {%d+} / . s"  :pm "the number 423 is odd"

rre             "[io]"                              :pm  "i42"
rre            "{[io]}"                             :pm  "i42"
rre            "{[io]}       {[0-9]+}"              :pm  "i42"
rre    "'('     {[io]}       {[0-9]+} ')'"          :pm "(i42) 2+3;"
rre "{  '('     {[io]}       {[0-9]+} ')'  }"       :pm "(i42) 2+3;"
rre "{  '('     {[io]}       {[0-9]+} ')'  } {.*}"  :pm "(i42) 2+3;"
rre "{| '('     {[io]}       {[0-9]+} ')' |} {.*}"  :pm "(i42) 2+3;"
rre "{| '(' {:a: [io]:} {:b: [0-9]+:} ')' |} {.*}"  :pm "(i42) 2+3;"

--]==]






-- Local Variables:
-- coding:  utf-8-unix
-- End:
