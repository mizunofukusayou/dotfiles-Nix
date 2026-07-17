{ pkgs, ... }:
let
  pdf2svg = pkgs.writeShellApplication {
    name = "pdf2svg";

    runtimeInputs = [
      pkgs.poppler-utils
      pkgs.coreutils # mkdir などを確実に動かすため
    ];

    text = ''
      if [ "$#" -ne 2 ]; then
          echo "ユーザーエラー: 引数の数が足りません。"
          echo "使い方: pdf2svg <入力ファイル> <ページ番号>"
          exit 1
      fi

      base_name="''${1%.*}"
      mkdir -p "$base_name"

      pdftocairo -svg -f "$2" -l "$2" "$1" "$base_name/$2.svg"
    '';
  };
in
{
  home.packages = [
    pdf2svg
  ];
}
