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
set scrolloff=10

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

command! ReloadConfig <cmd>so ~/.config/nvim/init.vim

nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>b <cmd>Telescope buffers<cr>
nnoremap <leader>h <cmd>Telescope help_tags<cr>

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

nnoremap <leader>dc <cmd>lua require('dap').continue()<CR>
nnoremap <leader>db <cmd>lua require('dap').toggle_breakpoint()<CR>
nnoremap <leader>do <cmd>lua require('dap').step_over()<CR>
nnoremap <leader>dh <cmd>lua require('dap').goto()<CR>
nnoremap <leader>dk <cmd>lua require('dap.ui.variables').hover()<CR>


" for nvim-compe
set completeopt=menuone,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

lua require('init')
