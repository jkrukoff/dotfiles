"John Krukoff's vim configuration

set nocompatible		"Not vi compatible (No matter how vim was invoked)

"Vundle plugins configuration
filetype off			"Required by vundle.
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"Actual plugin list
Plugin 'gmarik/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'
Plugin 'vim-flake8'
Plugin 'jpythonfold.vim'

"Finalize plugin setup.
call vundle#end()
filetype plugin on


"Global settings
set visualbell			"Use visual bell instead of beep.

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
set showtabline=1		"Show tab bar when tabs exist.

set foldlevel=100		"Expand all folds by default.

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

set history=1000		"Save 100 lines of history
set updatecount=80		"Characters typed before update
set updatetime=1000		"Milliseconds before update
set viminfo='100,\"500		"Remember filemarks for 100 files and 500 registers

set spelllang=en		"Set spell language to english.
set tags=./tags,tags		"Search for tags in both versions of current directory.
if !empty($VIM_TAGS)		"Use environment tags file, if provided.
	let &tags=&tags.",".$VIM_TAGS
endif

let mapleader=" "		"Rebind <leader> to space bar.
set timeoutlen=3000		"Wait 3 seconds for key sequence to complete.


"Binds
map <ESC><ESC><ESC> ZQ		"Exit vi


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

	"Go specific settings.
	let g:go_def_mapping_enabled = 0
	let g:go_highlight_functions = 1
	let g:go_highlight_methods = 1
	let g:go_highlight_structs = 1
	au FileType go nmap <Leader>i <Plug>(go-info)
	au FileType go nmap <Leader>o <Plug>(go-implements)
	au FileType go nmap <Leader>p <Plug>(go-callees)
	au FileType go nmap <Leader>gd <Plug>(go-doc)
	au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
	au FileType go nmap <Leader>gs <Plug>(go-doc-split)
	au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
	au FileType go nmap <Leader>gt <Plug>(go-doc-tab)
	au FileType go nmap <leader>r <Plug>(go-run)
	au FileType go nmap <leader>b <Plug>(go-build)
	au FileType go nmap <leader>t <Plug>(go-test)
	au FileType go nmap <leader>c <Plug>(go-coverage)
	au FileType go nmap <Leader>dd <Plug>(go-def)
	au FileType go nmap <Leader>ds <Plug>(go-def-split)
	au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
	au FileType go nmap <Leader>dt <Plug>(go-def-tab)
	au FileType go nmap <Leader>e <Plug>(go-rename)
	au FileType go nmap <Leader>I :GoImports<CR>

	"Python specific settings.
	autocmd FileType python set nocindent		"DON'T screw with my indenting
	autocmd FileType python set nosmartindent

	autocmd FileType python setlocal tabstop=8
	autocmd FileType python setlocal softtabstop=4
	autocmd FileType python setlocal shiftwidth=4
	autocmd FileType python setlocal smarttab
	autocmd FileType python setlocal expandtab

	"HTML specific settings.
	autocmd FileType html setlocal tabstop=4
	autocmd FileType html setlocal softtabstop=4
	autocmd FileType html setlocal shiftwidth=4
	autocmd FileType html setlocal expandtab

	"Markdown specific settings.
	autocmd BufNewFile,BufReadPost *.md set filetype=markdown

	"Git specific settings.
	autocmd Filetype gitcommit setlocal spell textwidth=72
endif

