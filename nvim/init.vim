set number                      " show line numbers
set relativenumber              " show relative line numbers
set cursorline                  " highlight the current line
set scrolloff=3                 " keep 3 lines visible above/below cursor
set tabstop=4                   " tab width
set softtabstop=2               " tab width for spaces
set shiftwidth=4                " indent width
set expandtab                   " use spaces instead of tabs
set smartindent                 " enable smart indentation
set autoindent                  " enable auto-indentation
set wrap                        " wrap long lines
set linebreak                   " break lines at word boundaries
set noswapfile                  " disable swap files
set clipboard=unnamedplus       " use system clipboard
set termguicolors               " enable 24-bit rgb colors
set laststatus=3                " modern status line
set signcolumn=yes              " always show sign column

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldenable
set foldlevel=99
set pumheight=10
set mouse=a
set redrawtime=3500

set ignorecase
set smartcase

" Additional settings for responsiveness
set timeoutlen=300              " Faster key timeout (in ms)
set ttimeoutlen=10              " Reduce terminal input delay (in ms)

set titlelen=0
" Font Settings (for GUI, e.g., Neovide)
set guifont=Hack\ Nerd\ Font:h13

" Automatically make buffers modifiable
autocmd BufEnter * setlocal modifiable

" Disable unused providers to improve performance
let g:loaded_python_provider = 0
let g:loaded_python3_provider = 0
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

" Leader Key
let mapleader = " "

" -------------------------------
" Plugin Manager
" -------------------------------
call plug#begin('~/.vim/plugged')

Plug 'rebelot/kanagawa.nvim'

Plug 'kdheepak/lazygit.nvim'
" File Explorer
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'

" Telescope (Fuzzy Finder)
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Bookmark and Harpoon Plugins
Plug 'ThePrimeagen/harpoon'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'tom-anders/telescope-vim-bookmarks.nvim'

" LSP and Dependencies
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" Breadcrumbs
Plug 'SmiteshP/nvim-navic'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-telescope/telescope-file-browser.nvim'
" Comments
Plug 'tpope/vim-commentary'

" Status Line
Plug 'nvim-lualine/lualine.nvim'

" Indentation Guides
Plug 'lukas-reineke/indent-blankline.nvim'

" Auto Pairs
Plug 'windwp/nvim-autopairs'

" Refactoring Support
Plug 'ThePrimeagen/refactoring.nvim'

" Formatting
Plug 'sbdchd/neoformat'

" Git integration
Plug 'lewis6991/gitsigns.nvim'
Plug 'f-person/git-blame.nvim'

Plug 'ellisonleao/gruvbox.nvim'

" --- DAP PLUGINS ---
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'         " Optional: For a better UI experience
Plug 'leoluz/nvim-dap-go'          " For Go-specific DAP configurations
Plug 'theHamsta/nvim-dap-virtual-text' " Optional: Shows debug info inline
Plug 'nvim-neotest/nvim-nio'       " Dependency for nvim-dap-ui

Plug 'mbbill/undotree'

call plug#end()

" -------------------------------
" Colorscheme Settings
" -------------------------------
lua << EOF
require("kanagawa").setup({
  compile        = false,           -- enable compiling the colorscheme
  undercurl      = true,            -- enable undercurls
  commentStyle   = { italic = true },
  functionStyle  = {},
  keywordStyle   = { italic = true },
  statementStyle = { bold   = true },
  typeStyle      = {},
  transparent    = false,           -- do not set background color
  dimInactive    = false,           -- dim inactive window `:h hl-NormalNC`
  terminalColors = true,            -- define vim.g.terminal_color_{0,17}
  colors = {
    palette = {},
    theme   = { wave = {}, lotus = {}, dragon = {}, all = {} },
  },
  overrides = function(colors)       -- add/modify highlights
    return {}
  end,
  theme        = "wave",            -- Load "wave" theme
  background = { dark = "wave", light = "lotus" },  
})
-- apply it
vim.cmd("colorscheme kanagawa")
EOF
" -------------------------------
" Key Mappings
" -------------------------------

