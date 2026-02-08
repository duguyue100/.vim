#!/usr/bin/env bash
# =============================================================================
# OS Setup Script
# Automates macOS and Ubuntu setup based on the instructions in this folder.
# Detects the OS and runs the appropriate steps with user confirmation.
#
# Features:
#   - OS detection (macOS / Ubuntu)
#   - Modular step functions for easy customization
#   - Interactive confirmation before each step
#   - State persistence across reboots (resume support)
#   - Error reporting with context
#   - Manual-step instructions when automation is not possible
#
# Usage:
#   chmod +x setup.sh
#   ./setup.sh
# =============================================================================

set -euo pipefail

# ── Paths & State ────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="${HOME}/.setup_os_state"

# ── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ── Helpers ──────────────────────────────────────────────────────────────────

info()    { echo -e "${CYAN}[INFO]${NC}  $*"; }
success() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*"; }
header()  { echo -e "\n${BOLD}═══════════════════════════════════════════════════════${NC}"; \
            echo -e "${BOLD}  $*${NC}"; \
            echo -e "${BOLD}══════════════════════════════════════════════════════${NC}\n"; }

# Detect OS: sets $OS to "macos" or "ubuntu"
detect_os() {
    case "$(uname -s)" in
        Darwin) OS="macos" ;;
        Linux)
            if grep -qi ubuntu /etc/os-release 2>/dev/null; then
                OS="ubuntu"
            else
                error "This script only supports macOS and Ubuntu."
                exit 1
            fi
            ;;
        *)
            error "Unsupported operating system: $(uname -s)"
            exit 1
            ;;
    esac
    info "Detected OS: ${BOLD}${OS}${NC}"
}

# ── State Management (resume after reboot) ───────────────────────────────────

save_state() {
    echo "$1" > "$STATE_FILE"
}

load_state() {
    if [[ -f "$STATE_FILE" ]]; then
        cat "$STATE_FILE"
    else
        echo "0"
    fi
}

clear_state() {
    rm -f "$STATE_FILE"
}

# ── Confirmation ─────────────────────────────────────────────────────────────

# Ask the user to confirm before running a step.
# Usage: confirm_step "Step Title" "command1" "command2" ...
#   Returns 0 if user confirms, 1 if skipped.
confirm_step() {
    local title="$1"; shift
    header "$title"

    echo -e "${YELLOW}The following commands will be executed:${NC}"
    echo ""
    for cmd in "$@"; do
        echo -e "  ${CYAN}\$${NC} $cmd"
    done
    echo ""

    while true; do
        read -rp "$(echo -e "${BOLD}Proceed? [y]es / [s]kip / [q]uit: ${NC}")" choice
        case "$choice" in
            y|Y|yes) return 0 ;;
            s|S|skip) warn "Skipping: $title"; return 1 ;;
            q|Q|quit) info "Exiting setup."; exit 0 ;;
            *) echo "Please enter y, s, or q." ;;
        esac
    done
}

# Show a manual instruction to the user (non-automatable step).
manual_step() {
    local title="$1"; shift
    header "$title (MANUAL)"
    echo -e "${YELLOW}This step requires manual action. Please follow the instructions below:${NC}"
    echo ""
    for line in "$@"; do
        echo -e "  ${CYAN}→${NC} $line"
    done
    echo ""
    read -rp "$(echo -e "${BOLD}Press Enter when you have completed this step (or 's' to skip): ${NC}")" choice
    if [[ "$choice" == "s" || "$choice" == "S" ]]; then
        warn "Skipping: $title"
    fi
}

# Run a command and handle errors.
run_cmd() {
    info "Running: $*"
    if eval "$@"; then
        success "Done."
    else
        error "Command failed: $*"
        error "You may need to investigate and fix this before continuing."
        read -rp "$(echo -e "${BOLD}Press Enter to continue to the next step, or 'q' to quit: ${NC}")" choice
        if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
            exit 1
        fi
    fi
}

# ── Reboot helper ────────────────────────────────────────────────────────────

