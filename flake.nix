{
  description = "Flake of VainOS";

		inputs = {
			nixpkgs.url = "nixpkgs/nixos-24.05";
			nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
			home-manager.url = "github:nix-community/home-manager/release-24.05";
			home-manager.inputs.nixpkgs.follows = "nixpkgs";
			home-manager-unstable.url = "github:nix-community/home-manager/master";
			home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";

			#hyprland = {
			#	type = "git";
			#	url = "https://code.hyprland.org/hyprwm/Hyprland.git";
			#	submodules = true;
			#	rev = "0f594732b063a90d44df8c5d402d658f27471dfe";	
			#	inputs.nixpkgs.follows = "nixpkgs";
			#};

			#hyprland-plugins = {
			#	type = "git";
			#	url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
			#	rev = "b73d7b901d8cb1172dd25c7b7159f0242c625a77"; #v0.43.0
			#	inputs.hyprland.follows = "hyprland";
			#};

			hyprlock = {
				type = "git";
				url = "https://code.hyprland.org/hyprwm/hyprlock.git";
				rev = "73b0fc26c0e2f6f82f9d9f5b02e660a958902763";
				inputs.nixpkgs.follows = "nixpkgs";
			};
			
		};

  #inputs = {
  #  nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  #	 home-manager = {
			#url = "github:nix-community/home-manager";
			#inputs.nixpkgs.follows = "nixpkgs";
		#};
  #};

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
		let 
			# ---- SYSTEM SETTINGS ----
			systemSettings = {
				system = "x86_64-linux";
				hostname = "vain-laptop";
				timezone = "Europe/Amsterdam";
				bootMode = "bios";
				bootMountPath = "/boot";
				gpuType = "nvidia";
			};
			# ---- USER SETTINGS ----
			userSettings = rec {
				username = "wowvain";
				name = "Vain";
				email = "wowvain.dev@gmail.com";
				homeDir = "/home/wowvain";
				dotfileDir = "~/.vainos";
				wm = "hyprland"; #  hyprland | i3
				wmType = if (wm == "hyprland") then "wayland" else "x11";	
				browser = "firefox";
				term = "kitty";
				editor = "vim";
				font = "IosevkaTermNF";
			};
				
			nixpkgs-patched = (import inputs.nixpkgs { 
				system = systemSettings.system; 
				config.allowUnfree = true;
			});	

			pkgs = nixpkgs-patched;
			lib = inputs.nixpkgs.lib;
		
			home-manager = inputs.home-manager;

			supportedSystems = [ "x86_64-linux" ];

			forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
			
			nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });

			sources = import ./nix/sources.nix;
			lanzaboote = import sources.lanzaboote;
		in {
			homeConfigurations = {
				${userSettings.username} = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					modules = [
						./home.nix
					];
					extraSpecialArgs = {
						inherit pkgs;
						inherit systemSettings;
						inherit userSettings;
						inherit inputs;
					};
				};
			};
			nixosConfigurations = {
				${systemSettings.hostname} = lib.nixosSystem {
					system = systemSettings.system;
					modules = [
						./configuration.nix
					];
					specialArgs = {
						inherit pkgs;
						inherit systemSettings;
						inherit userSettings;
						inherit inputs;
					};
				};
			};


			#nixosConfigurations.vain-laptop = nixpkgs.lib.nixosSystem {
		  #		system = "x86_64-linux";
		#		modules = [
		#			./configuration.nix
		#			lanzaboote.nixosModules.lanzaboote
		#		];
		#		specialArgs = { inherit inputs; };
		#	};
		#};
};
}
