# linux-utils
Scripts para instalar las apps que uso

## Shortcuts

### Rofi launcher and SSH
```
rofi -show run
```
```
rofi -show ssh
```
### Execute zsh after exiting ranger
```
gnome-terminal -e "zsh -c '. ranger;zsh'"
```

## Cheatsheet

### Stash only staged files

```bash
git diff --staged --name-only | xargs git stash -m
```

### Import mongo from multiple JSON files

```
$ tree .
.
├── collection1.json
├── collection2.json
└── collection3.json
```

```bash
ls | cut -f1 -d. | xargs -n1 -i -p mongoimport --db $DB_NAME --collection {} --file {}.json
```

### Remove `Ctrl` + `p` keybinding for display switch

- Open `dconf-editor`
- Navigate to org -> gnome -> mutter -> keybindings -> switch-monitor
- Then uncheck the box about using the default value and set the custom value to []
- Restart

### Force dark theme on Chrome
- Go to: [chrome://flags/#enable-force-dark](chrome://flags/#enable-force-dark)

### Repair grub dual boot

```bash
# Install required software
sudo apt install -y os-prober grub-customizer
# Add other OS to grub
sudo os-prober
# Update grub
sudo update-grub
# Check grub configuration
sudo grub-customizer
```
