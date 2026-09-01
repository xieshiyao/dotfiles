return {
  {
    "tmhedberg/SimpylFold",
    init = function()
      vim.g.SimpylFold_docstring_preview = 1
    end,
  },
  {
    "jiangmiao/auto-pairs",
    init = function()
      vim.g.AutoPairsShortcutToggle = ""
    end,
    config = function()
      local group = vim.api.nvim_create_augroup("AutoPairsUserConfig", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "htmldjango",
        callback = function()
          vim.b.AutoPairs = vim.fn.AutoPairsDefine({
            ["{%"] = "%}",
            ["{#"] = "#}",
          })
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "tex",
        callback = function()
          vim.b.AutoPairs = {
            ["("] = ")",
            ["["] = "]",
            ["{"] = "}",
            ["'"] = "'",
            ['"'] = '"',
            ['"""'] = '"""',
            ["'''"] = "'''",
            ["$"] = "$",
          }
        end,
      })
    end,
  },
  {
    "SirVer/ultisnips",
    dependencies = { "honza/vim-snippets" },
    init = function()
      vim.g.UltiSnipsEditSplit = "horizontal"
      vim.g.UltiSnipsExpandTrigger = "<C-j>"
      vim.g.UltiSnipsJumpForwardTrigger = "<C-j>"
      vim.g.UltiSnipsSnippetsDir = vim.fn.expand("~/myUltiSnips/")
      vim.g.UltiSnipsSnippetDirectories = {
        vim.fn.expand("~/myUltiSnips"),
        "UltiSnips",
      }
    end,
  },
  {
    "nixon/vim-vmath",
    config = function()
      vim.cmd([[
        vmap <expr> ++ VMATH_YankAndAnalyse()
        nmap ++ vip++
      ]])
    end,
  },
  {
    "gavinbeatty/dragvisuals.vim",
    config = function()
      vim.cmd([[
        vmap <expr> <Left> DVB_Drag('left')
        vmap <expr> <Right> DVB_Drag('right')
        vmap <expr> <Down> DVB_Drag('down')
        vmap <expr> <Up> DVB_Drag('up')
        vmap <expr> D DVB_Duplicate()
      ]])
    end,
  },
  "preservim/nerdcommenter",
  "wellle/targets.vim",
  {
    "tpope/vim-surround",
    dependencies = { "tpope/vim-repeat" },
  },
  "alvan/vim-closetag",
}
