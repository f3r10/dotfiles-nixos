{ pkgs, config, ... }:

{
    enable = true;
    plugins = with pkgs.vimPlugins; [
        # File tree
        nvim-web-devicons 
        nvim-tree-lua

        # Languages
        vim-nix

        # Eyecandy 
        nvim-treesitter
        #nvim-treesitter-pairs it does not exist on nix
        nvim-ts-rainbow
        bufferline-nvim
        galaxyline-nvim
        nvim-colorizer-lua

        # Lsp and completion
        nvim-lspconfig
        nvim-cmp
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        cmp-cmdline
        luasnip
        cmp_luasnip
        friendly-snippets

        #others
        #tabout-nvim it does not exist on nix
        nvim-dap
        #nvim-metals
        #scala-utils-nvim
        onedark-nvim
        vim-abolish
        vim-surround
        vim-vinegar
        vim-fugitive
        vim-rhubarb
        vim-highlightedyank
        vim-obsession
        #nvim-jvmopts
        goyo-vim
        nvim-bqf
        nvim-web-devicons
        gitsigns-nvim
        vista-vim
        vim-polyglot
        nvim-autopairs
        #stylua-nvim
        registers-nvim
        hop-nvim
        lazygit-nvim
        #nvim-lsp-compose
        lsp_signature-nvim
        toggleterm-nvim
        #nvim-ts-autotag
        auto-session
        #git-utils-nvim
        comment-nvim
        nvim-ts-context-commentstring
        nvim-lsp-ts-utils
        trouble-nvim
        rust-tools-nvim
        #startuptime-vim
        todo-comments-nvim
        #nvim-neoclip-lua
        #fm-nvim
        null-ls-nvim
        vim-bbye
        #impatient-nvim

        # Telescope
        telescope-nvim
        popup-nvim
        plenary-nvim
        telescope-fzy-native-nvim

        # Indent lines
        indent-blankline-nvim
    ];
    extraConfig = ''
	set runtimepath^=${./lua}
        luafile ${./lua}/init.lua
    '';
}
