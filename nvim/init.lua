-----------------------------------------------------------
-- Leader
-----------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-----------------------------------------------------------
-- Bootstrap lazy.nvim
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- General Options
-----------------------------------------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.laststatus = 3
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.mouse = "a"

-- Treesitter folding (12)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-----------------------------------------------------------
-- Keymaps (general)
-----------------------------------------------------------
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { desc = "Explorer" })

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------
require("lazy").setup({

-----------------------------------------------------------
-- Theme
-----------------------------------------------------------
{
  "rebelot/kanagawa.nvim",
  priority = 1000,
  config = function()
    require("kanagawa").setup({ dimInactive = true })
    vim.cmd.colorscheme("kanagawa-dragon")
  end,
},

-----------------------------------------------------------
-- Notify (10)
-----------------------------------------------------------
{
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    notify.setup({ stages = "fade", timeout = 3000 })
    vim.notify = notify
  end,
},

-----------------------------------------------------------
-- Noice
-----------------------------------------------------------
{
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
  config = function()
    require("noice").setup({
      lsp = { override = { ["cmp.entry.get_documentation"] = true } },
      presets = { bottom_search = true, command_palette = true },
    })
  end,
},

-----------------------------------------------------------
-- Statusline
-----------------------------------------------------------
{
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({ options = { globalstatus = true } })
  end,
},

-----------------------------------------------------------
-- File Explorer
-----------------------------------------------------------
{
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({})
  end,
},

-----------------------------------------------------------
-- Telescope
-----------------------------------------------------------
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
  },
  config = function()
    local t = require("telescope")
    t.setup({
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
    })
    t.load_extension("fzf")
  end,
},

-----------------------------------------------------------
-- Spectre (9)
-----------------------------------------------------------
{
  "nvim-pack/nvim-spectre",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>sr", function() require("spectre").open() end, desc = "Search & Replace" },
    { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Replace Word" },
  },
},

-----------------------------------------------------------
-- Treesitter
-----------------------------------------------------------
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "go", "lua", "php", "markdown" },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
    })
  end,
},

-----------------------------------------------------------
-- LSP
-----------------------------------------------------------
{
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "gopls", "lua_ls", "intelephense" },
    })

    local lsp = require("lspconfig")
    local caps = require("cmp_nvim_lsp").default_capabilities()

    local on_attach = function(_, bufnr)
      local map = function(k, v, d)
        vim.keymap.set("n", k, v, { buffer = bufnr, desc = d })
      end
      map("gd", require("telescope.builtin").lsp_definitions, "Definition")
      map("gr", require("telescope.builtin").lsp_references, "References")
      map("K", vim.lsp.buf.hover, "Hover")
    end

    lsp.gopls.setup({ on_attach = on_attach, capabilities = caps })
    lsp.lua_ls.setup({
      on_attach = on_attach,
      capabilities = caps,
      settings = { Lua = { diagnostics = { globals = { "vim" } } } },
    })
    lsp.intelephense.setup({ on_attach = on_attach, capabilities = caps })
  end,
},

-----------------------------------------------------------
-- Completion
-----------------------------------------------------------
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = { { name = "nvim_lsp" } },
    })
  end,
},

-----------------------------------------------------------
-- none-ls (deterministic formatting fix)
-----------------------------------------------------------
{
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local nls = require("null-ls")
    nls.setup({
      sources = {
        nls.builtins.formatting.gofmt,
        nls.builtins.formatting.goimports,
      },
      on_attach = function(client, bufnr)
        if client.name == "null-ls" then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(c) return c.name == "null-ls" end,
              })
            end,
          })
        end
      end,
    })
  end,
},

-----------------------------------------------------------
-- Neotest (fixed keymaps)
-----------------------------------------------------------
{
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/neotest-go",
  },
  config = function()
    require("neotest").setup({
      adapters = { require("neotest-go") },
    })
  end,
  keys = {
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test File" },
    { "<leader>tn", function() require("neotest").run.run() end, desc = "Test Nearest" },
    { "<leader>tA", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Test All" },
  },
},

-----------------------------------------------------------
-- ToggleTerm
-----------------------------------------------------------
{
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      direction = "horizontal",
      size = 15,
    })
  end,
},

}, {
  checker = { enabled = true },
})
