{ config, pkgs, ... }:
{
  system.stateVersion = "24.11";

  # Allow unfree packages (google-chrome is in home.nix).
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos";

  # The setup.sh script's interactive steps, translated into declarative NixOS modules.

  # Register fish as a shell in /etc/shells and set up its completions.
  programs.fish.enable = true;

  # User. Change the name if you created a different user during install
  # (and update home.nix + flake.nix to match).
  users.users.dgy = {
    isNormalUser = true;
    description = "dgy";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.fish; # fish becomes the default login shell (was chsh in setup.sh)
  };

  # Docker (setup.sh's common_step_docker)
  virtualisation.docker.enable = true;

  # SSH server (openssh-server was in the Ubuntu apt list)
  services.openssh.enable = true;

  # JetBrainsMono Nerd Font, required by ghostty-config and starship
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # If you installed the minimal ISO and want a desktop so Ghostty can run,
  # uncomment the three lines below (the graphical ISO already includes GNOME):
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
}