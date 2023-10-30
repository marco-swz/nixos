{ config, pkgs, ... }:
{
    home.username = "work";
    home.homeDirectory = "/home/work";
    home.stateVersion = "23.05";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        nnn
        zathura
        age
        chezmoi
        neovim
        (python311.withPackages(ps: with ps; [
            numpy
            matplotlib
            polars
        ]))
        python311Packages.pip
        flutter37-unwrapped
        obsidian
        teams
    ];
}

