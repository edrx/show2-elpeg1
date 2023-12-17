-- This file:
--   http://anggtwu.net/LUA/ParseTree2.lua.html
--   http://anggtwu.net/LUA/ParseTree2.lua
--          (find-angg "LUA/ParseTree2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- Version: 2023dec16
--
-- This file implements a way to produce figures like these ones,
--   https://en.wikipedia.org/wiki/Context-free_grammar
--   http://anggtwu.net/LATEX/2023-2-C2-Tudo.pdf#page=6
-- using a parser written in ELpeg1,
--   (find-angg "LUA/ELpeg1.lua")
-- and a totexer:
--   (find-angg "LUA/ToTeX1.lua")
--   (find-angg "LUA/ToTeX1.lua" "totexer")
-- See:
--   (find-eev2023replsvideo "57:25")
--   (find-1stclassvideolsubs "eev2023repls" "57:25")

-- (defun pt2 () (interactive) (find-angg "LUA/ParseTree2.lua"))
-- (defun pt1 () (interactive) (find-angg "LUA/ParseTree1.lua"))
-- Supersedes:
--   (find-angg "LUA/ParseTree1.lua")

-- «.b-and-e»		(to "b-and-e")
-- «.subj»		(to "subj")
-- «.grammar»		(to "grammar")
-- «.grammar-tests»	(to "grammar-tests")
-- «.fmts»		(to "fmts")
-- «.fmts-tests»	(to "fmts-tests")
-- «.ParseTree»		(to "ParseTree")
-- «.ParseTree-tests»	(to "ParseTree-tests")

require "ELpeg1"       -- (find-angg "LUA/ELpeg1.lua")
require "ToTeX1"       -- (find-angg "LUA/ToTeX1.lua")
require "Co1"          -- (find-angg "LUA/Co1.lua")

-- «b-and-e»  (to ".b-and-e")
-- (find-angg "LUA/ELpeg1.lua" "Gram" "mt_VAST =")
Gram.__index.mt_VAST = function (gr)
    return {
      __newindex = function (v,name,pat)
          pat = Cp():Cg"b" * pat * Cp():Cg"e"
          gr:set(name, Cast(name,pat))
        end,
    }
  end

-- «subj»  (to ".subj")
-- (find-angg "LUA/ELpeg1.lua" "Gram" "cm0 =")
Gram.__index.cm0 = function (gr, top, newsubj, pos)
    subj = newsubj
    if type(pos) == "string" then pos = subj:match(pos) end
    return gr:compile(top):match(subj, pos)
  end

-- «grammar»  (to ".grammar")
gr,V,VA,VE,PE = Gram.new()
_           = S(" ")^0
VA.num      = (R"09"^1):C()
VA.op       = (S"+-"):C()
VA.sum      = V.num *(_*V.op*_*V.num)^0
VA.Stmt     = V.Id *_*C("=")*_* V.Expr *_*";"
            + "{"  *_* V.StmtList *_*"}"
            + C("if") *_* "(" *_* V.Expr *_* ")" *_* V.Stmt
VA.StmtList = V.Stmt * (_*V.Stmt)^0
V.Expr0     = V.Id
            + V.Num
VA.Expr     = V.Expr0*(_*V.Optr*_*V.Expr0)^0
VA.Id       = C"x" + C"y"
VA.Num      = C(R"09")
VA.Optr     = C(S">+")

-- «grammar-tests»  (to ".grammar-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ParseTree2.lua"
  o = gr:cm0("Stmt", "if (x>9) { x=0; y=y+1;}")
= o
= o[1]
= o[2][1]
  PPV(o[2][1])

--]==]


defs.ParseTree = [=[
  % (find-LATEX "2023-2-C2-intro.tex" "gramatica-fig")
  \def\und#1#2{\underbrace{#1}_{\textstyle#2}}
  \def\ColorRed#1{{\color{red}{#1}}}
  \def\NT  #1{\langle\textsf{#1}\rangle}        % non-terminal
  \def\SUBJ#1{\ColorRed{\tt#1}}
  \def\SUBJ#1{\mathstrut\ColorRed{\tt#1}}       % a substring of subj, in tt font 
]=]

-- «fmts»  (to ".fmts")
--
fmts["co"]     = "{\tt<ParseTree_cot(o[1])>}"
fmts["(subj)"] = "\\SUBJ{<ParseTree_cot(o[1])>}"
fmts["und"]    = "\\und{<1>}{<2>}"
fmts["."]      = "<mapconcat(totex, o)>"
fmts["<>"]     = "\\NT{<o[1]>}"

