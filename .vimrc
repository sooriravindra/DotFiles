" Typos happen all the time. Using alias to fix em
com W w
com Q q
com Wq wq
com WQ wq

" Set 256 colour mode
set t_Co=256

" Enables utf-8 chars in Vim
set enc=utf-8

" Enable syntax highlighting
syntax enable

" Enable ftplugins and indent scripts
filetype plugin indent on

" Allow % to jump between if and else
runtime macros/matchit.vim

" Syntax highlighting to adopt to dark background
set background=dark

" colorscheme solarized? Nah. We'll set gruvbox later

" Show line numbers and make them relative
set number
set relativenumber

" Show menu when autocompleting commands
set wildmenu

" Keep cursor in the centre of the screen
set scrolloff=999

" Make the split seperator more cleaner
" hi VertSplit ctermbg=236 ctermfg=246
" set fillchars+=vert:|

" Show line number and percent in the command line
set ruler
set rulerformat=\ »\ \%c\ «\ %P\ %L

" Show the partial commands in the status bar
set showcmd

" Highlight the line where the cursor is located
set cursorline
hi CursorLine   cterm=NONE ctermbg=236

" Set tab as space with 4 characters
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Set backspace to work over line endings and emulate general behaviour
set backspace=indent,eol,start

" Highlight all search results and search as you type
set hlsearch
set incsearch

"" Ignores case during search
" set ignorecase

" New lines begin with indentation
set autoindent

" Buffers are now hidden, instead of asking each time
set hidden

" Press f2 to go to paste mode, where auto indenting will be turned off
set pastetoggle=<F2>

" Make grep sane. Use recursive by default. Use ag if available
" See https://github.com/ggreer/the_silver_searcher
if executable('ag')
    set grepprg=ag
else
    set grepprg=grep\ -rn
endif

" Set makeprg to run a command on pane 1 in tmux. TODO Need to tweak?
set makeprg=tmux\ send-keys\ -t\ 1\ 'clear'\ C-m&&\ tmux\ send-keys\ -t\ 1\ 'compile_cmd'\ C-m

" Enable ^y and ^p to yank and paste to system clipboard
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP


"" -- Let power line handle the following --
" Tabs have sensible colours
" hi TabLine ctermfg=Black ctermbg=LightGrey cterm=NONE


" ====================================================================
"                   Custom functions go here:
" ====================================================================

" Add a sensible Grep command. silent removes shell output, redraw
" needed to fix display after suppressing output. grep uses grepprg
" which was set
command! -bar -nargs=1 Grep silent grep <q-args> | redraw! | cw

" Need a silent make
command Smake silent make | redraw!

" Let's write a local init function that gets called each time vim
" is opened. We'll look at current directory look for a file called
" vimrc in the directory and source it, add cscope file if found. A
" nice trick is to set project specific stuff like makeprg set in
" vimrc and commit it to a repo.

function VimLocalInit()
    let l:welcome_msg="[GG]"
    if filereadable("vimrc")
        let l:welcome_msg.=" Sourcing local vimrc. "
        source vimrc
    endif
    if filereadable("cscope.out") && executable("cscope")
        let l:welcome_msg.=" cscope connected."
        cs add cscope.out
    endif
    echom l:welcome_msg
endfunction

function ReloadCscope()
    !cscope -qRb
    cs reset 1
endfunction

" Toggle the status bar, disabled by default

set laststatus=0
let g:ToggleStatusShow = 0

function ToggleStatus()
    if g:ToggleStatusShow == 0
        set laststatus=2
        let g:ToggleStatusShow = 1
    else
        set laststatus=0
        let g:ToggleStatusShow = 0
    endif
endfunction

" Following function and mapping allow smooth scrolling using ^d and ^u
" Helps preserve visual context. Inspired by http://goo.gl/7RUfA8

function SmoothScroll(up)
    if a:up
        let scrollaction="k"
    else
        let scrollaction="j"
    endif
    exec "normal " . scrollaction
    redraw
    let counter=1
    let scrollsize=15
    while counter<scrollsize
        let counter+=1
        sleep 1m
        redraw
        exec "normal " . scrollaction
    endwhile
endfunction

" Toggle centre cursor

function ToggleCursor()
    if &scrolloff==999
        set scrolloff=0
        echom "Centre cursor disabled"
    else
        set scrolloff=999
        echom "Centre cursor enabled"
    endif
endfunction

" Toggle fugitive git status

function ToggleGstatus()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Gstatus
    endif
endfunction

