return {
	{
		"nvim-neotest/neotest",
		cmd = {
			"NTestRun",
			"NTestRunNearest",
			"NTestStopNearest",
			"NTestSummaryOpen",
			"NTestSummaryClose",
			"NTestSummaryToggle",
			"NTestOutput",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-plenary",
			"nvim-neotest/neotest-vim-test",
            "nvim-neotest/nvim-nio"
		},
		config = function()
			require("neotest").setup({
				diagnostic = {
					enabled = true,
				},
				adapters = {
					require("neotest-python"),
					require("neotest-vim-test")({ allow_file_types = { "python" } }),
				},

				highlights = {
					passed = "NeotestPassed",
					running = "NeotestRunning",
					failed = "NeotestFailed",
					skipped = "NeotestSkipped",
					test = "NeotestTest",
					namespace = "NeotestNamespace",
					focused = "NeotestFocused",
					file = "NeotestFile",
					dir = "NeotestDir",
					border = "NeotestBorder",
					indent = "NeotestIndent",
					expand_marker = "NeotestExpandMarker",
					adapter_name = "NeotestAdapterName",
					select_win = "NeotestWinSelect",
					marked = "NeotestMarked",
				},

				icons = {
					expanded = "",
					collapsed = "",
					passed = "✅",
					running = "✨",
					failed = "❌",
					unknown = "❔",
				},
			})

			-- Create commands
			vim.cmd([[
                command! NTestRun lua require("neotest").run.run(vim.fn.expand("%"))
                command! NTestRunNearest lua require("neotest").run.run()
                command! NTestStopNearest lua require("neotest").run.stop()
                command! NTestSummaryOpen lua require("neotest").summary.open()
                command! NTestSummaryClose lua require("neotest").summary.close()
                command! NTestSummaryToggle lua require("neotest").summary.toggle()
                command! NTestOutput lua require("neotest").output.open({ enter = true })
            ]])
		end,
	},
}
