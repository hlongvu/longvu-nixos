{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    claude-code-nix.url = "github:sadjow/claude-code-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixpkgs-unstable, claude-code-nix, ... }: {
    nixosConfigurations = {
      # hostname: nixos
      nixos = let
        username = "longvu";
        specialArgs = {inherit username;};
      in
        nixpkgs.lib.nixosSystem {

          specialArgs = let
            system = "x86_64-linux";
            in {
              inherit username;
              # To use packages from nixpkgs-stable,
              # we configure some parameters for it first
              pkgs-unstable = import nixpkgs-unstable {
                inherit system;
                # To use Chrome, we need to allow the
                # installation of non-free software.
                config.allowUnfree = true;
              };
            };

          modules = [
            ./host/homepc/configuration.nix

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              # nixpkgs.overlays = [ claude-code.overlays.default ];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # TODO replace ryan with your own username
              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./home/home.nix;

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            }
          ];
        };
    };
  };
}
