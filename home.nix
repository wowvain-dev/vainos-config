{ config, pkgs, systemSettings, userSettings, inputs, ... }:
{
		home.username = userSettings.username;
		home.homeDirectory = userSettings.homeDir;

		programs.home-manager.enable = true;
		
    # home-manager.backupFileExtension = "bkp";
		#home.backupFileExtension = "bkp";
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
        ".config/alacritty/"      = { source = ./sources/alacritty; recursive = true; };
        ".config/kitty/"          = { source = ./sources/kitty; recursive = true; };
        ".config/neofetch/"       = { source = ./sources/neofetch; recursive = true; };
        ".config/wofi/"           = { source = ./sources/wofi; recursive = true; };
        ".config/yazi/"           = { source = ./sources/yazi; recursive = true; };
        ".config/mako/"           = { source = ./sources/mako; recursive = true; };
        ".config/waybar/"         = { source = ./sources/waybar; recursive = true; };
        # wms 
        ".config/i3/"             = { source = ./sources/i3; recursive = true; };
        ".config/hypr"            = { source = ./sources/hypr; recursive = true; };
        # fonts
        ".local/share/fonts/"     = { source = ./fonts; recursive = true; }; 
      };

		home.sessionVariables = {
			EDITOR = userSettings.editor;
			BROWSER = userSettings.browser;
			TERM = userSettings.term;
		};
}
