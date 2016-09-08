" Set 256 colour mode
set t_Co=256

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


nnoremap <C-U> :call SmoothScroll(1)<Enter>
nnoremap <C-D> :call SmoothScroll(0)<Enter>
inoremap <C-U> <Esc>:call SmoothScroll(1)<Enter>i
inoremap <C-D> <Esc>:call SmoothScroll(0)<Enter>i

" Vundle stuff starts here >>>>>>>>>>>

filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugin 'scrooloose/nerdtree'
" Keep Plugin commands between vundle#begin/end.
call vundle#end()            " required
filetype plugin indent on    " required

" end of Vundle stuff <<<<<<<<<<<<<<<<<<<<

" Set nerdtree config
map <C-o> :NERDTreeToggle<CR>
" Make NerdTRee open files in new tab by default

" In case utf-8 support is not present, use ascii chars in NerdTree
" let g:NERDTreeDirArrowExpandable = '>'
" let g:NERDTreeDirArrowCollapsible = 'v'

" Enables utf-8 chars in Vim
set enc=utf-8

" Tabs have sensible colours
hi TabLine ctermfg=Black ctermbg=LightGrey cterm=NONE

" Ignores case during search
" set ignorecase
