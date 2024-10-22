### Huge WIP

Still learning Nix and NixOS myself but my goal is to eventually make this modular and easy to recreate on any system.

#### General Info
- OS: NixOS
- DE: no desktop environment
- WM: Hyprland (wayland) / i3 (xorg)
- Bar: Waybar, soon will change to custom Fabric-py bar

#### Notes
- The configuration now uses flakes. 
- I am planning to give a proper folder structure to the configuration and make it more modular.


#### TODO

- [ ] Switch the whole `./sources` directory into well structured nix based configs
- [ ] Make the whole config more modular by using the variables in `outputs.(system|user)Settings`
- [ ] Implement an AMD config aswell (which I won't be able to test but if someone is willing to try, please contact me)
- [ ] Implement custom configs for: `nvim`, `emacs` & more rice related things
- [ ] Switch from waybar to a custom made fabric widget (I gotta learn fabric first though lol)
- [ ] Add custom installation scripts, including some for hardening the config files and updating flakes.
- [ ] Slowly make it good enough to turn into a custom ISO with its own installer.
- [ ] Maybe look more into making other boot loaders and display managers work (but currently only GRUB and GDM work for my Hyprland/Wayland on NVIDIA config).
