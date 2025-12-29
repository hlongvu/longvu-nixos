{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    opencode.url = "github:sst/opencode";
    snitch.url = "github:karol-broda/snitch";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixpkgs-unstable, ... }:
    let
      username = "longvu";
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };

      mkHost = hostPath: nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit username;
          inherit pkgs-unstable;
        };
        
        modules = [
          hostPath
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = inputs // { inherit username; pkgs-unstable = pkgs-unstable; };
              users.${username} = import ./home/home.nix;
            };
          }
        ];
      };
    in {
      nixosConfigurations = {
        nixos = mkHost ./host/homepc/configuration.nix;
        lapnix = mkHost ./host/lapnix/configuration.nix;
      };
    };
}
