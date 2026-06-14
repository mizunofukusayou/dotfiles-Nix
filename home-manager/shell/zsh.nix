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
  };
}