prompt_reboot() {
    local next_step="$1"
    save_state "$next_step"
    echo ""
    warn "A reboot is recommended before continuing."
    warn "The script will resume from step ${next_step} after reboot."
    warn "To resume, simply run this script again:  ${BOLD}${SCRIPT_DIR}/setup.sh${NC}"
    echo ""
    while true; do
        read -rp "$(echo -e "${BOLD}Reboot now? [y]es / [n]o (continue without reboot): ${NC}")" choice
        case "$choice" in
            y|Y) sudo reboot ;;
            n|N) return 0 ;;
            *) echo "Please enter y or n." ;;
        esac
    done
}

# =============================================================================
# UBUNTU STEPS
# =============================================================================

ubuntu_step_1_chrome() {
    if confirm_step "Step 1: Install Google Chrome (Optional)" \
        "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb" \
        "sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb" \
        "rm /tmp/google-chrome-stable_current_amd64.deb"; then
        run_cmd "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb"
        run_cmd "sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb"
        run_cmd "rm /tmp/google-chrome-stable_current_amd64.deb"
        info "Google Chrome installed successfully."
    fi
}

ubuntu_step_2_update() {
    if confirm_step "Step 2: Add PPAs and Update System" \
        "sudo apt-add-repository -y ppa:git-core/ppa" \
        "sudo add-apt-repository -y ppa:fish-shell/release-4" \
        "sudo apt update && sudo apt upgrade -y"; then
        run_cmd "sudo apt-add-repository -y ppa:git-core/ppa"
        run_cmd "sudo add-apt-repository -y ppa:fish-shell/release-4"
        run_cmd "sudo apt update && sudo apt upgrade -y"
    fi

    echo ""
    read -rp "$(echo -e "${BOLD}Do you have NVIDIA GPUs? [y/n]: ${NC}")" has_nvidia
    if [[ "$has_nvidia" == "y" || "$has_nvidia" == "Y" ]]; then
        if confirm_step "Step 2b: Add NVIDIA PPA" \
            "sudo add-apt-repository -y ppa:graphics-drivers/ppa" \
            "sudo apt update"; then
            run_cmd "sudo add-apt-repository -y ppa:graphics-drivers/ppa"
            run_cmd "sudo apt update"
        fi
    fi

    prompt_reboot 2
}

ubuntu_step_3_essential_packages() {
    if confirm_step "Step 3: Install Essential Packages" \
        "sudo apt install -y build-essential binutils cmake curl tmux unzip openssh-server xclip zsh ripgrep mc clang-format ruby-full curl zoxide git vlc libfuse2 plocate shellcheck duf fish procps"; then
        run_cmd "sudo apt install -y build-essential binutils cmake curl tmux unzip openssh-server xclip zsh ripgrep mc clang-format ruby-full curl zoxide git vlc libfuse2 plocate shellcheck duf fish procps"
    fi
}

ubuntu_step_4_ghostty() {
    if confirm_step "Step 4: Install Ghostty Terminal" \
        "source /etc/os-release && curl Ghostty .deb from GitHub releases" \
        "sudo dpkg -i <ghostty>.deb" \
        "sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/ghostty 60"; then
        source /etc/os-release
        GHOSTTY_DEB_URL=$(curl -s https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases/latest | grep -oP "https://github.com/mkasberg/ghostty-ubuntu/releases/download/[^\s/]+/ghostty_[^\s/_]+_amd64_${VERSION_ID}.deb")
        GHOSTTY_DEB_FILE=$(basename "$GHOSTTY_DEB_URL")
        run_cmd "curl -LO \"$GHOSTTY_DEB_URL\""
        run_cmd "sudo dpkg -i \"$GHOSTTY_DEB_FILE\""
        run_cmd "rm \"$GHOSTTY_DEB_FILE\""
        run_cmd "sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/ghostty 60"
    fi
}

ubuntu_step_5_linuxbrew() {
    if confirm_step "Step 5: Install Linuxbrew" \
        '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'; then
        run_cmd '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        info "Linuxbrew installed successfully."
    fi
}

ubuntu_step_6_brew_packages() {
    if confirm_step "Step 6: Install Packages via Linuxbrew" \
        "brew install bottom lsd fd fnm lazygit uv neovim fzf starship"; then
        run_cmd 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && brew install bottom lsd fd fnm lazygit uv neovim fzf starship'
    fi
}

ubuntu_step_7_nvidia_driver() {
    read -rp "$(echo -e "${BOLD}Do you have NVIDIA GPUs and want to install drivers? [y/n]: ${NC}")" has_nvidia
    if [[ "$has_nvidia" == "y" || "$has_nvidia" == "Y" ]]; then
        manual_step "Step 7: Install NVIDIA Driver" \
            "Run: sudo apt install nvidia-driver-<version>" \
            "Tip: press Tab to see available versions, pick a recent one." \
            "Then: sudo apt install nvidia-modprobe"
    fi
}

ubuntu_step_8_reboot_after_packages() {
    prompt_reboot 8
}

ubuntu_step_9_git_config() {
    header "Step 9: Setup Git Config"
    read -rp "Enter your Git user.name: " git_name
    read -rp "Enter your Git user.email: " git_email
    if [[ -n "$git_name" && -n "$git_email" ]]; then
        if confirm_step "Set Git Config" \
            "git config --global user.name \"$git_name\"" \
            "git config --global user.email \"$git_email\""; then
            run_cmd "git config --global user.name \"$git_name\""
            run_cmd "git config --global user.email \"$git_email\""
        fi
    else
        warn "Skipping Git config (empty name or email)."
    fi
}

ubuntu_step_10_clone_repo() {
    if [[ -d "${HOME}/.vim" ]]; then
        info "~/.vim already exists, skipping clone."
    else
        if confirm_step "Step 10: Clone .vim Repo" \
            "git clone https://github.com/duguyue100/.vim.git ~/.vim"; then
            run_cmd "git clone https://github.com/duguyue100/.vim.git \"${HOME}/.vim\""
        fi
    fi
}

ubuntu_step_11_ghostty_config() {
    if confirm_step "Step 11: Apply Ghostty Config" \
        "mkdir -p \${HOME}/.config/ghostty" \
        "ln -s \${HOME}/.vim/ghostty-config \${HOME}/.config/ghostty/config"; then
        run_cmd "mkdir -p \"${HOME}/.config/ghostty\""
        run_cmd "ln -sf \"${HOME}/.vim/ghostty-config\" \"${HOME}/.config/ghostty/config\""
    fi
}

ubuntu_step_12_fish_setup() {
    if confirm_step "Step 12: Configure Fish Shell" \
        "uv venv DGY --python 3.12 --directory \${HOME}" \
        "mkdir -p \${HOME}/.config/fish" \
        "ln -sf \${HOME}/.vim/config.fish \${HOME}/.config/fish/config.fish" \
        "ln -sf \${HOME}/.vim/starship.toml \${HOME}/.config/starship.toml"; then
        run_cmd 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
        run_cmd "uv venv --python 3.12 --directory \"${HOME}\""
        run_cmd "mkdir -p \"${HOME}/.config/fish\""
        run_cmd "rm -f \"${HOME}/.config/fish/config.fish\""
        run_cmd "ln -s \"${HOME}/.vim/config.fish\" \"${HOME}/.config/fish/config.fish\""
        run_cmd "ln -sf \"${HOME}/.vim/starship.toml\" \"${HOME}/.config/starship.toml\""
    fi

    if confirm_step "Switch Default Shell to Fish" \
        "chsh -s \$(which fish)"; then
        run_cmd "chsh -s \$(which fish)"
    fi
}

