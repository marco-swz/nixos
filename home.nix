{ config, pkgs, ... }:

{
  home.username = "marco";
  home.homeDirectory = "/home/marco";
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nnn
    zathura
    age
    chezmoi
    alacritty    
    zellij
    neovim
    openconnect
    (python311.withPackages(ps: with ps; [
        numpy
        matplotlib
        polars
    ]))
    python311Packages.pip
    nodejs_20
    rustup
    go
    zig
  ];
}

