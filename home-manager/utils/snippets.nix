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

        selected_title=$(jq -r '.title' "$SNIPPET_FILE" | fzf --prompt="Select Snippet: ")

        if [ -n "$selected_title" ]; then
            # 注意: Linux環境等で利用する場合は`pbcopy`の差し替えが必要です。
            selected_code=$(jq -r --arg title "$selected_title" 'select(.title == $title) .code' "$SNIPPET_FILE")

            echo "$selected_code"
            echo "$selected_code" | pbcopy
        fi
      '';
    })
  ];
}
