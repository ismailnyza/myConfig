" =========================================================
" BASIC OPTIONS
" =========================================================
set number
set relativenumber
set cursorline
set expandtab
set tabstop=4
set shiftwidth=4
set smartindent
set termguicolors
set signcolumn=yes
set updatetime=200
let mapleader=" "

" =========================================================
" AUTO-INSTALL VIM-PLUG
" =========================================================
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" =========================================================
" PLUGINS
" =========================================================
call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/plenary.nvim'

" Telescope + file browser
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-tree/nvim-web-devicons'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Java LSP
Plug 'mfussenegger/nvim-jdtls'

" Completion + snippets (psvm, sout)
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'

" Refactoring
Plug 'ThePrimeagen/refactoring.nvim'

" Git Integration (LazyGit)
Plug 'kdheepak/lazygit.nvim'

" Sudo Read/Write Support
Plug 'lambdalisue/suda.vim'

call plug#end()

" =========================================================
" SUDA (SUDO) SETUP
" =========================================================
" Smart edit automatically switches to sudo if you don't have permissions
" This makes :w! work seamlessly for root files
let g:suda_smart_edit = 1

" =========================================================
" LAZYGIT SETUP
" =========================================================
nnoremap <leader>lg :LazyGit<CR>

" =========================================================
" TREESITTER
" =========================================================
lua << EOF
require("nvim-treesitter.configs").setup({
  ensure_installed = { "java", "lua", "vim", "javascript", "typescript", "go" },
  highlight = { enable = true },
})
EOF

" =========================================================
" COMPLETION
" =========================================================
lua << EOF
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})
EOF

" =========================================================
" TELESCOPE
" =========================================================
lua << EOF
local telescope = require("telescope")
telescope.setup({
  defaults = {
    preview = true,
    layout_strategy = "horizontal",
  },
  extensions = {
    file_browser = {
      hijack_netrw = true,
      grouped = true,
      previewer = true,
    },
  },
})
telescope.load_extension("file_browser")
EOF

nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope file_browser path=%:p:h select_buffer=true<CR>

" =========================================================
" DIAGNOSTICS (SQUIGGLY ONLY)
" =========================================================
lua << EOF
vim.diagnostic.config({
  virtual_text = false,
  underline = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})
EOF

nnoremap <leader>d :lua vim.diagnostic.open_float()<CR>
nnoremap <leader>. :lua vim.lsp.buf.code_action()<CR>

" =========================================================
" REFACTORING
" =========================================================
lua << EOF
require("refactoring").setup({})
EOF

nnoremap <leader>re :lua require("refactoring").refactor("Extract Function")<CR>
nnoremap <leader>rv :lua require("refactoring").refactor("Extract Variable")<CR>
xnoremap <leader>re :lua require("refactoring").refactor("Extract Function")<CR>
xnoremap <leader>rv :lua require("refactoring").refactor("Extract Variable")<CR>

" =========================================================
" RUN CODE
" =========================================================
lua << EOF
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("w")
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%")
  local class = vim.fn.expand("%:t:r")

  if ft == "java" then
    vim.cmd("split | terminal javac " .. file .. " && java " .. class)
  end
end)
EOF
