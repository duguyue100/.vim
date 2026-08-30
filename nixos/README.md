# NixOS desktop configuration

This directory contains a complete NixOS configuration for a GNOME desktop.
It uses the NixOS `26.05` release branch and Home Manager for user packages,
desktop settings, and dotfile links.

The configuration expects this repository at `~/.vim`. The Neovim, Fish,
Ghostty, Starship, and tmux files stay in the repository and are linked into
the locations where their programs expect them.

## Requirements

- A fresh NixOS installation, preferably the graphical ISO.
- A VM or computer running either `x86_64` or `aarch64` Linux.
- Internet access during the first build.
- A username. The configuration currently uses `dgynix`; change `user` in
  `flake.nix` if you use another name.

## Install

Run these commands in the new NixOS system.

### 1. Clone the repository

The initial system may not have Git or flakes enabled, so use `nix-shell` for
the first clone. The `nixos` branch contains this configuration.

```bash
nix-shell -p git --run 'git clone -b nixos https://github.com/duguyue100/.vim.git ~/.vim'
```

### 2. Add the hardware configuration

NixOS creates this file during installation. Copy it into the repository and
stage it so the flake can read it.

```bash
cp /etc/nixos/hardware-configuration.nix ~/.vim/nixos/
cd ~/.vim
nix-shell -p git --run 'git add nixos/hardware-configuration.nix'
nix-shell -p git --run 'git status'
```

Check that `nixos/hardware-configuration.nix` appears in the status output.
This file contains the disk and hardware details for this machine and should
be kept with its configuration.

### 3. Apply the configuration

Check the architecture first:

```bash
uname -m
```

Use the matching command. The first build downloads and compiles a large set
of packages.

For Intel or AMD:

```bash
cd ~/.vim/nixos
nix-shell -p git --run 'sudo env "PATH=$PATH" nixos-rebuild switch --flake .#x86'
```

For ARM:

```bash
cd ~/.vim/nixos
nix-shell -p git --run 'sudo env "PATH=$PATH" nixos-rebuild switch --flake .#arm'
```

Log out and back in after the first build. This starts the Fish shell and
loads the GNOME, theme, panel, and user package settings.

### 4. Finish user-level setup

Run the post-setup script once:

```bash
~/.vim/nixos/post-setup.sh
```

It creates `~/DGY`, installs the Python tools used by the editor, installs the
Lazy.nvim plugins, installs the Python, Lua, TypeScript, and JavaScript
Tree-sitter parsers, and installs Midnight Captain.

Set your Git identity and SSH key separately if you need them:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
ssh-keygen -t ed25519 -C "you@example.com"
```

## Make changes

The main files are:

- `configuration.nix` for system services, users, fonts, and GNOME.
- `home.nix` for packages, dconf settings, themes, and links to dotfiles.
- `flake.nix` for the NixOS and Home Manager inputs and host definitions.
- `hardware-configuration.nix` for machine-specific hardware settings.
- `nvidia.nix` for the optional NVIDIA desktop driver configuration.

After changing a Nix file, rebuild with the command for your architecture:

```bash
cd ~/.vim/nixos
sudo nixos-rebuild switch --flake .#x86
```

Dotfiles linked from `~/.vim` update immediately. Changes to Nix files require
another rebuild.

## Update the system

Pull configuration changes and rebuild without changing the pinned package
versions:

```bash
cd ~/.vim
git pull --ff-only
cd ~/.vim/nixos
sudo nixos-rebuild switch --flake .#x86
```

Use `.#arm` instead on an ARM system. If you changed `home.nix`
or another Nix file locally, commit or stash that work before pulling.

For an x86_64 machine with an NVIDIA GPU, use:

```bash
sudo nixos-rebuild switch --flake .#nvidia
```

To update the software available from the 26.05 release branch, refresh the
flake lock file before rebuilding:

```bash
cd ~/.vim/nixos
nix flake update
sudo nixos-rebuild switch --flake .#x86
```

`nix flake update` keeps the `nixos-26.05` and `release-26.05` branches. It
only moves `flake.lock` to newer commits on those branches. Commit the updated
lock file if other machines should use the same package revisions.

To update only nixpkgs:

```bash
nix flake lock --update-input nixpkgs
```

Rebuild after changing the lock file. If a new generation causes problems,
switch back to the previous one:

```bash
sudo nixos-rebuild switch --rollback
```

## Clean up old generations

List installed system generations:

```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

Keep only the five newest system generations, then collect unused store paths:

```bash
sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations +5
sudo nix-collect-garbage
```

Alternatively, delete generations older than 30 days and collect garbage:

```bash
sudo nix-collect-garbage --delete-older-than 30d
```

Deleting generations removes those rollback options permanently. Keep at least
one known-good older generation until the new configuration has been tested.

## Hardware and hosts

`hardware-configuration.nix` belongs to one machine. For another machine, run
`sudo nixos-generate-config`, copy its generated hardware file here, and stage
it before rebuilding. If you maintain multiple machines, give each host its
own hardware file and NixOS configuration entry.

The flake currently defines these host names:

- `x86`
- `nvidia`
- `arm`

The hostname inside the system remains `nixos`.

## Troubleshooting

- If Nix says `nixos/hardware-configuration.nix` is missing, stage the file with
  `git -C ~/.vim add nixos/hardware-configuration.nix`.
- If the rebuild selects the wrong system, compare the flake target with
  `uname -m`.
- If flakes are disabled on the fresh install, add
  `nix.settings.experimental-features = [ "nix-command" "flakes" ];` to
  `/etc/nixos/configuration.nix`, run a regular `sudo nixos-rebuild switch`,
  and retry the flake command.
- If a desktop application does not open, make sure the graphical desktop and
  display manager are enabled in `configuration.nix`.
