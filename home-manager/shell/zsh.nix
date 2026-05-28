{ config, ... }:
{
  programs.zsh = {
    enable = true;

    # 補完を有効にする
    enableCompletion = true;

    # シンタックスハイライトを有効にする
    syntaxHighlighting.enable = true;

    # 入力補完を有効にする
    autosuggestion.enable = true;

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
