"John Krukoff's vim configuration

set nocompatible "Not vi compatible (No matter how vim was invoked)

"Vundle plugins configuration
filetype off
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
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'majutsushi/tagbar'
Plugin 'moll/vim-node'
Plugin 'nathanielc/vim-tickscript'
Plugin 'nginx/nginx'
Plugin 'saltstack/salt-vim'
Plugin 'scrooloose/syntastic'
Plugin 'sergei-dyshel/vim-yapf-format'
Plugin 'tmhedberg/SimpylFold'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'vim-erlang/erlang-motions.vim'
Plugin 'vim-erlang/vim-erlang-compiler'
Plugin 'vim-erlang/vim-erlang-omnicomplete'
Plugin 'vim-erlang/vim-erlang-runtime'
Plugin 'vim-erlang/vim-erlang-skeletons'
Plugin 'vim-erlang/vim-erlang-tags'
Plugin 'vim-scripts/TaskList.vim'
"Disabled plugins
"Elixir
" Plugin 'elixir-lang/vim-elixir'
"Rust
" Plugin 'rust-lang/rust.vim'
"Clojure
" Plugin 'guns/vim-clojure-static'
" Plugin 'guns/vim-sexp'
"Python 2 only
" Plugin 'pignacio/vim-yapf-format'

"Finalize plugin setup
call vundle#end()
filetype plugin on

"Change the default color scheme to something readable
set guifont=Consolas\ 14
set background=dark
highlight clear
if exists('syntax_on')
	syntax reset
endif
if has('gui_running')
	colorscheme desert
endif


"Enable syntax highlighting if the terminal supports color
if &t_Co > 2 || has('gui_running')
	syntax on
endif


"Global settings
set visualbell			"Use visual bell instead of beep

set ts=8			"Default tab for 8
set list			"Display invisible characters
set listchars=tab:>-,nbsp:-,eol:$,extends:\	"How to display invisible characters

set showmatch			"Show matching parentheses

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
set directory=~/tmp//,.		"Prefer to store swap file under home directory

set spelllang=en		"Set spell language to english
set tags=./tags,tags		"Search for tags in both versions of current directory
if !empty($VIM_TAGS)		"Use environment tags file, if provided
	let &tags=&tags.','.$VIM_TAGS
endif

let mapleader=' '		"Rebind <leader> to space bar
let maplocalleader=' '		"Rebind the <localleader> too.
set timeoutlen=3000		"Wait 3 seconds for key sequence to complete


"Global plugin configuration
let g:gutentags_ctags_tagfile='tags'
let g:gutentags_ctags_auto_set_tags=0	"Only update tags when requested.
let g:gutentags_generate_on_missing=0
let g:gutentags_generate_on_new=0
let g:gutentags_generate_on_write=0
let g:gutentags_generate_on_empty_buffer=0
let g:gutentags_define_advanced_commands=1

let g:netrw_banner=0		"Suppress file browser help banner
let g:netrw_use_errorwindow=0	"Display errors using standard handler
let g:netrw_liststyle=1		"Display files in columns
let g:netrw_preview=1		"Display file previews in vertical splits
let g:netrw_winsize=30		"Display opened files a bit larger

let g:syntastic_aggregate_error = 1
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_jump = 0
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_cursor_column = 0
let g:syntastic_enable_balloons = 0
let g:syntastic_enable_highlighting = 0
let g:syntastic_enable_signs = 0
let g:syntastic_id_checkers = 1
let g:syntastic_sort_aggregated_errors = 1
let g:syntastic_mode_map = {"mode": "passive"}


"Global bindings
map <ESC><ESC><ESC> ZQ					"Exit vim unconditionally
map <leader>/ :noh<CR>					"Clear search highlighting
map <leader>L :write<CR>:SyntasticCheck<CR>:Errors<CR>	"Check file for syntax errors
map <leader>T :TagbarToggle<CR>				"Display tag sidebar
map <leader>do <Plug>TaskList				"Launch tasklist plugin


