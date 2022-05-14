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

"set bg=light
"set pyxversion=3

set number
set ruler
set hlsearch
set backspace=indent,eol,start
"set display+=uhex " Show unprintable characters hexadecimal as <xx> instead of using ^C and ~C
set mouse=a
set confirm
set clipboard+=unnamedplus
set spellfile=$HOME/.vim/spell/en.utf-8.add

set wildmenu
set foldmethod=syntax
"If you prefer the <Left> and <Right> keys to move the cursor instead
"of selecting a different match, use this:
cnoremap <Left> <Space><BS><Left>
cnoremap <Right> <Space><BS><Right>
cnoremap <F8> \<\><Left><Left>

syntax on

"Stop highlighting temporary and clean all messages in command line
nnoremap <Esc> <Cmd>nohlsearch<bar>echo ''<bar>call coc#float#close_all()<CR>
nnoremap J	J<Cmd>exe CurrentChar()==' '?'norm! x':''<CR>
"nnoremap <leader>f gg=G
noremap <F12> @a
nnoremap <expr>z= "\<Cmd> setl " . (CurrentChar() =~ '\w' ? "spell\<CR>z=" : "nospell\<CR>")
nnoremap <Space>* <Cmd>let @/='\<'.expand('<cword>').'\>'<bar>set hlsearch<CR>
nnoremap <Space>g* <Cmd>let @/=expand('<cword>')<bar>set hlsearch<CR>
nnoremap <C-S> <Cmd>update<CR>
nnoremap <C-W>K <C-W>sK

"extend a one-line C function to four lines
nnoremap <Space><Space> di{}hi<CR><Right><CR><CR><Up><C-R>"<Esc>=i{

"write the file in insert mode
inoremap <C-S> <Esc><Cmd>update<CR>
snoremap <C-S> <Esc><Cmd>update<CR>

inoremap <C-A> <C-O>^
inoremap <C-E> <C-O>$
inoremap <C-O> <C-\><C-O>

nnoremap <leader>p viwp

set autoread "When a file has been detected to have been changed outside of Vim and
             "it has not been change inside of Vim, automatically read it again
             "instead of asking me.
function! MyCheckModified(timer)
	silent! checktime
endfunction
call timer_start(1000,'MyCheckModified',{'repeat':-1})

"TODO don't match when I am in insert mode
"highlight BadWhitespace ctermbg=yellow
"autocmd BufRead,BufNewFile *.c,*.cpp,*.h match BadWhitespace /\s\+$/

autocmd FileType man exe len(@%) ? "" : "on"

autocmd BufRead * exe line("'.")>0 
							\? line("'.")>line("$") 
								\? "norm! Gzz" 
								\: "norm! '.zz" 
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

"[ utils ]
"TODO ( getreg() setreg() )
function! Setline(lnum,text)
	let lines=split(a:text,"\n")
	call setline(a:lnum,lines[0])
	if len(lines)>1
		call append(a:lnum,lines[1:])
	endif
endfunction

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

function! CurrentChar()
	return getline(".")[col(".")-1]
endfunction

"[ abbreviations ]
"TODO change ?ab to ?noreab
iabbrev helloworld #include<stdio.h><CR>int main(void)<CR>{<CR>printf("Hello, world!\n");<CR>return 0;<CR>}<Esc>gg
"ab quit <Esc>:q!<CR>	"これ超危い。使わないで！
ia makeac #include<stdio.h><CR>int main(void)<CR>{<CR>return 0;<CR>}<Esc>3ggo
ia makealex %option noyywrap<CR>%%<CR>%%<CR>int main(void)<CR>{<CR>yylex();<CR>return 0;<CR>}<Esc>2ggA
ia csapph #include"csapp.h"<CR>int main(void)<CR>{<CR>return 0:<CR>}<Esc>3ggo

"autocmd FileType make ia gcc gcc -std=c99

