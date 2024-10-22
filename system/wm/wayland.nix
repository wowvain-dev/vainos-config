{ config, pkgs, ... }:

{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    ./gnome-keyring.nix
    ./fonts.nix
  ];

  environment.systemPackages = with pkgs; [
    wayland 
    waydroid
    (sddm-chili-theme.override {
      themeConfig = {
        blur = true;
        ScreenWidth = 2560;
        ScreenHeight = 1440;
        recursiveBlurLoops = 3;
        recursiveBlurRadius = 5;
      };
    })
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" "modesetting" ];
    xkb = {
      layout = "us";
      variant = "";
      options = "eurosign:e,caps:escape";
    };
  };

  environment.sessionVariables = {
		WLR_DRM_DEVICES = "/dev/dri/card1";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
}
