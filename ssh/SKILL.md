---
name: ssh
description: SSH remote access patterns and utilities for connecting to servers, managing keys, configuring connections, creating tunnels, and transferring files.
---

# SSH Skill

Comprehensive SSH for secure remote access, file transfers, tunneling, and server hardening.

## Basic Connection

Connect to server:
```bash
ssh user@hostname
```

Connect on specific port:
```bash
ssh -p 2222 user@hostname
```

Connect with specific identity:
```bash
ssh -i ~/.ssh/my_key user@hostname
```

## SSH Config

Config file location: `~/.ssh/config`

Create or edit for easier connections:
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cat > ~/.ssh/config << 'EOF'
Host myserver
    HostName 192.168.1.100
    User deploy
    Port 22
    IdentityFile ~/.ssh/myserver_key
    ForwardAgent yes
    ServerAliveInterval 60
EOF
chmod 600 ~/.ssh/config
```

Then connect with just:
```bash
ssh myserver
```

## Key Management

Generate new key (Ed25519, recommended):
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```

Generate RSA key (legacy compatibility):
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

Copy public key to server:
```bash
ssh-copy-id user@host
```

Copy specific key:
```bash
ssh-copy-id -i ~/.ssh/mykey.pub user@host
```

Manual key copy:
```bash
# Display public key
cat ~/.ssh/id_ed25519.pub

# On server, as the user
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys  # Paste public key
chmod 600 ~/.ssh/authorized_keys
```

## SSH Agent

Start agent:
```bash
eval "$(ssh-agent -s)"
```

Add key to agent:
```bash
ssh-add ~/.ssh/id_ed25519
```

Add with macOS keychain:
```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

List loaded keys:
```bash
ssh-add -l
```

## Running Remote Commands

Execute single command:
```bash
ssh user@host "ls -la /var/log"
```

Execute multiple commands:
```bash
ssh user@host "cd /app && git pull && pm2 restart all"
```

Run with pseudo-terminal (for interactive):
```bash
ssh -t user@host "htop"
```

## File Transfer

### SCP

Copy file to remote:
```bash
scp local.txt user@host:/remote/path/
```

Copy file from remote:
```bash
scp user@host:/remote/file.txt ./local/
```

Copy directory recursively:
```bash
scp -r ./local_dir user@host:/remote/path/
```

### rsync (preferred)

Sync directory to remote:
```bash
rsync -avz ./local/ user@host:/remote/path/
```

Sync from remote:
```bash
rsync -avz user@host:/remote/path/ ./local/
```

With progress and compression:
```bash
rsync -avzP ./local/ user@host:/remote/path/
```

Dry run first:
```bash
rsync -avzn ./local/ user@host:/remote/path/
```

## Port Forwarding (Tunnels)

### Local Forward

Access remote service locally:
```bash
ssh -L 8080:localhost:80 user@host
# Now localhost:8080 connects to host's port 80
```

Forward to another host:
```bash
ssh -L 5432:db-server:5432 user@jumphost
# Access db-server:5432 via localhost:5432
```

### Remote Forward

Expose local service to remote:
```bash
ssh -R 9000:localhost:3000 user@host
# Remote's port 9000 connects to your local 3000
```

### Dynamic SOCKS Proxy

```bash
ssh -D 1080 user@host
# Use localhost:1080 as SOCKS5 proxy for network pivoting
```

## Jump Hosts / Bastion

Connect through jump host:
```bash
ssh -J jumphost user@internal-server
```

Multiple jumps:
```bash
ssh -J jump1,jump2 user@internal-server
```

In config file:
```
Host internal
    HostName 10.0.0.50
    User deploy
    ProxyJump bastion
```

## Multiplexing (Connection Sharing)

In ~/.ssh/config:
```
Host *
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist 600
```

Create socket directory:
```bash
mkdir -p ~/.ssh/sockets
```

## Known Hosts

Remove old host key:
```bash
ssh-keygen -R hostname
```

Scan and add host key:
```bash
ssh-keyscan hostname >> ~/.ssh/known_hosts
```

## Common SSH Options

| Option | Description |
|--------|-------------|
| `-p PORT` | Connect to specific port |
| `-X` | Enable X11 forwarding |
| `-L local:remote:port` | Local port forwarding |
| `-R remote:local:port` | Remote port forwarding |
| `-D port` | Dynamic SOCKS proxy |
| `-N` | Don't execute remote command (for tunnels) |
| `-f` | Run in background |
| `-v` | Verbose mode (use -vv, -vvv for more) |

## Debugging

Verbose output:
```bash
ssh -v user@host
```

Very verbose:
```bash
ssh -vv user@host
```

Maximum verbosity:
```bash
ssh -vvv user@host
```

Test SSH config syntax:
```bash
sudo sshd -t
```

Check SSH service status:
```bash
sudo systemctl status sshd
```

## SSH Hardening (Server Side)

### Create Non-Root User

```bash
# Create user
sudo adduser deployer

# Add to sudo group
sudo usermod -aG sudo deployer

# Test sudo access
su - deployer
sudo whoami  # Should output: root
```

### Hardened sshd_config

Edit `/etc/ssh/sshd_config`:

```
# Disable root login
PermitRootLogin no

# Disable password authentication
PasswordAuthentication no

# Disable empty passwords
PermitEmptyPasswords no

# Limit authentication attempts
MaxAuthTries 3

# Allow specific users
AllowUsers deployer

# Use only SSH protocol 2
Protocol 2

# Disable X11 forwarding (unless needed)
X11Forwarding no

# Set login grace time
LoginGraceTime 60

# Disable host-based authentication
HostbasedAuthentication no
```

### Optional Advanced Settings

```
# Change default port (reduces automated scanner noise)
Port 2222

# Disable agent forwarding
AllowAgentForwarding no

# Disable TCP forwarding (if not needed)
AllowTcpForwarding no

# Set idle timeout
ClientAliveInterval 300
ClientAliveCountMax 2
```

### Test and Restart

```bash
# Test configuration
sudo sshd -t

# Restart SSH service
sudo systemctl restart sshd
```

## Security Best Practices

- Use Ed25519 keys (faster, more secure than RSA)
- Set `PasswordAuthentication no` on production servers
- Use `fail2ban` to block brute force attempts
- Keep keys encrypted with passphrases
- Use `ssh-agent` to avoid typing passphrase repeatedly
- Restrict key usage with `command=` in authorized_keys
- Always test new SSH config before restarting (keep session open)
- Use `AllowUsers` or `AllowGroups` to limit access
- Monitor authentication logs: `/var/log/auth.log`
- Rotate SSH keys periodically

## File Permissions

```bash
# Private key (MUST be 600)
chmod 600 ~/.ssh/id_ed25519

# Public key (can be 644)
chmod 644 ~/.ssh/id_ed25519.pub

# SSH directory
chmod 700 ~/.ssh

# Authorized keys
chmod 600 ~/.ssh/authorized_keys

# SSH config
chmod 600 ~/.ssh/config
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Connection refused | Verify SSH running; check firewall; confirm port |
| Auth failed | Check key permissions (600); verify authorized_keys format |
| Host key changed | Remove old entry: `ssh-keygen -R hostname` |
| Tunnel not working | Check `GatewayPorts` in sshd_config; verify firewall |
| Permission denied | Check file permissions; verify user has access |
