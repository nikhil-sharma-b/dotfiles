if vim.uv.os_uname().sysname ~= "Darwin" then
	return {}
end

return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "theme-sync",
		},
	},
	{
		name = "theme-sync-watcher",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		config = function()
			local colors_dir = vim.fn.expand("~/.config/theme-sync/generated")
			local watcher = vim.uv.new_fs_event()
			if not watcher then
				return
			end

			watcher:start(colors_dir, {}, function(error, filename)
				if error or filename ~= "nvim.lua" then
					return
				end
				vim.schedule(function()
					pcall(vim.cmd.colorscheme, "theme-sync")
					vim.cmd.redraw()
				end)
			end)

			_G.theme_sync_watcher = watcher
		end,
	},
}
