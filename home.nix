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

		xdg.desktopEntries.obsidian = {
			name = "obsidian";
			type = "Application";
			comment = "Knowledge base";
			categories = [ "Office" ];
			exec = "obsidian --disable-gpu %u";
			icon = "obsidian";
			mimeType = ["x-scheme-handler/obsidian"];
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


		home.packages = (with pkgs; [
			# Core
			zsh
			kitty
			git
			syncthing

			# Utils
			feh
			eza
			yazi
			hyprshot
			libnotify
			fontforge
			alsa-utils
			gnome.nautilus
			networkmanagerapplet
	
			# Rice
			mako
			swww
			wofi
			#waybar	
			#(pkgs.waybar.overrideAttrs (oldAttrs: {
			#	mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
			#}))
			neofetch
			imagemagick

			# Browsers
			firefox

			# Office
			obsidian
			openboard
			thunderbird
			libreoffice

			# Media
			vlc
			shutter
			obs-studio
			gnome.cheese

			# Social
			discord
			vesktop
			ferdium

			# Dev Editors
			vscode

			# Dev Libraries & Tools
			gcc
			gdb
			niv
			flex
			nasm
			sbctl
			bison
			libtool
			gnumake
			ncurses
			libiconv
			autoconf
			automake
			pkg-config
			makeWrapper

			fbset

			python3

			bfc
		]);

		home.sessionVariables = {
			EDITOR = userSettings.editor;
			BROWSER = userSettings.browser;
			TERM = userSettings.term;
		};
}
