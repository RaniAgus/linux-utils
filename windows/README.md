# Windows

## Powershell

Ejecutar:
```powershell
# Install oh-my-posh
winget install JanDeDobbeleer.OhMyPosh -s winget

# Install git-aliases
Install-Module git-aliases -Scope CurrentUser -AllowClobber

# Add powershell profile
New-Item -Path $PROFILE -Type File -Force
notepad $PROFILE
```

Y luego agregar la línea:
```ps1
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/xtoys.omp.json" | Invoke-Expression
```

## Bash
Ejecutar:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/^OSH_THEME=.*/OSH_THEME="sirup"/' ~/.bashrc
```
