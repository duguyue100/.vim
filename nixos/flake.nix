{
  description = "DGY NixOS configuration (translated from setup.sh)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.dgy = import ./home.nix;
        }
      ];
    in {
      # Flakes evaluate in pure mode, so the machine's arch cannot be
      # auto-detected (builtins.currentSystem is disabled) and must appear in
      # the output. Both are defined here; pick at rebuild time:
      #   sudo nixos-rebuild switch --flake .#x86_64-linux.nixos   (Intel VM)
      #   sudo nixos-rebuild switch --flake .#aarch64-linux.nixos  (Apple Silicon VM)
      # Check inside the VM with: uname -m
      nixosConfigurations.x86_64-linux.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        inherit modules;
      };
      nixosConfigurations.aarch64-linux.nixos = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        inherit modules;
      };
    };
}