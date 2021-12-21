local lsp = require "languages.lsp"

require("lspconfig").efm.setup {
  root_dir = require("lspconfig").util.root_pattern ".git",
  filetypes = {
    "javascript",
    "typescript",
    "typescriptreact",
    "javascriptreact",
    "html",
    "svelte",
    "lua",
    "elm",
    "rust",
    "css",
    "haskell"
  },

  init_options = { documentFormatting = true, codeAction = true },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      javascript = require("languages.javascript").efm,
      typescript = require("languages.javascript").efm,
      typescriptreact = require("languages.javascript").efm,
      javascriptreact = require("languages.javascript").efm,
      html = require("languages.html").efm,
      svelte = require("languages.svelte").efm,
      lua = require("languages.lua").efm,
      elm = require("languages.elm").efm,
      rust = require("languages.rust").efm,
      css = require("languages.css").efm,
      haskell = require("languages.haskell").efm
    },
  },

  on_attach = lsp.on_attach,

  capabilities = lsp.capabilities,
}
