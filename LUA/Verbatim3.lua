-- This file:
--   http://anggtwu.net/LUA/Verbatim3.lua.html
--   http://anggtwu.net/LUA/Verbatim3.lua
--          (find-angg "LUA/Verbatim3.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/Verbatim3.lua"))
-- Supersedes:
--   (find-angg "LUA/Verbatim2.lua")



-- «.Verbatim»		(to "Verbatim")
-- «.Verbatim-tests»	(to "Verbatim-tests")
-- «.usepackages»	(to "usepackages")
-- «.dednat6»		(to "dednat6")
-- «.dedna6-tests»	(to "dedna6-tests")

require "Show2"      -- (find-angg "LUA/Show2.lua")
require "Co1"        -- (find-angg "LUA/Co1.lua" "Co-tests")


-- __     __        _           _   _           
-- \ \   / /__ _ __| |__   __ _| |_(_)_ __ ___  
--  \ \ / / _ \ '__| '_ \ / _` | __| | '_ ` _ \ 
--   \ V /  __/ |  | |_) | (_| | |_| | | | | | |
--    \_/ \___|_|  |_.__/ \__,_|\__|_|_| |_| |_|
--                                              
-- «Verbatim»  (to ".Verbatim")
Verbatim = Class {
  type    = "Verbatim",
  from    = function (o) return Verbatim {o = o} end,
  __tostring = function (vb)
      if type(vb.o) == "string" then return vb.o end
      return mytostringv(vb.o)
    end,
  __index = {
    copy = function (vb) return deepcopy(vb) end,
    --
    -- (find-angg "LUA/Co1.lua" "poor-mans-code")
    -- vb:e(str) expands some (non-utf8) characters in str.
    co = Co.new("#$", " %&\\^_{}~"):add("\n", "\\\\\n"),
    e  = function (vb, s) return vb.co:translate(s) end,
    --
    -- Some functions that are not methods, used by map
    -- (find-LATEX "edrx21.sty" "defvbt" "vbtbgbox")
    f = {
      e  = function (s) return Verbatim({}):e(s) end,
      v  = function (s) return format("\\vbox{%%\n%s%%\n}", s) end,
      h1 = function (s) return format("\\vbthbox{%s}", s) end,
      bg = function (s) return format("\\vbtbgbox{%s}", s) end,
    },
    --
    prefix = "  ",
    _h  = function (vb) vb.o = map(vb.f.h1, vb.o) end,
    _c  = function (vb) vb.o = table.concat(vb.o, "%\n"..vb.prefix) end,
    _p  = function (vb) vb.o = vb.prefix..vb.o end,
    _e  = function (vb) vb.o = map(vb.f.e, vb.o) end,
    _v  = function (vb) vb.o = vb.f.v (vb.o) end,
    _bg = function (vb) vb.o = vb.f.bg(vb.o) end,
    _o  = function (vb) output(vb.o) end,
    _P  = function (vb) print(vb) end,
    _fmt    = function (vb,fmt,...) vb.o = format(fmt,...) end,
    _def    = function (vb,name) vb:_fmt("\\def\\%s{%s}",    name, vb.o) end,
    _defvbt = function (vb,name) vb:_fmt("\\defvbt{%s}{%s}", name, vb.o) end,
    _sa     = function (vb,name) vb:_fmt("\\sa{%s}{%s}",     name, vb.o) end,
    --
    act1 = function (vb, action, ...) 
        local _action = "_"..action
        if not vb[_action] then error("Unrecognized action: "..action) end
        vb[_action](vb,...)
        return vb
      end,
    act = function (vb, str)
        for _,actionarg in ipairs(split(str)) do
	  local action,arg = actionarg:match("^([^:]+):?(.*)$")
          vb:act1(action, arg)
	end
	return vb
      end,
    sa = function (vb, name)
        vb.o = format("\\sa{%s}{%s}", name, vb.o)
	return vb
      end,
    sa      = function (vb, name) return vb:act1("sa", name) end,
    defvbt0 = function (vb, name) return vb:act1("defvbt", name) end,
    defvbt  = function (vb, name) return vb:act("e h c p v bg"):defvbt0(name) end,
  },
}

-- «Verbatim-tests»  (to ".Verbatim-tests")
-- See: (find-LATEX "edrx21.sty" "defvbt")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Verbatim3.lua"
output = print
= Verbatim.__index.co
= Verbatim({}):e "Hello #$\n%&\\^_{}~!!!\n  Hey  hey"

  Verbatim.from({"a", "bb", "ccc"}):act("P")
  Verbatim.from({"a", "bb", "ccc"}):act("c P")
  Verbatim.from({"a", "bb", "ccc"}):act("e h c P")
  Verbatim.from({"a", "bb", "ccc"}):act("e h c p P")
  Verbatim.from({"a", "bb", "ccc"}):act("e h c v P")
  Verbatim.from({"a", "bb", "ccc"}):act("e h c p v P")
  Verbatim.from({"a", "bb", "ccc"}):act("e h c p v bg P")
  Verbatim.from({"a", "bb", "ccc"}):act("e h c p v bg def:foo P")
  Verbatim.from({"a", "bb", "ccc"}):act("e h c p v bg defvbt:foo P")
= Verbatim.from({"a", "bb", "ccc"}):act("e h c p v bg")
= Verbatim.from({"a", "bb", "ccc"}):act("e h c p v bg"):sa("[a b c] box")
= Verbatim.from({"a", "bb", "ccc"}):act("e h c p v bg defvbt:foo")
= Verbatim.from({"a", "bb", "ccc"}):act("e h c p v bg"):defvbt0("foo")
= Verbatim.from({"a", "bb", "ccc"}):act("e h c p v bg"):defvbt0("foo bar")
= Verbatim.from({"a", "bb", "ccc"}):defvbt("foo bar")
  Verbatim.from({"a", "bb", "ccc"}):defvbt("foo bar"):act("o")

--]==]


