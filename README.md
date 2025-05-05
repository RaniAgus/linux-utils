# linux-utils
Scripts para instalar las apps que uso.

## `zsh` Plugins

```sh
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
```

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

### Replace spaces with dashes (all files in folder)

```
rename -n 's/ /-/g' *
```

### Check video durations (all files in folder)
```sh
ls | xargs -n1 -I {} ffmpeg -i {} 2>&1 | grep "Duration:"
```

### Change commit author

```bash
grb -i HEAD~N
# Mark all commits for edit and repeat N times:
gcn! --author="Agustin Ranieri <aguseranieri@gmail.com>"
grb --continue
```

### Fix file permissions
```bash
git diff --name-only | xargs -i chmod 644 "{}"
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

# Remove "noprompt" from linux entry
sudo sed -i 's/ noprompt / /g' /boot/efi/EFI/Pop_OS-*/cmdline

# Add starting menu with timeout
printf "timeout 10\nconsole-mode max\n" | sudo tee /boot/efi/loader/loader.conf > /dev/null
```
Ref:
- [Pop_OS_Dual_Boot.md](https://github.com/spxak1/weywot/blob/main/Pop_OS_Dual_Boot.md#3222-install-windows-without-planning-for-pop_os-easier-and-most-common-for-users-already-having-windows-installed)
- [loader.conf](https://www.freedesktop.org/software/systemd/man/latest/loader.conf.html)

### Fix dual boot time

```bash
sudo timedatectl set-local-rtc 1
```

### [Auto-mount secondary hard drive](https://support.system76.com/articles/extra-drive/)

![image](https://user-images.githubusercontent.com/39303639/224555639-99cc156a-06b1-41db-a1c4-09e66004d269.png)

![image](https://user-images.githubusercontent.com/39303639/224555458-903394ac-e9a0-4309-9ba4-3f05d49d69a2.png)

### [Fix secondary drive permissions on dual boot](https://www.youtube.com/watch?v=N_TgL_uRTNU)

![image](https://user-images.githubusercontent.com/39303639/226109148-81b7f700-b930-40a5-85a8-5c77fb26d65f.png)

### [Convert GitHub App private key to PKCS8 private key](https://stackoverflow.com/questions/8290435/convert-pem-traditional-private-key-to-pkcs8-private-key)

```
openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in pkcs1.key -out pkcs8.key
```

### Generate random string

```
ruby -rsecurerandom -e 'puts SecureRandom.hex(32)'
```

### [Pair Bluetooth Devices on dual boot](https://unix.stackexchange.com/questions/255509/bluetooth-pairing-on-dual-boot-of-windows-linux-mint-ubuntu-stop-having-to-p)

1. Pair all devices with Ubuntu

2. Pair all devices with Windows

3. Go back to Ubuntu

4. Mount Windows device

5. Go to `Windows/System32/config`

6. Get all devices' pairing keys:
```bash
chntpw -e SYSTEM # this will open a console
```
```bash
cd \ControlSet001\Services\BTHPORT\Parameters\Keys
ls # shows you your Bluetooth port's MAC address
```
```
Node has 1 subkeys and 0 values
  key name
  <aa1122334455>
```
```bash
cd aa1122334455 # cd into that folder
ls  # list the existing devices' MAC addresses
```
```
Node has 0 subkeys and 1 values
  size     type            value name             [value if type DWORD]
    16  REG_BINARY        <00aa22ee4455>
```
```bash
hex 00aa22ee4455 # open the value for that MAC address
```
```
=> :00000 XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX XX .................
```

7. Rewrite the pairing keys in Linux config files:

```bash
sudo su # run as superuser
cd /var/lib/bluetooth/
ls # list all pairing keys
nano "00:AA:22:EE:44:55/info"
```

```config
[LinkKey]
Key=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

8. Restart bluetooth service:

```bash
sudo systemctl restart bluetooth
```

## [Fix bluetooth keyboard issues](https://askubuntu.com/a/1350323)

1. Open both blueman applet and:
```
bluetoothctl
```

2. In the applet, remove device if paired
3. In the cli, set:

```
pairable on
discoverable on
agent on
default-agent
show
```

4. Start pairing in the keyboard, and use the applet to connect

5. In the applet, set device as trusted

6. Cleanup settings

```
agent off
pairable off
discoverable off
```
