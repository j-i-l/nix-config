require("lazy").setup({
      spec = {
        -- Import plugins from lua/plugins
        { import = "plugins" },
      },
      performance = {
        reset_packpath = false,
        rtp = {
            reset = false,
          }
        },
      dev = {
        -- TODO: needs fixing the path is not expanded
        path = "${pkgs.vimUtils.packDir config.home-manager.users.{userInfo.username}.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start",
        -- use local pattern for these plugins
        pattern = {};
      },
      install = {
        -- Safeguard in case we forget to install a plugin with Nix
        missing = false,
      }
})
