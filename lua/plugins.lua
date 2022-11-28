-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
  }     

  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }

  use {'neoclide/coc.nvim', branch = 'release'}
 
  use {'dracula/vim', as = 'dracula'}

  use 'scrooloose/nerdtree'

  use 'ryanoasis/vim-devicons'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require('lualine').setup() end
  }
end)

