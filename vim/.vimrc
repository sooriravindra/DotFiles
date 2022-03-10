" Typos happen all the time. Using alias to fix em
com W w
com Q q
com Wq wq
com WQ wq

" Read file automatically if changed on disk
set autoread

" New splits below current and to the right
set splitbelow
set splitright

" Set 256 colour mode
set t_Co=256

" Set truecolor if support exists
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

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

" Show line numbers and ? make them relative
set number
" set relativenumber

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

if exists('$TMUX')
    let g:tmux_send_cmd=":silent !tmux send-keys -t 1 'clear' C-m ; "
    let g:tmux_send_cmd.="tmux send-keys -t 1 'type compile_cmd && compile_cmd && date' C-m"

    " Smake shall send keys to pane 1 in tmux, TODO should this be better?
    " command! Smake execute ':silent !tmux send-keys -t 1 "clear" C-m ; tmux send-keys -t 1 "type compile_cmd && compile_cmd" C-m'  | execute ':redraw!'
    command! Smake execute g:tmux_send_cmd | execute ':redraw!'
elseif v:version > 800
    " If higher than vim8 use the inbuilt terminal
    function! SideRun()
        only
        execute "vert term bash -c \"" &makeprg "\""
        wincmd p
    endfunction

    command! Smake :call SideRun()
endif

" Force autoread
function _Autoread(timer)
    silent checktime %
endfunction

function! Autoread()
    let timer = timer_start(200,'_Autoread', {'repeat': 5})
endfunction

" Let's write a local init function that gets called each time vim
" is opened. We'll look at current directory look for a file called
" .local_vimrc in the directory and source it, add cscope file if 
" found. A nice trick is to set project specific stuff like makeprg 
" set in .local_vimrc and commit it to a repo.

function VimLocalInit()
    let l:welcome_msg="[GG]"
    if filereadable(".local_vimrc")
        let l:welcome_msg.=" Sourcing local .local_vimrc. "
        source .local_vimrc
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
    cs add cscope.out
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

function ToggleGit()
    if buflisted(bufname('.git/index'))
        bd .git/index
    else
        Git
    endif
endfunction

nnoremap <silent> <C-U> :call SmoothScroll(1)<Enter>
nnoremap <silent> <C-D> :call SmoothScroll(0)<Enter>

inoremap <silent> <C-U> <Esc>:call SmoothScroll(1)<Enter>i
inoremap <silent> <C-D> <Esc>:call SmoothScroll(0)<Enter>i

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

Plug 'sheerun/vim-polyglot'

Plug 'liuchengxu/vim-which-key'

" Plug 'junegunn/goyo.vim'

" God bless Tim Pope

Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-commentary'

" Colorschemes

Plug 'joshdick/onedark.vim'

Plug 'gruvbox-community/gruvbox'

Plug 'lifepillar/vim-solarized8'

Plug 'ghifarit53/tokyonight-vim'

" Here comes the Dragon!
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Install coc-clangd by using the below vim command
" :CocInstall coc-langd
" Then install clangd on the machine

call plug#end()

" ====================================================================
"                    Leader commands follow:
" ====================================================================
"
" List all the commands here. Lest you forget.
"
" leader + leader  = Go to last buffer
" leader + /       = Comment the line/block (commentary)
" leader + j       = Next buffer
" leader + k       = Prev buffer
" leader + bd      = Delete buffer
" leader + bn      = Next buffer
" leader + bp      = Prev buffer
" leader + cg      = Jump to cscope definition
" leader + cr      = Reload cscope database
" leader + cs      = Jump to cscope symbol
" leader + fb      = Fuzzy search buffers
" leader + fp      = Fuzzy search files
" leader + mm      = Run makeprg (Smake command)
" leader + sf      = Run grepprg (Grep command)
" leader + su      = Gundo toggle
" leader + sw      = Remove trailing whitespace
" leader + tc      = Centre cursor toggle
" leader + tg      = Gstatus toggle (fugitive)
" leader + ts      = Status bar toggle
" leader + wn      = Close all other windows

" Let us use space as leader. So that we can use both L & R hand
let mapleader=" "

let g:which_key_map = {}

" Quick swap buffers
nnoremap <leader><leader> <C-^>
let g:which_key_map[' '] = 'switch-buffer'

" Navigate buffers
nnoremap <leader>k :bp<CR>
nnoremap <leader>j :bn <CR>
let g:which_key_map.k = 'previous-buffer'
let g:which_key_map.j = 'next-buffer'

