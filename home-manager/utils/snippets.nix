{ pkgs, config, ... }:
{
  home.shellAliases = {
    "sn" = "snippets";
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "snippets";

      runtimeInputs = with pkgs; [
        fzf
        jq
      ];

      text = ''
        SNIPPET_FILE="${config.xdg.configHome}/snippets/snippets.jsonl"

        if [ ! -f "$SNIPPET_FILE" ]; then
            echo "Error: Snippet file not found at $SNIPPET_FILE" >&2
            exit 1
        fi

        # 1. fzf の一覧には「タイトル」だけを表示させる
        # 2. 選択されたタイトルの行から、jq を使って生の「コード（改行も保持）」を抽出する
        selected_title=$(jq -r '.title' "$SNIPPET_FILE" | fzf --prompt="Select Snippet: ")

        if [ -n "$selected_title" ]; then
            # 一致するタイトルの code フィールドを生テキスト（-r）として取得
            # 改行コード（\n）はここで本物の改行に自動展開されます
            jq -r --arg title "$selected_title" 'select(.title == $title) .code' "$SNIPPET_FILE" | pbcopy
            
            echo "Copied to clipboard!"
        fi
      '';
    })
  ];
}
