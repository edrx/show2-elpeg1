-- This file:
--   http://anggtwu.net/LUA/CME2.lua.html
--   http://anggtwu.net/LUA/CME2.lua
--          (find-angg "LUA/CME2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- A parser and LaTeXer for expressions like these ones:
--   http://anggtwu.net/mathologer-calculus-easy.html#17:12
--   http://www.youtube.com/watch?v=kuOxDh3egN0#t=17m12s
--   (find-calceasyvideo "17:12" " ")
-- with several weird extensions... for example:
--   "a // b" yields "\frac{a}{b}", and // binds more slowly than +
--   "a m b"  yields "a b" - it's multiplication by concatenation

-- (defun e () (interactive) (find-angg "LUA/CME2.lua"))
-- Supersedes:
--   (find-angg "LUA/ELpeg-cme1.lua")

-- «.fmts»		(to "fmts")
-- «.fmts-tests»	(to "fmts-tests")
-- «.E»			(to "E")
-- «.E-tests»		(to "E-tests")
-- «.matrices»		(to "matrices")
-- «.matrices-tests»	(to "matrices-tests")
-- «.Vlast»		(to "Vlast")
-- «.foldplic»		(to "foldplic")
-- «.foldplic-tests»	(to "foldplic-tests")
-- «.grammar»		(to "grammar")
-- «.grammar-tests»	(to "grammar-tests")


require "ELpeg1"  -- (find-angg "LUA/ELpeg1.lua")
require "ToTeX1"  -- (find-angg "LUA/ToTeX1.lua")
require "MapAST1" -- (find-angg "LUA/MapAST1.lua")


--   __           _       
--  / _|_ __ ___ | |_ ___ 
-- | |_| '_ ` _ \| __/ __|
-- |  _| | | | | | |_\__ \
-- |_| |_| |_| |_|\__|___/
--                        
-- «fmts»  (to ".fmts")
-- Based on: (find-angg "LUA/ELpeg-cme1.lua" "fmts-and-funs")
fmts[ "()"] = "(<1>)"
fmts[".()"] = "\\left(<1>\\right)"
fmts[ "[]"] = "\\bmat{<1>}"
fmts[".[]"] = "\\bsm{<1>}"
fmts[ "{}"] = "{<1>}"
fmts["'"]   = "{<1>}'"
fmts["s"]   = "<1> <2>"
fmts["+"]   = "<1> + <2>"
fmts["-"]   = "<1> - <2>"
fmts["*"]   = "<1> \\cdot <2>"
fmts["/"]   = "<1> / <2>"
fmts["//"]  = "\\frac{<1>}{<2>}"
fmts[ "="]  = "<1> = <2>"
fmts[":="]  = "<1> \\,:=\\, <2>"
fmts[";;"]  = "<1> \\\\{} <2>"
fmts["^"]   = "{<1>}^{<2>}"
fmts["ap"]  = "<1> <2>"
fmts["."]   = "<1> <2>"
fmts["m"]   = "<1> <2>"
fmts["mul"] = "<1> <2>"
fmts["num"] = "<1>"
fmts["var"] = "<1>"
fmts["call"] = "\\<1> "
fmts["fun"]  = "<funs[o[1]] or o[1]>"
funs["ln"]   = "\\ln "
funs["sin"]  = "\\sin "
funs["sqrt"] = "\\sqrt "

-- «fmts-tests»  (to ".fmts-tests")
-- See: (find-angg "LUA/ToTeX1.lua" "totexer-tests")
--[[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "CME2.lua"
o = mkast("ap", mkast("fun", "sin"), mkast("//", "a", "b"))
= o
= o:show00()
= o:show {em=1}
 (etv)

--]]


--  ____            _        _                    
-- |  _ \ _ __ ___ | |_ ___ | |_ _   _ _ __   ___ 
-- | |_) | '__/ _ \| __/ _ \| __| | | | '_ \ / _ \
-- |  __/| | | (_) | || (_) | |_| |_| | |_) |  __/
-- |_|   |_|  \___/ \__\___/ \__|\__, | .__/ \___|
--                               |___/|_|         
--
-- «E»  (to ".E")
-- Uses:     (find-angg "LUA/ELpeg1.lua" "E-tests")
-- Based on: (find-angg "LUA/ELpeg-cme1.lua" "how-it-should-look")
fun   = function (name) return mkast("fun", name) end
var   = function (name) return mkast("var", name) end
num   = function (str)  return mkast("num", str)  end
bin   = function (a, op, b) return mkast(op, a, b) end
unary = function    (op, a) return mkast(op, a)    end
paren = function (a)    return unary("()", a) end
plic  = function (a)    return unary("'", a) end
ap    = function (a, b) return bin(a, "ap", b) end

