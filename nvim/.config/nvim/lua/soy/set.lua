-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- vim.opt.colorcolumn = "80"

-- vim.o.guifont = "Hack :h12:#h-slight"
vim.o.guifont = "JetBrainsMono :h12:#h-slight"

-- vim.opt.autocd

-- vim.api.nvim_set_keymap('', '<ScrollWheelLeft>', '<ScrollWheelRight>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('', '<ScrollWheelRight>', '<ScrollWheelLeft>', { noremap = true, silent = true })

vim.cmd('set mousescroll=hor:10')

-- vim.opt.scrolloff only for bottom of the editor
-- vim.opt.scrolloff = 5
vim.api.nvim_create_autocmd("CursorMoved", {
  group = vim.api.nvim_create_augroup("switchScrolloffTopBottom", { clear = true }),
  callback = function()
    if vim.fn.winline() < vim.o.lines/2 then
      vim.opt_local.scrolloff = 0
    else
      vim.opt_local.scrolloff = 5
    end
  end,
})
