-- This file:
--   http://anggtwu.net/LUA/Tos2.lua.html
--   http://anggtwu.net/LUA/Tos2.lua
--          (find-angg "LUA/Tos2.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- (defun e () (interactive) (find-angg "LUA/Tos2.lua"))
--
-- Like this: (find-angg "LUA/Tos.lua")
-- but with some changes.
-- Status: experimental, used in very few places.

-- «.Tos»		(to "Tos")
-- «.Tos-tests»		(to "Tos-tests")
-- «.PPC»		(to "PPC")
-- «.PPC-tests»		(to "PPC-tests")

table.empty = function (T) return next(T) == nil end



--  _____         
-- |_   _|__  ___ 
--   | |/ _ \/ __|
--   | | (_) \__ \
--   |_|\___/|___/
--                
-- «Tos»  (to ".Tos")

Tos = Class {
  type    = "Tos",
  __index = {
    --
    -- Basic methods:
    --   n:     number to string
    --   f:     function to string
    --   s:     string to string - adds quotes
    --   other: other object, like nil/bool/function, to string
    --   o:     object (of any type) to string
    --   ov:    like o, but vertical in a simplistic way
    --   t:     table to string - calls t0
    --   t0:    table to string, low level - calls kvs and getsortedkeys
    --   kvs:   listofkeyvaluepairs to string
    --   kv:    keyvaluepair to string
    --   k:     key to string
    --   v:     value to string
    --
    n  = function (tos, n) return tostring(n) end,
    s  = function (tos, s) return format("%q", s) end,
    f1 = function (tos, o) return PrintFunction.tostring(o) end,
    f0 = function (tos, o) return "<"..tostring(o)..">" end,
    f  = function (tos, o) return "<"..tostring(o)..">" end,
    other = function (tos, o) return "<"..tostring(o)..">" end,
    --
    o = function (tos, o, a,sep,b,emp)
        local ty = type(o)
        if ty=="number"   then return tos:n(o) end
        if ty=="string"   then return tos:s(o) end
        if ty=="function" then return tos:f(o) end
        if ty=="table"    then return tos:t(o, a,sep,b,emp) end
        return tos:other(o)
      end,
    t = function (tos, T, a,sep,b,emp)
        return tos:t0(T, a,sep,b,emp)
      end,
    t0 = function (tos, T, a,sep,b,emp)
        if table.empty(T) and emp then return emp end
        local body = tos:kvs(tos:getsortedkvs(T), sep)
        return (a or "{")..body..(b or "}")
      end,
    --
    kvs = function (tos, ps, sep)
        local kvtostring = function (p) return tos:kv(p) end
        return mapconcat(kvtostring, ps, sep or ", ")
      end,
    kv = function (tos, p) return tos:k(p.key).."="..tos:o(p.val) end,
    k  = function (tos, k) return tos:o(k) end,
    v  = function (tos, v) return tos:o(v) end,
    --
    -- t0 uses getsortedkvs to sort the key-value pairs of a table.
    getsortedkvs = function (tos, T)
        return sorted(tos:getkvs(T), tos.comparekvs)
      end,
    getkvs = function (tos, T)
        local kvs = {}
        for k,v in pairs(T) do table.insert(kvs, {key=k, val=v}) end
	return kvs
      end,
    comparekvs = function (kv1, kv2)  -- not a method!
        local k1,k2 = kv1.key, kv2.key
        return rawtostring_comp(k1, k2)
      end,
    --
    -- A "vertical" alternative to o.
    ov = function (tos, o, a,sep,b,emp)
        return tos:o(o, "{ ", ",\n  ", "\n}", "{}")
      end,
    --
    -- An alternative to kv that uses square brackets.
    kvb = function (tos, p)
        return "["..tos:k(p.key).."]="..tos:o(p.val)
      end,
    --
    -- An alternative to t.
    -- When tos is an object of the class Tos
    --  and foo is an object of the class Foo we have this:
    --   tos:t (foo)  -->     "{...}"
    --   tos:tp(foo)  --> "Foo:{...}"
    --   
    tp = function (tos, T, a,sep,b,emp)
        return tos:tprefix(T)..tos:t0(T, a,sep,b,emp)
      end,
    tprefix = function (tos, T, sep)
        local mt = getmetatable(T)
        local typename = mt and mt.type
	return typename and (typename..(sep or ":")) or "" 
      end,
    --
    -- Another alternative to (the outermost) t.
    tcols = function (tos, T, fmt)
        fmt = fmt or "%-14s %s"
        local kvs = tos:getsortedkvs(T)
        local f = function (kv) return format(fmt, tos:o(kv.key), tos:o(kv.val)) end
        return mapconcat(f, kvs, "\n")
      end,
  },
}


-- «Tos-tests»  (to ".Tos-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Tos2.lua"
A = { 2, "foo", {3, 4}, VTable{5, 6} }
A = { 2, "foo", a={3, 4}, b=VTable{5, 6} }
= Tos{}:o(A)


= Tos{}                 :tcols(Tos.__index)
= Tos{f=Tos.__index.f1} :tcols(Tos.__index)
= Tos{f=Tos.__index.f1} :tcols(Tos.__index, " %-14s %s")
= Tos{f=Tos.__index.f1} :tcols(Tos)  -- messy

Tos.__index.f = Tos.__index.f1
= Tos{}:tcols(Tos)
= Tos{}:tcols(Tos.__index)
= Tos{}:tcols(Tos.__index, " %-14s %s")



tos  = Tos {}
tosp = Tos {  t=Tos.__index.tp }
tosv = Tos {  o=Tos.__index.ov }
tosb = Tos { kv=Tos.__index.kvb }

= Tos.__index.f(nil, split)
= tos :o(split)

PP(split)

= tos :o(A)
= tosp:o(A)
= tos :ov(A)
= tosp:ov(A)
= tosb:ov(A)

     PPV(Tos.__index)
= tosv:o(Tos.__index)  -- Fix this
= tosv:ov(Tos.__index)  -- Fix this


= mapconcat(mytostring, sortedkeys(A), " ")

= keys(A)
PP(keys(A))



--]]


-- «PPC»  (to ".PPC")
PPC = function (T) print(Tos{f=Tos.__index.f1}:tcols(T)) end

-- «PPC-tests»  (to ".PPC-tests")
--[[
 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "Tos2.lua"
PPC(Tos.__index)

--]]







-- Local Variables:
-- coding:  utf-8-unix
-- End:

