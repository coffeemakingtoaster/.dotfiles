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

-- `vim.pack.add()` requires full URLs; "owner/repo" shorthand is not supported.
local function gh(repo)
	return "https://github.com/" .. repo
end

-- Build step for plugins that need compilation after install/update.
-- See `:help vim.pack-events`
local function run_build(name, cmd, cwd)
	local result = vim.system(cmd, { cwd = cwd }):wait()
	if result.code ~= 0 then
		local output = (result.stderr ~= "" and result.stderr) or result.stdout or "No output from build command."
		vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name = ev.data.spec.name
		local kind = ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end
		if name == "telescope-fzf-native.nvim" and vim.fn.executable("make") == 1 then
			run_build(name, { "make" }, ev.data.path)
		end
	end,
})

-- Simple utilities
vim.pack.add({ gh("NMAC427/guess-indent.nvim") })
require("guess-indent").setup({})

-- Git Signs
vim.pack.add({ gh("lewis6991/gitsigns.nvim") })
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
vim.pack.add({ gh("folke/which-key.nvim") })
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
	gh("nvim-lua/plenary.nvim"),
	gh("nvim-telescope/telescope.nvim"),
	gh("nvim-telescope/telescope-ui-select.nvim"),
})
if vim.fn.executable("make") == 1 then
	vim.pack.add({ gh("nvim-telescope/telescope-fzf-native.nvim") })
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
vim.pack.add({
	gh("neovim/nvim-lspconfig"),
	gh("mason-org/mason.nvim"),
	gh("j-hui/fidget.nvim"),
	{ src = gh("saghen/blink.cmp"), version = vim.version.range("1.*") },
})

require("mason").setup()
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
vim.pack.add({ gh("stevearc/conform.nvim") })
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
vim.pack.add({ gh("Yazeed1s/minimal.nvim") })
vim.cmd.colorscheme("minimal")
-- minimal.nvim sets `g:colors_name` before its own `:hi clear`, which resets it
vim.g.colors_name = "minimal"

-- UI/Comments
vim.pack.add({ gh("folke/todo-comments.nvim") })
require("todo-comments").setup({ signs = false })

-- Mini Modules
vim.pack.add({ gh("nvim-mini/mini.nvim") })
require("mini.ai").setup()
require("mini.surround").setup()
require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })

-- Treesitter
vim.pack.add({ { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" } })
local ts_languages = { "bash", "c", "html", "lua", "markdown", "markdown_inline", "vim", "vimdoc" }
require("nvim-treesitter").install(ts_languages)

---@param buf integer
---@param language string
local function treesitter_try_attach(buf, language)
	-- Check if a parser exists and load it
	if not vim.treesitter.language.add(language) then
		return
	end
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.treesitter.start(buf, language)
end

local available_parsers = require("nvim-treesitter").get_available()
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local language = vim.treesitter.language.get_lang(args.match)
		if not language then
			return
		end
		local installed_parsers = require("nvim-treesitter").get_installed("parsers")
		if vim.tbl_contains(installed_parsers, language) then
			treesitter_try_attach(args.buf, language)
		elseif vim.tbl_contains(available_parsers, language) then
			require("nvim-treesitter").install(language):await(function()
				treesitter_try_attach(args.buf, language)
			end)
		else
			treesitter_try_attach(args.buf, language)
		end
	end,
})

vim.pack.add({ gh("OXY2DEV/markview.nvim") })

require("markview").setup({ preview = { enable = false } })
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
