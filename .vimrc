"<F5> means run
"<S-F5> means run the lines selected in visual mode, or, in normal mode, the
"current line
set tabstop=4
set softtabstop=4
set shiftwidth=4
"let mapleader=" "

set autoindent
set smartindent
set cindent

set bg=light
"set pyxversion=3

set number
set ruler
set hlsearch
set backspace=indent,eol,start
"set display+=uhex " Show unprintable characters hexadecimal as <xx> instead of using ^C and ~C
set mouse=a
set confirm
set clipboard+=unnamed
"set clipboard+=unnamedplus

set wildmenu
"If you prefer the <Left> and <Right> keys to move the cursor instead
"of selecting a different match, use this:
cnoremap <Left> <Space><BS><Left>
cnoremap <Right> <Space><BS><Right>

syntax on

"nnoremap <silent> <Esc> :nohlsearch<CR>
"Stop highlighting temporary and clean all messages in command line
nmap <silent><Esc> <Cmd>nohlsearch<bar>echo ''<CR>
"TODO Jx is buggy, fix it
nnoremap J	Jx
"nnoremap <leader>f gg=G
nnoremap <F12> @a
nnoremap z= <Cmd>setlocal spell<CR>z=

"write the file in insert mode
inoremap <C-S> <Cmd>update<CR>
inoremap <C-A> <C-O>^
inoremap <C-E> <C-O>$

set autoread "When a file has been detected to have been changed outside of Vim and
             "it has not been change inside of Vim, automatically read it again
             "instead of asking me.

"TODO don't match when I am in insert mode
"highlight BadWhitespace ctermbg=yellow
"autocmd BufRead,BufNewFile *.c,*.cpp,*.h match BadWhitespace /\s\+$/

autocmd FileType man exe len(@%) ? "" : "on"

autocmd BufRead * :exe line("'.")>0 
							\? line("'.")>line("$") 
								\? "norm Gzz" 
								\: "norm '.zz" 
							\: ''
"rename
"noremap <leader>R :s/\<\>//g<Left><Left>

"set tags=tags,/usr/include/tags
"""""""""""""""""""""""""""""""""""""$VIMRUNTIME/vimrc_example.vim
"set nomodeline

" vim -b : edit binary using xxd-format!
augroup Binary
	au!
	au BufReadPre  *.exe let &bin=1
	au BufReadPost *.exe if &bin | %!xxd
	au BufReadPost *.exe set ft=xxd | endif
	au BufWritePre *.exe if &bin | %!xxd -r
	au BufWritePre *.exe endif
	au BufWritePost *.exe if &bin | %!xxd
	au BufWritePost *.exe set nomod | endif
augroup END

if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

if has('nvim')
	autocmd TermOpen * setlocal nonu
else
	autocmd TerminalOpen * setlocal nonu
endif

nnoremap <leader>zt :let saved=&fo<CR>
			\:setl fo-=cro<CR>
			\Go<CR><Esc>
			\:let &fo=saved<CR>
			\:unlet saved<CR>
			\zti

if has('nvim')
	map <F29> <C-F5>
	lmap <F29> <C-F5>
	tmap <F29> <C-F5>
	smap <F29> <C-F5>
	imap <F29> <C-F5>
	map <F17> <S-F5>
	lmap <F17> <S-F5>
	tmap <F17> <S-F5>
	smap <F17> <S-F5>
	imap <F17> <S-F5>
endif

"[ abbreviations ]
"TODO change ?ab to ?noreab
iabbrev helloworld #include<stdio.h><CR>int main(void)<CR>{<CR>printf("Hello, world!\n");<CR>return 0;<CR>}<Esc>gg
"ab quit <Esc>:q!<CR>	"これ超危い。使わないで！
ia makeac #include<stdio.h><CR>int main(void)<CR>{<CR>return 0;<CR>}<Esc>3ggo
ia makealex %option noyywrap<CR>%%<CR>%%<CR>int main(void)<CR>{<CR>yylex();<CR>return 0;<CR>}<Esc>2ggA
ia csapph #include"csapp.h"<CR>int main(void)<CR>{<CR>return 0:<CR>}<Esc>3ggo

