# Windows

## Powershell

Ejecutar:
```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
oh-my-posh get shell
New-Item -Path $PROFILE -Type File -Force
notepad $PROFILE
```

Agregar la línea:
```ps1
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/xtoys.omp.json" | Invoke-Expression
```

## Bash
Ejecutar:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sed -i 's/^OSH_THEME=.*/OSH_THEME="sirup"/' ~/.bashrc
```
