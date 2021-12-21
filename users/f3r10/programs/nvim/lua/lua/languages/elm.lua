local lsp = require "languages.lsp"
local M = {}

M.efm = {
  {
    formatCommand = "prettier --tab-width=2 --use-tabs=false --stdin-filepath ${INPUT} --plugin-search-dir .",
    formatStdin = true,
  },
}

M.all_format = { efm = "Pretter", elmls = "elm-format" }

M.default_format = "elmls"

M.lsp = {
  capabilities = lsp.capabilities,
  on_attach = lsp.on_attach,
}

return M
