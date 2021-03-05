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
set statusline+=%{coc#status()}%{get(b:,'coc_current_function','')}
set statusline+=%l\:%c\ %P
set diffopt+=vertical

noremap <Leader>b :Clap buffers<CR>
noremap <Leader>f :Clap files<CR>
noremap <Leader>g :Clap grep<CR>

noremap <Leader><Leader> :Clap tags<CR>

let g:clap_insert_mode_only=v:true
let g:clap_layout = { 'relative': 'editor' }
let g:clap_prompt_format = '%provider_id%:'


" coc-nvim 
" from https://github.com/neoclide/coc.nvim#example-vim-configuration
set updatetime=300
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = { 
        "rust", 
        "c", 
        "c_sharp",
        "cpp",
        "nix",
        "python",
        "json",
        "toml",
        "lua",
        "bash"
    },
    highlight = {
        enable = true
    },
    indent = {
        enable = true;
    },
    keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
    }
}
EOF
