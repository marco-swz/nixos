{ config, pkgs, ... }:
{
    home.username = "marco";
    home.homeDirectory = "/home/marco";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    home.packages = with pkgs; [
        nnn
        zathura
        age
        chezmoi
        alacritty    
        neovim
        openconnect
        (python311.withPackages(ps: with ps; [
            numpy
            matplotlib
            polars
        ]))
        python311Packages.pip
        nodejs_20
        obsidian
    ];

    programs.alacritty = {
        enable = true;
        settings = ''
            font:
              size: 11
            env:
              TERM: xterm-256color

            # Colors (NightFox)
            colors:
              # Default colors
              primary:
                background: '0x192330'
                foreground: '0xcdcecf'
              # Normal colors
              normal:
                black:   '0x393b44'
                red:     '0xc94f6d'
                green:   '0x81b29a'
                yellow:  '0xdbc074'
                blue:    '0x719cd6'
                magenta: '0x9d79d6'
                cyan:    '0x63cdcf'
                white:   '0xdfdfe0'
              # Bright colors
              bright:
                black:   '0x575860'
                red:     '0xd16983'
                green:   '0x8ebaa4'
                yellow:  '0xe0c989'
                blue:    '0x86abdc'
                magenta: '0xbaa1e2'
                cyan:    '0x7ad5d6'
                white:   '0xe4e4e5'
        '';
    };
}

