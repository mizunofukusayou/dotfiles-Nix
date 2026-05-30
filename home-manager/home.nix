{ config, pkgs, ... }:

{
  imports = [
    ./modules/allowUnfree.nix

    ./git/git.nix
    ./vscode/vscode.nix
    ./shell/shell.nix
  ];

  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    nixd
    nixfmt
    brave
  ];

  programs.home-manager.enable = true;
}
