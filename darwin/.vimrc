"John Krukoff's vim configuration

set nocompatible		"Not vi compatible (No matter how vim was invoked)

"Vundle plugins configuration
filetype off			"Required by vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"Actual plugin list
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'docker/docker', {'rtp': '/contrib/syntax/vim/'}
Plugin 'elzr/vim-json'
Plugin 'fatih/vim-go'
Plugin 'fs111/pydoc.vim'
Plugin 'gmarik/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'guns/vim-clojure-static'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'majutsushi/tagbar'
Plugin 'saltstack/salt-vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'vim-flake8'
Plugin 'vim-scripts/TaskList.vim'
"Disabled plugins
" Plugin 'guns/vim-sexp'
" Plugin 'tpope/vim-surround'

"Finalize plugin setup
call vundle#end()
filetype plugin on


"Global settings
set visualbell			"Use visual bell instead of beep

set ts=8			"Default tab for 8
set lcs=tab:>-,eol:$,extends:\	"Make tab characters and others visible
set list			"Display invisible characters

set showmatch			"Show matching parenthese

set backspace=2			"Backspace should delete everything

set laststatus=2		"Display a status bar
set wildmenu			"Filename completion
set ruler			"Show the position of the cursor
set showcmd			"Display command in progress
set showmode			"Display current mode
set showtabline=1		"Show tab bar when tabs exist

set wrapscan			"Have searches wrap from bottom of file to top
set hlsearch			"Highlight search results
set incsearch
set ignorecase			"Ignore case when performing a pattern match
set smartcase			"Except when mixed case is used

set mouse=a			"Always enable the mouse

set nomodeline			"Ignore modelines

set wrap			"Wrap lines at the screen edge
set formatoptions=cqol		"Only wrap comment text
set textwidth=78		"Wrap at 78 characters
set autoindent			"Automatic indenting
set nocindent			"But it's not smart enough to be trusted
set nosmartindent
set foldmethod=syntax		"See autocmds for making this not suck

set history=1000		"Save 1000 lines of history
set updatecount=80		"Characters typed before update
set updatetime=1000		"Milliseconds before update
set viminfo='100,\"500		"Remember filemarks for 100 files and 500 registers

set spelllang=en		"Set spell language to english
set tags=./tags,tags		"Search for tags in both versions of current directory
if !empty($VIM_TAGS)		"Use environment tags file, if provided
	let &tags=&tags.",".$VIM_TAGS
endif

let mapleader=" "		"Rebind <leader> to space bar
set timeoutlen=3000		"Wait 3 seconds for key sequence to complete


"Binds
map <ESC><ESC><ESC> ZQ		"Exit vi
map <leader>do <Plug>TaskList


"Change the default color scheme to something readable
set guifont=Consolas:h14
set background=dark
highlight clear
if exists("syntax_on")
  syntax reset
endif
if has("gui_running")
  colorscheme desert
endif


"Enable syntax highlighting if the terminal supports color
if &t_Co > 2 || has("gui_running")
	syntax on
endif


if has("autocmd")
	filetype on					"Enable filetype detection

	"Always open all folds, on read or file type change
	autocmd FileType * normal zR
	autocmd BufRead * normal zR

	"JSON specific settings
	let g:vim_json_syntax_conceal = 0

	"Go specific settings
	let g:go_def_mapping_enabled = 0
	let g:go_highlight_functions = 1
	let g:go_highlight_methods = 1
	let g:go_highlight_structs = 1
	autocmd FileType go nmap <leader>i <Plug>(go-info)
	autocmd FileType go nmap <leader>o <Plug>(go-implements)
	autocmd FileType go nmap <leader>p <Plug>(go-callees)
	autocmd FileType go nmap <leader>gd <Plug>(go-doc)
	autocmd FileType go nmap <leader>gb <Plug>(go-doc-browser)
	autocmd FileType go nmap <leader>gs <Plug>(go-doc-split)
	autocmd FileType go nmap <leader>gv <Plug>(go-doc-vertical)
	autocmd FileType go nmap <leader>gt <Plug>(go-doc-tab)
	autocmd FileType go nmap <leader>r <Plug>(go-run)
	autocmd FileType go nmap <leader>b <Plug>(go-build)
	autocmd FileType go nmap <leader>t <Plug>(go-test)
	autocmd FileType go nmap <leader>c <Plug>(go-coverage)
	autocmd FileType go nmap <leader>dd <Plug>(go-def)
	autocmd FileType go nmap <leader>ds <Plug>(go-def-split)
	autocmd FileType go nmap <leader>dv <Plug>(go-def-vertical)
	autocmd FileType go nmap <leader>dt <Plug>(go-def-tab)
	autocmd FileType go nmap <leader>e <Plug>(go-rename)
	autocmd FileType go nmap <leader>I :GoImports<CR>

	autocmd FileType go setlocal foldnestmax=1

	"Python specific settings
	let g:pydoc_perform_mappings = 0
	let g:pydoc_open_cmd = 'vsplit'

	autocmd FileType python set nocindent		"DON'T screw with my indenting
	autocmd FileType python set nosmartindent

	autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
	autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<
	autocmd FileType python setlocal foldnestmax=2
	autocmd FileType python setlocal tabstop=8
	autocmd FileType python setlocal softtabstop=4
	autocmd FileType python setlocal shiftwidth=4
	autocmd FileType python setlocal smarttab
	autocmd FileType python setlocal expandtab

	"HTML specific settings
	autocmd FileType html setlocal tabstop=4
	autocmd FileType html setlocal softtabstop=4
	autocmd FileType html setlocal shiftwidth=4
	autocmd FileType html setlocal expandtab

	"Markdown specific settings
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown

	"Git specific settings
	autocmd FileType gitcommit setlocal spell textwidth=72

	"Make specific settings
	autocmd FileType make setlocal foldmethod=indent
endif
