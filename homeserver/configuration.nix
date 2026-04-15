# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "homeserver"; # Define your hostname.

  networking = {
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 
      8123 
      3003
    ];
    interfaces.enp0s20f0u2c2 = {
      ipv4.addresses = [{
        address = "192.168.254.4";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.254.1";
      interface = "enp0s20f0u2c2";
    };
  };

  #services.nginx = {
  #  recommendedProxySettings = true;
  #  virtualHosts."home-assistant.local" = {
  #    forceSSL = true;
  #    enableACME = true;
  #    extraConfig = ''
  #      proxy_buffering off;
  #    '';
  #    locations."/" = {
  #      proxyPass = "http://[::1]:8123";
  #      proxyWebsockets = true;
  #    };
  #  };
  #};

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';
 
  services = {
    xserver.xkb = {
      layout = "us";
      variant = "altgr-intl";
    };

    home-assistant = {
      enable = true;
      extraComponents = [
        "esphome"
        "met"
        "radio_browser"
        "wiz"
        "zha"
        "default_config"
        "backup"
	"google_translate"
	"isal"
	"analytics"
	"mobile_app"
	"github"
	"nextcloud"
      ];
      config = {
        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        "script ui" = "!include scripts.yaml";
	#http = {
	#  server_host = "::1";
	#  trusted_proxies = [ "::1" ];
	#  use_x_forwarded_for = true;
	#};
      };

    };

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null;
        UseDns = true;
        PermitRootLogin = "yes";
      };
    };

    keyd = {
      enable = true;
      keyboards.default.settings = {
        main = {
          capslock = "overload(lay, esc)";
        };
        lay = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          };
        };
    };

    deluge = {
       enable = true;
       web = {
          enable = true;
          openFirewall = true;
      };
      openFirewall = true;
      dataDir = "/media/deluge/";
    };

    adguardhome = {
      enable = false;
      settings = {
        http = {
          # You can select any ip and port, just make sure to open firewalls where needed
          address = "127.0.0.1:3003";
        };
        dns = {
          upstream_dns = [
            "192.168.254.4:8123#home-assistant.local"
          ];
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;

          safe_search = {
            enabled = false;  # Enforcing "Safe search" option for search engines, when possible.
          };
        };
        # The following notation uses map
        # to not have to manually create {enabled = true; url = "";} for every filter
        # This is, however, fully optional
        filters = map(url: { enabled = true; url = url; }) [
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"  # The Big List of Hacked Malware Web Sites
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"  # malicious url blocklist
        ];
      };
    };
  };

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  users.users.marco = {
    isNormalUser = true;
    description = "marco";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
