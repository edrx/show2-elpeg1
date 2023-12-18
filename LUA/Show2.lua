-- This file:
--   http://anggtwu.net/LUA/Show2.lua.html
--   http://anggtwu.net/LUA/Show2.lua
--          (find-angg "LUA/Show2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- Version: 2023nov09
--
-- Based on:
--   (find-angg "LUA/Show1.lua")
--   (find-angg "LUA/Pict2e1.lua" "Show")
--   (find-angg "LUA/tikz1.lua" "Show-class")
--   (find-LATEXfile "2022pict2e-body.tex")
--   (find-LATEXfile "2022pict2e.tex")
-- Used by:
--   (find-angg "LUA/Co1.lua")
--    (find-angg "LUA/Verbatim3.lua")
--    (find-angg "LUA/Und1.lua")
--    (find-angg "LUA/LPex1.lua")
--    (find-angg "LUA/ParseTree1.lua")
--    (find-angg "LUA/Maxima2.lua")
--   (find-angg "LUA/Pict3.lua")
--    (find-angg "LUA/Piecewise2.lua")
--    (find-angg "LUA/Numerozinhos1.lua")
--    (find-angg "LUA/Surface1.lua")
--    (find-angg "LUA/ExprDxDy1.lua")
-- See:
--   (find-angg "LUA/Show2-outer.tex")

-- (defun s1 () (interactive) (find-angg "LUA/Show1.lua"))
-- (defun s2 () (interactive) (find-angg "LUA/Show2.lua"))
--
-- «.introduction»	(to "introduction")
-- «.Dang»		(to "Dang")
-- «.Dang-tests»	(to "Dang-tests")
-- «.TeXSet»		(to "TeXSet")
-- «.TeXSet-tests»	(to "TeXSet-tests")
--   «.defs»		(to "defs")
--   «.defs_repl»	(to "defs_repl")
--   «.usepackages»	(to "usepackages")
-- «.middletexbody»	(to "middletexbody")
-- «.dednat6»		(to "dednat6")
-- «.texbody»		(to "texbody")
-- «.texbody-tests»	(to "texbody-tests")
-- «.Show»		(to "Show")
-- «.Show-tests»	(to "Show-tests")
-- «.StringShow»	(to "StringShow")
-- «.StringShow-tests»	(to "StringShow-tests")



--  ___       _                 _            _   _             
-- |_ _|_ __ | |_ _ __ ___   __| |_   _  ___| |_(_) ___  _ __  
--  | || '_ \| __| '__/ _ \ / _` | | | |/ __| __| |/ _ \| '_ \ 
--  | || | | | |_| | | (_) | (_| | |_| | (__| |_| | (_) | | | |
-- |___|_| |_|\__|_|  \___/ \__,_|\__,_|\___|\__|_|\___/|_| |_|
--                                                             
-- «introduction»  (to ".introduction")
-- In 2022 I found a nice way to edit TikZ code in a REPL. After
-- polishing the first prototype a bit I created this page explaining
-- how it worked and how people could test it,
--
--   http://angg.twu.net/eev-tikz.html
--   http://angg.twu.net/eev-tikz.html#introduction
--
-- and I recorded this video,
--
--   (find-2022tikzvideo "0:00")
--   (find-1stclassvideo-links "2022tikz")
--
-- and created this e-script with instructions:
--
--   (find-tikz1-links)
--
-- The central idea is that people would edit their diagrams in test
-- blocks - see:
--
--   http://anggtwu.net/eepitch.html#test-blocks
--
-- and then they would type <f8> on two lines like these:
--
--   show()
--    (tikz-show)
--
-- The "show()" would:
--   a1) create a .tex file,
--   a2) compile the .tex with lualatex, and
--   a3) tell the user if the compilation was successful;
-- the "(tikz-show)" would:
--   b1) create the 3-window setting below, and
--   b2) refresh that PDF being displayed.
--      ___________________________
--     |           |               |
--     |           |  [t]arget     |
--     | the file  |   buffer      |
--     |   being   |_______________|
--     | [e]dited  |               |
--     | (a .lua)  |  [v]iew the   |
--     |           | resulting PDF |
--     |___________|_______________|
--
-- The "show()" would be sent to the Lua REPL in the target buffer and
-- would be run from there, and the "(tikz-show)" would be run from
-- elisp. This separation simplified the code a lot - but the user had
-- to wait for the success message from the "show()" before running
-- the "(tikz-show)".
--
-- In 2023 I saw that I needed some way to generalize that - I had
-- many Lua classes whose objects had nice LaTeX-ed representations,
-- and it would be better to use something like this,
--
--   o:show()
--    (etv)
--
-- where each class would have a different ":show()" method... most of
-- my classes "represent" diagrams drawn with pict2e, several
-- represent diagrams drawn with "\underbrace"s, and only a few use
-- TikZ; I needed a way to handle these different ":show()" methods.
--
-- This file implements some tools for defining these ":show()"s, and
-- it also implements (the Lua side of) a simple way to configure
-- where the .tex and the .pdf file are to be put. To understand how
-- this configuration is done and how the Emacs side works, see:
--
--   (find-show2-intro "3. Show2.lua")
--
--
--
-- TODO: Explain this:
--   http://angg.twu.net/pict2e-lua.html
--   (find-1stclassvideo-links "2022pict2elua")
--   (find-angg "LUA/tikz1.lua" "Show-class")
--   (find-TH "pict2e-lua")
--   (find-TH "pict2e-lua" "try-it")




--  ____                    
-- |  _ \  __ _ _ __   __ _ 
-- | | | |/ _` | '_ \ / _` |
-- | |_| | (_| | | | | (_| |
-- |____/ \__,_|_| |_|\__, |
--                    |___/ 
--
-- An object is the class Dang "is" a string whose parts
-- between <<D>>ouble <<ANG>>le brackets "are to be expanded".
--
-- More precisely: each object of the class Dang contains a
-- field .bigstr with a string. When that object is "expanded"
-- by tostring all the parts between double angle brackets
-- in .bigstr are "expanded" by Dang.eval. The expansion
-- happens every time that the tostring is run, and so the
-- result of the expansion may change.
--
-- Note that I use these conventions:
--   a bigstr is a string that may contain newlines,
--   a str    is a string that does not contain newlines,
--   an s     is the argument for the function f when
--            we run bigstr:gsub(pat, f) or str:gsub(pat, f).
--
-- To understand the details, see the tests below, in:
--   (to "Dang-tests")
-- Based on: (find-angg "LUA/tikz1.lua" "Dang")
-- Uses:     (find-angg "LUA/lua50init.lua" "eval-and-L")
--
-- «Dang»  (to ".Dang")

Dang = Class {
  type = "Dang",
  from = function (bigstr) return Dang {bigstr=bigstr} end,
  --
  eval0 = function (s)
      if s:match("^:")             -- How show we eval s?
      then return eval(s:sub(2))   --    With ":" -> as ":<expression>"
      else return expr(s)          -- Without ":" -> as "<statements>"
      end
    end,
  eval = function (s)
      local r = Dang.eval0(s)
      if r == nil then return "" end
      return tostring(r)
    end,
  replace = function (bigstr)                      -- replace each <<s>>
      return (bigstr:gsub("<<(.-)>>", Dang.eval))  -- by Dang.eval(s)
    end,
  --
  peval0 = function (s) PP(Dang.eval0(s)) end,
  peval  = function (s) PP(Dang.eval (s)) end,
  preplace = function (bigstr) PP(Dang.replace(bigstr)) end,
  --
  __tostring = function (da) return da:tostring() end,
  __index = {
    tostring = function (da) return Dang.replace(da.bigstr) end,
    -- See below: (to "StringShow")
    show00   = function (da,...) return tostring(da):show00(...) end,
    show0    = function (da,...) return tostring(da):show0 (...) end,
    show     = function (da,...) return tostring(da):show  (...) end,
  },
}

-- «Dang-tests»  (to ".Dang-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Show2.lua"
= Dang. eval0 ":return 2+3,'6'"  --> 5 6
  Dang.peval0 ":return 2+3,'6'"  --> 5 "6"
= Dang. eval0         "2+3,'6'"  --> 5 6
  Dang.peval0         "2+3,'6'"  --> 5 "6"
= Dang. eval          "2+3,'6'"  --> 5
  Dang.peval          "2+3,'6'"  --> "5"

= Dang. eval    "2+3"            --> 5
  Dang.peval    "2+3"            --> "5"
= Dang.replace "a<<2+3>>b"       --> a5b
 Dang.preplace "a<<2+3>>b"       --> "a5b"

    Dang.peval    "c"            --> ""
 Dang.preplace "a<<c>>b"         --> "ab"
c = "foo"
    Dang.peval    "c"            --> "foo"
 Dang.preplace "a<<c>>b"         --> "afoob"

=    Dang.from "a<<c>>b"           --> afoob
  PP(Dang.from "a<<c>>b")          --> {"bigstr"="a<<c>>b"}
=    Dang.from("a<<c>>b").bigstr   --> a<<c>>b
  PP(Dang.from("a<<c>>b").bigstr)  --> "a<<c>>b"

 Dang.preplace "a<<:>>b"               --> "ab"
 Dang.preplace "a<<:return>>b"         --> "ab"
 Dang.preplace "a<<:return nil>>b"     --> "ab"
 Dang.preplace "a<<:return 4+5>>b"     --> "a9b"
 Dang.preplace "a<<:return 4+5,6>>b"   --> "a9b"

 Dang.preplace "a<<:return false>>b"   --> "afalseb"

--]==]





--  _____   __  ______       _   
-- |_   _|__\ \/ / ___|  ___| |_ 
--   | |/ _ \\  /\___ \ / _ \ __|
--   | |  __//  \ ___) |  __/ |_ 
--   |_|\___/_/\_\____/ \___|\__|
--                               
-- A variant of the class Set in which __tostring produces TeX code.
-- TODO: replace "usepackages" and "defs" by TeXSet objects.
--  See: (find-angg "LUA/Set.lua" "Set")
-- «TeXSet»  (to ".TeXSet")

TeXSet = Class {
  type = "TeXSet",
  create = function (name, sep)
      local ts = TeXSet {name=name, _=Set.new(), sep=(sep or "\n")}
      _G[name] = ts
      return ts
    end,
  __newindex = function (ts, key, val)
      if val == nil then ts._:del(key); return end
      if val == true then
        local globalname = ts.name.."_"..key
        local currentvalue = _G[globalname]
        if not currentvalue then error(globalname.." is nil") end
        ts._:add(key, currentvalue)
        return
      end
      ts._:add(key, val)
    end,
  __tostring = function (ts)
      local f = function (key) return tostring(ts._:get(key)) end
      local keys = ts._:ks()
      return mapconcat(f, keys, ts.sep)
    end,
  __index = {
  },
}

-- «TeXSet-tests»  (to ".TeXSet-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Show2.lua"
  usepackages     = TeXSet.create("usepackages")
  usepackages_foo = Dang.from "\\usepackage[<<foooptions>>]{foo}"
= usepackages
  usepackages.bar = "\\usepackage{bar}"    -- new
  usepackages.foo = true                   -- use the current usepackages_foo
= usepackages
   foooptions = TeXSet.create("foooptions", ",")
=  foooptions
   foooptions.blep = "blep"
   foooptions.blip = "blip"
=  foooptions
= usepackages
   foooptions.blip = nil                    -- delete this option
= usepackages

--]==]


-- «defs»  (to ".defs")
TeXSet.create("defs")

-- «defs_repl»  (to ".defs_repl")
-- Based on: (find-angg "LUA/tikz1.lua" "repl2")
-- See: (find-angg "LUA/DednatRequire1.lua")
--      (find-angg "LUA/lua50init.lua" "loaddednatrequire")
--      (find-angg "LUA/lua50init.lua" "Repl3.lua" "run_repl3_now =")
defs_repl = [=[
              \directlua{ dofile(os.getenv("LUA_INIT"):sub(2)) }
              \directlua{ loaddednatrequire()                  }
\def\repl    {\directlua{ print(); run_repl3_now()             }}
\def\condrepl{\directlua{ if os.getenv"REPL"=="1" then print(); run_repl3_now() end }}
]=]



-- «usepackages»  (to ".usepackages")
TeXSet.create("usepackages")
usepackages_edrx21 = [=[
\usepackage{edrx21}               % (find-LATEX "edrx21.sty")
\input edrxaccents.tex            % (find-LATEX "edrxaccents.tex")
\input edrx21chars.tex            % (find-LATEX "edrx21chars.tex")
%\input edrxheadfoot.tex          % (find-LATEX "edrxheadfoot.tex")
\input edrxgac2.tex               % (find-LATEX "edrxgac2.tex")
]=]
usepackages_pict2e = [=[
\usepackage{pict2e}
\def\pictgridstyle{\color{GrayPale}\linethickness{0.3pt}}
\def\pictaxesstyle{\linethickness{0.5pt}}
\def\pictnaxesstyle{\color{GrayPale}\linethickness{0.5pt}}
\def\closeddot{{\circle*{0.4}}}
\def\opendot  {{\circle*{0.4}\color{white}\circle*{0.25}}}
\unitlength=20pt
]=]
usepackages_tikz = [=[
\usepackage{tikz}
]=]

-- «middletexbody»  (to ".middletexbody")
middletexbody_bare = Dang.from [=[<<texbody>>]=]
middletexbody      = middletexbody_bare


-- «dednat6»  (to ".dednat6")
-- (find-angg "LUA/Maxima2.lua"   "show2-tests")
-- (find-angg "LUA/Verbatim2.lua" "vbt-head-tests")
TeXSet.create("dednat6")
dednat6_0 = [=[
\catcode`\^^J=10
\directlua{dofile "dednat6load.lua"}  % (find-LATEX "dednat6load.lua")
]=]
dednat6_Verbatim2 = [==[
% (find-Deps1-cps "Verbatim2")
%L dofile "Verbatim2.lua"            -- (find-LATEX "Verbatim2.lua")
\pu
]==]
dednat6_Verbatim3 = [==[
% (find-Deps1-cps "Verbatim3")
%L dofile "Verbatim3.lua"            -- (find-LATEX "Verbatim3.lua")
\pu
]==]



--  _            _               _       
-- | |_ _____  _| |__   ___   __| |_   _ 
-- | __/ _ \ \/ / '_ \ / _ \ / _` | | | |
-- | ||  __/>  <| |_) | (_) | (_| | |_| |
--  \__\___/_/\_\_.__/ \___/ \__,_|\__, |
--                                 |___/ 
-- «texbody»  (to ".texbody")
-- Based on: (find-angg "LUA/tikz1.lua" "texbody")

scale = "1.0"
geometry = "paperwidth=148mm, paperheight=88mm,\n            "..
           "top=1.5cm, bottom=.25cm, left=1cm, right=1cm, includefoot"
geometryhead = "paperwidth=148mm, paperheight=88mm, top=2cm"
saysuccess = "\\GenericWarning{Success:}{Success!!!}"

outertexbody = Dang.from [=[
\documentclass[<<documentclassoptions>>]{book}
\usepackage[x11names,svgnames]{xcolor}
\usepackage{colorweb}
\usepackage{graphicx}
\usepackage[<<geometry>>]{geometry}
<<usepackages>>
<<dednat6>>
\begin{document}
\pagestyle{empty}
<<defs>>
<<middletexbody>>
<<saysuccess>>
\end{document}
]=]

-- «texbody-tests»  (to ".texbody-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Show2.lua"
= outertexbody.bigstr
= outertexbody
  texbody = "FOO"
= outertexbody

--]==]



--  ____  _
-- / ___|| |__   _____      __
-- \___ \| '_ \ / _ \ \ /\ / /
--  ___) | | | | (_) \ V  V /
-- |____/|_| |_|\___/ \_/\_/
--
-- This class treats a bigstr as LaTeX code, preprocesses it in
-- certain configurable ways, tries to run lualatex on the result,
-- _ALMOST_ prints a status showing if the lualatex-ing was
-- successful, and _ALMOST_ shows the resulting PDF.
-- delegated to an elisp function called etv, that is run from a red
-- star line like this one,
--
--    (show2-use "/tmp/Show2.tex")
--    (eepitch-lua51)
--    (eepitch-kill)
--    (eepitch-lua51)
--   dofile "Show2.lua"
--     texbody = "FOO"
--   = outertexbody
--   = Show.try(tostring(outertexbody))
--   = Show.log
--   = Show.bigstr
--    (etv)
--
-- that creates a 3-window setting whose windows are called [e]dit,
-- [t]arget, and [v]iew:
--    ___________________________
--   |           |     	       	 |
--   |           |  [t]arget	 |
--   | the file  |   buffer	 |
--   |   being   |_______________|
--   | [e]dited  |		 |
--   | (a .lua)  |  [v]iew the	 |
--   |           | resulting PDF |
--   |___________|_______________|
--
-- The function (etv) is usually defined by a call to `show2-use'.
--      See: (find-show2-intro "3. Show2.lua")
--           (find-show2-intro "3. Show2.lua" "show2-use")
-- Based on: (find-angg "LUA/tikz1.lua" "Show-class")
--
-- «Show»  (to ".Show")
--
Show = Class {
  type = "Show",
  new  = function (bigstr) Show.bigstr = bigstr; return Show{} end,
  save = function (bigstr) return Show.new(bigstr):write():fnametex() end,
  try  = function (bigstr) return Show.new(bigstr):write():compile() end,
  -- These variables are set at each call:
  bigstr  = "",
  log     = "",
  success = nil,
  --
  __tostring = function (s) return s:tostring() end,
  __index = {
    tostring = function (s)
        return format("Show: %s => %s", s:fnametex(), Show.success or "?")
      end,
    --
    nilify   = function (s, o) if o=="" then return nil else return o end end,
    getenv   = function (s, varname) return s:nilify(os.getenv(varname)) end,
    dir      = function (s) return s:getenv("SHOW2DIR")  or "/tmp/" end,
    stem     = function (s) return s:getenv("SHOW2STEM") or "Show2" end,
    fnametex = function (s) return s:dir()..s:stem()..".tex" end,
    fnamepdf = function (s) return s:dir()..s:stem()..".pdf" end,
    fnamelog = function (s) return s:dir()..s:stem()..".log" end,
    cmd      = function (s)
        return "cd "..s:dir().." && lualatex "..s:stem()..".tex < /dev/null"
      end,
    write = function (s)
        ee_writefile(s:fnametex(), Show.bigstr)
        return s
      end,
    compile = function (s)
        Show.log = getoutput(s:cmd())
        Show.success = Show.log:match "Success!!!"
        return s
      end,
  },
}

-- «Show-tests»  (to ".Show-tests")
--[==[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Show2.lua"
s = Show {}
= s:dir()
= s:stem()
= s:fnametex()
= s:fnamepdf()
= s:cmd()

  texbody = "FOO"
= outertexbody
= Show.try(tostring(outertexbody))
= Show.log
= Show.bigstr
 (etv)

--]==]




--  ____  _        _             ____  _                   
-- / ___|| |_ _ __(_)_ __   __ _/ ___|| |__   _____      __
-- \___ \| __| '__| | '_ \ / _` \___ \| '_ \ / _ \ \ /\ / /
--  ___) | |_| |  | | | | | (_| |___) | | | | (_) \ V  V / 
-- |____/ \__|_|  |_|_| |_|\__, |____/|_| |_|\___/ \_/\_/  
--                         |___/                           
--
-- This class implements the basic way in which string objects are
-- (LaTeXed and) "shown". For example, in
--
--   ("a \\cdot b"):show00 {scale=4, em=true}
--   ("a \\cdot b"):show0  {scale=4, em=true}
--   ("a \\cdot b"):show   {scale=4, em=true}
--
-- the third line wraps the "a \\cdot b" in an "\ensuremath" and in a
-- "\scalebox", sets the global variable "texbody" to the result of
-- that, and then runs this,
--
--   Show.try(tostring(outertexbody))
--
-- that runs lualatex and returns a status message.
--
-- Note that ":show" treats the string "a \\cdot b" of the example
-- above as an ("inner") "body", and it works like this:
--
--   body,opts --:show00--> texbody --> tostring(outertexbody) --> status
--          \ \--:show0----------------^                          ^
--           \---:show-------------------------------------------/
-- 
-- so we can use ":show00" and ":show0" to inspect how ":show" works.
--
-- Compare with:
--   (find-angg "LUA/Pict3.lua" "Pict-show")
--
-- «StringShow»  (to ".StringShow")
StringShow = Class {
  type = "StringShow",
  new  = function () return StringShow {} end,
  __index = {
    show00 = function (ss, body, opts)
        opts = opts or {}
        local s = body
        if opts.D     then s = format("\\displaystyle %s", s) end
        if opts.em    then s = format("\\ensuremath{%s}", s) end
        if opts.scale then s = format("\\scalebox{%s}{%s}", opts.scale, s) end
        return s
      end,
    show0 = function (ss, body, opts)
        texbody = ss:show00(body, opts)
        return tostring(outertexbody)
      end,
    show = function (ss, body, opts)
        return Show.try(ss:show0(body, opts))
      end,
    save = function (ss, body, opts)
        return Show.save(ss:show0(body, opts))
      end,
  },
}

string.show00 = function (body, opts) return StringShow.new():show00(body, opts) end
string.show0  = function (body, opts) return StringShow.new():show0 (body, opts) end
string.show   = function (body, opts) return StringShow.new():show  (body, opts) end
string.save   = function (body, opts) return StringShow.new():save  (body, opts) end

-- «StringShow-tests»  (to ".StringShow-tests")
--[[
 (show2-use "/tmp/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Show2.lua"
= StringShow.new():show00("foo")
= StringShow.new():show00("foo", {scale=2, em=true})
= StringShow.new():show0 ("foo", {scale=2, em=true})
= StringShow.new():show  ("foo", {scale=2, em=true})
 (etv)

= ("a \\cdot b"):show00 ()
= ("a \\cdot b"):show00 {scale=2, em=true}
= ("a \\cdot b"):show0  {scale=2, em=true}
= ("a \\cdot b"):show   {scale=2, em=true}
 (etv)

= Show.log
= Show.bigstr
= outertexbody
= outertexbody.bigstr

--]]







-- (defun e () (interactive) (find-angg "LUA/Show2.lua"))

-- Local Variables:
-- coding:  utf-8-unix
-- End:
