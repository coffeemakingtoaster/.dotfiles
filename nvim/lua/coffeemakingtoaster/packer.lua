-- Only required if you have packer configured as `opt`
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- My plugins 

  use 'wbthomason/packer.nvim'
  use { 
    'olivercederborg/poimandres.nvim',
    config = function()
      require('poimandres').setup {
      -- leave this setup function empty for default config
      -- or refer to the configuration section
      -- for configuration options
      }
    end
  }
  use 'davidhalter/jedi-vim'
  use {'neoclide/coc.nvim', branch = 'release'}
  use {'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons', opt = true }}
  use 'neovim/nvim-lspconfig'

  use{
	'nvim-telescope/telescope.nvim', tag = '0.1.0',
	requires={{'nvim-lua/plenary.nvim'}}
  }

	-- install without yarn or npm
  use({
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end,
  })

  use 'iamcco/mathjax-support-for-mkdp'
	
  -- Command autocomplete
  use {
  'gelguy/wilder.nvim',
  config = function()
    -- config goes here
  end,
  }
  
  -- Plugin Zone end
  -- Packer sync to ensure plugins are installed 
  require('packer').sync()

  -- Startup lua line
  require('lualine').setup{ opts = { theme = iceberg_dark } }

  -- Startup neovim/nvim-lspconfig
  require('lspconfig')['tsserver'].setup{
	on_attach=on_attach,
	flags=lsp_flags,
  }

  require'lspconfig'.clojure_lsp.setup{
	on_attach=on_attach,
	flags=lsp_flags,
  }
	
  require('telescope').setup()
  local tl_bldin = require('telescope.builtin')
  vim.keymap.set('n','ff',tl_bldin.find_files, {})
  vim.keymap.set('n', 'fb', tl_bldin.buffers, {})
	
  -- Activate vim command autocomplete
  require('wilder').setup({modes = {':', '/', '?'}})


end)

