local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
	"wbthomason/packer.nvim",

	"lukas-reineke/indent-blankline.nvim",

	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"javascript",
					"html",
					"tsx",
					"svelte",
					"clojure",
					"json",
					"vim",
					"lua",
					"css",
					"astro",
					"c",
					"scss",
					"typescript",
					"rust",
					"gitignore",
					"fennel",
					"teal",
					"go",
					"toml",
					"markdown",
					"markdown_inline",
					"prisma",
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
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["aC"] = "@class.outer",
							["iC"] = "@class.inner",
						},
					},
				},
			})
		end,
	},

	"folke/neodev.nvim",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				automatic_installation = true,
			})
			require("neodev").setup({})
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			local mason_registry = require("mason-registry")
			local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
				.. "/node_modules/@vue/language-server"

			lspconfig.tsserver.setup({
				capabilities = capabilities,
				init_options = {
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vue_language_server_path,
							languages = { "vue" },
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})

			lspconfig.volar.setup({
				capabilities = capabilities,
			})

			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
			})

			lspconfig.eslint.setup({
				capabilities = capabilities,
				---@diagnostic disable-next-line: unused-local
				on_attach = function(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})

			lspconfig.astro.setup({
				capabilities = capabilities,
			})

			lspconfig.cssmodules_ls.setup({
				capabilities = capabilities,
			})

			lspconfig.svelte.setup({
				capabilities = capabilities,
			})

			lspconfig.tailwindcss.setup({})
		end,
	},

	"hrsh7th/cmp-vsnip",
	"hrsh7th/vim-vsnip",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",

	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
						-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
						-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
						-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					end,
				},
				window = {
					-- completion = cmp.config.window.bordered(),
					-- documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "vsnip" }, -- For vsnip users.
					-- { name = 'luasnip' }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},

	{
		"mfussenegger/nvim-dap",
		config = function()
			local packagespath = vim.fn.stdpath("data") .. "/mason/packages"
			local dap = require("dap")
			dap.adapters.chrome = {
				type = "executable",
				command = "node",
				args = { packagespath .. "/chrome-debug-adapter/out/src/chromeDebug.js" },
			}

			dap.adapters.firefox = {
				type = "executable",
				command = "node",
				args = { packagespath .. "/firefox-debug-adapter/dist/adapter.bundle.js" },
			}

			local debuggers = { -- change this to javascript if needed
				{
					name = "Debug with Chrome",
					type = "chrome",
					request = "attach",
					program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
					port = 9222,
					webRoot = "${workspaceFolder}",
				},
				{
					name = "Debug with Firefox",
					type = "firefox",
					request = "launch",
					reAttach = true,
					url = "http://localhost:3000",
					webRoot = "${workspaceFolder}",
					firefoxExecutable = "/Applications/Firefox Developer Edition.app/Contents/MacOS/firefox",
				},
			}

			dap.configurations.javascript = debuggers
			dap.configurations.typescript = debuggers
			dap.configurations.javascriptreact = debuggers
			dap.configurations.typescriptreact = debuggers
			dap.configurations.vue = debuggers
			dap.configurations.svelte = debuggers
			dap.configurations.astro = debuggers
		end,
	},

	{ "theHamsta/nvim-dap-virtual-text", opts = {} },
	{ "rcarriga/nvim-dap-ui", opts = {}, dependencies = { "mfussenegger/nvim-dap" } },

	"mfussenegger/nvim-lint",

	{
		"mhartington/formatter.nvim",
		config = function()
			require("formatter").setup({
				filetype = {
					typescript = {
						require("formatter.filetypes.typescript").prettier,
					},
					typescriptreact = {
						require("formatter.filetypes.typescriptreact").prettier,
					},
					javascript = {
						require("formatter.filetypes.javascript").prettier,
					},
					astro = {
						require("formatter.defaults.prettierd"),
					},
					javascriptreact = {
						require("formatter.filetypes.javascriptreact").prettier,
					},
					json = {
						require("formatter.filetypes.json").prettier,
					},
					vue = {
						require("formatter.filetypes.vue").prettier,
					},
					svelte = {
						require("formatter.filetypes.svelte").prettier,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					["*"] = {
						require("formatter.filetypes.any").remove_trailing_whitespace,
					},
				},
			})
			local augroup = vim.api.nvim_create_augroup
			local autocmd = vim.api.nvim_create_autocmd
			augroup("__formatter__", { clear = true })
			autocmd("BufWritePost", {
				group = "__formatter__",
				command = ":FormatWrite",
			})
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		opts = {},
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({
				map_cr = false,
			})
		end,
	},
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},

	{
		"nvim-neorg/neorg",
		version = "*",
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.concealer"] = {}, -- Adds pretty icons to your documents
					["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
					["core.integrations.nvim-cmp"] = {},
					["core.integrations.telescope"] = {},
					["core.keybinds"] = {
						-- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
						config = {
							default_keybinds = true,
							neorg_leader = "<Leader><Leader>",
						},
					},
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								norg = "~/norg",
							},
							default_workspace = "norg",
						},
					},
				},
			})
			local neorg_callbacks = require("neorg.core.callbacks")

			---@diagnostic disable-next-line: missing-parameter
			neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
				-- Map all the below keybinds only when the "norg" mode is active
				keybinds.map_event_to_mode("norg", {
					n = { -- Bind keys in normal mode
						{ "<C-s>", "core.integrations.telescope.find_linkable" },
					},

					i = { -- Bind in insert mode
						{ "<C-l>", "core.integrations.telescope.insert_link" },
					},
				}, {
					silent = true,
					noremap = true,
				})
			end)

			local autocmd = vim.api.nvim_create_autocmd
			autocmd({ "BufRead", "BufEnter" }, {
				pattern = "*.norg",
				command = "setlocal conceallevel=2",
			})
		end,
		dependencies = {
			"luarocks.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-neorg/neorg-telescope",
		},
	},

	{
		"Olical/conjure",
		config = function()
			vim.g["conjure#extract#tree_sitter#enabled"] = true
		end,
	},

	{
		"clojure-vim/vim-jack-in",
		dependencies = {
			"tpope/vim-dispatch",
			"radenling/vim-dispatch-neovim",
		},
	},

	"gpanders/nvim-parinfer",

	"Exafunction/codeium.vim",

	{ "dracula/vim", name = "dracula" },

	"EdenEast/nightfox.nvim",

	"kdheepak/lazygit.nvim",

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},

	{ "akinsho/git-conflict.nvim", version = "*", config = true },

	"f-person/git-blame.nvim",

	{
		"stevearc/oil.nvim",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			require("neo-tree").setup({
				filesystem = {
					follow_current_file = true,
					use_libuv_file_watcher = true,
				},
				buffers = {
					follow_current_file = true,
				},
			})
		end,
	},

	"gpanders/editorconfig.nvim",

	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		requires = { { "nvim-lua/plenary.nvim" } },
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons", lazy = true },
		opts = {},
	},

	{
		"folke/which-key.nvim",
		opts = {},
	},
})