--                                  _                         
--  _   _ ___  ___ _ __   __ _  ___| | ____ _  __ _  ___  ___ 
-- | | | / __|/ _ \ '_ \ / _` |/ __| |/ / _` |/ _` |/ _ \/ __|
-- | |_| \__ \  __/ |_) | (_| | (__|   < (_| | (_| |  __/\__ \
--  \__,_|___/\___| .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/
--                |_|                         |___/           
--
-- «usepackages»  (to ".usepackages")
-- Note that only :show() uses these settings.
-- See: (find-angg "LUA/Show2.lua" "dednat6")
--      (find-angg "LUA/Show2.lua" "dednat6" "dednat6_Verbatim3")
usepackages.edrx21 = true
dednat6["0"]       = true
dednat6.Verbatim3  = true

--[==[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Verbatim3.lua"
vb = Verbatim.from({"a", "bb", "ccc", "dddd"})
= vb
= vb:copy():act("e h c p v bg")
= vb:copy():act("e h c p v bg").o
= vb:copy():act("e h c p v bg").o:show00()
= vb:copy():act("e h c p v bg").o:show0 ()
= vb:copy():act("e h c p v bg").o:show  ()
 (etv)

defs.greekcolors = [=[
  \defα{\color{black}}
  \defβ{\color{red}}
  \defγ{\color{orange}}
]=]

vb = Verbatim.from({"a", "bβb", "cβcγc", "dβdγdαd"})
= vb:copy():act("e h c p v bg")
= vb:copy():act("e h c p v bg").o
= vb:copy():act("e h c p v bg").o:show00()
= vb:copy():act("e h c p v bg").o:show0 ()
= vb:copy():act("e h c p v bg").o:show  ()
 (etv)

--]==]




--  ____           _             _    __   
-- |  _ \  ___  __| |_ __   __ _| |_ / /_  
-- | | | |/ _ \/ _` | '_ \ / _` | __| '_ \ 
-- | |_| |  __/ (_| | | | | (_| | |_| (_) |
-- |____/ \___|\__,_|_| |_|\__,_|\__|\___/ 
--                                         
-- «dednat6»  (to ".dednat6")
-- See: (find-LATEX "edrx21.sty" "defvbt")
-- The typical use in dednat6 is like this:
--
--   1. a %V-block sets the global variable vbt_lines,
--   2. a line like `%L defvbt "foo boxed"' outputs a \defvbt{name}{...},
--   3. a `\vbt{name}' accesses the vbt with that name.
--
-- For tests:
defs_Verbatim3_fooboxed0 = [=[
%V  _____
%V |     |
%V | foo |
%V |_____|
]=]
defs_Verbatim3_fooboxed1 = [=[
%L defvbt "foo boxed"
\pu
]=]

-- See: (find-dn6 "heads6.lua" "lua-head")
--      (find-dn6 "block.lua" "Block" "getblock =")
--
registerhead = registerhead or function () return nop end
registerhead "%V" {
  name   = "vbt",
  action = function ()
      local i,j,origlines = tf:getblock(3)
      vbt_lines = origlines
    end,
}

defvbt = function (name)
    Verbatim.from(vbt_lines):defvbt(name):act("o")
  end

-- «dedna6-tests»  (to ".dedna6-tests")
--[==[
 (show2-use "$SHOW2LATEXDIR/")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Verbatim3.lua"
defs.Verbatim3_fooboxed0 = true
defs.Verbatim3_fooboxed1 = true
= outertexbody

= ([[ a:\vbt{foo boxed}:b ]]):show0()
= ([[ a:\vbt{foo boxed}:b ]]):show ()
 (etv)

--]==]





-- Local Variables:
-- coding:  utf-8-unix
-- End:
