-- [[ Setting options ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false

vim.o.number = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

-- [[ Basic Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },
	virtual_text = true,
	virtual_lines = false,
	jump = { float = true },
})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- [[ Native Package Management (Neovim 12) ]]

-- Simple utilities
vim.pack.add({ "NMAC427/guess-indent.nvim" })
require("guess-indent").setup({})

-- Git Signs
vim.pack.add({ "lewis6991/gitsigns.nvim" })
require("gitsigns").setup({
	signs = {
		add = { text = "+" },
		change = { text = "~" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
	},
})

-- Which-key
vim.pack.add({ "folke/which-key.nvim" })
require("which-key").setup({
	delay = 0,
	icons = { mappings = vim.g.have_nerd_font },
	spec = {
		{ "<leader>s", group = "[S]earch", mode = { "n", "v" } },
		{ "<leader>t", group = "[T]oggle" },
		{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
		{ "<leader>r", group = "[R]ender" },
	},
})

-- Telescope & Dependencies
vim.pack.add({
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-telescope/telescope-ui-select.nvim",
})
if vim.fn.executable("make") == 1 then
	vim.pack.add("nvim-telescope/telescope-fzf-native.nvim")
end

require("telescope").setup({
	extensions = {
		["ui-select"] = { require("telescope.themes").get_dropdown() },
	},
})
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

-- LSP Configuration
-- TODO: I think this can be slimmed down
vim.pack.add({
	"neovim/nvim-lspconfig",
	"mason-org/mason.nvim",
	"mason-org/mason-lspconfig.nvim",
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	"j-hui/fidget.nvim",
	"saghen/blink.cmp",
})

require("mason").setup()
require("mason-lspconfig").setup()
require("fidget").setup({})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end
		map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
		map("grd", builtin.lsp_definitions, "[G]oto [D]efinition")
		map("grr", builtin.lsp_references, "[G]oto [R]eferences")
	end,
})

local capabilities = require("blink.cmp").get_lsp_capabilities()
local servers = { clangd = {}, pyright = {}, ts_ls = {}, lua_ls = {} }

for name, server in pairs(servers) do
	server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
	vim.lsp.config(name, server)
	vim.lsp.enable(name)
end

-- Formatter
vim.pack.add({ "stevearc/conform.nvim" })
require("conform").setup({
	formatters_by_ft = { lua = { "stylua" } },
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})

-- Completion (Blink)
require("blink.cmp").setup({
	keymap = { preset = "default" },
	sources = { default = { "lsp", "path", "snippets" } },
})

-- Colorscheme
vim.pack.add({ "Yazeed1s/minimal.nvim" })
vim.cmd.colorscheme("minimal")

-- UI/Comments
vim.pack.add({ "folke/todo-comments.nvim" })
require("todo-comments").setup({ signs = false })

-- Mini Modules
vim.pack.add({ "nvim-mini/mini.nvim" })
require("mini.ai").setup()
require("mini.surround").setup()
require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })

-- Treesitter
vim.pack.add({ "nvim-treesitter/nvim-treesitter" })
local ts_filetypes = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc" }
require("nvim-treesitter").install(ts_filetypes)
vim.api.nvim_create_autocmd("FileType", {
	pattern = ts_filetypes,
	callback = function()
		vim.treesitter.start()
	end,
})

vim.pack.add({ "OXY2DEV/markview.nvim" })

require("markview").setup({ initial_state = false })
vim.keymap.set("n", "<leader>rm", function()
	vim.cmd("Markview toggle")
end, { silent = true, desc = "Toggle [R]ender [M]arkdown" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		local ok, latex = pcall(require, "custom.functions.latex")
		if ok then
			vim.keymap.set("n", "<leader>rl", latex.compile_latex, { buffer = true, desc = "[R]ender [L]atex" })
		end
	end,
})