eq    = function (a, b) return bin(a, "=", b) end
plus  = function (a, b) return bin(a, "+", b) end
minus = function (a, b) return bin(a, "-", b) end
mul   = function (a, b) return bin(a, "mul", b) end
Mul   = function (a, b) return bin(a, "*",   b) end
div   = function (a, b) return bin(a, "/",   b) end
Div   = function (a, b) return bin(a, "//",  b) end
pow   = function (a, b) return bin(a, "^",   b) end

E[    "x"                ] = var"x"
E[ "ln x"                ] = ap(fun"ln", E"x")
E["(ln x)"               ] = paren(E"ln x")
E[       "3"             ] = num("3")
E["(ln x)^3"             ] = pow(E"(ln x)", E"3")
E["(ln x)^3"             ] = pow(E"(ln x)", E"3")
E[           "5"         ] = num("5")
E[                "sin x"] = ap(fun"sin", E"x")
E[            "5 + sin x"] = plus(E"5", E"sin x")
E["(ln x)^3 // 5 + sin x"] = Div(E"(ln x)^3", E"5 + sin x")

E[ "f"                                 ] = fun"f"
E[  "(x)"                              ] = paren(E"x")
E[ "f(x)"                              ] = ap(E"f", E"(x)")
E[     "g"                             ] = fun"g"
E[     "g(x)"                          ] = ap(E"g", E"(x)")
E[ "f(x)g(x)"                          ] = mul(E"f(x)", E"g(x)")
E["(f(x)g(x))"                         ] = paren(E"f(x)g(x)")
E["(f(x)g(x))'"                        ] = plic(E"(f(x)g(x))")
E[              "f'"                   ] = fun"f'"
E[              "f'(x)"                ] = ap(E"f'", E"(x)")
E[              "f'(x)g(x)"            ] = mul(E"f'(x)", E"g(x)")
E[                              "g'"   ] = fun"g'"
E[                              "g'(x)"] = ap(E"g'", E"(x)")
E[                          "f(x)g'(x)"] = mul(E"f(x)", E"g'(x)")
E[              "f'(x)g(x) + f(x)g'(x)"] = plus(E"f'(x)g(x)", E"f(x)g'(x)")
E["(f(x)g(x))' = f'(x)g(x) + f(x)g'(x)"] = eq(E"(f(x)g(x))'", E"f'(x)g(x) + f(x)g'(x)")

-- «E-tests»  (to ".E-tests")
--[[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "CME2.lua"
o = E["(ln x)^3 // 5 + sin x"]
= o
= o:show00()
= o:show {em=1}
 (etv)

--]]



-- «matrices»  (to ".matrices")
usepackages.amsmath = [=[ \usepackage{amsmath} ]=]
defs.matrices = [=[
\def\sm  #1{\begin{smallmatrix}#1\end{smallmatrix}}
\def\mat #1{\begin{matrix}#1\end{matrix}}
\def\psm #1{\left (\sm {#1}\right )}
\def\bsm #1{\left [\sm {#1}\right ]}
\def\pmat#1{\left (\mat{#1}\right )}
\def\bmat#1{\left [\mat{#1}\right ]}
]=]

-- «matrices-tests»  (to ".matrices-tests")
--[==[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "CME2.lua"
= ([=[ foo=\bsm{a & b \\ c & d} ]=]):show0 {em=1}
= ([=[ foo=\bsm{a & b \\ c & d} ]=]):show  {em=1}
 (etv)

--]==]



-- «Vlast»  (to ".Vlast")
-- (find-angg "LUA/ELpeg1.lua" "Gram-Vlast")
Gram.__index.set = function (gr, name, pat)
    Vlast = pat
    gr.entries[name] = pat
  end



