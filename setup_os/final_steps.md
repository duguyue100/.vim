# SSH config

If there is no `~/.ssh` folder, create one.
```bash
mkdir -p ~/.ssh
```

Create new SSH key using the following command:
```bash
ssh-keygen -t ed25519 -C "<your-email>"
```

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
