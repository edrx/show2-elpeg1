-- This file:
--   http://anggtwu.net/LUA/Und1.lua.html
--   http://anggtwu.net/LUA/Und1.lua
--          (find-angg "LUA/Und1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This file implements the Und "class", that parses and latexes
-- expressions with a syntax like this,
--
--   {<a>_<> <b>_<> <c>_<>}_<"abc">
--
-- in which things like <"abc"> are set in typewriter font and each
-- `_' indicates an underbrace.
--
-- (defun e () (interactive) (find-angg "LUA/Und1.lua"))
-- Supersedes:
--   (find-angg "LUA/Capts1.lua")
--   (find-angg "LUA/Capts1.lua" "uparse")
--   (find-angg "LUA/Underbrace1.lua")
-- Used by:
--   (find-angg "LUA/LPex1.lua")
--
-- «.Und-grammar»	(to "Und-grammar")
-- «.Und-globals»	(to "Und-globals")
-- «.Und-fmts»		(to "Und-fmts")
-- «.Und-tests»		(to "Und-tests")

require "Co1"        -- (find-angg "LUA/Co1.lua")
require "ELpeg1"     -- (find-angg "LUA/ELpeg1.lua")
require "ToTeX1"     -- (find-angg "LUA/ToTeX1.lua")


-- «Und-grammar»  (to ".Und-grammar")
--    gr,V,VA,VE,PE = Gram.new()
local gr,V,VA,VE,PE = Gram.new()
V.S        = (S" \t\n")^0
 _         = V.S
V.co1      = R" ~" - S"<>"
V.other1   = R" ~" - S"<>{}_"
V.other1   = P(1)  - S"<>{}_"
V.und1     = V.co + V.curly
V.longitem = V.unds + V.other
VA.co      = P"<" * (V.co1^0):C() * P">"
VA.curly   = P"{" * V.longitem^0  * P"}"
VA.other   = (V.other1^1):Cs()
V.unds     = assocl((V.co + V.curly), P"_"/"und")

-- «Und-globals»  (to ".Und-globals")
Und_gr     = gr
Und_pat    = gr:compile("longitem")
Und_parse  = function (str) return Und_pat:match(str) end
Und_tex    = function (str) return totex(Und_parse(str)) end
Und_co0    = Co.new(" %_{}", "\\^")
Und_cot    = Und_co0:translator()
Und_dotsp  = function (str, verbose)
    local a,b,c = str:match("^(%.*)(.-)(%.*)$")
    local d = (" "):rep(#(a..c))
    if verbose then PP(a,b,c,d) end
    return d..b..d
  end
Und_tex_arrayl = function (body)
    return format("\\begin{array}{l} %s\n\\end{array}", body)
  end
Und_tex_example0 = function (a,b)
    return Und_tex_arrayl(format("%s \\\\\n \\Rightarrow \\;\\; %s", a, b))
  end
-- example    = function (bigstr)
--     local a0,b0 = bigstr:match("^%s*([^\n]*)\n(.*)")
--     local a,b = bitrim(a0), bitrim(b0)
--     return mkast("example", co(a), uparse(b))
--   end


-- «Und-fmts»  (to ".Und-fmts")
fmts            = fmts or VTable {}
fmts["co"]      = "\\texttt{<Und_cot(Und_dotsp(o[1]))>}"
fmts["und"]     = "\\und{<1>}{<2>}"
fmts["curly"]   = "{<1>}"
fmts["curly"]   = "{<mapconcat(totex, o)>}"
fmts["other"]   = "<1>"
fmts["example"] = [[ \begin{array}{l}
                     <1> \\
                     \Rightarrow \;\; <2> \\
                     \end{array}
                  ]]
fmts["example"] = "<Und_tex_example0(totex(o[1]), totex(o[2]))>"

defs.und = [[ \def\und#1#2{\underbrace{#1}_{#2}} ]]

-- «Und-tests»  (to ".Und-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Und1.lua"
= Und_gr:cm("co",    "<foo>")
= Und_gr:cm("other", "abc")
= Und_gr:cm("unds",  "<a>_<b>_<c>")
= Und_gr:cm("unds",  "<aa>_<b>_{c}")
= Und_gr:cm("unds",  "<aa>_<b>_{<c>}")
= Und_gr:cm("unds",  "<aa>_<b>_{<c>_<d>}")
= Und_gr:cm("unds",  "<aa>_<b>_{<c>_<d>_<e>}")
= Und_gr:cm("unds",  "<aa>_<b>_{<c>_<d>_<e>fg}")

= Und_parse  '<abcde>_<"b" "d">_<"db">'
= Und_tex    '<abcde>_<"b" "d">_<"db">'
= Und_parse  '<abcde>_<"b" "d">_<"db">' :show {scale=4, em=1}
= Und_parse '<.abcde>_<"b" "d">_<"db">' :show {scale=4, em=1}
 (etv)
= Show.log

= Und_parse '<abcde>_<"b" "d">_{db}'             :show {scale=4, em=1}
= Und_parse '{<a><b>_<>  <c>}'                   :show {scale=4, em=1}
= Und_parse '{<a>_<><b>_<>  <c>_<>}_<"abc">'     :show {scale=4, em=1}
= Und_parse '{<a><b>_<>  <c>}_<"abc">'           :show {scale=4, em=1}
= Und_parse '{<a><b>_<""><c>}'                   :show {scale=4, em=1}
= Und_parse '{<a><b>_<""><c>}_<ac>'              :show {scale=4, em=1}
= Und_parse '{{<a><b>   _<"bb"><c>}}_<"abbc">'   :show {scale=4, em=1}
= Und_parse [[{{<a><b>   _<"bb"><c>}}_<"abbc">]] :show {scale=4, em=1}
= Und_parse [[{<P"a" * P"b":Cc("bb") * P"c"> :: 
    {<a><b>   _<"bb"><c>}_<"abbc">
    }]] :show {em=1}
 (etv)

o = mkast("example", "foo", "bar")
= o
= o:show()
 (etv)

= uparse '{ <a><b...>_<"bb" "BB"><c>}' :show {scale=4, em=1}
= uparse '{{<a><b...>_<"bb" "BB"><c>}}_<"abbBBc">' :show {scale=4, em=1}
 (etv)

= Show.log
= Show.bigstr
 (etv)

o = uparse "<foo>_<bar>_<plic>"
o = uparse '<abcde>_<"b" "d">_<"db">'
= o
= o:show {scale=4, em=1}
 (etv)


--]==]


-- Local Variables:
-- coding:  utf-8-unix
-- End:
