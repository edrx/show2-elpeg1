-- This file:
--   http://anggtwu.net/LUA/ParseTimeline1.lua.html
--   http://anggtwu.net/LUA/ParseTimeline1.lua
--          (find-angg "LUA/ParseTimeline1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- See:
--   (find-angg "bin/eevgitlib1.sh" "Time-tests")
--   (find-angg "LUA/Loeliger1.lua" "big")

-- (defun e () (interactive) (find-angg "LUA/ParseTimeline1.lua"))

-- «.test1»	(to "test1")
-- «.test2»	(to "test2")

require "ELpeg1"   -- (find-angg "LUA/ELpeg1.lua")

BranchLine = Class {
  type = "BranchLine",
  from = function (li) return BranchLine {li=li} end,
  __tostring = function (bl) return bl:totex() end,
  __index = {
    split0 = function (bl) return bl.li:match "%((.-)%) *(.*)" end,
    split = function (bl)
        local a,b = bl:split0()
        bl.a, bl.b = bitrim(a), bitrim(b)
        return bl
      end,
    mktex0 = function (bl)
        local A = HTable {}
        for s in bl.a:gmatch("([^,]+)") do
          s = bitrim(s)
          local c = s:match("HEAD %-> (.*)")
          if c then table.insert(A, c.."\\HEAD")
          elseif s == "HEAD" then table.insert(A, "\\HEAD")
          else table.insert(A, s)
          end
        end
        -- local tex0 = table.concat(A, "\\\\")
        local tex0 = table.concat(sorted(A), "\\\\")
        bl.tex0 = tex0
        return bl
      end,
    mktex1 = function (bl)
        bl.tex1 = format("\\drawbranch %s {%s};", bl.b, bl.tex0)
      end,
    totex = function (bl) bl:split():mktex0():mktex1(); return bl.tex1 end,
  },
}

Block = Class {
  type = "Block",
  from = function (t0) return Block {t0=t0, texs=VTable{}} end,
  __tostring = function (blo) return blo:loelines() end,
  __index = {
    add = function (blo,tex) table.insert(blo.texs, tex); return blo end,
    close = function (blo,t1) blo.t1=t1; return blo end,
    left = function (blo) return format('"%s"<=t and t<"%s"', blo.t0, blo.t1) end,
    loeline = function (blo,i) return format("  %s  :: %s", blo:left(), blo.texs[i]) end,
    loelines = function (blo)
        local f = function (i) return blo:loeline(i) end
        return mapconcat(f, seq(1,#blo.texs), "\n")
      end,
  },
}

Blocks = Class {
  type = "Blocks",
  new = function () return Blocks {times = VTable{}} end,
  __tostring = function (bls) return bls:toloelines() end,
  __index = {
    addtime = function (bls,time)
        if #bls > 0 then bls[#bls]:close(time) end
        table.insert(bls, Block.from(time))
        table.insert(bls.times, time)
        return bls
      end,
    addright = function (bls,right)
        table.insert(bls[#bls].texs, right)
        return bls
      end,
    toloelines = function (bls)
        local f = function (i) return bls[i]:loelines() end
        return mapconcat(f, seq(1,#bls-1), "\n")
      end,
    totimes = function (bls)
        return table.concat(blos.times, " ", 1, #blos.times-1)
      end,
    addline = function (bls,li)
        local time = li:match("Time: (.*)")
        if time then bls:addtime(time); return end
        local bl = BranchLine.from(li)
        if bl:split0() then bls:addright(bl:totex()); return end
      end,
    addlines = function (bls,bigstr)
        for _,li in ipairs(splitlines(bigstr)) do
          bls:addline(li)
        end
        return bls
      end,
  },
}

bigstr0 = [=[
Time: C0
* 7226cf0 (master, brBDG) B
* a139b85 (HEAD -> brAC) A

Time: C1
* c78b23b (HEAD -> brAC) C
| * 7226cf0 (master, brBDG) B
|/  
* a139b85 A

Time: D0
* c78b23b (brAC) C
| * 7226cf0 (HEAD -> brBDG, master) B
|/  
* a139b85 A
]=]


-- «test1»  (to ".test1")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ParseTimeline1.lua"
-- for _,li in ipairs(splitlines(bigstr)) do
--   print(li)
--   bl = BranchLine.from(li)
--   -- if bl:split0() then print(bl:split().a) end
--   -- if bl:split0() then bl:split():mktex0(); print(bl.tex0) end
--   -- if bl:split0() then bl:split():mktex0():mktex1(); print(bl.tex1) end
--   if bl:split0() then print(bl:totex()) end
-- end

blo = Block.from("A1"):add("foo"):add("bar"):close("B0")
PPV(blo)
= blo:loelines()
= blo:loeline(1)
= blo:loeline(2)

blos = Blocks.new()
blos:addtime("B1"):addright("foo"):addright("bar")
blos:addtime("C0"):addright("plic"):addright("ploc")
blos:addtime("D0")

= blos
= blos[1]
= blos[1].texs
= blos[1]:loelines()
= blos[2]:loelines()
= blos:toloelines()

blos = Blocks.new():addlines(bigstr0):addtime("zz")
= blos

--]]



-- «test2»  (to ".test2")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "ParseTimeline1.lua"
bigstr = ee_readfile "/tmp/all"
blos = Blocks.new():addlines(bigstr):addtime("zz")
= blos
= blos.times
= blos:totimes()

--]]






-- Local Variables:
-- coding:  utf-8-unix
-- End:
