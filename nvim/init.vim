" Disable modeline
set nomodeline
set hidden

set termguicolors

set background=dark
colorscheme base16-default-dark

set nobackup
set nowritebackup
set noswapfile

set showcmd
set noshowmode

set autoread

set number
set relativenumber

" Disable linenumbers for terminal buffers
au TermOpen * setlocal nonumber norelativenumber signcolumn=no

set signcolumn=number
 

set ignorecase
set smartcase

set incsearch
set magic
set inccommand=nosplit

set showmatch

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

map <SPACE> <Leader>
map <SPACE><SPACE> <Leader><Leader>

set statusline=%f\ %m%r%y
set statusline+=%#warningmsg#
set statusline+=%*
set statusline+=%=
set statusline+=%l\:%c\ %P

command! ReloadConfig so ~/.config/nvim/init.vim

nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>

" For completion-nvim
" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

lua require('init')
