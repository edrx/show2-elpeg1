-- This file: http://anggtwu.net/LUA/lua50init.lua.html
--            http://anggtwu.net/LATEX/dednat6/edrxlib.lua.html
--            http://anggtwu.net/dednat6/dednat6/edrxlib.lua.html
--            http://anggtwu.net/blogme3/edrxlib.lua.html
--            http://anggtwu.net/emlua/edrxlib.lua.html
--
-- This is my "init file" for Lua. As I have LUA_INIT set
-- to "@$HOME/LUA/lua50init.lua", the Lua interpreter loads
-- this on start-up.
-- See: (find-angg ".zshrc" "lua" "LUA_INIT")
--      (find-lua51manual "#6" "LUA_INIT" "@filename")
--      (find-es "lua5" "LUA_INIT")
--      (find-es "lua5" "lua-init-from-emacs")
--
-- This is _also_ the module "edrxlib.lua" in dednat6, blogme3, and emlua!
-- I use these sexps to keep them in sync:
--   (find-tkdiff    "~/LUA/lua50init.lua"   "~/LATEX/dednat6/edrxlib.lua")
--   (find-tkdiff    "~/LUA/lua50init.lua" "~/dednat6/dednat6/edrxlib.lua")
--   (find-sh0 "cp -v ~/LUA/lua50init.lua               ~/LUA/edrxlib.lua")
--   (find-sh0 "cp -v ~/LUA/lua50init.lua     ~/LATEX/dednat6/edrxlib.lua")
--   (find-sh0 "cp -v ~/LUA/lua50init.lua     ~/LATEX/dednat7/edrxlib.lua")
--   (find-sh0 "cp -v ~/LUA/lua50init.lua   ~/dednat6/dednat6/edrxlib.lua")
--   (find-sh0 "cp -v ~/LUA/lua50init.lua           ~/blogme3/edrxlib.lua")
--   (find-sh0 "cp -v ~/LUA/lua50init.lua             ~/emlua/edrxlib.lua")
-- Old way (fragile): (find-es "emacs" "hard-links")
--
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- Version: 20231218  <- don't trust this date
-- Public domain.
--
-- Note: "dednat4.lua" and "dednat6.lua" try to load this at startup,
-- with 'require "edrxlib"', just after setting the path; if this has
-- already been loaded by LUA_INIT, then the 'require "edrxlib"' will
-- be a no-op, because of this trick:
--      (to "package.require")
--      (to "edrxlib")
-- otherwise it is loaded, usually from "~/dednat4/" or
-- "~/LATEX/dednat6/". See also:
--      (find-dn4 "dednat4.lua" "edrxlib")
--      (find-dn6 "dednat6.lua" "requires")
--      (find-blogme3 "blogme3.lua" "edrxlib")
--
-- This init file used to work both on lua-5.0 and lua-5.1...
-- I have stopped using lua-5.0, but I kept the name of this file.
-- This file works on Lua 5.1, 5.2, 5.3, and 5.4.
--
-- This file still has _A LOT_ of cruft!




-- «.compat»			(to "compat")
-- «.pack-and-unpack»		(to "pack-and-unpack")
-- «.printf»			(to "printf")
-- «.loadstring»		(to "loadstring")
-- «.ee_expand»			(to "ee_expand")
-- «.ee_dofile»			(to "ee_dofile")
-- «.readfile»			(to "readfile")
-- «.writefile»			(to "writefile")
-- «.fileexists»		(to "fileexists")
-- «.trim»			(to "trim")
-- «.split»			(to "split")
-- «.splitlines»		(to "splitlines")
-- «.splitlines-5.3»		(to "splitlines-5.3")
-- «.getoutput»			(to "getoutput")
-- «.map»			(to "map")
-- «.sorted»			(to "sorted")
-- «.fold»			(to "fold")
-- «.min-and-max»		(to "min-and-max")
-- «.table.reverse»		(to "table.reverse")
-- «.table.addentries»		(to "table.addentries")
-- «.package.require»		(to "package.require")
-- «.edrxlib»			(to "edrxlib")
-- «.cow-and-coy»		(to "cow-and-coy")
-- «.eval-and-L»		(to "eval-and-L")
-- «.eoo»			(to "eoo")
-- «.Class»			(to "Class")
--   «.over0»			(to "over0")
--   «.over»			(to "over")
--   «.methodsover»		(to "methodsover")
-- «.rawtostring»		(to "rawtostring")
-- «.rawtostring_comp»		(to "rawtostring_comp")
-- «.Code»			(to "Code")
-- «.Tos»			(to "Tos")
--   «.mytostring»		(to "mytostring")
--   «.mytostringm»		(to "mytostringm")
--   «.PP»			(to "PP")
--   «.VerticalTable»		(to "VerticalTable")
--   «.HTable-and-VTable»	(to "HTable-and-VTable")
--   «.VList»			(to "VList")
-- «.Set»			(to "Set")
--   «.SetL»			(to "SetL")
-- «.Path»			(to "Path")
-- «.DednatRequire»		(to "DednatRequire")
-- «.PrintFunction»		(to "PrintFunction")
-- «.DGetInfo»			(to "DGetInfo")
--   «.DGetInfo-method»		(to "DGetInfo-method")
--   «.DGetInfo-luatb»		(to "DGetInfo-luatb")
-- «.DGetInfos»			(to "DGetInfos")
-- «.Rect»			(to "Rect")
--   «.SynTree»			(to "SynTree")
--   «.DedTree»			(to "DedTree")
--   «.syntree»			(to "syntree")
--   «.re_expand_INFIX»		(to "re_expand_INFIX")
--   «.math-grammar»		(to "math-grammar")
-- «.Re»			(to "Re")
--
-- «.strlen8»			(to "strlen8")
-- «.untabify»			(to "untabify")
-- «.untabify8»			(to "untabify8")
-- «.utf8tohtml»		(to "utf8tohtml")
-- «.u8c_to_l1»			(to "u8c_to_l1")
-- «.u8_to_l1»			(to "u8_to_l1")
-- «.toslashhex»		(to "toslashhex")
-- «.divmod»			(to "divmod")
-- «.userocks»			(to "userocks")
-- «.loadblogme3»		(to "loadblogme3")
-- «.savevars»			(to "savevars")
-- «.variants-of-format»	(to "variants-of-format")
--   «.minus-0»			(to "minus-0")
--   «.trailing-zeroes»		(to "trailing-zeroes")
--   «.pformat»			(to "pformat")
--   «.dformat»			(to "dformat")
--   «.gformat»			(to "gformat")
--
-- «.loaddednat6»		(to "loaddednat6")
-- «.loadelpeg1»		(to "loadelpeg1")
-- «.loaddednatrequire»		(to "loaddednatrequire")
-- «.loadshow2»			(to "loadshow2")
-- «.loadtikz2»			(to "loadtikz2")
-- «.loadluarocks»		(to "loadluarocks")
-- «.loadfbcache2»		(to "loadfbcache2")
-- «.capitalize»		(to "capitalize")
-- «.getinscritos»		(to "getinscritos")
--
-- «.string-methods»		(to "string-methods")
-- «.otherfunctions»		(to "otherfunctions")
-- «.0-based»			(to "0-based")
-- «.P-old»			(to "P-old")
-- «.P-old-tests»		(to "P-old-tests")
-- «.PP-old»			(to "PP-old")
-- «.PPP-old»			(to "PPP-old")
-- «.follow»			(to "follow")
-- «.NamedFunction»		(to "NamedFunction")
-- «.envsubst»			(to "envsubst")
-- «.mytostring-old»		(to "mytostring-old")
-- «.ee_loadlib»		(to "ee_loadlib")
-- «.ee_ls»			(to "ee_ls")
-- «.load_dednat4»		(to "load_dednat4")
-- «.load_posix»		(to "load_posix")
-- «.load_PP»			(to "load_PP")
-- «.PPeval»			(to "PPeval")
-- «.loadlpeg»			(to "loadlpeg")
-- «.loadlpegrex»		(to "loadlpegrex")
-- «.loadpegdebug»		(to "loadpegdebug")
-- «.loadbitlib»		(to "loadbitlib")
-- «.autoload»			(to "autoload")
-- «.loadtcl»			(to "loadtcl")
-- «.loadldb»			(to "loadldb")
-- «.loadpeek»			(to "loadpeek")
-- «.loadalarm»			(to "loadalarm")
-- «.loadposix»			(to "loadposix")
-- «.curl»			(to "curl")
-- «.preparef2n»		(to "preparef2n")
-- «.each2»			(to "each2")
-- «.translatechars»		(to "translatechars")
-- «.lpeg»			(to "lpeg")
--   «.sbeconcat»		(to "sbeconcat")
--   «.concatbestrings»		(to "concatbestrings")
--   «.lpeg_togsub»		(to "lpeg_togsub")
--   «.lpeg_gsub»		(to "lpeg_gsub")
--   «.lpeg_gsub_»		(to "lpeg_gsub_")
--   «.lpeg_balanced»		(to "lpeg_balanced")
-- «.ee_into»			(to "ee_into")
-- «.chdir»			(to "chdir")
-- «.hms_to_s»			(to "hms_to_s")
-- «.s_to_hms»			(to "s_to_hms")
-- «.icollect»			(to "icollect")
-- «.Repl1.lua»			(to "Repl1.lua")
-- «.Repl2.lua»			(to "Repl2.lua")
-- «.Repl3.lua»			(to "Repl3.lua")
--
-- «.mytraceback»		(to "mytraceback")
-- «.errorfb_line»		(to "errorfb_line")
-- «.ee_template»		(to "ee_template")
-- «.interactor»		(to "interactor")
-- «.MyXpcall»			(to "MyXpcall")
-- «.Repl»			(to "Repl")
-- «.loadluarepl»		(to "loadluarepl")

-- «.replaceranges»		(to "replaceranges")
-- «.string.replace»		(to "string.replace")
-- «.anggurl-and-angg_url»	(to "anggurl-and-angg_url")
--
-- «.Sexp»			(to "Sexp")
-- «.youtube_make_url»		(to "youtube_make_url")
-- «.youtube_split»		(to "youtube_split")
-- «.to_youtube_hash»		(to "to_youtube_hash")
-- «.url_split»			(to "url_split")
-- «.Blogme»			(to "Blogme")
--
-- «.EevIntro»			(to "EevIntro")
-- «.ELispH»			(to "ELispH")
-- «.ELispHF»			(to "ELispHF")
-- «.code_video»		(to "code_video")
-- «.getsexp»			(to "getsexp")
-- «.SexpSkel»			(to "SexpSkel")
-- «.ELispInfo»			(to "ELispInfo")
--
-- «.getsexpskel»		(to "getsexpskel")
-- «.SexpLine»			(to "SexpLine")
--
-- «.fsize»			(to "fsize")
--
-- «.findxxxpdf_parse»		(to "findxxxpdf_parse")
--
-- «.repltexthis»		(to "repltexthis")
-- «.Path.addLUAtopath»		(to "Path.addLUAtopath")


-- «compat»  (to ".compat")
-- On Lua 4.x these functions had the short names on the left;
-- on Lua-5.0.x a file etc/compat.lua could be used to make the short
-- names work, but on Lua-5.1.x this compat.lua has been dropped...
-- I still like the short names, so:
write    = io.write        -- (find-lua51manual "#pdf-io.write")
format   = string.format   -- (find-lua51manual "#pdf-string.format")
gsub     = string.gsub     -- (find-lua51manual "#pdf-string.gsub")
strfind  = string.find     -- (find-lua51manual "#pdf-string.find")
strlen   = string.len      -- (find-lua51manual "#pdf-string.len")
strsub   = string.sub      -- (find-lua51manual "#pdf-string.sub")
concat   = table.concat    -- (find-lua51manual "#pdf-table.concat")
tinsert  = table.insert    -- (find-lua51manual "#pdf-table.insert")
tremove  = table.remove    -- (find-lua51manual "#pdf-table.remove")
-- foreachi = table.foreachi -- (find-lua51manual "#7.2" "table.foreachi")

-- getn     = table.getn     -- (find-lua51manual "#7.2" "table.getn")
table.getn  = function (tbl) return tbl.n or #tbl end
getn        = function (tbl) return tbl.n or #tbl end

-- «pack-and-unpack»  (to ".pack-and-unpack")
-- (find-es "lua5" "pack-and-unpack")
-- pack  = table.pack or function (...) return arg end   -- 5.1 and 5.2
pack     = table.pack or function (...) return {n=select("#", ...), ...} end
unpack   = unpack or table.unpack
myunpack = function (arg) return unpack(arg, 1, arg.n) end
-- Examples:
--      PP(pack(nil, 22, nil, 44, nil))        -->  {2=22, 4=44, "n"=5}
--   PP(unpack({nil, 22, nil, 44, nil, n=5}))  -->  <nil> 22
-- PP(myunpack({nil, 22, nil, 44, nil, n=5}))  -->  <nil> 22 <nil> 44 <nil>

-- «printf»  (to ".printf")
printf = function (...) write(format(...)) end

-- «loadstring»  (to ".loadstring")
-- (find-es "lua5" "loadstring")
loadstring = loadstring or load

-- «ee_expand»  (to ".ee_expand")
-- (find-eev "eev.el" "ee-expand")
ee_expand = function (path)
    path = string.gsub(path, "^~$", "$HOME/", 1)
    path = string.gsub(path, "^~/", "$HOME/", 1)
    path = string.gsub(path, "^%$(%w+)", os.getenv, 1)
    return path
  end

-- «ee_dofile»  (to ".ee_dofile")
-- For example,
--   ee_dofile("~/LUA/tikz1.lua")
-- works as expected; with the standard dofile we would need this:
--   dofile(os.getenv("HOME").."/LUA/tikz1.lua")
ee_dofile  = function (path) return dofile(ee_expand(path)) end

-- «readfile»  (to ".readfile")
-- «writefile»  (to ".writefile")
-- (find-es "lua5" "readfile")
-- (find-lua51manual "#pdf-io.open")
-- (find-lua51manual "#pdf-file:read")
-- (find-lua51manual "#pdf-file:write")
readfile = function (fname)
    local f = assert(io.open(fname, "r"))
    local bigstr = f:read("*a")
    f:close()
    return bigstr
  end
writefile = function (fname, bigstr)
    local f = assert(io.open(fname, "w+"))
    f:write(bigstr)
    f:close()
  end

-- «fileexists» (to ".fileexists")
fileexists = function (fname)
    local f, err = (io.open(fname, "r"))
    if f then io.close(f); return true end
    return false
  end

-- (find-blogme3file "youtube.lua" "ee_readfile =")
ee_readfile  = function (fname) return readfile(ee_expand(fname)) end
ee_writefile = function (fname, str) return writefile(ee_expand(fname), str) end

filecontents0 = function (fname)
    local ok,contents = pcall(function () return ee_readfile(fname) end)
    if ok then return contents end
  end

-- (find-dn4 "dednat4.lua" "dednat4dir")
-- (find-dn6 "dednat6.lua" "package.path")
fnamedirectory    = function (fname) return fname:match"^(.*/)[^/]*$"  end
fnamenondirectory = function (fname) return fname:match     "([^/]*)$" end

ee_shorten = function (fname)
    fname = fname:gsub("^/home/edrx/", "~/")
    fname = fname:gsub("^~/snarf/",   "$S/")
    return fname
  end

