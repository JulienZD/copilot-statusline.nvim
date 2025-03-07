local copilot = require('copilot-statusline.util')

local M = {}

M.config = {}

local icons = {
  enabled = '',
  sleep = '',
  disabled = '',
  warning = '',
  unknown = '',
  loading = '',
}

-- Whether copilot is attached to a buffer
local attached = false

local state = nil

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('copilot-status', {}),
  desc = 'Update copilot attached status (copilot-statusline',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'copilot' then
      attached = true

      require('copilot.api').register_status_notification_handler(function()
        local new_state = M:get_copilot_status()
        -- only update statusline if the state has changed
        if new_state ~= state then
          state = new_state
          vim.cmd('redrawstatus')
        end
      end)

      return true
    end
    return false
  end,
})

function M.setup(options)
  M.config = vim.tbl_deep_extend('force', M.config, options or {})
end

function M.section_copilot(args)
  return state
end

function M:get_copilot_status()
  -- All copilot API calls are blocking before copilot is attached,
  -- To avoid blocking the startup time, we check if copilot is attached
  local copilot_loaded = package.loaded['copilot'] ~= nil
  if not copilot_loaded or not attached then
    return 'n/a'
  end

  if copilot.is_loading() then
    return icons.loading
  elseif copilot.is_error() then
    return icons.warning
  elseif not copilot.is_enabled() then
    return icons.disabled
  elseif copilot.is_sleep() then
    return icons.sleep
  else
    return icons.enabled
  end
end

return M
