{ config, pkgs, user, ... }:
let
  vim = "${config.home.homeDirectory}/.vim";
  orchisGtk = pkgs.orchis-theme.override {
    tweaks = [ "macos" ];
  };
  # Symlink a file from the ~/.vim repo into ~/.config (like setup.sh's ln -sf).
  link = target: config.lib.file.mkOutOfStoreSymlink target;
in
{
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "24.11";

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      enable-animations = true;
      font-name = "Inter 11";
      icon-theme = "Tela";
      gtk-theme = "Orchis-Light";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":maximize,minimize,close";
    };
    "org/gnome/shell" = {
      always-show-log-out = true;
      enabled-extensions = [
        "dash2dock-lite@icedman.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "blur-my-shell@aunetx"
        "Vitals@CoreCoding.com"
        "auto-theme-switcher@amritashan.github.io"
        "speedinator@liam.moe"
      ];
      favorite-apps = [
        "google-chrome.desktop"
        "org.gnome.Nautilus.desktop"
        "com.mitchellh.ghostty.desktop"
      ];
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Orchis-Light";
    };
    "org/gnome/shell/extensions/auto-theme-switcher" = {
      light-theme = "Orchis-Light";
      dark-theme = "Orchis-Dark";
      true-light-mode = true;
      light-mode-trigger = "custom";
      dark-mode-trigger = "custom";
      custom-light-time = "07:00";
      custom-dark-time = "19:00";
      manual-mode-active = false;
    };
    "org/gnome/shell/extensions/moe/liam/speedinator" = {
      speed = 1.5;
    };
    "org/gnome/shell/extensions/dash2dock-lite" = {
      animate-icons = true;
      open-app-animation = true;
      autohide-dash = true;
      autohide-dodge = true;
      autohide-speed = 0.35;
      background-color = [ 0.0 0.0 0.0 0.85 ];
      hide-labels = true;
      apps-icon = false;
      trash-icon = true;
      downloads-icon = false;
      dock-location = 0;
      favorites-only = false;
      pressure-sense = false;
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = false;
    };
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [
        "_memory_usage_"
        "_system_load_1m_"
        "__network-rx_max__"
        "__network-tx_max__"
      ];
      update-time = 2;
    };
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "ghostty";
      exec-arg = "-e";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty" = {
      name = "Open Ghostty";
      command = "ghostty";
      binding = "<Super><Control>t";
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      GNOME = [ "com.mitchellh.ghostty.desktop" ];
      default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };

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
      package = orchisGtk;
      name = "Orchis-Light";
    };
    iconTheme = {
      package = pkgs.tela-icon-theme;
      name = "Tela";
    };
  };

  # All brew install / apt install packages from setup.sh, now in nixpkgs.
  home.packages = with pkgs; [
    gnomeExtensions.dash2dock-lite
    gnomeExtensions.user-themes
    gnomeExtensions.blur-my-shell
    gnomeExtensions.vitals
    gnomeExtensions.automatic-theme-switcher
    gnomeExtensions.speedinator
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
    xclip
    shellcheck
    lazydocker
    tree-sitter
    zoxide
    ripgrep
    git
    duf
    fish
    ghostty
    google-chrome
    networkmanagerapplet
    nodejs
    yarn
    fnm
    wget
    ffmpeg
    jless
    vlc
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
  ] ++ pkgs.lib.optional (pkgs.stdenv.hostPlatform.system == "x86_64-linux") pkgs.slack;

  # Dotfiles. Source of truth is the ~/.vim repo; these are live symlinks.
  home.file = {
    ".config/fish/config.fish".source = link "${vim}/config.fish";
    ".config/ghostty/config".source = link "${vim}/ghostty-config";
    ".config/starship.toml".source = link "${vim}/starship.toml";
    ".tmux.conf".source = link "${vim}/tmux.conf";
    ".darglint".source = link "${vim}/.darglint";
    ".config/mc/mc.keymap".source = link "${vim}/mc.keymap";
    ".config/opencode/opencode.jsonc".source = link "${vim}/opencode/opencode.jsonc";
    ".config/opencode/skills".source = link "${vim}/opencode/skills";
    ".config/nvim".source = link vim; # same as setup.sh's ln -sf ~/.vim ~/.config/nvim
    # tpm. The rev must be pinned — pure flake eval rejects unlocked fetchGit.
    ".tmux/plugins/tpm" = {
      source = builtins.fetchGit {
        url = "https://github.com/tmux-plugins/tpm";
        rev = "e261deb1b47614eed3400089ce7197dc68acc4eb";
      };
      recursive = true;
    };
    ".tmux/plugins/yank".source = "${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank";
    ".tmux/plugins/tmux-which-key".source = "${pkgs.tmuxPlugins.tmux-which-key}/share/tmux-plugins/tmux-which-key";
    ".tmux/plugins/tmux2k" = {
      source = builtins.fetchGit {
        url = "https://github.com/2kabhishek/tmux2k";
        rev = "01fa86446cbf6f69690b63b0f6f30f9293423b68";
      };
      recursive = true;
    };
  };
}
