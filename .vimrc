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
"hi VertSplit ctermbg=236 ctermfg=246
" set fillchars+=vert:|

" Show line number and percent in the command line
set ruler
set rulerformat=\ »\ \%c\ «\ %P\ %L

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


"" -- Let power line handle the following --
" Tabs have sensible colours
" hi TabLine ctermfg=Black ctermbg=LightGrey cterm=NONE


" ====================================================================
"                   Custom functions here:
" ====================================================================

" Add a sensible Grep command. silent removes shell output, redraw needed to
" fix display after suppressing output. grep uses grepprg which was set (ag)
command! -bar -nargs=1 Grep silent grep <q-args> | redraw! | cw

" Need a silent make
command Smake silent make | redraw!


" Let's write a local init function that gets called each time vim is opened
" We'll look at current directory look for a file called vimrc in the directory 
" and source it, add cscope file if found. A nice trick is to set project
" specific stuff like makeprg set in vimrc and commit it to a repo.
function VimLocalInit()
    let l:welcome_msg=""
    if filereadable("vimrc")
               let l:welcome_msg.="Sourcing local vimrc. "
               source vimrc
    endif
    if filereadable("cscope.out")
               let l:welcome_msg.="Adding cscope.out. "
               cs add cscope.out
    endif
    echom l:welcome_msg
endfunction

function ReloadCscope()
    !cscope -qRb
    cs reset 1
endfunction

let g:ToggleStatusShow = 1
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

" Toggle status bar at <leader-t>
nnoremap <silent> <leader>t :call ToggleStatus()<Enter>

" Reload cscope
nnoremap <silent> <leader>r :call ReloadCscope()<Enter><Enter>

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

" Plugins I used, but no longer use:
"Plug 'scrooloose/nerdtree'
"Plug 'ctrlpvim/ctrlp.vim'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

Plug 'ap/vim-buftabline'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'junegunn/fzf.vim'

Plug 'christoomey/vim-tmux-navigator'

Plug 'lervag/vimtex'

Plug 'tpope/vim-vinegar'

Plug 'scrooloose/nerdcommenter'

Plug 'airblade/vim-gitgutter'

Plug 'sjl/gundo.vim'

Plug 'nachumk/systemverilog.vim'

call plug#end()

"
"  ===========================================================================
"                         Configure plugins hence forth
"  ===========================================================================


" ---NERDCommenter---
" Use <leader> / to toggle comments
vnoremap <leader>/ :call NERDComment(0,"toggle")<CR>
nnoremap <leader>/ :call NERDComment(0,"toggle")<CR>

" ------FZF--------
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>p :FZF<CR>

" ------CtrlP--------
"nnoremap <leader>b :CtrlPBuffer<CR>
"nnoremap <leader>p :CtrlP<CR>
"nnoremap <leader>o :CtrlPMixed<CR>
"
"let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']


"" ------VimTex------
let g:vimtex_compiler_latexmk = {'callback' : 0}


" Less flashy colours
set laststatus=0

"" -------Gundo-------
let g:gundo_prefer_python3 = 1

let g:buftabline_indicators = 1
