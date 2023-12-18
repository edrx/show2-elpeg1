-- This file:
--   http://anggtwu.net/LUA/DeleteComments2.lua.html
--   http://anggtwu.net/LUA/DeleteComments2.lua
--          (find-angg "LUA/DeleteComments2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- See: (find-dn6 "output.lua" "deletecomments_2021")
--      (find-dn6 "output.lua" "deletecomments")
--      (find-anggfile "LUA/Maxima1.lua" "DeleteComments2")
-- Usage:
--   require "DeleteComments2" -- (find-angg "LUA/DeleteComments2.lua")
--   deletecomments = deletecomments_2023
--
-- (defun e1 () (interactive) (find-angg "LUA/ELpeg1.lua"))
-- (defun d2 () (interactive) (find-angg "LUA/DeleteComments2.lua"))

require "ELpeg1"  -- (find-angg "LUA/ELpeg1.lua")
--    gr,V,VAST,VEXPECT,PEXPECT = Gram.new()
local gr,V,VAST,VEXPECT,PEXPECT = Gram.new()

V.PR1         = P"%" * (1-S"\n")^0   -- a percent and everything at its right
V.NS1         = "\n" * (S" \t")^0    -- a newline and the spaces following it
V.PR2         = V.PR1 * V.NS2^-1     -- recurse starting from PR1
V.NS2         = V.NS1 * V.PR2^-1     -- recurse starting from NS1
V.comment     = V.PR2
V.commentspc  = V.comment / " "
V.commentdel  = V.comment / ""
V.qperc       = P"\\%"
V.qname       = P"\\"*R("AZ","az")^1
V.qnamec      = P"\\"*R("AZ","az")^1 * V.commentspc^-1
V.unit        = V.qperc + V.qnamec + V.commentdel + P(1)
V.delcomments = (V.unit^0):Cs()

deletecomments_2023_ = gr:compile("delcomments")
deletecomments_2023  = function (bigstr)
    return deletecomments_2023_:match(bigstr)
  end

--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "DeleteComments2.lua"
= gr:cm("delcomments",       "%foo\n %plic\n  ploc")
= gr:cm("delcomments", "blergh%foo\n %plic\n  ploc")
= gr:cm("delcomments", "b\\rgh%foo\n %plic\n  ploc")
=  deletecomments_2023 "b\\rgh%foo\n %plic\n  ploc"

--]==]





-- Local Variables:
-- coding:  utf-8-unix
-- End:
