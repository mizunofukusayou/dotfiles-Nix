# matlabでjavaを使いたい時に使用するコマンド
# これでアプリを起動後、以下のコマンドを実行して、javaを立ち上げる必要がある。
# `java.lang.String("hello")`
{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "matlab";
      runtimeInputs = [ pkgs.temurin-bin ];
      runtimeEnv = {
        JAVA_HOME = "${pkgs.temurin-bin.home}";
      };
      text = ''
        /Applications/MATLAB_R2026a.app/bin/matlab
      '';
    })
  ];
}