"[ make comment ]
noremap   <C-V>^o^I# <Esc>	|	"default
noremap <C-?> <C-V>^o^lx		|	"default
autocmd FileType c,cpp,yacc,go,javascript,javascriptreact,css noremap <buffer>		<C-V>^o^I// <Esc>
autocmd FileType c,cpp,yacc,go,javascript,javascriptreact,css noremap <buffer><C-?>	<C-V>^o^llx<Esc>
autocmd FileType vim noremap <buffer>				<C-V>^o^I"<Esc>
autocmd FileType vim noremap <buffer><C-?>				<C-V>^o^x<Esc>
autocmd FileType fortran noremap <buffer>				<C-V>^o^I!<Esc>
autocmd FileType fortran noremap <buffer><C-?>				<C-V>^o^x<Esc>
autocmd FileType tex,bib noremap <buffer>				<C-V>^o^I% <Esc>
autocmd FileType tex,bib noremap <buffer><C-?>				<C-V>^o^x<Esc>
iab   /*   /* */<Esc>hhi

"[ for C debug ]
nnoremap <C-F5> <Cmd>update<bar>make<CR>
imap <C-F5> <Esc><C-F5>
autocmd FileType c,cpp,fortran noremap <buffer><F5> <Cmd>exe "Te ./".expand("%:r")<CR>
nnoremap <F3> <Cmd>cc<CR>
nnoremap <F2> <Cmd>cN<CR>
nnoremap <F4> <Cmd>cn<CR>

"[ for vim script ]
autocmd FileType vim nnoremap	<buffer><F5>		<Cmd>silent update<bar>so %<CR>

