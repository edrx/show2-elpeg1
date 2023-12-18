-- This file:
--   http://angg.twu.net/LUA/Stack1.lua.html
--   http://angg.twu.net/LUA/Stack1.lua
--           (find-angg "LUA/Stack1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun s () (interactive) (find-angg "LUA/Stack1.lua"))
-- (find-angggrep "grep --color=auto -nH --null -e Stack LUA/*.lua")

-- (find-dn6 "stacks.lua" "Stack")
--
Stack = Class {
  type    = "Stack",
  new     = function () return Stack {} end,
  --
  __tostring = function (s) return mapconcat(tostring, s, " ") end,
  __index = {
    push  = function (s, o) table.insert(s, o); return s end,
    pushs = function (s, ...) for _,o in ipairs({...}) do s:push(o) end; return s end,
    --
    check     = function (s) assert(#s>0, s.msg or "Empty stack"); return s end,
    drop      = function (s) s:check(); s[#s]=nil; return s end,
    dropn     = function (s, n) for i=1,n  do s:drop() end; return s end,
    dropuntil = function (s, n) while #s>n do s:drop() end; return s end,
    clear     = function (s)    return s:dropn(#s) end,
    --
    pop  = function (s) return                            s[#s], s:dropn(1) end,
    pop2 = function (s) return                   s[#s-1], s[#s], s:dropn(2) end,
    pop3 = function (s) return          s[#s-2], s[#s-1], s[#s], s:dropn(3) end,
    pop4 = function (s) return s[#s-3], s[#s-2], s[#s-1], s[#s], s:dropn(4) end,
    --
    pick = function (s, offset) return s[#s-offset] end,
    pock = function (s, offset, o)     s[#s-offset] = o; return s end,
    --
    PP    = function (s) PP(s); return s end,
    print = function (s) print(s); return s end,

  },
}

--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Stack1.lua"
s = Stack.new()
= s
s:push(22):push(33)
= s

s:push(22):push(33):PP()
= s:clear():push(22):push(33):PP():push(44):PP():dropn(2)
= s:clear():push(22):push(33):PP():push(44):PP():dropn(2):PP():pop()
= Stack.new():push(11):push(22):push(33)
= s:dropn(4)

--]]



-- Local Variables:
-- coding:  utf-8-unix
-- End:
