set number                " show line numbers
set relativenumber        " show relative line numbers
set cursorline            " highlight the current line
set scrolloff=3           " keep 3 lines visible above/below cursor
set tabstop=4             " tab width
set softtabstop=2         " tab width for spaces
set shiftwidth=4          " indent width
set expandtab             " use spaces instead of tabs
set smartindent           " enable smart indentation
set autoindent            " enable auto-indentation
set wrap                  " wrap long lines
set linebreak             " break lines at word boundaries
set noswapfile            " disable swap files
set clipboard=unnamedplus " use system clipboard
set termguicolors         " enable 24-bit rgb colors
set laststatus=3          " modern status line
set signcolumn=yes        " always show sign column

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldenable
set foldlevel=99
set pumheight=10
" set mouse=a
set mouse=a
set redrawtime=3500

set ignorecase
set smartcase

" Additional settings for responsiveness
set timeoutlen=300      " Faster key timeout (in ms)
set ttimeoutlen=10      " Reduce terminal input delay (in ms)
" nvim 11 stuffo
"
:set cmdheight=0
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

Plug 'ellisonleao/gruvbox.nvim'

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

call plug#end()

" -------------------------------
" Colorscheme Settings
" -------------------------------
" colorscheme ayu
"set background=dark
"-- Set the background to dark for the Gruvbox color scheme
lua << EOF
vim.o.background = "dark"

require("gruvbox").setup({
  contrast = "hard",
  transparent_mode = false,
  italic = {
    strings = false,
    comments = true,
    folds = true,
    operators = false,
  },
  overrides = {},
  dim_inactive = false,
})

vim.cmd("colorscheme gruvbox")
EOF
" -- Apply the Gruvbox colorscheme

" -------------------------------
" Key Mappings
" -------------------------------

nnoremap <leader>sv :source $MYVIMRC<CR>
" Clear search highlights
nnoremap <leader>h :nohlsearch<CR>

" File Explorer
" nnoremap <leader>n :NvimTreeFindFileToggle<CR>

lua << EOF
require("telescope").load_extension("file_browser")

vim.keymap.set("n", "<leader>n", function()
  local cwd = vim.fn.expand("%:p:h") -- current file's folder

  require("telescope").extensions.file_browser.file_browser({
    cwd = cwd,
    path = cwd,
    hidden = true,
    grouped = true,
    select_buffer = true,
    initial_mode = "normal",
    previewer = false,
    prompt_title = false,
    results_title = false,
    layout_strategy = "center",
    layout_config = {
      height = 0.85,
      width = 0.5,
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    display_stat = false,  -- ⬅️ removes permissions/sizes/modified time
  })
end, { desc = "Minimal File Browser (relative to current file)" })
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
    prompt_prefix = "   ",
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
  ensure_installed = { "go", "gomod", "html", "css", "javascript", "php" },
  highlight = { enable = true },
  indent = { enable = true },
}
EOF

" Breadcrumbs Configuration
lua << EOF
local navic = require('nvim-navic')
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

require('lspconfig').ts_ls.setup {
  on_attach = on_attach
}

vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
EOF

" Lualine Configuration
lua << EOF
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'tokyonight',
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
        cond = require('nvim-navic').is_available
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
  indent = { char = '|' },
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
  mapping = {
    ['<C-j>'] = cmp.mapping.select_next_item(),  -- next item
    ['<C-k>'] = cmp.mapping.select_prev_item(),  -- previous item
    ['<CR>']  = cmp.mapping.confirm({ select = true }), -- confirm selection
    ['<Esc>'] = cmp.mapping.close(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-b>'] = cmp.mapping.complete(), -- manual completion
    ['<C-e>'] = cmp.mapping.abort(),    -- abort completion
    ['<Up>']   = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' },
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  window = {
    documentation = cmp.config.window.bordered(),
    completion = cmp.config.window.bordered(),
  },
}
EOF

" Mason for LSP servers
lua << EOF
require("mason").setup()
require("mason-lspconfig").setup()

-- LSP for Go
local lspconfig = require('lspconfig')

lspconfig.gopls.setup {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    -- You can still use other LSP features like hover, rename, etc.
    local buf_map = function(mode, lhs, rhs)
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, { noremap=true, silent=true })
    end

    buf_map('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>')
    buf_map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    buf_map('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    buf_map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
    buf_map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  end,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      usePlaceholders = true,
      completionDocumentation = true,
    },
  },
}
EOF

" --- Telescope LSP mappings ---
lua << EOF
-- Enhanced, readonly-style Telescope UI for LSP

local layout_config = {
  width = 0.8,
  height = 0.9,
  preview_height = 0.6,
}

local common_opts = {
  initial_mode = "normal",                 -- ⬅ start in normal mode (no editing)
  prompt_title = false,                    -- ⬅ hide prompt title
  results_title = false,                   -- ⬅ hide results title (clean look)
  layout_strategy = "vertical",
  layout_config = layout_config,
  path_display = { "smart" },
  sorting_strategy = "ascending",          -- ⬅ place matches at top
  prompt_prefix = "  ",                    -- ⬅ make prompt invisible-ish
}

function _G.goto_definition()
  require('telescope.builtin').lsp_definitions(common_opts)
end

function _G.goto_implementation()
  require('telescope.builtin').lsp_implementations(common_opts)
end

function _G.goto_declaration()
  require('telescope.builtin').lsp_declarations(common_opts)
end

function _G.goto_references()
  require('telescope.builtin').lsp_references(common_opts)
end

-- Key mappings with descriptions
vim.keymap.set('n', 'gd', _G.goto_definition, { desc = "Go to Definition" })
vim.keymap.set('n', 'gi', _G.goto_implementation, { desc = "Go to Implementation" })
vim.keymap.set('n', 'gD', _G.goto_declaration, { desc = "Go to Declaration" })
vim.keymap.set('n', 'gr', _G.goto_references, { desc = "Find References" })
EOF


lua << EOF
function _G.search_todos()
  -- Use grep_string which doesn't allow editing the search term
  require('telescope.builtin').grep_string({
    search = "todo",
    prompt_title = "TODOs in Project",
    initial_mode = "normal", -- Start in normal mode instead of insert mode
    
    -- Layout for better code context viewing
    layout_strategy = "vertical",
    layout_config = {
      height = 0.9,
      width = 0.8,
      preview_height = 0.6,
    },
    
    -- Better display options
    path_display = {"smart"},
    results_title = "Project TODOs",
  })
end

vim.keymap.set('n', '<leader>td', _G.search_todos, { desc = "Search TODOs" })
EOF
"Refactoring Plugin
"

lua << EOF
require('refactoring').setup({})
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
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function()
      gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end)
    map('v', '<leader>hr', function()
      gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
    end)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function()
      gs.blame_line { full = true }
    end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>td', gs.toggle_deleted)
  end,
}

-- Define or link highlight groups for Gitsigns
vim.api.nvim_set_hl(0, 'GitSignsAdd',          { link = 'DiffAdd' })
vim.api.nvim_set_hl(0, 'GitSignsChange',       { link = 'DiffChange' })
vim.api.nvim_set_hl(0, 'GitSignsDelete',       { link = 'DiffDelete' })
vim.api.nvim_set_hl(0, 'GitSignsTopdelete',    { link = 'GitSignsDelete' })
vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitSignsChange' })
EOF

" Git Blame Plugin Configuration
let g:gitblame_enabled = 0 " Start disabled (1 to enable by default)
nnoremap <leader>gb :GitBlameToggle<CR>

" grep but with the selected text
"
" 1) Define a small Lua helper function to capture the visual selection
lua << EOF
function _G.get_visual_selection()
  -- Save the current register contents
  local saved_reg = vim.fn.getreg('"')
  local saved_type = vim.fn.getregtype('"')

  -- Yank the current selection into the " register
  vim.cmd('normal! ""y')

  -- Get the selection from the " register
  local selection = vim.fn.getreg('"')

  -- Restore the previous register state
  vim.fn.setreg('"', saved_reg, saved_type)

  -- Remove any newline characters (optional)
  selection = string.gsub(selection, "\n", " ")
  return selection
end
EOF

" undo tree plugin
Plug 'mbbill/undotree'
nnoremap <leader>u :UndotreeToggle<CR>

" find and replace



" " 2) Visual-mode keymap: pass the selected text to Telescope's live_grep
xnoremap <leader>fg :<C-u>lua require('telescope.builtin').live_grep({ default_text = get_visual_selection() })<CR>


" Disable arrow keys and display message
nnoremap <Up>    :echo "Use 'k' instead!"<CR>
nnoremap <Down>  :echo "Use 'j' instead!"<CR>
nnoremap <Left>  :echo "Use 'h' instead!"<CR>
nnoremap <Right> :echo "Use 'l' instead!"<CR>

inoremap <Up>    <Esc>:echo "Use 'k' instead!"<CR>
inoremap <Down>  <Esc>:echo "Use 'j' instead!"<CR>
inoremap <Left>  <Esc>:echo "Use 'h' instead!"<CR>
inoremap <Right> <Esc>:echo "Use 'l' instead!"<CR>

vnoremap <Up>    :echo "Use 'k' instead!"<CR>
vnoremap <Down>  :echo "Use 'j' instead!"<CR>
vnoremap <Left>  :echo "Use 'h' instead!"<CR>
vnoremap <Right> :echo "Use 'l' instead!"<CR>
" Paste over selection without copying replaced text
" Paste over selection without copying replaced text
xnoremap p "_dP
noremap <leader>lg :LazyGit<CR>
" Disable all mouse click actions
noremap <LeftMouse> <Nop>
noremap <RightMouse> <Nop>
noremap <MiddleMouse> <Nop>
noremap <2-LeftMouse> <Nop>
noremap <3-LeftMouse> <Nop>
noremap <4-LeftMouse> <Nop>

" Optional: Disable mouse drag/select to avoid visual mode triggers
noremap <LeftDrag> <Nop>
noremap <RightDrag> <Nop>
noremap <MiddleDrag> <Nop>
