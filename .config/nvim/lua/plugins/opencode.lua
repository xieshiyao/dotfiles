return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      "folke/snacks.nvim",
      opts = {
        input = {},
        picker = {},
        terminal = {},
      },
    },
  },
  config = function()
    local opencode = require("opencode")
    local opencode_cmd = "opencode --port"
    local terminal_opts = {
      win = {
        position = "right",
        enter = false,
      },
    }

    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, terminal_opts)
        end,
      },
    }
    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      opencode.ask("@this: ")
    end, { desc = "Ask OpenCode", silent = true })

    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      opencode.select()
    end, { desc = "Select OpenCode action", silent = true })

    vim.keymap.set({ "n", "t" }, "<C-.>", function()
      require("snacks.terminal").toggle(opencode_cmd, terminal_opts)
    end, { desc = "Toggle OpenCode terminal", silent = true })

    vim.keymap.set({ "n", "x" }, "go", function()
      return opencode.operator("@this ")
    end, { desc = "Append range to OpenCode", expr = true })

    vim.keymap.set("n", "goo", function()
      return opencode.operator("@this ") .. "_"
    end, { desc = "Append line to OpenCode", expr = true })

    vim.keymap.set("n", "<S-C-u>", function()
      opencode.command("session.half.page.up")
    end, { desc = "Scroll OpenCode up", silent = true })

    vim.keymap.set("n", "<S-C-d>", function()
      opencode.command("session.half.page.down")
    end, { desc = "Scroll OpenCode down", silent = true })

    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment number", silent = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement number", silent = true })
  end,
}
