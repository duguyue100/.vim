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

---
At this moment, you've finished the setup of the machine. Go back to the
[README](../README.md) to setup another!
