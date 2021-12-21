local f = require "f3r10.functions"
local map = f.map

P = function(thing)
  print(vim.inspect(thing))
  return thing
end

RELOAD = function(p)
  package.loaded[p] = nil
  return require(p)
end
-- MAPPINGS -----------------------
map("i", "jk", "<ESC>")
map("n", "<leader>.", "<c-^>")
map("n", "<leader>,", ":w<cr>")
map("n", "<space>", ":set hlsearch! hlsearch?<cr>")

map("n", "<leader>l", ":set list!<cr>")
map("n", "<leader>b", "<Cmd>:Bwipeout<CR>")
-- remove extra whitespace
--map("n", "<leader><space>", ":%s/\s\+$<cr>")
--map("n", "<leader><space><space>", ":%s/\n\{2,}/\r\r/g<cr>")

-- Commentary
map("n", "<leader>/", "<CMD>lua require('Comment.api').toggle_current_linewise()<CR>")
map("v", "<leader>/", "<ESC><CMD>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>")

map("n", "<C-h>", ":call functions#WinMove('h')<cr>")
map("n", "<C-j>", ":call functions#WinMove('j')<cr>")
map("n", "<C-w>k", ":call functions#WinMove('k')<cr>")
map("n", "<C-l>", ":call functions#WinMove('l')<cr>")

map("n", "<leader>wc", ":wincmd q<cr>")
-- toggle cursor line
map("n", "<leader>i", ":set cursorline!<cr>")

-- toggle nerd tree
map("n", "<leader>k", ":NvimTreeToggle<cr>")
--find the current file in nerdtree without needing to reload the drawer
map("n", "<leader>y", ":NvimTreeFindFile<cr>")

-- vim-fugitive

map("n", "<leader>gs", ":Git<cr>")
-- map("n", "<leader>ge", ":Gedit<cr>")
-- map("n", "<leader>gr", ":Gread<cr>")
-- map("n", "<leader>gb", ":Gblame<cr>")

map(
  "n",
  "<leader><leader>n",
  [[<cmd>lua RELOAD("f3r10.functions").toggle_nums()<CR>]]
)
map(
  "n",
  "<leader><leader>c",
  [[<cmd>lua RELOAD("f3r10.functions").toggle_conceal()<CR>]]
)

map("n", "<leaer>nhs", ":nohlsearch<cr>")
map("n", "<leader>xml", ":%!xmllint --format -<cr>")
map("n", "<leader>fo", ":copen<cr>")
map("n", "<leader>fc", ":cclose<cr>")
map("n", "<leader>fn", ":cnext<cr>")
map("n", "<leader>fp", ":cprevious<cr>")
map("n", "<leader>tv", ":vnew | :te<cr>")

map("n", "<leader>m", [[<Cmd>lua require('format').format()<CR>]])
map("v", "<leader>c", [[<Cmd>lua require('format').range_format()<CR>]])
map("n", "<leader>;", [[:lua require('utils.core').match_jump()<CR>]])
-- LSP
map("n", "gD", [[<cmd>lua vim.lsp.buf.definition()<CR>]])
map("n", "K", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
map("v", "K", [[<cmd>lua vim.lsp.buf.hover()<CR>]])
map("n", "<C-k>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]])
map("n", "<space>a", [[<cmd>lua vim.diagnostic.setloclist()<CR>]])
map("n", "gi", [[<cmd>lua vim.lsp.buf.implementation()<CR>]])
map("n", "gr", [[<cmd>lua vim.lsp.buf.references()<CR>]])
map(
  "n",
  "gds",
  [[<cmd>lua require"telescope.builtin".lsp_document_symbols()<CR>]]
)
map(
  "n",
  "gws",
  [[<cmd>lua require"f3r10.telescope".lsp_workspace_symbols()<CR>]]
)
map("n", "<leader>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]])
-- map("n", "<leader>ca", [[<cmd>lua vim.lsp.buf.code_action()<CR>]])
map(
  "n",
  "<leader>ca",
  [[<Cmd>lua require("f3r10.functions").telescopeLspCodeActions()<CR>]]
)
map("n", "<leader>ws", [[<cmd>lua require"metals".hover_worksheet()<CR>]])
map("n", "<leader>a", [[<cmd>lua RELOAD("metals").open_all_diagnostics()<CR>]])
map(
  "n",
  "<leader>tt",
  [[<cmd>lua require("metals.tvp").toggle_tree_view()<CR>]]
)
map("n", "<leader>tr", [[<cmd>lua require("metals.tvp").reveal_in_tree()<CR>]])
map("n", "<leader>d", [[<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>]]) -- buffer diagnostics only
map("n", "<leader>nd", [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]])
map("n", "<leader>pd", [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]])
map(
  "n",
  "gl",
  [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "rounded" })<CR>]]
)
map("n", "<leader>cl", [[<cmd>lua vim.lsp.codelens.run()<CR>]])
map(
  "n",
  "<leader>st",
  [[<cmd>lua require("metals").toggle_setting("showImplicitArguments")<CR>]]
)

