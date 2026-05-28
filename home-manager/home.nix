{ config, pkgs, ... }:

{
  home.username = "mizunofukusayou";
  home.homeDirectory = "/Users/mizunofukusayou";

  imports = [
    ./modules/allowUnfree.nix

    ./git/git.nix
    ./vscode/vscode.nix
    ./shell/shell.nix
  ];

  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;
}
