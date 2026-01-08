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
