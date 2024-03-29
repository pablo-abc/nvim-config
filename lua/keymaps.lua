vim.g.mapleader = ","
vim.g.localleader = "\\"

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
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

map("n", "<leader>nh", ":noh<CR>", { desc = "Clear highlights" })
map("n", "<leader>tt", ":10split<CR>:terminal<CR>i", { desc = "Open terminal" })

-- Global mappings. Diagnostic
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostics float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })

-- Tabs
map("n", "<leader>to", ":tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tq", ":tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tl", ":tabn<CR>", { desc = "Next tab" })
map("n", "<leader>th", ":tabp<CR>", { desc = "Previous tab" })

-- Autocomplete
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

-- Tree
map("n", "<leader>e", ":Neotree toggle<CR>")

-- Git
map("n", "<leader>g", ":Neogit<CR>")

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- DAP
local dap = require("dap")
vim.keymap.set("n", "<leader>bc", dap.continue, {})
vim.keymap.set("n", "<leader>bo", dap.step_over, {})
vim.keymap.set("n", "<leader>bi", dap.step_into, {})
vim.keymap.set("n", "<leader>bt", dap.toggle_breakpoint, {})

local dapui = require("dapui")
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
