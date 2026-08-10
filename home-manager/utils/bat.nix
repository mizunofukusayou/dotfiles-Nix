{ pkgs, ... }:

{
  programs.bat = {
    enable = true;

    # 必須級の追加パッケージ
    extraPackages = with pkgs.bat-extras; [
      batman # manページをbatで綺麗に表示 (batman)
      batgrep # batのハイライト付きでripgrep検索 (batgrep)
      batdiff # git diffをbatで綺麗に表示 (batdiff)
    ];

    config = {
      # カラートラブルを防ぎ、常に構文強調を有効化
      color = "always";

      # カラーステーマの指定 (catppuccin-mocha, TwoDark, Nord なども人気)
      theme = "TwoDark";

      # ヘッダーや行番号のスタイル設定 (必要に応じて選定)
      # "full" (デフォルト), "plain" (飾り枠なし), "numbers,changes" (行番号とGit変更のみ)
      style = "numbers,changes,header";
    };
  };
}
