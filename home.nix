{ config, pkgs, ... }:
let 
    home-manager = builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
    };
in
{
    imports = [
        (import "${home-manager}/nixos")
    ];
  

    home-manager.backupFileExtension = "bkp";

    home-manager.users.wowvain = {
    home.stateVersion = "24.05";
    
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "fiefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
        };
      };

      home.file = {
        # shells
        ".zshrc".source           = ./sources/zshrc.zsh;

        # dpi config for xorg
        ".Xresources".source      = ./sources/xresources.txt;

        # editors
        ".vimrc".source           = ./sources/vimrc.vim;

        # terminals
        ".config/alacritty/"      = { 
            source = ./sources/alacritty;
            recursive = true;
        };
        ".config/kitty/"          = {
            source = ./sources/kitty;
            recursive = true;
        };

        ".config/neofetch/"       = {
            source = ./sources/neofetch;
            recursive = true;
        };
        ".config/wofi/"           = {
            source = ./sources/wofi;
            recursive = true;
        };
        ".config/yazi/"           = {
            source = ./sources/yazi;
            recursive = true;
        };
        
        # wms 
        ".config/i3/"             = {
            source = ./sources/i3;
            recursive = true;
        };
        ".config/hypr"            = {
            source = ./sources/hypr;
            recursive = true;
        };

        # fonts
        ".local/share/fonts/"     = {
            source = ./fonts;
            recursive = true;
        }; 
      };
    };
}
