<h1 align="center">copilot-statusline.nvim</h1>

Component for [mini.statusline](https://github.com/echasnovski/mini.statusline) to display the status of [copilot.lua](https://github.com/zbirenbaum/copilot.lua)

### Requirements
- [Neovim](https://neovim.io/)
- [mini.statusline](https://github.com/echasnovski/mini.statusline)
- [Copilot.lua](https://github.com/zbirenbaum/copilot.lua)
- A [Nerd Font](https://www.nerdfonts.com/#home) *- For Default Icons*


### Installation

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'JulienZD/copilot-statusline.nvim',
  opts = {}, 
}
```

### Usage

#### lazy.nvim
1. Add copilot-statusline as a dependency to mini.nvim
2. Override the `active` components with the addition of the copilot statusline component

```lua
{ 
  'echasnovski/mini.nvim',
  dependencies = {
    {
      'JulienZD/copilot-statusline.nvim',
      opts = {},
    },
  },
  config = function()
    local statusline = require 'mini.statusline'

    -- This is the default active function, with the additions for copilot-statusline marked
    local active = function()
      local mode, mode_hl = statusline.section_mode { trunc_width = 100 }
      local git = statusline.section_git { trunc_width = 40 }
      local diff = statusline.section_diff { trunc_width = 75 }
      local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
      local lsp = statusline.section_lsp { trunc_width = 75 }
      local filename = statusline.section_filename { trunc_width = 140 }
      local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
      local location = statusline.section_location { trunc_width = 75 }
      local search = statusline.section_searchcount { trunc_width = 75 }

      -- This line below is added
      local copilot = require('copilot-statusline').section_copilot { trunc_width = 75 }

      return statusline.combine_groups {
        { hl = mode_hl, strings = { mode } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        -- This line below is added
        { hl = 'MiniStatuslineCopilot', strings = { copilot } },
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl, strings = { search, location } },
      }
    end

    statusline.setup {
      content = { active = active },
      use_icons = true,
    }
  end
}
```

### Credits

This plugin was mostly inspired by [copilot-lualine](https://github.com/AndreM222/copilot-lualine).
