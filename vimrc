let g:coc_global_extensions = [
\ 'coc-omni',
\ 'coc-html',
\ 'coc-css',
\ 'coc-emmet',
\ 'coc-json',
\ 'coc-highlight',
\ 'coc-syntax',
\ 'coc-tag',
\ 'coc-tsserver',
\ 'coc-prettier',
\ 'coc-eslint'
\ ]

" - - - arthurnavah - Plugs -
"
call plug#begin('~/.vim/plugged')

" NERDTree - File explorer
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'

" Denite - Search file
Plug 'shougo/denite.nvim'

" Airline - Status bar
Plug 'bling/vim-airline'

" Syntastic - Sintax
Plug 'scrooloose/syntastic'

" vim-go - Go Support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" vim-json - JSON Support
Plug 'elzr/vim-json'

" vim-javascript - JavaScript Support
Plug 'pangloss/vim-javascript'
" typescript-vim - TypeScript Support
Plug 'leafgarland/typescript-vim'
" vim-jsx-pretty - JSX syntax
Plug 'maxmellon/vim-jsx-pretty'
" vim-jsx-typescript - TSX syntax
Plug 'peitalin/vim-jsx-typescript'
" vim-styled-components - Styled Components
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" nerdcommenter - Comments fast
Plug 'scrooloose/nerdcommenter'

" delimitmate - Closing parentheses, keys, etc
Plug 'raimondi/delimitmate'

" emmet - HTML and CSS generator
Plug 'mattn/emmet-vim'

" coc.nvim - Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release', 'do': { -> coc#util#install() }}

" vim-multiple-cursors - Multi cursor
Plug 'terryma/vim-multiple-cursors'

" Gitgutter - GIT change signal icons
Plug 'airblade/vim-gitgutter'

" vim-devicons - Icons file
Plug 'ryanoasis/vim-devicons'

" indentline - Indentline guide
Plug 'yggdroot/indentline'

" vim-eununch - UNIX Utility
Plug 'tpope/vim-eunuch'

" AnsiEsc.vim - ansi escape sequences concealed
Plug 'vim-scripts/AnsiEsc.vim'

" themes
Plug 'vim-airline/vim-airline-themes'
Plug 'mhartington/oceanic-next'
Plug 'joshdick/onedark.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'sickill/vim-monokai'
Plug 'dracula/vim'
Plug 'w0ng/vim-hybrid'
Plug 'flrnprz/taffy.vim'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'

call plug#end()

" ---------------------------

" vim config
set nocompatible              " be iMproved, required
filetype off                  " required
set backspace=2
filetype plugin indent on    " required
set relativenumber
set number
set list
let mapleader=" "
let maplocalleader="\\"
cnoremap jk <Esc>
inoremap jk <Esc>
cnoremap kj <Esc>
inoremap kj <Esc>

set cursorline
highlight Cursorline cterm=bold

set encoding=UTF-8
set fileencodings=UTF-8
set guifont=Fira\ Mono\ for\ Powerline\ 12

set ruler

syntax on

set ignorecase
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab

set laststatus=2

set scrolloff=4
set hlsearch
set smartcase
set formatoptions+=1

set updatetime=200
set ttyfast
set timeout timeoutlen=200 ttimeoutlen=50
set history=50

set title
set noerrorbells
set lazyredraw
set wrap linebreak nolist
set autoread

colorscheme OceanicNext

let g:rehash256 = 1
set t_Co=256
set background=dark

autocmd FileType markdown let g:indentLine_enabled=0
set conceallevel=0

set hidden
set nobackup
set nowritebackup
set signcolumn=auto
set scl=auto

set directory^=$HOME/.vim/tmp//

nnoremap <leader>l :vsplit<CR>
nnoremap <leader>j :split<CR>

" NERDTree config
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nn :NERDTreeFind<CR>

