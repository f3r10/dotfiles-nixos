local treesitter_config = require "nvim-treesitter.configs"

-- require("nvim-treesitter.configs").setup({
--     -- playground = { enable = true },
--     query_linter = {
--       enable = true,
--       use_virtual_text = true,
--       lint_events = { "BufWrite", "CursorHold" },
--     },
--     ensure_installed = "maintained",
--     highlight = {
--       enable = true,
--       disable = { "scala", "html"},
--     },

--     rainbow = {
--       enable = true,
--       extended_mode = false,
--     },

--     autotag = { enable = true },

--     pairs = {
--       enable = true,
--       highlight_self = false,
--       goto_right_end = false,
--       fallback_cmd_normal = 'normal! %',
--     },

--     autopairs = { enable = true },
--   })
treesitter_config.setup {
  ensure_installed = "maintained",
  sync_install = false,
  highlight = {
    enable = true,
    disable = { "scala", "html" },
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },

  -- rainbow = {
  --   enable = true,
  --   extended_mode = false,
  -- },

  -- autotag = { enable = true },

  -- pairs = {
  --   enable = true,
  --   highlight_self = false,
  --   goto_right_end = false,
  --   fallback_cmd_normal = "normal! %",
  -- },

  autopairs = { enable = true },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}
