local M = {}

local previewers = require "telescope.previewers"
local Job = require "plenary.job"
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job
    :new({
      command = "file",
      args = { "--mime-type", "-b", filepath },
      on_exit = function(j)
        local mime_type = vim.split(j:result()[1], "/")[1]
        if mime_type == "text" then
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        else
          -- maybe we want to write something to the buffer here
          vim.schedule(function()
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
          end)
        end
      end,
    })
    :sync()
end

M.setup = function()
  local actions = require "telescope.actions"
  local trouble = require "trouble.providers.telescope"
  require("telescope").setup {
    -- defaults = {
    --     -- file_ignore_patterns = { "target", "node_modules", "parser.c", "out"},
    --     file_ignore_patterns = { "node_modules", "target"},
    --     prompt_prefix = " >",
    --     file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    --     grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    --     mappings = {
    --         n = {
    --             ["f"] = actions.send_to_qflist,
    --         },
    --     },
    --     file_sorter = require("telescope.sorters").get_fzy_sorter,
    --     color_devicons = true,

    --     qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    --     buffer_previewer_maker = new_maker,

    -- },
    defaults = {
      prompt_prefix = " >",
      selection_caret = " ",
      path_display = { "smart" },
      mappings = {
        i = {
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,

          ["<C-c>"] = actions.close,

          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,

          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["<C-l>"] = actions.complete_tag,
          ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
        },
        n = {
          ["<esc>"] = actions.close,
          ["<CR>"] = actions.select_default,
          ["<C-x>"] = actions.select_horizontal,
          ["<C-v>"] = actions.select_vertical,
          ["<C-t>"] = actions.select_tab,

          ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
          ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
          ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          ["j"] = actions.move_selection_next,
          ["k"] = actions.move_selection_previous,
          ["H"] = actions.move_to_top,
          ["M"] = actions.move_to_middle,
          ["L"] = actions.move_to_bottom,

          ["<Down>"] = actions.move_selection_next,
          ["<Up>"] = actions.move_selection_previous,
          ["gg"] = actions.move_to_top,
          ["G"] = actions.move_to_bottom,

          ["<C-u>"] = actions.preview_scrolling_up,
          ["<C-d>"] = actions.preview_scrolling_down,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["?"] = actions.which_key,
        },
      },

      layout_config = {
        horizontal = { mirror = false, preview_width = 0.5 },
        vertical = { mirror = false },
      },

      file_ignore_patterns = { ".git", "target" },
      set_env = { ["COLORTERM"] = "truecolor" },
      --[[ buffer_previewer_maker = new_maker, --]]
      -- mappings = {
      --   n = {
      --     i = { ["<c-t>"] = trouble.open_with_trouble },
      --     n = { ["<c-t>"] = trouble.open_with_trouble },
      --   },
      -- },
    },

    --[[ pickers = {
      buffers = {
        show_all_buffers = true,
        sort_lastused = true,
        sort_mru = true,
        previewer = false,
        mappings = {
          i = {
            ["<c-d>"] = "delete_buffer",
          },
        },
      },
    }, --]]
    --[[ extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    }, --]]
  }
  --[[ require("telescope").load_extension "fzy_native" --]]
end

-- local M = {}
-- M.search_dotfiles = function()
--     require("telescope.builtin").find_files({
--         prompt_title = "< VimRC >",
--         cwd = vim.env.DOTFILES,
--     })
-- end

-- M.git_branches = function()
--     require("telescope.builtin").git_branches({
--         attach_mappings = function(_, map)
--             map("i", "<c-d>", actions.git_delete_branch)
--             map("n", "<c-d>", actions.git_delete_branch)
--             return true
--         end,
--     })
-- end
--
-- This is mainly for Metals since we don't respond to "" as a query to get all
-- the symbols. This will first get the input form the user and then execute
-- the query.
M.lsp_workspace_symbols = function()
  local input = vim.fn.input "Query: "
  vim.api.nvim_command "normal :esc<CR>"
  if not input or #input == 0 then
    return
  end
  require("telescope.builtin").lsp_workspace_symbols { query = input }
end

return M