cabbrev to to vert sp
cabbrev bo bo vert sp
autocmd FileType make :ia gcc gcc -std=c99

"[ make comment ]
noremap   <C-V>^o^I# <Esc>	|	"default
noremap <C-?> <C-V>^o^lx		|	"default
autocmd FileType c,cpp,yacc,go,javascript :noremap <buffer>		<C-V>^o^I// <Esc>
autocmd FileType c,cpp,yacc,go,javascript :noremap <buffer><C-?>	<C-V>^o^llx<Esc>
autocmd FileType vim :noremap <buffer>				<C-V>^o^I"<Esc>
autocmd FileType vim :noremap <buffer><C-?>				<C-V>^o^x<Esc>
iab   /*   /* */<Esc>hhi

"[ for C debug ]
nnoremap <C-F5> <Cmd>update<bar>make<CR>
noremap <F5> <Cmd>exe "Te ./".expand("%:r")<CR>
nnoremap <F3> <Cmd>cc<CR>
nnoremap <F2> <Cmd>cN<CR>
nnoremap <F4> <Cmd>cn<CR>

"[ for vim script ]
autocmd FileType vim :nnoremap	<buffer><F5>		<Cmd>silent update<bar>so %<CR>

highlight link ImportantComment Todo
"autocmd FileType vim :match ImportantComment /\(".\{-}\)\@<=\[ [^\]]* \]/
autocmd FileType vim :match ImportantComment /\v(".*)@<=\[ [^\]]* \]/
autocmd FileType vim :nnoremap \[   /\(".\{-}\)\@<=\[ [^\]]*\c[^\]]* \]
			\<Left><Left><Left><Left><Left><Left><Left><Left><Left>

"[ Run codes ]
function! s:run() range  "execute lines in the range
	"exe join(filter(getline(a:firstline,a:lastline),' v:val !~ ''^\s*"'' '),"\n")

	let lang2cmd={"help":"so","vim":"so","python":"Te python3"}
	let tmp=tempname()
	silent exe a:firstline "," a:lastline "w" tmp
	try
		exe lang2cmd[&ft] tmp
	finally
		"call delete(tmp)
		"TODO can't delete it now because it seems that python3 still need it
	endtry
endfunction

vnoremap <S-F5>		:call <SID>run()<CR>|" TODO~~
nnoremap <S-F5>		:call <SID>run()<CR>
vmap	<leader>r	<S-F5>
nmap	<leader>r	<S-F5>
imap	<F5>		<Esc><F5>
imap	<S-F5>		<Esc><S-F5>

" run the codes in current screen
autocmd FileType vim,help,python :nnoremap <buffer><leader>R	<Cmd>let b:winview=winsaveview()
												\<bar>exe line('w0').",".line('w$').'call <SID>run()'
												\<bar>if exists('b:winview')
													\<bar>call winrestview(b:winview)
												\<bar>endif<CR>

" [ vim-plug ] [ plugins ]
"autocmd FileType vim nnoremap <leader>gx 
"TODO ( getreg() setreg() )

call plug#begin('~/.vim/plugged')

	Plug 'neoclide/coc.nvim',{'branch': 'release'}
		inoremap <silent><expr> <TAB>
		  \ pumvisible() ? "\<C-n>" :
		  \ <SID>check_back_space() ? "\<TAB>" :
		  \ coc#refresh()
		inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

		function! s:check_back_space() abort
		  let col = col('.') - 1
		  return !col || getline('.')[col - 1]  =~# '\s'
		endfunction

		inoremap <silent><expr><C-Space> coc#refresh()

		nnoremap <expr><C-f> coc#util#has_float() ? coc#util#float_scroll(1) : "\<C-f>"
		nnoremap <expr><C-b> coc#util#has_float() ? coc#util#float_scroll(0) : "\<C-b>"

		nnoremap <expr><Tab> "\<Cmd>call " . (coc#util#has_float() 
					\? "coc#util#float_hide()"
					\: "CocAction('doHover')" 
					\) . "<CR>"

		nmap <silent>[e <Plug>(coc-diagnostic-prev)
		nmap <silent>]e <Plug>(coc-diagnostic-next)

		nmap <silent><leader>gd <Plug>(coc-definition)
		nmap <silent><leader>gt <Plug>(coc-type-definition)
		nmap <silent><leader>gi <Plug>(coc-implementation)
		nmap <silent><leader>gr <Plug>(coc-references)
		
		nmap <silent><leader>F  <Plug>(coc-fix-current)

		nmap <silent><F1> <Plug>(coc-codelens-action)

		nmap <silent><leader>ac  <Plug>(coc-codeaction)
		vmap <silent><leader>ac  <Plug>(coc-codeaction-selected)

		inoremap <silent><CR> <C-g>u<CR><C-r>=coc#on_enter()<CR>

		nmap <F8> <Plug>(coc-rename)

		nnoremap <leader>f <Cmd>call CocAction('format')<CR>

		set updatetime=300
		autocmd CursorHold * silent call CocActionAsync('highlight')
		nnoremap <LeftMouse> <LeftMouse><Cmd>call CocActionAsync('highlight')<CR>
		"set termguicolors

		let g:coc_global_extensions=['coc-json','coc-tsserver','coc-python','coc-css',
					\'coc-vimlsp','coc-highlight',
					\'coc-snippets','coc-html','coc-go','coc-ultisnips','coc-marketplace']

		"inoremap <expr><cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

	Plug 'fatih/vim-go'
	"Plug 'chrisbra/changesPlugin'
	"Plug 'johngrib/vim-game-code-break'
	"Plug 'johngrib/vim-game-snake'
	"Plug 'suan/vim-instant-markdown'
	"Plug 'shime/vim-livedown'
	Plug 'tmhedberg/SimpylFold' "for python
		let g:SimpylFold_docstring_preview=1
	Plug 'jiangmiao/auto-pairs'
		let g:AutoPairsShortcutToggle=''  "Default is '<M-p>'
	Plug 'scrooloose/nerdtree'
		map <C-n> <Cmd>NERDTreeToggle<CR>
		autocmd FileType nerdtree nnoremap  <buffer>/  /\c
	Plug 'tpope/vim-fugitive' "Git wrapper
	Plug 'vim-airline/vim-airline'
		"let g:airline_focuslost_inactive = 1
	Plug 'vim-scripts/matchit.zip'
	Plug 'vim-scripts/python_match.vim'
	Plug 'SirVer/ultisnips'
		Plug 'honza/vim-snippets'
		let g:UltiSnipsExpandTrigger = '<C-j>'
		"let g:UltiSnipsJumpForwardTrigger = '<C-j>'
		"let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

	"for web development
	Plug 'tpope/vim-surround'
	"Plug 'mattn/emmet-vim' "for html expansion
	Plug 'alvan/vim-closetag'
	"Plug 'mhinz/vim-startify'

call plug#end()

let g:mark2pos={}

function! SaveMarks(marks)
	for m in split(a:marks,'\zs')
		if m !~ '\s'
			let g:mark2pos[m]=getpos("'".m)
		endif
	endfor
endfunction

function! RestoreMarks()
	for [m,p] in items(g:mark2pos)
		call setpos("'".m,p)
		unlet g:mark2pos[m]
	endfor
endfunction

function! OpenGithub()
	let repo=getline(line("."))[col("'<")-1:col("'>")-1]
	call jobstart(['firefox','https://github.com/'.repo])
endfunction
nnoremap gh <Cmd>call SaveMarks('<>')<CR>
			\vi'<Esc>
			\<Cmd>call OpenGithub()<CR>
			\<Cmd>call RestoreMarks()<CR>


"[ golang ]
"let g:go_fmt_command = "goimports"
autocmd FileType go :nnoremap <buffer><leader>r :GoRun %<CR>
autocmd FileType go :nnoremap <buffer><leader>b :GoBuild<CR>
autocmd FileType go :nnoremap <buffer><leader>i :GoImport 
autocmd FileType go :nnoremap <buffer><leader>I :GoImports<CR>
"autocmd FileType go :nnoremap <buffer><leader>f :GoFmt<CR>
"autocmd BufWritePost *.go !gofmt -w %

"[ +clipboard ]
" " Copy to clipboard
vnoremap <leader>y  "+y
nnoremap <leader>y  "+y
nnoremap <leader>Y  "+Y
" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

"[ Alt key ]
function! s:setAlt(key,...)
	if a:0
		let back_to_insert_mode=1
	else
		let back_to_insert_mode=0
	endif
	exe 'tnoremap <A-'.a:key.'> <C-\><C-N><C-w>'.a:key.(back_to_insert_mode?'a':'')
	exe 'inoremap <A-'.a:key.'> '
				\.(back_to_insert_mode ? 
					\'<Cmd>wincmd '.a:key.'<CR>' :
					\'<C-\><C-N><C-w>'.a:key)
	exe 'nnoremap <A-'.a:key.'> <C-w>'.a:key
endfunction

call <SID>setAlt('h')
call <SID>setAlt('j')
call <SID>setAlt('k')
call <SID>setAlt('l')
call <SID>setAlt('p')
call <SID>setAlt('s')
call <SID>setAlt('v')
call <SID>setAlt('c')
call <SID>setAlt(']')
call <SID>setAlt('T')

call <SID>setAlt('H',1)
call <SID>setAlt('L',1)
call <SID>setAlt('J',1)
call <SID>setAlt('K',1)

call <SID>setAlt('_',1)
call <SID>setAlt('\|',1)
call <SID>setAlt('>',1)
call <SID>setAlt('<',1)

call <SID>setAlt('=',1)
call <SID>setAlt('-',1)
call <SID>setAlt('+',1)

call <SID>setAlt('o',1)
call <SID>setAlt('x') " exchange current window with window N(default: next window)
call <SID>setAlt('t')
call <SID>setAlt('b')

"call <SID>setAlt('z',1) "this will close preview window
"close previous window
function s:close_previous_window()
	"let current_winnr=winnr()
	let prev_winnr=winnr('#')
	if prev_winnr
		exe prev_winnr..'close'
	endif
endfunctio
tnoremap <A-z> <Cmd>call <SID>close_previous_window()<CR>
inoremap <A-z> <Cmd>call <SID>close_previous_window()<CR>
nnoremap <A-z> <Cmd>call <SID>close_previous_window()<CR>


"[ use `d` and `u` to move and `q` to exit ] [ for man, help and terminal ]
autocmd FileType man,help :nnoremap <nowait><buffer>d 
autocmd FileType man,help :nnoremap <buffer>u 
autocmd FileType man,help :nnoremap <buffer>q ZQ
if has('nvim')
	autocmd TermOpen * :nnoremap <nowait><buffer>d 
	autocmd TermOpen * :nnoremap <buffer>u 
	autocmd TermOpen * :nnoremap <buffer>q ZQ
endif
"autocmd FileType man :nnoremap <buffer>- /^\s\+\zs-
"autocmd FileType man :nnoremap <buffer>- /\v^\s+(--?[a-zA-Z-]+,\s*)*\zs-
"autocmd FileType man :nnoremap <buffer>- /\v^\s+
"			\%(
"				\--?[a-zA-Z-]+
"				\[ =]?[=<>()<bar>[\]a-zA-Z-]*
"				\,\s*
"			\)*\zs-
autocmd FileType man :nnoremap <buffer>- /\v^\s+
			\%(
				\[+-][^,]+,\s*
			\)*\zs-
"syntax match manOptionDesc display /\v(^\s+
autocmd FileType man match manOptionDesc /\v
			\(^\s+
				\%([+-][^,]+,\s*)*
			\)@<=[+-]-?[[<]?[^[< =]+/
"TODO commit this to neovim repo. (runtime/syntax/man.vim)
"This regex is complicated because it has to deal with something like:
"	-M[<n>], --find-renames[=<n>]
"	--diff-filter=[(A|C|D|M|R|T|U|X|B)...[*]]
"	--[no-]force-with-lease, --force-with-lease=<refname>, --force-with-lease=<refname>:<expect>
"	--[no-]signed, --signed=(true|false|if-asked)
"	-U<n>, --unified=<n>
"	-S<string>
"	-1 --base, -2 --ours, -3 --theirs
"git-push(1) and git-log(1) is a good man page to test highlight
autocmd FileType man :nnoremap <buffer><Space> /^\s\+\zs


"[ User command ]
":star! works like "A" and :star works like "i". When using this command in a
"function or scripts, the insertion only starts after the function or script
"is finished
command! -nargs=? Te sp | startinsert! | te <args>
command! -nargs=0 Ipy Te ipython3
command! -nargs=0 Py Te python3
command! -nargs=0 Isym Te isympy

command! -nargs=0 So so ~/.vimrc
command! -nargs=0 Sos so ./Session.vim

command! -nargs=0 V exe len(@%) ? "sp" : "e" "~/.vimrc"
command! -nargs=0 B exe len(@%) ? "sp" : "e" "~/.bashrc"
command! -nargs=0 T exe len(@%) ? "sp" : "e" "~/.tmux.conf"
command! -nargs=0 M exe len(@%) ? "sp" : "e" "makefile"

command! -nargs=0 P to vert sp ~/.vim/plugged/

"rename file
command! -nargs=1 Re let temp=expand('%:t') | saveas <args> | call delete(expand(temp))

command! -nargs=0 RemoveAllTrailingSpaces %s/\s\+$/


"TODO
"It is possible to move the cursor after an abbreviation: >
"   :iab if if ()<Left>
"
"You can even do more complicated things.  For example, to consume the space
"typed after an abbreviation: >
"   func Eatchar(pat)
"      let c = nr2char(getchar(0))
"      return (c =~ a:pat) ? '' : c
"   endfunc
"   iabbr <silent> if if ()<Left><C-R>=Eatchar('[ \r\n]')<CR>


"[ Python ]
"autocmd FileType python :setlocal foldmethod=indent
autocmd FileType python :nnoremap <buffer><F5>		<Cmd>update<bar>Te python3 %<CR>
"autocmd FileType python :nmap <buffer><leader>R	HVG<S-F5>
set foldlevel=99
nnoremap <Space> za

autocmd BufWritePre  *.py call CocAction('format')

":echo searchpair('{', '', '}', 'bW')

"	This works when the cursor is at or before the "}" for which a
"	match is to be found.  To reject matches that syntax
"	highlighting recognized as strings: >

":echo searchpair('{', '', '}', 'bW',
"     \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string"')
"Hi! So now you can use the syntax highlighting to determine whether the
"cursor is in a comment or not!

"call setqflist(balabala)


"make this into a plugin.
"first, :0read skeleton.<filetype>
"then use 'norm Gdd' to delete last line
"finally :exe <filetype>.vim
autocmd BufNewFile *.c 0r ~/.vim/skeleton.c | norm! Gdd5gg


" [ test zone ]
"autocmd FocusLost * call setline(line("$")+1,mode())
"autocmd FocusLost * if 1 | call setline(line("$")+1,"if1") | else |  call setline(line("$")+1,"if0") | endif
"autocmd FocusLost * if index(['v','V',''],mode())!=-1 | exe 'norm "*ygv' | endif
autocmd FocusLost * exe index(['v','V',''],mode())!=-1 ? 'norm "*ygv' : ''
" <ajfiowef> <fjwioefje>   <fjwiew> < w here jeiof >   <><fjeiow>
"
" [shi't]   [bi'tch]
"echo 'abcd'     'bjsaioe'
"nnoremap di< <Cmd>exe getline('.')[col('.')-1]=='<' ? 'norm f>' <Enter>


"[ web development ] [ html javascript xhtml ]
autocmd Filetype html,javascript setl tabstop=8 softtabstop=0 expandtab shiftwidth=2 softtabstop=0 expandtab shiftwidth=2 smarttab

"autocmd FileType html :nnoremap <silent><buffer><F5>		<Cmd>update<CR><Cmd>!open -a /Applications/Firefox.app %<CR>
if has('mac')
	autocmd FileType xhtml,html :nnoremap <buffer><F5>	<Cmd>update<bar>call jobstart(['open','-a','/Applications/Firefox.app',@%])<CR>
else
	autocmd FileType xhtml,html :nnoremap <buffer><F5>	<Cmd>update<bar>call jobstart(['firefox',@%])<CR>
endif

autocmd Filetype javascript nnoremap <F5> <Cmd>update %<bar>Te node %<CR>

"function s:testS()
"	echo "hello from s:testS"
"endfunction
"
"call s:testS()
"
"nnoremap <F7> <Cmd>call <SID>testS()<CR>
