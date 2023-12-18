-- This file:
--   http://anggtwu.net/LUA/ToTeX1.lua.html
--   http://anggtwu.net/LUA/ToTeX1.lua
--          (find-angg "LUA/ToTeX1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This file implements a way to converts ASTs to TeX code.
-- It defines two classes: Subst, that is very low-level, and ToTeX,
-- that is built on top to Subst; ToTeX overrides some of the methods
-- in Subst a tricky way - using the function addoverrides, that is
-- defined in another file. Each ToTeX object is the core of a
-- "totexer"; each totexer is a way to convert ASTs to tex code.
-- Totexers are defined at the end of this file.
--
-- Introduction
-- ============
-- The class Dang in Show2 has two ways of expanding substrings in
-- <D>ouble <ang>le brackets: in
--
--   Dang.replace "a<<2+3>>b<<:return 4+5>>"
--
-- it treats the "2+3" as an "expression" and the "return 4+5" as
-- "statements". For the details, see:
--
--   (find-angg "LUA/Show2.lua")
--   (find-angg "LUA/Show2.lua" "Dang-tests")
--
-- The class Subst extends this idea with other kinds of
-- substitutions. In
--
--   Subst.replace "_<1>_<2+3>_<:return 4+5>_<aa>_"
--
--   the "1"           in <1>           is expanded with expn,
--   the "2+3"         in <2+3>         is expanded with expexpr,
--   the ":return 2+3" in <:return 2+3> is expanded with expeval, and
--   the "aa"          in <aa>          is expanded with expfield.
--
-- In the class Subst all these methods are defined in a way that is
-- suited for debugging; in the class ToTeX they are replaced by methods
-- that are more complex - some are even recursive - and that are
-- suited for generating tex code.
--
-- Supersedes:
--   (find-angg "LUA/Subst1.lua")
-- Used by:
--   (find-angg "LUA/ELpeg1.lua" "AST")
--
-- (defun tt () (interactive) (find-angg "LUA/ToTeX1.lua"))
-- (defun s1 () (interactive) (find-angg "LUA/Subst1.lua"))

-- «.Subst»			(to "Subst")
-- «.Subst-tests»		(to "Subst-tests")
-- «.ToTeX»			(to "ToTeX")
-- «.ToTeX-tests»		(to "ToTeX-tests")
-- «.totexer»			(to "totexer")
-- «.totexer-tests»		(to "totexer-tests")

require "ELpeg1"         -- (find-angg "LUA/ELpeg1.lua")
require "Show2"          -- (find-angg "LUA/Show2.lua")
require "addoverrides1"  -- (find-angg "LUA/addoverrides1.lua")
L = Code.L               -- (find-angg "LUA/Code.lua" "Code")


--  ____        _         _   
-- / ___| _   _| |__  ___| |_ 
-- \___ \| | | | '_ \/ __| __|
--  ___) | |_| | |_) \__ \ |_ 
-- |____/ \__,_|_.__/|___/\__|
--                            
-- (find-angg "LUA/lua50init.lua" "pformat" "myntos =")
-- «Subst»  (to ".Subst")

Subst = Class {
  type    = "Subst",
  replace = function (str,verbose) return Subst{}:replace(str, verbose) end,
  __tostring = function (su) return su:tostring() end,
  __index = {
    tostring = function (tt) return "(Dummy tostring)" end,
    --
    nil_tos    = function (su)      return "(nil)" end,
    number_tos = function (su, n)   return myntos(n) end,
    table_tos  = function (su, tbl) return mytostring(tbl) end,
    tostring1  = function (su, o)
        if type(o) == "string" then return o                end
        if type(o) == "nil"    then return su:nil_tos()     end
        if type(o) == "number" then return su:number_tos(o) end
        if type(o) == "table"  then return su:table_tos(o)  end
        return tostring(o)
      end,
    --
    fields   = {aa="AAA", bb="BBB"},
    hasfield = function (su, s)    return su.fields[s] end,
    expfield = function (su, s)    return su.fields[s] end,
    expn     = function (su, n)    return format("(expn %d)", n) end,
    expexpr  = function (su, code) return format("(expexpr %s)", code) end,
    expeval  = function (su, code) return format("(expeval %s)", code) end,
    --
    classify = function (su, s)
        if s:match("^[0-9]+$") then return "expn",     s+0      end
        if s:match("^:")       then return "expeval",  s:sub(2) end
        if su:hasfield(s)      then return "expfield", s        end
                                    return "expexpr",  s
      end,
    replace = function (su, str, verbose)
        local f = function (b)
            local s = b:sub(2,-2)
            local method,arg = su:classify(s)
            local out = su:tostring1(su[method](su,arg))
            if verbose then PP(s, method, arg, out) end
            return out
          end
        return (str:gsub("%b<>", f))
      end,
  },
}

