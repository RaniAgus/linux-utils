# linux-utils
Scripts para instalar las apps que uso

## Shortcuts

```zsh
# Rofi launcher and SSH
rofi -show run
rofi -show ssh

# Execute zsh after exiting ranger
gnome-terminal -e "zsh -c '. ranger;zsh'"
```

## Cheatsheet

- Stash only staged files:

```bash
git diff --staged --name-only | xargs git stash -m
```

- Import mongo from multiple JSON files:

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

- Remove `Ctrl` + `p` keybinding for display switch:

1. Open `dconf-editor`
2. Navigate to org -> gnome -> mutter -> keybindings -> switch-monitor
3. Then uncheck the box about using the default value and set the custom value to []
4. Restart