-- «foldplic»  (to ".foldplic")
foldplic = function (A)
    local o = A[1]
    for i=2,#A do o = plic(o) end
    return o
  end
assocplic = function (pe, po) return Ct(pe*(_*po)^0) / foldplic end

-- «foldplic-tests»  (to ".foldplic-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "CME2.lua"
o = AST {mkast("+", "a", "b"), "'", "'", "'"}
= o
= foldplic(o)

--]==]


-- «grammar»  (to ".grammar")
gr,V,VA,VE,PE = Gram.new()
_ = S(" ")^0

VA.num   = Cs(P"-"^-1 * R"09"^1)
VA.var   = anyof "x y a b e"
VA.fun   = anyof "f'' f' f g' g ln sin sqrt"
VA.call  = P"!" * (R("AZ", "az")^1):Cs()
VA.ap    = V.fun *_* V.exprbasic

V.exprbasic = Cparen( "(", ")", V.expr)
            + Cparen(".(", ")", V.expr)
            + Cparen( "{", "}", V.expr)
            + Cparen( "[", "]", V.expr)
            + Cparen(".[", "]", V.expr)
            + V.call + V.ap + V.num + V.fun + V.var
V.exprplic  = assocplic(Vlast, Cs"'"  )
V.exprsubst = assocl(Vlast,    Cs"s"  )
V.exprpow   = assocr(Vlast,    Cs"^"  )
V.exprmul   = assocl(Vlast,    anyof("mul m"))
V.exprMul   = assocl(Vlast,    Cs"*"  )
V.exprdiv   = assocl(Vlast,    Cs"/"  )
V.exprplus  = assocl(Vlast,    anyof("+ -"))
V.exprDiv   = assocl(Vlast,    Cs"//" )
V.expreq    = assocl(Vlast,    Cs"="  )
V.exprceq   = assocl(Vlast,    Cs":=" )
V.exprnl    = assocl(Vlast,    Cs";;" )
V.expr      = _* V.exprnl

CME_parser  = gr:compile("expr")
CME_parse   = function (str) return CME_parser:match(str) end
CME         = function (str) return totex(CME_parse(str)) end




-- «grammar-tests»  (to ".grammar-tests")
--[==[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "CME2.lua"

= CME_parse(".(x^2 * f(g(x))) s .[ f(x):=e^{3x} ;; f'(x):=3e^{3x}]")
= CME_parse(".(x^2 * f(g(x))) s .[ f(x):=e^{3 m x} ;; f'(x):=3 m e^{3 m x} ].")
= CME_parse(".(x^2 * f(g(x))) s .[ f(x):=e^{3mx} ;; f'(x):=3me^{3mx} ].")
= CME      (".(x^2 * f(g(x))) s .[ f(x):=e^{3mx} ;; f'(x):=3me^{3mx} ].")
= CME      (".(x^2 * f(g(x))) s .[ f(x):=e^{3mx} ;; f'(x):=3me^{3mx} ].") :show {em=1}
 (etv)

= CME_parse " (f(y)=y^2+y^3) s [y:=200]  = (f(200)=200^2 + 200^3) "
= CME_parse " (f(y)=y^2+y^3) s [y:=a+b]  = (f(a+b)=(a+b)^2 + (a+b)^3) "
= CME_parse " (f(y)=y^2+y^3) s [y:=g(x)] = (f(g(x))=g(x)^2 + g(x)^3) "

ma = MapAST {
  trivs = Set.from(split("() fun var num")),
  heads = { 
    ["ap"] = function(m, o) return m:mkast(m:f(o[1]), m:f(o[2])) end,
  },
}

o = CME_parse " (f(y)=y^2+y^3) s [y:=200]  = (f(200)=200^2 + 200^3) "
o = CME_parse " (f(y)=y^2+y^3) s [y:=a+b]  = (f(a+b)=(a+b)^2 + (a+b)^3) "
o = CME_parse " (f(y)=y^2+y^3) s [y:=g(x)] = (f(g(x))=g(x)^2 + g(x)^3) "
= o
= ma:f(o)

--]==]





-- Local Variables:
-- coding:  utf-8-unix
-- End:
