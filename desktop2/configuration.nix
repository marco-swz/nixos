{ inputs, config, pkgs, pkgsUnstable, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking = {
        hostName = "desktop2";
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

    services = {
	xserver.enable = true;
        xserver.videoDrivers = ["nvidia"];
    };

    users.users.marco.packages = with pkgs; [
        kdePackages.kate
    ];

    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.printing.enable = true;
    security.rtkit.enable = true;

    system.stateVersion = "24.05";
}
