local M = {}
local shared_diagnostic_settings = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  { virtual_text = false }
)
-- local lsp_config = require "lspconfig"
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- lsp_config.util.default_config = vim.tbl_extend(
--   "force",
--   lsp_config.util.default_config,
--   {
--     handlers = {
--       ["textDocument/publishDiagnostics"] = shared_diagnostic_settings,
--     },
--     capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities),
--   }
-- )

Metals_config = require("metals").bare_config()

Metals_config.settings = {
  showImplicitArguments = true,
  showInferredType = true,
  excludedPackages = {
    "akka.actor.typed.javadsl",
    "com.github.swagger.akka.javadsl",
    "akka.stream.javadsl",
  },
  serverProperties = {"-Xmx3G", "-Xms3G", "-Xss4m"},
  --fallbackScalaVersion = "3.0.1",
  --serverProperties = {
  --  "-Dmetals.scala-cli.launcher=/usr/local/bin/scala-cli",
  --},
}

Metals_config.init_options.statusBarProvider = "on"
Metals_config.init_options.compilerOptions.isCompletionItemResolve = false
Metals_config.handlers["textDocument/publishDiagnostics"] =
  shared_diagnostic_settings
Metals_config.capabilities = require("cmp_nvim_lsp").update_capabilities(
  capabilities
)

local dap = require "dap"

dap.configurations.scala = {
  {
    type = "scala",
    request = "launch",
    name = "Run",
    metals = {
      runType = "run",
      args = { "firstArg", "secondArg", "thirdArg" },
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test File",
    metals = {
      runType = "testFile",
    },
  },
  {
    type = "scala",
    request = "launch",
    name = "Test Target",
    metals = {
      runType = "testTarget",
    },
  },
}

Metals_config.on_attach = function(_, _)
  vim.cmd [[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]]
  vim.cmd [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
  vim.cmd [[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]

  require("metals").setup_dap()
end

M.lsp = {
  metals_config = Metals_config,
}

return M
