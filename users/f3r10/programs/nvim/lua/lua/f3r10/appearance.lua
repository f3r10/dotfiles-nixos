local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local f = require "f3r10.functions"
local map = f.map
local opt = vim.opt
local global_opt = vim.opt_global

P = function(thing)
  print(vim.inspect(thing))
  return thing
end

RELOAD = function(p)
  package.loaded[p] = nil
  return require(p)
end
----------------------------------
-- VARIABLES ---------------------
----------------------------------
g["mapleader"] = ","
g["netrw_gx"] = "<cWORD>"

----------------------------------
-- OPTIONS -----------------------
----------------------------------
require "options"
----------------------------------
-- COMMANDS ----------------------
----------------------------------
cmd [[autocmd FileType markdown setlocal textwidth=80]]
cmd [[autocmd BufReadPost,BufNewFile *.md,*.txt,COMMIT_EDITMSG set wrap linebreak nolist spell spelllang=en_us complete+=kspell]]
cmd [[autocmd BufReadPost,BufNewFile .html,*.txt,*.md,*.adoc set spell spelllang=en_us]]
cmd [[autocmd TermOpen * startinsert]]

--cmd [[augroup colorset]]
--cmd [[autocmd!]]

--- For some reason when this is included in the augroup down below it doesn't work
---- Needed to esnure float background doesn't get odd highlighting
---- https://github.com/joshdick/onedark.vim#onedarkset_highlight
--cmd [[autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" } })]]
--cmd [[autocmd ColorScheme * highlight link LspCodeLens Conceal]]
--cmd [[augroup END]]

cmd "colorscheme onedark"

-- cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]

-- LSP
-- cmd [[augroup lsp]]
-- cmd [[autocmd!]]
-- cmd [[autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
-- cmd [[autocmd FileType scala,sbt lua require("metals").initialize_or_attach(Metals_config)]]

-- -- used in textDocument/hightlight
-- cmd [[hi! link LspReferenceText CursorColumn]]
-- cmd [[hi! link LspReferenceRead CursorColumn]]
-- cmd [[hi! link LspReferenceWrite CursorColumn]]

-- -- Diagnostic specific colors
-- cmd [[hi! DiagnosticError guifg=#e06c75]]
-- cmd [[hi! DiagnosticWarn guifg=#e5c07b]]
-- cmd [[hi! DiagnosticInfo guifg=#56b6c2]]
-- cmd [[hi! link DiagnosticHint DiagnosticInfo]]

-- -- _Maybe_ try underline for a bit
-- cmd [[hi! DiagnosticUnderlineError cterm=NONE gui=underline guifg=NONE]]
-- cmd [[hi! DiagnosticUnderlineWarn cterm=NONE gui=underline guifg=NONE]]
-- cmd [[hi! DiagnosticUnderlineInfo cterm=NONE gui=underline guifg=NONE]]
-- cmd [[hi! DiagnosticUnderlineHint cterm=NONE gui=underline guifg=NONE]]

-- -- Statusline specific highlights
-- cmd [[hi! StatusLine guifg=#5C6370 guibg=#282c34]]
-- cmd [[hi! link StatusError DiagnosticError]]
-- cmd [[hi! link StatusWarn DiagnosticWarn]]

-- cmd [[augroup END]]
-- cmd([[augroup AutoFormat]])
--     cmd([[autocmd!]])
--     cmd([[autocmd BufWritePre * lua require("nvim-lsp-compose").write()]])
-- cmd([[augroup END]])

vim.cmd [[command! Format execute 'lua vim.lsp.buf.formatting()' ]]

----------------------------------
-- DIAGNOSTIC SETTINGS -----------
----------------------------------
-- fn.sign_define(
--   "DiagnosticSignError",
--   { text = "▬", texthl = "DiagnosticError" }
-- )
-- fn.sign_define(
--   "DiagnosticSignWarn",
--   { text = "▬", texthl = "DiagnosticWarn" }
-- )
-- fn.sign_define(
--   "DiagnosticSignInfo",
--   { text = "▬", texthl = "DiagnosticInfo" }
-- )
-- fn.sign_define(
--   "DiagnosticSignHint",
--   { text = "▬", texthl = "DiagnosticHint" }
-- )

-- Since a lot of errors can be super long and multiple lines in Scala, I use
-- this to split on the first new line and only dispaly the first line as the
-- virtual text... that is when I actually use virtual text for diagnsostics
local diagnostic_foramt = function(diagnostic)
  return string.format(
    "%s: %s",
    diagnostic.source,
    f.split_on(diagnostic.message, "\n")[1]
  )
end

-- vim.diagnostic.config({ virtual_text = { format = diagnostic_foramt } })
