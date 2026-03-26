vim.g.mapleader = " "
vim.g.maplocalleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.mouse = "a"
vim.opt.updatetime = 200
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.cursorline = true
vim.opt.pumheight = 12

vim.keymap.set("n", "<leader>n", "<cmd>Neotree toggle reveal filesystem right<CR>", { desc = "Project file explorer" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files hidden=true<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

require("lazy").setup({
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("kanagawa-dragon")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
            preview_width = 0.55,
            width = 0.95,
            height = 0.9,
          },
          path_display = { "smart" },
          preview = {
            treesitter = true,
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
          lsp_references = {
            show_line = false,
          },
        },
      })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          hijack_netrw_behavior = "open_default",
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
          window = {
            mappings = {
              ["l"] = "open",
              ["<Right>"] = "open",
              ["h"] = "close_node",
              ["<Left>"] = "close_node",
              ["P"] = { "focus_preview" },
              ["<CR>"] = "open",
            },
          },
        },
        window = {
          position = "right",
          width = 40,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      local ok, ts_configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.schedule(function()
          vim.notify("nvim-treesitter not ready yet; run :Lazy! sync and restart nvim", vim.log.levels.WARN)
        end)
        return
      end

      ts_configs.setup({
        ensure_installed = { "go", "gomod", "gosum", "lua", "vim", "bash", "markdown", "javascript", "typescript", "tsx", "json", "html", "css" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "lua_ls", "bashls", "ts_ls", "jsonls", "html", "cssls" },
        automatic_enable = false,
      })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "gopls",
          "goimports",
          "gofumpt",
          "golangci-lint",
          "lua-language-server",
          "stylua",
          "bash-language-server",
          "shellcheck",
          "typescript-language-server",
          "js-debug-adapter",
          "prettier",
          "eslint-lsp",
          "json-lsp",
          "html-lsp",
          "css-lsp",
        },
        auto_update = false,
        run_on_start = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      local function setup(server, opts)
        opts = opts or {}
        if vim.fn.has("nvim-0.11") == 1 and vim.lsp and vim.lsp.config then
          vim.lsp.config(server, opts)
          vim.lsp.enable(server)
        else
          lspconfig[server].setup(opts)
        end
      end

      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Implementation" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "<leader>gu", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "Usages" }))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
        vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = false }) end, vim.tbl_extend("force", opts, { desc = "Format" }))
      end

      setup("gopls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          gopls = {
            gofumpt = true,
            usePlaceholders = true,
            staticcheck = true,
          },
        },
      })

      setup("ts_ls", { capabilities = capabilities, on_attach = on_attach })
      setup("bashls", { capabilities = capabilities, on_attach = on_attach })
      setup("jsonls", { capabilities = capabilities, on_attach = on_attach })
      setup("html", { capabilities = capabilities, on_attach = on_attach })
      setup("cssls", { capabilities = capabilities, on_attach = on_attach })
      setup("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
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
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer" },
        }),
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.goimports,
          null_ls.builtins.formatting.prettier,
        },
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          if ft == "go" or ft == "lua" or ft == "javascript" or ft == "javascriptreact" or ft == "typescript" or ft == "typescriptreact" or ft == "json" or ft == "css" or ft == "html" then
            vim.lsp.buf.format({ bufnr = args.buf, async = false })
          end
        end,
      })
    end,
  },
}, {
  checker = { enabled = false },
})
