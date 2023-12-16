-- eoo.lua: Edrx'x simple OO scheme, with explanations.
-- This file:
--   http://anggtwu.net/LUA/eoo.lua.html
--   http://anggtwu.net/LUA/eoo.lua
--          (find-angg "LUA/eoo.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
-- Version: 2021sep12
-- License: GPL3 - if you need another license, ask me.
--
-- A very simple object system.
-- Here's a _very_ short description of how it works:
--
--   The metatable of each object points to its class;
--   classes are callable, and act as creators.
--   New classes can be created with, e.g.:
--     Circle = Class { type = "Circle", __index = {...} }
--   then:
--     Circle {size = 1}
--   sets the metatable of the table {size = 1} to Circle,
--   and returns the table {size = 1} (with its __mt modified).
--
-- There are real docs (with lots of diagrams!) below.
--
-- Version in my init file: (find-angg "LUA/lua50init.lua" "eoo")
--         Originally from: (find-angg "LUA/canvas2.lua"  "Class")
--                  A tool: (find-angg ".emacs.templates" "class")
--            Compare with: http://lua-users.org/wiki/ObjectOrientedProgramming

-- «.Class»			(to "Class")
-- «.otype»			(to "otype")

-- Docs:
--   «.syntax-sugars»		(to "syntax-sugars")
--   «.__mt»			(to "__mt")
--   «.__mt-box»		(to "__mt-box")
--   «.Vector»			(to "Vector")
--   «.Vector-reductions»	(to "Vector-reductions")
-- Tests:
--   «.test-Vector»		(to "test-Vector")
--   «.test-override»		(to "test-override")



-- «Class» (to ".Class")
-- The code for "Class" is just these five lines.
Class = {
    type   = "Class",
    __call = function (class, o) return setmetatable(o, class) end,
  }
setmetatable(Class, Class)


-- «otype» (to ".otype")
-- "otype(o)" works like "type(o)", except on my "objects" and on
-- objects whose metatables are registered in otype_metatables.
-- For example, after doing
--   otype_metatables[getmetatable(lpeg.P(1))] = "lpeg"
-- then the otype of any lpeg pattern will be "lpeg".
otype_metatables = {}

otype = function (o)
    local  mt = getmetatable(o)
    return mt and (otype_metatables[mt] or mt.type) or type(o)
  end




-- «over» (to ".over")
-- Code for inheritance.
-- Note: I have used this only a handful of times, and ages ago!
-- See: (find-dn6 "diagstacks.lua" "MetaStack")
--      (find-dn6 "diagstacks.lua" "MetaStack" "MetaStack = ClassOver(Stack) {")
over = function (uppertable)
    return function (lowertable)
        setmetatable(uppertable, {__index=lowertable})
        return uppertable
      end
  end

ClassOver = function (upperclassmt)
    return function (lowerclass)
        setmetatable(upperclassmt.__index, {__index=lowerclass.__index})
        return Class(upperclassmt)
      end
  end






--  ____                 
-- |  _ \  ___   ___ ___ 
-- | | | |/ _ \ / __/ __|
-- | |_| | (_) | (__\__ \
-- |____/ \___/ \___|___/
--                       
--[==[

 «syntax-sugars»  (to ".syntax-sugars")

1. Syntax sugars
================
The best way to explain _in all details_ how this system of classes
and objects works is by introducing some new notations, or "syntax
sugars", that will be valid only in these comments; they are not
implemented in the Lua parser. The squiggly arrow "⇝" will mean
"desugars to", and is used like this:

                new notation  ⇝  more basic notation

In Lua these three syntax sugars are standard:

                       T.foo  ⇝  T["foo"]
  function foo (...) ... end  ⇝  foo = function (...) ... end
                foo:bar(...)  ⇝  foo.bar(foo, ...)

They are explained in these sections of the manual:

  (find-lua51manual "#2.2" "field name as an index" "a.name"   "a[\"name\"]")
  (find-lua51manual "#2.3"                        "var.Name" "var[\"Name\"]")
  (find-lua51manual "#2.5.8" "v:name(args)" "v.name(v, args)")
  (find-lua51manual "#2.5.9" "function f () body end")
  (find-lua51manual "#2.5.9" "colon syntax")

Our two first syntax sugars are these: "λ" will be an abbreviation for
"function", and "⇒" will be an abbreviation for "return". So:

  λ(a,b) ⇒ expr end   ⇝   function (a,b) return expr end

Our third syntax sugar will be the "__mt" notation for metatables - we
will pretend that the field ".__mt" of a table accesses its metatable.
So:

         B.__mt       ⇝   getmetatable(B)
         B.__mt = A   ⇝   setmetatable(B, A)

Now some diagrammatic notations. We will draw tables as boxes with two
coluns in which each line represents a key-value pair, like this:

         ╭──────────╮ 
  	 │  1  ┆ 10 │ 
  	 │  2  ┆ 20 │  ⇝  {10, 20, a=30, ["!"]=40}
  	 │ "a" ┆ 30 │ 
  	 │ "!" ┆ 40 │ 
  	 ╰──────────╯

This Lua code

  A = {10, 20, 30}
  B = {40, 50, a=A}

builds two tables, that we will draw like this:

        ╭──────────╮         ╭──────────╮ 
    B = │  1  ┆ 40 │     A = │  1  ┆ 10 │ 
        │  2  ┆ 50 │         │  2  ┆ 20 │  
        │ "a" ┆  • ───────>  │  3  ┆ 30 │  
        ╰──────────╯         ╰──────────╯  

A table with a metatable will be drawn in special way, with an "mt"
at its bottom left pointing to its metatable. This code

  A = {10, 20, 30}
  C = {40, 50}
  setmetatable(A, C)

generates the structures below; note that the "⇝" in the middle
indicates that the diagram at the left is a syntax sugar for the
diagram at the right...

        ╭──────────╮            ╭─────────────╮ 
    C = │  1  ┆ 40 │        C = │    1   ┆ 40 │ 
        │  2  ┆ 50 │            │    2   ┆ 50 │ 
        ╰mt────────╯            │ "__mt" ┆  • │ 
          │            ⇝        ╰───────────│─╯ 
          ╰──╮                        ╭─────╯   
             v                        v           
        ╭──────────╮             ╭──────────╮     
    A = │  1  ┆ 10 │         A = │  1  ┆ 10 │     
        │  2  ┆ 20 │             │  2  ┆ 20 │     
        │  3  ┆ 30 │             │  3  ┆ 30 │     
        ╰──────────╯             ╰──────────╯     

We will use the notation <func> to denote a function - that may or may
not have a global name. For example, this code,

  Class = {
      type   = "Class",
      __call = function (class, o) return setmetatable(o, class) end,
    }
  setmetatable(Class, Class)

creates this in the memory:

   <fcal> = function (class, o) return setmetatable(o, class) end

           ╭────────────────────╮     
   Class = │ "type"   ┆ "Class" │     
           │ "__call" ┆ <fcal>  │     
           ╰mt──────────────────╯     
             │    ^                   
             ╰────╯                    

If we didn't have the trick of giving names like "<bla>" to function
objects we would have to use bullets an arrows, like "• ──> ...", to
show that the field "__call" above points to a certain function.

From here onwards "Class" will always denote the table "Class" above.

Our last (diagrammatic) syntax sugar will give us a convenient way to
draw "normal" classes, i.e., classes that are not the class "Class".
Every "normal" class - for example: Vector - is made of two tables,
one for "the class itself" and another one for its "methods". When we
run this code,

  Vector = Class {
    type       = "Vector",
    __add      = function (V, W) return Vector {V[1]+W[1], V[2]+W[2]} end,
    __tostring = function (V) return "("..V[1]..","..V[2]..")" end,
    __index    = {
      norm = function (V) return math.sqrt(V[1]^2 + V[2]^2) end,
    },
  }

this will create these structures in the memory:

   <fcal> = function (class, o) return setmetatable(o, class) end
   <fadd> = function (V, W)     return Vector {V[1]+W[1], V[2]+W[2]} end
   <ftos> = function (V)        return "("..V[1]..","..V[2]..")" end,
   <fnrm> = function (V)        return math.sqrt(V[1]^2 + V[2]^2) end

           ╭─Class───────────────────╮              ╭─────────────────────────╮
  Vector = │ "type"       ┆ "Vector" │     Vector = │ "type"       ┆ "Vector" │        
           │ "__add"      ┆ <fadd>   │              │ "__add"      ┆ <fadd>   │        
           │ "__tostring" ┆ <ftos>   │              │ "__tostring" ┆ <ftos>   │ 
           ├─────────────────────────│   ⇝          │ "__index"    ┆    •     │        
           │ "norm"       ┆ <fnrm>   │              ╰mt─────────────────│─────╯ 
           ╰─────────────────────────╯                │              ╭──╯      
                                                      │              v         
                                                      │     ╭─────────────────╮        
                                                      │     │ "norm" ┆ <fnrm> │        
                                                      │     ╰─────────────────╯        
                                                      v                                
                                                    ╭────────────────────╮     
                                            Class = │ "type"   ┆ "Class" │     
                                                    │ "__call" ┆ <fcal>  │     
                                                    ╰mt──────────────────╯     
                                                      │    ^                   
                                                      ╰────╯                    

Note the "⇝" indicating that the diagram at the left is a
(diagrammatic) syntax sugar for the diagram at the right... the upper
part of the box, above the horizontal line, is "the class itself", and
the part below the horizontal line is its "table of methods". The
metatable of the "class itself" points to the table Class, that is
omitted from the drawing at the left, and ".__index" field points to
the "table of methods".



 «__mt» (to ".__mt")

2. The __mt notation
====================
Metatables are explained in detail in section 2.8 of the Lua manual,

  (find-lua51manual "#2.8" "Metatables")
  (find-lua51manual "#pdf-setmetatable")

but in a way that I find quite difficult. I found out that the "__mt
notation", described above, simplifies A LOT the description of _most_
of what happens when metatables are used and the metamethods like
"__index" or "__add" are called.

If A and B are tables having the same non-nil metatable, then modulo
details, we have these "reductions":

  A + B        ⇝  A.__mt.__add(A, B)
  A - B        ⇝  A.__mt.__sub(A, B)
  A * B        ⇝  A.__mt.__mul(A, B)
  A / B        ⇝  A.__mt.__div(A, B)
  A % B        ⇝  A.__mt.__mod(A, B)
  A ^ B        ⇝  A.__mt.__pow(A, B)
  - A          ⇝  A.__mt.__unm(A, A)
  A .. B       ⇝  A.__mt.__concat(A, B)
  #A           ⇝  A.__mt.__len(A, A)
  A == B       ⇝  A.__mt.__eq(A, B)
  A ~= B       ⇝  not (A == B)
  A < B        ⇝  A.__mt.__lt(A, B)
  A <= B       ⇝  A.__mt.__le(A, B)
                     (or not (B < A) in the absence of __le)
  A[k]         ⇝  A.__mt.__index(A, k)
  A[k] = v     ⇝  A.__mt.__newindex(A, k, v)
  A(...)       ⇝  A.__mt.__call(A, ...)
  tostring(A)  ⇝  A.__mt.__tostring(A)

The term "reduction" was borrowed from λ-calculus, but I am using it
here in an imprecise way. The listing above is a translation to the
__mt-notation of the "main cases" that are mentioned in these sections
of the manual:

  (find-lua51manual "#2.8" "op1 + op2")
  (find-lua51manual "#pdf-tostring")

and we follow the order in which these cases are listed in the manual.
The "main cases" are the cases in which both A and B are tables with
the same metatable, the expected method - like "__add" - is a field in
that metatable, and no errors happen. The manual also describes what
happens when we are not in the "main case"; then the expressions at
the left in the table above may "reduce" to other expressions.






 «__mt-box» (to ".__mt-box")

3. The __mt notation and box diagrams
=====================================
If we combine the reductions of the previous section with the box
diagrams from section 1 we can visualize how some quite intrincate
operations happen.

For example, we can depict the values of a and b after these
assignments,

  a = {10, 20, 30}
  b = {11, a, "foo", print}
  T = {__index = b}
  a.__mt = T

as:

      ╭─────────────╮         ╭────────╮
  b = │ 1 ┆    11   │     a = │ 1 ┆ 10 │
      │ 2 ┆     * ──────────> │ 2 ┆ 20 │
      │ 3 ┆  "foo"  │         │ 3 ┆ 30 │
      │ 4 ┆ <print> │         ╰mt──────╯
      ╰─────────────╯           │
           ^                    v
           │                 ╭────────────────╮
           │             T = │ "__index" ┆ • ─────╮
           │                 ╰────────────────╯   │
           │                                      │
           ╰──────────────────────────────────────╯

Now let's try to calculate a[4] by a series of reductions. Without
metatables we would have a[4] = nil, so:

  a[4]  ⇝  a.__mt.__index[4]
        ⇝       T.__index[4]
        ⇝               b[4]
        ⇝            <print>

So a[4] yields <print>.




 «Vector» (to ".Vector")

4. A class "Vector"
===================
Consider this demo code:

--[[

 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "eoo.lua"   -- this file
Vector = Class {
  type       = "Vector",
  __add      = function (V, W) return Vector {V[1]+W[1], V[2]+W[2]} end,
  __tostring = function (V) return "("..V[1]..","..V[2]..")" end,
  __index    = {
    norm = function (V) return math.sqrt(V[1]^2 + V[2]^2) end,
  },
}
v = Vector  {3,  4}  --  v = { 3,  4, __mt = Vector}
w = Vector {20, 30}  --  w = {20, 30, __mt = Vector}
print(v)             --> (3,4)
print(v + w)         --> (23,34)
print(v:norm())      --> 5
print( type(v))      --> table
print(otype(v))      --> Vector
print( type(""))     --> string
print(otype(""))     --> string

--]]

After running the line "w = ..." we will have this:

   <fcal> = function (class, o) return setmetatable(o, class) end
   <fadd> = function (V, W)     return Vector {V[1]+W[1], V[2]+W[2]} end
   <ftos> = function (V)        return "("..V[1]..","..V[2]..")" end,
   <fnor> = function (V)        return math.sqrt(V[1]^2 + V[2]^2) end

            ╭───────╮       ╭────────╮
        v = │ 1 ┆ 3 │   w = │ 1 ┆ 20 │
            │ 2 ┆ 4 │       │ 2 ┆ 30 │
            ╰mt─────╯       ╰mt──────╯
              │╭─────────────╯
              ││
              vv
            ╭─────────────────────────╮
   Vector = │ "type"       ┆ "Vector" │
            │ "__add"      ┆ <fadd>   │
            │ "__tostring" ┆ <ftos>   │    
            │ "__index"    ┆   •      │
            ╰mt────────────────│──────╯    
              │                v
              │        ╭─────────────────╮
              │	       │ "norm" ┆ <fnor> │
              │	       ╰─────────────────╯
              v
            ╭────────────────────╮
    Class = │ "type"   ┆ "Class" │
            │ "__call" ┆ <fcal>  │
            ╰mt──────────────────╯
              │    ^
              ╰────╯



 «Vector-reductions» (to ".Vector-reductions")

5. The "Vector" demo: reductions
================================
We can now use the diagram above and our notation for reductions to
understand how expressions like these ones

  v = Vector {3, 4}
  v:norm()

work. Remember that we can calculate the result of applying a
λ-expression to its arguments in two steps, like this:

  (λ(a,b) ⇒ a+b) (3, 4)  ⇝  (a+b) [a:=3, b:=4]
                         ⇝  (3+4)

The "[a:=3, b:=4]" means "substitute all `a's by 3 and all `b's by 4
in the preceding expression".

Being slightly informal at some steps, we have this:

     Vector {3, 4}
  ⇝  Vector({3, 4})
  ⇝  Vector.__mt.__call(Vector, {3, 4})
  ⇝        Class.__call(Vector, {3, 4})
  ⇝              <fcal>(Vector, {3, 4})
  ⇝  (λ(class, o) ⇒ setmetatable(o, class)) (Vector, {3, 4})
  ⇝  (λ(class, o) o.__mt=class; ⇒ o)        (Vector, {3, 4})
  ⇝              (o.__mt=class; ⇒ o) [o:={3, 4}, class:=Vector]
  ⇝                                      {3, 4,    __mt=Vector}

and so:

    v = Vector {3, 4}
  ⇝ v =        {3, 4, __mt=Vector}

I am using ideas borrowed from basic λ-calculus to talk about mutable
objects, so I had to improvise at some points.

Here's what happens when we calculate "v:norm()":

     v:norm()
  ⇝  {3, 4, __mt=Vector}:norm()
  ⇝  {3, 4, __mt=Vector}.norm             ({3, 4, __mt=Vector})
  ⇝  {3, 4, __mt=Vector}.__mt.__index.norm({3, 4, __mt=Vector})
  ⇝                    Vector.__index.norm({3, 4, __mt=Vector})
  ⇝  (λ(V) ⇒ math.sqrt(V[1]^2+V[2]^2) end)({3, 4, __mt=Vector})
  ⇝         (math.sqrt(V[1]^2+V[2]^2)) [V:={3, 4, __mt=Vector}]
  ⇝          math.sqrt(   3^2+   4^2)
  ⇝          math.sqrt(           25)
  ⇝                                5





6. Overriding methods
=====================
(I use this a lot. TODO: write this section!)
Demo:




Everything below this point
will be rewritten and/or deleted.
--snip--snip--

The section on __mt reductions was adapted from:
  http://anggtwu.net/__mt.html
           (find-TH "__mt")

Gavin Wraith implemented two shorthands in his RiscLua: "\" is a
shorthand for "function" and "=>" is a shorthand for "return". We
will use unicode characters instead: "λ" will be a shorthand for
"function" and "⇒" will be a shorthand for "return". With that
we can write, for example,

  square = λ(x) ⇒ x*x end

instead of:

  square = function (x) return x*x end

See:
  http://www.wra1th.plus.com/lua/notes/Scope.html
  (find-es "lua5" "risclua")

We will also use the notation [var := value] for substituion of a
single variable, and [var1 := value1, var2 := value2 ...] for
simultaneous substitution. A beta-reduction can be calculated in two
steps:

  (λ(x) ⇒ x*x end)(5)  ⇝  (x*x)[x:=5]
                       ⇝   5*5

--]==]





--  _____         _       
-- |_   _|__  ___| |_ ___ 
--   | |/ _ \/ __| __/ __|
--   | |  __/\__ \ |_\__ \
--   |_|\___||___/\__|___/
--                        
--[[
-- «test-Vector»  (to ".test-Vector")

 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "eoo.lua"   -- this file
Vector = Class {
  type       = "Vector",
  __add      = function (V, W) return Vector {V[1]+W[1], V[2]+W[2]} end,
  __tostring = function (V) return "("..V[1]..","..V[2]..")" end,
  __index    = {
    norm = function (V) return math.sqrt(V[1]^2 + V[2]^2) end,
  },
}
v = Vector  {3,  4}  --  v = { 3,  4, __mt = Vector}
w = Vector {20, 30}  --  w = {20, 30, __mt = Vector}
print(v)             --> (3,4)
print(v + w)         --> (23,34)
print(v:norm())      --> 5
print( type(v))      --> table
print(otype(v))      --> Vector
print( type(""))     --> string
print(otype(""))     --> string


-- «test-override»  (to ".test-override")
-- Eoo.lua is "REPL-friendly" in the sense that it is easy to add new
-- methods to a class, and to override old methods, from a REPL.

 (eepitch-lua51)
 (eepitch-kill)
 (eepitch-lua51)
dofile "eoo.lua"
Foo = Class {
  type = "Foo",
  new        = function (v) return Foo({v=v}) end,
  __tostring = function (o) return o:tostring() end,
  __index = {
    tostring = function (o) return "(" .. o.v .. ")" end
  },
}

a = Foo.new(42)
= a              --> (42)
b = Foo.new(99)
= b              --> (99)

-- This overrides the default ":tostring" of the class:
Foo.__index.tostring = function (o) return "[" .. o.v .. "]" end
= a              --> [42]
= b              --> [99]

-- This overrides the ":tostring" method in a single instance:
a.tostring           = function (o) return "<" .. o.v .. ">" end
= a              --> <42>
= b              --> [99]

-- This creates an instance with an overriden ":tostring" method:
c = Foo {v=200, tostring = function (o) return "<<" .. o.v .. ">>" end}
= c              --> <<200>>

--]]







-- Local Variables:
-- coding:  utf-8-unix
-- End:
