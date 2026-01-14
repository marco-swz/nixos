{ inputs, config, pkgs, pkgsUnstable, lib, ... }:
{
    imports = [
        inputs.home-manager.nixosModules.home-manager
    ];

    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    networking = {
        networkmanager.enable = true;
    };

    time.timeZone = "Europe/Vienna";

    i18n.defaultLocale = "en_US.UTF-8";

    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    security = {
        rtkit.enable = true;
        pam = {
            u2f = {
                enable = true;
                settings = {
                    interactive = true;
                    cue = true;
                    origin = "pam://yubi";
                    authfile = pkgs.writeText "u2f-mappings" (lib.concatStrings [
                        "marco"
                        # yubikey-mini
                        ":qgtGIFyJHe1nQDBKaVblvpyWBUAaG3VFndZlCkamSsi7MrAhxifVEgdyuoaT5A+T8K5vGo7ZYLDLHWBb17zYyQ==,ZQ41wptQfqLb0dhvpYSnaeXOUaohAv0NWSssxXX6oXRceuARUNlu8cJ0agFdyyjHE842TWZovX3aT8dDKCakhw==,es256,+presence"
                        # yubikey
                        ":G8xHP1ha6DZUQG8CsOmMdXkPC7CEYr6rEoiJFa7Tfz1xaOjTswA0tnKsmszVsZ8Gn/LuI8ko+1PVw+9LDvkEGw==,7Q2JJ3n3HQH4GHXbW9BIfZsVFL8E9ZByHvmDweo9TtC3rHxPoKbVPPavUNJqFioOFqO6mGS5A0Og5TcJwaxb0g==,es256,+presence"
                    ]);
                };
            };
            services = {
                login.u2fAuth = true;
                sudo.u2fAuth = true;
            };
        };
    };

    users.users.marco = {
        isNormalUser = true;
        shell = pkgs.bashInteractive;
        extraGroups = [ "wheel" "networkmanager" "kvm" "libwirtd" "docker" "plugdev" "dialout" "openrazer"];
        packages = [];
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
        printing.enable = true;

        udev = {
            # - USB-to-SPI/I2C adapter
            # - FT232H SPI/I2C adapter
            # - ZSA Voyager
            # - Oryx Webflash
            # - Oryx Webflash
            extraRules = ''
                SUBSYSTEM=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="5512", MODE="0666"
                SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666"
                SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
                KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
                KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
                KERNEL=="ttyUSB[0-9]*",MODE="0666"
                KERNEL=="ttyACM[0-9]*",MODE="0666"
            '';

            packages = [
                pkgs.yubikey-personalization
                pkgs.libu2f-host
                pkgs.gnome-settings-daemon
            ];
        };

        xserver = {
            enable = true;
            displayManager.gdm.enable = true;
            desktopManager.gnome.enable = true;
        };

        gvfs.enable = true;
        udisks2.enable = true;
        pcscd.enable = true;

        keyd = {
            enable = true;
            keyboards.default = {
                ids = [ 
                    "*" 
                    # These 3 exclude Razer Orbweaver Chroma
                    "-1532:0207:44ff54f0" 
                    "-1532:0207:f22f4c51"
                    "-1532:0207:79813634"
                ];
                settings = {
                    main = {
                        leftalt = "leftcontrol";
                        capslock = "overload(alt, esc)";
                        rightcontrol = "leftalt";
                    };
                    leftcontrol = {
                        h = "left";
                        j = "down";
                        k = "up";
                        l = "right";
                    };
                };
            };
        };

        input-remapper = {
            enable = true;
            serviceWantedBy = [ "multi-user.target" ];
            enableUdevRules = true;
        };
    };

     programs = {
        gnupg.agent = {
            enable = true;
            enableSSHSupport = true;
            enableExtraSocket = true;
        };

        ssh.startAgent = false;
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

        shellInit = ''
            gpg-connect-agent /bye
            export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
            export GPG_TTY="$(tty)"
        '';

        gnome.excludePackages = with pkgs; [
            orca
            evince
            geary
            gnome-backgrounds
            gnome-tour
            gnome-user-docs
            baobab
            epiphany
            gnome-calculator
            gnome-calendar
            gnome-characters
            gnome-console
            gnome-contacts
            gnome-logs
            gnome-maps
            gnome-music
            gnome-weather
            gnome-connections
            simple-scan
            snapshot
            yelp
            gnome-software
        ];

        systemPackages = with pkgs; [
            openssl
            opensc
            pcsc-tools
            libu2f-host
            tree
            vim
            wget
            git
            gnumake
            gcc
            alacritty    
            pkg-config
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
            gnomeExtensions.appindicator 
            gnomeExtensions.dash-to-panel
            gnomeExtensions.bottom-panel
            dconf-editor
            yubikey-manager
            yubikey-personalization
            openrazer-daemon
            polychromatic # frontend for openrazer
        ];
    };

    nix = {
        package = pkgs.nix;
        extraOptions = ''
            experimental-features = nix-command flakes
            trusted-users = root marco
        '';
    };

    hardware = {
        bluetooth.enable = true;
        bluetooth.powerOnBoot = true;
        graphics = {
            enable = true;
        };
        openrazer.enable = true;
    };
}
