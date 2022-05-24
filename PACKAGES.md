# Packages
The lists of packages that I use on Arch Linux

## Initial Install (work on root env)

### Wireless Network
```sh
pacman -S dhcpcd iwd
systemctl enable dhcpcd.service
systemctl enable iwd.service
```

### Microcode
```sh
pacman -S intel-ucode  ## for Intel
pacman -S amd-ucode    ## for AMD
```

### ETC
```sh
pacman -S neovim zsh git tmux wget
```

## CLI

### AUR Helper: yay
```sh
git clone https://aur.archlinux.org/yay
cd yay && makepkg -is
cd .. && rm -rf yay
```

### Dropbox Client: Maestral
```sh
sudo pacman -S python-virtualenv
```

### Audio
- with pulseaudio
  ```sh
  sudo pacman -S pulseaudio pulseaudio-alsa pamixer pulsemixer
  ```
- with pipewire (compability with pulseaudio)
  ```sh
  sudo pacman -S pipewire-pulse wireplumber pamixer pulsemixer
  ```

### MPD and Clients
```sh
sudo pacman -S mpd mpc ncmpcpp
```

### Program Languages
```sh
# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
```

## Xorg

### Video Driver
```sh
sudo pacman -S nvidia # with nvidia gpu
sudo pacman -S xf86-video-amdgpu # with amd gpu
sudo pacman -S xf86-video-intel # with intel gpu
```

### Xorg Base
```sh
sudo pacman -S xorg-server xorg-xinit
```

### Terminal Emulator: Alacritty
```sh
sudo pacman -S alacritty
```

### Window Manager: Bspwm
```sh
sudo pacman -S bspwm sxhkd picom
```

Install sxhkd-statusd and enable polybar-sxhkd
```sh
sudo pacman -S socat
git clone https://github.com/piutranq/sxhkd-statusd
cd sxhkd-statusd
make
sudo make install
cd .. && rm -rf sxhkd-statusd
```

### Korean IME: KIME
```sh
git clone https://aur.archlinux.com/kime
cd kime
makepkg -is
cd .. && rm -rf kime
```

### Polybar | Rofi | ETC
```sh
sudo pacman -S polybar rofi hsetroot xorg-xsetroot
```

<!-- vim:wrap! -->
