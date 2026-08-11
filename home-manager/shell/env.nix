# 環境変数、パスの追加、エイリアスなど、シェルの環境をカスタマイズする
{ pkgs, ... }:
{
  xdg.enable = true;

  home = {
    language = {
      base = "en_US.UTF-8";
      ctype = "ja_JP.UTF-8";
    };

    sessionVariables = {
      EDITOR = "nvim";
      JAVA_HOME = "${pkgs.temurin-bin.home}";
      MATLAB_JAVA = "$JAVA_HOME";
    };

    shellAliases = {
      dr = "defaults read";
      yy = "pbcopy";
      diff = "code -d";
      github = "gh repo view -w";
    };
  };
}
