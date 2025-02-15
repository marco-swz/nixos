{ inputs, config, pkgs, pkgsUnstable, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking = {
        hostName = "desktop";
    };

    hardware = {
        nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
    };

    programs.hyprland = {
        #package = pkgsUnstable.hyprland;
        enable = true;
        xwayland.enable = true;
    };

    services = {
        xserver.videoDrivers = ["nvidia"];
    };

    system.stateVersion = "23.11";
}