ubuntu_step_13_symlinks_and_tools() {
    if confirm_step "Step 13: Symlinks & Tools (darglint, tmux, mc, npm)" \
        "ln -sf \${HOME}/.vim/.darglint \${HOME}/.darglint" \
        "ln -sf \${HOME}/.vim/tmux.conf \${HOME}/.tmux.conf" \
        "git clone https://github.com/tmux-plugins/tpm \${HOME}/.tmux/plugins/tpm" \
        "\${HOME}/.tmux/plugins/tpm/bin/install_plugins" \
        "mkdir -p \${HOME}/.config/mc" \
        "ln -sf \${HOME}/.vim/mc.keymap \${HOME}/.config/mc/mc.keymap" \
        "ln -sf \${HOME}/.vim/opencode/opencode.jsonc \${HOME}/.config/opencode/opencode.jsonc" \
        "fnm install 20 && fnm use 20 && npm install --global yarn"; then
        run_cmd "ln -sf \"${HOME}/.vim/.darglint\" \"${HOME}/.darglint\""
        run_cmd "ln -sf \"${HOME}/.vim/tmux.conf\" \"${HOME}/.tmux.conf\""
        if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
            run_cmd "git clone https://github.com/tmux-plugins/tpm \"${HOME}/.tmux/plugins/tpm\""
        else
            info "tpm already cloned, skipping."
        fi
        run_cmd "\"${HOME}/.tmux/plugins/tpm/bin/install_plugins\""
        run_cmd "mkdir -p \"${HOME}/.config/mc\""
        run_cmd "rm -f \"${HOME}/.config/mc/mc.keymap\""
        run_cmd "ln -s \"${HOME}/.vim/mc.keymap\" \"${HOME}/.config/mc/mc.keymap\""
        run_cmd "ln -s \"${HOME}/.vim/opencode/opencode.jsonc\" \"${HOME}/.config/opencode/opencode.jsonc\""
        warn "You may need to log out and log back in for this to take effect."
        warn "You can now use Ghostty as your terminal."
    fi
}

ubuntu_step_14_python_packages() {
    if confirm_step "Step 14: Install Python Packages (essentials, dev tools)" \
        "uv pip install pynvim jedi-language-server pre-commit mypy types-setuptools pyupgrade docformatter darglint ruff typos==1.19.0 types-dataclasses==0.1.7"; then
        run_cmd "uv pip install pynvim jedi-language-server pre-commit mypy types-setuptools pyupgrade docformatter darglint ruff typos==1.19.0 types-dataclasses==0.1.7"
    fi

    read -rp "$(echo -e "${BOLD}Do you have NVIDIA GPUs? Install nvitop? [y/n]: ${NC}")" has_nvidia
    if [[ "$has_nvidia" == "y" || "$has_nvidia" == "Y" ]]; then
        if confirm_step "Install nvitop"; then
            run_cmd "uv pip install nvitop"
        fi
    fi
}

ubuntu_step_15_neovim_config() {
    if confirm_step "Step 15: Configure Neovim" \
        "ln -sf \${HOME}/.vim \${HOME}/.config/nvim"; then
        run_cmd "ln -sf \"${HOME}/.vim\" \"${HOME}/.config/nvim\""
    fi

    manual_step "Install Neovim Tree-sitters" \
        "Open nvim and run:  :TSInstall python lua typescript javascript" \
        "Neovim packages will be installed automatically on first launch."
}

ubuntu_step_16_docker() {
    manual_step "Step 16: Install Docker" \
        "Follow the official Docker installation guide for Ubuntu:" \
        "  https://docs.docker.com/engine/install/ubuntu/"
}

ubuntu_step_17_ssh() {
    if confirm_step "Step 17: SSH Key Setup" \
        "mkdir -p ~/.ssh"; then
        run_cmd "mkdir -p ~/.ssh"
    fi

    header "Generate SSH Key"
    read -rp "Enter your email for the SSH key: " ssh_email
    if [[ -n "$ssh_email" ]]; then
        if confirm_step "Generate SSH Key" \
            "ssh-keygen -t ed25519 -C \"$ssh_email\""; then
            run_cmd "ssh-keygen -t ed25519 -C \"$ssh_email\""
        fi
    else
        warn "Skipping SSH key generation (no email provided)."
    fi

    manual_step "Add SSH Key to GitHub" \
        "Copy your public key:  cat ~/.ssh/id_ed25519.pub" \
        "Add it to your GitHub account at https://github.com/settings/keys"

    manual_step "Configure ~/.ssh/config" \
        "Create or edit ~/.ssh/config with your preferred settings." \
        "Example template:" \
        "  Host *" \
        "      AddKeysToAgent yes" \
        "      IdentityFile ~/.ssh/<default-key>"
}