let NERDTreeShowFiles=1
let NERDTreeShowHidden=1
let NERDTreeHighlightCursorline=1
let NERDTreeMouseMode=2
let NERDTreeIgnore=[ '^\.git$', ]
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

" denite config
nmap <leader>b :Denite buffer <CR>
nmap <leader>f :Denite file/rec <CR>
nnoremap <leader>h :<C-u>Denite grep:. -no-empty -mode=normal<CR>

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
	nnoremap <silent><buffer><expr> <CR>
				\ denite#do_map('do_action')
	nnoremap <silent><buffer><expr> p
				\ denite#do_map('do_action', 'preview')
	nnoremap <silent><buffer><expr> q
				\ denite#do_map('quit')
	nnoremap <silent><buffer><expr> f
				\ denite#do_map('open_filter_buffer')
	nnoremap <silent><buffer><expr> <Space>
				\ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
	imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/', 'vendor/', 'node_modules'])

" airline config
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='oceanicnext'
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1
let g:airline#extensions#tabline#show_splits = 0

" typescript config
let g:vim_json_syntax_conceal = 2

autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

" vim-go config
let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []

let g:go_auto_type_info = 1
let g:go_jump_to_error = 0
let g:go_fmt_command = "goimports"
let g:go_auto_sameids = 0
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_addtags_transform = "camelcase"

autocmd FileType go nmap <leader>gb  :GoBuild<CR>
autocmd FileType go nmap <leader>gj  :GoLint<CR>
autocmd FileType go nmap <leader>gk :GoVet<CR>
autocmd FileType go nmap <leader>ga  :GoAlternate<CR>
autocmd FileType go nmap <leader>gc  :GoCoverageToggle<CR>
autocmd FileType go nmap <leader>gat  :GoAddTags
autocmd FileType go nmap <leader>grt  :GoRemoveTags
autocmd FileType go nmap <leader>gcp  :GoChannelPeers<CR>
" go - show function calls
autocmd BufEnter *.go nmap <leader>cc  <Plug>(go-callers)

" emmet config
let g:user_emmet_leader_key='<C-K>'
let g:user_emmet_install_global = 0
autocmd FileType html,css,javascript EmmetInstall

" gitgutter config
let g:gitgutter_max_signs = 200

" indentline config
let g:indentLine_char = '¦'

" coc.nvim config

set cmdheight=2
set shortmess+=c
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
autocmd CursorHold * silent call CocActionAsync('highlight')
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" ---------------------------------------

" vim scripts

" Borrar archivos de Buffer excepto el activo con :Bo
"   Author : Christian J. Robinson <infynity@onewest.net>
command! -nargs=? -complete=buffer -bang Bo
    \ :call BufOnly('<args>', '<bang>')

function! BufOnly(buffer, bang)
	if a:buffer == ''
		" No buffer provided, use the current buffer.
		let buffer = bufnr('%')
	elseif (a:buffer + 0) > 0
		" A buffer number was provided.
		let buffer = bufnr(a:buffer + 0)
	else
		" A buffer name was provided.
		let buffer = bufnr(a:buffer)
	endif

	if buffer == -1
		echohl ErrorMsg
		echomsg "No matching buffer for" a:buffer
		echohl None
		return
	endif

	let last_buffer = bufnr('$')

	let delete_count = 0
	let n = 1
	while n <= last_buffer
		if n != buffer && buflisted(n)
			if a:bang == '' && getbufvar(n, '&modified')
				echohl ErrorMsg
				echomsg 'No write since last change for buffer'
							\ n '(add ! to override)'
				echohl None
			else
				silent exe 'bdel' . a:bang . ' ' . n
				if ! buflisted(n)
					let delete_count = delete_count+1
				endif
			endif
		endif
		let n = n+1
	endwhile

	if delete_count == 1
		echomsg delete_count "buffer deleted"
	elseif delete_count > 1
		echomsg delete_count "buffers deleted"
	endif

endfunction

"----------------------------------------------------
