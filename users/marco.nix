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
        clang-tools
        glibc
        thunderbird
    ];
}