ubuntu_step_18_git_remote() {
    if confirm_step "Step 18: Switch .vim Remote to SSH" \
        "cd ~/.vim && git remote set-url origin git@github.com:duguyue100/.vim.git"; then
        run_cmd "cd \"${HOME}/.vim\" && git remote set-url origin git@github.com:duguyue100/.vim.git"
    fi
}

ubuntu_step_19_os_preferences() {
    manual_step "Step 19: Ubuntu OS Preferences" \
        "Clean up Dock: Right-click icons -> Unpin from Favorites (keep Files & Trash)." \
        "Pin Chrome to the dock." \
        "Settings -> Ubuntu Desktop -> Desktop Icons: turn off 'Show Home Folder'." \
        "Settings -> Ubuntu Desktop -> Dock: turn on 'Auto-hide the Dock'." \
        "Settings -> Appearance -> Style -> Dark (if you prefer dark theme)." \
        "Settings -> Power -> Power Saving: set to 'Never'." \
        "Settings -> Displays -> Night Light: enable if desired."
}

# =============================================================================
# macOS STEPS
# =============================================================================

macos_step_1_chrome() {
    if confirm_step "Step 1: Install Google Chrome (Optional)" \
        "curl -L -o /tmp/googlechrome.dmg https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg" \
        "hdiutil attach /tmp/googlechrome.dmg -nobrowse" \
        "cp -R /Volumes/Google\\ Chrome/Google\\ Chrome.app /Applications/" \
        "hdiutil detach /Volumes/Google\\ Chrome" \
        "rm /tmp/googlechrome.dmg"; then
        run_cmd "curl -L -o /tmp/googlechrome.dmg https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg"
        run_cmd "hdiutil attach /tmp/googlechrome.dmg -nobrowse"
        run_cmd "cp -R /Volumes/Google\\ Chrome/Google\\ Chrome.app /Applications/"
        run_cmd "hdiutil detach /Volumes/Google\\ Chrome"
        run_cmd "rm /tmp/googlechrome.dmg"
        info "Google Chrome installed successfully."
    fi
}

macos_step_2_os_updates() {
    manual_step "Step 2: Install macOS Updates" \
        "Go to System Preferences -> Software Update and install any pending updates." \
        "Reboot if required before continuing."
}

macos_step_3_homebrew() {
    if confirm_step "Step 3: Install Homebrew" \
        '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'; then
        run_cmd '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        run_cmd "eval \"$(/opt/homebrew/bin/brew shellenv)\""
        info "Verifying brew installation..."
        run_cmd "which brew"
    fi
}

macos_step_4_ghostty() {
    if confirm_step "Step 4: Install Ghostty Terminal" \
        "brew install --cask ghostty"; then
        run_cmd "eval \"\$(/opt/homebrew/bin/brew shellenv)\" && brew install --cask ghostty"
    fi
}

macos_step_5_essential_packages() {
    if confirm_step "Step 5: Install Essential Packages via Homebrew" \
        "brew install automake bison cmake ffmpeg gcc git libuv tmux wget findutils zeromq ripgrep lazygit midnight-commander clang-format ruby lsd zoxide shellcheck node cairo pango fd bottom md5sha1sum jless fzf stats MonitorControl bob bash duf fish starship uv anomalyco/tap/opencode neovim"; then
        run_cmd "eval \"\$(/opt/homebrew/bin/brew shellenv)\" && brew install automake bison cmake ffmpeg gcc git libuv tmux wget findutils zeromq ripgrep lazygit midnight-commander clang-format ruby lsd zoxide shellcheck node cairo pango fd bottom md5sha1sum jless fzf stats MonitorControl bob bash duf fish starship uv anomalyco/tap/opencode neovim"
    fi
}

