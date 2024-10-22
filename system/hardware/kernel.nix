{ config, pkgs, pkgs-unstable, ... }:

{
	boot.kernelPackages = pkgs-unstable.linuxPackages_xanmod_latest;
	boot.consoleLogLevel = 0;
}
