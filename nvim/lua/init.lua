-- require'nvim-treesitter.configs'.setup {
--     ensure_installed = "maintained",
--     highlight = {
--         enable = true
--     },
--     indent = {
--         enable = true;
--     },
--     keymaps = {
--         -- You can use the capture groups defined in textobjects.scm
--         ["af"] = "@function.outer",
--         ["if"] = "@function.inner",
--         ["ac"] = "@class.outer",
--         ["ic"] = "@class.inner",
--     }
-- }

local dap = require('dap')
dap.adapters.rust = {
    type = 'executable',
    attach = {
        pidProperty = "pid",
        pidSelect = "ask"
    },
    command = 'lldb-vscode',
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
    },
    name = "lldb"
}

dap.configurations.rust = {
    {
        type = 'rust';
        request = 'launch';
        name = "Launch file";
        cwd = '${workspaceFolder}';
        program = '${workspaceFolder}/target/debug/kloonorio';
        env = {
            CARGO_MANIFEST_DIR = '${workspaceFolder}';
        }
    },
}

vim.cmd [[
    command! -complete=file -nargs=* DebugC lua require "my_debug".start_c_debugger({<f-args>}, "gdb")
]]
vim.cmd [[
    command! -complete=file -nargs=* DebugRust lua require "my_debug".start_c_debugger({<f-args>}, "gdb", "rust-gdb")
]]

local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>a', '<cmd>Telescope lsp_code_actions<CR>', opts)
  buf_set_keymap('n', '<leader>r', '<cmd>Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', '<leader>s', '<cmd>Telescope lsp_workspace_symbols<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#282828
      hi LspReferenceText cterm=bold ctermbg=red guibg=#282828
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#282828
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local lspconfigs = require('lspconfig/configs')
if not lspconfig.rnix_lsp then
    lspconfigs.rnix_lsp = {
        default_config = {
            cmd = { "rnix-lsp" },
            root_dir= function() vim.fn.getcwd() end;
            filetypes = { "nix" },
        }
    };
end

-- Use a loop to conveniently both setup defined servers 
-- and map buffer local keybindings when the language server attaches
local servers = { "rust_analyzer", "rnix_lsp" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { on_attach = on_attach }
end

lspconfig["clangd"].setup { 
    on_attach = on_attach,
    cmd = { "clangd", "--background-index", "--compile-commands-dir=build" }
}

local actions = require('telescope.actions')
require('telescope').setup{
    defaults = {
        layout_strategy = 'flex';
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            }
        }
    }
}
require('telescope').load_extension('fzy_native')
require('telescope').load_extension('frecency')

require'compe'.setup {
  enabled = true;
  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
    nvim_lua = true;
    nvim_treesitter = true;
  };
}

require('nvim-web-devicons').setup{}

local lualine = require('lualine')
lualine.options = {
    theme = 'seoul256',
    section_separators = nil,
    component_separators = nil,
    icons_enabled = true,
}
lualine.sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 
        { 'diagnostics', 
          sources = { 'nvim_lsp' }, 
        }, 
        'encoding', 
        { 'fileformat', icons_enabled = false },
        'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location'  },
}
lualine.inactive_sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { 'filename' },
    lualine_x = { 
        { 'diagnostics', 
          sources = { 'nvim_lsp' }, 
        }, 
        'encoding', 
        { 'fileformat', icons_enabled = false },
        'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location'  },
}
lualine.status()

require('neuron').setup {
    neuron_dir = "~/notes",
}
