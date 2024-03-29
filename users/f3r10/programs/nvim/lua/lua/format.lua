local utils = require "utils.core"
local M = {}

local html = require "languages.html"
local svelte = require "languages.svelte"
local lua = require "languages.lua"
local elm = require "languages.elm"
local javascript = require "languages.javascript"
local rust = require "languages.rust"
local css = require "languages.css"
local haskell = require "languages.haskell"

local formatters = {
  lua = lua.all_format,
  elm = elm.all_format,
  javascript = javascript.all_format,
  javascriptreact = javascript.all_format,
  typescript = javascript.all_format,
  typescriptreact = javascript.all_format,
  svelte = svelte.all_format,
  html = html.all_format,
  rust = rust.all_format,
  css = css.all_format,
  haskell = haskell.all_format
}

M.default_formatter = {
  lua = lua.default_format,
  elm = elm.default_format,
  javascript = javascript.default_format,
  javascriptreact = javascript.default_format,
  typescript = javascript.default_format,
  typescriptreact = javascript.default_format,
  svelte = svelte.default_format,
  html = html.default_format,
  rust = rust.default_format,
  css = css.default_format,
  haskell = haskell.default_format
}

M.choose_formatter = function()
  local fileType = vim.bo.filetype
  local all_formatters = formatters[fileType]
  local store_formatters = {}

  local count = 0
  for key, _ in pairs(all_formatters) do
    count = count + 1
    -- table.insert(store_formatters, key)
    store_formatters[#store_formatters + 1] = key
    print("[" .. count .. "] " .. key)
  end

  if count > 1 then
    local option = vim.fn.input "Choose your formmatter: "

    M.default_formatter[fileType] = store_formatters[tonumber(option)]
  end
end

M.formatter_status = function()
  local fileType = vim.bo.filetype
  if M.default_formatter[fileType] then
    return formatters[fileType][M.default_formatter[fileType]] .. "   "
  else
    return ""
  end
end

M.format = function()
  local clients = vim.lsp.buf_get_clients(0)
  local fileType = vim.bo.filetype
  local code_formatter = M.default_formatter[fileType]

  if utils.tablelength(clients) > 1 then
    -- check if multiple clients, and if efm is setup
    for _, c1 in pairs(clients) do
      if c1.name == code_formatter then
        c1.resolved_capabilities.document_formatting = true
        -- if efm then disable others
        for _, c2 in pairs(clients) do
          -- print(c2.name, c2.resolved_capabilities.document_formatting)
          if c2.name ~= code_formatter then
            c2.resolved_capabilities.document_formatting = false
          end
        end
        -- no need to contunue first loop
        break
      end
    end
  end

  vim.lsp.buf.formatting_sync(nil, 1000)
end

M.range_format = function()
  local vim_mode = vim.api.nvim_eval "mode()"

  if vim_mode == "v" then
    local start_position = vim.api.nvim_eval 'getpos("v")'
    local end_position = vim.api.nvim_eval 'getpos(".")'

    vim.lsp.buf.range_formatting(
      {},
      { start_position[2], 0 },
      { end_position[2], 0 }
    )
  end
end

return M
