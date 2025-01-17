{ inputs, config, pkgs, pkgsUnstable, ... }:
{
    imports = [
        inputs.home-manager.nixosModules.home-manager
    ];

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

    programs = {
        gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
        };
    };

    security.rtkit.enable = true;

    security.pam.services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
    };

    users.users.marco = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "kvm" "libwirtd" "docker" "plugdev" "dialout" ];
        packages = with pkgs; [];
        shell = pkgs.nushell;
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
        # - USB-to-SPI/I2C adapter
        # - FT232H SPI/I2C adapter
        # - ZSA Voyager
        # - Oryx Webflash
        # - Oryx Webflash
        udev.extraRules = ''
            SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="5512", MODE="0666"
            SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666"
            SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
            KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
            KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
            KERNEL=="ttyUSB[0-9]*",MODE="0666"
            KERNEL=="ttyACM[0-9]*",MODE="0666"
        '';

        udev.packages = [ pkgs.yubikey-personalization ];

        gvfs.enable = true;
        udisks2.enable = true;
        pcscd.enable = true;

        keyd = {
            enable = true;
            keyboards.default.settings = {
                main = {
                    capslock = "layer(control)";
                    tab = "esc";
                };
                control = {
                    h = "left";
                    j = "down";
                    k = "up";
                    l = "right";
                    ";" = "tab";
                    "'" = "S-tab";
                };
            };
        };
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
            gnumake
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
            xorg.xkbcomp
            xorg.setxkbmap
            xorg.xmodmap
            yubikey-manager
            (waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            }))
        ];
    };

    nix = {
        package = pkgs.nix;
        extraOptions = "experimental-features = nix-command flakes";
    };

    hardware = {
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
        graphics = {
            enable = true;
        };
    };
}
