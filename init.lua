require('keymaps')
require('plugins')
require('treesitter-config')
require('telescope-config')

vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.title = true
vim.opt.guifont = "FiraCode Nerd Font Mono:h12"
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.cmd('command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument')
vim.cmd('colorscheme dracula')

vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeMinimalUI = 1
vim.g.NERDTreeIgnore = {}
vim.g.NERDTreeStatusLine = ''
vim.g.coc_global_extensions = { 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-eslint',
  'coc-sumneko-lua' }
