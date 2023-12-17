-- This file:
--   http://anggtwu.net/LUA/LpegRex3.lua.html
--   http://anggtwu.net/LUA/LpegRex3.lua
--          (find-angg "LUA/LpegRex3.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This is similar to:
--   (find-angg "LUA/Re2.lua")
-- but for lpegrex.lua.
--
-- (defun e1 () (interactive) (find-angg "LUA/ELpeg1.lua"))
-- (defun l3 () (interactive) (find-angg "LUA/LpegRex3.lua"))
-- (find-es "lpeg" "lpegrex")

-- «.LpegRex»		(to "LpegRex")
-- «.LpegRex-tests»	(to "LpegRex-tests")



--  _                      ____           
-- | |    _ __   ___  __ _|  _ \ _____  __
-- | |   | '_ \ / _ \/ _` | |_) / _ \ \/ /
-- | |___| |_) |  __/ (_| |  _ <  __/>  < 
-- |_____| .__/ \___|\__, |_| \_\___/_/\_\
--       |_|         |___/                
-- «LpegRex»  (to ".LpegRex")

LpegRex = Class {
  type    = "LpegRex",
  from = function (str) return LpegRex {str=str} end,
  __index = {
    defs = {__options={}},
    compile = function (lr) return lpegrex.compile(lr.str, lr.defs) end,
    match   = function (lr,subj,init) return lr:compile():match(subj,init) end,
    pm      = function (lr,subj) return PP(lr:compile():match(subj)) end,
    pmt     = function (lr,subj) print(trees(lr:compile():match(subj))) end,
  },
}

lre = LpegRex.from

-- «LpegRex-tests»  (to ".LpegRex-tests")
--[==[
 (eepitch-lua52)
 (eepitch-kill)
 (eepitch-lua52)
dofile "LpegRex3.lua"
loadlpegrex()       -- (find-angg "LUA/lua50init.lua" "loadlpegrex")
require "Re2"       -- (find-angg "LUA/Re2.lua" "Re-tests")
rre "{ '<' {[io]} {[0-9]+} '>' } {.*}"      :pm "<i42> 2+3;"  -- re.lua
lre "{ '<' {[io]} {[0-9]+} '>' } {.*}"      :pm "<i42> 2+3;"  -- lpegrex

-- (find-es "lpeg" "lpegrex-tag")
-- (find-lpegrexpage 2 "AST Nodes" "NodeName <== patt")
-- (find-lpegrextext 2 "AST Nodes" "NodeName <== patt")
-- (find-lpegrexpage 5 "pos = 'init'")
-- (find-lpegrextext 5 "pos = 'init'")
-- (find-lpegrexpage 6 "tag = function(tag, node)")
-- (find-lpegrextext 6 "tag = function(tag, node)")

require "ELpeg1"
lre " foo <== {.} {.} "  :pm  "ab"
lre " foo <== {.} {.} "  :pmt "ab"

LpegRex.__index.defs.__options.pos    = "b"
LpegRex.__index.defs.__options.endpos = "e"
LpegRex.__index.defs.__options.tag    = function (name, node)
    node[0] = name
    return AST(node)
  end

-- Constant capture
-- A VA with a different name

lre " top <- foo   foo <-         {.} {.} "  :pmt "ab"
lre " top <- foo   foo <--        {.} {.} "  :pmt "ab"
lre " top <- foo   foo <-- $'bar' {.} {.} "  :pmt "ab"

lre " top <- foo   foo        <-| {.} {.} "  :pm  "ab"
lre " top <- foo   foo        <== {.} {.} "  :pm  "ab"
lre " top <- foo   foo        <== {.} {.} "  :pmt "ab"
lre " top <- foo   foo : bar  <== {.} {.} "  :pmt "ab"

--]==]




-- Local Variables:
-- coding:  utf-8-unix
-- End:
