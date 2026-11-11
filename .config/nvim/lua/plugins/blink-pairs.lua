return {
	-- Disable LazyVim's default auto-pairs plugin
	{
		"nvim-mini/mini.pairs",
		enabled = false,
	},

	-- Customize blink.pairs colors using TokyoNight's palette
	{
		"folke/tokyonight.nvim",
		opts = function(_, opts)
			local original = opts.on_highlights

			opts.on_highlights = function(hl, c)
				if original then
					original(hl, c)
				end

				hl.BlinkPairsOrange = { fg = c.yellow }
				hl.BlinkPairsPurple = { fg = c.magenta }
				hl.BlinkPairsBlue = { fg = c.cyan }

				hl.BlinkPairsMatchParen = {
					bg = c.bg_highlight,
					bold = true,
				}

				hl.BlinkPairsUnmatched = {
					fg = c.red,
					bold = true,
					underline = true,
				}
			end
		end,
	},

	-- Keep your working blink.pairs configuration
	{
		"saghen/blink.pairs",
		dependencies = { "saghen/blink.lib" },
		version = "*",

		build = function()
			require("blink.pairs").download():pwait(60000)
		end,

		opts = {
			mappings = {
				enabled = true,
				cmdline = false,

				-- Disable optional Ctrl+B wrapping shortcuts
				wrap = {
					["<C-b>"] = false,
					["<C-S-b>"] = false,
				},

				-- disabled_filetypes = {
				-- 	"text",
				-- 	"markdown",
				-- },
			},

			highlights = {
				enabled = true,
				cmdline = false,

				matchparen = {
					enabled = true,
					cmdline = false,
					include_surrounding = true,
					group = "BlinkPairsMatchParen",
					priority = 250,
				},
			},
		},
	},
}