-- «trim» (to ".trim")
-- (to "string-methods")
-- (find-lua51manual "#5.4.1" "Patterns")
ltrim = function (str) return str:match"^%s*(.*)$" end
rtrim = function (str) return str:reverse():ltrim():reverse() end
bitrim = function (str) return str:ltrim():rtrim() end
string.ltrim = ltrim
string.rtrim = rtrim
string.bitrim = bitrim

-- «split»  (to ".split")
-- (find-es "lua5" "split")
split = function (str, pat)
    local arr = {}
    string.gsub(str, pat or "([^%s]+)", function (word)
        table.insert(arr, word)
      end)
    return arr
  end

-- «splitlines»  (to ".splitlines")
splitlines = function (bigstr)
    local arr = split(bigstr, "([^\n]*)\n?")
    table.remove(arr)
    return arr
  end
isplitlines = function (bigstr)
    return ipairs(splitlines(bigstr))
  end

-- «splitlines-5.3»  (to ".splitlines-5.3")
-- (find-es "lua5" "splitlines-5.3")
splitlines = function (bigstr)
    local arr = split(bigstr, "([^\n]*)\n?")
    if _VERSION:sub(5) < "5.3" then
      table.remove(arr)
    end
    return arr
  end

-- «getoutput»  (to ".getoutput")
-- (find-es "lua5" "getoutput")
getoutput = function (command)
    local pipe = assert(io.popen(command))
    local output = pipe:read("*a")
    pipe:close()
    return output
  end

-- «map»  (to ".map")
--------[ keys, map, seq, nop, each2, splitlines, chartranslator ]--------

keys = function (tbl)
    local ks = {}
    for k,_ in pairs(tbl) do table.insert(ks,k) end
    return ks
  end

