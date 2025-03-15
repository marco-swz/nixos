{ inputs,config, pkgs, pkgsUnstable, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking = {
        hostName = "notebook";
    };

    system.stateVersion = "23.11";
}

