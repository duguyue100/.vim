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

# Show the code of a function, ask for confirmation, and execute it.
# Usage: prompt_and_run "Step Title" "function_name"
prompt_and_run() {
    local title="$1"
    local func_name="$2"

    header "$title"

    echo -e "${YELLOW}The following code will be executed:${NC}"
    echo -e "${CYAN}"
    declare -f "$func_name" | sed '1,2d;$d'
    echo -e "${NC}"

    while true; do
        read -rp "$(echo -e "${BOLD}Proceed? [y]es / [s]kip / [q]uit: ${NC}")" choice
        case "$choice" in
            y|Y|yes)
                info "Running: $title"
                if "$func_name"; then
                    success "Done."
                else
                    error "Step failed: $title"
                    error "You may need to investigate and fix this before continuing."
                    read -rp "$(echo -e "${BOLD}Press Enter to continue to the next step, or 'q' to quit: ${NC}")" err_choice
                    if [[ "$err_choice" == "q" || "$err_choice" == "Q" ]]; then
                        exit 1
                    fi
                fi
                return 0
                ;;
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

ubuntu_step_2_update() {
    sudo apt-add-repository -y ppa:git-core/ppa
    sudo add-apt-repository -y ppa:fish-shell/release-4
    sudo apt update && sudo apt upgrade -y

    echo ""
    read -rp "$(echo -e "${BOLD}Do you have NVIDIA GPUs? [y/n]: ${NC}")" has_nvidia
    if [[ "$has_nvidia" == "y" || "$has_nvidia" == "Y" ]]; then
        sudo add-apt-repository -y ppa:graphics-drivers/ppa
        sudo apt update
    fi

    prompt_reboot 2
}

ubuntu_step_3_essential_packages() {
    sudo apt install -y build-essential binutils cmake curl unzip openssh-server xclip zsh ripgrep mc clang-format ruby-full curl zoxide git vlc libfuse2 plocate duf fish procps
}

