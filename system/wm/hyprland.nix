{ inputs, pkgs, lib, userSettings, ... }:
let
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in 
{
  # Wayland configs
  imports = [
    ./wayland.nix
    ./pipewire.nix
    ./dbus.nix
  ]

  # Security
  security = {
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs-hyprland.xdg-desktop-portal-hyprland;
    };
  };

  services.xserver.excludePackages = [ pkgs.xterm ];

  services.displayManager.defaultSession = "hyprland";  
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
  # services.xserver = {
  #   displayManager.sddm = {
  #     enable = true;
  #     wayland.enable = true;
  #     enableHidpi = true;
  #     packages = pkgs.sddm;
  #     theme = "chili";
  #   }
  # };
}