macos_step_6_git_config() {
    header "Step 6: Setup Git Config"
    read -rp "Enter your Git user.name: " git_name
    read -rp "Enter your Git user.email: " git_email
    if [[ -n "$git_name" && -n "$git_email" ]]; then
        if confirm_step "Set Git Config" \
            "git config --global user.name \"$git_name\"" \
            "git config --global user.email \"$git_email\""; then
            run_cmd "git config --global user.name \"$git_name\""
            run_cmd "git config --global user.email \"$git_email\""
        fi
    else
        warn "Skipping Git config (empty name or email)."
    fi
}

macos_step_7_clone_repo() {
    if [[ -d "${HOME}/.vim" ]]; then
        info "$HOME/.vim already exists, skipping clone."
    else
        if confirm_step "Step 7: Clone .vim Repo" \
            "git clone https://github.com/duguyue100/.vim.git ~/.vim"; then
            run_cmd "git clone https://github.com/duguyue100/.vim.git \"${HOME}/.vim\""
        fi
    fi
}

macos_step_8_ghostty_config() {
    if confirm_step "Step 8: Apply Ghostty Config" \
        "mkdir -p \${HOME}/.config/ghostty" \
        "ln -s \${HOME}/.vim/ghostty-config \${HOME}/.config/ghostty/config"; then
        run_cmd "mkdir -p \"${HOME}/.config/ghostty\""
        run_cmd "ln -sf \"${HOME}/.vim/ghostty-config\" \"${HOME}/.config/ghostty/config\""
    fi
}

macos_step_9_fish_setup() {
    if confirm_step "Step 9: Configure Fish Shell" \
        "uv venv DGY --python 3.12 --directory \${HOME}" \
        "mkdir -p \${HOME}/.config/fish" \
        "ln -sf \${HOME}/.vim/config.fish \${HOME}/.config/fish/config.fish" \
        "ln -sf \${HOME}/.vim/starship.toml \${HOME}/.config/starship.toml"; then
        run_cmd "eval \"$(/opt/homebrew/bin/brew shellenv)\""
        run_cmd "uv venv --python 3.12 --directory \"${HOME}\""
        run_cmd "mkdir -p \"${HOME}/.config/fish\""
        run_cmd "rm -f \"${HOME}/.config/fish/config.fish\""
        run_cmd "ln -s \"${HOME}/.vim/config.fish\" \"${HOME}/.config/fish/config.fish\""
        run_cmd "ln -sf \"${HOME}/.vim/starship.toml\" \"${HOME}/.config/starship.toml\""
    fi

    if confirm_step "Switch Default Shell to Fish" \
        "echo \$(which fish) | sudo tee -a /etc/shells" \
        "chsh -s \$(which fish)"; then
        run_cmd "eval \"$(/opt/homebrew/bin/brew shellenv)\""
        run_cmd "echo \$(which fish) | sudo tee -a /etc/shells"
        run_cmd "chsh -s \$(which fish)"
    fi
}

macos_step_10_symlinks_and_tools() {
    if confirm_step "Step 10: Symlinks & Tools (darglint, tmux, mc, npm)" \
        "ln -sf \${HOME}/.vim/.darglint \${HOME}/.darglint" \
        "ln -sf \${HOME}/.vim/tmux.conf \${HOME}/.tmux.conf" \
        "git clone https://github.com/tmux-plugins/tpm \${HOME}/.tmux/plugins/tpm" \
        "\${HOME}/.tmux/plugins/tpm/bin/install_plugins" \
        "mkdir -p \${HOME}/.config/mc" \
        "ln -sf \${HOME}/.vim/mc.keymap \${HOME}/.config/mc/mc.keymap" \
        "npm install --global yarn"; then
        run_cmd "ln -sf \"${HOME}/.vim/.darglint\" \"${HOME}/.darglint\""
        run_cmd "ln -sf \"${HOME}/.vim/tmux.conf\" \"${HOME}/.tmux.conf\""
        if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
            run_cmd "git clone https://github.com/tmux-plugins/tpm \"${HOME}/.tmux/plugins/tpm\""
        else
            info "tpm already cloned, skipping."
        fi
        run_cmd "\"${HOME}/.tmux/plugins/tpm/bin/install_plugins\""
        run_cmd "mkdir -p \"${HOME}/.config/mc\""
        run_cmd "rm -f \"${HOME}/.config/mc/mc.keymap\""
        run_cmd "ln -s \"${HOME}/.vim/mc.keymap\" \"${HOME}/.config/mc/mc.keymap\""
        run_cmd "npm install --global yarn"
        warn "You may need to log out and log back in for this to take effect."
        warn "You can now use Ghostty as your terminal."
    fi
}

