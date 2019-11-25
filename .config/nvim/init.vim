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
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mbbill/undotree'
Plug 'vim-scripts/nc.vim'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-vinegar'
Plug 'roxma/python-support.nvim'
Plug 'tpope/vim-fugitive'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

Plug 'neovim/nvim-lsp'

" Rust plugins
Plug 'rust-lang/rust.vim'

call plug#end()

filetype plugin indent on

" Disable modeline
set nomodeline
set hidden

set termguicolors

if has("gui_running")
    guifont Monaco:12
endif

set background=dark
colorscheme base16-default-dark

set encoding=utf8

set nobackup
set nowritebackup
set noswapfile

set showcmd
set noshowmode

set autoread

set number
set relativenumber

" Disable linenumbers for terminal buffers
au TermOpen * setlocal nonumber norelativenumber

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

set breakindent

set ruler

set completeopt-=preview

set wildmenu
set wildmode=longest:full,full

if has('mouse')
    set mouse=a
endif

set laststatus=2

set diffopt+=vertical

map <SPACE> <Leader>
map <SPACE><SPACE> <Leader><Leader>

set statusline=%f%m%r\
set statusline+=%y[%{strlen(&fenc)?&fenc:'none'},
set statusline+=%{&ff}]
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%=
set statusline+=%l\:%c\ %P\

set diffopt+=vertical

""" LSP
call nvim_lsp#setup("pyls", {})
call nvim_lsp#setup("clangd", {})
call nvim_lsp#setup("bashls", {})
call nvim_lsp#setup("tsserver", {})

autocmd Filetype python,c,cpp,sh,javascript,typescript setl omnifunc=lsp#omnifunc

" Remap keys for gotos
nnoremap <silent> gd :call lsp#text_document_definition()<CR>
nnoremap <silent> gy :call lsp#text_document_type_definition()<CR>
nnoremap <silent> gi :call lsp#text_document_implementation()<CR>
nnoremap <silent> gr :call lsp#text_document_references()<CR>

" FZF
let $FZF_DEFAULT_OPTS='--layout=reverse  --margin=1,2'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }

function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(20)
  let width = float2nr(80)
  let horizontal = float2nr((&columns - width) / 2)
  let vertical = 5

  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal'
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

let g:fzf_buffers_jump = 1

noremap <Leader>b :Buffers<CR>
noremap <Leader>f :GFiles<CR>
noremap <Leader>c :GFiles?<CR>
noremap <Leader>g :Rg<CR>

au TermOpen * setlocal nonumber norelativenumber
