{ pkgs, lib, config, ... }:
{
  programs = {
    neovim = {
      enable =true;
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
      '';
      withPython3 = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        coc-nvim
        coc-pyright
        pkgs.vimPlugins.nvim-tree-lua
        pkgs.vimPlugins.vim-startify
        pkgs.vimPlugins.fzfWrapper
        pkgs.vimPlugins.fzf-vim
        pkgs.vimPlugins.ack-vim
        pkgs.vimPlugins.vim-gitgutter
      ];
      extraPackages = with pkgs; [
        nodejs_21
        ack
	      silver-searcher
        (python3.withPackages (ps: with ps; [
          black
          flake8
        ]))
      ];
      extraPython3Packages = (ps: with ps; [
        jedi
      ]);
    };
  };
}