nnoremap <leader>sv :source $MYVIMRC<CR>
" Clear search highlights
nnoremap <leader>h :nohlsearch<CR>

lua << EOF
-- NvimTree Configuration
require("nvim-tree").setup({
  view = {
    adaptive_size = true,
    side = "right",
    width = 40,
    mappings = { -- If this still causes issues, ensure nvim-tree.lua is fully updated (:PlugUpdate nvim-tree.lua)
      list = {
        { key = "<C-n>", action = "close" }, -- This specific key is also used globally below, which is fine.
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
})

-- Toggle NvimTree and focus current file
local function toggle_nvim_tree()
  local nvim_tree = require("nvim-tree.api")
  local current_buf = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buf)

  if current_file ~= "" then
    nvim_tree.tree.toggle({
      path = current_file,
      find_file = true,
      focus = true,
    })
  else
    nvim_tree.tree.toggle()
  end
end

vim.keymap.set("n", "<C-n>", toggle_nvim_tree, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>n", toggle_nvim_tree, { noremap = true, silent = true, desc = "Toggle file explorer" })
EOF
" Telescope Keymaps
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>

" Manage Bookmarks via Telescope
nnoremap <leader>bb :Telescope vim_bookmarks all<CR>
nnoremap <leader>ba :BookmarkToggle<CR>
nnoremap <leader>bc :BookmarkClearAll<CR>

" Manage Harpoon via Telescope
lua << EOF
require('telescope').load_extension('harpoon')
EOF
nnoremap <leader>bh :Telescope harpoon marks<CR>
nnoremap <leader>ha :lua require('harpoon.mark').add_file()<CR>
nnoremap <leader>hc :lua require('harpoon.mark').clear_all()<CR>

" LSP Keymaps Go
nnoremap <leader>ds <cmd>Telescope lsp_document_symbols<CR>
nnoremap <leader>ws <cmd>Telescope lsp_workspace_symbols<CR>

" Folding Keymaps
nnoremap <leader>za za
nnoremap <leader>zr zR
nnoremap <leader>zm zM
nnoremap <leader>zo zo
nnoremap <leader>zc zc

" Toggle comment
nnoremap <leader>/ :Commentary<CR>
vnoremap <leader>/ :Commentary<CR>

" -------------------------------
" Plugin Configuration
" -------------------------------

" Telescope Configuration
lua << EOF
local telescope = require('telescope')

telescope.setup {
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = { preview_width = 0.6 },
    },
    sorting_strategy = "ascending",
    prompt_prefix = "    ",
    entry_maker = function(entry)
      -- Remove leading whitespace for grep
      entry.value = entry.value:gsub("^%s+", "")
      entry.display = entry.value
      entry.ordinal = entry.value
      return entry
    end,
  },
  extensions = {
    vim_bookmarks = {
      hide_filename = false,
      only_selected_bookmarks = true,
      layout_strategy = "horizontal",
      layout_config = {
        width = 0.9,
        preview_width = 0.6,
      },
      entry_maker = function(entry)
        -- Remove indentation for bookmark previews
        entry.value = entry.value:gsub("^%s+", "")
        entry.display = entry.value
        entry.ordinal = entry.value
        return entry
      end,
    },
  },
}

telescope.load_extension('vim_bookmarks')
EOF


" Treesitter Configuration
lua << EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = { "go", "gomod", "html", "css", "javascript", "php", "lua", "vim", "vimdoc" }, -- CORRECTED: "gopls", "delve" removed. Added common ones like lua, vim.
  highlight = { enable = true },
  indent = { enable = true },
  -- incremental_selection = { enable = true }, -- Optional: useful feature
  -- textobjects = { enable = true }, -- Optional: useful feature
}
EOF

" Breadcrumbs Configuration
lua << EOF
local navic = require('nvim-navic')
-- This on_attach function should be passed to your LSP server setups (e.g., gopls)
local on_attach_navic = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

-- Example for generic LSP setup if you had one, or specifically for each server
-- For your gopls setup later, you'll add `on_attach = on_attach_navic` or combine it.
-- require('lspconfig').ts_ls.setup { -- You may or may not use ts_ls, this is an example
--   on_attach = on_attach_navic
-- }
EOF

