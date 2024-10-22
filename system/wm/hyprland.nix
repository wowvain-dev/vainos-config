{ inputs, pkgs, pkgs-unstable, lib, userSettings, ... }:
let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  hyprland-patched = inputs.hyprland.packages.${pkgs.system}.hyprland;
in 
{
  # Wayland configs
  imports = [
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
  ];

  # Security
  security = {
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    hyprland = {
      enable = true;
      # package = (
      #   hyprland-patched.overrideAttrs (
      #     oldAttrs: rec {
      #       nativeBuildInputs = oldAttrs.nativeBuildInputs or [] ++ [ pkgs-unstable.libinput ];
      #     }
      #   )
      # );
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs-hyprland.xdg-desktop-portal-hyprland;
    };
  };

  services.xserver.excludePackages = [ pkgs.xterm ];

  #services.displayManager.defaultSession = "hyprland";  
  # the original GDM Vain setup
  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  # the untested SDDM setup
   #services = {
	   #displayManager.sddm = {
       #enable = true;
       #wayland.enable = true;
       #enableHidpi = true;
       #package = pkgs.sddm;
	     #theme = "chili";
     #};
  #};
}
