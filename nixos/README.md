# NixOS setup (translated from `setup.sh`)

This directory is a NixOS configuration built with **flakes** + **home-manager**.
It reproduces everything `setup.sh` did for macOS/Ubuntu, but declaratively:
instead of running commands and answering prompts, you describe the end state
and `nixos-rebuild` makes it true. There are no reboots, no Homebrew, no PPAs.

The config lives in the `.vim` repo, so the dotfiles (`config.fish`,
`ghostty-config`, `starship.toml`, `tmux.conf`, the nvim config, ...) are
symlinked straight out of `~/.vim` — same as `setup.sh` did.

## Requirements

- A NixOS VM. Download the **graphical ISO** (it includes a desktop so the
  Ghostty terminal can run) from https://nixos.org/download/ and install it in
  your VM software (UTM, VMware, QEMU, ...).
- During install you will be asked for a username. **This config assumes the
  user is named `dgy`.** If you pick something else, you must rename `dgy`
  everywhere: `configuration.nix`, `home.nix`, and `flake.nix`.
- Internet access from the VM (it downloads a lot on the first rebuild).

## Quick start

Run these commands inside the NixOS VM after installing:

```bash
# 1. Get the dotfiles repo (it contains this NixOS config too).
#    A fresh NixOS has no git yet, so use the classic nix-shell (no flakes needed).
#    (git + curl become permanent after step 2.)
#    Use -b nixos: the repo's default branch (lua) does not contain this config.
nix-shell -p git --run 'git clone -b nixos https://github.com/duguyue100/.vim.git ~/.vim'

# 2. Apply the system config. First run downloads/builds a lot — be patient.
#    Pick the arch matching your VM. Check it with:  uname -m
#      x86_64  →  .#x86_64-linux.nixos
#      aarch64 →  .#aarch64-linux.nixos
cd ~/.vim/nixos
sudo nixos-rebuild switch --flake .#x86_64-linux.nixos

# 3. Set (or reset) your user password.
passwd

# 4. Log out and back in (or reboot). Your default shell is now fish,
#    and all the tools below are installed.
```

That's it. The manual one-time steps that can't be declarative are below.

## Manual one-time steps

```bash
# Git identity (setup.sh asked for these interactively)
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# SSH key, then add ~/.ssh/id_ed25519.pub at https://github.com/settings/keys
ssh-keygen -t ed25519 -C "you@example.com"

# Python environment. config.fish sources ~/DGY/bin/activate.fish on startup,
# so this venv must exist or fish will error on that line.
uv venv DGY --python 3.12 --directory ~
uv pip install pynvim jedi-language-server pre-commit mypy types-setuptools \
    pyupgrade docformatter darglint ruff typos==1.19.0 types-dataclasses==0.1.7

# Neovim: launch it once (plugins install automatically), then add tree-sitters:
#   :TSManager python lua typescript javascript

# tmux: start it once. tpm is already linked into ~/.tmux/plugins and will
# auto-install the plugins from tmux.conf on first start.
```

Optional: create the directories your fish aliases `cd` into —
`mkdir -p ~/workspace ~/Downloads`.

## What's installed (mapped from setup.sh)

| setup.sh | NixOS equivalent |
|---|---|
| `brew install` / `apt install` lists | `home.packages` in `home.nix` |
| fish as default shell (`chsh`) | `users.users.dgy.shell = pkgs.fish` in `configuration.nix` |
| `ln -sf` dotfiles | `home.file` symlinks in `home.nix` |
| tmux + tpm plugins | `~/.tmux.conf` symlink + tpm linked to `~/.tmux/plugins` |
| Docker Desktop | `virtualisation.docker.enable = true` |
| openssh-server | `services.openssh.enable = true` |
| JetBrainsMono Nerd Font | `fonts.packages = [ nerd-fonts.jetbrains-mono ]` |
| `opencode` (brew tap) | `opencode` package (it's in nixpkgs now) |

Not translated (still manual, in the checklist above, or skipped):
git identity, SSH keys, the `~/DGY` Python venv, Neovim tree-sitters.
macOS-only GUI apps (Rectangle, Stats, Scroll Reverser, MonitorControl) don't
exist on Linux and are dropped. `midnight-captain` (a `curl | bash` installer)
is not packaged for Nix — install it manually only if you actually use it.

## Making changes

Edit the files in this directory, then re-apply:

```bash
cd ~/.vim/nixos
sudo nixos-rebuild switch --flake .#x86_64-linux.nixos
```

- **Add a package:** put it in `home.packages` in `home.nix`.
- **Change dotfiles:** edit them in `~/.vim` — the symlinks are live, no rebuild needed.
- **Rename the hostname:** this config pins `networking.hostName = "nixos"`, so
  the rebuild flag is always `.#<arch>-linux.nixos` (see Quick start). If you
  want a different hostname, change it in `configuration.nix` and the attribute
  names in `flake.nix` together.

## Updating everything

```bash
cd ~/.vim/nixos
nix flake update   # bump nixpkgs + home-manager to latest
sudo nixos-rebuild switch --flake .#nixos
```

## Troubleshooting

- **"flake attribute 'nixosConfigurations.nixos' missing"** or a username error:
  your user/hostname don't match. Rename `dgy`/`nixos` as described above.
- **Wrong architecture error**: flakes evaluate in pure mode, so the arch can't
  be auto-detected — the flake defines both (`.#x86_64-linux.nixos` and
  `.#aarch64-linux.nixos`). Make sure the flag matches `uname -m` in the VM.
- **`nixos-rebuild --flake` says "experimental feature disabled":** enable
  flakes first with a classic rebuild — add
  `nix.settings.experimental-features = [ "nix-command" "flakes" ];` to
  `/etc/nixos/configuration.nix`, run `sudo nixos-rebuild switch`, then retry
  step 2 (this config declares the same option, so it stays enabled after that).
- **Ghostty won't open:** no display server. Install a desktop environment
  (uncomment the GNOME lines in `configuration.nix`, or use the graphical ISO).
- **`builtins.fetchGit` fails (network):** it only fetches the tiny `tpm` repo;
  check your connection and re-run.