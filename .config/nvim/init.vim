set shell=bash
set nocompatible

" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.config/nvim/plugged')

Plug 'chriskempson/base16-vim'
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

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

Plug 'Shougo/denite.nvim'


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

if has('mouse')
    set mouse=a
endif

set laststatus=2

map <SPACE> <Leader>
map <SPACE><SPACE> <Leader><Leader>

noremap <Leader>b :Denite buffer<CR>
noremap <Leader>f :Denite file/rec<CR>

set statusline=%f%m%r\
set statusline+=%y[%{strlen(&fenc)?&fenc:'none'},
set statusline+=%{&ff}]
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%=
set statusline+=%l\:%c\ %P\

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" for python completions
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'jedi')
" language specific completions on markdown file
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'mistune')

" utils, optional
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'psutil')
let g:python_support_python3_requirements = add(get(g:,'python_support_python3_requirements',[]),'setproctitle')

set hidden

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

call denite#custom#var('file/rec', 'command',
\ ['rg', '--files', '--glob', '!.git'])

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

set diffopt+=vertical
