set shell=bash
set nocompatible


call plug#begin('~/.config/nvim/plugged')

Plug 'chriskempson/base16-vim'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'mbbill/undotree'
Plug 'hecal3/vim-leader-guide'
Plug 'racer-rust/vim-racer'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --tern-completer --racer-completer --clang-completer' }
Plug 'Chiel92/vim-autoformat'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
Plug 'vim-scripts/nc.vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'

" Org-mode
Plug 'vim-scripts/utl.vim'

" Latex plugins
Plug 'lervag/vimtex'

" Rust plugins
Plug 'rust-lang/rust.vim'

" JS/React

call plug#end()

filetype plugin indent on

set termguicolors

if has("gui_running")
    guifont Monaco:12
endif

set background=dark
colorscheme base16-default-dark

if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

set encoding=utf8

set nobackup
set nowb
set noswapfile

set autoread

set number
set relativenumber

set ignorecase
set smartcase

set hlsearch
set incsearch
set magic

set showmatch

set noerrorbells
set novisualbell
set t_vb=
set tm=500

set autoindent
set expandtab
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4

set ruler

set wildmenu
set wildmode=longest:full,full

"set omnifunc=syntaxcomplete#Complete

if has('mouse')
	set mouse=a
endif

set laststatus=2

"nnoremap <SPACE> <Nop>
"let mapleader="\<Space>"
"
map <SPACE> <Leader>

noremap <Leader>b :Buffers<CR>
noremap <Leader>f :Files<CR>

set statusline+=%F%m%r\ 
set statusline+=%y[%{strlen(&fenc)?&fenc:'none'},
set statusline+=%{&ff}]
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%=
set statusline+=%l\:%c\ %P\ 

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

let g:racer_cmd = "racer"
let $RUST_SRC_PATH="/usr/local/src/rust"

let g:grepper = {
    \ 'tools': ['ag', 'git', 'grep'],
    \ 'open': 0,
    \ 'jump': 1,
    \ }

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 'ignorecase'
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#enable_smart_case=1

let g:deoplete#sources#rust#racer_binary='/Users/simon/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/usr/local/src/rust/src'

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
