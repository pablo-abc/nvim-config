vim.g.mapleader = ','
vim.g.localleader = '\\'

-- Map keys with `silent` true by default
--@param mode string
--@param lhs string
--@param rhs string
--@param opts table?
--@return nil
--@usage map('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
--@usage map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
local function map(mode, lhs, rhs, opts)
  local options = { silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

map('n', '<leader>nh', ':noh<CR>')
map('n', '<leader>tt', ':10split<CR>:terminal<CR>i')


-- Tabs
map('n', '<leader>to', ':tabnew<CR>')
map('n', '<leader>tq', ':tabclose<CR>')
map('n', '<leader>tl', ':tabn<CR>')
map('n', '<leader>th', ':tabp<CR>')

-- Autocomplete
map(
  'i',
  '<CR>',
  function()
    if vim.fn['coc#pum#visible']() == 1 then
      return vim.fn['coc#pum#confirm']()
    else
      return require('nvim-autopairs').autopairs_cr()
    end
  end,
  { expr = true }
)

map('n', '<leader>K', ':call CocActionAsync("doHover")<CR>')

-- Tree
map('n', '<leader>e', ':Neotree toggle<CR>')

-- Git
map('n', '<leader>g', ':Neogit<CR>')
