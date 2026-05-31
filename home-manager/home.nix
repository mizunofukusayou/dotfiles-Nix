{ config, pkgs, ... }:

{
  imports = [
    ./git/git.nix
    ./vscode/vscode.nix
    ./shell/shell.nix
    ./ssh/ssh.nix
  ];

  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    nixd
    nixfmt
    brave
    go-task
  ];

  programs.home-manager.enable = true;
}
