local generated = vim.fn.expand("~/.config/theme-sync/generated/nvim.lua")
if vim.fn.filereadable(generated) == 1 then
	dofile(generated)
end