if has("autocmd")
	"Always open all folds, on read or file type change
	autocmd BufNewFile,BufRead,FileType * normal zR

	"Erlang specific settings
	let g:erlang_show_errors = 1
	let g:erlang_highlight_bifs = 1
	let g:erlang_highlight_special_atoms = 1
	let g:erl_author='John Krukoff'
	let g:erl_tpl_dir=expand('~/.vim-erlang-skeletons-templates')
	let g:syntastic_erlang_checkers = ['escript', 'syntaxerl']

	autocmd FileType erlang setlocal textwidth=70
	autocmd FileType erlang setlocal foldnestmax=2
	autocmd FileType erlang setlocal tabstop=8
	autocmd FileType erlang setlocal softtabstop=4
	autocmd FileType erlang setlocal shiftwidth=4
	autocmd FileType erlang setlocal smarttab
	autocmd FileType erlang setlocal expandtab

	"Go specific settings
	let g:go_def_mapping_enabled = 0
	let g:go_highlight_functions = 1
	let g:go_highlight_methods = 1
	let g:go_highlight_structs = 1
	let g:syntastic_go_checkers = ['gometalinter']
	autocmd FileType go nmap <buffer> <localleader>i <Plug>(go-info)
	autocmd FileType go nmap <buffer> <localleader>o <Plug>(go-implements)
	autocmd FileType go nmap <buffer> <localleader>p <Plug>(go-callees)
	autocmd FileType go nmap <buffer> <localleader>gd <Plug>(go-doc)
	autocmd FileType go nmap <buffer> <localleader>gb <Plug>(go-doc-browser)
	autocmd FileType go nmap <buffer> <localleader>gs <Plug>(go-doc-split)
	autocmd FileType go nmap <buffer> <localleader>gv <Plug>(go-doc-vertical)
	autocmd FileType go nmap <buffer> <localleader>gt <Plug>(go-doc-tab)
	autocmd FileType go nmap <buffer> <localleader>r <Plug>(go-run)
	autocmd FileType go nmap <buffer> <localleader>b <Plug>(go-build)
	autocmd FileType go nmap <buffer> <localleader>t <Plug>(go-test)
	autocmd FileType go nmap <buffer> <localleader>c <Plug>(go-coverage)
	autocmd FileType go nmap <buffer> <localleader>dd <Plug>(go-def)
	autocmd FileType go nmap <buffer> <localleader>ds <Plug>(go-def-split)
	autocmd FileType go nmap <buffer> <localleader>dv <Plug>(go-def-vertical)
	autocmd FileType go nmap <buffer> <localleader>dt <Plug>(go-def-tab)
	autocmd FileType go nmap <buffer> <localleader>e <Plug>(go-rename)
	autocmd FileType go nmap <buffer> <localleader>f :GoFmt<CR>
	autocmd FileType go nmap <buffer> <localleader>I :GoImports<CR>
	autocmd FileType go nmap <buffer> <localleader>k o_ = 'breakpoint'  //TODO: Breakpoint.<esc>

	autocmd FileType go setlocal foldnestmax=1

	"Python specific settings
	let g:pydoc_perform_mappings = 0
	let g:pydoc_open_cmd = 'vsplit'
	let g:syntastic_python_checkers = ['flake8', 'prospector']
	let g:yapf_format_allow_out_of_range_changes = 0
	let g:yapf_format_move_to_error = 0
	let g:virtualenv_directory = '.'
	autocmd FileType python nmap <buffer> <localleader>f :YapfFullFormat<CR>
	autocmd FileType python vmap <buffer> <localleader>f :YapfFormat<CR>
	autocmd FileType python nmap <buffer> <localleader>V :VirtualEnvActivate .virtualenv<CR>
	autocmd FileType python nmap <buffer> <localleader>k oimport pdb; pdb.set_trace()  # TODO: Breakpoint.<esc>
	autocmd FileType python nmap <buffer> <localleader>n :r!python -c "import datetime; print(repr(datetime.datetime.utcnow()))"<CR>
	autocmd BufWinEnter *.py setlocal foldexpr=SimpylFold(v:lnum) foldmethod=expr
	autocmd BufWinLeave *.py setlocal foldexpr< foldmethod<

	autocmd FileType python setlocal encoding=utf-8
	autocmd FileType python setlocal foldnestmax=2
	autocmd FileType python setlocal nocindent
	autocmd FileType python setlocal tabstop=8
	autocmd FileType python setlocal softtabstop=4
	autocmd FileType python setlocal shiftwidth=4
	autocmd FileType python setlocal smarttab
	autocmd FileType python setlocal expandtab

	"Shell specific settings
	let g:syntastic_sh_checkers = ['shellcheck']
	autocmd FileType sh setlocal makeprg=shellcheck\ -f\ gcc\ %:S
	autocmd FileType sh setlocal tabstop=2
	autocmd FileType sh setlocal softtabstop=2
	autocmd FileType sh setlocal shiftwidth=2
	autocmd FileType sh setlocal expandtab

	"Javascript specific settings
	let g:syntastic_javascript_checkers = ['gjslint']
	autocmd FileType javascript setlocal tabstop=2
	autocmd FileType javascript setlocal softtabstop=2
	autocmd FileType javascript setlocal shiftwidth=2
	autocmd FileType javascript setlocal expandtab

	"Java specific settings
	autocmd FileType java setlocal tabstop=4
	autocmd FileType java setlocal softtabstop=4
	autocmd FileType java setlocal shiftwidth=4
	autocmd FileType java setlocal expandtab

	"TICK script specific settings
	let g:tick_fmt_autosave = 0
	let g:tick_fmt_experimental = 0
	autocmd FileType tick nmap <buffer> <localleader>f :TickFmt<CR>

	"XML specific settings
	let g:syntastic_xml_chekcers = ['xmllint']
	autocmd FileType xml setlocal tabstop=2
	autocmd FileType xml setlocal softtabstop=2
	autocmd FileType xml setlocal shiftwidth=2
	autocmd FileType xml setlocal expandtab

	"JSON specific settings
	let g:syntastic_json_checkers = ['jsonlint']
	let g:vim_json_syntax_conceal = 0

	"YAML specific settings
	let g:syntastic_yaml_checkers = ['yamllint']
	autocmd FileType yaml setlocal tabstop=2
	autocmd FileType yaml setlocal softtabstop=2
	autocmd FileType yaml setlocal shiftwidth=2
	autocmd FileType yaml setlocal expandtab

	"HTML specific settings
	let g:syntastic_html_checkers = ['tidy']
	autocmd FileType html setlocal tabstop=4
	autocmd FileType html setlocal softtabstop=4
	autocmd FileType html setlocal shiftwidth=4
	autocmd FileType html setlocal expandtab

	"XHTML specific settings
	let g:syntastic_xhtml_checkers = ['tidy']
	autocmd FileType xhtml setlocal tabstop=4
	autocmd FileType xhtml setlocal softtabstop=4
	autocmd FileType xhtml setlocal shiftwidth=4
	autocmd FileType xhtml setlocal expandtab

	"CSS specific settings
	let g:syntastic_css_checkers = ['recess']
	autocmd FileType css setlocal tabstop=4
	autocmd FileType css setlocal softtabstop=4
	autocmd FileType css setlocal shiftwidth=4
	autocmd FileType css setlocal expandtab

	"Markdown specific settings
	autocmd BufNewFile,BufReadPost *.md setlocal filetype=markdown

	"Git specific settings
	autocmd FileType gitcommit setlocal spell textwidth=72

	"Make specific settings
	autocmd FileType make setlocal foldmethod=indent
endif
