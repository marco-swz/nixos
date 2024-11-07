{ inputs, config, pkgs, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";

    networking.hostName = "nix"; 

    programs.hyprland = {
        #package = pkgsUnstable.hyprland;
        enable = true;
        xwayland.enable = true;
    };

    system.stateVersion = "23.11";
}