map = function (f, arr, n)
    local brr = {}
    for i=1,(n or #arr) do table.insert(brr, (f(arr[i]))) end
    return brr
  end

seq = function (a, b, c)
    local arr = {}
    for i=a,b,(c or 1) do table.insert(arr, i) end
    return arr
  end
seqn = function (a, b, n)
    local f = function (k) return a + (b-a)*(k/n) end
    return map(f, seq(0, n))
  end

nop = function () end
id  = function (...) return ... end

copy = function (A)
    local B = {}
    for k,v in pairs(A) do B[k] = v end
    setmetatable(B, getmetatable(A))
    return B
  end

shallowcopy = function (A, B)
    B = B or {}
    for k,v in pairs(A) do B[k] = v end
    setmetatable(B, getmetatable(A))
    return B
  end

deepcopy = function (A)
    if type(A) ~= "table" then return A end
    local B = {}
    for k,v in pairs(A) do B[k] = deepcopy(v) end
    setmetatable(B, getmetatable(A))
    return B
  end

deepcopymt = function (A, mt)
    if type(A) ~= "table" then return A end
    local B = {}
    for k,v in pairs(A) do B[k] = deepcopymt(v, mt) end
    setmetatable(B, mt)  -- use mt
    return B
  end

uniq = function (A)
    local B = {}
    for i=1,#A do if A[i] ~= A[i-1] then table.insert(B, A[i]) end end
    return B
  end

-- (find-efunctiondescr   'mapconcat)
-- (find-elnode "Index" "* mapconcat:")
-- (find-es "lua5" "table.concat")
mapconcat = function (f, tbl, sep, n)
    return table.concat(map(f, tbl, n), sep)
  end

maplines = function (f, bigstr)
    return mapconcat(f, splitlines(bigstr), "\n")
  end

transpose = function (A)
    local TA = {}
    for k,v in pairs(A) do TA[v] = k end
    return TA
  end

-- «sorted»  (to ".sorted")
-- (find-es "lua5" "sorted")
-- (find-lua51manual "#pdf-table.sort")
-- http://lua-users.org/lists/lua-l/2011-04/msg00406.html
sorted = function (tbl, lt) table.sort(tbl, lt); return tbl end

-- «fold»  (to ".fold")
-- (find-es "lua5" "fold")
-- (find-es "haskell" "foldr")
-- (find-hugsbasefile "Prelude.hs" "\nfoldl ")
-- foldl :: (a -> b -> a) -> a -> [b] -> a
foldl = function (f, a, B, i, j)
    for k=(i or 1),(j or #B) do a = f(a, B[k]) end
    return a
  end
foldl1 = function (f, A)
    local o = A[1]
    for i=2,#A do o = f(o, A[i]) end
    return o
  end
foldr1 = function (f, A)
    local o = A[#A]
    for i=#A-1,1,-1 do o = f(A[i], o) end
    return o
  end

-- «min-and-max» (to ".min-and-max")
-- (find-lua51manual "#pdf-math.min")
-- (find-lua51manual "#pdf-math.max")
-- PP(math.min("22", "200"))  --> 22
--      PP(min("22", "200"))  --> "200"
min = function (a, b)
    if a < b then return a else return b end
  end
max = function (a, b)
    if a < b then return b else return a end
  end

Min = function (a, b) return (a and b and min(a, b)) or a or b end
Max = function (a, b) return (a and b and max(a, b)) or a or b end

minmax = function (a, b, c) return Min(a, b), Max(b, c) end

-- «table.reverse»     (to ".table.reverse")
-- «table.addentries»  (to ".table.addentries")
table.reverse = function (A)
    local B = {}
    setmetatable(B, getmetatable(A))
    for i=1,#A do B[#A-i+1] = A[i] end
    return B
  end
table.addentries = function (A, B)
    for k,v in pairs(B) do A[k] = v end
    return A
  end


-- «package.require»  (to ".package.require")
-- «edrxlib»          (to ".edrxlib")
-- Make package.require consider that this file has been loaded when
-- it was loaded by LUA_INIT=@.../LUA/lua50init.lua (see the comments
-- at the top of this file) so that we can do 'require "lua50init"' or
-- 'require "edrxlib"'...
--   (find-lua51manual "#pdf-require")
--   (find-lua51file "")
--   (find-lua51file "src/loadlib.c" "static int ll_require ")
package.loaded.lua50init =
  package.loaded.lua50init or "(loaded by LUA_INIT=@...)"
package.loaded.edrxlib =
  package.loaded.edrxlib or "(loaded by LUA_INIT=@...)"

-- «cow-and-coy» (to ".cow-and-coy")
-- (find-es "lua5" "cow-and-coy")
coy = coroutine.yield
cow = coroutine.wrap

-- «eval-and-L» (to ".eval-and-L")
-- (find-es "lua5" "lambda-with-L")
-- (find-es "lua5" "lambda-with-Code")
-- (find-LATEX "2014-1-GA-P2-gab.lua")
eval = function (str) return assert(loadstring(str))() end
expr = function (str) return eval("return "..str) end
L00 = function (args, body)
    return string.format("function (%s) return %s end", args, body)
  end
L0 = function (str)
    str = str:gsub("^%s*(%S+)%s+->", "%1 ")
    local args, body = str:match("^%s*(%S+)%s+(.*)$")
    return L00(args, body)
  end
L = function (str) return expr(L0(str)) end
--
-- An alternative definition - better, but uses a class:
-- L = Code.L
-- See: (to "Code")


-- «eoo» (to ".eoo")
-- «Class»  (to ".Class")
-- For a documented version, see:
--   (find-angg "LUA/eoo.lua")
--
Class = {
    type   = "Class",
    __call = function (class, o) return setmetatable(o, class) end,
  }
setmetatable(Class, Class)

otype_metatables = {}
otype = function (o)    -- works like type, except on my "objects"
    local  mt = getmetatable(o)
    return mt and (otype_metatables[mt] or mt.type) or type(o)
  end

-- «over0»  (to ".over0")
-- Example:
-- A = {a=22}
-- B = over(A, {b=33})
-- PP(B, A, B.b, B.a)
--   --> {"b"=33} {"a"=22} 33 22
--[[
over = function (bottomtable, toptable)
    return setmetatable(toptable or {}, {__index = bottomtable})
  end
--]]

-- «over» (to ".over")
-- (find-es "lua5" "over")
--   over(B)(A) creates this: A --> mt --> B
over = function (B)
    return function (A)
        return setmetatable(A, {__index=B})
      end
  end
Over = function (class)
    return over(class.__index)
  end

-- «methodsover»  (to ".methodsover")
-- (find-es "lua5" "methodsover")
methodsover = function (class1index)
    return function (class2index)
        local class2indexmetatable = { __index = class1index }
        setmetatable(class2index, class2indexmetatable)
        return class2index
      end
  end

-- «rawtostring»  (to ".rawtostring")
-- (find-es "lua5" "rawtostring")
rawtostring = function (o)
    if type(o) == "table" then
      local mt = getmetatable(o); setmetatable(o, nil)
      local rawtos = tostring(o); setmetatable(o, mt)
      return rawtos
    end
    return tostring(o)
  end

-- «rawtostring_comp»  (to ".rawtostring_comp")
-- Based on: (to "Tos" "comparekvs =")
rawtostring_comp = function (o1, o2)
    local t1, t2 = type(o1), type(o2)
    if t1 == t2 then
      if t1 == "number" then return o1 < o2 end
      if t1 == "string" then return o1 < o2 end
      return rawtostring(o1) < rawtostring(o2)  -- fast
    else
      return t1 < t2   -- numbers before strings before tables, etc
    end
  end

sortedkeys = function (A)
    return sorted(keys(A), rawtostring_comp)
  end



-- «Code»  (to ".Code")
-- The class Code "converts strings to executable code" in nice ways.
-- Commented version: (find-angg "LUA/Code.lua")
-- See: (to "eval-and-L")
--
Code = Class {
  type = "Code",
  from = function (src) return Code {src=src} end,
  ve   = function (src) return Code.from(src):setcodeve() end,
  vc   = function (src) return Code.from(src):setcodevc() end,
  L    = function (src) return Code.ve(src):f() end,
  __tostring = function (c) return c.src end,
  __call     = function (c, ...) return c:f()(...) end,
  __index = {
    format    = function (c, fmt) return format(fmt, c:parse2()) end,
    setcode   = function (c, fmt) c.code = c:format(fmt); return c end,
    setcodeve = function (c) return c:setcode("local %s=...; return %s") end,
    setcodevc = function (c) return c:setcode("local %s=...; %s") end, 
    f         = function (c) return assert(loadstring(c.code)) end,
    --
    pat = "^%s*([%w_,]+)%s*[%-=]>(.*)$",
    parse2 = function (c)
        local vars,rest = c.src:match(c.pat)
        if not vars then error("Code.parse2 can't parse: "..c.src) end
        return vars, rest
      end,
  },
}



-- «Tos» (to ".Tos")
-- Commented version:
-- (find-angg "LUA/Tos.lua")
--
Tos = Class {
  type    = "Tos",
  __index = {
    --
    -- Basic methods:
    --   o: object (of any type) to string
    --   ov: like o, but vertical in a simplistic way
    --   t: table to string
    --    t0: table to string, low level
    --   kvs: listofkeyvaluepairs to string
    --   kv: keyvaluepair to string
    --   k: key to string
    --
    o = function (tos, o, a,sep,b,emp)
        local ty = type(o)
        if ty=="number" then return tostring(o) end
        if ty=="string" then return format("%q", o) end
        if ty=="table"  then return tos:t(o, a,sep,b,emp) end
        return "<"..tostring(o)..">"
      end,
    ov = function (tos, o, a,sep,b,emp)
        return tos:o(o, "{ ", ",\n  ", "\n}", "{}")
      end,
    t = function (tos, T, a,sep,b,emp)
        return tos:t0(T, a,sep,b,emp)
      end,
    t0 = function (tos, T, a,sep,b,emp)
        local tableisempty = (next(T) == nil)
        if tableisempty and emp then return emp end
        local body = tos:kvs(tos:getsortedkvs(T), sep)
        return (a or "{")..body..(b or "}")
      end,
    --
    kvs = function (tos, ps, sep)
        local tos_p = function (p) return tos:kv(p) end
        return mapconcat(tos_p, ps, sep or ", ")
      end,
    kv = function (tos, p) return tos:k(p.key).."="..tos:o(p.val) end,
    k = function (tos, k) return tos:o(k) end,
    --
    -- t0 uses this to sort the key-value pairs of a table.
    getsortedkvs = function (tos, T)
        return sorted(tos:getkvs(T), tos.comparekvs)
      end,
    getkvs = function (tos, T)
        local kvs = {}
        for k,v in pairs(T) do table.insert(kvs, {key=k, val=v}) end
	return kvs
      end,
    comparekvs = function (kv1, kv2)  -- not a method!
        local k1, k2 = kv1.key,  kv2.key
        return rawtostring_comp(k1, k2)
      end,
    --
    -- return a tostring-like function
    f = function (tos, a,sep,b,emp)
        return function (o) return tos:o(o, a,sep,b,emp) end
      end,
    --
    -- An alternative to t. See the object "tosp" below.
    tp = function (tos, T, a,sep,b,emp)  -- experimental
        local mt = getmetatable(T)
        local typename = mt and mt.type
	local prefix = typename and (typename..":") or "" 
        return prefix..tos:t0(T, a,sep,b,emp)
      end,
  },
}

-- Two global objects of the class Tos.
-- To change how mytostring and PP work, replace them.
tos0 = Tos({})
tosp = Tos({t = Tos.__index.tp})

-- «mytostring»  (to ".mytostring")
-- Basic tostring-ish functions.
-- To override them, redefine these functions.
mytostring      = function (o) return tos0:o(o) end
mytostringv     = function (o) return tos0:ov(o) end
mytabletostring = function (o) return tos0:ov(o) end -- old name
--
mytostringp     = function (o) return tosp:o(o)  end
mytostringvp    = function (o) return tosp:ov(o) end
mytostringpv    = function (o) return tosp:ov(o) end

-- «mytostringm»  (to ".mytostringm")
mytostringm = function (o)
    local mt = getmetatable(o)
    if mt and mt.__tostring then return tostring(o) end
    return mytostring(o)
  end

-- «PP»  (to ".PP")
-- Basic pretty-printing functions.
-- PPV = function (o) print(mytabletostring(o)); return o end
PPPV = function (o) print(mytostringpv(o)); return o end
PPP  = function (o) print(mytostringp (o)); return o end
PPV  = function (o) print(mytostringv (o)); return o end
PP  = function (...) return PP_(mytostring, ...) end
PP_ = function (tos, ...)
    local args = pack(...)
    for i=1,args.n do printf(" %s", tos(args[i])) end
    print()
    return ...
  end



-- «VerticalTable» (to ".VerticalTable")
-- Tests: (find-es "lua5" "VerticalTable")
-- Note: this is an obsolete name, use VTable instead
VerticalTable = Class {
  type    = "VerticalTable",
  __tostring = function (vt) return mytabletostring(vt) end,
  __index = {
  },
}

-- «HTable-and-VTable»  (to ".HTable-and-VTable")
-- (find-es "lua5" "Tos-2021")
-- tos_HTable = Tos({}):f()
-- tos_VTable = Tos({}):f("{ ", ",\n  ", "\n}", "{}")
HTable = Class {
  type = "HTable",
  __tostring = mytostring,
  __index = {
  },
}
HTableP = Class {
  type = "HTableP",
  __tostring = mytostringp,
  __index = {
  },
}
VTable = Class {
  type = "VTable",
  __tostring = mytostringv,
  __index = {
  },
}
VTableP = Class {
  type = "VTableP",
  __tostring = mytostringvp,
  __index = {
  },
}

-- «VList»  (to ".VList")
-- Commented version: (find-angg "LUA/LsQuadros1.lua" "VList")
VList = Class {
  type    = "VList",
  __tostring = function (vl) return vl:tostring() end,
  __index = {
    tostring0 = function (vl) return mapconcat(mytostringm, vl, ',\n ') end,
    tostring  = function (vl) return "VList{\n "..vl:tostring0().."\n}" end,
  },
}

-- «Set» (to ".Set")
-- Commented version:
-- (find-angg "LUA/Set.lua" "Set")
--
Set = Class {
  type    = "Set",
  new = function () return Set {_={}} end,
  from = function (L) return Set.fromarray(L) end,
  fromarray = function (L)
      local C = Set.new()
      for i,v in ipairs(L) do C._[v]=v end
      return C
    end,
  __add = function (A, B)   -- union
      local C = Set.new()
      for k,v in pairs(A._) do C._[k]=v end
      for k,v in pairs(B._) do C._[k]=v end
      return C
    end,
  __sub = function (A, B)   -- difference
      local C = Set.new()
      for k,v in pairs(A._) do C._[k]=v end
      for k,v in pairs(B._) do C._[k]=nil end
      return C
    end,
  __mul = function (A, B)     -- intersection
      local C = Set.new()
      for k,v in pairs(A._) do if B._[k] then C._[k]=v end end
      return C
    end,
  __len = function (A) print"!" return #(keys(A._)) end,  -- number of elements
  __tostring = function (A)
      return "(Set with "..A:n().." elements)"
    end,
  --
  -- Methods
  __index = {
    get = function (A, k) return A._[k] end,
    has = function (A, k) return A._[k] end,
    n   = function (A) return #keys(A._) end,
    k   = function (A) return  keys(A._) end,
    ks  = function (A) return sorted(keys(A._)) end,
    ksc = function (A, sep) return table.concat(A:ks(), sep or "\n") end,
    gen = function (A)
        return cow(function ()
            for i,v in ipairs(A:ks()) do coy(v, A:get(v)) end
          end)
      end,
    add = function (A, key, val)
        A._[key] = val or key
        return A
      end,
    del = function (A, key)
        A._[key] = nil
        return A
      end,
  },
}


-- «SetL» (to ".SetL")
-- Commented version:
-- (find-angg "LUA/SetL.lua")
-- (find-angg "LUA/SetL.lua" "SetL")
--
SetL = Class {
  type = "SetL",
  new  = function () return SetL {keys={}, list={}} end,
  from = function (L) return Set.fromarray(L) end,
  fromarray = function (L)
      local C = Set.new()
      for i,k in ipairs(L) do C:add(k) end
      return C
    end,
  __len = function (setl) return setl:n() end,
  __tostring = function (setl)
      return format("(SetL with %d elements)", setl:n())
    end,
  __add = function (A, B)   -- union
      local C = SetL:new()
      for k,v in A:gen() do C:add(k, v) end
      for k,v in B:gen() do C:add(k, v) end
      return C
    end,
  __mul = function (A, B)   -- intersection
      local C = SetL:new()
      for k,v in A:gen() do if B:has(k) then C:add(k, v) end end
      return C
    end,
  __sub = function (A, B)   -- difference
      local C = SetL.new()
      for k,v in A:gen() do if not B:has(k) then C:add(k, v) end end
      return C
    end,
  --
  -- Methods
  __index = {
    get = function (setl, key) return setl.keys[key] end,
    val = function (setl, key) return setl.keys[key] end,
    has = function (setl, key) return setl.keys[key] end,
    n   = function (setl) return #setl.list end,
    k   = function (setl) return setl.list end,
    ks  = function (setl) return sorted(keys(setl.keys)) end,
    ksc = function (setl, sep) return table.concat(setl:ks(), sep or "\n") end,
    gen = function (setl) return cow(function ()
        for i,k in ipairs(setl.list) do coy(k, setl:val(k)) end
      end) end,
    add = function (setl, key, val)
        if not setl:has(key) then
          setl.keys[key] = val or key
          table.insert(setl.list, key)
        end
        return setl
      end,
  },
}


-- «Path»  (to ".Path")
-- Commented version: (find-angg "LUA/Path.lua")
-- Typical usage: Path.prepend("path", "~/LUA/?.lua")
--            or: Path.prependtopath   "~/LUA/?.lua"
--
Path = Class {
  type = "Path",
  from = function (field) return Path {field = field} end,
  prepend = function (field, fname) return Path.from(field):prepend(fname) end,
  prependtopath  = function (fname) return Path.prepend("path",  fname) end,
  prependtocpath = function (fname) return Path.prepend("cpath", fname) end,
  addLUAtopath = function () return Path.prepend("path", "~/LUA/?.lua") end,
  find = function (field, modulename)
      local modulepath = modulename:gsub("%.", "/")
      for pathentry in package[field]:gmatch("([^;]+)") do
        local filename = pathentry:gsub("%?", modulepath)
        local file = io.open(filename, "rb")
        if file then
          file:close()
          return filename
        end
      end
    end,
  __tostring = function (p) return p:tostring() end,
  __index = {
    get = function (p) return package[p.field] end,
    set = function (p, newvalue) package[p.field] = newvalue end,
    tostring = function (p, sep)
        return format("package.%s = %s", p.field, p:tostring0(sep))
      end,
    tostring0 = function (p, sep)
        return (p:get():gsub(";", sep or "\n ;"))
      end,
    toset = function (p)
        return Set.from(split(p:get(), "([^;]+)"))
      end,
    has = function (p, fname)
        return p:toset():has(fname)
      end,
    prepend0 = function (p, fname)
        p:set(ee_expand(fname)..";"..p:get())
      end,
    prepend = function (p, fname)
        if not p:has(ee_expand(fname)) then
	  p:prepend0(fname)
	end
        return p
      end
  },
}

-- «DednatRequire»  (to ".DednatRequire")
-- Used by: (to "loaddednatrequire")
-- Commented version: (find-angg "LUA/DednatRequire1.lua")
DednatRequire = {
  alreadyloaded = function (modulename)
      if package.loaded[modulename] then
        return package.loaded[modulename]
      end
    end,
  findandload = function (modulename)
      local filename = DednatRequire.find(modulename)
      if not filename then return nil end
      return DednatRequire.loadfile(modulename, filename)
    end,
  find = function (modulename)
      local modulepath = string.gsub(modulename, "%.", "/")
      for path in string.gmatch(package.path, "([^;]+)") do
        local filename = string.gsub(path, "%?", modulepath)
        local file = io.open(filename, "rb")
        if file then
          file:close()
          return filename
        end
      end
    end,
  loadfile = function (modulename, filename)
      local runcode = assert(loadfile(filename))   -- the file must exist
      local retval = runcode()                     -- and this must succeed
      package.loaded[modulename] = retval or _G    -- mark as loaded
      return package.loaded[modulename]
    end,
  --
  newrequire = function (modulename)
      return DednatRequire.alreadyloaded(modulename) -- try the method 0
          or DednatRequire.findandload(modulename)   -- try the method 1
          or oldrequire(modulename)                  -- try the oldrequire
    end,
}


-- «PrintFunction»  (to ".PrintFunction")
-- Commented version: (find-angg "LUA/PrintFunction1.lua")
--
PrintFunction = Class {
  type = "PrintFunction",
  from = function (f) return PrintFunction(debug.getinfo(f, "nSluf")) end,
  tostring = function (f) return tostring(PrintFunction.from(f)) end,
  __tostring = function (pf) return pf:tostring() end,
  __index = {
    v          = function (pf) return VTable(copy(pf)) end,
    tostring   = function (pf) return pf:_any() end,
    _shortsrc0 = function (pf) return ee_shorten(pf.short_src) end,
    _shortsrc0 = function (pf) return ee_shorten(pf.source:sub(2)) end,
    _shortsrc  = function (pf) return pf.short_src and pf:_shortsrc0() end,
    _name0     = function (pf) return pf.name and format("%q", pf.name) end,
    _name      = function (pf) return pf:_name0() or "(unknown name)" end,
    _linedef   = function (pf) return pf.linedefined end,
    _linelast  = function (pf) return pf.lastlinedefined end,
    _linecurr0 = function (pf) return pf.currentline end,
    _linecurr  = function (pf) return pf:_linecurr0()~=-1 and pf:_linecurr0() end,
    _line1     = function (pf) return pf:_linedef() end,
    _line2     = function (pf) return pf:_linecurr() or pf:_linelast() end,
    _tailcall0 = function (pf) return "[Lua] tail call" end,
    _main0     = function (pf) return "[Lua] "..pf:_shortsrc()
                                   .." line "..pf:_linecurr() end,
    _C0        = function (pf) return "[ C ] "..pf.namewhat
                                   .." C function "..pf:_name() end,
    _tbbody0   = function (pf) return (pf:_shortsrc() or "")
                               .." "..(pf:_line1() or "")
                               .." "..(pf:_line2() or "")
                               .." "..(pf.namewhat or "")
                               .." "..(pf.name or "") end,
    _tbbody    = function (pf) return rtrim(pf:_tbbody0()) end,
    _findluatb = function (pf) return format('(find-luatb \"%s\")', pf:_tbbody()) end,
    _any       = function (pf)
        if pf.short_src == "[C]"         then return pf:_C0() end
        if pf.what      == "main"        then return pf:_main0() end
        if pf.short_src == "(tail call)" then return pf:_tailcall0() end
        return pf:_findluatb()
      end,
  },
}


-- «DGetInfo»  (to ".DGetInfo")
-- Commented version: (find-angg "LUA/DGetInfo1.lua")
-- Idea: running something like
--
--   dgi = DGetInfo.atlevel(99, "getvalues")
--
-- calls debug.getinfo and debug.getlocal to get a lot of information
-- about the stack frame at level 99, and puts that information in a
-- static object that is easy to inspect. This class is used by the
-- class DGetInfos, defined below.
--
DGetInfo = Class {
  type = "DGetInfo",
  what = "nSluf",
  new  = function (A) return DGetInfo(A or {}) end,
  --
  atlevel = function (lvl, getvalues)
      local dgi = debug.getinfo(lvl, DGetInfo.what)
      if not dgi then return end
      if getvalues then dgi.values = {} end
      for i=1,1000 do
	local name,value = debug.getlocal(lvl, i)
        if not name then break end
	dgi[i] = name
        if getvalues then dgi.values[i] = value end
      end
      return DGetInfo(dgi)
    end,
  fromfunction = function (f)
      local dgi = debug.getinfo(f, DGetInfo.what)
      return DGetInfo(dgi)
    end,
  --
  --  
  __tostring = function (dgi) return dgi:tostring() end,
  __index = {
    tostring = function (dgi) return dgi:tb() end,
    --
    -- «DGetInfo-method»  (to ".DGetInfo-method")
    -- method = "fvtb",
    -- method = "prosodytb",
    -- (find-angg "LUA/Prosody1.lua" "Prosody")
    method    = "luatb",
    tb        = function (dgi) return dgi[dgi.method](dgi) end,
    tbi       = function (dgi, i) return format("%2d -> %s", i, dgi:tb()) end,
    prosodytb = function (dgi) return Prosody.traceback1(dgi) end,
    fvtb      = function (dgi) return dgi:funname().." :: "..dgi:vars() end,
    --
    -- «DGetInfo-luatb»  (to ".DGetInfo-luatb")
    -- See: (find-angg ".emacs" "find-luatb")
    luatb = function (dgi)
        if dgi.short_src == "[C]"         then return dgi:luatb_C() end
        if dgi.what      == "main"        then return dgi:luatb_main() end
        if dgi.short_src == "(tail call)" then return dgi:luatb_tailcall() end
        return dgi:luatb_other()
      end,
    luatb_tailcall = function (dgi)
        return "[Lua] tail call"
      end,
    luatb_main = function (dgi)
        return "[Lua] "..dgi.short_src
             .." line "..dgi.currentline
      end,
    luatb_C = function (dgi)
        return "[ C ] "       ..dgi.namewhat
              .." C function "..dgi:luatb_name()
      end,
    luatb_other0 = function (dgi)
        return        (dgi:shortsrc() or "")
               .." "..(dgi:luatb_line1() or "")
               .." "..(dgi:luatb_line2() or "")
               .." "..(dgi.namewhat or "")
               .." "..(dgi.name or "")
          end,
    luatb_other = function (dgi)
        return format('(find-luatb \"%s\")', rtrim(dgi:luatb_other0()))
      end,
    luatb_name = function (dgi)
        return dgi.name and format("%q", dgi.name) or "(unknown name)"
      end,
    luatb_line1 = function (dgi) return dgi.linedefined end,
    luatb_line2 = function (dgi)
        if dgi.currentline == -1 then return dgi.lastlinedefined end
        return dgi.currentline
      end,
    --
    shortsrc = function (dgi)
        return dgi.short_src and ee_shorten(dgi.short_src)
      end,
    funname = function (dgi) return dgi.name or "(noname)" end,
    vars  = function (dgi) return table.concat(dgi, " ") end,
    varns = function (dgi)
        local namens = {}
        for i,name in ipairs(dgi) do namens[name] = i end
        return namens
      end,
    vs = function (dgi)
        local values = VTableP({})
        for i,name in ipairs(dgi) do values[name] = dgi.values[i] end
        return values
      end,
    v = function (dgi, name)
        local n = dgi:varns()[name] or error("Bad var name: "..tostring(name))
        return dgi.values[n]
      end,
    --
    find_fline = function (dgi, line)
        local src = dgi:shortsrc()
        return format("(find-fline \"%s\" %d)", src, line)
      end,
    fline = function (dgi)
        local l0  = dgi.linedefined
        local l1  = dgi.currentline
        local l2  = dgi.lastlinedefined
        return dgi:find_fline(l1)
      end,
    --
    -- 2022jul17:
    info = function (dgi, tostr)
        return pformat("spec: %s\nsrc: %s\n%s", dgi, dgi:fline(), dgi:infovalns(tostr))
      end,
    infovaln = function (dgi, n, tostr)
        tostr = tostr or mytostring
        return format(" %d %q: %s", n, dgi[n], tostr(dgi.values[n]))
      end,
    infovalns = function (dgi, tostr)
        local f = function (i) return dgi:infovaln(i, tostr) end
        return mapconcat(f, seq(1, #dgi), "\n")
      end,
  },
}


-- «DGetInfos»  (to ".DGetInfos")
-- Commented version:
--   (find-angg "LUA/DGetInfo1.lua" "DGetInfos")
--   (find-angg "LUA/DGetInfo1.lua" "DGetInfos-tests")
-- Idea: running something like
--
--   dgis = DGetInfos.newv()
-- 
-- runs lots of "debug.getinfo()"s and "debug.getlocal"s via DGetInfo,
-- and returns a static structure that can be inspected in a repl,
-- both inside an error handler and post-mortem.
--
DGetInfos = Class {
  type = "DGetInfos",
  new  = function (getvalues) return DGetInfos({}):getinfos(getvalues) end,
  newv = function () return DGetInfos.new("getvalues") end,
  __tostring = function (dgis) return dgis:tostring() end,
  __index = {
    getinfos = function (dgis, getvalues)
        dgis.infos = {}
        for i=0,1000 do
          dgis[i] = DGetInfo.atlevel(i, getvalues)
          if not dgis[i] then return dgis end
        end
      end,
    firstsuch = function (dgis, f)
        for i=0,#dgis do
          if f(dgis[i], i) then return i end
        end
      end,
    setbase = function (dgis, f)
        local z = dgis:firstsuch(f)
        if not z then error("setbase: not found") end
        dgis.base = z
        return dgis
      end,
    --
    seq = function (dgis, a, b, dir)
        a,b = (a or #dgis),(b or 0)
        dir = dir or (a <= b and 1 or -1)
        return seq(a, b, dir)
      end,
    tostring = function (dgis, a, b, dir)
        local f = function (i) return dgis[i]:tbi(i) end
        return mapconcat(f, dgis:seq(a, b, dir), "\n")
      end,
    --
    tb  = function (dgis, a, b, dir) return dgis:tostring(a, b, dir) end,
    tbn = function (dgis, a, b, dir) return dgis:tostring(a, b, dir) end,
  },
}



-- «Rect» (to ".Rect")
-- Commented version: (find-angg "LUA/Rect.lua")
-- Old notes:         (find-es "lua5" "Rect")
-- An old version:    (find-es "lua5" "Rect-2019")
--
torect = function (o)
    if otype(o) == "Rect" then return o end
    if type(o) == "string" then return Rect.new(o) end
    error()
  end
--
Rect = Class {
  type = "Rect",
  new  = function (str) return Rect(splitlines(str)) end,
  rep  = function (str, n) local r=Rect{}; for i=1,n do r[i]=str end; return r end,
  from = function (o)
      if type(o) == "string" then return Rect.new(o) end
      if type(o) == "number" then return Rect.new(tostring(o)) end
      return o -- missing: test otypeness
    end,
  --
  -- A hack to let us build syntax trees very quickly:
  syntree = function (op, a1, ...)
      if not a1 then return Rect.from(op) end
      local r = Rect.from(a1):syn1(op)
      for _,an in ipairs({...}) do r = r:synconcat(Rect.from(an)) end
      return r
    end,
  --
  __tostring = function (rect) return rect:tostring() end,
  __concat = function (r1, r2) return torect(r1):concat(torect(r2)) end,
  __index = {
    tostring = function (rect) return table.concat(rect, "\n") end,
    copy = function (rect) return copy(rect) end,
    width = function (rect)
        return rect.w or foldl(max, 0, map(string.len, rect))
      end,
    push1 = function (rect, str) table.insert(rect, 1, str); return rect end,
    push2 = function (rect, str1, str2) return rect:push1(str2):push1(str1) end,
    pad0  = function (rect, y, w, c, rstr)
        rect[y] = ((rect[y] or "")..(c or " "):rep(w)):sub(1, w)..(rstr or "")
        return rect
      end,
    lower = function (rect, n, str)
        for i=1,n do rect:push1(str or "") end
        return rect
      end,
    concat = function (r1, r2, w, dy)
        r1 = r1:copy()
        w = w or r1:width()
        dy = dy or 0
        for y=#r1+1,#r2+dy do r1[y] = "" end
        for y=1,#r2 do r1:pad0(y+dy, w, nil, r2[y]) end
        return r1
      end,
    prepend = function (rect, str) return Rect.rep(str, #rect)..rect end,
    --
    -- Low-level methods for building syntax trees:
    --   syn1 draws a "|" above a rect and draws the opname above it,
    --   synconcat draws two syntax trees side by side and joins them with "_"s.
    syn1 = function (r1, opname) return r1:copy():push2(opname or ".", "|") end,
    synconcat = function (r1, r2)
        return r1:copy():pad0(1, r1:width()+2, "_")..r2:copy():push2(".", "|")
      end,
    --
    -- Low-level methods for building deduction trees:
    --   dedconcat draws two deduction trees side by side,
    --   dedsetbar draws or redraws the bar above the conclusion,
    --   dedaddroot adds a bar and a conclusion below some trees drawn
    --   side by side.
    dedconcat = function (r1, r2)
        local w = r1:width() + 2
        if #r1 <  #r2 then return r1:copy():lower(#r2-#r1):concat(r2, w) end
        if #r1 == #r2 then return r1:copy():concat(r2, w) end
        if #r1  > #r2 then return r1:copy():concat(r2, w, #r1-#r2) end
      end,
    dedsetbar = function (r, barchar, barname)
        if #r == 1 then table.insert(r, 1, "") end
        local trim = function (str) return (str:match("^(.-) *$")) end
        local strover  = trim(r[#r-2] or "")  -- the hypotheses above the bar
        local strunder = trim(r[#r])          -- the conclusion below the bar
        local len = max(#strover, #strunder)
	local bar = (barchar or "-"):rep(len)
        r[#r-1] = bar..(barname or "")
        return r
      end,
    dedaddroot = function (r, rootstr, barchar, barname)
        table.insert(r, "")                  -- The bar will be here.
        table.insert(r, rootstr)             -- Draw the conclusion,
        return r:dedsetbar(barchar, barname) -- and then set the bar.
      end,
  },
}

-- «SynTree»  (to ".SynTree")
-- Commented version:
-- (find-angg "LUA/Rect.lua")
-- (find-angg "LUA/Rect.lua" "SynTree")
--
SynTree = Class {
  type = "SynTree",
  from = function (A) return deepcopymt(A, SynTree) end,
  torect = function (o)
      if type(o) == "number" then return Rect.new(tostring(o)) end
      if type(o) == "string" then return Rect.new(o) end
      if type(o) == "table" then
	local op = o[0]
	if type(op) == "number" then op = tostring(op) end
        if #o == 0 then return Rect.new(op or ".") end
        local r = SynTree.torect(o[1]):syn1(op)
        for i=2,#o do r = r:synconcat(SynTree.torect(o[i])) end
        return r
      end
    end,
  __tostring = function (o) return o:torect():tostring() end,
  __index = {
    torect = function (o)
        return SynTree.torect(o)
      end,
  },
}


-- «DedTree»  (to ".DedTree")
-- Commented version:
-- (find-angg "LUA/Rect.lua")
-- (find-angg "LUA/Rect.lua" "DedTree")
--
DedTree = Class {
  type = "DedTree",
  from = function (A) return deepcopymt(A, DedTree) end,
  torect = function (o)
      if type(o) == "number" then return Rect.new(tostring(o)) end
      if type(o) == "string" then return Rect.new(o) end
      if type(o) == "table" then
        if #o == 0 then
          local r = DedTree.torect(o[0] or "?")
          r:dedsetbar(o.bar, o.label)
          return r
        else
          r = DedTree.torect(o[1])
          for i=2,#o do r = r:dedconcat(dedtorect(o[i])) end
          return r:dedaddroot(o[0] or "?", o.bar, o.label)
        end
      end
      error()
    end,
  __tostring = function (o) return o:torect():tostring() end,
  __index = {
    torect = function (o)
        return DedTree.torect(o)
      end,
  },
}





-- «re_expand_INFIX» (to ".re_expand_INFIX")
-- (find-es "lua-intro" "lpeg-re-infix-2")
-- (find-angg "LUA/Re-infix.lua" "preproc_infix")
re_expand_INFIX_0 = function (parenstr)
    local components = split(parenstr:sub(2, -2))
    local e     = table.remove(components, 1)
    local sep   = table.remove(components, 1)
    local ops   = components
    local quote = function (str) return '"'..str..'"' end
    local oneop = function (ops) return mapconcat(quote, ops, " / ") end
    local tbl   = {E=e, SEP=sep, OP=oneop(ops)}
    local re    = string.gsub("(E s ({OP} SEP E)*)", "[A-Z]+", tbl)
    return re
  end
re_expand_INFIX = function (gram)
    return (string.gsub(gram, "INFIX(%b())", re_expand_INFIX_0))
  end

-- «math-grammar» (to ".math-grammar")
-- (find-gab "gab.lua" "lpeg-parser")
-- (find-gabfile "gab.lua" "Expr.__index.infix =")
-- Missing: _, __, (), {|,,}, {,,}, Fa/Ex/Lambda, :, not, unary-
math_grammar_0 = [[
  e75 <- INFIX( e70 s   |                ) -> f_nonassoc
  e70 <- INFIX( e65 s   ,                ) -> f_nary
  e65 <- INFIX( e60 s   <-               ) -> f_nonassoc
  e60 <- INFIX( e55 s   ->               ) -> f_nonassoc
  e55 <- INFIX( e50 s   or               ) -> f_left
  e50 <- INFIX( e45 s   &                ) -> f_left
  e45 <- INFIX( e40 s   not              ) -> f_OOOOOOOOOOOOPS
  e40 <- INFIX( e35 s   in               ) -> f_nonassoc
  e35 <- INFIX( e30 s   <= < == != >= >  ) -> f_nary
  e30 <- INFIX( e25 s   + -              ) -> f_left
  e25 <- INFIX( e20 s   // / *           ) -> f_left
  e20 <- INFIX( e15 s   ^                ) -> f_right
]]



-- «Re»  (to ".Re")
-- Commented version:
-- (find-angg "LUA/Re.lua")
-- (find-angg "LUA/Re.lua" "Re-tests")
--
Re = Class {
  type = "Re",
  __tostring = function (r) return mytostringv(r) end,
  __call = function (r, subj, init) return r:test(subj, init) end,
  --
  __index    = {
    grammar = "",
    defs    = {},
    preproc = function (res0) return res0 end,
    --
    -- Every call to r:compile(str) overwrites
    -- the fields r.res0, r.res, and r.rec of r.
    compile = function (r, res0)
        local res = r.preproc(res0) .. r.grammar
        r.res0 = res0
        r.res  = res
        if res == res0 then r.res0 = nil end
        r.rec = re.compile(r.res, r.defs)
        return r
      end,
    match = function (r, subj, init)
        return r.rec:match(subj, init)
      end,
    test = function (r, subj, init)
        if    r.print
        then (r.print)(r:match(subj, init))
        else return    r:match(subj, init)
        end
      end,
    --
    p = function (r, ...) print(r.res) end,
    c = function (r, ...) return r:compile(...) end,
    cc = function (r, ...) return copy(r):compile(...) end,
  },
}


-- «strlen8» (to ".strlen8")
-- (find-es "lua5" "utf8")
string.len8 = function (str) return str:gsub("[\128-\191]+", ""):len() end
strlen8 = string.len8

-- «untabify»  (to ".untabify")
-- Note: to untabify strings in encodings where chars can be more than
-- 1-byte long, change the "strlen" below... (I never had to do that,
-- though).
untabify_table =
  {"        ", "       ", "      ", "     ", "    ", "   ", "  ", " "}
--{"--------", "-------", "------", "-----", "----", "---", "--", "-"}
untabify_strtab = function (strbeforetab)
    return strbeforetab ..
      untabify_table[math.fmod(strlen(strbeforetab), 8) + 1]
  end
untabify = function (str)
    return (gsub(str, "([^\t\r\n]*)\t", untabify_strtab))
  end

-- «untabify8» (to ".untabify8")
untabify8_strtab = function (strbeforetab)
    return strbeforetab ..
      untabify_table[math.fmod(strlen(strbeforetab), 8) + 1]
  end
untabify8 = function (str)
    return (gsub(str, "([^\t\r\n]*)\t", untabify_strtab))
  end


-- «utf8tohtml» (to ".utf8tohtml")
-- (find-es "lua5" "utf8-to-html")
utf8pat   = "[\192-\253][\128-\191]+"
utf8ctohtml = function (u)
    local a, b = u:byte(1, 2)
    local code = (a-192)*64+(b-128)
    return format("&#x%X;", code)
  end
utf8tohtml0 = function (str)
    return (str:gsub(utf8pat, utf8ctohtml))
  end
utf8tohtml = function (str)
    local str2 = str:gsub("[&<>]", {["&"]="&amp;", ["<"]="&lt;", [">"]="&gt;"})
    return utf8tohtml0(str2)
  end

-- «u8c_to_l1» (to ".u8c_to_l1")
-- (find-es "charsets" "l1_to_u8")
u8c_l1_pat = "[\194-\195][\128-\191]"
u8c_to_code = function (u)
    local a, b = u:byte(1, 2)
    return (a-192)*64+(b-128)
  end
u8c_to_l1 = function (u)
    return string.char(u8c_to_code(u))
  end
measure_utf8_ness = function (bigstr)
    local bigstr_, n_u8_l1_pairs = bigstr:gsub(u8c_l1_pat, "")
    local bigstr__, n_other_l1s = bigstr_:gsub("[\128-\255]", "")
    return n_u8_l1_pairs, n_other_l1s
  end

-- «u8_to_l1» (to ".u8_to_l1")
-- (find-es "charsets" "u8_to_l1")
-- (ee-insert '(128 255))
-- (find-einsert '((128 255)))
-- (find-einsert '((128 191)))
-- (find-einsert '((196 255)))
-- u8_to_l1 = function (str)
--     local f = function (cc) return string.char(cc:byte(2)+64) end
--     return (str:gsub("\195[\128-\191]", f))
--   end
u8_to_l1 = function (bigstr)
    return (bigstr:gsub(u8c_l1_pat, u8c_to_l1))
  end
u8_to_l1_maybe = function (bigstr)
    local ngoodpairs, nbadchars = measure_utf8_ness(bigstr)
    if ngoodpairs > 0 and nbadchars == 0 then return u8_to_l1(bigstr) end
    return bigstr
  end


-- «toslashhex» (to ".toslashhex")
toslashhex1 = function (c) return format("\\%d", string.byte(c)) end
toslashhex  = function (str) return (str:gsub("[\128-\255]", toslashhex1)) end

-- «divmod» (to ".divmod")
-- http://lars.nocrew.org/forth2012/core/DivMOD.html
divmod = function (a, b) return (a-(a%b))/b, a%b end


-- «loadblogme3» (to ".loadblogme3")
-- (find-es "blogme" "interactive")
-- (find-angg ".emacs" "blogme3")
loadblogme3 = function (msg)
    blogmedir = ee_expand "~/blogme3/"
    ee_dofile "~/blogme3/blogme3.lua"
    b = doblogme
    if msg then print 'See: (find-es "blogme" "interactive")' end
  end
loadblogme3rest = function ()
    pathtoroot    = getpathtoroot("")
    eevarticle    = pathto("eev-article.html")
    eepitchreadme = pathto("eev-current/eepitch.readme.html")
    eepitch_el    = pathto("eev-current/eepitch.el.html")
    eevintrosdir  = pathto("eev-intros/")
    require "angglisp"
  end
loadblogme3all = function (msg)
    loadblogme3(msg)
    loadblogme3rest()
  end

-- «savevars»  (to ".savevars")
-- (find-es "lua5" "savevars")
savevars = function (restorefromargs, ...)
    local values = pack(...)
    local restorevars = function () restorefromargs(unpack(values)) end
    return restorevars
  end




--   __                            _   
--  / _| ___  _ __ _ __ ___   __ _| |_ 
-- | |_ / _ \| '__| '_ ` _ \ / _` | __|
-- |  _| (_) | |  | | | | | | (_| | |_ 
-- |_|  \___/|_|  |_| |_| |_|\__,_|\__|
--                                     
-- «variants-of-format»  (to ".variants-of-format")
-- See also: (find-es "lua5" "formatt-and-printt")
--           (find-dn6 "output.lua" "formatt")

-- «minus-0»  (to ".minus-0")
-- (find-es "lua5" "minus-0-email")
-- http://lua-users.org/lists/lua-l/2022-05/msg00082.html
-- truncn = function (n) return trunc0(string.format("%.3f", n)) end
-- truncn = function (n) return trunc0(string.format("%.3f", fix0(n))) end
fix0 = function (x) if (x == 0) then return 0 else return x end end

-- «trailing-zeroes» (to ".trailing-zeroes")
-- «pformat» (to ".pformat")
-- (find-es "lua5" "string.format")
-- (find-es "lua5" "pformat")
trunc0 = function (str) return str:reverse():gsub("^0*%.?", ""):reverse() end
truncn = function (n) return trunc0(string.format("%.3f", n)) end
myntos = function (n) return trunc0(string.format("%.3f", n)) end
pformat1 = function (o)
    if type(o) == "number" then return truncn(o) end
    return tostring(o)
  end
pformatargs = function (...)
    local n = select("#", ...)
    return myunpack(map(pformat1, {...}, n), 1, n)
  end
pformat = function (fmt, ...)
    return format(fmt, pformatargs(...))
  end
pformatexpr = function (exprstr)
    return table.concat(map(pformat1, {expr(exprstr)}))
  end

-- «dformat»  (to ".dformat")
-- (find-es "lua5" "dformat")
-- In Lua5.3 this yields an error instead of truncating the 2.3 to an integer:
--   string.format("foo %d bar", 2.3)
-- This quick hack lets my use
--   string.dformat("foo %d bar", 2.3)   -- or:
--          dformat("foo %d bar", 2.3)
-- to get the old behavior in any (?) version of Lua.
--
if _VERSION:sub(5) < "5.3" then
  dformat_fmt = function (fmt) return fmt end
  string.dformat = string.format
  dformat        = string.format
else
  dformat_fmt = function (fmt) return (fmt:gsub("%%d", "%%.0f")) end
  string.dformat = function (fmt, ...)
      return string.format(dformat_fmt(fmt), ...)
    end
  dformat = string.dformat
end








-- (find-lua53manual "#8" "integer subtype")
toint    = math.floor        -- for 5.3

-- «string-methods»  (to ".string-methods")
-- A note about "string methods": if s is a string, then a piece of
-- code like "s:rep(2)" works like "string.rep(s, 2)"; this is a
-- Lua-5.1-ism that is not described in the first edition of PiL - the
-- one that is online, that covers only Lua 5.0. When we do
--
--   s = "foo"
--   print(s:rep(2))
--
-- then the "s:rep(2)" is syntax sugar for 's["rep"](s,2)'. At first
-- sight, the table access s["rep"] should fail, but in 5.1 strings
-- have a metatable like this:
--
--   setmetatable("str", {__index = string})
--
-- and so instead of failing Lua does something else... the s["rep"]
-- becomes getmetatable(s).__index["rep"], and that is just
-- string["rep"], i.e., string.rep; so, s:rep(2) works like
-- string.rep(s, 2).
--
-- See:
-- (find-lua51manual "#2.2"   "a.name as syntactic sugar")
-- (find-lua51manual "#2.5.8" "v:name(args)" "v.name(v,args)")
-- (find-lua51manual "#2.8" "Tables and userdata have individual metatables")
-- (find-lua51manual "#2.8" "table[key]" "h = metatable(table).__index")
-- (find-lua51manual "#5.4" "object-oriented style" "s:byte(i)")
-- (find-lua51manual "#pdf-string.rep")
-- (find-pilw3m "13.4.1.html" "The __index Metamethod")



-- «otherfunctions»  (to ".otherfunctions")

-- «0-based»  (to ".0-based")
-- (find-es "lua5" "0-based")
-- 0-based string functions.
-- (To do: remove this! I think I only use 0-based string functions at
--  dednat4 - and now I'm almost getting used to the 1-based
--  conventions...)
-- (find-sh "lua -e \"print(substr0('abcdef', 2, 3)) --> cde\"")
substr0 = function (str, start0, len)
    return string.sub(str, start0 + 1, len and start0 + len)
  end



-- «P-old»  (to ".P-old")
-- Like "print", but distinguishing strings from numbers, and using "<>"s.
-- See: (find-lua51manual "#pdf-type")
-- Examples:
--  print(nil, 22, "33", {}, false, print)
-->  nil   22   33   table: 0x806da60   false   function: 0x806b388
--  P(nil, 22, "33", {}, false, print)
-->  <nil> 22 "33" <table> <boolean> <function>
--
P = function (...)
    local arg = arg or pack(...)   -- for Lua 5.2
    for i=1,arg.n do
      local v = arg[i]
      if     type(v)=="number" then printf(" %d", v)
      elseif type(v)=="string" then printf(" %q", v)
      else printf(" <%s>", type(v))
      end
    end
    print()
  end

-- «P-old-tests»  (to ".P-old-tests")
-- P(string.find("0123456789", "3(45)(67)", 4))  --> 4 8 "45" "67"
-- P(string.find("0123456789", "3(45)(67)", 5))  --> <nil>

-- Note: in Lua5.0 "table.foreach(t, print)" could be used to inspect tables.
-- Ref: http://lua-users.org/lists/lua-l/2008-02/msg00932.html
--      http://lua-users.org/lists/lua-l/2008-02/msg00944.html

-- «PP-old»  (to ".PP-old")
-- 2015aug20: oveeriden by: (to "Tos")
-- (to "mytostring")
-- My favourite function for inspecting data!
-- This is like "print" too, but it uses "mytostring" to print the
-- contents of tables recursively. The output format is compact,
-- human-friendly, and simple to understand and to implement. Note: on
-- cyclic structures "mytostring" will loop and break; and metatables
-- are ignored (I use them very rarely, btw).
-- Examples:
--  PP(nil, true, false, 22, "22", "a\nb", print, nil)
-->   <nil> <true> <false> 22 "22" "a\
--    b" <function: 0x806b388> <nil>
--
--  PP({44, 55, nil, 77, [{a=11}]={[22]="b"}, [{}]={}, [{}]={}})
-->    {1=44, 2=55, 4=77, {"a"=11}={22="b"}, {}={}, {}={}}
--

-- PP = function (...)
--     -- local arg = arg or pack(...)   -- for Lua 5.2
--     local arg = pack(...)
--     for i=1,arg.n do printf(" %s", mytostring(arg[i])) end
--     printf("\n")
--     return myunpack(arg)    -- todo: change to "..." (a 5.1-ism)
--   end

-- «PPP-old»  (to ".PPP-old")
-- Useful for debugging sometimes.
-- I haven't used this in ages.
-- I reused the name for something else.
-- PP(string.rep("ab", 4))
-->              "abababab"
-- PP(string.rep(PPP("rep:")("ab", 4)))
-->                   (rep: "ab" 4)"abababab"
--
-- PPP = function (idstr)
--     return function (...)
--         printf("(%s", idstr)
--         for i=1,arg.n do printf(" %s", mytostring(arg[i])) end
--         printf(")")
--         return unpack(arg)
--       end
--   end

-- «follow» (to ".follow")
follow = function (o, str)
    local w, rest = str:match("(%S+)%s*(.*)")
    if not w then return o end
    if w == "()" then return follow(o(), rest) end
    if w == "{}" then return follow(o{}, rest) end
    if w == "mt" then return follow(getmetatable(o), rest) end
    return follow(o[w], rest)
  end

-- «NamedFunction» (to ".NamedFunction")
-- (find-es "lua5" "NamedFunction")
-- Obsolete, superseded by: (to "Code")
--               (find-angg "LUA/Code.lua")
--               (find-angg "LUA/Code.lua" "Code-tests")
--
NamedFunction = Class {
  type    = "NamedFunction",
  __tostring = function (o) return o.name end,
  __call     = function (o, ...) return o.f(...) end,
  __index = {
  },
}
lambda = function (str)
    local vars,rest = str:match "^ *([%w_,]*)[ .:]*(.-) *$"
    local body = rest:gsub("=>", " return ")
    local code = "return function ("..vars..")\n"..body.."\nend"
    local name = "("..vars..": "..rest..")"
    local f = assert(loadstring(code))()
    -- return NamedFunction {name=name, f=f}
    return NamedFunction {name=name, code=code, f=f}
  end


-- «envsubst»  (to ".envsubst")
-- (find-es "lua5" "envsubst")
-- Obsolete?
setenv_ = {}
setenv = function (varname, value) setenv_[varname] = value end
getenv = function (varname) return setenv_[varname] or os.getenv(varname) end
envsubst = function (str)
     return string.gsub(str, "%$([%a_][%w_]*)", function (e)
         return getenv(e) or ""
       end)
   end

-- «mytostring-old»  (to ".mytostring-old")
-- My old versions of "mystotring", that didn't use metatables, are here:
--   (find-angg "LUA/tos.lua")
--   (find-angg "LUA/tos2.lua")
-- The current version of mystotring is implemented using the class Tos.

-- These functions are used by: (to "PP")
-- Possible replacements:
--   (find-dn5 "tos.lua")



-- «ee_loadlib»  (to ".ee_loadlib")
ee_loadlib = function (libname, funcname)
    return assert(package.loadlib(ee_expand(libname), funcname))()
  end

-- «ee_ls» (to ".ee_ls")
-- (find-es "lua5" "posix-ls")
ee_ls = function (dir)
    userocks()
    require "posix"
    return (posix.dir(ee_expand(dir)))
  end



-- «load_dednat4»  (to ".load_dednat4")
-- See: (to "loaddednat6")
-- (find-angg ".emacs" "eepitch-dednat4")
-- (find-es    "xypic" "eepitch-dednat4")
-- (find-dn4 "dednat4.lua" "diag-head")
-- (find-dn4 "dednat4.lua" "abbrev-head")
-- (find-dn4 "dednat4.lua" "tree-head" "treeheadcode1")
-- (find-dn4 "dednat4.lua" "processfile")
-- (defun eepitch-dednat4 () (interactive) (eepitch-comint "dednat4" "lua51 -e load_dednat4() -i"))
-- (eepitch-kill)
-- (eepitch-dednat4)
load_dednat4 = function ()
    dednat4dir = dednat4dir or ee_expand("~/dednat4/")
    print("Loading: " .. dednat4dir .. "dednat4.lua")
    dofile(dednat4dir .. "dednat4.lua")
    A  = function (abbrev, expansion) addabbrev(abbrev, expansion) end
    D  = function (linestr) dofs(untabify(linestr)) end
    DX = function (linestr) dxy2Dx(untabify(linestr)) end
    D2 = function (linestr) dxy2D(untabify(linestr)) end
  end


-- «load_posix»  (to ".load_posix")
-- This is for lua-5.0, for 5.1 see: (to "loadposix")
-- (find-es "lua5" "load_posix")
-- (find-es "lua5" "posix-install")
load_posix = function ()
    userocks(); require "posix"
    -- assert(loadlib(getenv("HOME").."/.lua50/lposix.so", "luaopen_posix"))()
  end

-- «load_PP»  (to ".load_PP")
-- Load PP.so, that defines a C function called PP for inspecting the stack.
-- Old version, for lua-5.0:
-- -- (find-angg ".lua50/PP.c")
--    load_PP = function ()
--        assert(loadlib(getenv("HOME").."/.lua50/PP.so", "PP_init"))()
--      end
-- New version, for lua-5.1:
load_PP = function ()
    assert(package.loadlib(getenv("HOME").."/.lua51/PP.so", "PP_init"))()
  end
-- 2008dec01: load_PP is not needed for debugging anymore!...
-- The user-defined GDB command `PP' used to call the C function `PP',
-- that was defined in PP.c/PP.so - but I changed the GDB `PP' to make
-- it run directly all the calls to Lua that the C `PP' used to make.
-- See: (find-angg ".lua51/PP.c")
--      (find-angg ".lua51/PP.gdb")

-- «PPeval»  (to ".PPeval")
-- (find-angg ".lua51/PP.gdb" "PPeval")
-- (find-lua51file "src/lua.c" "first line starts with `=' ?")
PPeval = function (str)
    local e, code = string.match(str, "^(=?=?)(.*)$")
    local eval = function (str) return assert(loadstring(str))() end
    if     e == "==" then    PP(eval("return "..code))
    elseif e == "="  then print(eval("return "..code))
    else   return eval(code)
    end
  end

-- «loadlpeg»  (to ".loadlpeg")
-- (find-es "lua5" "lpeg-0.7")
-- (find-es "lua5" "lpeg-0.8.1")
-- (find-es "lua5" "lpeg-0.9")
-- (find-es "lua5" "lpeg")
loadlpeg = function ()
    local oldcpath = package.cpath
    package.cpath = ee_expand("~/usrc/lpeg-0.9/?.so")..";"..oldcpath
    require "lpeg"
    package.cpath = oldcpath
    lpeg.test  = function (pat, str) PP(pat:C():match(str)) end
    lpeg.testt = function (pat, str) PP(pat:Ct():match(str)) end
    lpeg.togsub   = lpeg_togsub     -- (to "lpeg_togsub")
    lpeg.gsub     = lpeg_gsub       -- (to "lpeg_gsub")
    lpeg.gsub_    = lpeg_gsub_      -- (to "lpeg_gsub_")
    lpeg.Balanced = lpeg_balanced   -- (to "lpeg_balanced")
  end

-- «loadlpegrex»  (to ".loadlpegrex")
-- (find-es "lpeg" "lpegrex")
loadlpegrex = function (dir)
    dir = dir or "~/usrc"
    Path.prepend("path",  dir.."/lpeglabel/?.lua")
    Path.prepend("cpath", dir.."/lpeglabel/?.so")
    Path.prepend("path",  dir.."/lpegrex/?.lua")
    lpegrex = require 'lpegrex'
  end

-- «loadpegdebug»  (to ".loadpegdebug")
-- (find-es "lpeg" "pegdebug")
loadpegdebug = function ()
    Path.prepend("path", "~/usrc/PegDebug/src/?.lua")
    lpeg     = require "lpeg"
    pegdebug = require "pegdebug"
  end

-- «loadbitlib»  (to ".loadbitlib")
-- Obsolete. See: (find-es "lua5" "bitlib-51")

-- «autoload»  (to ".autoload")
-- Obsolete.

-- «loadtcl»  (to ".loadtcl")
-- Obsolete.
-- -- (find-es "lua5" "luatclbridge")
-- -- (find-angg "LUA/luatclbridge.c")
-- -- loadtcl = function ()
-- --     local filename = ee_expand("~/LUA/tlbridge.so")
-- --     local initname = "luaopen_tlbridge"
-- --     tcl = tcl or assert(package.loadlib(filename, initname))()
-- --   end
-- loadtcl = function ()
--     -- local filename = ee_expand("~/LUA/luatclbridge.so")
--     local filename = ee_expand("~/.lua51/luatclbridge.so")
--     local initname = "luaopen_luatclbridge"
--     if not tcl then
--       tcl, tclfindexecutable = assert(package.loadlib(filename, initname))()
--       tclfindexecutable("/home/edrx/usrc/tk8.4/tk8.4-8.4.12/unix/wish") -- test
--     end
--   end
-- loadtk     = function () loadtcl(); return tcl("package require Tk") end
-- loadexpect = function () loadtcl(); return tcl("package require Expect") end
-- loadsnack  = function () loadtcl(); return tcl("package require sound") end
-- -- (find-es "tcl" "snack")
-- -- (find-anggfile "TCL/piano.tcl")


-- «loadldb»  (to ".loadldb")
-- Obsolete.
-- -- (find-es "lua5" "ldb-from-tgz")
-- -- (find-es "lua5" "ldb")
-- loadldb = function ()
--     local oldpath = package.path
--     -- package.path = ee_expand("$S/http/primero.ricilake.net/lua/?.lua")
--     -- package.path = ee_expand("~/LUA/?.lua")
--     package.path = ee_expand("~/usrc/ldb/?.lua")
--     ldb = require "ldb"
--     package.path = oldpath
--   end


-- «loadpeek»  (to ".loadpeek")
-- Obsolete.
-- -- (find-angg "DAVINCI/peek.c")
-- -- (find-angg "DAVINCI/peek.lua")
-- loadpeek = function ()
--     if not peek then
--       assert(package.loadlib(ee_expand("~/DAVINCI/peek.so"), "peek_init"))()
--     end
--   end
-- getaddr = function (obj)
--     return tonumber(string.match(tostring(obj), " 0x([0-9A-Za-z]+)"), 16)
--   end


-- «loadalarm»  (to ".loadalarm")
-- Obsolete. See: (find-es "lua5" "signal")

-- «loadposix»  (to ".loadposix")
-- New way (active below):  (find-es "lua5" "luaposix")
-- old way (deleted):       (find-es "lua5" "posix-lua51")
loadposix = function ()
    userocks(); require "posix"
  end

-- «curl» (to ".curl")
-- (find-man "1 curl" "-s, --silent")
curl = function (url)
    local cmd = format("curl -s '%s'", url)
    return getoutput(cmd)
  end


-- «preparef2n»  (to ".preparef2n")
-- Supersed by: (find-angg "LUA/DFS.lua")
-- Very old notes: (find-es "lua5" "functionnames")


-- «each2»  (to ".each2")
-- (find-es "lua5" "each2")
-- (find-pilw3m "7.1.html" "Iterators and Closures")
each2 = function (tbl)
    local i = 1
    return function ()
        if i <= table.getn(tbl) then
          i = i + 2
          return tbl[i - 2], tbl[i - 1]
        end
      end
  end

-- «translatechars»  (to ".translatechars")
-- (find-node "(coreutils)Translating")
translatechars = function (str, re, tbl)
    return (gsub(str, re, function (c) return tbl[c] or c end))
  end

-- chartranslator = function (re, tbl)
--     return function (str)
--         return gsub(str, re, function (c) return tbl[c] or c end)
--       end
--   end
--
-- sgmlify = chartranslator(sgmlify_re, sgmlify_table)


--  _                      
-- | |    _ __   ___  __ _ 
-- | |   | '_ \ / _ \/ _` |
-- | |___| |_) |  __/ (_| |
-- |_____| .__/ \___|\__, |
--       |_|         |___/ 
--
-- «lpeg»  (to ".lpeg")

-- «sbeconcat»  (to ".sbeconcat")
-- Concatenate a table with strings and with begin/end pairs
-- Example:
--   sbeconcat("abfoocd"){1, 3, "FOO", 6, 8}   --> "abFOOcd"
-- This is ugly! concatbestrings, below, is much clearer.
--
sbeconcat = function (subj, f)
    f = f or function (str) return str end
    return function (table1)
        local table2, i, n = {}, 1, table.getn(table1)
        while i <= n do
          local obj = table1[i]
          if type(obj) == "string" then
            tinsert(table2, obj)
            i = i + 1
          else
	    local str = string.sub(subj, obj, table1[i+1] - 1)
            tinsert(table2, f(str))    --< sgmlify?
            i = i + 2
          end
        end
        return table.concat(table2)
      end
  end

-- «concatbestrings»  (to ".concatbestrings")
-- A "table of bestrings" is a table containing pairs of numbers
-- (begin/end pairs) and strings. Example:
--   concatbestrings("abfoocd", nil, {1, 3, "FOO", 6, 8})   --> "abFOOcd"
--         (a table of bestrings) -> \-----------------/
--
concatbestrings = function (subj, f, bestrings)
    f = f or function (s) return s end
    local table2, i = {}, 1
    while i <= #bestrings do
      local obj = bestrings[i]
      if type(obj) == "string" then
        table.insert(table2, obj)
        i = i + 1
      else
	local str = string.sub(subj, obj, bestrings[i+1] - 1)
        table.insert(table2, f(str))
        i = i + 2
      end
    end
    return table.concat(table2)
  end

curriedconcatbestrings = function (subj, f)
    return function (bestrings)
        return concatbestrings(subj, f, bestrings)
      end
  end


-- «lpeg_togsub»  (to ".lpeg_togsub")
-- «lpeg_gsub»    (to ".lpeg_gsub")
-- A pattern that returns a string can be "Kleene-starred with
-- the least possible filling" to create a pattern that works
-- somewhat like a gsub, but that returns a table of bestrings...
-- Roughly, that would be like converting "(pat)" into
-- "\\(().-()(pat)\\)*().-()", where the "\\(...\\)" is a "shy
-- group" - i.e., its parentheses do not return a capture.
--
-- Actually this returns a sequence of captures, not a table; use Ct()
-- to pack them in to a table, and then a concatbestrings.
--
-- The logic: the pattern PosPosWord, below, works like this:
--
--    -> Pos -----+1--> Pos --> Word -->
--             ^  2
--             |  \---> Anychar ->\
--             |                  |
--             \------------------/
--
-- where each "Pos" returns a number, and "Word" returns a string.
-- The "1" and the "2" indicate the order in which the branches are
-- tried (at the "+"). The rest of the function shouldn't be hard to
-- understand.
--
-- (find-es "lua5" "lpeg-quickref")
lpeg_togsub = function (Word)
    local Pos        = lpeg.Cp()
    local AnyChar    = lpeg.P(1)
    local BeRest     = Pos * AnyChar^0 * Pos
    local PosPosWord = Pos * lpeg.P { Pos * Word + AnyChar * lpeg.V(1) }
    return PosPosWord^0 * BeRest
  end

lpeg_gsub = function (Word, subj, f)
    f = f or function (...) return ... end
    return concatbestrings(subj, f, Word:togsub():Ct():match(subj))
  end

-- Example:
-- loadlpeg()
-- Word        = lpeg.R("AZ")^1 / function (s) return "<"..s..">" end
-- = Word:gsub("abFOOcdBAR", function (s) return "_"..s.."_" end)
--         --> "_ab_<FOO>_cd_<BAR>__"


-- «lpeg_gsub_»  (to ".lpeg_gsub_")
-- An alternative (faster but more complex):
-- With gsub_ we can reuse a prebuilt :togsub():Ct() pattern,
-- without having to build it anew each time.
-- loadlpeg()
-- WordTogsubCt = Word:togsub():Ct()
-- = WordTogsubCt:gsub_("abFOOcdBAR", function (s) return "_"..s.."_" end)
--         --> "_ab_<FOO>_cd_<BAR>__"
--
lpeg_gsub_ = function (WordTogsubCt, subj, f)
    f = f or function (...) return ... end
    return concatbestrings(subj, f, WordTogsubCt:match(subj))
  end



-- «lpeg_balanced»  (to ".lpeg_balanced")
-- (find-angg "LUA/preproc.lua")
lpeg_balanced = function (Open, MidChars, Close)
    local Middle
    Open     = lpeg.P(Open)
    Close    = lpeg.P(Close)
    MidChars = MidChars or (1 - (Open + Close))^1
    Middle   = lpeg.P { (MidChars + Open * lpeg.V(1) * Close)^0 }
    return Open * Middle:C() * Close, Middle
  end




-- «ee_template»  (to ".ee_template")
-- (find-eev "eev-template0.el")
-- ee_template({a="<AA>", b="<BB>"}, "foo{a}bar{c}plic")
--   --> "foo<AA>bar{c}plic"
ee_template = function (pairs, templatestr)
    return (string.gsub(templatestr, "{([^{}]+)}", pairs))
  end

-- «ee_into»  (to ".ee_into")
-- ee_into("a b c", "<AA> <BB>")
--   --> {"a"="<AA>", "b"="<BB>"}
ee_into = function (fieldnames, data)
    if type(fieldnames) == "string" then fieldnames = split(fieldnames) end
    if type(data)       == "string" then data       = split(data)       end
    local o = {}
    for i=1,#fieldnames do o[fieldnames[i]] = data[i] end
    return o
  end

-- «chdir»  (to ".chdir")
-- 2008may23 / 2020jan17
-- See: (find-es "lua5" "luaposix-git")
chdir = function (dir)
    loadposix()
    if not posix.chdir then posix.chdir = posix.unistd.chdir end
    return assert(posix.chdir(ee_expand(dir)))
  end

-- «userocks»  (to ".userocks")
-- (find-es "luarocks" "path")
-- (find-angg ".emacs" "luarocks")
-- (find-lua51manual "#pdf-require")
-- (find-lua51manual "#pdf-package.path")
-- (find-lua51manual "#pdf-package.cpath")
-- (find-fline "~/usrc/luarocks/share/lua/5.1/")
-- (find-fline "~/usrc/luarocks/lib/lua/5.1/")
userocks = function ()
    local luarocksdir = ee_expand "~/usrc/luarocks"
    local HOME = ee_expand "~/"
    package.path  = package.path ..";"..luarocksdir.."/share/lua/5.1/?.lua"
    package.cpath = package.cpath..";"..luarocksdir.."/lib/lua/5.1/?.so"
    package.path  = package.path ..";"..HOME..".luarocks/share/lua/5.1/?.lua"
    local req = function (pkgname) return function () require(pkgname) end end
    loadposix  = req "posix"
    load_posix = req "posix"
  end

-- «hms_to_s» (to ".hms_to_s")
-- «s_to_hms» (to ".s_to_hms")
hms_to_s = function (hms)
    local zeros = "00:00:00"
    hms = zeros:sub(1, #zeros-#hms)..hms
    return hms:sub(1, 2)*3600 + hms:sub(4, 5)*60 + hms:sub(7, 8)
  end
s_to_hms = function (s)
    local f = function (n) local a = math.fmod(n, 60); return a, (n-a)/60 end
    local s,m = f(s)
    local m,h = f(m)
    if h > 0
    then return format("%d:%02d:%02d", h, m, s)
    else return format(     "%d:%02d",    m, s)
    end
  end

-- «icollect» (to ".icollect")
-- (find-es "lua5" "icollect")


-- «Repl1.lua»  (to ".Repl1.lua")
-- (find-angg "LUA/Repl1.lua")
run_my_repl_now = function ()
    ee_dofile "~/LUA/Repl1.lua"
    r = EdrxRepl.new()
    r:repl()
  end
stop_my_repl_now = function ()
    dg = dgis
    r.STOP = "please"
  end

-- «Repl2.lua»  (to ".Repl2.lua")
-- (find-angg "LUA/Repl2.lua" "Repl2")
-- (find-angg "LUA/Repl2.lua" "Repl2" "while not r.STOP do")
run_repl2_now = function ()
    ee_dofile "~/LUA/Repl2.lua"
    r = Repl2.new()
    r:repl()
  end
stop_repl2_now = function ()
    r.STOP = "please"
  end

-- «Repl3.lua»  (to ".Repl3.lua")
-- (find-angg "LUA/Repl3.lua")
run_repl3_now = function ()
    -- Path.prependtopath "~/LUA/?.lua"
    Path.addLUAtopath()
    require "Repl3"
    r = Repl.new()
    r:repl()
  end
stop_repl3_now = function ()
    r.STOP = "please"
  end

-- «mytraceback»  (to ".mytraceback")
-- «errorfb_line»  (to ".errorfb_line")
-- Obsolete.
-- See: (find-angg "LUA/Repl1.lua")
-- and: (find-angg "LUA/lua50init.lua" "DGetInfos")
--      (find-angg "LUA/lua50init.lua" "DGetInfos" "tb =")

-- «interactor»  (to ".interactor")
-- Obsolete (from 2007). Deleted.
-- (find-es "lua5" "interactor")
-- (find-TH "repl")

-- «MyXpcall»  (to ".MyXpcall")
-- Obsolete! Moved to: (find-angg "LUA/myxpcall.lua" "MyXpcall")
-- Superseded by: (find-angg "edrxrepl/edrxpcall.lua")
--
-- «Repl» (to ".Repl")
-- Obsolete. See: (find-es "lua5" "Repl")
-- Superseded by: (find-angg "edrxrepl/edrxrepl.lua")
--                (find-angg "edrxrepl/edrxrepl.lua" "Repl")
--                (find-angg "LUA/Repl1.lua")

-- «loadluarepl» (to ".loadluarepl")
-- Obsolete.
-- See: (find-es "lua5" "lua-repl-0.8")
-- And: (find-dednat6 "dednat6/luarepl.lua")
-- TODO: replace all uses of this by the Repl class defined above.


-- «replaceranges» (to ".replaceranges")
-- str = "(foo bar)"
-- ranges = {{6,9,"BAR"}, {2,5, string.upper}}
-- = replaceranges(str, ranges)
replaceranges_ = function (str, ranges, spos, rpos, f)
    local range = ranges[rpos]
    if not range then return str:sub(spos) end
    local a, b, s_or_f = range[1], range[2], range[3]
    local s = (type(s_or_f) == "string")
                and s_or_f
                or  s_or_f(str:sub(a, b-1))
    return f(str:sub(spos, a-1)) .. s ..
           replaceranges_(str, ranges, b, rpos+1, f)
  end
replaceranges = function (str, ranges, f)
    table.sort(ranges, function (a, b) return a[1]<b[1] end)
    return replaceranges_(str, ranges, 1, 1, f or id)
  end


-- «string.replace» (to ".string.replace")
-- a = "abcdefg"
-- a:replace(2, "CDE")     --> "abCDEfg"
-- a:replace(2, "CDE", 4)  --> "abCDE g"
--
string.leftof = function (s, w)
    if     #s >  w then return s:sub(1, w)
    elseif #s == w then return s
    else return s..string.rep(" ", w - #s)
    end
  end
string.rightof = function (s, w)
    if #s <= w then return ""
    else return s:sub(w+1)
    end
  end
string.replace = function (s, x, r, w)
    w = w or #r
    r = r:leftof(w)
    return s:leftof(x)..r..s:rightof(x + #r)
  end


-- «anggurl-and-angg_url»  (to ".anggurl-and-angg_url")
-- Obsolete! TODO: replace this by a class that shortens
-- local filenames correctly.
string.revgsub = function (str, ...)
    return str:reverse():gsub(...):reverse()
  end
underlinify = function (s)
    return s:sub(1, 1)..string.rep("_", #s-2)..s:sub(#s)
  end

intro_url = function (stem)
    return anggurl("eev-intros/find-"..stem.."-intro.html")
  end

angg_url  = function (fname) return "../"..fname end
intro_url = function (stem) return string.upper(stem) end
isdir     = function (fname) return fname=="" or fname:sub(-1)=="/" end
suffixing = function (fname, suffix, anchor)
    return (isdir(fname) and fname or fname..suffix) ..
           (anchor and "#"..anchor or "")
  end

meta_find_angg = function (anggdir, suffix, intro_stem)
    return function (fname, tag)
        local target = fname and
          angg_url(anggdir)..suffixing(fname, suffix or ".html")
        if target and tag then target = target.."#"..tag end
        return target, intro_url(intro_stem or "code-c-d")
      end
  end



-- «Sexp» (to ".Sexp")
-- Used here: (find-blogme3 "anggdefs.lua" "Sexp")
elisp = {}
elisp["find-angg"] = meta_find_angg("")
elisp["find-es"]   = meta_find_angg("e/", ".e.html")

elispSPECIAL = {}

Sexp = Class {
  type    = "Sexp",
  __index = {
    getsexp = function (sexp)
        local line = sexp.line
        if line:sub(#line) ~= ")" then return end
        local len = #line
        local skel = line:gsub("\\.", "__")              -- backslash+c -> __
        skel = skel:revgsub("\"[^\"]*\"", underlinify)   -- "abc" -> "___"
        skel = skel:sub(1, len-1):revgsub("%b)(", underlinify)..skel:sub(len)
        local revsexp = line:reverse():match("^%b)(")
        if not revsexp then return end
        sexp.sexp = revsexp:reverse()
        sexp.pre  = line:sub(1, len-#sexp.sexp)
        -- sexp.sexpskel = skel:sub(#sexp.pre+1)
        sexp.midskel = skel:sub(#sexp.pre+2, len-1)
        sexp.head    = sexp.midskel:match("^%S*")
        return sexp.head
      end,
    getsexpargs = function (sexp)
        local n = 0
        sexp.ranges = {}
        for i,j in sexp.midskel:gmatch("()%S+()") do
          n = n + 1
          sexp[n] = sexp.sexp:sub(i+1, j)
          sexp.ranges[n] = {i+1, j+1}
        end
      end,
    string = function (sexp, n)
        return sexp[n] and sexp[n]:match '^"(.*)"$'
      end,
    --
    Q = function (text) return text end,
    hrefto = function (sexp, url)
        return function (text)
            return '<a href="'..url..'">'..sexp.Q(text)..'</a>'
          end
      end,
    setrange = function (sexp, a, b, s_or_f)
          table.insert(sexp.htmlranges, {a, b, s_or_f})
      end,
    sethelp = function (sexp, url)
        local r = sexp.ranges[1]
        if url then sexp:setrange(r[1], r[2], sexp:hrefto(url)) end
        -- table.insert(sexp.htmlranges, {r[1], r[2], sexp:hrefto(url)})
        -- end
      end,
    settarget = function (sexp, url)
        local len = #sexp.sexp
        if url then sexp:setrange(len-1, len+1, sexp:hrefto(url)) end
        -- table.insert(sexp.htmlranges, {len-1, len+1, sexp:hrefto(url)})
        -- end
      end,
    tohtml0 = function (sexp)
        return replaceranges(sexp.sexp, sexp.htmlranges or {}, sexp.Q)
      end,
    getsexphtml = function (sexp)
        sexp.htmlranges = {}
        if not sexp.head then return end
        if elispSPECIAL[sexp.head] then    -- for all kinds of special hacks
          elispSPECIAL[sexp.head](sexp)
          return
        end
        local find_aaa = elisp[sexp.head]
        if not find_aaa then return end
        sexp:getsexpargs()
        sexp.target, sexp.help = find_aaa(sexp:string(2), sexp:string(3))
        sexp:sethelp(sexp.help)
        sexp:settarget(sexp.target)
        sexp.sexphtml = sexp:tohtml0()
      end,
    getlinehtml = function (sexp)
        if sexp:getsexp() then sexp:getsexphtml() end
        if sexp.sexphtml
        then sexp.linehtml = sexp.Q(sexp.pre)..sexp.sexphtml
        else sexp.linehtml = sexp.Q(sexp.line)
        end
        return sexp.linehtml
      end,
  },
}

-- «youtube_make_url»  (to ".youtube_make_url")
-- (find-es "youtube" "time-syntax")
youtube_make_url = function (hash, time)
    return "http://www.youtube.com/watch?v=" .. hash .. youtube_time(time)
  end
youtube_time = function (time)
    if type(time) ~= "string" then return "" end
    local mm,ss = time:match("^(%d?%d):(%d%d)$")
    if ss then return "&t="..(mm*60+ss) end
    local hh,mm,ss = time:match("^(%d?%d):(%d%d):(%d%d)$")
    if ss then return "&t="..(hh*3600+mm*60+ss) end
    return ""
  end
youtube_time_hhmmss = function (time)
    if type(time) ~= "string" then return "" end
    local mm,ss = time:match("^(%d?%d):(%d%d)$")
    if ss then return format("&t=%sm%ss", mm, ss) end
    local hh,mm,ss = time:match("^(%d?%d):(%d%d):(%d%d)$")
    if ss then return format("&t=%sh%sm%ss", hh, mm, ss) end
    return ""
  end

-- «youtube_split» (to ".youtube_split")
-- I was using this at too many places - including one-shot programs...
-- (find-angg "LUA/youtube-tags.lua")
-- (find-angg "LUA/youtube.lua")
-- (find-blogme3 "youtube.lua")
youtube_split_url0 = function (li)
    local a, url, b, title, c = li:match "^(.-)(https?://%S*)(%s*)(.-)(%s*)$"
    if not url then return end
    local hash, time
    for key,value in url:gmatch "[?&](%w*)=([^?&#'()]*)" do
      if key == "v" then hash = value end
      if key == "t" then time = value end  -- not being used now
    end
    if not hash then return end
    return a, hash, b, title, c
  end
youtube_split_url = function (li)
    local a, hash, b, title, c = youtube_split_url0(li)
    if a then return hash, youtube_make_url(hash), title end
  end

-- «to_youtube_hash»  (to ".to_youtube_hash")
to_youtube_hash = function (str)
    str = str:gsub("%.%w%w%w$", "")
    str = str:sub(-11)
    return str
  end


-- «url_split» (to ".url_split")
-- Used here: (find-angg "LUA/redirect.lua")
url_percent_decode  = function (str)
    local f = function (hh) return string.char(tonumber(hh, 16)) end
    return (str:gsub("%%(%x%x)", f))
  end
url_query_split = function (query)
    local Q = {}
    for key,value in query:gmatch "[?&](%w*)=([^?&#'()]*)" do
      Q[key] = url_percent_decode(value)
    end
    return Q
  end
--
url_split_re  = nil
url_split_re0 = function ()
    userocks()
    require "re"     -- (find-es "lua5" "lpeg-re")
    return re.compile [=[
        {|       {:scheme: [a-z]+ :} "://"
                 {:host:   [^/]+  :}
           ( "/" {:path:   [^?#]* :} ) ?
           ( "?" {:query:  [^#]*  :} ) ?
           ( "#" {:anchor: [^#]*  :} ) ?
        |}
      ]=]
  end
url_split = function (url)
    url_split_re = url_split_re or url_split_re0()
    local parts  = url_split_re:match(url)
    if parts and parts.query then parts.q = url_query_split("?" .. parts.query) end
    return parts
  end


-- «Blogme» (to ".Blogme")
-- Deleted! Superseded by: (find-anggfile "LUA/BlogMe3.lua")

-- (find-blogme3 "anggdefs.lua" "basic-words-for-html" "HREF")
HREF  = function (url, str) return format('<a href="%s">%s</a>', url, str) end
HREF1 = function (url, str) return url and HREF(url, str) or str end

-- «EevIntro» (to ".EevIntro")
-- (find-es "lua5" "EevIntro")
-- Superseded by sandwiches:
--   (find-blogme3file "sandwiches.lua")
-- TODO: check which .blogme files still use this.
--
EevIntro = Class {
  type = "EevIntro",
  from = function (stem, sec)
      return EevIntro {stem=stem, sec=sec}
    end,
  fromshort = function (short)
      if short:match"#"
      then return EevIntro.from(short:match"^(.-)#(.*)")
      else return EevIntro.from(short)
      end
    end,
  fromheadposspec = function (head, posspec)
      local stem = head:match "^find%-(.*)%-intro$"
      local sec = posspec and posspec:match "^(%d[%d%.]*)%. "
      return EevIntro.from(stem, sec)
    end,
  fromsexp = function (li)
      local head, rest = li:match "^%s*%(([!-~]+)(.*)%)%s*$"
      local posspec = rest:match "^%s+\"(.*)\"$"
      return EevIntro.fromheadposspec(head, posspec)
    end,
  __tostring = function (ei) return mytostring(ei) end,
  __index = {
    url = function (ei)
        return format("eev-intros/find-%s-intro.html%s",
                      ei.stem, ei.sec and "#"..ei.sec or "")
      end,
    short = function (ei)
        return ei.stem .. (ei.sec and "#"..ei.sec or "")
      end,
  },
}

introhtml = function (stem, sec)
    return EevIntro.from(stem, sec):url()
  end



-- «ELispH» (to ".ELispH")
-- Superseded by sandwiches:
--   (find-blogme3file "sandwiches.lua")
-- TODO: check which .blogme files still use this.
--
-- See: (find-es "lua5" "ELispH")
--      (find-es "lua5" "ELispH-tests")
-- An ELispH object holds data that can generate a "help url" and
-- a "target url". For example:
--
--   eh = ELispH({intro="eev-quick", target="index.html", anchor="eev"})
--   eh:gethelp()   --> "eev-intros/find-eev-quick-intro.html"
--   eh:gettarget() --> "index.html#eev"
--
-- The :sexphtml(...) method connects this to SexpSkel.
--
ELispH = Class {
  type    = "ELispH",
  __tostring = function (eh) return mytabletostring(eh) end,
  __index = {
    gethelp = function (eh)
        if eh.intro then
          local stem,section = eh.intro:match("^(.-)#(.*)")
          if section then return introhtml(stem, section) end
          return introhtml(eh.intro)
        end
	return eh.help
      end,
    gettarget = function (eh)
        return eh.target and (eh.target .. (eh.anchor and "#"..eh.anchor or ""))
      end,
    sexphtml = function (eh, hzer, a, head, b, qp)
        hzer = hzer or id
        local help   = eh:gethelp()
        local target = eh:gettarget()
        return hzer(a) .. HREF1(help,   hzer(head)) ..
               hzer(b) .. HREF1(target, hzer(qp))
      end,
    --
    test = function (eh)
        local outt = {help=eh:gethelp(), target=eh:gettarget()}
        return tostring(eh) .. " ->\n" .. mytabletostring(outt)
      end,
  },
}


-- «ELispHF» (to ".ELispHF")
-- Superseded by sandwiches:
--   (find-blogme3file "sandwiches.lua")
-- TODO: check which .blogme files still use this.
--
-- (find-es "lua5" "ELispHF")
-- (find-es "lua5" "ELispHF-tests")
-- An ELispHF object holds an "elisp hyperlink function", that when
-- called produces an ElispH object.
--
ELispHF = Class {
  type    = "ELispHF",
  newangg = function (head, d, suffix)
      return ELispHF {head=head, d=d, suffix=suffix, f="angg"}
    end,
  newintro = function (head)
      return ELispHF {head=head, f="intro"}
    end,
  newnode = function (head, c, manual)
      return ELispHF {head=head, c=c, manual=manual, f="node"}
    end,
  newyoutube = function (head, hash)
      return ELispHF {head=head, hash=hash, f="youtube"}
    end,
  __tostring = function (ehf) return mytabletostring(ehf) end,
  __call = function (ehf, ...) return ehf[ehf.f](ehf, ...) end,
  __index = {
    angg = function (ehf, a, b, c)
        local target = suffixing(ehf.d..(a or ""), ehf.suffix, b)
        return ELispH {intro="eev-quick#9", target=target}
      end,
    intro = function (ehf, a)
        local ei = EevIntro.fromheadposspec(ehf.head, a)
        return ELispH {intro=ei.stem, target=ei:url()}
        -- return ELispH {intro=ei:short(), target=ei:url()}
      end,
    node = function (ehf, a)
        local manual, section = ehf.manual, a
        local target = ELispInfo{}:mstohtml(manual, section)
        return ELispH {intro="eev-quick#9.2", target=target}
      end,
    youtube = function (ehf, a)
        local hash, time = ehf.hash, a
        local target = youtube_make_url(hash, time)
        return ELispH {intro="audiovideo#4.3", target=target}
      end,
    codevideo = function (ehf, c, urlorfnameorhash)
        if c and urlorfnameorhash then code_video(c, urlorfnameorhash) end
        return ELispH {intro="audiovideo#4.3"}
      end,
  },
}

_EHF = VerticalTable {}

code_c_d_angg = function (c, d, suffix)
    local find_c     = "find-"..c
    local find_cfile = "find-"..c.."file"
    _EHF[find_c    ] = ELispHF.newangg(find_c, d, suffix or ".html")
    _EHF[find_cfile] = ELispHF.newangg(find_c, d, ".html")
  end

-- (find-blogme3 "angglisp.lua" "code_c_m_b_s")
-- (find-angg "LUA/lua50init.lua" "ELispHF")
-- (find-es "blogme" "code_c_m_b")
infomanual_basedir = VerticalTable {}

code_c_m_b = function (c, manual, basedir)
    infomanual_basedir[manual] = basedir
    local find_cnode = "find-"..c.."node"
    _EHF[find_cnode] = ELispHF.newnode(find_cnode, c, manual)
  end

-- «code_video»  (to ".code_video")
-- Superseded by sandwiches:
--   (find-blogme3file "sandwiches.lua")
-- TODO: check which .blogme files still use this.
--
-- Run this to make blogme3 process `(code-video "c" "fname")' sexps:
--   _EHF["code-video"] = ELispHF {f="codevideo"}
--
code_video = function (c, urlorfnameorhash)
    local find_c = "find-"..c
    local hash = to_youtube_hash(urlorfnameorhash)
    _EHF[find_c] = ELispHF.newyoutube(find_c, hash)
  end






-- «getsexp» (to ".getsexp")
-- Superseded by sandwiches:
--   (find-blogme3file "sandwiches.lua")
-- TODO: check which .blogme files still use this.
--
-- New version: (find-angg "LUA/SexpAtEol1.lua" "SexpAtEol-tests")
-- (find-es "lua5" "getsexp")
-- (find-blogme3 "sexp.lua" "getsexp")
-- Version: 2019jan08.
-- A low-level function that splits a line into a sexp, a skel, and other stuff.
-- If    str  = 'Hello  (find-xpdfpage "~/LATEX/foo.pdf" (+ 2 3))'
-- then  sexp =        '(find-xpdfpage "~/LATEX/foo.pdf" (+ 2 3))',
--       skel =        '(find-xpdfpage "_______________" (_____))',
--       head =         'find-xpdfpage',
--       left = 'Hello '.
getsexp = function (str)
    if str:sub(-1) ~= ")" then return end
    local rep = string.rep
    local simpq = function (s) return '"'..rep("_", #s-2)..'"' end  -- simplify '"'s
    local simpp = function (s) return '('..rep("_", #s-2)..')' end  -- simplify parens
    local leks = str:gsub("\\.", "__"):reverse():gsub('"[^"]*"', simpq):match("^%b)(")
    if not leks then return end
    local skel = leks:reverse()
    local sexp = str:sub(-#skel)
    local head = sexp:match("^%(([^ ()\"]+)")
    local skel = "(" .. skel:sub(2):gsub("%b()", simpp)
    local left = str:sub(1, -1-#skel)
    return sexp, head, skel, left
  end

-- «SexpSkel» (to ".SexpSkel")
-- (find-es "lua5" "SexpSkel")
-- (find-es "lua5" "SexpSkel-test")
-- A user-friendly class based on getsexp with a nice printing function.
SexpSkel = Class {
  type    = "SexpSkel",
  fromline = function (line)
      local str,right = line:match("^(.-%))([%s]*)$")
      if not str then return SexpSkel {line=line} end
      local sexp,head,skel,left = getsexp(str)
      if not sexp then return SexpSkel {line=line} end
      return SexpSkel {line=line, left=left, sexp=sexp, right=right,
                       skel=skel, head=head}
    end,
  __tostring = function (ss)
      if not ss.sexp then return ss.line.."\n[no sexp]" end
      local spacify = function (s, c) return string.rep(c or " ", #s) end
      local left0  = spacify(ss.left)
      local right0 = spacify(ss.right, ".")
      return ss.line                .."\n"..
             left0..ss.sexp..right0 .."\n"..
             left0..ss.skel         .."\n"..
             left0.." "..ss.head
    end,
  __index = {
    splitsexp = function (ss)
        local sexpmid = ss.sexp:sub(2, -2)   -- without the '(' and the ')'
        local skelmid = ss.skel:sub(2, -2)   -- without the '(' and the ')'
        local A = {}
        local f = function (p0, p1)                 -- positions from skelmid
            table.insert(A, sexpmid:sub(p0, p1-1))  -- substring from sexpmid
            -- PP(sexpmid:sub(p0, p1-1), skelmid:sub(p0, p1-1))
          end
        skelmid:gsub("()[^%s]+()", f)
        return A
      end,
    parsestrargs = function (ss)
        local A = ss:splitsexp()
        local f = function (str) return str and str:match("^\"(.*)\"$") end
        return f(A[2]), f(A[3]), f(A[4])
      end,
    parseq = function (ss)
        local headpat = "("..string.rep(".", #ss.head)..")"
        local qppat   = "(\"?%))"   -- optional last quote, closing parenthesis
        local a,head,b,qp  = ss.sexp:match("^(.)"..headpat.."(.-)"..qppat.."$")
        -- print(table.concat({a,head,b,qp}, "|"))
        return a,head,b,qp
      end,
    --
    -- (find-es "lua5" "SexpSkel")
    -- Interface with ELispH and ELispHF:
    ehtosexphtml = function (ss, eh, hzer)
        return eh:sexphtml(hzer, ss:parseq())
      end,
    ehftoeh = function (ss, ehf)
        return ehf(ss:parsestrargs()) end,
    toehf = function (ss)
        return _EHF[ss.head] end,
    toeh = function (ss)
        local ehf = ss:toehf(); return ehf and ss:ehftoeh(ehf)
      end,
    totarget = function (ss)
        local eh = ss:toeh(); return eh and eh:gettarget()
      end,
    tohelp = function (ss)
        local eh = ss:toeh(); return eh and eh:gethelp()
      end,
    tosexphtml = function (ss, hzer)
        local eh = ss:toeh(); return eh and ss:ehtosexphtml(eh, hzer)
      end,
  },
}



-- «ELispInfo» (to ".ELispInfo")
-- (find-es "lua5"  "ELispInfo")
-- (find-blogme3 "sexp.lua" "find-xxxnodes")
-- Superseded by sandwiches:
--   (find-blogme3file "sandwiches.lua")
-- TODO: check which .blogme files still use this.
--
ELispInfo = Class {
  type = "ELispInfo",
  new  = function (c, manual, basedir)
      infomanual_basedir[manual] = basedir
      return ELispInfo {c=c, manual=manual}
    end,
  __index = {
    -- convert [s]ection name to [h]tml
    shre    = "([-'/ &])",
    shtable = {["-"] = "_002d", ["'"] = "_0027", ["/"] = "_002f",
               [" "] = "-",     ["&"] = "-"},
    shexpand = function (eli, section)
        return section:gsub("%s+", " "):gsub(eli.shre, eli.shtable)
      end,
    --
    -- convert a pair (manual, section) to html
    mstohtml = function (eli, manual, section)
        if not manual or not section then return end
        local basedir = infomanual_basedir[manual]
        if not basedir then return end
        local sectionh = eli:shexpand(section)
        return basedir..sectionh..".html"
      end,
    -- a "nodename" is a string like "(libc)I/O Overview"
    nodenametohtml = function (eli, nodename)
        if not nodename then return end
        local manual, section = string.match(nodename, "^%(([^()]+)%)(.*)$")
        return eli:mstohtml(manual, section)
      end,
    --
    -- -- convert a section name to html
    -- stohtml = function (eli, section)
    --     return eli:mstohtml(eli.manual, section)
    --   end,
    -- -- convert a (manual, section) pair or a section to an ELispH
    -- mstoeh = function (eli, manual, section)
    --     return ELispH {intro="eev-quick#3", target=eli:mstohtml(manual, section)}
    --   end,
    -- stoeh = function (eli, section)
    --     return ELispH {intro="eev-quick#9.2", target=eli:stohtml(section)}
    --   end,
    --
  },
}




-- _E = {}
-- _E["to"] = ElispHF {intro="anchors", calctarget=calctarget_to}
-- _E["find-angg"] = ElispHF {intro="anchors", d=""}

-- «getsexpskel» (to ".getsexpskel")
-- Olbsolete.
-- Algorithm and tests: (find-es "lua5" "getsexpskel")
--
-- getsexpskel = function (str)
--     if str:sub(-1) ~= ")" then return end
--     local f = function (s) return '"'..string.rep("_", #s-2)..'"' end
--     local g = function (s) return ')'..string.rep("_", #s-2)..'(' end
--     local str2 = str:gsub("\\.", "__")      -- backslash+c -> __
--     local str3 = str2:reverse()
--     local str4 = str3:gsub('"[^"]*"', f)
--     local skel1 = str4:match("%b)(");    if not skel1 then return end
--     local skel2 = skel1:sub(2, -2):gsub("%b)(", g)
--     local skel3 = skel2:reverse()
--     return skel3
--   end

-- «SexpLine» (to ".SexpLine")
-- Obsolete. See: (find-es "lua5" "SexpLine")
-- This was intended to replace some parts of: (find-blogme3 "escripts.lua")
--
-- SexpLine = Class {
--   type = "SexpLine",
--   from = function (src)
--       return SexpLine {src=src, skel=getsexpskel(src)}
--     end,
--   __tostring = function (sl) return mytabletostring(sl) end,
--   __index = {
--     skelf = function (sl) return sl.skel:match"^(%S+)" end,
--     split = function (sl)
--         local f       = sl:skelf()
--         local len     = #sl.src
--         local lensexp = #sl.skel + 2
--         local lena    = len - lensexp
--         local lenb    = 1
--         local lenc    = #f
--         local lene    = (sl.src:sub(-2, -2) == "\"") and 2 or 1
--         local lend    = len - lena - lenb - lenc - lene
--         sl.a = sl.src:sub(1, lena)
--         sl.b = "("
--         sl.c = f
--         sl.d = sl.src:sub(lena + lenb + lenc + 1, lena + lenb + lenc + lend)
--         sl.e = sl.src:sub(-lene)
--         local p1, p2 = sl.skel:match"^%S+%s+()%S+()"
--         if p1 then
--           local offset = lena + 1
--           sl.arg1 = sl.src:sub(offset + p1, offset + p2):match"^\"(.*)\"$"
--         end
--         return sl
--       end,
--     splitt = function (sl)    -- for tests
--         return sl.a.."|"..sl.b.."|"..sl.c.."|"..sl.d.."|"..sl.e
--       end,
--     splitsexp = function (sl)
--         sl.nth = {}
--         for p1,p2 in sl.skel:gmatch("()%S+()") do
--           local b, e = #sl.a + 1 + p1, #sl.a + p2
--           local raw = sl.src:sub(b, e)
--           local str = raw:match"^\"(.*)\"$"
--           table.insert(sl.nth, {b=b, e=e, raw=raw, str=str})
--         end
--         return sl
--       end,
--     n      = function (sl)    return #sl.nth end,
--     rawarg = function (sl, n) return (sl.nth[n] or {}).raw end,
--     arg    = function (sl, n) return (sl.nth[n] or {}).str end,
--     --
--     q = function (sl, body) return body end,
--     r = function (sl, url, body)
--         return url and format('<a href="%s">%s</a>', url, body) or body
--       end,
--     sethtml = function (sl)
--         sl.f        = sl.skel and sl:skelf()
--         sl.ef       = sl.f and _E[sl.f]
--         if not sl.ef then
--           sl.html   = sl:q(sl.src)
--         else
--           sl:split()
--           sl:splitsexp()
--           sl.help     = sl.ef:calchelp()
--           sl.target   = sl.ef:calctarget(sl:arg(2), sl:arg(3))
--           sl.sexphtml = sl.b..
--                         sl:r(sl.help, sl.c)..
--                         sl:q(sl.d)..
--                         sl:r(sl.target, sl.e)
--           sl.html     = sl:q(sl.a) .. sl.sexphtml
--         end
--         return sl
--       end,
--   },
-- }






-- «fsize» (to ".fsize")
-- (find-es "lua5" "lua-posix-wheezy")
-- require "posix"
readlink = function (fname)
    while posix.readlink(fname) do fname = posix.readlink(fname) end
    return fname
  end
fsize = function (fname)
    return posix.stat(fname).size
  end
roundblock = function (size, blocksize)
    local m = math.fmod(size, blocksize)
    if m ~= 0 then size = size - m + blocksize end
    return size
  end
fsizeb = function (fname, blocksize)
    return roundblock(fsize(readlink(fname)), blocksize or 8192)
  end

ydb_sort = function (bigstr)
    local lines = splitlines(bigstr)
    local ord   = {}
    local lt    = function (li1, li2) return ord[li1] < ord[li2] end
    for _,li in ipairs(lines) do
      ord[li] = li:gsub("http://www.youtube.com/watch[^ ]+", "")
    end
    return table.concat(sorted(lines, lt), "\n")
  end
ydb_sort1 = function () print(ydb_sort(io.read("*a"))) end


-- «loaddednat6» (to ".loaddednat6")
-- loaddednat6 = function ()
--     -- dednat6dir = "/home/edrx/dednat6/"     -- (find-dn6 "")
--     dednat6dir = os.getenv"HOME".."/dednat6/" -- (find-dn6 "")
--     dofile(dednat6dir.."dednat6.lua")         -- (find-dn6 "dednat6.lua")
--   end
loaddednat6 = function (dir)
    dednat6dir = ee_expand(dir or "~/LATEX/dednat6/") -- (find-dn6 "")
    dofile(dednat6dir.."dednat6.lua")                 -- (find-dn6 "dednat6.lua")
  end

-- «loadelpeg1»  (to ".loadelpeg1")
-- (find-angg "LUA/ELpeg1.lua")
loadelpeg1 = function ()
    -- Path.prependtopath "~/LUA/?.lua"
    Path.addLUAtopath()
    require "ELpeg1"
  end

-- «loaddednatrequire»  (to ".loaddednatrequire")
-- Uses: (to "DednatRequire")
-- Used by: (find-angg "LUA/Show2.lua" "defs_repl")
loaddednatrequire = function ()
    oldrequire    = oldrequire or require
    dednatrequire = DednatRequire.newrequire
    require       = dednatrequire
  end

-- «loadshow2»  (to ".loadshow2")
-- (find-angg "LUA/Show2.lua")
loadshow2 = function ()
    -- Path.prependtopath "~/LUA/?.lua"
    Path.addLUAtopath()
    require "Show2"
    show0 = show0 or function () return          tostring(outertexbody)  end
    show  = show  or function () return Show.try(tostring(outertexbody)) end
  end

-- «loadtikz2»  (to ".loadtikz2")
-- (find-angg "LUA/Tikz2.lua")
loadtikz2 = function ()
    -- Path.prependtopath "~/LUA/?.lua"
    Path.addLUAtopath()
    require "Tikz2"
  end

-- «loadfbcache2» (to ".loadfbcache2")
loadfbcache2 = function ()
    chdir "~/fbcache/"      -- (find-fbcache "")
    dofile "fbcache2.lua"   -- (find-fbcache "fbcache2.lua")
  end

-- «loadluarocks» (to ".loadluarocks")
-- (find-es "lua5" "luarocks.loader")
-- (find-es "lua5" "luarocks-interactively")
-- (find-fline "/usr/bin/luarocks")
loadluarocks = function ()
    package.path = "/usr/share/lua/5.1//?.lua;/usr/share/lua/5.1//?/init.lua;"..package.path
    command_line = require("luarocks.command_line")
    program_name = "luarocks"
    program_description = "LuaRocks main command-line interface"
    commands          = {}
    commands.help     = require("luarocks.help")
    commands.pack     = require("luarocks.pack")
    commands.unpack   = require("luarocks.unpack")
    commands.build    = require("luarocks.build")
    commands.install  = require("luarocks.install")
    commands.search   = require("luarocks.search")
    commands.list     = require("luarocks.list")
    commands.remove   = require("luarocks.remove")
    commands.make     = require("luarocks.make")
    commands.download = require("luarocks.download")
    commands.path     = require("luarocks.path")
    commands.show     = require("luarocks.show")
    commands.new_version = require("luarocks.new_version")
  end


-- «capitalize» (to ".capitalize")
-- Capitalize Brazilian names.
capitalize = function (text, smallwords)
    smallwords = smallwords or Set.fromarray(split("de da do das dos e"))
    local capitalize1 = function (word)
        word = word:lower()
        if smallwords:has(word) then return word end
        return word:sub(1,1):upper()..word:sub(2):lower()
      end
    return (text:gsub("%a+", capitalize1))
  end

-- «getinscritos» (to ".getinscritos")
-- (find-angg ".emacs" "getinscritos")
getinscrito = function (li)
    local mat,cpf,nome,email = li:match("^%s*(%d+)%s+(%d+)%s+(.-)%s%s+(%S+)")
    if not mat then return end
    local Nome = capitalize(nome)
    local dest = format("%-60s <%s>,", '"'..Nome..'"', email)
    local inscrito = {li=li, mat=mat, cpf=cpf, nome=nome, email=email,
      Nome=Nome, dest=dest}
    return inscrito
  end
getinscritos = function ()
    for li in io.lines() do
      if getinscrito(li) then print(getinscrito(li).dest) end
    end
  end


-- «findxxxpdf_parse» (to ".findxxxpdf_parse")
-- (find-angg "LUA/book-index.lua")
-- (find-angg ".emacs" "book-index")
--
findxxxpdf_parse = function (li, stem, adj)
    li = untabify(li)
    li = li:gsub(" [ .]* ", " ")
    li = li:match("^ *(.-) *$")
    local str,p = li:match("^(.*) ([0-9]+)$")
    if str then
      if stem and adj then
        printf(";; (find-%spage (+ %d %d) \"%s\")\n", stem, adj, p, str)
      elseif str and (not adj) then
        printf(";; (find-%spage %d \"%s\")\n",        stem,      p, str)
      end
    end
    return str,p
  end
findxxxpdf_parse_file = function (fname, stem, adj)
    for _,li in ipairs(splitlines(ee_readfile(fname))) do
      findxxxpdf_parse(li, stem, adj)
    end
  end



-- «repltexthis»  (to ".repltexthis")
-- This function has been put here temporarily.
-- It will change.
repltexthis = function (mathmodetexstuff)
    ee_writefile("~/LATEX/o.tex", "$"..mathmodetexstuff.."$")
    print("Wrote ~/LATEX/o.tex.")
    print('See: (find-LATEX "2021repl-pict.tex")')
  end


unixnewlines = function (bigstr)
    return (bigstr:gsub("\r\n", "\n"):gsub("\r", "\n"))
  end



-- «Path.addLUAtopath»  (to ".Path.addLUAtopath")
-- Notes about redefining Path.addLUAtopath:
-- 1) its default is here:
--    (to "Path")
--    (to "Path" "addLUAtopath =")
-- 2) in my machine ~/LUA/ is not in the Lua path
-- 3) most of the Lua libraries that I wrote are in ~/LUA/
-- 4) _usually_ things like 'require "Tos2"' only work after Path.addLUAtopath()
-- 5) _usually_ running Path.addLUAtopath() adds ~/LUA/ to the Lua path
-- 6) in some tests I need to make Path.addLUAtopath() a no-op
-- 7) in show2-elpeg1 Path.addLUAtopath() needs to be a no-op
-- 8) in show2-elpeg1 the redefinition below should be uncommented
--Path.addLUAtopath = function () end



-- Local Variables:
-- coding: utf-8-unix
-- End:
