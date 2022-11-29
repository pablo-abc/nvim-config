local opt = vim.opt
local g = vim.g

opt.swapfile = false
opt.termguicolors = true
opt.autoindent = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.title = true
opt.guifont = "FiraCode Nerd Font Mono:h12"
opt.splitbelow = true
opt.splitright = true

vim.cmd('command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument')
vim.cmd('colorscheme nordfox')

g.coc_global_extensions = {
  'coc-css',
  'coc-html',
  'coc-json',
  'coc-prettier',
  'coc-tsserver',
  'coc-eslint',
  'coc-sumneko-lua'
}
