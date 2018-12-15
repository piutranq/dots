""""""""""""
" vim-plug "
""""""""""""
call plug#begin()
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'leafgarland/typescript-vim'
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/syntastic'
Plug 'mtscout6/syntastic-local-eslint.vim'
Plug 'Raimondi/delimitMate'
Plug 'terryma/vim-multiple-cursors'
Plug 'terryma/vim-smooth-scroll'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ntpeters/vim-better-whitespace'
call plug#end()


"""""""""""""""
" Basic Setup "
"""""""""""""""

set autoread

" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

" Tab, Indent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Clipboard
set clipboard=unnamedplus

" Column
set colorcolumn=80


"""""""""""""""""""
" Visual Settings "
"""""""""""""""""""
" Basic
syntax on
set ruler
set number
set showcmd
set cursorline
set showmatch

" Color
set background=dark
set termguicolors
colorscheme gruvbox
highlight Normal guibg=none ctermbg=none

" lightline.vim
let g:lightline = {
\   'colorscheme': 'gruvbox'
\}


"""""""""""""""""""""
" Language Settings "
"""""""""""""""""""""
"HTML/CSS/JS/TS
autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType css setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype json setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2

"""""""""""""""
" Keybindings "
"""""""""""""""
" Remove default scroll keys
noremap <C-f> <Nop>
noremap <C-b> <Nop>
noremap <C-u> <Nop>
noremap <C-d> <Nop>
noremap <C-Home> <Nop>
noremap <C-End> <Nop>
noremap <S-Up> <Nop>
noremap <S-Down> <Nop>

" Redirect Ctrl+A -> Home, Ctrl+E -> End
" It is necessary for Home/End key behavior on tmux environment.
nnoremap <C-a> <Home>
inoremap <C-a> <Home>
vnoremap <C-a> <Home>
nnoremap <C-e> <End>
inoremap <C-e> <End>
vnoremap <C-e> <End>

" Move single lines on normal & input mode
nnoremap <C-S-Up> :m-2<CR>
inoremap <C-S-Up> <Esc>:m-2<CR>i
nnoremap <C-S-Down> :m+1<CR>
inoremap <C-S-Down> <Esc>:m+1<CR>i

" Move selected lines on visual mode
vnoremap <C-S-Up> :m-2<CR>gv
vnoremap <C-S-Down> :m'>+<CR>gv

" vim-multiple-cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-s>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" smooth_scroll
noremap <C-Up> :call smooth_scroll#up(&scroll, 10, 5)<CR>
noremap <C-Down> :call smooth_scroll#down(&scroll, 10, 5)<CR>
noremap <PageUp> :call smooth_scroll#up(&scroll, 10, 5)<CR>
noremap <PageDown> :call smooth_scroll#down(&scroll, 10, 5)<CR>
inoremap <C-Up> <Esc>:call smooth_scroll#up(&scroll, 10, 5)<CR>i
inoremap <C-Down> <Esc>:call smooth_scroll#down(&scroll, 10, 5)<CR>i
inoremap <PageUp> <Esc>:call smooth_scroll#up(&scroll, 10, 5)<CR>i
inoremap <PageDown> <Esc>:call smooth_scroll#down(&scroll, 10, 5)<CR>i

" NERDTree
noremap <F3> :NERDTreeToggle<CR>


"""""""""""""""""""
" Plugin Settings "
"""""""""""""""""""
" delimitMate (Bracket auto completition)
let delimitMate_expand_cr=1

" syntastic (Syntax checker)
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint']

" NERDTree
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 20

