local opt = vim.opt

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
if not vim.g.vscode then
	opt.guifont = "FiraCode Nerd Font Mono:h12"
end
opt.splitbelow = true
opt.splitright = true
opt.clipboard = "unnamed"

-- vim.cmd('command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument')
if not vim.g.vscode then
	vim.cmd("colorscheme nordfox")
end
