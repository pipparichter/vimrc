" vim-plug initialization (DON'T TOUCH THIS)
let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_path)
    echo "Installing Vim-plug..."
    echo ""
    silent !mkdir -p ~/.vim/autoload
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    let vim_plug_just_installed = 1
endif

" manually load vim-plug the first time
if vim_plug_just_installed
    :execute 'source '.fnameescape(vim_plug_path)
endif

" Plugins ================================================================

call plug#begin('~/.vim/plugged')

" Plugins from GitHub repos --------------------------------------------

" Preview MarkDown text in a browser
Plug 'suan/vim-instant-markdown', {'for':'markdown'}
" Override configs by directory 
Plug 'arielrossanigo/dir-configs-override.vim'
" Code commenter
Plug 'scrooloose/nerdcommenter'
" Git integration
Plug 'motemen/git-vim'
" Tab list panel
Plug 'kien/tabman.vim'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Terminal Vim with 256 colors colorscheme
Plug 'fisadev/fisa-vim-colorscheme'
" Consoles as buffers
Plug 'rosenfeld/conque-term'
" Surround
Plug 'tpope/vim-surround'
" Automatically adds close parentheses, brackets, etc. 
Plug 'Townk/vim-autoclose'
" Indent text object
Plug 'michaeljsmith/vim-indent-object'
" Indentation based movements
Plug 'jeetsukumaran/vim-indentwise'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'honza/vim-snippets'
Plug 'garbas/vim-snipmate'
" Automatically sort python imports
Plug 'fisadev/vim-isort'
" Window chooser
Plug 't9md/vim-choosewin'
" Python and other languages code checker
Plug 'scrooloose/syntastic'
" Paint css colors with the real color
Plug 'lilydjwg/colorizer'
" Ack code search (requires ack installed in the system)
Plug 'mileszs/ack.vim'
if has('python')
    " YAPF formatter for Python
    Plug 'pignacio/vim-yapf-format'
endif

" Plugins from vim-scripts repos ---------------------------------

" Search results counter
Plug 'vim-scripts/IndexedSearch'
" XML/HTML tags navigation
Plug 'vim-scripts/matchit.zip'
" Yank history navigation
Plug 'vim-scripts/YankRing.vim'

" Other plugins -------------------------------------------------

" Latex
Plug '~/.vim/plugged/vim-latex' " , {'for':'tex'}


call plug#end()

" Install plugins the first time vim runs ----------------------

if vim_plug_just_installed
    echo "Installing Bundles, please ignore key map error messages"
    :PlugInstall
endif


" Vim settings and mappings ====================================================

" Not vi-compatible
set nocompatible

" Allow plugins by file type (required for plugins!)
filetype plugin on
filetype indent on

" Tabs and spaces adjustments
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Always show status bar
set ls=2

" Incremental search
set incsearch

" Highlighted search results
set hlsearch

" Syntax highlight on
syntax on

" Show line numbers
set nu

" Latex mappings for creating bold/italicized/underlined text, as well as
" other shortcuts for markdown files
augroup conditional_mappings
    " Make sure the autocommands aren't loaded twice by removing all loaded
    " autocommands in this group. This is needed because, each time the .vimrc
    " is called, it merges augroups (it doesn't replace them); if this command
    " is not included, autocmds in the group will be included twice.
    autocmd!
    
    autocmd FileType tex imap <C-X> \textit{}<Left>
    autocmd FileType tex imap <C-Y> \textbf{}<Left>
    autocmd FileType tex imap <C-Z> \underline{}<Left>
    autocmd FileType tex imap <C-E> $ $<Left>
    
    autocmd FileType markdown imap <C-X> **<Left>
    autocmd FileType markdown imap <C-Y> ****<Left><Left>
    autocmd FileType markdown imap <C-N> <br/>
    " autocmd FileType markdown imap <Tab> <Tab>

augroup END

" Disabled because this setting makes the window flicker.
set completeopt-=preview

" Use 256 colors when possible
if (&term =~? 'mlterm\|xterm\|xterm-256\|screen-256') || has('nvim')
	let &t_Co = 256
    colorscheme fisa
else
    colorscheme delek
endif

" When scrolling, keep cursor 3 lines away from screen border
set scrolloff=3

" Terminal-like autocompletion of files and commands
set wildmode=list:longest

" Better backup, swap and undos storage
" Set a directory for swap files
set directory=~/.vim/dirs/tmp     
" Set a directory for backup files
set backup                        
set backupdir=~/.vim/dirs/backups
" What does this do?
set undofile                      
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo
" Store yankring history file
let g:yankring_history_dir = '~/.vim/dirs/'

" Create needed directories if they don't exist
if !isdirectory(&backupdir)
    call mkdir(&backupdir, "p")
endif
if !isdirectory(&directory)
    call mkdir(&directory, "p")
endif
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif


" Plugins settings and mappings ======================================================

" Syntastic ------------------------------

" Show list of errors and warnings on the current file
nmap <leader>e :Errors<CR>
" Check also when just opened the file
let g:syntastic_check_on_open = 1

" TabMan ------------------------------

" Shortcut to open and close TabMan window
let g:tabman_toggle = 'mt'

" Autoclose ------------------------------

" Fix to let ESC work as espected with Autoclose plugin
let g:AutoClosePumvisible = {"ENTER": "\<C-Y>", "ESC": "\<ESC>"}

" Window Chooser ------------------------------

nmap  -  <Plug>(choosewin)

let g:choosewin_overlay_enable = 1

" Airline ------------------------------

let g:airline_powerline_fonts = 0
let g:airline_theme = 'bubblegum'
let g:airline#extensions#whitespace#enabled = 0

" Latex-Suite ----------------------------

" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor = 'latex'

" Setting viewing rules based on document type
let g:Tex_ViewRule_dvi = 'xdvi'
let g:Tex_ViewRule_ps = 'ghostview'
let g:Tex_ViewRule_pdf = 'xpdf'

let g:Tex_DefaultTargetFormat = 'pdf'

let g:Tex_CompileRule_pdf = 'pdflatex -interaction=nonstopmode -output-directory=./ -output-format=pdf $*'

" NerdCommenter -----------------------------

" Note that this Plugin only works in Normal and Visual modes.

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

