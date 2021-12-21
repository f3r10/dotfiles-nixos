local augroup = vim.api.nvim_exec
local cmd = vim.cmd
local au = require "au"

vim.api.nvim_command "command! -range CommentToggle lua require('utils.comment').comment_toggle(<line1>, <line2>)"

au({ "BufNewFile", "BufRead" }, {
  "*.pcss",
  function()
    vim.bo.filetype = "pcss.css"
  end,
})

-- augroup(
--   [[
--     augroup FormatAutogroup
--     autocmd!
--     autocmd BufWritePre Dockerfile,*.md,*.php,*.py,*.js,*.jsx,*.ts,*.tsx,*.svelte,*.go,*.lua,*.rs,*.tex,*.css,*.html,*.yaml,*.yml,*.json lua require('format').format()
--     augroup END
--     ]],
--   true
-- )

-- augroup(
--   [[
--     augroup UpdateGlobal
--     autocmd!
--     autocmd CursorHold,CursorHoldI * lua require'utils.lightbulb'.code_action()
--     augroup END
--     ]],
--   true
-- )
augroup(
  [[
  augroup LspScala
  autocmd!
  autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd FileType scala,sbt lua require("metals").initialize_or_attach(require("languages.scala").lsp.metals_config)
  ]],
  true
)


vim.cmd [[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR> 
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Search', timeout = 200}) 
    autocmd BufWinEnter * :set formatoptions-=cro
    autocmd FileType qf set nobuflisted
  augroup end
  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end
  augroup _markdown
    autocmd!
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end
  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd = 
  augroup end
]]
