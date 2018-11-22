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
Plug 'junegunn/fzf'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-repeat'
Plug 'w0rp/ale'

Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mbbill/undotree'
Plug 'Chiel92/vim-autoformat'
Plug 'vim-scripts/nc.vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'
Plug 'Shougo/echodoc.vim'
Plug 'roxma/python-support.nvim'
Plug 'tpope/vim-fugitive'

" language server protocol framework
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" vimscript
Plug 'Shougo/neco-vim'

" Rust plugins
Plug 'rust-lang/rust.vim'

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
set noshowmode

set autoread

set number
set relativenumber

set ignorecase
set smartcase

set hlsearch
set incsearch
set magic
set inccommand=nosplit

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

" for python completions
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'jedi')
" language specific completions on markdown file
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'mistune')

" utils, optional
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'psutil')
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'setproctitle')

set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'typescript': ['javascript-typescript-stdio'],
    \ 'typescript.tsx': ['tcp://127.0.0.1:2089'],
    \ }

let g:deoplete#enable_at_startup = 1

let g:ale_fixers = {
            \ 'typescript': ['tslint', 'prettier', 'eslint',
            \                'remove_trailing_lines', 
            \                'trim_whitespace'
            \               ],
            \ 'javascript': ['prettier', 'eslint'],
            \ 'python': ['black'],
            \ 'html': ['tidy', 
            \          'remove_trailing_lines',
            \          'trim_whitespace'
            \         ]
            \}

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

set diffopt+=vertical
