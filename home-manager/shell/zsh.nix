{ config, ... }:
{
  programs.zsh = {
    enable = true;

    enableCompletion = true; # 補完を有効にする
    syntaxHighlighting.enable = true; # シンタックスハイライトを有効にする
    autosuggestion.enable = true; # 入力補完を有効にする

    # 履歴の部分一致検索を有効にする
    historySubstringSearch = {
      enable = true;
      searchUpKey = [ "^j" ]; # 上矢印キー
      searchDownKey = [ "^k" ]; # 下矢印キー
    };

    # コマンド履歴の設定
    history = {
      size = 50000;
      save = 100000;
      path = "${config.xdg.stateHome}/zsh/history";
      share = true;
      ignoreDups = true;
      saveNoDups = true;
      ignoreSpace = true;
      extended = true;
    };

    setOptions = [
      "NO_BEEP"
      "CORRECT"
    ];

    # pdftocairoを使ってPDFの特定ページをSVGに変換する関数
    initContent = ''
      # PDFの特定ページをSVGに変換する関数
      # 使い方: pdf2svg <入力ファイル> <ページ番号>
      # 例: pdf2svg input.pdf 3  ->  input-3.svg が生成される
      pdf2svg() {
        if [ "$#" -ne 2 ]; then
          echo "ユーザーエラー: 引数の数が足りません。"
          echo "使い方: pdf2svg <入力ファイル> <ページ番号>"
          return 1
        fi

      # 入力ファイル名から拡張子（.pdfなど）を取り除く（例: input.pdf -> input）
      local base_name="''${1%.*}"

      pdftocairo -svg -f "$2" -l "$2" "$1" "$base_name-$2.svg"
      }
    '';
  };
}
