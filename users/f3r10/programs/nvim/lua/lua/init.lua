--vim.cmd [[packadd packer.nvim]]
-- require("onedark").setup()
require("onedark").setup {
  functionStyle = "italic",
  sidebars = { "qf", "vista_kind", "terminal", "packer" },
  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
  colors = { hint = "orange", error = "#ff0000" },
  commentStyle = "italic",
}
require("setup.bufferline-two")
require "setup.impatient"
-- require("options")
require("f3r10.telescope").setup()
require "f3r10.plugins"
require("f3r10.galaxyline").setup()
-- require("f3r10.cmp").setup()
require("f3r10.lsp").setup()
require "f3r10.appearance"

require "setup.autopairs"
require "setup.toggleterm"
require "setup.blankline"
require "setup.signature"
-- require("setup.windline")
require "setup.colorizer"
require "setup.gitsigns"
require "setup.nvim-tree"
require("hop").setup()
-- require "lsp.efm"
require "lsp.null-ls"
require "lsp.tailwindcss"
require "lspicon"
require "setup.treesitter"

require "setup.cmp_2"
require("luasnip/loaders/from_vscode").lazy_load()
-- require "highlights"
require "mappings"
require "autocommands"

require("trouble").setup {
  fold_open = "v", -- icon used for open folds
  fold_closed = ">", -- icon used for closed folds
  indent_lines = false, -- add an indent guide below the fold icons
  signs = {
    -- icons / text used for a diagnostic
    error = "error",
    warning = "warn",
    hint = "hint",
    information = "info",
  },
  use_lsp_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
}

require "setup.rust_tools"
require("todo-comments").setup {}
-- NOTE this setup  produce an core dump error
-- require("neogit").setup {}
require("neoclip").setup()

require("fm-nvim").setup {}

require("setup.comment")
