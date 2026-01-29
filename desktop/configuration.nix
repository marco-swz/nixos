{ inputs, config, pkgs, pkgsUnstable, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking = {
        hostName = "desktop";
    };

    hardware = {
        graphics = {
            enable = true;
            enable32Bit = true;
        };
        amdgpu = {
            opencl.enable = true;
        };
    };

    programs = {
        steam = {
            enable = true;
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
            localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        };

    };

    system.stateVersion = "23.11";

    services = {
        lact = {
            enable = true;
        };
    };

    environment = {
        systemPackages = with pkgs; [
            clinfo
        ];
    };
}