-- «Subst-tests»  (to ".Subst-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ToTeX1.lua"
= Subst.replace("_<2+3>_<:return 4+5>_<aa>_")
= Subst.replace("_<2+3>_<:return 4+5>_<aa>_", "verbose")

s = Subst {}
= s
= s:tostring1("a")
= s:tostring1(nil)
= s:tostring1(true)
= s:tostring1(1.23456)
= s:tostring1({20,30})

--]]






--  _____   _____   __  __
-- |_   _|_|_   _|__\ \/ /
--   | |/ _ \| |/ _ \\  / 
--   | | (_) | |  __//  \ 
--   |_|\___/|_|\___/_/\_\
--                        
-- TODO: explain how I used expexpr and expeval to implement expn
--
-- «ToTeX»  (to ".ToTeX")

ToTeX = Class {
  type = "ToTeX",
  from = function (tbl)
      return addoverrides(Subst(shallowcopy(tbl)), ToTeX.__index)
    end,
  __index = {
    witho    = function (tt,o) tt=shallowcopy(tt); tt.o=o; return tt end,
    tostring = function (tt) return tt:tostring1(tt.o) end,
    expexpr  = function (tt,code) return L("tt,o => "..code)(tt, tt.o) end,
    expeval  = function (tt,code)        L("tt,o => "..code)(tt, tt.o) end,
    --
    -- Overrides for table_tos
    tag  = function (tt) return tt.o[0] end,
    fmt  = function (tt) return tt.fmts[tt:tag()] end,
    table_tos = function (tt)
        if not tt:tag() then return "[No tag]" end
        if not tt:fmt() then return "[No fmt: "..tt:tag().."]" end
        return tt:replace(tt:fmt())
      end,
    --
    -- Overrides for expn
    getn0 = function (tt, n) return          tt.o[n]  end,
    getn  = function (tt, n) return tt:witho(tt.o[n]) end,
    expn  = function (tt, n) return tostring(tt:getn(n)) end,
    --
    show00 = function (tt,...) return tostring(a):show00(...) end,
    show0  = function (tt,...) return tostring(a):show0 (...) end,
    show   = function (tt,...) return tostring(a):show  (...) end,
  },
}

