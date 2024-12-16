-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    -- import your plugins
    {
      'catppuccin/nvim',
      name = 'catppuccin',
      lazy = false, -- make sure we load this during startup if it is your main colorscheme
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
        -- load the colorscheme here
        vim.cmd.colorscheme 'catppuccin-mocha'
      end
    },
    {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
      config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
        vim.keymap.set('n', '<leader><leader>', builtin.oldfiles, { desc = 'Telescope previously open files' })
      end
    },
    {
      'nvim-telescope/telescope-ui-select.nvim',
      config = function()
        require('telescope').setup ({
          extensions = {
            ['ui-select'] = {
              require('telescope.themes').get_dropdown {
              }
            }
          }
        })
        require('telescope').load_extension('ui-select')
      end
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function ()
        local config = require('nvim-treesitter.configs')
        config.setup({
          auto_install = true,
          highlight = { enable = true },
          indent = {enable = true },
        })
      end
    },
    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v3.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
        'MunifTanjim/nui.nvim',
        '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
      }
    },
    {
      'nvim-lualine/lualine.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('lualine').setup({options = { theme = 'dracula' }})
      end
    },
    {
      'williamboman/mason.nvim',
      lazy = false,
      config = function()
        require('mason').setup()
      end
    },
    {
      'williamboman/mason-lspconfig.nvim',
      lazy = false,
      opts = {
        auto_install = true,
      },
    },
    {
      'neovim/nvim-lspconfig',
      lazy = false,
      config = function()
        local lspconfig = require('lspconfig')
        lspconfig.lua_ls.setup({})
        lspconfig.ts_ls.setup({})
        lspconfig.clangd.setup({})
	      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
        vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, {})
        vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, {})
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
      end
    },
    {
      'ThePrimeagen/vim-be-good'
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- automatically check for plugin updates
  checker = { enabled = true },
})