highlight link ImportantComment Todo
autocmd FileType vim match ImportantComment /\v(".*)@<=\[ [^\]]* \]/
autocmd FileType vim nnoremap <leader>s   /\(".\{-}\)\@<=\[ [^\]]*\c[^\]]* \]
			\<Left><Left><Left><Left><Left><Left><Left><Left><Left>

"[ Run codes ]
function! s:run() range  "execute lines in the range
	"exe join(filter(getline(a:firstline,a:lastline),' v:val !~ ''^\s*"'' '),"\n")

	let lang2cmd={"help":"so","vim":"so","python":"Te python3","javascript":"Te node"}
	let tmp=tempname()
	silent exe a:firstline "," a:lastline "w" tmp
	try
		exe lang2cmd[&ft] tmp
	finally
		"call delete(tmp)
		"TODO can't delete it now because it seems that python3 still need it
	endtry
endfunction

vnoremap <S-F5>		<Cmd>call <SID>run()<CR>|" TODO~~
nnoremap <S-F5>		<Cmd>call <SID>run()<CR>
vmap	<leader>r	<S-F5>
nmap	<leader>r	<S-F5>
noremap <F5>		<Cmd>update<bar>Te %<CR>
imap	<F5>		<Esc><F5>
imap	<S-F5>		<Esc><S-F5>

" run the codes in current screen
autocmd FileType vim,help,python :nnoremap <buffer><leader>R	<Cmd>let b:winview=winsaveview()
												\<bar>exe line('w0').",".line('w$').'call <SID>run()'
												\<bar>if exists('b:winview')
													\<bar>call winrestview(b:winview)
												\<bar>endif<CR>

" [ vim-plug ] [ plugins ] [ coc ]
call plug#begin('~/.vim/plugged')

	Plug 'neoclide/coc.nvim',{'branch': 'release'}
		Plug 'liuchengxu/vista.vim'
			let g:vista_default_executive = 'coc'
			nnoremap <Leader>v <Cmd>Vista!!<CR>
		inoremap <silent><expr> <TAB>
		  \ pumvisible() ? "\<C-n>" :
		  \ <SID>check_back_no_identifier() ? 
		  \ &ft=="haskell" ? "  " : "\<TAB>" :
		  \ coc#refresh()
		inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

		function! s:check_back_no_identifier() abort
		  let col = col('.') - 1
		  return !col || getline('.')[col - 1]  !~# '\w\|\.'
		endfunction

		inoremap <silent><expr><C-Space> coc#refresh()

		nnoremap <expr><C-f> coc#float#has_float() ? coc#float#float_scroll(1) : "\<C-f>"
		nnoremap <expr><C-b> coc#float#has_float() ? coc#float#float_scroll(0) : "\<C-b>"

		nnoremap <expr><Tab> "\<Cmd>silent! call " . (coc#float#has_float() 
					\? "coc#float#close_all()"
					\: "CocAction('doHover')" 
					\) . "<CR>"
		nnoremap <C-P> <C-I>

		nmap <silent>[e <Plug>(coc-diagnostic-prev)
		nmap <silent>]e <Plug>(coc-diagnostic-next)

		nmap <silent>gd <Plug>(coc-definition)
		nmap <silent><leader>gt <Plug>(coc-type-definition)
		nmap <silent>gi <Plug>(coc-implementation)
		nmap <silent>gr <Plug>(coc-references)
		
		nmap <silent><leader>F  <Plug>(coc-fix-current)

		nmap <silent><F1> <Plug>(coc-codelens-action)

		nmap <silent><leader>ac  <Plug>(coc-codeaction)
		vmap <silent><leader>ac  <Plug>(coc-codeaction-selected)

		inoremap <silent><CR> <C-g>u<CR><C-r>=coc#on_enter()<CR>

		nmap <F8> <Plug>(coc-rename)

		nnoremap <leader>f <Cmd>call CocAction('format')<CR>
		autocmd BufWrite * silent call CocAction('format')

		set updatetime=300
		autocmd CursorHold * silent call CocActionAsync('highlight')
		nnoremap <LeftMouse> <LeftMouse><Cmd>call CocActionAsync('highlight')<CR>

		let g:coc_global_extensions=['coc-json','coc-tsserver','coc-css',
					\'coc-vimlsp','coc-pyright','coc-omnisharp','coc-go','coc-java',
					\'coc-snippets','coc-html','coc-xml','coc-ultisnips',
					\'coc-marketplace','coc-highlight',
					\'coc-vimtex','coc-docker']
		"autocmd FileType python let b:coc_root_patterns = ['.iamroot','.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']

		"inoremap <expr><cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

	"Plug 'fatih/vim-go'
		"let g:go_fmt_command = "goimports"
		"autocmd FileType go nnoremap <buffer><leader>r <Cmd>GoRun %<CR>
		"autocmd FileType go nnoremap <buffer><leader>b <Cmd>GoBuild<CR>
		"autocmd FileType go nnoremap <buffer><leader>i <Cmd>GoImport 
		"autocmd FileType go nnoremap <buffer><leader>I <Cmd>GoImports<CR>
		"autocmd FileType go nnoremap <buffer><leader>f <Cmd>GoFmt<CR>
	"Plug 'chrisbra/changesPlugin'
	"Plug 'johngrib/vim-game-code-break'
	"Plug 'johngrib/vim-game-snake'
	Plug 'vim/killersheep'
	"Plug 'suan/vim-instant-markdown'
	"Plug 'shime/vim-livedown'
	Plug 'tmhedberg/SimpylFold' "for python
		let g:SimpylFold_docstring_preview=1
	Plug 'jiangmiao/auto-pairs'
		let g:AutoPairsShortcutToggle=''  "Default is '<M-p>'
	Plug 'scrooloose/nerdtree'
		map <C-n> <Cmd>NERDTreeToggle<CR>
		autocmd FileType nerdtree nnoremap  <buffer>/  /\c
	Plug 'preservim/nerdcommenter'
	Plug 'tpope/vim-fugitive' "Git wrapper
		Plug 'tpope/vim-rhubarb' "GitHub extension for fugitive.vim
	Plug 'vim-airline/vim-airline'
		"let g:airline_powerline_fonts = 1
		"let g:airline_left_sep =  "\uE0C0"
		"let g:airline_right_sep = "\uE0C2"
		"let g:airline_focuslost_inactive = 1
		"Plug 'vim-airline/vim-airline-themes'
	Plug 'vim-scripts/matchit.zip'
	Plug 'vim-scripts/python_match.vim'
	Plug 'SirVer/ultisnips'
		let g:UltiSnipsEditSplit='horizontal'
		let g:UltiSnipsExpandTrigger='<C-j>'
		" TODO use different Trigger for Expansion and JumpForward
		let g:UltiSnipsSnippetsDir=$HOME.'/myUltiSnips/'
		let g:UltiSnipsSnippetDirectories=[$HOME."/myUltiSnips", "UltiSnips"]
		Plug 'honza/vim-snippets'
		"let g:UltiSnipsJumpForwardTrigger = '<C-j>'
		"let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
	Plug 'morhetz/gruvbox'
		let g:gruvbox_contrast_dark='hard'
		command! -nargs=? -complete=custom,s:SoftMediumHard Theme 
					\if len(<q-args>)>0
						\|exe 'let g:gruvbox_contrast_'.&bg.'=<q-args>' 
						\|colorscheme gruvbox
					\|else
						\|echohl Title
						\|echo "g:gruvbox_contrast_light=".g:gruvbox_contrast_light 
						\"g:gruvbox_contrast_dark=".g:gruvbox_contrast_dark
						\|echohl None
					\|endif
		function! s:SoftMediumHard(_,__,___)
			return join(['soft','medium','hard'],"\n")
		endfunction
	Plug 'nixon/vim-vmath'
		vmap <expr>  ++  VMATH_YankAndAnalyse()
		nmap         ++  vip++
	Plug 'atweiden/vim-dragvisuals'
		vmap <expr> <left> DVB_Drag('left')
		vmap <expr> <right> DVB_Drag('right')
		vmap <expr> <down> DVB_Drag('down')
		vmap <expr> <up> DVB_Drag('up')
		vmap <expr> D DVB_Duplicate()

	Plug 'lervag/vimtex'
		let g:tex_flavor='latex'
		"let g:vimtex_compiler_progname='nvr'
	Plug 'wellle/targets.vim'
	"Plug 'sheerun/vim-polyglot'
	"	let g:polyglot_disabled = ['latex'] " conflict with vimtex
	"	let g:python_highlight_space_errors=0
	Plug 'airblade/vim-gitgutter'
	Plug 'vimwiki/vimwiki'
	  let g:vimwiki_key_mappings =
		\ {
		\   'all_maps': 1,
		\   'global': 1,
		\   'headers': 1,
		\   'text_objs': 1,
		\   'table_format': 1,
		\   'table_mappings': 0,
		\   'lists': 1,
		\   'links': 1,
		\   'html': 1,
		\   'mouse': 0,
		\ }
	Plug 'easymotion/vim-easymotion'
		map <space> <Plug>(easymotion-prefix)
		let g:EasyMotion_verbose = 0
		map S <Plug>(easymotion-s)
	Plug 'dracula/vim', { 'as': 'dracula' }
	"Plug 'mhinz/vim-signify'

	"Plug 'ryanoasis/vim-devicons' "Adds file type icons to Vim plugins
		"let g:webdevicons_enable_airline_statusline=0
" NERDTrees File highlighting
"function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
" exec 'autocmd FileType nerdtree highlight lalala' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
" exec 'autocmd FileType nerdtree syn match lalala' . a:extension .' #^\s\+.*'. a:extension .'$#'
"endfunction
"
"call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
"call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
"call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
"call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
"call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
"call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
"call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
"call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', '#151515')
"call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868', '#151515')
"call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868', '#151515')
"call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868', '#151515')
"call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#686868', '#151515')
"
"call NERDTreeHighlightFile('cpp', 'blue', 'none', 'blue', '#151515')
"call NERDTreeHighlightFile('py', 'lightblue', 'none', 'lightblue', '#151515')
"call NERDTreeHighlightFile('c', 'lightgreen', 'none', 'lightgreen', '#151515')
"call NERDTreeHighlightFile('tex', 'brown', 'none', 'brown', '#151515')
"call NERDTreeHighlightFile('rpm', 'red', 'none', 'darkred', '#151515')
"call NERDTreeHighlightFile('zip', 'red', 'none', 'darkred', '#151515')
"call NERDTreeHighlightFile('go', 'lightblue', 'none', 'lightblue', '#151515')
"call NERDTreeHighlightFile('exe', 'grey', 'none', 'grey', '#151515')
"call NERDTreeHighlightFile('jpeg', 'magenta', 'none', 'magenta', '#151515')
"call NERDTreeHighlightFile('jpg', 'magenta', 'none', 'magenta', '#151515')
"call NERDTreeHighlightFile('png', 'magenta', 'none', 'magenta', '#151515')
"call NERDTreeHighlightFile('gif', 'magenta', 'none', 'magenta', '#151515')
"call NERDTreeHighlightFile('mp4', 'magenta', 'none', 'magenta', '#151515')
	"runtime syntax/colortest.vim

	"for web development
	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-repeat'
	"Plug 'mattn/emmet-vim' "for html expansion
	Plug 'alvan/vim-closetag'
	Plug 'tweekmonster/django-plus.vim'
	Plug 'MaxMEllon/vim-jsx-pretty'
	"Plug 'mhinz/vim-startify'

call plug#end()

"colorscheme	gruvbox
colorscheme	dracula
if !has("mac")
	set termguicolors
endif
" TODO
" write a command to toggle
" - backgroud
" - colorscheme
" - options for that colorscheme

function! OpenGithub()
	let repo=getline(line("."))[col("'<")-1:col("'>")-1]
	call jobstart(['firefox','https://github.com/'.repo])
endfunction
nnoremap gh <Cmd>call SaveMarks('<>')<CR>
			\vi'<Esc>
			\<Cmd>call OpenGithub()<CR>
			\<Cmd>call RestoreMarks()<CR>



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
"call <SID>setAlt('t')
"call <SID>setAlt('b') "readline need this!"

"call <SID>setAlt('z',1) "this will close preview window
"close previous window
function! s:close_previous_window()
	"let current_winnr=winnr()
	let prev_winnr=winnr('#')
	if prev_winnr
		exe prev_winnr..'close'
	endif
endfunctio
tnoremap <A-z> <Cmd>call <SID>close_previous_window()<CR>
inoremap <A-z> <Cmd>call <SID>close_previous_window()<CR>
nnoremap <A-z> <Cmd>call <SID>close_previous_window()<CR>


"[ use `d` and `u` to move and `q` to exit ] [ for man, help, qf and terminal ]
autocmd FileType man,help,qf nnoremap <nowait><buffer>d 
autocmd FileType man,help,qf nnoremap <buffer>u 
autocmd FileType man,help,qf nnoremap <buffer>q ZQ
if has('nvim')
	autocmd TermOpen * nnoremap <nowait><buffer>d 
	autocmd TermOpen * nnoremap <buffer>u 
	autocmd TermOpen * nnoremap <buffer>q ZQ
endif
"autocmd FileType man nnoremap <buffer>- /^\s\+\zs-
"autocmd FileType man nnoremap <buffer>- /\v^\s+(--?[a-zA-Z-]+,\s*)*\zs-
"autocmd FileType man nnoremap <buffer>- /\v^\s+
"			\%(
"				\--?[a-zA-Z-]+
"				\[ =]?[=<>()<bar>[\]a-zA-Z-]*
"				\,\s*
"			\)*\zs-
autocmd FileType man nnoremap <buffer>- /\v^\s+
			\%(
				\[+-][^,]+,\s*
			\)*\zs-
autocmd FileType man nnoremap <buffer>+ /\v^\s+
			\%(
				\[+-][^,]+,\s*
			\)*\zs\+
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
"git-push(1) and git-log(1) are good man pages to test highlight
autocmd FileType man nnoremap <buffer><Space><Space> /^\s\+\zs


"[ User command ]
":star! works like "A" and :star works like "i". When using this command in a
"function or scripts, the insertion only starts after the function or script
"is finished
command! -nargs=? Te sp | startinsert! | te <args>
" TODO support auto completion
command! -nargs=* Ipy Te ipython3 <args>
command! -nargs=0 Py Te python3
command! -nargs=0 Isym Te isympy
command! -nargs=* GH Te ghci <args>

command! -nargs=0 So so ~/.vimrc
command! -nargs=0 Sos so ./Session.vim

command! -nargs=0 V exe len(@%) ? "sp" : "e" "~/.vimrc"
command! -nargs=0 B exe len(@%) ? "sp" : "e" "~/.bashrc"
command! -nargs=0 C exe len(@%) ? "sp" : "e" ".ccls"
command! -nargs=0 T exe len(@%) ? "sp" : "e" "~/.tmux.conf"
" TODO GNUmakefile makefile Makefile
command! -nargs=0 -bang M if <q-bang> == "!" && expand("%:t:e") =~# 'cpp\|c'
			\| silent exe "!echo" expand("%:t:r").":" "> makefile"
			\| echo "./makefile written."
			\| else
			\| exe len(@%) ? "sp" : "e" "makefile"
			\| endif

command! -nargs=0 P to vert sp ~/.vim/plugged/

if has('nvim')
	command! -nargs=0 X silent !chmod u+x %
endif

"c  cpp

"rename file
command! -nargs=1 -complete=custom,s:ReComplete Re let temp=expand('%') 
			\| saveas <args> 
			\| call setfperm(<q-args>,getfperm(temp))
			\| call delete(temp)
function! s:ReComplete(_,__,___)
	return expand("%")
endfunction

command! -nargs=0 Open silent !gnome-open %

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
"autocmd FileType python setlocal foldmethod=indent
autocmd FileType python nnoremap <buffer><F5>		<Cmd>update<bar>Te python3 %<CR>
"autocmd FileType python nmap <buffer><leader>R	HVG<S-F5>
set foldlevel=99
"nnoremap <Space> za

autocmd FileType python vnoremap <buffer><CR> <Cmd>call <SID>run_in_ipython()<CR>
autocmd FileType python nnoremap <buffer><CR> <Cmd>call <SID>run_in_ipython()<CR>
autocmd FileType python nnoremap <buffer><S-F5> <Cmd>Te ipython3 -i %<CR>
function s:run_in_ipython()
	silent norm! "+Y
	let @* = "%paste\<CR>"
	for buf in getbufinfo()
		if buf.name =~ 'term://.//\d\+:ipython\(3\|2\)\?'
			" found
			let winnr = bufwinnr(buf.bufnr)
			exe winnr . "wincmd w"
			norm! "*pG
			return
		endif
	endfor
	" not found
	Ipy
	norm "*p
	stopinsert
endfunction
" id=win_getid() "get id of current window"
" win_gotoid(id) "go back"
"
" id=termopen('bash')
" chansend(id,"echo hello\n")

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
"then use 'norm! Gdd' to delete last line
"finally :exe <filetype>.vim
autocmd BufNewFile *.c 0r ~/.vim/skeleton.c | norm! Gdd5gg


"[ web development ] [ html javascript xhtml django ]
autocmd Filetype html,javascript setl tabstop=8 softtabstop=0 expandtab shiftwidth=2 softtabstop=0 expandtab shiftwidth=2 smarttab

if has('mac')
	autocmd FileType xhtml,html nnoremap <buffer><F5>	<Cmd>update<bar>call jobstart(['open','-a','/Applications/Firefox.app',@%])<CR>
else
	autocmd FileType xhtml,html nnoremap <buffer><F5>	<Cmd>update<bar>call jobstart(['firefox',@%])<CR>
endif

autocmd Filetype javascript nnoremap <F5> <Cmd>update %<bar>Te node %<CR>
autocmd FileType htmldjango let b:AutoPairs=AutoPairsDefine({'{%':'%}','{#':'#}'})

" [ Haskell ]
autocmd FileType haskell nnoremap <buffer><F5>		<Cmd>update<bar>Te runghc %<CR>

" [ latex ]
autocmd FileType tex let b:AutoPairs={
			\'(':')',
			\'[':']',
			\ '{':'}',
			\"'":"'",
			\'"':'"',
			\ '"""':'"""',
			\ "'''":"'''",
			\
			\ '$':'$',
			\}
let g:tex_fold_enabled=1
"autocmd FileType tex inoremap <buffer>\[   \[  \]<left><left><left>
"TODO don't map \[, map \!!!

" [ bash, shell ]
autocmd FileType sh nnoremap <buffer><F5>	<Cmd>update<bar>Te bash %<CR>


"[ test zone ]

" show the syntax name under the cursor
" echo synIDattr(synID(line("."),col("."),1),"name")

"if  0 && executable('speak-ng')
"	autocmd InsertCharPre * 
"				\if v:char =~ '\w' |
"					\if 0 | call jobstart(['speak-ng',v:char]) | endif |
"				\else |
"					\call jobstart(['speak-ng'
"					\,match(strpart(getline('.'),0,col('.')),'\w\+\s*$')!=-1 
"						\?substitute(strpart(getline('.'),0,col('.'))
"							\,'.\{-}\(\w\+\)\s*$','\1','')
"						\:''
"					\]) |
"				\endif
"endif

"autocmd  InsertEnter * call jobstart(['speak-ng',mode(1)])

"nnoremap \/ <Cmd>call feedkeys('/apple','t')<CR>

"function MySearch(pattern)
"	let @/=a:pattern
"	set hlsearch
"endfunction
"cnoremap <C-S> <C-\>e 'MySearch("'.escape(getcmdline(),'\"').'")'<CR>
"cnoremap <C-S> <Cmd>let @/=getcmdline()<bar>set hlsearch<bar><CR><Esc>
"cnoremap <C-S> <Esc>
"
" TODO autocmd FileType man vnnoremap gO ???

"							*hl-Pmenu*
"Pmenu		Popup menu: normal item.

autocmd BufNewFile /home/sudongpo/update-log/*.txt call append(line('$'),"vim:set nonu:")
