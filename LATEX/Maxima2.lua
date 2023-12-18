-- This file:
--   http://anggtwu.net/LUA/Maxima2.lua.html
--   http://anggtwu.net/LUA/Maxima2.lua
--          (find-angg "LUA/Maxima2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- Long story short: I found emaxima.sty too limited and too hard to
-- modify, and I wrote this Lpeg-based tool to convert the output of
-- Maxima with "display2d:'emaxima" to LaTeX code.
--
-- The "too limited" above means: emaxima.sty changes catcodes
-- temporarily, and because of that it was super hard to use
-- emaxima.sty to put Maxima code in "\vbox"es.
--
-- See: (find-es "maxima" "Maxima2.lua")

-- (defun o () (interactive) (find-angg "LUA/Maxima1.lua"))
-- (defun e () (interactive) (find-angg "LUA/Maxima2.lua"))

-- «.MaximaLine»		(to "MaximaLine")
-- «.MaximaLine-tests»		(to "MaximaLine-tests")
-- «.MaximaIO»			(to "MaximaIO")
-- «.MaximaIO-tests»		(to "MaximaIO-tests")
-- «.MaximaIOs»			(to "MaximaIOs")
-- «.MaximaIOs-tests»		(to "MaximaIOs-tests")
-- «.grammar»			(to "grammar")
-- «.grammar-tests»		(to "grammar-tests")
-- «.MaximaHead»		(to "MaximaHead")
-- «.MaximaHead-tests»		(to "MaximaHead-tests")
-- «.head»			(to "head")
-- «.show2»			(to "show2")
-- «.show2-tests»		(to "show2-tests")
-- «.show2-tests-head»		(to "show2-tests-head")
-- «.show2-tests-prep»		(to "show2-tests-prep")

require "ELpeg1"          -- (find-angg "LUA/ELpeg1.lua")
require "Show2"           -- (find-angg "LUA/Show2.lua")
require "Co1"             -- (find-angg "LUA/Co1.lua")
require "DeleteComments2" -- (find-angg "LUA/DeleteComments2.lua")

deletecomments = deletecomments_2023



--  __  __            _                 _     _            
-- |  \/  | __ ___  _(_)_ __ ___   __ _| |   (_)_ __   ___ 
-- | |\/| |/ _` \ \/ / | '_ ` _ \ / _` | |   | | '_ \ / _ \
-- | |  | | (_| |>  <| | | | | | | (_| | |___| | | | |  __/
-- |_|  |_|\__,_/_/\_\_|_| |_| |_|\__,_|_____|_|_| |_|\___|
--                                                         
-- «MaximaLine»  (to ".MaximaLine")
-- See: (find-LATEX "edrx21.sty" "maximablue-red")

MaximaLine = Class {
  type = "MaximaLine",
  ify  = function (tbl) return MaximaLine(tbl) end,
  __tostring = function (ml) return mytostring(ml) end,
  __index = {
    co = Co.new(" \\%{}$_", "^"),
    cot   = function (ml, str) return ml.co:translate(str) end,
    blue0 = function (ml, a)   return format("\\maximablue{%s}", a) end,
    red0  = function (ml, a,b) return format("\\maximared{%s}{%s}", a,b) end,
    type1tex = function (ml) return ml:blue0(ml:cot(ml.c .. ml.d)) end,
    type2tex = function (ml, c)
        local spaces = c:gsub(".", " ")
        return ml:blue0(ml:cot(spaces .. ml.d))
      end,
    type3tex = function (ml)
        --local fmt = "$\displaystyle %s$"
        local fmt = "%s"
        return ml:red0(ml:cot(ml.c), ""),
               ml:red0("", format(fmt, ml.d)),
               ml:red0("", "")
      end,
  },
}

-- «MaximaLine-tests»  (to ".MaximaLine-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Maxima2.lua"
ml1 = MaximaLine.ify {a="i", b="42", c="(%i42) ", d="2+"}
ml2 = MaximaLine.ify {                            d="3;"}
ml3 = MaximaLine.ify {a="o", b="42", c="(%o42) ", d="5"}
= ml1
= ml2
= ml3
= ml1:type1tex()
= ml2:type2tex("(%i42) ")
= ml3:type3tex()

--]]



--  __  __            _                 ___ ___  
-- |  \/  | __ ___  _(_)_ __ ___   __ _|_ _/ _ \ 
-- | |\/| |/ _` \ \/ / | '_ ` _ \ / _` || | | | |
-- | |  | | (_| |>  <| | | | | | | (_| || | |_| |
-- |_|  |_|\__,_/_/\_\_|_| |_| |_|\__,_|___\___/ 
--                                               
-- In the first version of this program an object of the class
-- MaximaIO (a "mio") was always a list made of an "(%i<n>)" line and
-- an "(%o<n>)" line associated to it. A mio could represent something
-- like this:
--
--   (%i42) 2+3;
--   (%o42)   5
--
-- Then I realized the in my logs of Maxima sessions I could have mios
-- like this one:
--
--   (%i1) a+
--         b+
--         42; c+d; e+f;
--   (%o1) b + a + 42
--   (%o2) d + c
--   (%o3) f + e
--
-- each "(%i<n>)" line can be followed by some continuation lines, and
-- this can be followed by zero or more "(%o<n>)" lines. See the test
-- block for the details.
--
-- «MaximaIO»  (to ".MaximaIO")

MaximaIO = Class {
  type = "MaximaIO",
  ify  = function (tbl) return MaximaIO(tbl) end,
  __tostring = function (mio) return mio:totyped() end,
  __index = {
    tovtable = function (mio)
        local vt = VTable {mio[1]}
        for _,ml in ipairs(mio[2]) do table.insert(vt, ml) end
        for _,ml in ipairs(mio[3]) do table.insert(vt, ml) end
        return vt
      end,
    totyped = function (mio)
        local prefix = (mio[1].c):gsub(".", " ")
        local vt = VTable {}
        local add = function (str) table.insert(vt, str) end
        local addtype1 = function (ml) add("type 1: "..ml.c  ..ml.d) end
        local addtype2 = function (ml) add("type 2: "..prefix..ml.d) end
        local addtype3 = function (ml) add("type 3: "..ml.c  ..ml.d) end
        addtype1(mio[1])
        for _,ml in ipairs(mio[2]) do addtype2(ml) end
        for _,ml in ipairs(mio[3]) do addtype3(ml) end
        return table.concat(vt, "\n")
      end,
    toboxes = function (mio)
        local prefix = (mio[1].c):gsub(".", " ")
        local vt = VTable {}
        local add = function (str) table.insert(vt, str) end
        local adds = function (...) for _,o in ipairs({...}) do add(o) end end
        local addtype1 = function (ml) add(ml:type1tex()) end
        local addtype2 = function (ml) add(ml:type2tex(prefix)) end
        local addtype3 = function (ml) adds(ml:type3tex()) end
        addtype1(mio[1])
        for _,ml in ipairs(mio[2]) do addtype2(ml) end
        for _,ml in ipairs(mio[3]) do addtype3(ml) end
        return vt
      end,
    toboxesconcat = function (mio, sep)
        return table.concat(mio:toboxes(), sep or "\n")
      end,
    a  = function (mio)     return mio:totyped() end,
    b  = function (mio,sep) return mio:toboxesconcat(sep) end,
    ab = function (mio,sep) return mio:a().."\n"..mio:b(sep) end,
  },
}

-- «MaximaIO-tests»  (to ".MaximaIO-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Maxima2.lua"
mio = MaximaIO.ify {"a", {"b", "c"}, {"d", "e"}} 
= mio:tovtable()

mio = MaximaIO.ify {
    MaximaLine_parse "(%i1) a+",          -- type 1: (%i<n>)
  { MaximaLine_parse "b+",                -- type 2: continuation
    MaximaLine_parse "42; c+d; e+f;",     -- type 2: continuation
  },
  { MaximaLine_parse "(%o1) b + a + 42",  -- type 3: (%o<n>)
    MaximaLine_parse "(%o2) d + c",       -- type 3: (%o<n>)
    MaximaLine_parse "(%o3) f + e",       -- type 3: (%o<n>)
  }
}
= mio:tovtable()
= mio:totyped()
= mio:toboxes()
= mio:toboxesconcat()
= mio:toboxesconcat(" \\\\\n")
= mio:a ()
= mio: b()
= mio: b(" \\\\\n")
= mio:ab()
= mio:ab(" \\\\\n")

bigstr = [[
(%i1) a+
b+
42; c+d; e+f;
(%o1) b + a + 42
(%o2) d + c
(%o3) f + e
(%i4)
]]
mios = MaximaIOs_parse(bigstr)
= mios[1]
= mios[2]
= otype(mios[1])


 (eepitch-maxima)
 (eepitch-kill)
 (eepitch-maxima)
a+
b+
42; c+d; e+f;

--]==]



--  __  __            _                 ___ ___      
-- |  \/  | __ ___  _(_)_ __ ___   __ _|_ _/ _ \ ___ 
-- | |\/| |/ _` \ \/ / | '_ ` _ \ / _` || | | | / __|
-- | |  | | (_| |>  <| | | | | | | (_| || | |_| \__ \
-- |_|  |_|\__,_/_/\_\_|_| |_| |_|\__,_|___\___/|___/
--
-- An object of the class MaximaIOs (a "mios") is essentially just a
-- list of objects of the class MaximaIO (a list of "mio"s).
--                                                   
-- «MaximaIOs»  (to ".MaximaIOs")

MaximaIOs = Class {
  type    = "MaximaIOs",
  __tostring = function (mios) return mios:ias() end,
  __index = {
    a   = function (mios,i)     return mios[i]:a() end,
    b   = function (mios,i,sep) return mios[i]:b(sep) end,
    ab  = function (mios,i,sep) return mios[i]:a().."\n"..mios[i]:b(sep) end,
    ias = function (mios)
        local f = function (i) return i..":\n"..mios:a(i) end
        return mapconcat(f, seq(1, #mios), "\n")
      end,
    iabs = function (mios,sep)
        local f = function (i) return i..":\n"..mios:ab(i,sep) end
        return mapconcat(f, seq(1, #mios), "\n")
      end,
    bs = function (mios, sep)
        local f = function (i) return mios:b(i,sep) end
        return mapconcat(f, seq(1, #mios), sep or "\n")
      end,
    debug = function (mios,sep) return mios:iabs(sep) end,
    totex = function (mios,sep) return mios:bs(sep) end,
    show = function (mios, opts)
        opts = opts or {}
        scale = opts.scale or 1
        texbody = "\\vbox{\n"..mios:totex().."}"
        return Show.try(tostring(outertexbody))
      end,
    --
    show00 = function (mios,...)
        local texbody0 = "\\vbox{\n"..mios:totex().."}"
        return texbody0:show00(...)
      end,
    show0  = function (mios,...) return mios:show00(...):show0(...) end,
    show   = function (mios,...) return mios:show00(...):show (...) end,
  },
}

-- «MaximaIOs-tests»  (to ".MaximaIOs-tests")
--[==[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Maxima2.lua"

bigstr = [[
(%i1) a+
b+
42; c+d; e+f;
(%o1) b + a + 42
(%o2) d + c
(%o2) f + e
(%i3)
]]
mios = MaximaIOs_parse(bigstr)
= mios
= mios[1]
= mios[2]
= mios:debug()
= mios:debug(" \\\\\n")
= mios:totex()
= mios:totex(" \\\\\n")

= mios:show00({scale=0.8})
= mios:show0 ({scale=0.8})
= mios:show  ({scale=0.8})
= Show.log
= Show.bigstr
 (etv)

--]==]



--   __ _ _ __ __ _ _ __ ___  _ __ ___   __ _ _ __ 
--  / _` | '__/ _` | '_ ` _ \| '_ ` _ \ / _` | '__|
-- | (_| | | | (_| | | | | | | | | | | | (_| | |   
--  \__, |_|  \__,_|_| |_| |_|_| |_| |_|\__,_|_|   
--  |___/                                          
--
-- «grammar»  (to ".grammar")
-- See: (find-es "lpeg" "lpeg.Cfromthere")
--      (find-es "lpeg" "lpeg.Cobeying")
--    gr,V,VAST,VEXPECT,PEXPECT = Gram.new()
local gr,V,VAST,VEXPECT,PEXPECT = Gram.new()

V.a      = S"io":Cg"a"
V.b      = (R"09"^1):Cg"b"
V.c0     = Cp():Cg"c"                -- store the initial position in "c"
V.c1     = Cb"c":Cfromthere():Cg"c"  -- replace "c" by its :Cfromthere()
V.abc    = V.c0 * P"(%" * V.a * V.b * P")" * P" "^-1 * V.c1
V.d      = ((1-S"\n")^0):C():Cg"d"
V.abcd   = V.abc^-1 * V.d
V.abct   = V.abc:Ct()
V.abcdt  = V.abcd:Ct()
V.mline  = V.abcd:Ct() / MaximaLine.ify
V.mline1 = V.mline:Cobeying(function (ml) return ml.a == "i" end)
V.mline2 = V.mline:Cobeying(function (ml) return ml.a == nil end)
V.mline3 = V.mline:Cobeying(function (ml) return ml.a == "o" end)
V.mio    = (V.mline1 *
            ((P"\n" * V.mline2)^0):Ct() *
            ((P"\n" * V.mline3)^0):Ct()
           ):Ct() / MaximaIO.ify
V.mios   = (V.mio * (P"\n" * V.mio)^0) :Ct()

Maxima_gr        = gr
MaximaLine_pat   = gr:compile("mline")
MaximaLine_parse = function (str) return MaximaLine_pat:match(str) end
MaximaIOs_pat    = gr:compile("mios")
MaximaIOs_parse  = function (str)
    local mios = MaximaIOs_pat:match(str)
    if type(mios) ~= "table" then
      print("MaximaIOs_pat:match failed! Input:")
      print(str)
    end
    return MaximaIOs(mios)
  end

-- «grammar-tests»  (to ".grammar-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Maxima2.lua"
=  Maxima_gr:cm ("abc",    "(%i42)")
=  Maxima_gr:cm ("abct",   "(%i42)")
=  Maxima_gr:cm ("abcd",   "(%i42)")
=  Maxima_gr:cmp("abcd",   "(%i42)")
PP(Maxima_gr:cm0("abct",   "(%i42) foo"))
PP(Maxima_gr:cm0("abcdt",  "(%i42) foo"))
   Maxima_gr:cmp("abcdt",  "(%i42) foo")
PP(Maxima_gr:cm0("abcdt",  "blarpy foo"))
=  Maxima_gr:cm0("mline",  "(%i3) foo")
=  Maxima_gr:cm0("mline",  "(%o42) foo")
=  Maxima_gr:cm0("mline",  "blarpy foo")
=  Maxima_gr:cm0("mline1", "(%i3) foo")
=  Maxima_gr:cm0("mline1", "(%o42) foo")
=  Maxima_gr:cm0("mline1", "blarpy foo")
=  Maxima_gr:cm0("mline2", "(%i3) foo")
=  Maxima_gr:cm0("mline2", "(%o42) foo")
=  Maxima_gr:cm0("mline2", "blarpy foo")

bigstr = [[
(%i1) a+
b+
42; c+d; e+f;
(%o1) b + a + 42
(%o2) d + c
(%o3) f + e
(%i4)
]]

 (eepitch-maxima)
 (eepitch-kill)
 (eepitch-maxima)
a+
b+
42; c+d; e+f;

--]==]



--  __  __            _                 _   _                _ 
-- |  \/  | __ ___  _(_)_ __ ___   __ _| | | | ___  __ _  __| |
-- | |\/| |/ _` \ \/ / | '_ ` _ \ / _` | |_| |/ _ \/ _` |/ _` |
-- | |  | | (_| |>  <| | | | | | | (_| |  _  |  __/ (_| | (_| |
-- |_|  |_|\__,_/_/\_\_|_| |_| |_|\__,_|_| |_|\___|\__,_|\__,_|
--                                                             
-- The code below tells Dednat6 how to handle blocks of comments
-- in which each line starts with "%M".
--
-- «MaximaHead»  (to ".MaximaHead")

MaximaHead = Class {
  type    = "MaximaHead",
  __index = {
    set_maxima_lines = function (mh, origlines, delchars)
        local mtrim = function (li)
            if not delchars then return (li:gsub("^%%M ?", "")) end
            return li:sub(delchars+1)
          end
        if type(origlines) == "string" then origlines = splitlines(origlines) end
        maxima_lines00  = VTable(copy(origlines))
        maxima_lines0   = VTable(map(mtrim, maxima_lines00))
        maxima_lines    = bitrim(table.concat(maxima_lines0,   "\n"))
        return maxima_lines
      end,
    mios  = function (mh)      return MaximaIOs_parse(maxima_lines) end,
    sa000 = function (mh, sep) return maximahead:mios():totex(sep) end,
    sa00  = function (mh, sep) return "\\vbox{"..mh:sa000(sep).."}" end,
    sa0   = function (mh, name, sep)
        return format("\\sa{%s}{%%\n%s%%\n}", name, mh:sa00(sep))
      end,
    sa   = function (mh, name, sep) output(mh:sa0(name, sep)) end,
    --
    M0  = function (mh)
        local addM = function (li) return "%M "..li end
        return VTable(map(addM, maxima_lines0))
      end,
    M1  = function (mh) return bitrim(table.concat(mh:M0(), "\n")) end,
    M2  = function (mh,name) return '%L maximahead:sa("'..name..'", "")' end,
    M12 = function (mh,name) return mh:M1().."\n"..mh:M2(name).."\n\\pu" end,
    M3  = function (mh,name) return "\\ga{"..name.."}" end,
    show00 = function (mh,...) return mh:M12("foo").."\n\n"..mh:M3("foo"):show00(...) end,
    show0  = function (mh,...) return mh:show00(...):show0() end,
    show   = function (mh,...) return mh:show00(...):show () end,

  },
}
maximahead = MaximaHead {}

-- «MaximaHead-tests»  (to ".MaximaHead-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Maxima2.lua"

bigstr = [[
%M (%i1) a+
%M b+
%M 42; c+d; e+f;
%M (%o1) b + a + 42
%M (%o2) d + c
%M (%o3) f + e
%M (%i4)
%M
]]
= maximahead:set_maxima_lines(bigstr, 0)  -- delete 0 chars
= maximahead:set_maxima_lines(bigstr, 3)  -- delete 3 chars
= maximahead:set_maxima_lines(bigstr)     -- delete the "%M "s
= maxima_lines00
= maxima_lines0
= maxima_lines

= maximahead:sa000()
= maximahead:sa00 ()
= maximahead:sa0  ("foo")

= maximahead:M0()
= maximahead:M1()
= maximahead:M2 ("bar")
= maximahead:M12("bar")
= maximahead:M3 ("bar")
= maximahead:show00 {scale=0.9}
= maximahead:show0  {scale=0.9}
= maximahead:show   {scale=0.9}
 (etv)
= Show.log
= Show.bigstr

= maximahead:mios()
= maximahead:mios():totex()
= maximahead:mios():totex("%\n")
= maximahead:mios():totex(" \\\\\n")
= maximahead:sa00()
= maximahead:sa00(      " \\\\\n")
= maximahead:sa0("foo")
= maximahead:sa0("foo", " \\\\\n")
output = print
  maximahead:sa ("foo")
  maximahead:sa ("foo", " \\\\\n")

--]==]

--  _                    _ 
-- | |__   ___  __ _  __| |
-- | '_ \ / _ \/ _` |/ _` |
-- | | | |  __/ (_| | (_| |
-- |_| |_|\___|\__,_|\__,_|
--                         
-- See: http://angg.twu.net/dednat6/tug-slides.pdf#page=17
--      http://angg.twu.net/dednat6/tugboat-rev2.pdf#page=4
--      https://tug.org/TUGboat/tb39-3/tb123ochs-dednat.pdf#page=4
--
-- «head»  (to ".head")
-- (find-angg "LUA/Verbatim1.lua" "vbt-head")
registerhead = registerhead or function () return nop end
registerhead "%M" {
  name   = "maxima",
  action = function ()
      local i,j,origlines = tf:getblock(0)
      maximahead:set_maxima_lines(origlines)
    end,
}


-- «show2»  (to ".show2")
-- (find-angg "LUA/Show2.lua" "dednat6" "dednat6_Maxima2")
-- (find-LATEX "edrx21.sty" "maximablue-red")

dednat6_Maxima2 = [==[
% (find-Deps1-cps "Maxima2")
%L dofile "Maxima2.lua"              -- (find-angg "LUA/Maxima2.lua")
\pu
]==]

usepackages.edrx21 = true
dednat6["0"]       = true
dednat6.Maxima2    = true

-- «show2-tests»  (to ".show2-tests")
--[==[
 (find-Deps1-cps "Maxima2")
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Maxima2.lua"
= outertexbody

= ([=[
   % A low-level test without Dednat6.
   % See: (find-LATEX "edrx21.sty" "maximablue-red")
   \def\hboxthreewidth{4cm}
   \vbox{%
     \maximablue{(\%i1)\ 2*3;}%
     \maximared{(\%o1)\ }{}%
     \maximared{}{5}%
   }
   ]=]) :show {scale=1.5}
= Show.log
= Show.bigstr
 (etv)

--]==]


-- «show2-tests-head»  (to ".show2-tests-head")
--[==[
 (find-Deps1-cps "Maxima2")
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Maxima2.lua"
= outertexbody

dednat6.Maxima2_test = [=[
% A test with Dednat6.
%
%M (%i1) 2*3;
%M (%o1) 5
%L maximahead:sa("2 + 3", "")
\pu
\def\hboxthreewidth {6cm}
]=]

= ([=[ \vbox{\ga{2 + 3}}
   ]=]) :show {scale=1.5}
= Show.log
= Show.bigstr
 (etv)

--]==]


-- «show2-tests-prep»  (to ".show2-tests-prep")
--[[
 (find-Maxima2-links "maxima-subst1")
 (eepitch-maxima)
 (eepitch-kill)
 (eepitch-maxima)
load("/usr/share/emacs/site-lisp/maxima/emaxima.lisp")$
load("~/MAXIMA/barematrix1.lisp")$
display2d:'emaxima$

linenum:0;
/* PR:  power rule
 * PRW: power rule, wrong version
*/
PR  : 'diff(x^n,x) = n*x^(n-1);
PRW : 'diff(x^n,x) = n*x^(n-1) + 10*n;
subst([n=4], PR);
subst([n=4], PRW);

--]]




















-- Local Variables:
-- coding:  utf-8-unix
-- End:
