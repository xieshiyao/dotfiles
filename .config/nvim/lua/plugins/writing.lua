return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.tex_fold_enabled = 1
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull",
        "Overfull",
        "relsize Warning",
        "usage of the caption package is not recommended",
      }
    end,
  },
  {
    "vimwiki/vimwiki",
    init = function()
      -- Don't claim every .md file on the system as a temporary wiki; vimwiki
      -- manages only files inside a registered wiki path, so .md stays markdown.
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_key_mappings = {
        all_maps = 1,
        global = 1,
        headers = 1,
        text_objs = 1,
        table_format = 1,
        table_mappings = 0,
        lists = 1,
        links = 1,
        html = 1,
        mouse = 0,
      }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "vimwiki" },
    build = function()
      vim.fn["mkdp#util#install_sync"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "vimwiki" }
    end,
    keys = {
      {
        "<Leader>mp",
        "<Cmd>MarkdownPreviewToggle<CR>",
        ft = { "markdown", "vimwiki" },
        desc = "Toggle markdown preview",
      },
    },
  },
  "tweekmonster/django-plus.vim",
  "MaxMEllon/vim-jsx-pretty",
}
