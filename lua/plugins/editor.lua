vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_format = true
  end
end, {
  bang = true,
  desc = 'Disable autoformat on save',
})

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_format = false
end, {
  desc = 'Enable autoformat on save',
})

return {
  -- I commented line below because it mess up with my setup
  -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  { -- Autoformat
    'stevearc/conform.nvim',
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if vim.g.disable_format or vim.b[bufnr].disable_autoformat then
          return
        end

        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }

      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup()

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return ''
      end
    end,
  },

  { 'windwp/nvim-ts-autotag' },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc' },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
      }
    end,
  },

  { 'github/copilot.vim' },
}