" Lualine Configuration
lua << EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'kanagawa',
    component_separators = { left = '|', right = '|' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      'filename',
      {
        require('nvim-navic').get_location,
        cond = function()
          return require('nvim-navic').is_available()
        end
      }
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}
EOF

" Indentation Guides (ibl plugin)
lua << EOF
require("ibl").setup({
  indent = { char = '|' }, -- You can also use '▏' or '▎' or '▍' or '▌' or '▋' or '▊' or '▉' or '█'
  whitespace = { remove_blankline_trail = false },
  scope = {
    show_start = true,
    show_end   = true,
  },
})
EOF

" Auto Pairs
lua << EOF
require('nvim-autopairs').setup{}
EOF

" Standard LSP Completion Configuration (without AI code completion)
lua << EOF
local cmp = require('cmp')

cmp.setup {
  mapping = cmp.mapping.preset.insert({
    ['<C-j>'] = cmp.mapping.select_next_item(),  -- next item
    ['<C-k>'] = cmp.mapping.select_prev_item(),  -- previous item
    ['<CR>']  = cmp.mapping.confirm({ select = true }), -- confirm selection
    ['<Esc>'] = cmp.mapping.close(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(), -- manual completion (was C-b, C-Space is more common)
    ['<C-e>'] = cmp.mapping.abort(),    -- abort completion
    -- Tab completion, if you like it
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
    -- ['<S-Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   else
    --     fallback()
    --   end
    -- end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  -- Removed deprecated completion option:
  -- completion = {
  --   completeopt = 'menu,menuone,noinsert',
  -- },
  window = {
    documentation = cmp.config.window.bordered(),
    completion = cmp.config.window.bordered(),
  },
  experimental = {
    ghost_text = true, -- Optional: shows inline virtual text for completion candidate
  }
}
EOF

" Mason for LSP servers
lua << EOF
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "delve"
    -- Add other LSPs/tools here e.g. "lua_ls", "rust_analyzer", "pyright"
  }
})

-- LSP for Go (and other languages)
local lspconfig = require('lspconfig')
local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Common on_attach function for LSPs
local on_attach_common = function(client, bufnr)
  -- Standard LSP keymaps
  local buf_map = function(mode, lhs, rhs, desc)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    if desc then opts.desc = desc end
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  buf_map('n', 'K',        vim.lsp.buf.hover, 'LSP: Hover Documentation')
  buf_map('n', '<leader>rn', vim.lsp.buf.rename, 'LSP: Rename')
  buf_map('n', '<leader>ca', vim.lsp.buf.code_action, 'LSP: Code Action')
  buf_map('n', '[d',       vim.diagnostic.goto_prev, 'LSP: Previous Diagnostic')
  buf_map('n', ']d',       vim.diagnostic.goto_next, 'LSP: Next Diagnostic')
  buf_map('n', '<leader>dl', vim.diagnostic.open_float, 'LSP: Show Line Diagnostics')
  buf_map('n', '<leader>q',  vim.diagnostic.setloclist, 'LSP: Quickfix Diagnostics List')

  -- Navic (breadcrumbs) attachment
  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, bufnr)
  end
end

lspconfig.gopls.setup {
  capabilities = cmp_capabilities,
  on_attach = on_attach_common, -- Use the common on_attach
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      usePlaceholders = true,     -- if true, snippet support is needed (e.g. luasnip)
      -- completionDocumentation = true, -- This option might be deprecated or part of capabilities
    },
  },
}

-- Add setups for other LSPs here using on_attach_common
-- Example for lua-language-server (if you installed it via Mason)
-- lspconfig.lua_ls.setup {
--   capabilities = cmp_capabilities,
--   on_attach = on_attach_common,
--   settings = {
--     Lua = {
--       diagnostics = { globals = {'vim'} }
--     }
--   }
-- }
EOF

