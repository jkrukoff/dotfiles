"John Krukoff's vim configuration

set nocompatible		"Not vi compatible (No matter how vim was invoked)

" Vundle plugins configuration
filetype off			"Required by vundle.
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Actual plugin list
Plugin 'gmarik/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'
Plugin 'vim-flake8'
Plugin 'jpythonfold.vim'

" Finalize plugin setup.
call vundle#end()
filetype plugin on


" Global settings
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

set history=100			"Save 100 lines of history
set updatecount=80		"Characters typed before update
set updatetime=1000		"Milliseconds before update
set viminfo='50,\"200		"Remember filemarks for 50 files and 200 registers

set spelllang=en		"Set spell language to english.
set tags=./tags,tags		"Search for tags in both versions of current directory.


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
