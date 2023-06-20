{ config, pkgs, ... }:

{
  home.username = "marco";
  home.homeDirectory = "/home/marco";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    age
    chezmoi
    alacritty    
    neovim
    python311
    python311Packages.pip
    zellij
  ];
}
