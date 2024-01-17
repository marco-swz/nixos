{ inputs, config, pkgs, pkgs2205, ... }:

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

    hardware = {
        opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
        };

        bluetooth.enable = true;
        nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
    };

    networking = {
        hostName = "desktop"; # Define your hostname.
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

    security.rtkit.enable = true;

    users.users.marco = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "kvm" "libwirtd" "docker" ];
        packages = with pkgs; [];
    };

    virtualisation.docker.enable = true;

    services = {
        openssh.enable = true;
        xserver.videoDrivers = ["nvidia"];
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
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
    };

    nix = {
        package = pkgs.nixFlakes;
        extraOptions = "experimental-features = nix-command flakes";
    };

    home-manager = {
        extraSpecialArgs = { inherit inputs pkgs pkgs2205; };
        users = {
            marco = import ./../../users/marco.nix;
        };
    };
}

