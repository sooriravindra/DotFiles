" Typos happen all the time. Using alias to fix em
com W w
com Q q
com Wq wq
com WQ wq

" Set 256 colour mode
set t_Co=256

" Enables utf-8 chars in Vim
set enc=utf-8

" Set terminal to Xterm to make special keys work rightEg: <Home>
" set term=xterm-256color

" Commands for setting the solarized dark theme with syntax highlighting
syntax enable
set background=dark
" colorscheme solarized

" Set tab as space with 4 characters
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Set backspace to work over line endings and emulate general behaviour
set backspace=indent,eol,start

" Show line numbers
set number

" Show menu when autocompleting commands
set wildmenu

" Highlight all search results and search as you type
set hlsearch
set incsearch

" Keep cursor in the centre of the screen
set scrolloff=999

set autoindent

" Buffers are now hidden, instead of asking each time
set hidden

" Press f2 to go to paste mode, where auto indenting will be turned off
set pastetoggle=<F2>

" Enable ^y and ^p to yank and paste to system clipboard
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP

"Make the split seperator more cleaner
hi VertSplit ctermbg=250 ctermfg=236
set fillchars+=vert:│

" Show line number and percent in the command line
set ruler
set rulerformat=\»\ \%c\ \«\ \%P\ \%L

set cursorline
hi CursorLine   cterm=NONE ctermbg=235

"" -- Let power line handle the following --
" Tabs have sensible colours
" hi TabLine ctermfg=Black ctermbg=LightGrey cterm=NONE

"" Ignores case during search
" set ignorecase

" Let us use space as leader. So that we can use both L & R hand
let mapleader=" "
" Quick swap buffers
nnoremap <leader><leader> <C-^>

" Navigate buffers
nnoremap <leader>k :bp<CR>
nnoremap <leader>j :bn <CR>

" Toggle status bar at <leader-t>
let g:ToggleStatusShow = 0
function ToggleStatus()
    if g:ToggleStatusShow == 0
        set laststatus=2
        let g:ToggleStatusShow = 1
    else
        set laststatus=1
        let g:ToggleStatusShow = 0
    endif
endfunction

nnoremap <silent> <leader>t :call ToggleStatus()<Enter>

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
        sleep 10m
        redraw
        exec "normal " . scrollaction
    endwhile
endfunction


nnoremap <silent> <C-U> :call SmoothScroll(1)<Enter>
nnoremap <silent> <C-D> :call SmoothScroll(0)<Enter>
inoremap <silent> <C-U> <Esc>:call SmoothScroll(1)<Enter>i
inoremap <silent> <C-D> <Esc>:call SmoothScroll(0)<Enter>i

if has("cscope")
    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    endif
endif
" --------------------------------
" Install using: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"  Vundle stuff starts here {

filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'vim-airline/vim-airline'

Plugin 'vim-airline/vim-airline-themes'

Plugin 'christoomey/vim-tmux-navigator'

Plugin 'tpope/vim-vinegar'

"Plugin 'scrooloose/nerdtree'

Plugin 'scrooloose/nerdcommenter'

Plugin 'airblade/vim-gitgutter'

" Keep Plugin commands between vundle#begin/end.

call vundle#end()
filetype plugin indent on    " required

" } end of Vundle stuff

"
"  -------- Configure plugins hence forth ---------------
"


"" -----NERDTree----
"map <C-o> :NERDTreeToggle<CR>

"" Quit vim if NERDTree is the only open window
""autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"" If no file is specified open nerd tree
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"let NERDTreeShowHidden=1
""" In case utf-8 support is not present, use ascii chars in NerdTree
"" let g:NERDTreeDirArrowExpandable = '>'
"" let g:NERDTreeDirArrowCollapsible = 'v'

" ------CtrlP--------
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>p :CtrlP<CR>

" ---NERDCommenter---
" Use <leader> / to toggle comments
vnoremap <leader>/ :call NERDComment(0,"toggle")<CR>
nnoremap <leader>/ :call NERDComment(0,"toggle")<CR>

" ------AirLine------
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='wombat'

"" Enable the following unicode if the font is unavailable on the terminal
"" unicode symbols
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.branch = '⎇'
"let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
"let g:airline_symbols.whitespace = 'Ξ'
"
"" airline symbols
"let g:airline_left_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''
"let g:airline_symbols.branch = ''
"let g:airline_symbols.readonly = ''
"let g:airline_symbols.linenr = ''
