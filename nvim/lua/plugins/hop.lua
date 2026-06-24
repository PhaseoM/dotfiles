return {
	"phaazon/hop.nvim",
	branch = "v2", -- optional but strongly recommended
	config = function()
		-- you can configure Hop the way you like here; see :h hop-config
		require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })

		-- place this in one of your configuration file(s)
		local hop = require("hop")
		local directions = require("hop.hint").HintDirection
		vim.keymap.set("", "<leader><leader>w", function()
			hop.hint_words()
		end, { remap = true })
		vim.keymap.set("", "<leader><leader>s", function()
			hop.hint_lines_skip_whitespace()
		end, { remap = true })
		vim.keymap.set("", "<leader><leader>j", function()
			hop.hint_words({ direction = directions.AFTER_CURSOR, current_line_only = false })
		end, { remap = true })
		vim.keymap.set("", "<leader><leader>k", function()
			hop.hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = false })
		end, { remap = true })
		vim.keymap.set("", "<leader><leader>l", function()
			hop.hint_words({ direction = directions.AFTER_CURSOR, current_line_only = true })
		end, { remap = true })
		vim.keymap.set("", "<leader><leader>h", function()
			hop.hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = true })
		end, { remap = true })
	end,
}
