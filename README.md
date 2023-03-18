# linux-utils
Scripts para instalar las apps que uso.

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

### Change commit author

```bash
grb -i HEAD~N
# Mark all commits for edit and repeat N times:
gcn! --author="Agustin Ranieri <aguseranieri@gmail.com>"
grb --continue
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

### Repair `/boot/efi` dual boot

```bash
# Find Windows efi partition 
sudo fdisk -l

# Mount it
sudo mkdir /mnt/windows
sudo mount /dev/sda1 /mnt/windows

# Copy Windows entry
sudo cp -r /mnt/windows/EFI/Microsoft/ /boot/efi/EFI

# Add starting menu with timeout
printf "timeout 10\nconsole-mode max\n" | sudo tee /boot/efi/loader/loader.conf > /dev/null
```

### Fix dual boot time

```bash
sudo timedatectl set-local-rtc 1
```

### [Auto-Mount Second Hard Drive(s)](https://support.system76.com/articles/extra-drive/)

![image](https://user-images.githubusercontent.com/39303639/224555639-99cc156a-06b1-41db-a1c4-09e66004d269.png)

![image](https://user-images.githubusercontent.com/39303639/224555458-903394ac-e9a0-4309-9ba4-3f05d49d69a2.png)

### Cannot write to secondary drive fix

- [Cannot Write to NTFS in POP OS](https://www.youtube.com/watch?v=N_TgL_uRTNU)
