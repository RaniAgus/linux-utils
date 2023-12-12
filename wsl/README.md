# WSL

## 1Password path

```bash
sudo ln -s "/mnt/c/Users/${USERNAME}/AppData/Local/1Password/app/8/op-ssh-sign.exe" /usr/local/bin/op-ssh-sign.exe
```

## Git configuration

```toml
[core]
        sshCommand = "ssh.exe"
[user]
        name = "Agustin Ranieri"
        email = "aguseranieri@gmail.com"
        signingkey = "ssh-????? ?????"
[gpg]
        format = "ssh"
[commit]
        gpgsign = true
[gpg "ssh"]
        program = "op-ssh-sign.exe"
```
