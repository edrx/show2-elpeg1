-- This file:
--   http://anggtwu.net/LUA/Indent2.lua.html
--   http://anggtwu.net/LUA/Indent2.lua
--          (find-angg "LUA/Indent2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This file defines the class Indent and the lowest-level methods of
-- the class Pict. The middle-level methods of the class Pict are
-- defined, and explained, here:
--
--  (find-angg "LUA/Pict3.lua" "PictBounds-methods")
--  (find-angg "LUA/Pict3.lua" "Pict-show")
--
-- This file does not implement a ":show()" method for pict objects;
-- see the link to "Pict-show" above.
--
-- (defun e  () (interactive) (find-angg "LUA/Indent2.lua"))
-- (defun e1 () (interactive) (find-angg "LUA/ELpeg1.lua"))
-- (defun i1 () (interactive) (find-angg "LUA/Indent1.lua"))
-- (defun i2 () (interactive) (find-angg "LUA/Indent2.lua"))
-- (defun p2 () (interactive) (find-angg "LUA/Pict2e2.lua"))
-- (defun p3 () (interactive) (find-angg "LUA/Pict3.lua"))

-- «.Indent»		(to "Indent")
-- «.Indent-tests»	(to "Indent-tests")
-- «.Pict»		(to "Pict")
-- «.Pict-tests»	(to "Pict-tests")

require "Stack1"  -- (find-angg "LUA/Stack1.lua")
require "ELpeg1"  -- (find-angg "LUA/ELpeg1.lua" "Gram")

spaces = function (n) return string.rep(" ", n) end

flatten = function (o)
    local out = VTable {}
    local add   -- recursive, defined in the next line
    add = function (x)
        if type(x) == "table"
        then map(add, x)
        else table.insert(out, x)
        end
      end
    add(o)
    return out
  end


--  ___           _            _   
-- |_ _|_ __   __| | ___ _ __ | |_ 
--  | || '_ \ / _` |/ _ \ '_ \| __|
--  | || | | | (_| |  __/ | | | |_ 
-- |___|_| |_|\__,_|\___|_| |_|\__|
--                                 
-- «Indent»  (to ".Indent")

Indent = Class {
  type  = "Indent",
  from  = function (bigstr) return Indent.from0(bigstr):concat() end,
  from0 = function (bigstr) return Indent.new():split(bigstr):runall() end,
  new   = function ()
      return Indent {stack=Stack.new(), prefixn=0, outs=VTable{}}
    end,
  makepat = function (open, close)
      local tocmd   = function (tbl) return HTable(tbl) end
      local toitems = function (tbl) return VTable(tbl) end
      local gr,V = Gram.new()
      V.o       = P(open)
      V.c       = P(close)
      V.hs      = S" \t"
      V.s       = S" \t\n"
      V.ss      = V.s^0
      V.l       = V.ss:C():Cg"l"
      V.r       = V.ss:C():Cg"r"
      V.cmdbody = ((-V.c*P(1))^0):C():Cg"cmdbody"
      V.cmd     = (V.l * V.o * V.cmdbody * V.c * V.r):Ct() / tocmd
      V.nl      = P"\n":Ct() / tocmd
      V.hspaces = (V.hs^1):C()
      V.other   = ((-V.s * -V.o * -V.c * P(1))^1):C()
      V.item    = V.cmd + V.hspaces + V.nl + V.other
      V.toitems = (V.item^0):Ct() / toitems
      return gr:compile("toitems")
    end,
  setopenclose = function (open, close)
      Indent.__index.o = open
      Indent.__index.c = close
      Indent.__index.pat = Indent.makepat(open, close)
    end,
  __index = {
    -- o = "<",   -- open
    -- c = ">",   -- close
    -- pat = Indent.makepat("<", ">"),
    --
    -- :ocfix(str) lets us write the delimiters as "<" and ">".
    -- For example, if o is "[." and c is ".]",
    -- then:      ind:ocfix("foo <i:pop()> bar")
    -- returns:            "foo [.i:pop().] bar"
    --
    ocfix = function (ind,str)
        return (str:gsub("([<>])", {["<"]=ind.o, [">"]=ind.c}))
      end,
    --
    split0 = function (ind,bigstr) return ind.pat:match(bigstr) end,
    split  = function (ind,bigstr) ind.ins = ind:split0(bigstr); return ind end,
    prefix = function (ind,delta) return spaces(ind.prefixn + (delta or 0)) end,
    nl     = function (ind,delta) return "\n"..ind:prefix(delta) end,
    ind    = function (ind,delta)
        ind.stack:push(ind.prefixn)
        ind.prefixn = ind.prefixn+delta
        return ind
      end,
    pop    = function (ind) ind.prefixn = ind.stack:pop(); return ind end,
    out    = function (ind,o) table.insert(ind.outs, o); return ind end,
    concat = function (ind) return table.concat(ind.outs) end,
    --
    runstr = function (ind,s) ind:out(s); return ind end,
    runnl  = function (ind)   ind:out(ind:nl()); return ind end,
    runcmd = function (ind,c)
        local l = c.l
        local r = c.r
        local o = l..r
        local cmd = format("local i,l,r,o=...; %s\nreturn o", c.cmdbody)
        local o2 = assert(loadstring(cmd))(ind, l, r, o)
        ind:out(o2)
      end,
    runo  = function (ind,o)
        if type(o) == "string" then ind:runstr(o)
        elseif not o.cmdbody then ind:runnl()
        else ind:runcmd(o)
        end
        return ind
      end,
    runall = function (ind)
        for _,o in ipairs(ind.ins) do ind:runo(o) end
        return ind
      end,
  },
}

Indent.setopenclose("<", ">")

-- «Indent-tests»  (to ".Indent-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Indent2.lua"
bigstr = "abc def <foo> \nbar\nplic"
bigstr = "abc def\nbar\nplic"
bigstr = "aaa\nbbb\nccc<i:ind(2)>ddd\neee\nfff<i:pop()>ggg\nhhh"
i = Indent.new():split(bigstr)
= i
= i.ins
= i.outs
= i:runall()
= i.outs
= i:concat()

bigstr = "foo{<i:ind(2);o=i:nl()>\nbar<i:pop()>\n}"
= Indent.from(bigstr)

Indent.setopenclose("[",     "]")
Indent.setopenclose("<<.", ".>>")
bigstr = "foo{[   i:ind(2);o=i:nl()   ]\nbar[   i:pop()   ]\n}"
bigstr = "foo{<<. i:ind(2);o=i:nl() .>>\nbar<<. i:pop() .>>\n}"
i = Indent.new():split(bigstr)
= i
= i.ins
= Indent.from(bigstr)

= Indent({}):ocfix("foo<o=i:nl()> bar")

--]]




--  ____  _      _   
-- |  _ \(_) ___| |_ 
-- | |_) | |/ __| __|
-- |  __/| | (__| |_ 
-- |_|   |_|\___|\__|
--                   
-- «Pict»  (to ".Pict")
-- Based on: (find-angg "LUA/Pict2e2.lua" "Pict")
-- See:      (find-angg "LUA/Pict3.lua" "Pict-show")
--
Pict = Class {
  type = "Pict",
  __tostring = function (o) return o:tostring() end,
  __index = {
    tostring = function (o,percent)
        local bigstr = o:indent()
        if percent then bigstr = bigstr:gsub("\n", "%%\n") end
        return bigstr
      end,
    indent = function (o) return Indent.from(o:concat()) end,
    concat = function (o) return table.concat(flatten(o), "\n") end,
    --
    output  = function (p) output(p:tostring("%")) end,
    add     = function (o,o2) table.insert(o, o2); return o end,
    print   = function (o,o2) return p:add(o) end,
    printf  = function (o,...) return p:add(format(...)) end,
    pprintf = function (o,...) return p:add(pformat(...)) end,
    --
    glue_     = "<o=''>",
    ["{+1"]   = "{<i:ind(1);o=''>",
    ["{+2"]   = "{<i:ind(2);o=i:nl()>",
    ["}"]     = "<i:pop();o=''>}",
    ["nl}"]   = "<i:pop();o=i:nl()>}",
    ["$+1"]   = "<i:ind(1);o='$'>",
    ["$$+2"]  = "<i:ind(2);o='$$'>",
    ["{$+1"]  = "<i:ind(1);o='{$'>",
    ["pop$"]  = "<i:pop();o='$'>",
    ["pop$$"] = "<i:pop();o='$$'>",
    ["pop$}"] = "<i:pop();o='$}'>",
    ["+2nl"]  = "<i:ind(2);o=i:nl()>",
    ["popnl"] = "<i:pop(); o=i:nl()>",
    --
    cmd0 = function (o,str) return Indent({}):ocfix(str) end,
    cmd  = function (o,tag) return Indent({}):ocfix(o[tag]) end,
    glue   = function (o) return Pict {o:cmd0("glue_")} end,
    --
    pre0   = function (o,prestr) return Pict({prestr, o}) end,
    preg   = function (o,prestr) return Pict({prestr, o:cmd("glue_"), o}) end,
    pre    = function (o,prestr) return prestr and o:preg(prestr) or o end,
    wrap0  = function (o,tag1,tag2) return Pict({o:cmd(tag1), o, o:cmd(tag2)}) end,
    wrapp  = function (o,tag1,tag2,prestr) return o:wrap0(tag1,tag2):pre(prestr) end,
    wrap1  = function (o, prestr) return o:wrapp("{+1",      "}", prestr) end,
    wrap2  = function (o, prestr) return o:wrapp("{+2",    "nl}", prestr) end,
    wrap1d = function (o, prestr) return o:wrapp("{$+1", "pop$}", prestr) end,
    wrapsp = function (o, prestr) return o:wrapp("+2nl", "popnl", prestr) end,
    wrapbe = function (o,b,e) return Pict {b, o:wrapsp(), e} end,
    --
    em        = function (o) return o:wrap1("\\ensuremath")  end,
    d         = function (o) return o:wrapp("$+1",   "pop$") end,
    dd        = function (o) return o:wrapp("$$+2", "pop$$") end,
    def       = function (o, name) return o:wrap2("\\def\\"..name) end,
    sa        = function (o, name) return o:wrap2("\\sa{"..name.."}") end,
    color     = function (o, color) return o:pre0("\\color{"..color.."}"):wrap1() end,
    Color     = function (o, color) return o:wrap1("\\Color"..color) end,
    precolor0 = function (o, color) return o:pre0("\\color{"..color.."}") end,
    precolor  = function (o, color) return o:pre0("\\color{"..color.."}"):wrap1() end,
    prethickness = function (o, th) return o:pre0("\\linethickness{"..th.."}") end,
    preunitlength = function (o, u) return o:pre0("\\unitlength="..u) end,
    bhbox     = function (o) return o:wrap1d("\\bhbox") end,
    myvcenter = function (o) return o:wrap1("\\myvcenter") end,
    putat     = function (o, xy) return o:wrap1(pformat("\\put%s", xy)) end,
    --
    scalebox  = function (o, scale)
        if not scale then return o end
        return o:em():wrap2("\\scalebox{"..scale.."}")
      end,
  },
}

-- «Pict-tests»  (to ".Pict-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Indent2.lua"
= Pict {"bar"} :wrapp("{+2", "nl}", "\\foo")
= Pict {"foo", "bar"} :wrap1()
= Pict {"foo", "bar"} :wrap1("\\text")
= Pict {"foo", "bar"} :wrap1("\\ensuremath")
= Pict {"foo", "bar"} :wrap2()
= Pict {"foo", "bar"} :wrap2("\\pre")
= Pict {"foo", "bar"} :wrap2("\\pre") :tostring()
= Pict {"foo", "bar"} :wrap2("\\pre") :tostring("%")
= Pict {"foo", "bar"} :wrap2("\\pre") :concat()
= Pict {"foo", "bar"} :d()
= Pict {"foo", "bar"} :dd()
= Pict {"foo", "bar"} :def("plic")
= Pict {"foo", "bar"} :sa ("plic")
= Pict {"foo", "bar"} :color("red")
= Pict {"foo", "bar"} :Color("Red")
= Pict {"foo", "bar"} :precolor("red")
= Pict {"foo", "bar"} :prethickness("2pt")
= Pict {"foo", "bar"} :preunitlength("2pt")
= Pict {"foo", "bar"} :bhbox()
= Pict {"foo", "bar"} :myvcenter()
= Pict {"foo", "bar"} :putat("(2,3)")
= Pict {"foo", "bar"} :wrapbe("aaa", "bbb")
= Pict {"foo", "bar"} :wrapbe("aaa", "bbb"):wrapbe("ccc", "ddd")

glue = "<o=''>"
nl   = "<o='\\n'>"
p    = "<o=i:prefix()>"
b    = "<i:ind(2);o=''>"
e    = "<i:pop();o=''>"

= Pict {"aaa", glue, nl, b, "foo", "bar", glue, e, "bbb"}   -- good
= Pict {"aaa",       nl, b, "foo", "bar", glue, e, "bbb"}   -- good
= Pict {"aaa", glue, nl, b, "foo", "bar", e, glue, "bbb"}
= Pict {"aaa", glue, nl, b, "foo", "bar", e, nl, "bbb"}

b = "<i:ind(2);o=i:nl()>"
e = "<i:pop();o=i:nl()>"
= Pict {"aaa", b, "foo", "bar", e, "bbb"}



Indent.setopenclose("<<.", ".>>")
= Pict {"foo", "bar"} :wrap2("\\pre")
= Pict {"foo", "bar"} :wrap2("\\pre") :concat()

--]]


-- (find-angg "LUA/Indent1.lua" "flatten")




-- Local Variables:
-- coding:  utf-8-unix
-- End:
