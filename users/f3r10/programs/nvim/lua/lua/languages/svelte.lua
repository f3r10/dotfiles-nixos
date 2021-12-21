local lsp = require('languages.lsp')
local M = {}

M.efm = {
    {
        formatCommand = 'prettier --stdin-filepath ${INPUT} --plugin-search-dir .',
        formatStdin = true,
    },
}

M.all_format = { efm = 'Pretter' }

M.default_format = 'efm'

M.lsp = {
    capabilities = lsp.capabilities,
    on_attach = lsp.on_attach,
}

return M
