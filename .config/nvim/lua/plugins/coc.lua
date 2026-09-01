return {
  "neoclide/coc.nvim",
  branch = "release",
  init = function()
    vim.g.coc_global_extensions = {
      "coc-json",
      "coc-tsserver",
      "coc-css",
      "coc-vimlsp",
      "coc-pyright",
      "coc-omnisharp",
      "coc-go",
      "coc-java",
      "coc-snippets",
      "coc-html",
      "coc-xml",
      "coc-ultisnips",
      "coc-marketplace",
      "coc-highlight",
      "coc-vimtex",
      "coc-docker",
    }
  end,
  config = function()
    vim.opt.updatetime = 300

    vim.cmd([[
      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1] =~# '\s'
      endfunction

      inoremap <silent><expr> <Tab>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace()
            \   ? (&filetype ==# 'haskell' ? ' ' : "\<Tab>")
            \   : coc#refresh()
      inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
      inoremap <silent><expr><C-Space> coc#refresh()

      nnoremap <expr><C-f> coc#float#has_float() ? coc#float#float_scroll(1) : "\<C-f>"
      nnoremap <expr><C-b> coc#float#has_float() ? coc#float#float_scroll(0) : "\<C-b>"
      nnoremap <expr><Tab> "\<Cmd>silent! call "
            \ . (coc#float#has_float() ? "coc#float#close_all()" : "CocAction('doHover')")
            \ . "<CR>"
      nnoremap <C-P> <C-I>

      nmap <silent>[e <Plug>(coc-diagnostic-prev)
      nmap <silent>]e <Plug>(coc-diagnostic-next)
      nmap <silent>gd <Plug>(coc-definition)
      nmap <silent><Leader>gt <Plug>(coc-type-definition)
      nmap <silent>gi <Plug>(coc-implementation)
      nmap <silent>gr <Plug>(coc-references)
      nmap <silent><Leader>F <Plug>(coc-fix-current)
      nmap <silent><F1> <Plug>(coc-codelens-action)
      nmap <silent><Leader>ac <Plug>(coc-codeaction)
      vmap <silent><Leader>ac <Plug>(coc-codeaction-selected)
      nmap <F8> <Plug>(coc-rename)

      inoremap <silent><CR> <C-g>u<CR><C-r>=coc#on_enter()<CR>
      nnoremap <Leader>f <Cmd>call CocAction('format')<CR>
      nnoremap <LeftMouse> <LeftMouse><Cmd>call CocActionAsync('highlight')<CR>
      nnoremap <Esc> <Cmd>nohlsearch<bar>echo ''<bar>call coc#float#close_all()<CR>
    ]])

    local group = vim.api.nvim_create_augroup("CocUserConfig", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = group,
      callback = function()
        vim.fn.CocActionAsync("highlight")
      end,
    })
  end,
}
