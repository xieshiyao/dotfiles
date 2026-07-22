local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. output)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json",
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "dracula" } },
  checker = { enabled = false },
  change_detection = { notify = false },
})

vim.api.nvim_create_user_command("LazyConfig", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/lua/config/lazy.lua")
end, { desc = "Edit lazy.nvim setup" })

vim.api.nvim_create_user_command("LazyPlugins", function()
  vim.cmd.edit(vim.fn.stdpath("config") .. "/lua/plugins/init.lua")
end, { desc = "Edit lazy.nvim plugin list" })
