{ config, pkgs, ... }:

{
imports =
    [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    #boot.loader.grub = {
    #   enable = true;
    #  configurationLimit = 5;
    #   device = "nodev";
    #   efiSupport = true;
    #};
    
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "notebook"; # Define your hostname.
    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    time.timeZone = "Europe/Vienna";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

    programs.hyprland = {
        enable = true;

        xwayland = {
            enable = true;
        };
    };

    programs.waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
    };

    environment.loginShellInit = ''
        [[ "$(tty)" == /dev/tty1 ]] && Hyprland
    '';

    hardware.bluetooth.enable = true;

    # Enable sound.
    #sound.enable = true;
    #hardware.pulseaudio.enable = true;

    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        #jack.enable = true;
    };

    environment.etc = {
        "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
            bluez_monitor.properties = {
                ["bluez5.enable-sbc-xq"] = true,
                ["bluez5.enable-msbc"] = true,
                ["bluez5.enable-hw-volume"] = true,
                ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
            }
        '';
    };


    users.users.marco = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "kvm" "libwirtd" "docker" ];
        packages = with pkgs; [];
    };
    users.users.work = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "kvm" "libwirtd" "docker" ];
        packages = with pkgs; [];
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
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
    ];

    virtualisation.docker.enable = true;

    services.openssh.enable = true;

    system.stateVersion = "unstable";

    nix = {
        package = pkgs.nixFlakes;
        extraOptions = "experimental-features = nix-command flakes";
    };
    nixpkgs.config.allowUnfree = true;

    environment.variables = rec {
        EDITOR = "nvim";
    };


}

