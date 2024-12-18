-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['d'] = 'trash',
          ['D'] = 'delete',
        },
      },
      commands = {
        trash = function(state)
          local inputs = require 'neo-tree.ui.inputs'
          local utils = require 'neo-tree.utils'
          local path = state.tree:get_node().path
          local _, name = utils.split_path(path)

          local msg = string.format("Are you sure you want to trash '%s'?", name)

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end

            vim.fn.system { 'gio', 'trash', path }

            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,

        trash_visual = function(state, selected_nodes)
          local inputs = require 'neo-tree.ui.inputs'
          local msg = 'Are you sure you want to trash ' .. #selected_nodes .. ' files ?'

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            for _, node in ipairs(selected_nodes) do
              vim.fn.system { 'gio', 'trash', node.path }
            end

            require('neo-tree.sources.manager').refresh(state.name)
          end)
        end,
      },
    },
  },
}
