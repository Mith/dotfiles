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
Plug 'wellle/targets.vim'
Plug 'justinmk/vim-sneak'

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
set wildmode=full

if has('mouse')
    set mouse=a
endif

set laststatus=2

set diffopt+=vertical

map <SPACE> <Leader>
map <SPACE><SPACE> <Leader><Leader>

set statusline=%f\ %m%r%y
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%=
set statusline+=%l\:%c\ %P

set diffopt+=vertical

""" LSP
lua << EOF
    local nvim_lsp = require'nvim_lsp'

    nvim_lsp.pyls.setup{}
    nvim_lsp.clangd.setup{}
    nvim_lsp.bashls.setup{}
    nvim_lsp.tsserver.setup{}
    nvim_lsp.vimls.setup{}
    nvim_lsp.rust_analyzer.setup{}
EOF

autocmd Filetype python,c,cpp,cs,sh,javascript,typescript,vim,rust setl omnifunc=v:lua.vim.lsp.omnifunc

" Remap keys for gotos
nnoremap <silent> gd <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <Leader>h <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <Leader>td <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <Leader>r <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <Leader>d <cmd>lua vim.lsp.buf.peek_definition()<CR>

" FZF
let $FZF_DEFAULT_OPTS='--layout=reverse  --margin=1,2'
let $FZF_FIND_FILE_COMMAND='fd --type f . \$dir'
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
noremap <Leader>f :Files<CR>
noremap <Leader>c :GFiles?<CR>
noremap <Leader>g :Rg<CR>

noremap <Leader><Leader> :GFiles<CR>

au TermOpen * setlocal nonumber norelativenumber