-- «fmts-tests»  (to ".fmts-tests")
--[==[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ParseTree2.lua"

osubj = mkast("(subj)", "{ }")
ont   = mkast("<>", "Stmts")
o     = mkast("und", osubj, ont)
= o:show {em=1}
 (etv)

--]==]



--  ____                    _____              
-- |  _ \ __ _ _ __ ___  __|_   _| __ ___  ___ 
-- | |_) / _` | '__/ __|/ _ \| || '__/ _ \/ _ \
-- |  __/ (_| | |  \__ \  __/| || | |  __/  __/
-- |_|   \__,_|_|  |___/\___||_||_|  \___|\___|
--                                             
-- «ParseTree»  (to ".ParseTree")

ParseTree_co  = Co.new("#${} ", "%&\\^_~"):add("\n", "\\\\\n")
ParseTree_cot = ParseTree_co:translator()

ParseTree = Class {
  type    = "ParseTree",
  deletestrings = function (o) return ParseTree{}:copyo(o,"mkstr0") end,
  dotstrings    = function (o) return ParseTree{}:copyo(o,"mkstr1") end,
  subjstrings0  = function (o) return ParseTree{}:copywithsubj(o) end,
  subjstrings   = function (o)
      return ParseTree.subjstrings0(ParseTree.deletestrings(o))
    end,
  __index = {
    cot    = function (pt,str) return ParseTree_cot(str) end,
    psubj  = function (pt,pos1,pos2) return subj:sub(pos1,pos2-1) end, 
    osubj  = function (pt,o) return pt:psubj(o.b, o.e) end,
    isast  = function (pt,o) return otype(o) == "AST" end,
    --
    copy0 = function (pt,ast) return AST {[0]=ast[0], b=ast.b, e=ast.e} end,
    add1  = function (pt,o,a) if a ~= nil then table.insert(o,a) end end,
    adds  = function (pt,o,...)
        local as = pack(...)
        for i=1,as.n do pt:add1(o,as[i]) end
      end,
    mkstr1 = function (pt,str) return "."..str.."." end,
    mkstr0 = function (pt,str) return nil end,
    copyo  = function (pt,o,mkstr)
        if pt:isast(o) then
          local o2 = pt:copy0(o)
          for i=1,#o do pt:adds(o2, pt:copyo(o[i], mkstr)) end
          return o2
        else
          return pt[mkstr](pt, o)
        end
      end,
    --
    mksubj0 = function (pt,pos1,pos2)
        return mkast("(subj)", pt:psubj(pos1,pos2))
      end,
    mksubj = function (pt,pos1,pos2)
        if pos1 < pos2 then return pt:mksubj0(pos1,pos2) end
      end,
    copywithsubj = function (pt,o)
        if not pt:isast(o) then error("Not an AST!") end
        local o2 = pt:copy0(o)
        local pos = o.b
        local add = function (o3) pt:add1(o2,o3) end
        local addsubj = function (pos1,pos2) add(pt:mksubj(pos1,pos2)) end
        if #o == 0 then
          addsubj(o.b, o.e)
        else
          for i=1,#o do
            addsubj(pos, o[i].b)
            add(pt:copywithsubj(o[i]))
            pos = o[i].e
          end
          addsubj(o[#o].e, o.e)
        end
        return o2
      end,
    --
    underbracify = function (pt, o)
        if not pt:isast(o) then print(o); error("^ Not an AST!") end
        if o[0] == "(subj)" then return o end
        local o1 = mkast("<>", o[0])
        local o2 = mkast(".")
        for i=1,#o do table.insert(o2, pt:underbracify(o[i])) end
        return mkast("und", o2, o1)
      end,
  },
}

-- «ParseTree-tests»  (to ".ParseTree-tests")
-- (find-angg "LUA/ELpeg1.lua" "totex-tests")
--[==[
 (find-angg "LUA/Show2.lua" "texbody")
 (find-code-show2 "~/LATEX/Show2.tex")
       (code-show2 "~/LATEX/Show2.tex")
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ParseTree2.lua"
o = gr:cm0("Stmt", "if (x>9) { x=0; y=y+1;}")
= o

pt = ParseTree {}
o0 = pt:copyo(o, "mkstr0")
o1 = pt:copyo(o, "mkstr1")
= o1
= o0

o9  = pt:copywithsubj(o0)
o10 = pt:underbracify(o9)
-- = o9
-- = o10
= o10:show {em=1}
 (etv)

= defs
-- (find-angg "LUA/Co1.lua" "Co-tests")

--]==]



--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ParseTree2.lua"
o = gr:cm0("Stmt", "if (x>9) { x=0; y=y+1;}")
= o
= copyo(o)

--]]





-- Local Variables:
-- coding:  utf-8-unix
-- End:
