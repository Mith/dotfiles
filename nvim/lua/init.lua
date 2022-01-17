-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

require("which-key").setup {
    triggers = "auto",
    key_labels = { ["<leader>"] = "SPC" }
}

-- Configure treesitter before setting colorscheme
require'nvim-treesitter.configs'.setup {
    highlight = {enable = true},
    -- indent = {enable = true},
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner"
            }
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer'
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer'
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer'
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer'
            }
        }
    },
    refactor = {
        highlight_definitions = { enable = true },
    },
    matchup = {
        enable = true,
    }
}

vim.o.termguicolors = true
vim.cmd [[colorscheme nvcode]]
vim.cmd [[hi LineNr ctermbg=NONE guibg=NONE]]

-- Remap space as leader key
-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', {noremap = true, silent = true})
vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Telescope
local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
                ["<esc>"] = actions.close
            }
        }
    }
}

require('telescope').load_extension('fzf')


-- which-key-nvim
local wk = require("which-key")
-- Add leader shortcuts
wk.register({
    ['b'] = {
        [[<cmd>lua require('telescope.builtin').buffers()<CR>]], "Buffers"
    },
    ['<space>'] = {
        [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]],
        "Files"
    },
    ['h'] = {
        [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], "Help tags"
    },
    ['t'] = {
        [[<cmd>lua require('telescope.builtin').tags()<CR>]], "Tags"
    },
    ['g'] = {
        [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], "Grep"
    },
    ['o'] = {
        [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], "Old files"
    },
    ['c'] = {
        [[<cmd>lua require('telescope.builtin').commands()<CR>]], "Commands"
    }
}, {prefix='<leader>', noremap = true, silent = true})

-- LSP settings
local lspconfig = require 'lspconfig'

local custom_init = function(client)
  client.config.flags = client.config.flags or {}
  client.config.flags.allow_incremental_sync = true
end

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
    local opts = {buffer = bufnr}
    local wk = require("which-key")
    wk.register({
        ['gD'] = {'<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to declaration'},
        ['gd'] = {'<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to definition'},
        ['K'] = {'<cmd>lua vim.lsp.buf.hover()<CR>'},
        ['gi'] = {
            '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Go to implementation'
        },
        ['<C-k>'] = {'<cmd>lua vim.lsp.buf.signature_help()<CR>'},
        ['<leader>D'] = {
            '<cmd>lua vim.lsp.buf.type_definition()<CR>',
            'Go to type definition'
        },
        ['<leader>rn'] = {'<cmd>lua vim.lsp.buf.rename()<CR>'},
        ['gr'] = {'<cmd>lua vim.lsp.buf.references()<CR>'},
        ['<leader>ca'] = {'<cmd>lua vim.lsp.buf.code_action()<CR>'},
        ['<leader>dp'] = {'<cmd>lua vim.diagnostic.goto_prev()<CR>'},
        ['<leader>dn'] = {'<cmd>lua vim.diagnostic.goto_next()<CR>'},
        ['<leader>s'] = {[[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]]},
        ['<leader>S'] = {[[<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>]]},
    }, opts)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
local servers = {
    'clangd', 'pyright', 'vimls', 'bashls', 'rnix', 'gdscript'
}
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {on_init = custom_init, on_attach = on_attach, capabilities = capabilities}
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
    snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
    mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        ["<c-y>"] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            },
            { "i", "c" }
            ),

        ["<c-space>"] = cmp.mapping {
            i = cmp.mapping.complete(),
            c = function(
                    _ --[[fallback]]
                    )
                if cmp.visible() then
                    if not cmp.confirm { select = true } then
                        return
                    end
                else
                    cmp.complete()
                end
            end,
        },
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end
    },
    sources = {
        {name = 'nvim_lua'},
        {name = 'nvim_lsp'},
        {name = 'luasnip'},
        {name = 'path'},
        {name = 'buffer'}
    },
    experimental = {
        native_menu = false,
        ghost_text = true
    }
}

cmp.setup.cmdline(':', {
    sources = {
        { name = 'cmdline' }
    }
})

cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Plugin setup
require('nvim-web-devicons').setup {}
require('rust-tools').setup {
    server = {
        on_init = custom_init,
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 50,
        }
    }
}

require('Comment').setup()

-- Neovide configuration
vim.o.guifont = "FiraCode Nerd Font:h10"
vim.g.neovide_cursor_animation_length=0.03
vim.g.neovide_cursor_vfx_mode = "wireframe"
vim.g.neovide_floating_blur = false

--Autopairs setup
require('nvim-autopairs').setup{}
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))

-- Lualine
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = nil, right = nil},
        section_separators = { left = nil, right = nil},
    },
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'diagnostics'},
        lualine_y = {'progress', 'location'},
        lualine_z = {}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'diagnostics'},
        lualine_y = {'progress', 'location'},
        lualine_z = {}
    },
}
