return {
  { "neoclide/coc.nvim", branch = "release" },
  "liuchengxu/vista.vim",
  "vim/killersheep",
  "tmhedberg/SimpylFold",
  "jiangmiao/auto-pairs",
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
  },
  "preservim/nerdcommenter",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "vim-airline/vim-airline",
  "vim-scripts/matchit.zip",
  "vim-scripts/python_match.vim",
  {
    "SirVer/ultisnips",
    dependencies = { "honza/vim-snippets" },
  },
  "NLKNguyen/papercolor-theme",
  "morhetz/gruvbox",
  "nixon/vim-vmath",
  "gavinbeatty/dragvisuals.vim",
  "lervag/vimtex",
  "wellle/targets.vim",
  "airblade/vim-gitgutter",
  {
    "vimwiki/vimwiki",
    init = function()
      -- Don't claim every .md file on the system as a temporary wiki; vimwiki
      -- manages only files inside a registered wiki path, so .md stays markdown.
      vim.g.vimwiki_global_ext = 0
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    -- "vimwiki" covers .md files that really are inside a registered wiki
    ft = { "markdown", "vimwiki" },
    build = function() vim.fn["mkdp#util#install_sync"]() end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown", "vimwiki" }
    end,
    keys = {
      { "<Leader>mp", "<Cmd>MarkdownPreviewToggle<CR>", ft = { "markdown", "vimwiki" },
        desc = "Toggle markdown preview" },
    },
  },
  "easymotion/vim-easymotion",
  { "dracula/vim", name = "dracula" },
  {
    "tpope/vim-surround",
    dependencies = { "tpope/vim-repeat" },
  },
  "alvan/vim-closetag",
  "tweekmonster/django-plus.vim",
  "MaxMEllon/vim-jsx-pretty",
}
