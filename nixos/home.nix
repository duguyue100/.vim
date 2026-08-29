{ config, pkgs, ... }:
let
  vim = "${config.home.homeDirectory}/.vim";
  catppuccinGtk = pkgs.catppuccin-gtk.override {
    accents = [ "flamingo" ];
    size = "standard";
    tweaks = [ ];
    variant = "latte";
  };
  # Symlink a file from the ~/.vim repo into ~/.config (like setup.sh's ln -sf).
  link = target: config.lib.file.mkOutOfStoreSymlink target;
in
{
  home.username = "dgynix";
  home.homeDirectory = "/home/dgynix";
  home.stateVersion = "24.11";

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
    theme = {
      package = catppuccinGtk;
      name = "Catppuccin-Latte-Standard-Flamingo-Light";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus";
    };
  };

  # All brew install / apt install packages from setup.sh, now in nixpkgs.
  home.packages = with pkgs; [
    # common CLI tools
    bottom
    lsd
    fd
    lazygit
    uv
    python312
    neovim
    fzf
    starship
    tmux
    shellcheck
    lazydocker
    tree-sitter
    zoxide
    ripgrep
    git
    duf
    fish
    ghostty
    waybar
    nwg-drawer
    mako
    awww
    hyprlock
    hypridle
    wl-clipboard
    grim
    slurp
    google-chrome
    nodejs
    yarn
    fnm
    wget
    ffmpeg
    jless
    vlc
    mc
    # dev toolchain (build-essential + brew build deps)
    cmake
    curl
    unzip
    clang-tools # clang-format
    automake
    bison
    gcc
    ruby
    opencode # coding agent (was the anomalyco/tap brew formula)
  ];

  # Dotfiles. Source of truth is the ~/.vim repo; these are live symlinks.
  home.file = {
    ".config/fish/config.fish".source = link "${vim}/config.fish";
    ".config/ghostty/config".source = link "${vim}/ghostty-config";
    ".config/hypr/hyprland.lua".source = link "${vim}/hyprland.lua";
    ".config/waybar/config".source = link "${vim}/waybar-config";
    ".config/waybar/style.css".source = link "${vim}/waybar-style.css";
    ".config/nwg-drawer/drawer.css".source = link "${vim}/nwg-drawer.css";
    ".config/hypr/hypridle.conf".source = link "${vim}/hypridle.conf";
    ".config/hypr/hyprlock.conf".source = link "${vim}/hyprlock.conf";
    ".local/bin/set-wallpaper" = {
      source = ../set-wallpaper;
      executable = true;
    };
    ".config/starship.toml".source = link "${vim}/starship.toml";
    ".tmux.conf".source = link "${vim}/tmux.conf";
    ".darglint".source = link "${vim}/.darglint";
    ".config/mc/mc.keymap".source = link "${vim}/mc.keymap";
    ".config/opencode/opencode.jsonc".source = link "${vim}/opencode/opencode.jsonc";
    ".config/nvim".source = link vim; # same as setup.sh's ln -sf ~/.vim ~/.config/nvim
    # tpm. The rev must be pinned — pure flake eval rejects unlocked fetchGit.
    ".tmux/plugins/tpm" = {
      source = builtins.fetchGit {
        url = "https://github.com/tmux-plugins/tpm";
        rev = "e261deb1b47614eed3400089ce7197dc68acc4eb";
      };
      recursive = true;
    };
  };
}
