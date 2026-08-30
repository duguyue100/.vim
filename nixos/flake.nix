{
  description = "DGY NixOS configuration (translated from setup.sh)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Change this one value when deploying the configuration for another user.
      user = "dgynix";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user; };
          home-manager.users.${user} = import ./home.nix;
        }
      ];
    in {
      # Flakes evaluate in pure mode, so the machine's arch cannot be
      # auto-detected (builtins.currentSystem is disabled). Both are defined
      # here; pick at rebuild time. NOTE: nixos-rebuild treats everything after
      # `.#` as ONE config name, so these must not contain dots.
      #   sudo nixos-rebuild switch --flake .#nixos-x86_64-linux   (Intel VM)
      #   sudo nixos-rebuild switch --flake .#nixos-aarch64-linux  (Apple Silicon VM)
      # Check inside the VM with: uname -m
      nixosConfigurations.nixos-x86_64-linux = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit user; };
        inherit modules;
      };
      nixosConfigurations.nixos-aarch64-linux = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit user; };
        inherit modules;
      };
    };
}
