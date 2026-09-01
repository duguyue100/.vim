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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "application/bzip2" = "org.gnome.FileRoller.desktop";
      "application/gzip" = "org.gnome.FileRoller.desktop";
      "application/vnd.rar" = "org.gnome.FileRoller.desktop";
      "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-bzip-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-rar" = "org.gnome.FileRoller.desktop";
      "application/x-rar-compressed" = "org.gnome.FileRoller.desktop";
      "application/x-tar" = "org.gnome.FileRoller.desktop";
      "application/x-xz-compressed-tar" = "org.gnome.FileRoller.desktop";
      "application/x-zip-compressed" = "org.gnome.FileRoller.desktop";
      "application/zip" = "org.gnome.FileRoller.desktop";
      "application/zstd" = "org.gnome.FileRoller.desktop";
    };
  };
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file://${vim}/wallpapers/lake-overlook.jpg";
      picture-uri-dark = "file://${vim}/wallpapers/lake-overlook.jpg";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-ac-timeout = 0;
      sleep-inactive-battery-type = "nothing";
      sleep-inactive-battery-timeout = 0;
    };
    "org/gnome/desktop/interface" = {
      enable-animations = false;
      font-name = "Inter 11";
      icon-theme = "Tela";
      gtk-theme = "Orchis-Light";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":maximize,minimize,close";
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-input-source = [ "XF86Keyboard" ];
      switch-input-source-backward = [ "<Shift>XF86Keyboard" ];
    };
    "org/gnome/shell" = {
      always-show-log-out = true;
      enabled-extensions = [
        "dash-in-panel@fthx"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "blur-my-shell@aunetx"
        "Vitals@CoreCoding.com"
        "auto-theme-switcher@amritashan.github.io"
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
    "org/gnome/shell/extensions/dash-in-panel" = {
      center-dash = false;
      show-activities = false;
      show-apps = false;
      show-dash = false;
      panel-height = 32;
      icon-size = 20;
      button-margin = 2;
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
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/wofi/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty" = {
      name = "Open Ghostty";
      command = "ghostty";
      binding = "<Control><Alt>t";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/wofi" = {
      name = "Launch applications";
      command = "wofi --show drun";
      binding = "<Super>space";
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
    gnomeExtensions.dash-in-panel
    gnomeExtensions.user-themes
    gnomeExtensions.blur-my-shell
    gnomeExtensions.vitals
    gnomeExtensions.automatic-theme-switcher
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
    wofi
    google-chrome
    networkmanagerapplet
    nodejs
    yarn
    fnm
    wget
    ffmpeg
    jless
    vlc
    file-roller
    # dev toolchain (build-essential + brew build deps)
    cmake
    curl
    zip
    unzip
    autoconf
    gettext
    libtool
    libpq
    clang-tools # clang-format
    automake
    bison
    gcc
    ruby
    opencode # coding agent (was the anomalyco/tap brew formula)
  ] ++ pkgs.lib.optional (pkgs.stdenv.hostPlatform.system == "x86_64-linux") pkgs.slack;

  # Dotfiles. Source of truth is the ~/.vim repo; these are live symlinks.
  home.file = {
    "Templates/Blank File".text = "";
    ".config/autostart/slack.desktop".source = "${pkgs.slack}/share/applications/slack.desktop";
    ".config/fish/config.fish".source = link "${vim}/config.fish";
    ".config/ghostty/config".source = link "${vim}/ghostty-config";
    ".config/starship.toml".source = link "${vim}/starship.toml";
    ".tmux.conf".source = link "${vim}/tmux.conf";
    ".darglint".source = link "${vim}/.darglint";
    ".config/mc/mc.keymap".source = link "${vim}/mc.keymap";
    ".config/opencode/opencode.jsonc".source = link "${vim}/opencode/opencode.jsonc";
    ".config/opencode/skills".source = link "${vim}/opencode/skills";
    ".config/wofi/config".source = link "${vim}/wofi/config";
    ".config/wofi/style.css".source = link "${vim}/wofi/style.css";
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
