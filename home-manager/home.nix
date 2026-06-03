{ config, pkgs, ... }:
{
  imports = [
    ./git/git.nix
    ./vscode/vscode.nix
    ./shell/shell.nix
    ./ssh/ssh.nix
    ./utils/utils.nix
  ];

  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core CLI & Utilities
    go-task

    # Languages & Toolchains
    go
    python313

    # LSPs & Formatters
    nixd
    nixfmt
  ];

  programs.home-manager.enable = true;
}
