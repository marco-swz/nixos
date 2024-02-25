{ inputs,config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.home-manager
    ];

    system.stateVersion = "23.11";

    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    networking = {
        hostName = "notebook"; # Define your hostname.
        networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    };

    time.timeZone = "Europe/Vienna";

    i18n.defaultLocale = "en_US.UTF-8";

    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    hardware = {
        bluetooth.enable = true;
        opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
        };
    };

    security.rtkit.enable = true;

    users.users.marco = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "kvm" "libwirtd" "docker" ];
        packages = with pkgs; [];
    };

    environment = {
        variables = {
            EDITOR = "nvim";
        };

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
            nerdfonts
            firefox
            networkmanagerapplet
            udiskie
            bemenu
            zip
            unzip
            docker
            tmux
            pciutils
            (waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            }))
        ];

        loginShellInit = ''
            [[ "$(tty)" == /dev/tty1 ]] && Hyprland
        '';

        etc = {
            "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
                bluez_monitor.properties = {
                    ["bluez5.enable-sbc-xq"] = true,
                    ["bluez5.enable-msbc"] = true,
                    ["bluez5.enable-hw-volume"] = true,
                    ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
                }
            '';
        };
    };


    services = {
        openssh.enable = true;
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
    };

    virtualisation.docker.enable = true;

    nix = {
        package = pkgs.nixFlakes;
        extraOptions = "experimental-features = nix-command flakes";
    };

    home-manager = {
        extraSpecialArgs = { inherit inputs pkgs; };
        users = {
            marco = import ./../../users/marco.nix;
        };
    };
}