-- completion
map("i", "<S-Tab>", [[pumvisible() ? "<C-p>" : "<Tab>"]], { expr = true })
map("i", "<Tab>", [[pumvisible() ? "<C-n>" : "<Tab>"]], { expr = true })
-- map("i", "<CR>", [[compe#confirm("<CR>")]], { expr = true })

-- telescope
map("n", "<C-p>", [[<cmd>lua require"telescope.builtin".git_files()<CR>]])
map("n", "<leader>p", [[:lua require('telescope.builtin').find_files()<CR>]])
map(
  "n",
  "<leader>t",
  [[:lua require('telescope.builtin').lsp_document_diagnostics()<CR>]]
)
map("n", "<leader>r", [[<cmd>lua require"telescope.builtin".buffers()<CR>]])
map("n", "<leader>fp", [[<cmd>lua require"telescope.builtin".find_files()<CR>]])
map("n", "<leader>ff", [[<cmd>lua require"telescope.builtin".live_grep()<CR>]])
map(
  "n",
  "<leader>fb",
  [[<cmd>lua require"telescope.builtin".file_browser()<CR>]]
)
map(
  "n",
  "<leader>mc",
  [[<cmd>lua require("telescope").extensions.metals.commands()<CR>]]
)

-- nvim-dap
map("n", "<leader>dc", [[<cmd>lua require"dap".continue()<CR>]])
map("n", "<leader>dr", [[<cmd>lua require"dap".repl.toggle()<CR>]])
map("n", "<leader>ds", [[<cmd>lua require"dap.ui.variables".scopes()<CR>]])
map("n", "<leader>dK", [[<cmd>lua require"dap.ui.widgets".hover()<CR>]])
map("n", "<leader>dt", [[<cmd>lua require"dap".toggle_breakpoint()<CR>]])
map("n", "<leader>dso", [[<cmd>lua require"dap".step_over()<CR>]])
map("n", "<leader>dsi", [[<cmd>lua require"dap".step_into()<CR>]])
map("n", "<leader>dl", [[<cmd>lua require"dap".run_last()<CR>]])

map("n", "]b", "<Cmd>BufferLineCycleNext<CR>")

map("n", "[b", "<Cmd>BufferLineCyclePrev<CR>")

-- trouble
map("n", "<leader>xx", [[<cmd>Trouble<CR>]])
map("n", "<leader>xw", [[<cmd>Trouble lsp_workspace_diagnostics<CR>]])
map("n", "<leader>xd", [[<cmd>Trouble lsp_document_diagnostics<CR>]])
map("n", "gR", [[<cmd>Trouble lsp_references<CR>]])

--vim
map("n", "<C-f>", [[<cmd>silent !tmux neww tmux-sessionizer<CR>]])
