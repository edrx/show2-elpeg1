-- This file:
--   http://anggtwu.net/LUA/DednatRequire1.lua.html
--   http://anggtwu.net/LUA/DednatRequire1.lua
--          (find-angg "LUA/DednatRequire1.lua")
-- Author: Eduardo Ochs <eduardoochs@gmail.com>
--
-- This makes the "require" in lualatex behave in a way that is more
-- compatible with the "require"s of plain Luas.
--
-- Initially I tried to fix the "broken" require of lualatex by using
-- a table.insert to insert a new function in the middle of this
-- table:
--
--   (find-lua51manual "#pdf-package.loaders")
--   (find-lua52manual "#pdf-package.searchers")
--   (find-lua52manual "#8.2" "package.loaders was renamed package.searchers")
--
-- Here are some e-mails about my first attempts to fix it:
--
--   https://tug.org/pipermail/luatex/2015-February/005071.html My problem with require
--   https://tug.org/pipermail/luatex/2015-February/005073.html My (obsolete) solution
--   https://tug.org/pipermail/luatex/2017-July/006589.html My problem with the .fls
--   https://tug.org/pipermail/luatex/2017-July/006590.html A solution: use loadfile
--   https://tug.org/pipermail/luatex/2020-November/007426.html My original question
--   https://tug.org/pipermail/luatex/2020-November/007427.html Luigi's answer 1
--   https://tug.org/pipermail/luatex/2020-November/007428.html My answer 1
--   https://tug.org/pipermail/luatex/2020-November/007429.html Luigi's answer 2
--   https://tug.org/pipermail/luatex/2020-November/007430.html Ulrike's answer
--
-- Then, at some point in texlive2020, my fix stopped working, and it
-- broke require in horrible ways... the new lualibs-package.lua was
-- redefining the entries in package.searchers and then referring to
-- the new seacher functions by their numeric indices, and my
-- table.insert was moving package.searchers[3] to
-- package.searchers[4] - and BOOM. See here:
--
--   https://github.com/latex3/lualibs/issues/4
--
-- This file has a fix for "require" that works (AFAIK) in all
-- versions of lualuatex. It saves a copy of "require" in
-- "oldrequire", defines "dednatrequire" as a wrapper around
-- "oldrequire", and then sets "require" to "dednatrequire". After
-- that we can switch between the two behaviors with:
--
--   require = oldrequire
--   require = dednatrequire
--
-- Also here:
--   (find-angg "LUA/lua50init.lua" "DednatRequire")
--   (find-angg "LUA/lua50init.lua" "loaddednatrequire")
-- Used by:
--   (find-angg "LUA/Show2.lua" "defs_repl")
-- Based on:
--   (find-dn6 "lualoader.lua")
--   (find-dn6 "lualoader.lua" "dednatlualoader")
--   (find-es "luatex" "package.searchers-2020")
--
-- (defun e () (interactive) (find-angg "LUA/DednatRequire1.lua"))


-- «.compatibility»		(to "compatibility")
-- «.DednatRequire»		(to "DednatRequire")

--   ____                            _   _ _     _ _ _ _         
--  / ___|___  _ __ ___  _ __   __ _| |_(_) |__ (_) (_) |_ _   _ 
-- | |   / _ \| '_ ` _ \| '_ \ / _` | __| | '_ \| | | | __| | | |
-- | |__| (_) | | | | | | |_) | (_| | |_| | |_) | | | | |_| |_| |
--  \____\___/|_| |_| |_| .__/ \__,_|\__|_|_.__/|_|_|_|\__|\__, |
--                      |_|                                |___/ 
--
-- «compatibility»  (to ".compatibility")
-- (find-lua51manual "#pdf-package.loaders")
-- (find-lua52manual "#pdf-package.searchers")
-- (find-lua52manual "#8.2" "package.loaders was renamed package.searchers")
package.searchers = package.searchers or package.loaders


--  ____           _             _   ____                  _          
-- |  _ \  ___  __| |_ __   __ _| |_|  _ \ ___  __ _ _   _(_)_ __ ___ 
-- | | | |/ _ \/ _` | '_ \ / _` | __| |_) / _ \/ _` | | | | | '__/ _ \
-- | |_| |  __/ (_| | | | | (_| | |_|  _ <  __/ (_| | |_| | | | |  __/
-- |____/ \___|\__,_|_| |_|\__,_|\__|_| \_\___|\__, |\__,_|_|_|  \___|
--                                                |_|                 
--
-- «DednatRequire»  (to ".DednatRequire")
-- Note that this is "fake" class, that doesn't
-- have __index, and doesn't have a metatable.
-- See: (find-lua51manual "#pdf-package.loaders" "first searcher")
--      (find-lua51manual "#pdf-package.loaders" "second searcher")
--      (find-angg "LUA/lua50init.lua" "DednatRequire")
--
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

oldrequire    = oldrequire or require
dednatrequire = DednatRequire.newrequire
require       = dednatrequire



-- Local Variables:
-- coding:  utf-8-unix
-- End:
