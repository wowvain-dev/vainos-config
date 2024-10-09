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
        ".zshrc".source         = ./sources/zshrc.zsh;
        ".Xresources".source    = ./sources/xresources.txt;
        ".vimrc".source         = ./sources/vimrc.vim;
        ".config/i3/".source    = ./sources/i3;
        ".config/i3/".recursive = true;

        #".config/i3/"           = {
        #    source = ./sources/i3;
        #    recursive = true;
        #};
      };
    };
}