macos_step_11_python_packages() {
    if confirm_step "Step 11: Install Python Packages (essentials, dev tools)" \
        "uv pip install pynvim jedi-language-server pre-commit mypy types-setuptools pyupgrade docformatter darglint ruff typos==1.19.0 types-dataclasses==0.1.7"; then
        run_cmd "uv pip install pynvim jedi-language-server pre-commit mypy types-setuptools pyupgrade docformatter darglint ruff typos==1.19.0 types-dataclasses==0.1.7"
    fi
}

macos_step_12_neovim_config() {
    if confirm_step "Step 12: Configure Neovim" \
        "ln -sf \${HOME}/.vim \${HOME}/.config/nvim"; then
        run_cmd "ln -sf \"${HOME}/.vim\" \"${HOME}/.config/nvim\""
    fi

    manual_step "Install Neovim Tree-sitters" \
        "Open nvim and run:  :TSInstall python lua typescript javascript" \
        "Neovim packages will be installed automatically on first launch."
}

macos_step_13_utilities() {
    if confirm_step "Step 13: Install LaTeX" \
        "brew install texlive latexit"; then
        run_cmd "eval \"\$(/opt/homebrew/bin/brew shellenv)\" && brew install texlive latexit"
    fi

    manual_step "Install macOS Utilities" \
        "Slack: Download from https://slack.com/intl/en-gb/downloads/mac (or use browser)." \
        "VLC: Download from https://www.videolan.org/vlc/" \
        "Scroll Reverser: Download from https://pilotmoon.com/scrollreverser/" \
        "  - Move the app to Applications folder." \
        "  - Grant permissions in Settings on first launch." \
        "  - In the App tab, enable 'Start at login'." \
        "Rectangle: Download from https://rectangleapp.com/" \
        "  - Grant permissions during setup." \
        "  - In settings, set 'repeated commands' to cycle 1/2, 2/3, 1/3 on half actions." \
        "  - Import the profile RectangleConfig.json from the .vim repo." \
        "Stats: Already installed. Import stats_settings.plist from the .vim repo." \
        "MonitorControl: Already installed. Grant permissions during setup."
}

macos_step_14_docker() {
    manual_step "Step 14: Install Docker Desktop" \
        "Download Docker Desktop from https://docs.docker.com/desktop/install/mac-install/" \
        "Install the downloaded .dmg file."
}

macos_step_15_ssh() {
    if confirm_step "Step 15: SSH Key Setup" \
        "mkdir -p ~/.ssh"; then
        run_cmd "mkdir -p ~/.ssh"
    fi

    header "Generate SSH Key"
    read -rp "Enter your email for the SSH key: " ssh_email
    if [[ -n "$ssh_email" ]]; then
        if confirm_step "Generate SSH Key" \
            "ssh-keygen -t ed25519 -C \"$ssh_email\""; then
            run_cmd "ssh-keygen -t ed25519 -C \"$ssh_email\""
        fi
    else
        warn "Skipping SSH key generation (no email provided)."
    fi

    manual_step "Add SSH Key to GitHub" \
        "Copy your public key:  cat ~/.ssh/id_ed25519.pub" \
        "Add it to your GitHub account at https://github.com/settings/keys"

    manual_step "Configure ~/.ssh/config" \
        "Create or edit ~/.ssh/config with your preferred settings." \
        "Example template:" \
        "  Host *" \
        "      AddKeysToAgent yes" \
        "      IdentityFile ~/.ssh/<default-key>"
}

