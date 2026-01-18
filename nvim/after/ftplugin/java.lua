local jdtls = require("jdtls")
local home = os.getenv("HOME")

local jdtls_path = home .. "/tools/jdtls"
local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local lombok = home .. "/tools/lombok/lombok.jar"

local workspace = vim.fn.stdpath("cache")
  .. "/jdtls/"
  .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p"):gsub("/", "_")

local config = {
  cmd = {
    vim.fn.exepath("java"),

    "-javaagent:" .. lombok,
    "-Xbootclasspath/a:" .. lombok,

    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",

    "-Xmx2g",

    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",

    "-jar", launcher,
    "-configuration", jdtls_path .. "/config_linux",
    "-data", workspace,
  },

  root_dir = require("jdtls.setup").find_root({
    ".git", "mvnw", "gradlew", "pom.xml", "build.gradle",
  }),

  capabilities = require("cmp_nvim_lsp").default_capabilities(),

  on_attach = function(_, bufnr)
    local map = function(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { buffer = bufnr })
    end

    map("K", vim.lsp.buf.hover)
    map("gd", vim.lsp.buf.definition)
    map("gr", vim.lsp.buf.references)
    map("<leader>rn", vim.lsp.buf.rename)
    map("<leader>ca", vim.lsp.buf.code_action)
  end,
}

jdtls.start_or_attach(config)

