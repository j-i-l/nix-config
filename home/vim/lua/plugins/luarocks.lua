return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
    luarocks_build_args = {
      -- NOTE: This path will be different for you.
      -- Find it with `nix-store --query $(which luajit)` Don't forget to add the `/include`
      -- "--with-lua-include=/nix/store/98blcb69q9qy0k279xjk10lcmfwnd4rg-luajit-2.1.1693350652/include",
      "--with-lua-include=${pkgs.vimUtils.packDir config.home-manager.users.{userInfo.username}.programs.lua.finalPackage.passthru.packpathDirs}/include",
    },
  },
}