nnoremap <silent> <C-U> :call SmoothScroll(1)<Enter>
nnoremap <silent> <C-D> :call SmoothScroll(0)<Enter>

inoremap <silent> <C-U> <Esc>:call SmoothScroll(1)<Enter>i
inoremap <silent> <C-D> <Esc>:call SmoothScroll(0)<Enter>i

" ====================================================================
"                    Leader commands follow:
" ====================================================================
"
" List all the commands here. Lest you forget.
"
" leader + leader = Go to last buffer
" leader + /      = Comment the line/block (commentary)
" leader + b      = Fuzzy search buffers
" leader + c      = Centre cursor toggle
" leader + f      = Run grepprg (Grep command)
" leader + g      = Jump to cscope definition
" leader + j      = Next buffer
" leader + k      = Prev buffer
" leader + l      = Close all other windows
" leader + m      = Run makeprg (Smake command)
" leader + p      = Fuzzy search files
" leader + q      = Remove trailing whitespace
" leader + r      = Reload cscope database
" leader + s      = Jump to cscope symbol
" leader + t      = Status bar toggle
" leader + u      = Gundo toggle
" leader + v      = Gstatus toggle (fugitive)
" leader + x      = Delete buffer

" Let us use space as leader. So that we can use both L & R hand
let mapleader=" "

" Quick swap buffers
nnoremap <leader><leader> <C-^>

" Navigate buffers
nnoremap <leader>k :bp<CR>
nnoremap <leader>j :bn <CR>

" Close current buffer
nnoremap <leader>x :bd <CR>

" Close all other windows
nnoremap <leader>l :only <CR>

" cscope query symbol and definition
nnoremap <silent> <leader>s :cs f s <C-R><C-W><Enter>
nnoremap <silent> <leader>g :cs f g <C-R><C-W><Enter>

" mapping for grep
nnoremap <leader>f :Grep

" mapping Gundo
nnoremap <leader>u :GundoToggle <Enter>

" lets make faster
nnoremap <leader>m :Smake <CR>

" Toggle center cursor
nnoremap <silent> <leader>c :call ToggleCursor()<Enter>

" Toggle status bar
nnoremap <silent> <leader>t :call ToggleStatus()<Enter>

" Toggle Gstatus
nnoremap <silent> <leader>v :call ToggleGstatus()<Enter>

" Reload cscope
nnoremap <silent> <leader>r :call ReloadCscope()<Enter><Enter>

" Remove trailing whitespace
nnoremap <leader>q :%s/\s\+$//e <Enter>

" =======================================================================
"                      Autocommands here:
" =======================================================================

autocmd VimEnter * :call VimLocalInit()

" =======================================================================
"                      Vim Plug stuff here, adds plugins
" =======================================================================

" Run the following to install Plug:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
" https://raw.github.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

" A bit of history. Plugins I used, but no longer do:
"
" Plug 'scrooloose/nerdtree'
" Replaced by vinegar
"
" Plug 'ctrlpvim/ctrlp.vim'
" Replaced by FZF
"
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Buftabline provides the buffer line which is the only reason I used Airline
"
" Plug 'lervag/vimtex'
" Instead : latexmk -pdf -pvc -interaction=nonstopmode <sample.tex>
"
" Plug 'scrooloose/nerdcommenter'
" Replaced by commentary
"
" Plug 'tpope/vim-vinegar'
" Replaced by adding some netrw configs

Plug 'tommcdo/vim-lion'

Plug 'ap/vim-buftabline'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'junegunn/fzf.vim'

Plug 'christoomey/vim-tmux-navigator'

Plug 'airblade/vim-gitgutter'

Plug 'sjl/gundo.vim'

Plug 'nachumk/systemverilog.vim'

Plug 'mattn/emmet-vim'

Plug 'machakann/vim-sandwich'

" God bless Tim Pope

Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-commentary'

" Colorschemes

Plug 'sickill/vim-monokai'

Plug 'morhetz/gruvbox'

call plug#end()

"
"  ===================================================================
"                        Plug configs go here
"  ===================================================================


" ----commentary----
vnoremap <leader>/ :Commentary<CR>
nnoremap <leader>/ :Commentary<CR>

" -------FZF--------
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>p :FZF<CR>

"" -------Gundo-------
let g:gundo_prefer_python3 = 1

" ------gruvbox-------
colorscheme gruvbox

" -----Buftabline-----
let g:buftabline_indicators = 1

" -----netrw----------
let g:netrw_banner = 0
nnoremap - :e shodisu_ \| Explore \| bw! shodisu_<CR>
