# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, systemSettings, userSettings,  pkgs, pkgs-unstable, inputs, ... }:
{
	imports = [
    # Generated hardware config
		./hardware-configuration.nix

    # Core system configuration
    ./system/hardware/systemd.nix
    ./system/hardware/kernel.nix
    ./system/hardware/power.nix
    ./system/hardware/time.nix
    ./system/hardware/opengl.nix
    ./system/hardware/graphics.nix
    ./system/hardware/udev.nix

    # WM / DE
    (./. + "/system/wm" + ("/" + userSettings.wm) + ".nix") # Import the correct WM

	];


	#boot.kernelPackages = pkgs-unstable.linuxPackages;

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "ntfs" ];
	boot.loader.systemd-boot.enable = lib.mkForce false;
	boot.loader.efi.canTouchEfiVariables = true;
  
	boot.loader.grub.configurationLimit = 10;
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
  # services.displayManager.defaultSession = if (userSettings.wm == "hyprland") then "hyprland" else "i3+none";
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.displayManager.gdm.wayland = if (userSettings.wmType == "wayland") then true else false;
  # services.xserver = {
  #   enable = true;
  #   videoDrivers = [ "nvidia" "modesetting" ];
  #   desktopManager = {
  #     xterm.enable = false;
  #   };
  #   windowManager.i3 = {
  #     enable = true;
  #     extraPackages = with pkgs; [
  #       dmenu
  #       i3status
  #       i3lock
  #       i3blocks
  #     ];
  #   };
  # };
  

  # programs.hyprland = {
  #   enable = true;
  #   xwayland.enable = true;
  # };

  # environment.sessionVariables = {
  #   WLR_NO_HARDWARE_CURSORS = "1";
  #   NIXOS_OZONE_WL = "1";
  # };

  # hardware = {
  #   opengl.enable = true;

	# 	nvidia = {
	# 		nvidiaSettings = true;
	# 		open = true;
	# 		modesetting.enable = true;
	# 	};
  # };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
	 	pkgs.xdg-desktop-portal
	 	pkgs.xdg-desktop-portal-gtk 
	];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.libinput.enable = true;
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

    sbctl

		kitty
    direnv
		cryptsetup
		home-manager
		wpa_supplicant

    pkgs-unstable.libinput

    waybar

    (pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
  ];

  services.flatpak.enable = true;

	fonts.fontDir.enable = true;
}