-- «ToTeX-tests»  (to ".ToTeX-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ToTeX1.lua"

fmts["+"]   = "<1> + <2>"
fmts["*"]   = "<1> \\cdot <2>"
fmts["L"]   = "\\leaf "
tt0         = ToTeX.from {fmts=fmts}
o3          =            mkast("*", "a", 2.3456)
o5          = mkast("+", mkast("*", "a", 2.3456), 99)
tt3         = tt0:witho(o3)
tt5         = tt0:witho(o5)

= tt3
= tt5
= tt3:fmt()
= tt3:getn(1)
= tt3:getn(2)
= tt3:getn(2).o

= tt3:replace("_<2+3>_")
= tt3:replace("_<2>_")         -- err
= tt3:replace("_<tt.o[1]>_")
= tt3:replace("_<tt.o[2]>_")
= tt3:replace("_<tt:getn(1)>_")
= tt3:replace("_<tostring(tt:getn(1))>_")
= tt3:replace("_<tostring(tt:getn(2))>_")
= tt3:replace("_<tt:getn(2)>_")

= tt3:replace("_<tt:getn(2)>_")

= tt3:replace("_<tostring(tt)>_")
= tt3:replace("_<tostring(tt:getn(1))>_")
= tt3:replace("_<tostring(tt:getn(2))>_")
= tt3:replace("_<rawtostring(tt)>_")
= tt3:replace("_<:2+3>_")
= tt3:replace("_<:2+3+>_")
= tt3:replace("_<:print(2+3)>_")

gm  = function (o) return getmetatable(o)         end
gmi = function (o) return getmetatable(o).__index end

PPV(tt3)
PPV(gm(tt3))
PPV(gmi(tt3))

= type(PrintFunction.tostring(print))

= print
setmetatable(print, PrintFunction.fmetatable())
setmetatable({}, PrintFunction.fmetatable())



= tt3.expeval
= prf(tt3.expeval)
= tt3:expeval("print 'hello'")
  tt3:expeval("print(tt,o)")
  tt3:expeval("print(tt)")
= tt3
= prf(gmi(tt3).__tostring)
= prf(gm (tt3).__tostring)
= prf(    tt3 .  tostring)
= PPV(gmi(tt3))
= PPV(gmi(tt3))

PPV(gm(tt3))

= tt0:replace("foo", "verbose")
= tt0:replace("foo <1>", "verbose")

= tt0:witho(2)
= tt0:witho(o3)
= tt0:witho(o3):getn0(1)
= tt0:witho(o3):getn (1)
= tt0:witho(o3):getn0(2)
= tt0:witho(o3):getn(2)
= tt0:witho(2.3456)
= tt0:witho({[0]="L"})
  tt1 = tt0:witho(o3)
= tt1
= tt1:getn0(1)
= tt1:getn0(2)
= tt1:getn(2)
= tt1:expn(1)
= tt1:expn(2)



= tt0:witho(o3)
tt1         = tt0:witho(o5)

= tt1
= tt1:tostring()
= tt1:replace "foo"
= tt1:tostring()
= tt1.o
= tt1.fmts
= tt1:tag()
= tt1:fmt()

keyss = function (T)
    local ks = sorted(keys(T), rawtostring_comp)
    return mapconcat(mytostring, ks, " ")
  end

= keyss {20, 30, a=40}




funs        = VTable {}
funs["sin"] = VTable {}

= totex  (o)
= totex0 (o)
= totex00(o)
= totex00(o).o
= totex00(o):tag()
= totex00(o):fmt()
= totex00(o):getn(1)
= totex00(o):getn(1).o
= totex00(o):getn(2)
= totex00(o):getn(2).o
= totex00(o):getn(2):fmt()
= totex00(o):getn(2):getn(2)
= totex00(o):getn(2):getn(2).o
= totex00()
= totex00():gsub("a<2+3>b")

--]==]



--  _        _                     
-- | |_ ___ | |_ _____  _____ _ __ 
-- | __/ _ \| __/ _ \ \/ / _ \ '__|
-- | || (_) | ||  __/>  <  __/ |   
--  \__\___/ \__\___/_/\_\___|_|   
--                                 
-- «totexer»  (to ".totexer")
-- A "totexer" is a function that converts ASTs to LaTeX code. The
-- "default totexer" consists of five global variables below.
-- TODO: write examples showing how to build several different totexers
-- and how to make them all available in parallel.
--
fmts    = VTable {}
funs    = VTable {}
totex00 = ToTeX.from {fmts=fmts, funs=funs}
totex0  = function (o) return totex00:witho(o) end
totex   = function (o) return totex0(o):tostring() end

-- Add to:   (find-angg "LUA/ELpeg1.lua" "AST")
-- Based on: (find-angg "LUA/Pict3.lua" "Points2-methods")
--           (find-angg "LUA/Show2.lua" "StringShow")
table.addentries(AST.__index,
  { show00 = function (a,...) return totex(a):show00(...) end,
    show0  = function (a,...) return totex(a):show0 (...) end,
    show   = function (a,...) return totex(a):show  (...) end,
  })

-- «totexer-tests»  (to ".totexer-tests")
--[[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ToTeX1.lua"
fmts["+"]   = "<1> + <2>"
fmts["*"]   = "<1> \\cdot <2>"
o5          = mkast("+", "a", mkast("*", 2.3456, 3.4567))

= otype(totex0(o5))
= otype(totex (o5))
=       totex0(o5)
=       totex0(o5).o
=       totex (o5)

= o5:show00 {em=1}
= o5:show0  {em=1}
= o5:show   {em=1}
 (etv)

--]]






--
-- (defun s1 () (interactive) (find-angg "LUA/Subst1.lua"))
-- (defun s2 () (interactive) (find-angg "LUA/Subst2.lua"))










-- Local Variables:
-- coding:  utf-8-unix
-- End:
