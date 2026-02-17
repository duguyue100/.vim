## Start a OpenCode Docker

Run the docker compose file from this folder:

```bash
docker compose up -d
```

This `docker-composw.yml` file will start the OpenCode server and broadcast it on port 4096.
If you are using Tailscale, you can access it from any device connected to your Tailscale network.

The session and all configs will be saved in a local folder called `opencode-data`.
