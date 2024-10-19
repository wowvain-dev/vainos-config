{ config, pkgs, ... }:

{
	environment.systemPackages = with pkgs; [ virt-manager distrobox ];

	virtualisation.libvirtd = {
		allowedBridges = [
			"nm-bridge"
			"virb0"
		];
		enable = true;
		qemu.runAsBoot = false;
	};

	virtualisation.waydroid.enable = true;
}
