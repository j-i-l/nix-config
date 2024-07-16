{ pkgs, lib, config, userInfo, ... }:
  let
    nvim-spell-fr-utf8-dictionary = builtins.fetchurl {
      url = "http://ftp.vim.org/vim/runtime/spell/fr.utf-8.spl";
      sha256 = "abfb9702b98d887c175ace58f1ab39733dc08d03b674d914f56344ef86e63b61";
    };
    nvim-spell-fr-utf8-suggestions = builtins.fetchurl {
      url = "http://ftp.vim.org/vim/runtime/spell/fr.utf-8.sug";
      sha256 = "0294bc32b42c90bbb286a89e23ca3773b7ef50eff1ab523b1513d6a25c6b3f58";
    };
    nvim-spell-fr-latin1-dictionary = builtins.fetchurl {
      url = "http://ftp.vim.org/vim/runtime/spell/fr.latin1.spl";
      sha256 = "086ccda0891594c93eab143aa83ffbbd25d013c1b82866bbb48bb1cb788cc2ff";
    };
    nvim-spell-fr-latin1-suggestions = builtins.fetchurl {
      url = "http://ftp.vim.org/vim/runtime/spell/fr.latin1.sug";
      sha256 = "5cb2c97901b9ca81bf765532099c0329e2223c139baa764058822debd2e0d22a";
    };
  in {
    home.file."${config.xdg.configHome}/nvim/spell/fr.utf-8.spl".source = nvim-spell-fr-utf8-dictionary;
    home.file."${config.xdg.configHome}/nvim/spell/fr.utf-8.sug".source = nvim-spell-fr-utf8-suggestions;
    home.file."${config.xdg.configHome}/nvim/spell/fr.latin1.spl".source = nvim-spell-fr-latin1-dictionary;
    home.file."${config.xdg.configHome}/nvim/spell/fr.latin1.sug".source = nvim-spell-fr-latin1-suggestions;
    home.file."${config.xdg.configHome}/nvim/lua" = {
      recursive = true;
      source = ./lua;
    };
    programs = {
      neovim = {

        enable = true;
        extraConfig = ''
        	syntax on
          filetype on
          set expandtab
          set bs=2
          set tabstop=2
          set shiftwidth=2
          set autoindent
          set smartindent
          set smartcase
          set ignorecase
          set modeline
          set nocompatible
          set encoding=utf-8
          set hlsearch
          set history=700
          set t_Co=256
          set termguicolors
          set background=dark
          set tabpagemax=1000
          set ruler
          set nojoinspaces
          set shiftround
          set number relativenumber
          set clipboard+=unnamedplus

          set nolbr
          set tw=0

          " Visual mode pressing * or # searches for the current selection
          " Super useful! From an idea by Michael Naumann
          vnoremap <silent> * :call VisualSelection('f')<CR>
          vnoremap <silent> # :call VisualSelection('b')<CR>

          let mapleader = ","

          " Disable highlight when <leader><cr> is pressed
          map <silent> <leader><cr> :noh<cr>

          " Smart way to move between windows
          map <C-j> <C-W>j
          map <C-k> <C-W>k
          map <C-h> <C-W>h
          map <C-l> <C-W>l

          " nice try, Ex mode
          map Q <Nop>
          " who uses semicolon anyway?
          map ; :

          nnoremap gp `[v`]
          
          " File finder
          nmap <Leader>t :FZF<CR>
          nmap <Leader>h :Ag<CR>
          
          let g:syntastic_cpp_compiler = 'clang++'
          let g:syntastic_cpp_compiler_options = ' -std=c++11'
          let g:syntastic_c_include_dirs = [ 'src', 'build' ]
          let g:syntastic_cpp_include_dirs = [ 'src', 'build' ]

          let g:ycm_autoclose_preview_window_after_completion = 1

          let g:zig_fmt_autosave = 1

          hi clear SpellBad
          hi SpellBad cterm=underline
          " Set style for gVim
          hi SpellBad gui=undercurl

          " Telescope 
          nnoremap <leader>ff <cmd>Telescope find_files<cr>
          nnoremap <leader>fg <cmd>Telescope live_grep<cr>
          nnoremap <leader>fb <cmd>Telescope buffers<cr>
          nnoremap <leader>fh <cmd>Telescope help_tags<cr>
        '';
        withPython3 = true;
        viAlias = true;
        vimAlias = true;
        # TODO; checkout https://github.com/Kidsan/nixos-config/tree/main/home/programs/neovim/nvim
        plugins = with pkgs.vimPlugins; [
          coc-nvim
          coc-pyright
          pkgs.vimPlugins.nvim-tree-lua
          pkgs.vimPlugins.vim-startify
          pkgs.vimPlugins.fzfWrapper
          pkgs.vimPlugins.fzf-vim
          pkgs.vimPlugins.ack-vim
          pkgs.vimPlugins.vim-gitgutter
          pkgs.vimPlugins.plenary-nvim
          {
            plugin = nvim-colorizer-lua;
            type = "lua";
            config = builtins.readFile(./lua/colorizer.lua);
          }
          {
            plugin = lualine-nvim;
            type = "lua";
            config = builtins.readFile(./lua/lualine.lua);
          }
          {
            plugin = lazy-nvim;
            type = "lua";
            config = builtins.readFile(./lua/lazy-nvim.lua);
          }
          # pkgs.vimPlugins.neorg
          # pkgs.vimPlugins.neorg-telescope
          pkgs.vimPlugins.telescope-nvim
          pkgs.vimPlugins.nvim-notify
          pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          pkgs.vimPlugins.nvim-treesitter
          pkgs.vimPlugins.nui-nvim
          pkgs.vimPlugins.noice-nvim
          pkgs.vimPlugins.nvim-web-devicons
        ];
        extraPackages = with pkgs; [
          lua
          gcc
          nodejs
          fd
          ripgrep-all
          ack
	        silver-searcher
          (python3.withPackages (ps: with ps; [
            # black
            # flake8
          ]))
        ];
        extraPython3Packages = (ps: with ps; [
          setuptools
          # rope
          # pylama
          # jedi
        ]);
      };
    };

}
