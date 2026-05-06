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

   nixarr = {
    enable = true;
    # These two values are also the default, but you can set them to whatever
    # else you want
    # WARNING: Do _not_ set them to `/home/user/whatever`, it will not work!
    mediaDir = "/data/media";
    stateDir = "/data/media/.state/nixarr";

    vpn = {
      enable = false;
      # WARNING: This file must _not_ be in the config git directory
      # You can usually get this wireguard file from your VPN provider
      wgConf = "/data/.secret/wg.conf";
    };

    jellyfin = {
      enable = true;
      openFirewall = true;
    };

    transmission = {
      enable = true;
      # vpn.enable = true;
      peerPort = 51820; # Set this to the port forwarded by your VPN
    };

    bazarr.enable = true;
    lidarr = {
      enable = true;
      openFirewall = true;
    };
    radarr.enable = true;
    sonarr.enable = true;
    seerr.enable = true;

      # --- Declarative Prowlarr Settings ---
    prowlarr = {
      enable = true;
      openFirewall = true;

      # settings-sync = {
        # Automatically sync all enabled Nixarr apps to Prowlarr.
        # This adds Sonarr, Radarr, Lidarr, and Readarr as applications
        # with the correct URLs and API keys — no manual setup needed.
        # enable-nixarr-apps = true;

        # Define tags for organizing indexers
        # tags = [ "usenet" "torrent" "private" ];

        # Define indexers directly in Nix
        # indexers = [
        #   {
        #     sort_name = "nzbgeek";
        #     tags = [ "usenet" ];
        #     fields = {
        #       # Secrets are read from files at runtime, not stored in the Nix store
        #       apiKey.secret = "/data/.secret/nzbgeek-api-key";
        #     };
        #   }
        #   {
        #     sort_name = "torznab";
        #     name = "Jackett";
        #     tags = [ "torrent" ];
        #     fields = {
        #       baseUrl = "http://localhost:9117/api/v2.0/indexers/all/results/torznab/";
        #       apiKey.secret = "/data/.secret/jackett-api-key";
        #     };
        #   }
        # ];
      # };
    };

    # --- Declarative Sonarr Download Clients ---
    # sonarr.settings-sync = {
    #   # Automatically configure Transmission as a download client.
    #   # Uses the correct port and localhost (works even across VPN boundaries
    #   # because Nixarr sets up nginx proxies automatically).
    #   transmission.enable = true;
    # };

    # # --- Declarative Radarr Download Clients ---
    # radarr.settings-sync = {
    #   transmission.enable = true;
    # };

    # # --- Declarative Bazarr Connections ---
    # bazarr.settings-sync = {
    #   # Automatically configure the Sonarr connection in Bazarr.
    #   # API keys and ports are filled in from Nixarr's configuration.
    #   sonarr.enable = true;
    #   sonarr.config = {
    #     # Optionally only sync subtitles for monitored content
    #     sync_only_monitored_series = true;
    #     sync_only_monitored_episodes = true;
    #   };

    #   # Same for Radarr
    #   radarr.enable = true;
    #   radarr.config = {
    #     sync_only_monitored_movies = true;
    #   };
    # };
  };

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
    helix
    zellij
  ];

  system.stateVersion = "25.05"; # Did you read the comment?
}
