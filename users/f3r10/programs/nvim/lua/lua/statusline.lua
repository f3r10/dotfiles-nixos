local M = {}

-- Credit https://github.com/glepnir/galaxyline.nvim/blob/main/lua/galaxyline/provider_diagnostic.lua
local function get_nvim_lsp_diagnostic(diag_type)
    if next(vim.lsp.buf_get_clients(0)) == nil then
        return '0 '
    end
    local active_clients = vim.lsp.get_active_clients()

    if active_clients then
        local count = 0

        for _, client in ipairs(active_clients) do
            count = count + vim.lsp.diagnostic.get_count(vim.api.nvim_get_current_buf(), diag_type, client.id)
        end

        return count .. ' '
    end
end

-- Credit https://github.com/glepnir/galaxyline.nvim/blob/main/lua/galaxyline/provider_diagnostic.lua
function M.diagnostics_error()
    if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        return get_nvim_lsp_diagnostic('Error')
    end

    return '0 '
end

-- Credit https://github.com/glepnir/galaxyline.nvim/blob/main/lua/galaxyline/provider_diagnostic.lua
function M.diagnostics_warning()
    if not vim.tbl_isempty(vim.lsp.buf_get_clients(0)) then
        return get_nvim_lsp_diagnostic('Warning')
    end

    return '0 '
end

-- Credit https://github.com/glepnir/galaxyline.nvim/blob/main/lua/galaxyline/provider_vcs.lua
function M.get_hunks_data()
    -- diff data 1:add 2:modified 3:remove
    local diff_data = { 0, 0, 0 }
    if vim.fn.exists('b:gitsigns_status') == 1 then
        local gitsigns_dict = vim.api.nvim_buf_get_var(0, 'gitsigns_status')
        diff_data[1] = tonumber(gitsigns_dict:match('+(%d+)')) or 0
        diff_data[2] = tonumber(gitsigns_dict:match('~(%d+)')) or 0
        diff_data[3] = tonumber(gitsigns_dict:match('-(%d+)')) or 0
    end

    return diff_data
end

local async_load = vim.loop.new_async(vim.schedule_wrap(function()
    local line
    if vim.fn.winwidth(0) > 30 then
        local fileType = vim.bo.filetype
        local lineBreak = vim.go.fileformat
        local is_update = false
        local tab = vim.api.nvim_eval('&tabstop')

        if fileType ~= '' and fileType ~= 'toggleterm' then
            is_update = true
            -- tab = vim.api.nvim_eval('&tabstop')

            fileType = fileType:gsub('^%l', string.upper)

            if lineBreak == 'unix' then
                lineBreak = 'LF'
            elseif lineBreak == 'mac' then
                lineBreak = 'CR'
            else
                lineBreak = 'CRLF'
            end
        else
            is_update = false
        end

        line = ''

        if fileType ~= 'Help' then
            line = line
                .. '%#StatuslineBackground#   '
                .. require('git_utils').branch('')
                .. '   %#StatuslineDiagnosticsError#'
                .. [[ %{luaeval('require("statusline").diagnostics_error()')}]]
                .. '%#StatuslineDiagnosticsWarning#'
                .. [[ %{luaeval('require("statusline").diagnostics_warning()')}]]
                .. '  %#StatuslineDiffAdded#'
                .. [[ %{luaeval('require("statusline").get_hunks_data()[1]')}]]
                .. ' %#StatuslineDiffModified#'
                .. [[ %{luaeval('require("statusline").get_hunks_data()[2]')}]]
                .. ' %#StatuslineDiffRemoved#'
                .. [[ %{luaeval('require("statusline").get_hunks_data()[3]')}]]
        end

        line = line .. '%#StatuslineBackground#%=ln %l, col %c   '

        if is_update and vim.fn.winwidth(0) > 80 then
            line = line
                .. 'Tabsizes '
                .. tab
                .. '   '
                .. lineBreak
                .. '   '
                .. fileType
                .. [[   %{luaeval('require("format").formatter_status()')}]]
        end

        line = line .. '%#StatuslineSmiley#  '
    else
        line = '%#StatuslineBackground#'
    end

    vim.wo.statusline = line
end))

-- Credit https://github.com/glepnir/galaxyline.nvim/blob/main/lua/galaxyline.lua
function M.load()
    async_load:send()
end

return M
