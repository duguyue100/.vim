{ config, pkgs, user, ... }:
{
  # Machine-specific hardware: fileSystems, kernel modules. Generated at
  # install time; copy it into this repo (see README quick start). It does NOT
  # contain the boot loader — that's set below.
  imports = [ ./hardware-configuration.nix ];

  # Boot loader. This aarch64 (UEFI) VM boots with systemd-boot. If you ever
  # use a BIOS/legacy machine instead, comment these two lines and enable:
  #   boot.loader.grub.enable = true;
  #   boot.loader.grub.device = "/dev/sda";   # your disk
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.11";

  # Allow unfree packages (google-chrome is in home.nix).
  nixpkgs.config.allowUnfree = true;

  # Flakes + nix-command, needed for `nixos-rebuild --flake` and `nix flake
  # update`. A fresh NixOS disables them by default; if your first rebuild
  # complains, enable them via a classic rebuild first (see README
  # troubleshooting). After this config is active they stay on permanently.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.nix-ld.enable = true;

  networking.hostName = "LF";

  # The setup.sh script's interactive steps, translated into declarative NixOS modules.

  # git goes system-wide so nix (which runs as root during rebuilds) can find it
  # when reading the flake repo. It's the same package home.nix installs.
  environment.systemPackages = with pkgs; [ git ];

  # Register fish as a shell in /etc/shells and set up its completions.
  programs.fish.enable = true;

  # User. The name is defined once in flake.nix.
  users.users.${user} = {
    isNormalUser = true;
    description = user;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.fish; # fish becomes the default login shell (was chsh in setup.sh)
  };

  # Docker (setup.sh's common_step_docker)
  virtualisation.docker.enable = true;

  # SSH server (openssh-server was in the Ubuntu apt list)
  services.openssh.enable = true;

  # JetBrainsMono Nerd Font, required by ghostty-config and starship
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    inter
  ];

  # Desktop environment — needed for the Ghostty terminal to have a display.
  # If you prefer another desktop, swap `gnome` for e.g. `plasma5` / `xfce`.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
