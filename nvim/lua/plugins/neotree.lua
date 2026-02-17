return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				-- buffers = {
				-- 	follow_current_file = true,
				-- },
				filesystem = {
					-- follow_current_file = true,
					window = {
						width = 30,
					},
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_by_name = {
							"node_modules",
						},
						never_show = {
							".DS_Store",
							"thumbs.db",
						},
					},
				},
			})
		end,
	},
	{
		"antosha417/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
	{
		"s1n7ax/nvim-window-picker",
		version = "2.*",
		config = function()
			require("window-picker").setup({
				filter_rules = {
					include_current_win = false,
					autoselect_one = true,
					-- filter using buffer options
					bo = {
						-- if the file type is one of following, the window will be ignored
						filetype = { "neo-tree", "neo-tree-popup", "notify" },
						-- if the buffer type is one of following, the window will be ignored
						buftype = { "terminal", "quickfix" },
					},
				},
			})
		end,
	},
	vim.keymap.set(
		"n",
		"<leader>e",
		":Neotree toggle position=left<CR>",
		{ noremap = true, silent = true, desc = "Neotree toggle" }
	), -- focus file explorer
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function()
			local bg = "#1F1928"

			vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = bg })
			vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = bg })
		end,
	}),
}
