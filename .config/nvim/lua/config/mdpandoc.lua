-- Pandoc-based markdown preview, for the LaTeX delimiters that
-- markdown-preview.nvim cannot parse: \[ ... \] and \( ... \).
--
-- mkdp bundles a fork of markdown-it-katex that only implements $...$ and
-- $$...$$, and that parser lives inside its prebuilt browser bundle, so the
-- delimiters can't be configured. Pandoc's +tex_math_single_backslash reads
-- both styles and renders via MathJax.
--
-- Tradeoffs vs :MarkdownPreview -- no live update and no scroll sync (re-render
-- and reload the tab), and MathJax comes from a CDN, so this one needs network.

local M = {}

local CACHE = vim.fn.stdpath("cache") .. "/mdpandoc"
local opened = {}

-- Stable path per buffer, so re-rendering refreshes the same browser tab.
local function out_path(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local key = name == "" and ("buffer-" .. buf)
    or vim.fn.fnamemodify(name, ":p"):gsub("[^%w%-_%.]", "_")
  return CACHE .. "/" .. key .. ".html"
end

---@param buf integer|nil buffer to render (default: current)
---@param quiet boolean|nil suppress the success message (used by the autosave hook)
function M.preview(buf, quiet)
  buf = buf or vim.api.nvim_get_current_buf()

  if vim.fn.executable("pandoc") == 0 then
    vim.notify("MdPreviewPandoc: pandoc not found in $PATH", vim.log.levels.ERROR)
    return
  end

  vim.fn.mkdir(CACHE, "p")

  local name = vim.api.nvim_buf_get_name(buf)
  local out = out_path(buf)
  local dir = name ~= "" and vim.fn.fnamemodify(name, ":p:h") or assert(vim.uv.cwd())
  local title = name ~= "" and vim.fn.fnamemodify(name, ":t") or ("buffer " .. buf)

  -- The HTML lives in the cache dir, so relative images/links would break;
  -- <base> points them back at the source directory.
  local header = out .. ".header.html"
  vim.fn.writefile({ ('<base href="%s/">'):format(vim.uri_from_fname(dir)) }, header)

  local res = vim
    .system({
      "pandoc",
      "-f",
      "markdown+tex_math_single_backslash",
      "-t",
      "html",
      "--standalone",
      "--mathjax",
      "--resource-path",
      dir,
      "--include-in-header",
      header,
      "--metadata",
      "title=" .. title,
      "-o",
      out,
    }, {
      -- render the buffer, not the file on disk, so unsaved edits show up
      stdin = vim.api.nvim_buf_get_lines(buf, 0, -1, false),
      text = true,
    })
    :wait()

  if res.code ~= 0 then
    vim.notify(
      "MdPreviewPandoc: pandoc exited " .. res.code .. "\n" .. (res.stderr or ""),
      vim.log.levels.ERROR
    )
    return
  end

  if not opened[out] then
    local ok, obj, err = pcall(vim.ui.open, out)
    if not ok then
      obj, err = nil, obj
    end
    if not obj then
      vim.notify("MdPreviewPandoc: could not open browser: " .. tostring(err), vim.log.levels.ERROR)
      return
    end
    opened[out] = true
    vim.notify("MdPreviewPandoc: opened " .. out)
  elseif not quiet then
    vim.notify("MdPreviewPandoc: re-rendered, reload the browser tab")
  end

  -- keep the rendered file current on every write of this buffer
  if not vim.b[buf].mdpandoc_hooked then
    vim.b[buf].mdpandoc_hooked = true
    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = buf,
      group = vim.api.nvim_create_augroup("MdPandoc", { clear = false }),
      desc = "Re-render pandoc markdown preview",
      callback = function()
        M.preview(buf, true)
      end,
    })
  end
end

vim.api.nvim_create_user_command("MdPreviewPandoc", function()
  M.preview()
end, { desc = [[Preview markdown via pandoc + MathJax (handles \[ \] and \( \))]] })

vim.keymap.set("n", "<Leader>mP", "<Cmd>MdPreviewPandoc<CR>", {
  desc = "Markdown preview (pandoc/MathJax)",
})

return M