" --- Telescope LSP mappings ---
lua << EOF
local telescope_builtin = require('telescope.builtin')
local common_opts_telescope_lsp = { -- Renamed to avoid conflict if _G.common_opts is used elsewhere
  -- layout_strategy = "vertical", -- Keep this if you prefer, or remove for default
  -- layout_config = { width = 0.8, height = 0.9, preview_height = 0.6 },
  -- initial_mode = "normal", -- these are good, but for brevity keeping them default unless specified
  -- prompt_title = false,
  -- results_title = false,
  -- path_display = { "smart" },
  -- sorting_strategy = "ascending",
  -- prompt_prefix = "  ",
}

vim.keymap.set('n', 'gd', function() telescope_builtin.lsp_definitions(common_opts_telescope_lsp) end, { desc = "LSP: Go to Definition" })
vim.keymap.set('n', 'gi', function() telescope_builtin.lsp_implementations(common_opts_telescope_lsp) end, { desc = "LSP: Go to Implementation" })
vim.keymap.set('n', 'gD', function() telescope_builtin.lsp_declarations(common_opts_telescope_lsp) end, { desc = "LSP: Go to Declaration" })
vim.keymap.set('n', 'gr', function() telescope_builtin.lsp_references(common_opts_telescope_lsp) end, { desc = "LSP: Find References" })
vim.keymap.set('n', '<leader>D', function() telescope_builtin.lsp_type_definitions(common_opts_telescope_lsp) end, { desc = "LSP: Go to Type Definition" })
EOF


lua << EOF
function _G.search_todos()
  require('telescope.builtin').grep_string({
    search = "TODO\\|FIXME\\|HACK", -- Search for TODO, FIXME, or HACK
    use_regex = true, -- Interpret search string as a regex
    prompt_title = "Project TODOs/FIXMEs/HACKs",
    -- initial_mode = "normal", -- default is insert

    layout_strategy = "vertical",
    layout_config = {
      height = 0.9,
      width = 0.8,
      preview_height = 0.6,
    },
    path_display = {"smart"},
    -- results_title = "Project TODOs", -- Handled by prompt_title more or less
  })
end

vim.keymap.set('n', '<leader>td', _G.search_todos, { desc = "Search TODOs/FIXMEs" })
EOF
"Refactoring Plugin
lua << EOF
require('refactoring').setup({})
-- You might want to add keymaps for refactoring actions here
-- e.g., vim.keymap.set("v", "<leader>re", function() require("refactoring").select_refactor() end, { desc = "Refactor selected" })
EOF

" Gitsigns Configuration
lua << EOF
require('gitsigns').setup {
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
  },
  current_line_blame = false, -- set to true to show inline blame
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, lhs, rhs, opts_or_desc)
      local opts = vim.tbl_islist(opts_or_desc) and opts_or_desc[1] or opts_or_desc or {}
      if vim.tbl_islist(opts_or_desc) and opts_or_desc[2] then opts.desc = opts_or_desc[2] end
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "Git: Next Hunk" })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, desc = "Git: Previous Hunk" })

    -- Actions
    map({'n', 'v'}, '<leader>hs', gs.stage_hunk, "Git: Stage Hunk")
    map({'n', 'v'}, '<leader>hr', gs.reset_hunk, "Git: Reset Hunk")
    map('n', '<leader>hS', gs.stage_buffer, "Git: Stage Buffer")
    map('n', '<leader>hu', gs.undo_stage_hunk, "Git: Undo Stage Hunk")
    map('n', '<leader>hR', gs.reset_buffer, "Git: Reset Buffer")
    map('n', '<leader>hp', gs.preview_hunk, "Git: Preview Hunk")
    map('n', '<leader>hb', function() gs.blame_line { full = true } end, "Git: Blame Line")
    map('n', '<leader>tb', gs.toggle_current_line_blame, "Git: Toggle Current Line Blame")
    map('n', '<leader>hd', gs.diffthis, "Git: Diff This")
    map('n', '<leader>hD', function() gs.diffthis('~') end, "Git: Diff This ~")
    map('n', '<leader>td', gs.toggle_deleted, "Git: Toggle Deleted Hunks")

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', "Git: Select Hunk (text object)")
  end,
}
-- No need to manually link Gitsigns highlights if your colorscheme supports them or if defaults are fine
EOF

