return require("packer").startup(function(use)
  -- Packer can manage itself
  use { "wbthomason/packer.nvim", opt = true }
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/popup.nvim" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzy-native.nvim" },
    },
  }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      -- { "hrsh7th/cmp-vsnip" },
      -- { "hrsh7th/vim-vsnip" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
      { "rafamadriz/friendly-snippets" },
    },
  }
  use { "abecodes/tabout.nvim" }

  use { "mfussenegger/nvim-dap" }
  use {
    "scalameta/nvim-metals",
    requires = {
      { "nvim-lua/plenary.nvim" },
    },
  }
  -- use { "chriskempson/base16-vim" }
  -- use { "joshdick/onedark.vim" }
  -- use { "ful1e5/onedark.nvim" }
  use { "monsonjeremy/onedark.nvim" }
  use { "glepnir/galaxyline.nvim" }
  use { "neovim/nvim-lspconfig" }

  -- substitute, search, and abbreviate multiple variants of a word
  -- ex -> :%Subvert/facilit{y,ies}/building{,s}/g
  use { "tpope/vim-abolish" }

  --insert or delete brackets, parens, quotes in pair
  -- it looks it is the same as nvim-autopairs
  -- use({"jiangmiao/auto-pairs"})

  -- mappings to easily delete, change and add such surroundings in pairs, such as quotes, parens, etc.
  use { "tpope/vim-surround" }

  -- netrw helper
  use { "tpope/vim-vinegar" }

  use { "tpope/vim-fugitive" }
  -- hub extension for fugitive"
  use { "tpope/vim-rhubarb" }

  --Show the select of the yank
  use { "machakann/vim-highlightedyank" }

  -- Save current vim session
  use { "tpope/vim-obsession" }

  --- to test

  use { "ckipp01/nvim-jvmopts" }

  use { "junegunn/goyo.vim", opt = true }
  use { "kevinhwang91/nvim-bqf" }
  use { "kyazdani42/nvim-web-devicons" }

  use {
    "lewis6991/gitsigns.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
    },
  }
  use { "liuchengxu/vista.vim" }
  -- use({ "machakann/vim-sandwich" }) -> the same as vim-surround
  --
  --:ColorizerToggle
  use { "norcalli/nvim-colorizer.lua" }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "theHamsta/nvim-treesitter-pairs",
      "p00f/nvim-ts-rainbow",
    },
  }

  use {
    "ckipp01/scala-utils.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }
  use { "sheerun/vim-polyglot" }
  use { "windwp/nvim-autopairs" }

  -- use({ "Yggdroot/indentLine" }) replace by:
  --
  use { "lukas-reineke/indent-blankline.nvim" }

  use { "ckipp01/stylua-nvim" }
  -- use({"scrooloose/nerdtree"})
  -- use({"Xuyuanp/nerdtree-git-plugin"})

  use {
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
  }

  -- check what it is on the registers with " and @
  -- use { "junegunn/vim-peekaboo" }
  use { "tversteeg/registers.nvim" }
  -- move around typing a few keys
  use { "phaazon/hop.nvim" }
  -- enhanced features for the default / search
  -- use ({"haya14busa/is.vim"})

  use { "kdheepak/lazygit.nvim" }

  use { "sentriz/nvim-lsp-compose" }

  use { "ray-x/lsp_signature.nvim" }

  use { "nvim-lua/plenary.nvim" }

  use { "akinsho/toggleterm.nvim" }

  use { "windwp/nvim-ts-autotag" }

  use { "rmagatti/auto-session" }

  use { "Nguyen-Hoang-Nam/git-utils.nvim" }

  use { "windwp/windline.nvim" }

  use { "akinsho/bufferline.nvim", requires = "kyazdani42/nvim-web-devicons" }

  use "numToStr/Comment.nvim"
  use { "JoosepAlviste/nvim-ts-context-commentstring" }

  use { "jose-elias-alvarez/nvim-lsp-ts-utils" }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }

  use { "simrat39/rust-tools.nvim" }

  use { "tweekmonster/startuptime.vim" }

  use {
    "folke/todo-comments.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  }

  -- use {
  --   "TimUntersberger/neogit",
  --   requires = { "nvim-lua/plenary.nvim" },
  -- }
  use {
    "AckslD/nvim-neoclip.lua",
  }

  use { "is0n/fm-nvim" }

  use "jose-elias-alvarez/null-ls.nvim"

  use "moll/vim-bbye"

  use "lewis6991/impatient.nvim"

end)