" Close current buffer
nnoremap <leader>bd :bd <CR>

nnoremap <leader>bp :bp<CR>
nnoremap <leader>bn :bn <CR>
let g:which_key_map.b = {
            \ 'name' : '+buffer',
            \ 'd' : 'buffer-delete',
            \ 'n' : 'buffer-next',
            \ 'p' : 'buffer-previous'
            \ }


" Close all other windows
nnoremap <leader>wn :only <CR>
nnoremap <leader>wh <C-w>h
nnoremap <leader>wj <C-w>j
nnoremap <leader>wk <C-w>k
nnoremap <leader>wl <C-w>l

let g:which_key_map.w = {
            \ 'name' : '+window',
            \ 'n' : 'window-only',
            \ 'h' : 'window-left',
            \ 'j' : 'window-down',
            \ 'k' : 'window-up',
            \ 'l' : 'window-right',
            \ }

" mapping for grep
nnoremap <leader>sf :Grep

" mapping Gundo
nnoremap <leader>su :GundoToggle <Enter>

" Remove trailing whitespace
nnoremap <leader>sw :%s/\s\+$//e <Enter>

" lets make faster
nnoremap <leader>sm :Smake <CR>

let g:which_key_map.s = {
            \ 'name' : '+super',
            \ 'f' : 'grep-find',
            \ 'u' : 'gundo',
            \ 'w' : 'remove-trailing-whitespace',
            \ 'm' : 'super-make'
            \ }

" Toggle center cursor
nnoremap <silent> <leader>tc :call ToggleCursor()<Enter>

" Toggle status bar
nnoremap <silent> <leader>ts :call ToggleStatus()<Enter>

" Toggle Gstatus
nnoremap <silent> <leader>tg :call ToggleGit()<Enter>

let g:which_key_map.t = {
            \ 'name' : '+toggle',
            \ 'c' : 'toggle-cursor-line',
            \ 's' : 'toggle-status-bar',
            \ 'g' : 'toggle-git'
            \ }

" Reload cscope
nnoremap <silent> <leader>cr :call ReloadCscope()<Enter><Enter>

" cscope query symbol and definition
nnoremap <silent> <leader>cs :cs f s <C-R><C-W><Enter>
nnoremap <silent> <leader>cg :cs f g <C-R><C-W><Enter>

let g:which_key_map.c = {
            \ 'name' : '+coc-cscope',
            \ 'r' : 'cscope-reload',
            \ 's' : 'cscope-symbol',
            \ 'g' : 'cscope-definition',
            \ }


"
"  ===================================================================
"                        Plug configs go here
"  ===================================================================


" ----commentary----
vnoremap <leader>/ :Commentary<CR>
nnoremap <leader>/ :Commentary<CR>

" -------FZF--------

nnoremap <leader>fb :Buffers<CR>
" Below command binds <leader>p to list only git files if inside a git repo
nnoremap <leader>p :execute system('git rev-parse --is-inside-work-tree') =~ 'true' ? 'GFiles' : 'Files'<CR>
" To list all files even in git repositories:
nnoremap <leader>fp :Files<CR>
" To fuzzy search lines in all buffers
nnoremap <leader>fl :Lines<CR>

let g:which_key_map.p = 'fzf-relevant-files'
let g:which_key_map.f = {
            \ 'name' : '+fzf',
            \ 'b' : 'search-buffers',
            \ 'p' : 'fuzzy-search-files',
            \ 'l' : 'fuzzy-search-lines'
            \ }

"" -------Gundo-------
let g:gundo_prefer_python3 = 1

" ------Colorscheme-------
" colorscheme solarized8_flat
let g:tokyonight_disable_italic_comment = 1
colorscheme tokyonight

" -----Buftabline-----
let g:buftabline_indicators = 1

" -----netrw----------
let g:netrw_banner = 0
nnoremap - :e shodisu_ \| Explore \| bw! shodisu_<CR>

" ----coc.nvim--------
inoremap <silent><expr> <TAB>
            \ pumvisible() ? coc#_select_confirm() :
            \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

nnoremap <leader>cj :call CocAction('diagnosticNext')<CR>
let g:which_key_map.c['j'] = 'coc-next-error'

nnoremap <leader>ch :CocCommand clangd.switchSourceHeader<CR>
let g:which_key_map.c['h'] = 'coc-switch-header'

nnoremap <leader>cf :CocFix<CR>
let g:which_key_map.c['f'] = 'coc-fix'

" ---vim-whichkey---
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>

