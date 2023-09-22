{ config, pkgs, ... }:

{
  home.username = "marco";
  home.homeDirectory = "/home/marco";
  home.stateVersion = "22.05";
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
    python311
    python311Packages.pip
    nodejs_20
    cargo
    go
    zig
  ];
}