ubuntu_step_4_ghostty() {
    source /etc/os-release
    GHOSTTY_DEB_URL=$(curl -s https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases/latest | grep -oP "https://github.com/mkasberg/ghostty-ubuntu/releases/download/[^\s/]+/ghostty_[^\s/_]+_amd64_${VERSION_ID}.deb")
    GHOSTTY_DEB_FILE=$(basename "$GHOSTTY_DEB_URL")
    curl -LO "$GHOSTTY_DEB_URL"
    sudo dpkg -i "$GHOSTTY_DEB_FILE"
    rm "$GHOSTTY_DEB_FILE"
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/ghostty 60
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


ubuntu_step_20_os_preferences() {
    manual_step "Step 20: Ubuntu OS Preferences" \
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

macos_step_2_os_updates() {
    manual_step "Step 2: Install macOS Updates" \
        "Go to System Preferences -> Software Update and install any pending updates." \
        "Reboot if required before continuing."
}

macos_step_4_ghostty() {
    eval "$(/opt/homebrew/bin/brew shellenv)" && brew install --cask ghostty
}

macos_step_14_utilities() {
    eval "$(/opt/homebrew/bin/brew shellenv)" && brew install texlive latexit

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

macos_step_18_os_preferences() {
    manual_step "Step 18: macOS Preferences" \
        "Clean up Dock: Right-click icons -> Options -> Remove from Dock." \
        "System Preferences -> Desktop & Dock: turn on 'Automatically hide and show the Dock'." \
        "System Preferences -> Appearance: choose 'Auto'." \
        "System Preferences -> Wallpaper: set your preferred wallpaper." \
        "System Preferences -> Lock Screen: configure as desired." \
        "System Preferences -> Keyboard -> Keyboard Shortcuts -> Function Keys:" \
        "  Turn on 'Use F1, F2, etc. keys as standard function keys'."
}

# =============================================================================
# COMMON STEPS
# =============================================================================

common_step_chrome() {
    if [[ "$OS" == "ubuntu" ]]; then
        wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome-stable_current_amd64.deb
        sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
        rm /tmp/google-chrome-stable_current_amd64.deb
    else
        curl -L -o /tmp/googlechrome.dmg https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg
        hdiutil attach /tmp/googlechrome.dmg -nobrowse
        cp -R /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/
        hdiutil detach /Volumes/Google\ Chrome
        rm /tmp/googlechrome.dmg
    fi
    info "Google Chrome installed successfully."
}

common_step_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ "$OS" == "ubuntu" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    info "Verifying brew installation..."
    which brew
}

common_step_brew_packages() {
    if [[ "$OS" == "ubuntu" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    local COMMON_PACKAGES=(bottom lsd fd lazygit uv neovim fzf starship anomalyco/tap/opencode tmux shellcheck jesseduffield/lazydocker/lazydocker tree-sitter-cli)
    local OS_PACKAGES=()

    if [[ "$OS" == "ubuntu" ]]; then
        OS_PACKAGES=(fnm)
    else
        OS_PACKAGES=(automake bison cmake ffmpeg gcc git libuv wget findutils zeromq ripgrep midnight-commander clang-format ruby zoxide node cairo pango md5sha1sum jless stats MonitorControl bob bash duf fish)
    fi

    brew install "${COMMON_PACKAGES[@]}" "${OS_PACKAGES[@]}"
}


common_step_git_config() {
    header "Setup Git Config"
    read -rp "Enter your Git user.name: " git_name
    read -rp "Enter your Git user.email: " git_email
    if [[ -n "$git_name" && -n "$git_email" ]]; then
        git config --global user.name "$git_name"
        git config --global user.email "$git_email"
    else
        warn "Skipping Git config (empty name or email)."
    fi
}

common_step_clone_repo() {
    if [[ -d "${HOME}/.vim" ]]; then
        info "~/.vim already exists, skipping clone."
    else
        git clone https://github.com/duguyue100/.vim.git "${HOME}/.vim"
    fi
}

common_step_ghostty_config() {
    mkdir -p "${HOME}/.config/ghostty"
    ln -sf "${HOME}/.vim/ghostty-config" "${HOME}/.config/ghostty/config"
}

common_step_fish_setup() {
    if [[ "$OS" == "ubuntu" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    uv venv DGY --python 3.12 --directory "${HOME}"
    mkdir -p "${HOME}/.config/fish"
    rm -f "${HOME}/.config/fish/config.fish"
    ln -s "${HOME}/.vim/config.fish" "${HOME}/.config/fish/config.fish"
    ln -sf "${HOME}/.vim/starship.toml" "${HOME}/.config/starship.toml"

    if [[ "$OS" == "macos" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo "$(which fish)" | sudo tee -a /etc/shells
    fi
    chsh -s "$(which fish)"
}

common_step_symlinks_and_tools() {
    ln -sf "${HOME}/.vim/.darglint" "${HOME}/.darglint"
    ln -sf "${HOME}/.vim/tmux.conf" "${HOME}/.tmux.conf"
    if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
    else
        info "tpm already cloned, skipping."
    fi
    "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
    mkdir -p "${HOME}/.config/mc"
    rm -f "${HOME}/.config/mc/mc.keymap"
    ln -s "${HOME}/.vim/mc.keymap" "${HOME}/.config/mc/mc.keymap"
    mkdir -p "${HOME}/.config/opencode"
    ln -s "${HOME}/.vim/opencode/opencode.jsonc" "${HOME}/.config/opencode/opencode.jsonc"

    if [[ "$OS" == "macos" ]]; then
        npm install --global yarn
    fi
}

common_step_logout_reminder() {
    manual_step "Logout Reminder" \
        "Please log out and log back in for all changes to take effect." \
        "You can now use Ghostty as your terminal."
}

common_step_python_packages() {
    uv pip install pynvim jedi-language-server pre-commit mypy types-setuptools pyupgrade docformatter darglint ruff typos==1.19.0 types-dataclasses==0.1.7

    if [[ "$OS" == "ubuntu" ]]; then
        read -rp "$(echo -e "${BOLD}Do you have NVIDIA GPUs? Install nvitop? [y/n]: ${NC}")" has_nvidia
        if [[ "$has_nvidia" == "y" || "$has_nvidia" == "Y" ]]; then
            uv pip install nvitop
        fi
    fi
}

common_step_neovim_config() {
    ln -sf "${HOME}/.vim" "${HOME}/.config/nvim"

    manual_step "Install Neovim Tree-sitters" \
        "Open nvim and run:  :TSInstall python lua typescript javascript" \
        "Neovim packages will be installed automatically on first launch."
}

common_step_docker() {
    if [[ "$OS" == "ubuntu" ]]; then
        manual_step "Install Docker" \
            "Follow the official Docker installation guide for Ubuntu:" \
            "  https://docs.docker.com/engine/install/ubuntu/"
    else
        manual_step "Install Docker Desktop" \
            "Download Docker Desktop from https://docs.docker.com/desktop/install/mac-install/" \
            "Install the downloaded .dmg file."
    fi
}

common_step_ssh() {
    mkdir -p ~/.ssh

    header "Generate SSH Key"
    read -rp "Enter your email for the SSH key: " ssh_email
    if [[ -n "$ssh_email" ]]; then
        ssh-keygen -t ed25519 -C "$ssh_email"
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

common_step_git_remote() {
    cd "${HOME}/.vim" && git remote set-url origin git@github.com:duguyue100/.vim.git
}

# =============================================================================
# STEP REGISTRIES (modular – add/remove/reorder steps here)
# =============================================================================

UBUNTU_STEPS=(
    common_step_chrome
    ubuntu_step_2_update
    ubuntu_step_3_essential_packages
    ubuntu_step_4_ghostty
    common_step_homebrew
    common_step_brew_packages
    ubuntu_step_7_nvidia_driver
    ubuntu_step_8_reboot_after_packages
    common_step_git_config
    common_step_clone_repo
    common_step_ghostty_config
    common_step_fish_setup
    common_step_symlinks_and_tools
    common_step_logout_reminder
    common_step_python_packages
    common_step_neovim_config
    common_step_docker
    common_step_ssh
    common_step_git_remote
    ubuntu_step_20_os_preferences
)

MACOS_STEPS=(
    common_step_chrome
    macos_step_2_os_updates
    common_step_homebrew
    macos_step_4_ghostty
    common_step_brew_packages
    common_step_git_config
    common_step_clone_repo
    common_step_ghostty_config
    common_step_fish_setup
    common_step_symlinks_and_tools
    common_step_logout_reminder
    common_step_python_packages
    common_step_neovim_config
    macos_step_14_utilities
    common_step_docker
    common_step_ssh
    common_step_git_remote
    macos_step_18_os_preferences
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
        local func_name="${steps[$i]}"
        local title
        title=$(echo "$func_name" | tr '_' ' ' | awk '{for(j=1;j<=NF;j++) $j=toupper(substr($j,1,1)) substr($j,2)} 1')

        info "Step $((i + 1)) / ${total}"
        save_state "$i"

        prompt_and_run "$title" "$func_name"
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
