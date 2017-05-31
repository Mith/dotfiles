set shell=bash
set nocompatible

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.config/nvim/plugged')

Plug 'chriskempson/base16-vim'
Plug 'cloudhead/neovim-fuzzy'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'easymotion/vim-easymotion'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
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

set showcmd

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
map <SPACE><SPACE> <Leader><Leader>

noremap <Leader>b :FuzzyOpen<CR>
noremap <Leader>f :FuzzyGrep<CR>

set statusline=%F%m%r\
set statusline+=%y[%{strlen(&fenc)?&fenc:'none'},
set statusline+=%{&ff}]
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%=
set statusline+=%l\:%c\ %P\

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
