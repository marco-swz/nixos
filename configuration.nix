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

  networking.hostName = "nix"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    #useXkbConfig = true; 
  };

  # Configure keymap in X11
  services.xserver = {
    #enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    libinput = {
      enable = true;
      touchpad.accelProfile = "flat";
      touchpad.tapping = true;
      mouse.accelProfile = "flat";
    };
  };

  programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        alacritty
        wl-clipboard
        mako
        wdisplays
      ];
  };

  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && exec sway
  '';

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.marco = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gcc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


  services.openssh.enable = true;
  services.pipewire.enable = true;   

  system.stateVersion = "23.05"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  environment.variables = rec {
      EDITOR = "nvim";
  };


}

