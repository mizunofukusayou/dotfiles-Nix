# 環境変数、パスの追加、エイリアスなど、シェルの環境をカスタマイズする
{ lib, ... }:
{
  xdg.enable = true;

  home.language = {
    base = "en_US.UTF-8";
    ctype = "ja_JP.UTF-8";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.shellAliases = {
    nix-clean = "home-manager expire-generations '-30 days' && nix profile wipe-history --older-than 30d && nix store gc";
    switch-nix-darwin = "sudo darwin-rebuild switch --flake .";
    switch-home-manager = "home-manager switch --flake .";
    dr = "defaults read";
  };
}
