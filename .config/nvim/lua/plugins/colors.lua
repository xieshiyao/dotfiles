return {
  "NLKNguyen/papercolor-theme",
  {
    "morhetz/gruvbox",
    init = function()
      vim.g.gruvbox_contrast_dark = "hard"
    end,
    config = function()
      vim.api.nvim_create_user_command("Theme", function(opts)
        if opts.args ~= "" then
          vim.g["gruvbox_contrast_" .. vim.o.background] = opts.args
          vim.cmd.colorscheme("gruvbox")
          return
        end

        vim.api.nvim_echo({
          { "g:gruvbox_contrast_light=" .. tostring(vim.g.gruvbox_contrast_light), "Title" },
          { " g:gruvbox_contrast_dark=" .. tostring(vim.g.gruvbox_contrast_dark), "Title" },
        }, false, {})
      end, {
        nargs = "?",
        complete = function()
          return { "soft", "medium", "hard" }
        end,
        desc = "Show or set the Gruvbox contrast",
      })
    end,
  },
  {
    "dracula/vim",
    name = "dracula",
    lazy = false,
    priority = 1000,
    config = function()
      if vim.fn.has("mac") == 0 then
        vim.opt.termguicolors = true
      end

      vim.cmd.colorscheme("dracula")
      vim.api.nvim_set_hl(0, "Cursor", { reverse = true })
      vim.api.nvim_set_hl(0, "lCursor", { link = "Cursor" })
      vim.opt.guicursor = table.concat({
        "n-v-c-sm:block-Cursor",
        "i-ci-ve:ver25-Cursor",
        "r-cr-o:hor20-Cursor",
        "t:block-blinkon500-blinkoff500-Cursor",
      }, ",")
    end,
  },
  "vim-airline/vim-airline",
}
