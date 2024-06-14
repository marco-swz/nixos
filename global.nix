{ inputs, config, pkgs, pkgsUnstable, ... }:
{
    imports = [
        inputs.home-manager.nixosModules.home-manager
    ];

    system.stateVersion = "23.11";

    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    networking = {
        networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    };

    time.timeZone = "Europe/Vienna";

    i18n.defaultLocale = "en_US.UTF-8";

    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    programs.hyprland = {
        package = pkgsUnstable.hyprland;
        enable = true;
        xwayland.enable = true;
    };

    security.rtkit.enable = true;

    users.users.marco = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "kvm" "libwirtd" "docker" ];
        packages = with pkgs; [];
    };

    virtualisation.docker.enable = true;

    services = {
        openssh.enable = true;
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
        pipewire.wireplumber = {
            enable = true;
        };
        # For the USB - SPI/I2C adapter
        udev.extraRules = ''
            SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="5512", MODE:="0666"
        '';
    };

    environment = {
        variables = {
            # To prevent invisible cursor on wayland
            WLR_NO_HARDWARE_CURSORS = "1";
            # Hint electron apps to use wayland
            NIXOS_OZONE_WL = "1";
        };

        loginShellInit = ''
            [[ "$(tty)" == /dev/tty1 ]] && Hyprland
        '';

        systemPackages = with pkgs; [
            tree
            vim
            wget
            git
            gcc
            alacritty    
            pkg-config
            openssl
            pavucontrol
            firefox
            networkmanagerapplet
            udiskie
            bemenu
            zip
            unzip
            pciutils
            home-manager
            wl-clipboard
            (waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            }))
        ];
    };

    nix = {
        package = pkgs.nixFlakes;
        extraOptions = "experimental-features = nix-command flakes";
    };

    hardware = {
        bluetooth.enable = true;
        opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
        };
    };
}
