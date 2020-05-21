set shell=bash
set nocompatible

function! PackagerInit() abort
    if empty(glob('~/.config/nvim/pack/packager/opt/vim-packager'))
      silent !git clone https://github.com/kristijanhusak/vim-packager ~/.config/nvim/pack/packager/opt/vim-packager
    endif

    packadd vim-packager
    call packager#init()
    call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
    call packager#add('chriskempson/base16-vim')
    call packager#add('airblade/vim-gitgutter')
    call packager#add('tpope/vim-repeat')
    call packager#add('sheerun/vim-polyglot')
    call packager#add('tpope/vim-commentary')
    call packager#add('tpope/vim-surround')
    call packager#add('mbbill/undotree')
    call packager#add('vim-scripts/nc.vim')
    call packager#add('tpope/vim-sleuth')
    call packager#add('tpope/vim-vinegar')
    call packager#add('roxma/python-support.nvim')
    call packager#add('tpope/vim-fugitive')
    call packager#add('wellle/targets.vim')
    call packager#add('justinmk/vim-sneak')
    call packager#add('calviken/vim-gdscript3')

    call packager#add('junegunn/fzf', { 'do': {-> fzf#install()} })
    call packager#add('junegunn/fzf.vim')

    call packager#add('liuchengxu/vim-clap', { 'do': ':Clap install-binary!' })

    call packager#add('neovim/nvim-lsp')
    call packager#add('haorenW1025/completion-nvim')

    " Rust plugins
    call packager#add('rust-lang/rust.vim')
endfunction

command! UpdatePackages call PackagerInit() | call packager#update()
command! InstallPackages call PackagerInit() | call packager#install()

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
packadd nvim-lsp
""" LSP
lua << EOF
    local nvim_lsp = require'nvim_lsp'

    local servers = {'rust_analyzer', 'tsserver', 'vimls', 'bashls', 'clangd'}
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {}
    end
EOF

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Remap keys for gotos
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

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

noremap <Leader>b :Clap buffers<CR>
noremap <Leader>f :Clap files<CR>
noremap <Leader>c :Clap git_diff_files<CR>
noremap <Leader>g :Clap grep<CR>
noremap <Leader>t :Clap tags<CR>

noremap <Leader><Leader> :Clap gfiles<CR>

let g:clap_insert_mode_only=v:true
let g:clap_layout = { 'relative': 'editor' }
let g:clap_prompt_format = '%provider_id%:'
