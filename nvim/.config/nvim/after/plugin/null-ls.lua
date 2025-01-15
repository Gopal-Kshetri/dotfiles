local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.isort,
		null_ls.builtins.formatting.gofumpt,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.ocamlformat,
		null_ls.builtins.diagnostics.cppcheck,
	},
	timeout = 5000,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
					-- vim.lsp.buf.format({ async = false }) -- for auto format on save
				end,
			})
		end
	end,
})
vim.keymap.set("n", "<leader>ft", vim.lsp.buf.format, {})