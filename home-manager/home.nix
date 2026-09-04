{ pkgs, ... }:
{
  imports = [
    ./git/git.nix
    ./neovim/neovim.nix
    ./vscode/vscode.nix
    ./shell/shell.nix
    ./ssh/ssh.nix
    ./utils/utils.nix
  ];

  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core CLI & Utilities
    tree
    keepassxc # ローカルパスワード管理

    # Languages & Toolchains
    temurin-bin # Java
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  programs.home-manager.enable = true;
}
