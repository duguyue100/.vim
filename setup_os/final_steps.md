# SSH config

If there is no `~/.ssh` folder, create one.
```bash
mkdir -p ~/.ssh
```

Create new SSH key using the following command:
```bash
ssh-keygen -t ed25519 -C "<your-email>"
```
You can add your new SSH key to the Github account.


The SSH config file can be a nice way to improve your experience:
```bash
touch ~/.ssh/config
```

You can use the following template:
```bash
Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/<default-key>

Host some_alias
	HostName <ip>
	user <user>
    port <port>
	ForwardAgent yes
    IdentityFile ~/.ssh/<key>
    LocalForward <port> localhost:<port>
    LocalForward <port> localhost:<port>
    LocalForward <port> localhost:<port>
```

# Git-related

Note that if you want to push to this repo, you need to change the remote URL from
`https` to `ssh`. You can do this by running the following command:

```bash
cd ~/.vim
git remote set-url origin git@github.com:duguyue100/.vim.git
```

# OS Preferences

## Ubuntu

- I like a clean Dock, so I unpin all icons from the sidebar but keep the files
    manager and trash can.
    - Right-click on the icon -> Unpin from Favorites
    - I also pin Chrome to the dock.
    - In Settings -> Ubuntu Desktop -> Dekstop Icons, turn off "Show Home Folder".
    - In Settings -> Ubuntu Desktop -> Dock, turn on "Auto-hide the Dock".

- If you like dark theme, go to Settings -> Appearance -> Style -> Dark.
- In Settings -> Power -> Power Saving, I usually configure it to "Never".
- If you would like Night Shift, go to Settings -> Displays -> Night Light and enable it.

## macOS

- I like a clean Dock, so I remove all the icons from the sidebar.
    - Right-click on the icon -> Options -> Remove from Dock
    - In System Preferences -> Desktop & Dock, I turn on "Automatically hide and show the Dock".

- In System Preferences -> Appearance, I choose "Auto" for the theme.

- To set wallpaper, go to System Preferences -> Wallpaper.

- To set lock screen, go to System Preferences -> Lock Screen.

- I like my functions keys to be the default.
    - Go to System Preferences -> Keyboard -> Keyboard Shortcuts.
    - Choose "Function keys" on the left.
    - Turn on "Use F1, F2, etc. keys as standard function.

---
At this moment, you've finished the setup of the machine. Go back to the
[README](./README.md) to setup another!
