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
}
