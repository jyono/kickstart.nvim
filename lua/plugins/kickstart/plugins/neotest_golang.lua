--[[
  Path: lua/plugins/kickstart/plugins/neotest_golang.lua
  Module: plugins.kickstart.plugins.neotest_golang

  Purpose
    Lazy spec for neotest-golang: Neotest adapter for Go tests (table-driven,
    subtests) when you wire Neotest core elsewhere.

  Rationale
    Declared as a standalone plugin entry so enabling `nvim-neotest/neotest`
    later only requires adding the core plugin + runners; this stays inert until then.

  See https://github.com/nvim-neotest/neotest and adapter README.
]]

---@type LazySpec
return {
{
  'fredrikaverpil/neotest-golang',
},
}
