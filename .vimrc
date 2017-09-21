" Typos happen all the time. Using alias to fix em
com W w
com Q q
com Wq wq
com WQ wq

" Set 256 colour mode
set t_Co=256

" Enables utf-8 chars in Vim
set enc=utf-8

"" Set terminal to Xterm to make special keys work rightEg: <Home>
" set term=xterm-256color

" Enable syntax highlighting
syntax enable

" Syntax highlighting to adopt to dark background
set background=dark

"" Colorscheme: Solarized? Nah
colorscheme gruvbox

" Show line numbers
set number

" Show menu when autocompleting commands
set wildmenu

" Keep cursor in the centre of the screen
set scrolloff=999

"Make the split seperator more cleaner
hi VertSplit ctermbg=250 ctermfg=236
set fillchars+=vert:│

" Show line number and percent in the command line
set ruler
set rulerformat=\»\ \%c\ \«\ \%P\ \%L

" Highlight the line where the cursor is located
set cursorline
hi CursorLine   cterm=NONE ctermbg=235

" Set tab as space with 4 characters
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Set backspace to work over line endings and emulate general behaviour
set backspace=indent,eol,start

" Highlight all search results and search as you type
set hlsearch
set incsearch

"" Ignores case during search
" set ignorecase

set autoindent

" Buffers are now hidden, instead of asking each time
set hidden

" Press f2 to go to paste mode, where auto indenting will be turned off
set pastetoggle=<F2>

" Make grep sane
set grepprg=ag 

" Enable ^y and ^p to yank and paste to system clipboard
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP

" cscope, export CSCOPE_DB when you need supoort
cs add $CSCOPE_DB

"" -- Let power line handle the following --
" Tabs have sensible colours
" hi TabLine ctermfg=Black ctermbg=LightGrey cterm=NONE


" ====================================================================
"                   Custom functions here:
" ====================================================================

" Toggle the status bar 
function ToggleStatus()
    if g:ToggleStatusShow == 0
        set laststatus=2
        let g:ToggleStatusShow = 1
    else
        set laststatus=1
        let g:ToggleStatusShow = 0
    endif
endfunction

" Add a sensible Grep command. silent removes shell output, redraw needed to
" fix display after suppressing output. grep uses grepprg which was set (ag)
command! -bar -nargs=1 Grep silent grep <q-args> | redraw! | cw

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
        sleep 3m
        redraw
        exec "normal " . scrollaction
    endwhile
endfunction

nnoremap <silent> <C-U> :call SmoothScroll(1)<Enter>
nnoremap <silent> <C-D> :call SmoothScroll(0)<Enter>
inoremap <silent> <C-U> <Esc>:call SmoothScroll(1)<Enter>i
inoremap <silent> <C-D> <Esc>:call SmoothScroll(0)<Enter>i

" ====================================================================
"                    Leader commands follow:
" ====================================================================

" Let us use space as leader. So that we can use both L & R hand
let mapleader=" "

" Quick swap buffers
nnoremap <leader><leader> <C-^>

" Navigate buffers
nnoremap <leader>k :bp<CR>
nnoremap <leader>j :bn <CR>

" Toggle status bar at <leader-t>
nnoremap <silent> <leader>t :call ToggleStatus()<Enter>
" by default don't show
let g:ToggleStatusShow = 0

" cscope query symbol and definition
nnoremap <silent> <leader>s :cs f s <C-R><C-W><Enter>
nnoremap <silent> <leader>g :cs f g <C-R><C-W><Enter>

" mapping for grep
nnoremap <leader>f :Grep 

" lets make faster
nnoremap <leader>m :make <CR>
" =======================================================================
"                      Vim Plug stuff here, adds plugins
" =======================================================================

" Run the following to install Plug:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
" https://raw.github.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

Plug 'ctrlpvim/ctrlp.vim'

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

Plug 'christoomey/vim-tmux-navigator'

Plug 'tpope/vim-vinegar'

"Plug 'scrooloose/nerdtree'

Plug 'scrooloose/nerdcommenter'

Plug 'airblade/vim-gitgutter'

call plug#end()

"
"  ===========================================================================
"                         Configure plugins hence forth
"  ===========================================================================


" ------CtrlP--------
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>p :CtrlP<CR>

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" ---NERDCommenter---
" Use <leader> / to toggle comments
vnoremap <leader>/ :call NERDComment(0,"toggle")<CR>
nnoremap <leader>/ :call NERDComment(0,"toggle")<CR>

" ------AirLine------
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" Less flashy colours
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


