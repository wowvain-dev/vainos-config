# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, systemSettings, userSettings,  pkgs, inputs, ... }:
let 
	sources = import ./nix/sources.nix;
	lanzaboote = import sources.lanzaboote;
in 
{

  #imports =
  #  [ # Include the results of the hardware scan.
  #    ./hardware-configuration.nix 
  #			./home.nix
#      lanzaboote.nixosModules.lanzaboote
  #  ];
	imports = [
		./hardware-configuration.nix
		lanzaboote.nixosModules.lanzaboote
	];


  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "ntfs" ];
	#boot.loader.systemd-boot.enable = if (systemSettings.bootMode == "uefi") then true else false;
  #boot.loader.efi.canTouchEfiVariables = if (systemSettings.bootMode == "uefi") then true else false;
  #boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath; 
	boot.loader.systemd-boot.enable = lib.mkForce false;
	boot.loader.efi.canTouchEfiVariables = true;
  systemd.enableEmergencyMode = false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

	networking.hostName = systemSettings.hostname;
	networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;
	
  security.sudo.enable = true;

	users.users.${userSettings.username} = {
		isNormalUser = true;
		home = userSettings.homeDir;
		description = userSettings.name;
		extraGroups = [ "networkmanager" "wheel" "input" "dialout" "video" "render" ];
		packages = [];
		uid = 1000;
	};

  # Enable the X11 windowing system.
  services.displayManager.defaultSession = if (userSettings.wm == "hyprland") then "hyprland" else "i3+none";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = if (userSettings.wmType == "wayland") then true else false;
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" "modesetting" ];
    desktopManager = {
      xterm.enable = false;
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        i3blocks
      ];
    };
  };
  

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;

		nvidia = {
			nvidiaSettings = true;
			open = true;
			modesetting.enable = true;
		};
    #nvidia.open = true;
    #nvidia.modesetting.enable = true;
		#nvidia.nvidiaPersistenced = true;
    #nvidia.powerManagement.enable = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
		pkgs.xdg-desktop-portal
		pkgs.xdg-desktop-portal-gtk 
	];

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e,caps:escape";


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.variables.EDITOR = "vim";

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
		# core
		vim
		wget
		curl
		zsh
		git
		kitty
		cryptsetup
		home-manager
		wpa_supplicant
	
    waybar
    eww
    mako
    libnotify
    networkmanagerapplet
    swww
    emacs
    firefox
    discord
    alacritty
    alacritty-theme
    ferdium
    yazi
    wofi 
    eza
    pavucontrol
    sbctl
    niv
    thunderbird
    gnome.nautilus
    neofetch
    ungoogled-chromium
    shutter
    feh
    vscode
    obs-studio
    vlc
    gnome.cheese
    hyprshot
    kdePackages.partitionmanager
    parted
    imagemagick

    alsa-utils
		home-manager

    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))


    gdb
    gcc
    flex 
    nasm
    bison
    libtool
    gnumake
    libiconv
    autoconf
    automake
    fontforge
    pkg-config
    makeWrapper

    python3
    paleta
    bfc
    libreoffice
    
    fbset

    ncurses
  ];

  services.flatpak.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Iosevka" "IosevkaTerm"]; })
  ];

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "wootility_udev";
      text = ''
        # Wooting One Legacy

        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

        SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

        # Wooting One update mode

        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

        # Wooting Two Legacy

        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

        SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

        # Wooting Two update mode

        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

        # Generic Wootings

        SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"

        SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", TAG+="uaccess" 
      '';
      destination = "/etc/udev/rules.d/70-wooting.rules";
    })
  ];

}

