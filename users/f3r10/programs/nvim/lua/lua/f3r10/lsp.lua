-- requires https://github.com/sentriz/nvim-lsp-compose

-- lang servers:
--     efm        go install github.com/mattn/efm-langserver@latest
--     bash       npm install -g bash-language-server
--     c          yay -S clang
--     dockerfile npm install -g dockerfile-language-server-nodejs
--     go         go install golang.org/x/tools/gopls@latest
--     python     npm install -g pyright
--     js, ts     npm install -g typescript typescript-language-server
--     svelte     npm install -g svelte svelte-language-server
--     tailwind   yay -S vscode-tailwindcss-language-server-bin
--     vue        npm install -g @volar/server

-- formatters:
--     prettierd            npm install -g @fsouza/prettierd
--     prettier go template npm install -g prettier prettier-plugin-go-template
--     prettier svelte      npm install -g prettier prettier-plugin-svelte svelte
--     goimports            go install golang.org/x/tools/cmd/goimports@latest
--     clang-format         yay -S clang
--     black                pip install --user black
--     stylua               https://github.com/JohnnyMorganz/StyLua/releases
--     pg_format            https://github.com/darold/pgFormatter
--     pandoc               yay -S pandoc-bin
--     shfmt                go install mvdan.cc/sh/v3/cmd/shfmt@latest

-- linters:
--     shellcheck   yay -S shellcheck-bin
--     eslint_d     npm install -g eslint_d
--     pylint       pip install --user pylint
--     hadolint     yay -S hadolint-bin
--     markdownlint npm install -g markdownlint-cli
--
local M = {}

M.setup = function()
  local lsp_config = require "lspconfig"
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  -- for _, sign in ipairs(signs) do
  --   vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  -- end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  -- vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    config
  )

  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {
      border = "rounded",
    })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {
      border = "rounded",
    }
  )

  -- sumneko lua
  lsp_config.sumneko_lua.setup(require("languages.lua").lsp)

  lsp_config.html.setup(require("languages.html").lsp)
  lsp_config.jsonls.setup {
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
        end,
      },
    },
  }
  lsp_config.tsserver.setup(require("languages.javascript").lsp)
  lsp_config.svelte.setup(require("languages.svelte").lsp)
  lsp_config.elmls.setup(require("languages.elm").lsp)
  lsp_config.cssls.setup(require("languages.css").lsp)
  lsp_config.hls.setup(require("languages.haskell").lsp)
  lsp_config.rnix.setup{}
  -- lsp_config.rust_analyzer.setup(require("languages.rust").lsp)

  -- Uncomment for trace logs from neovim
  --vim.lsp.set_log_level('trace')
  -- require "languages.scala"
end

return M
