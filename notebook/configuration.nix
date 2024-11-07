{ inputs,config, pkgs, pkgsUnstable, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking = {
        hostName = "notebook";
    };

    programs.hyprland = {
        #package = pkgsUnstable.hyprland;
        enable = true;
        xwayland.enable = true;
    };

    system.stateVersion = "23.11";
}