macos_step_16_git_remote() {
    if confirm_step "Step 16: Switch .vim Remote to SSH" \
        "cd ~/.vim && git remote set-url origin git@github.com:duguyue100/.vim.git"; then
        run_cmd "cd \"${HOME}/.vim\" && git remote set-url origin git@github.com:duguyue100/.vim.git"
    fi
}

macos_step_17_os_preferences() {
    manual_step "Step 17: macOS Preferences" \
        "Clean up Dock: Right-click icons -> Options -> Remove from Dock." \
        "System Preferences -> Desktop & Dock: turn on 'Automatically hide and show the Dock'." \
        "System Preferences -> Appearance: choose 'Auto'." \
        "System Preferences -> Wallpaper: set your preferred wallpaper." \
        "System Preferences -> Lock Screen: configure as desired." \
        "System Preferences -> Keyboard -> Keyboard Shortcuts -> Function Keys:" \
        "  Turn on 'Use F1, F2, etc. keys as standard function keys'."
}

# =============================================================================
# STEP REGISTRIES (modular – add/remove/reorder steps here)
# =============================================================================

UBUNTU_STEPS=(
    ubuntu_step_1_chrome
    ubuntu_step_2_update
    ubuntu_step_3_essential_packages
    ubuntu_step_4_ghostty
    ubuntu_step_5_linuxbrew
    ubuntu_step_6_brew_packages
    ubuntu_step_7_nvidia_driver
    ubuntu_step_8_reboot_after_packages
    ubuntu_step_9_git_config
    ubuntu_step_10_clone_repo
    ubuntu_step_11_ghostty_config
    ubuntu_step_12_fish_setup
    ubuntu_step_13_symlinks_and_tools
    ubuntu_step_14_python_packages
    ubuntu_step_15_neovim_config
    ubuntu_step_16_docker
    ubuntu_step_17_ssh
    ubuntu_step_18_git_remote
    ubuntu_step_19_os_preferences
)

MACOS_STEPS=(
    macos_step_1_chrome
    macos_step_2_os_updates
    macos_step_3_homebrew
    macos_step_4_ghostty
    macos_step_5_essential_packages
    macos_step_6_git_config
    macos_step_7_clone_repo
    macos_step_8_ghostty_config
    macos_step_9_fish_setup
    macos_step_10_symlinks_and_tools
    macos_step_11_python_packages
    macos_step_12_neovim_config
    macos_step_13_utilities
    macos_step_14_docker
    macos_step_15_ssh
    macos_step_16_git_remote
    macos_step_17_os_preferences
)

# =============================================================================
# MAIN
# =============================================================================

main() {
    echo ""
    echo -e "${BOLD}  ╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}  ║              DGY OS Setup                     ║${NC}"
    echo -e "${BOLD}  ╚═══════════════════════════════════════════════╝${NC}"
    echo ""

    detect_os

    local steps=()
    if [[ "$OS" == "ubuntu" ]]; then
        steps=("${UBUNTU_STEPS[@]}")
    else
        steps=("${MACOS_STEPS[@]}")
    fi

    local total=${#steps[@]}
    local start_step
    start_step=$(load_state)

    if [[ "$start_step" -gt 0 ]]; then
        info "Resuming from step $((start_step + 1)) of ${total} (state file: ${STATE_FILE})"
        echo ""
        read -rp "$(echo -e "${BOLD}Continue from step $((start_step + 1))? [y]es / [r]estart from beginning: ${NC}")" choice
        case "$choice" in
            r|R) start_step=0; clear_state ;;
        esac
    fi

    for i in $(seq "$start_step" $((total - 1))); do
        info "Step $((i + 1)) / ${total}"
        save_state "$i"
        ${steps[$i]}
        echo ""
    done

    clear_state

    echo ""
    echo -e "${GREEN}${BOLD}  ╔═══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}  ║         Setup Complete! 🎉                    ║${NC}"
    echo -e "${GREEN}${BOLD}  ╚═══════════════════════════════════════════════╝${NC}"
    echo ""
    info "You may want to restart your terminal or reboot for all changes to take effect."
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
