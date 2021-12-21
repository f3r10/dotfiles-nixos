local api = vim.api

local M = {}

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
      augroup lsp_document_highlight
      autocmd! * <buffer>
      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
      ]],
      false
    )
  end
  -- vim.api.nvim_exec(
  --   [[
  --     augroup show_line_diagnostics
  --     autocmd! * <buffer>
  --     autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})
  --     augroup END
  --     ]],
  --   false
  -- )

  -- vim.cmd [[autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()]]
  -- vim.cmd [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
  -- vim.cmd [[autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
end
-- Credit https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
function M.on_attach(client, bufnr)
  if client.name == "tsserver" then
    client.resolved_capabilities.document_formatting = false
  end
  lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

M.capabilities = capabilities

return M
