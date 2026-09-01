return {
  {
    "liuchengxu/vista.vim",
    init = function()
      vim.g.vista_default_executive = "coc"
    end,
    keys = {
      { "<Leader>v", "<Cmd>Vista!!<CR>", desc = "Toggle Vista" },
    },
  },
  {
    "preservim/nerdtree",
    cmd = { "NERDTree", "NERDTreeToggle" },
    dependencies = {
      "ryanoasis/vim-devicons",
      "tiagofumo/vim-nerdtree-syntax-highlight",
    },
    keys = {
      { "<C-n>", "<Cmd>NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
    },
    config = function()
      local group = vim.api.nvim_create_augroup("NerdTreeUserConfig", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "nerdtree",
        callback = function(args)
          vim.keymap.set("n", "/", "/\\c", { buffer = args.buf })
        end,
      })
    end,
  },
  {
    "easymotion/vim-easymotion",
    init = function()
      vim.g.EasyMotion_verbose = 0
    end,
    config = function()
      vim.cmd([[
        map <Space> <Plug>(easymotion-prefix)
        map S <Plug>(easymotion-s)
      ]])
    end,
  },
}