" Git Blame Plugin Configuration
let g:gitblame_enabled = 0 " Start disabled (1 to enable by default)
nnoremap <leader>gb :GitBlameToggle<CR>

" grep but with the selected text
lua << EOF
function _G.get_visual_selection()
  local saved_reg = vim.fn.getreg('"')
  local saved_type = vim.fn.getregtype('"')
  vim.cmd('normal! ""y')
  local selection = vim.fn.getreg('"')
  vim.fn.setreg('"', saved_reg, saved_type)
  selection = string.gsub(selection, "\n", " ")
  return selection
end
EOF
xnoremap <leader>fg :<C-u>lua require('telescope.builtin').live_grep({ default_text = _G.get_visual_selection() })<CR>

" DAP (Debug Adapter Protocol) Configuration
lua << EOF
local dap = require('dap')
local dapui = require('dapui')
local dapgo = require('dap-go')
local dap_virtual_text = require('nvim-dap-virtual-text')

dapgo.setup()

dapui.setup({
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.33 },
        { id = "breakpoints", size = 0.17 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 0.3,
      position = "bottom",
    },
    {
      elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 }, },
      size = 0.25,
      position = "right",
    }
  },
  floating = {
    max_height = nil, max_width = nil, border = "rounded",
    mappings = { close = { "q", "<Esc>" }, },
  },
  windows = { indent = 1 },
  render = { max_type_length = nil, max_value_lines = 100, },
})

dap_virtual_text.setup() -- Defaults are usually fine

dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set("n", "<Leader>dB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = "DAP: Set Conditional Breakpoint" })
vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "DAP: Continue" })
vim.keymap.set("n", "<Leader>dj", dap.step_into, { desc = "DAP: Step Into" })
vim.keymap.set("n", "<Leader>dk", dap.step_over, { desc = "DAP: Step Over" })
vim.keymap.set("n", "<Leader>do", dap.step_out, { desc = "DAP: Step Out" })
vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
vim.keymap.set("n", "<Leader>dl", dap.run_last, { desc = "DAP: Run Last" })
vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "DAP: Terminate" })
vim.keymap.set("n", "<Leader>dC", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })

vim.keymap.set("n", "<Leader>dui", dapui.toggle, { desc = "DAP: Toggle UI" })
vim.keymap.set("n", "<Leader>due", function() dapui.eval(nil, { enter = true }) end, { desc = "DAP: Evaluate Expression (visual)" })
vim.keymap.set("n", "<Leader>d?", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.scopes)
end, { desc = "DAP: View Scopes (float)" })
EOF

" Disable arrow keys and display message
nnoremap <Up>     :echo "Use 'k' instead!"<CR>
nnoremap <Down>   :echo "Use 'j' instead!"<CR>
nnoremap <Left>   :echo "Use 'h' instead!"<CR>
nnoremap <Right>  :echo "Use 'l' instead!"<CR>

inoremap <Up>     <Esc>:echo "Use 'k' instead!"<CR>a
inoremap <Down>   <Esc>:echo "Use 'j' instead!"<CR>a
inoremap <Left>   <Esc>:echo "Use 'h' instead!"<CR>a
inoremap <Right>  <Esc>:echo "Use 'l' instead!"<CR>a

vnoremap <Up>     :<C-u>echo "Use 'k' instead!"<CR>
vnoremap <Down>   :<C-u>echo "Use 'j' instead!"<CR>
vnoremap <Left>   :<C-u>echo "Use 'h' instead!"<CR>
vnoremap <Right>  :<C-u>echo "Use 'l' instead!"<CR>

" Paste over selection without copying replaced text
xnoremap p "_dP
nnoremap <leader>lg :LazyGit<CR>

" Disable most mouse interactions if you prefer keyboard-only
" set mouse= " Uncomment to completely disable mouse
" If you keep mouse=a but want to disable specific clicks:
" noremap <LeftMouse> <Nop>
" noremap <RightMouse> <Nop>
" noremap <MiddleMouse> <Nop>
" noremap <2-LeftMouse> <Nop>
" noremap <LeftDrag> <Nop>
