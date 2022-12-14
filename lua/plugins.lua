local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'lukas-reineke/indent-blankline.nvim'

  use 'p00f/nvim-ts-rainbow'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end,
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
          'javascript',
          'html',
          'tsx',
          'svelte',
          'help',
          'clojure',
          'json',
          'vim',
          'lua',
          'css',
          'astro',
          'c',
          'scss',
          'typescript',
          'rust',
          'gitignore',
          'fennel',
          'teal',
          'go'
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
        highlight = {
          enable = true,
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },
      }
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
            },
          },
        },
      })
    end,
  }

  use {
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  }

  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {
        map_cr = false
      }
    end
  }

  use {
    'Olical/conjure',
    config = function()
      vim.g['conjure#extract#tree_sitter#enabled'] = true
    end
  }

  use {
    'clojure-vim/vim-jack-in',
    requires = {
      'tpope/vim-dispatch',
      'radenling/vim-dispatch-neovim',
    }
  }

  use 'gpanders/nvim-parinfer'

  use { 'neoclide/coc.nvim', branch = 'release' }

  use 'github/copilot.vim'

  use { 'dracula/vim', as = 'dracula' }

  use 'EdenEast/nightfox.nvim'

  use 'kdheepak/lazygit.nvim'

  use 'f-person/git-blame.nvim'

  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      require('neo-tree').setup({
        filesystem = {
          follow_current_file = true,
          use_libuv_file_watcher = true
        },
        buffers = {
          follow_current_file = true
        }
      })
    end
  }

  use 'gpanders/editorconfig.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require('lualine').setup() end
  }

  use {
    'folke/which-key.nvim',
    config = function()
      require("which-key").setup()
    end
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
