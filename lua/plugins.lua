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

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
      ts_update()
    end
  }

  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

  use { 'neoclide/coc.nvim', branch = 'release' }

  use { 'dracula/vim', as = 'dracula' }

  use 'EdenEast/nightfox.nvim'

  use {
    'kyazdani42/nvim-tree.lua',
    config = function() require('nvim-tree').setup() end
  }

  use 'ryanoasis/vim-devicons'

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
