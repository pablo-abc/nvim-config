vim.g.mapleader = ' '

local keymap = vim.keymap

keymap.set('n', '<leader>nh', ':noh<CR>')
keymap.set('n', '<leader>tt', ':10split<CR>:terminal<CR>i')


-- Tabs
keymap.set('n', '<leader>to', ':tabnew<CR>')
keymap.set('n', '<leader>tq', ':tabclose<CR>')
keymap.set('n', '<leader>tl', ':tabn<CR>')
keymap.set('n', '<leader>th', ':tabp<CR>')

-- Autocomplete
keymap.set(
  'i',
  '<CR>',
  function()
    if vim.fn['coc#pum#visible']() == 1 then
      return vim.fn['coc#pum#confirm']()
    else
      return '<CR>'
    end
  end,
  { expr = true }
)

keymap.set('n', 'K', ':call CocActionAsync("doHover")<CR>')

-- Tree
keymap.set('n', '<leader>e', ':Neotree toggle<CR>')

-- Git
keymap.set('n', '<leader>g', ':Neogit<CR>')
