# neovim

## Ubuntu

```bash
mkdir -p "${HOME}"/bin
cd "${HOME}"/bin
wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage nvim
ln -s "${HOME}"/.vim "${HOME}"/.config/nvim
```

## macOS

Use `bob` to install
```bash
bob use stable
```

## Configure

Expose configure
```bash
ln -s "${HOME}"/.vim "${HOME}"/.config/nvim
```

Open `nvim`, the packages are going to be installed automatically.

Install tree-sitters in neovim
```bash
:TSInstall python lua typescript javascript
```

# Utilities

## Ubuntu

## macOS

- LaTeX: `brew install texlive latexit`
- [Slack](https://slack.com/intl/en-gb/downloads/mac): You can use the browser
    version as well, there is nothing wrong wit it.
- [VLC](https://www.videolan.org/vlc/): The best video player.
- [Scroll Reverser](https://pilotmoon.com/scrollreverser/): I happen to be one of
    those people who prefer natural scrolling on the trackpad and reverse
    scrolling on the mouse.
    - You will need to manually move the app to the Applications folder.
    - When you open the app the first time, you will need to grant permissions in the settings.
    - Make sure in the App tab, the app is set to start at login.
- [Rectangle](https://rectangleapp.com/)
    - In settings, repeated commands, set cycle 1/2, 2/3 and 1/3 on half actions.
    - During setup, you will need to grant permissions in the settings.
    - In the app settings, please import the profile `RetangleConfig.json` from this repo.
- Stats: this has been installed as part of the core package.
    - After the initial setup, import the profile `stats_settings.plist` from this
        repo.
- MonitorControl: this has been installed as part of the core package.
    - During the app setup, you will need to grant permissions in the settings.

# Docker

## Ubuntu

## macOS

Go to the [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/) page
to download the installer and install.

---
After installing all above packages, please proceed to [Final steps](./final_steps.md).
