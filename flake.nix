{
  description = "Flake of VainOS";

		inputs = {
			lix-module = {
				url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
				inputs.nixpkgs.follows = "nixpkgs";
			};

			nixpkgs.url = "nixpkgs/nixos-24.05";
			nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
			home-manager.url = "github:nix-community/home-manager/release-24.05";
			home-manager.inputs.nixpkgs.follows = "nixpkgs";
			home-manager-unstable.url = "github:nix-community/home-manager/master";
			home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs";

			lanzaboote = {
				url = "github:nix-community/lanzaboote/v0.4.1";
				inputs.nixpkgs.follows = "nixpkgs";
			};

			emacs-pin-nixpkgs.url = "nixpkgs/f72123158996b8d4449de481897d855bc47c7bf6";
			kdenlive-pin-nixpkgs.url = "nixpkgs/cfec6d9203a461d9d698d8a60ef003cac6d0da94";
    	nwg-dock-hyprland-pin-nixpkgs.url = "nixpkgs/2098d845d76f8a21ae4fe12ed7c7df49098d3f15";

			hyprland = {
				type = "git";
				url = "https://code.hyprland.org/hyprwm/Hyprland.git";
				submodules = true;
				rev = "0f594732b063a90d44df8c5d402d658f27471dfe";	
				inputs.nixpkgs.follows = "nixpkgs";
			};

			hyprland-plugins = {
				type = "git";
				url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
				rev = "b73d7b901d8cb1172dd25c7b7159f0242c625a77"; #v0.43.0
				inputs.hyprland.follows = "hyprland";
			};

			hyprlock = {
				type = "git";
				url = "https://code.hyprland.org/hyprwm/hyprlock.git";
				rev = "73b0fc26c0e2f6f82f9d9f5b02e660a958902763";
				inputs.nixpkgs.follows = "nixpkgs";
			};
			
			hyprgrass.url = "github:horriblename/hyprgrass/427690aec574fec75f5b7b800ac4a0b4c8e4b1d5";
    	hyprgrass.inputs.hyprland.follows = "hyprland";

    	nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    	nix-doom-emacs.inputs.nixpkgs.follows = "emacs-pin-nixpkgs";

    	nix-straight.url = "github:librephoenix/nix-straight.el/pgtk-patch";
    	nix-straight.flake = false;
    	nix-doom-emacs.inputs.nix-straight.follows = "nix-straight";

			nvchad = {
				url = "github:NvChad/starter";
				flake = false;
			};

			stylix.url = "github:danth/stylix";

			rust-overlay.url = "github:oxalica/rust-overlay";

			
		};

  #inputs = {
  #  nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  #	 home-manager = {
			#url = "github:nix-community/home-manager";
			#inputs.nixpkgs.follows = "nixpkgs";
		#};
  #};

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, lanzaboote, ... } @ inputs: 
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
				shell = "fish";
				editor = "vim";
				font = "IosevkaTermNF";
			};
				
			nixpkgs-patched = (import inputs.nixpkgs { 
				system = systemSettings.system; 
				config.allowUnfree = true;
				config.allowUnfreePredicate = (_: true);
			});	

			nixpkgs-unstable-patched = (import inputs.nixpkgs-unstable { 
				system = systemSettings.system; 
				config.allowUnfree = true;
				config.allowUnfreePredicate = (_: true);
			});	

			pkgs-emacs = import inputs.emacs-pin-nixpkgs {
				system = systemSettings.system;
			};

			pkgs-kdenlive = import inputs.kdenlive-pin-nixpkgs {
				system = systemSettings.system;
			};

			pkgs-nwg-dock-hyprland = import inputs.nwg-dock-hyprland-pin-nixpkgs {
				system = systemSettings.system;
			};


			pkgs = nixpkgs-patched;
			pkgs-unstable = nixpkgs-unstable-patched;

			lib = inputs.nixpkgs.lib;
			home-manager = inputs.home-manager;

			supportedSystems = [ "x86_64-linux" ];

			forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
			
			nixpkgsFor = forAllSystems (system: import inputs.nixpkgs { inherit system; });

		in {
			homeConfigurations = {
				${userSettings.username} = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					modules = [
						./home.nix
					];
					extraSpecialArgs = {
						inherit pkgs;
						inherit pkgs-emacs;
						inherit pkgs-kdenlive;
						inherit pkgs-nwg-dock-hyprland;
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
						lanzaboote.nixosModules.lanzaboote
						inputs.lix-module.nixosModules.default
					];
					specialArgs = {
						inherit pkgs;
						inherit pkgs-unstable;
						inherit systemSettings;
						inherit userSettings;
						inherit inputs;
					};
				};
			};

			# TO IMPLEMENT LATER (custom install script for VainOS)
			# packages = forAllSystems (system:
			# 	let pkgs = nixpkgsFor.${system};
			# 	in {
			# 		default = self.packages.${system}.install;

			# 		install = pkgs.writeShellApplication {
			# 			name = "install";
			# 			runtimeInputs = with pkgs; [ git ];
			# 			text = ''${./install.sh} "$@"'';
			# 		};
			# 	}
			# );
};
}
