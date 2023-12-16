-- This file:
--   http://anggtwu.net/LUA/LPex1.lua.html
--   http://anggtwu.net/LUA/LPex1.lua
--          (find-angg "LUA/LPex1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- The classes in this file parse, typeset, and test "lpeg examples".
-- Supersedes:
--   (find-angg "LUA/Capts1.lua")
-- Uses:
--   (find-angg "LUA/Und1.lua")
--
-- «.LPex-grammar»		(to "LPex-grammar")
-- «.LPex-globals»		(to "LPex-globals")
-- «.LPex_bigstr0»		(to "LPex_bigstr0")
-- «.LPex-grammar-tests»	(to "LPex-grammar-tests")
-- «.LPex»			(to "LPex")
-- «.LPex-tests»		(to "LPex-tests")
-- «.LPexes_bigstr1»		(to "LPexes_bigstr1")
-- «.LPexes»			(to "LPexes")
-- «.LPexes-tests»		(to "LPexes-tests")

require "Co1"        -- (find-angg "LUA/Co1.lua")
require "ELpeg1"     -- (find-angg "LUA/ELpeg1.lua")
require "Und1"       -- (find-angg "LUA/Und1.lua")

-- (find-angg "LUA/Capts1.lua" "lpexes_parse")



-- «LPex-grammar»  (to ".LPex-grammar")
--    gr,V,VA = Gram.new()
local gr,V,VA = Gram.new()
V.nl          = P"\n"
V.restofline  = (1-P"\n")^0
V.colonline   = (S" "^0 * (R"az"^0):C() * ":" * P" "^-1 * V.restofline:C() * V.nl):Ct()
V.nameline    = V.colonline:Cobeying(function (o) return o[1] >  "" end)
V.contline    = V.colonline:Cobeying(function (o) return o[1] == "" end)
V.otherline   = (-V.colonline) * V.restofline * V.nl
V.named0      = V.nameline * V.contline^0
V.named       = V.named0:Ct() / function (A)
                    local f = function (i) return A[i][2] end
                    return {A[1][1], mapconcat(f, seq(1,#A), "\n")}
                  end
V.block0      = V.otherline^0 * V.named^1
V.block       = V.block0:Ct() / function (B)
                   local C = VTable {}
                   for _,A in ipairs(B) do C[A[1]] = A[2] end
                   return C
                 end
V.blocks      = (V.block^1):Ct()

-- «LPex-globals»  (to ".LPex-globals")
LPex_pat      = gr:compile("blocks")
LPex_parse    = function (bigstr) return LPex_pat:match(bigstr.."\n") end
LPex_tostring = function (B)
    local f = function (s) return (s:gsub("\n", "\n      ")) end
    local g = function (k) return format("%s: %s", k, f(B[k])) end
    return mapconcat(g, sorted(keys(B)), "\n")
  end

-- «LPex_bigstr0»  (to ".LPex_bigstr0")
-- For basic tests. Similar to: (to "LPexes_bigstr1")
--
LPex_bigstr0 = [=[
  name: test 1
  subj: ""
  code: (Cc"a" * Cc("c","d"))
  diag: {{<.>_<"a"> <.....>_<"c" "d">_<b={."c" "d".}>
      :             <.....>_<"e" "f">_<b={."e" "f".}>

  name: test 2
  subj: ""
  code: (Cc"a" * Cc("c","d")) * foo
  diag: {{<.>_<"a"> <.....>_<"c" "d">_<b={."c" "d".}> }}
]=]

-- «LPex-grammar-tests»  (to ".LPex-grammar-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "LPex1.lua"
D = LPex_parse(LPex_bigstr0)
PP(D)
= LPex_tostring(D[1])
= LPex_tostring(D[2])

--]==]



--  _     ____           
-- | |   |  _ \ _____  __
-- | |   | |_) / _ \ \/ /
-- | |___|  __/  __/>  < 
-- |_____|_|   \___/_/\_\
--                       
-- «LPex»  (to ".LPex")

LPex = Class {
  type = "LPex",
  from = function (tbl) return LPex(tbl) end,
  __tostring = function (lpex) return LPex_tostring(lpex) end,
  __index = {
    example = function (lpex)
        return mkast("example", mkast("co", lpex.code), Und_parse(lpex.diag))
      end,
    show  = function (lpex, opts) return lpex:example():show(opts) end,
    pat   = function (lpex) return expr(lpex.code) end,
    test  = function (lpex) PP(lpex:pat():match(expr(lpex.subj))) end,
    short = function (lpex) return format("%s  ::  %s", lpex.name, lpex.code) end,
    sa    = function (lpex)
        local name,texcode = lpex.name, totex(lpex:example())
        local fmt = "\\sa{%s}{%s}"
        return format(fmt, name, texcode)
      end,
  },
}

-- «LPex-tests»  (to ".LPex-tests")
--[==[
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "LPex1.lua"
D = LPex_parse(LPex_bigstr1)
= D[3]
o = LPex.from(D[2])
= o
= o:example()

= Und_cot("bla")
= o.code
foo = Cc"foo"
= o:test()
= o:short()
= o:sa()
= o:show {em=1}
 (etv)

--]==]



-- «LPexes_bigstr1»  (to ".LPexes_bigstr1")
-- Used by: (find-LATEX "2023lpegcaptures.tex" "defs-lpex1")
-- Similar to: (to "LPex_bigstr0")
--
-- These are the diagrams that I drew when I was learning some quirky
-- parts of lpeg. They are used by a test block below and by this LaTeX
-- file,
--     http://anggtwu.net/LATEX/2023lpegcaptures.pdf
--     http://anggtwu.net/LATEX/2023lpegcaptures.tex.html
--                 (find-LATEX "2023lpegcaptures.tex")
-- that I used in a presentation to two friends in aug2023 to check if
-- they could understand my ideas (spoiler: they could).
--
LPexes_bigstr1 = [=[

  name: P_1
  subj: "abc"
  code: P"a" * P"b" * P"c"
  diag: {<a>_<> <b>_<> <c>_<>}_<>

  name: C_1
  subj: "abcd"
  code: (P(1) * P"b" * C(1) * C"d"):C()
  diag: {<a>_<> <b>_<> <c>_<"c"> <c>_<"d">}_<"abcd" "c" "d">

  name: Cs_1
  subj: "abc"
  code: (P"a" * (P"b" / "bb") * P"c"):Cs()
  diag: {<a>_<> <b>_<"bb"> <c>_<>}_<"abbc">

  name: Cc_1
  subj: "cd"
  code: Cc("a","b") * P"cd" * Cc("e","f")
  diag: {<...>_<"a" "b"> <cd>_<> <...>_<"e" "f">}_<"a" "b" "e" "f">

  name: Cg_1
  subj: ""
  code: Cc"a" * Cc("b","c"):Cg"d" * Cc"e"
  diag: {<.>_<"a"> <.....>_<"b" "c">_<d={."b" "c".}> <.>_<"e">}
      :   _<"a" d={."b" "c".} "e">
      :   _<"a" "e">

  name: Cg_2
  subj: ""
  code: (Cc"a" * Cc("b","c"):Cg"d" * Cc"e"):Ct()
  diag: {<.>_<"a"> <.....>_<"b" "c">_<d={."b" "c".}> <.>_<"e">}
      :   _<{"a", d={"b", "c"}, "e"}>

  name: Cg_3
  subj: ""
  code: (Cc"a" * Cc("b","c"):Cg"d" * Cc"e" * Cc("f", "g"):Cg"d"):Ct()
  diag: {<.>_<"a"> <.....>_<"b" "c">_<d={."b" "c".}>
      :    <.>_<"e"> <.....>_<"f" "g">_<d={."f" "g".}>}
      :   _<"a" d={."b" "c".} "e" d={."f" "g".}>
      :   _<{"a", d={"b", "c"}, "e", d={"f"}}>
      :   _<{"a", "e", d={"f"}}>

  name: Cg_4
  subj: ""
  code: Cc"a" * Cc("b","c"):Cg"d" * Cc"e" * Cc("f", "g"):Cg"d"
  diag: {<.>_<"a"> <.....>_<"b" "c">_<d={."b" "c".}>
      :    <.>_<"e"> <.....>_<"f" "g">_<d={."f" "g".}>}
      :   _<"a" d={."b" "c".} "e" d={."f" "g".}>
      :   _<"a" "e">

  name: Cb_1
  subj: ""
  code: (Cc"a" * Cc("c","d"):Cg"b" * Cc("e", "f"):Cg"b" * Cc"g" * Cb"b"):Ct()
  diag: {{<.>_<"a"> <.....>_<"c" "d">_<b={."c" "d".}>
      :               <.....>_<"e" "f">_<b={."e" "f".}>
      :     <.>_<"g">}
      :     _<"a" b={."c" "d".} b={."e" "f".} "g">
      :     _<"a" b={."e" "f".} "g">
      :    <.>_<["b"]>}
      :   _<"a" b={."e" "f".} "g" "e" "f">
      :   _<{"a", b={"e", "f"}, "g", "e", "f"}>

  name: Cb_2
  subj: ""
  code: (Cc"a":Cg"b" * Cc"c":Cg"d" * Cc"e":Cg"f") * Cb"b"
  diag: {{<..>_<"a">_<b="a">
      :   <..>_<"c">_<d="c">
      :   <..>_<"e">_<f="e">}_<b="a" d="c" f="e">
      :  <..>_<["b"]>
      : }_<b="a" d="c" f="e" ["b"]>
      :  _<b="a" d="c" f="e" "a">

  name: Cb_3
  subj: ""
  code: Cc"a":Cg"b" * (Cc"c":Cg"d" * Cc"e":Cg"f" * Cb"b")
  diag: {<..>_<"a">_<b="a">
      :  {<..>_<"c">_<d="c">
      :   <..>_<"e">_<f="e">
      :   <..>_<["b"]>}_<d="c" f="e" ["b"]>}
      : _<b="a" d="c" f="e" ["b"]>
      : _<b="a" d="c" f="e" "a">

  name: Cb_4
  subj: ""
  code: (Cc"a" * (Cc("b", "c") * Cc"d":Cg"e"):Cg"f" * Cb"f"):Ct()
  diag: {{<..>_<"a"> <....>_<"b" "c"> <..>_<"d">_<e="d">}
      :  _<"a" "b" "c" e="d">
      :  _<"a" "b" "c">
      :  _<f={."a" "b" "c".}>
      :  <..>_<["f"]>
      : }_<f={."a" "b" "c".} ["f"]>
      :  _<f={."a" "b" "c".} "a" "b" "c">
      :  _<{f={"a"}, "a", "b", "c"}>

]=]



--  _     ____                    
-- | |   |  _ \ _____  _____  ___ 
-- | |   | |_) / _ \ \/ / _ \/ __|
-- | |___|  __/  __/>  <  __/\__ \
-- |_____|_|   \___/_/\_\___||___/
--                                
-- «LPexes»  (to ".LPexes")

LPexes = Class {
  type = "LPexes",
  from = function (bigstr) return LPexes({}):add(bigstr) end,
  __tostring = function (lps)
      local f = function (lp) return lp:short() end
      return mapconcat(f, lps, "\n")
    end,
  __index = {
    add = function (lps,bigstr)
        for _,lp0 in ipairs(LPex_parse(bigstr)) do
          local lp = LPex.from(lp0)
          table.insert(lps, lp)
          lps[lp.name] = lp
        end
        return lps
      end,
    sas = function (lps)
        local f = function (lp) return lp:sa() end
        return mapconcat(f, lps, "\n\n")
      end,
    names0 = function (lps,fmt,sep,medstr)
        local f = function (lp) return format(fmt,lp.name) end
        local A = medstr and split(medstr) or lps
        return mapconcat(f, A, sep)
      end,
    names = function (lps) return lps:names0("%s", " ") end,
    gas   = function (lps,sep,medstr)
        return lps:names0("\\ga{%s}", sep or "\n", medstr)
      end,
  },
}

-- «LPexes-tests»  (to ".LPexes-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "LPex1.lua"
lps = LPexes.from(LPexes_bigstr1)
= lps
= lps[1]
= lps[2]
= lps["C_1"]
= lps:sas()
= lps:names()
= lps:gas()
= lps:gas(" \\\\\n")

-- (find-es "lpeg" "lpeg-unnamed")
fparen = function (...) return "("..table.concat({...}, ",")..")" end

lps:add [=[

  name: Cf_1
  subj: "abcdef"
  code: ((C(1)*C(1)):Cg() * (C(1)*C(1)):Cg() * (C(1)*C(1)):Cg()):Cf(fparen)
  diag: {{<a.>_<"a"> <b.>_<"b">}_<{."a" "b".}>
      :  {<c.>_<"c"> <d.>_<"d">}_<{."c" "d".}>
      :  {<e.>_<"e"> <f.>_<"f">}_<{."e" "f".}>}
      : _<"((a,c,d),e,f)">

]=]

= lps["Cf_1"]
= lps["Cf_1"]:test()
= lps["Cf_1"]:show {em=1}
 (etv)

--]==]




-- (defun e () (interactive) (find-angg "LUA/LPex1.lua"))



-- Local Variables:
-- coding:  utf-8-unix
-- End:
