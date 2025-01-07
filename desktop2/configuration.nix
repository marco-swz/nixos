{ inputs, config, pkgs, pkgsUnstable, ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking = {
        hostName = "desktop2";
    };

    hardware = {
        nvidia = {
            modesetting.enable = true;
            powerManagement.enable = false;
            powerManagement.finegrained = false;
            open = false;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
    };

    services = {
        xserver.enable = true;
        xserver.videoDrivers = ["nvidia"];
        xserver.displayManager.gdm.enable = true;
        xserver.desktopManager.gnome.enable = true;
    };

    #users.users.marco.packages = with pkgs; [
    #    kdePackages.kate
    #];

    environment.gnome.excludePackages = with pkgs; [
        orca
        evince
        # file-roller
        geary
        gnome-disk-utility
        # seahorse
        # sushi
        # sysprof
        #
        # gnome-shell-extensions
        #
        # adwaita-icon-theme
        # nixos-background-info
        gnome-backgrounds
        # gnome-bluetooth
        # gnome-color-manager
        # gnome-control-center
        # gnome-shell-extensions
        gnome-tour # GNOME Shell detects the .desktop file on first log-in.
        gnome-user-docs
        # glib # for gsettings program
        # gnome-menus
        # gtk3.out # for gtk-launch program
        # xdg-user-dirs # Update user dirs as described in https://freedesktop.org/wiki/Software/xdg-user-dirs/
        # xdg-user-dirs-gtk # Used to create the default bookmarks
        #
        baobab
        epiphany
        # gnome-text-editor
        gnome-calculator
        gnome-calendar
        gnome-characters
        # gnome-clocks
        gnome-console
        gnome-contacts
        # gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        # gnome-system-monitor
        gnome-weather
        # loupe
        # nautilus
        gnome-connections
        simple-scan
        snapshot
        # totem
        yelp
        gnome-software
    ];
    #services.displayManager.sddm.enable = true;
    #services.desktopManager.plasma6.enable = true;
    services.printing.enable = true;
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [ 
        gnomeExtensions.appindicator 
        gnomeExtensions.dash-to-panel
        dconf-editor
    ];
    services.udev.packages = [ pkgs.gnome.gnome-settings-daemon ];

    /*
    programs.dconf = {
        enable = true;
        profiles.user.databases = [
            {
                lockAll = true; # prevents overriding
                settings = {
                    "org/gnome/desktop/interface" = {
                        clock-show-weekday = true;
                        color-scheme = "prefer-dark";
                        gtk-theme = "Kanagawa";
                        enable-animations = false;
                        enable-hot-corners = false;
                    };
                    "org/gnome/desktop/peripherals/mouse" = {
                        speed = "0.66666666666666674";
                    };
                    "org/gnome/desktop/wm/keybindings" = {
                        switch-to-workspace-1 = "['<Super>s']";
                        switch-to-workspace-2 = "['<Super>d']";
                        switch-to-workspace-3 = "['<Super>f']";
                        switch-to-workspace-4 = "['<Super>g']";
                        switch-to-workspace-5 = "['<Super>w']";
                        switch-to-workspace-6 = "['<Super>e']";
                        switch-to-workspace-7 = "['<Super>r']";
                        switch-to-workspace-8 = "['<Super>t']";
                        switch-to-workspace-9 = "['<Super>z']";
                        switch-to-workspace-10 = "['<Super>x']";
                        switch-to-workspace-11 = "['<Super>c']";
                        switch-to-workspace-12 = "['<Super>v']";
                        move-to-workspace-1 = "['<Shift><Super>s']";
                        move-to-workspace-2 = "['<Shift><Super>d']";
                        move-to-workspace-3 = "['<Shift><Super>f']";
                        move-to-workspace-4 = "['<Shift><Super>g']";
                        move-to-workspace-5 = "['<Shift><Super>w']";
                        move-to-workspace-6 = "['<Shift><Super>e']";
                        move-to-workspace-7 = "['<Shift><Super>r']";
                        move-to-workspace-8 = "['<Shift><Super>t']";
                        move-to-workspace-9 = "['<Shift><Super>z']";
                        move-to-workspace-10 = "['<Shift><Super>x']";
                        move-to-workspace-11 = "['<Shift><Super>c']";
                        move-to-workspace-12 = "['<Shift><Super>v']";
                        toggle-maximized = "['<Super>Up']";
                    };
                    "org/gnome/desktop/wm/preferences" = {
                        num-workspaces = "12";
                        focus-mode = "mouse";
                    };
                    "org/gnome/desktop/input-sources" = { 
                        sources = "[('xkb', 'us+altgr-intl')]";
                    };
                };
            }
        ];
    };
    */

    system.stateVersion = "24.05";
}
