{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # フォーマッター（自動整形）
      stylua # Lua
      shfmt # Shell スクリプト
      markdownlint-cli2

      # Linter
      statix # Nix

      # LSP サーバー（コード補完・静的解析）
      lua-language-server # Lua (lua_ls)
      nil # Nix
      clang-tools # C / C++ (clangd)
      marksman # Markdown

      # その他
      ripgrep # 高速テキスト検索 (LazyVimの全体検索等に必須)
      fd # 高速ファイル検索 (LazyVimのファイル検索等に必須)
      tree-sitter # 文法ハイライトパーサー用 CLI (tree-sitter-cli)
    ];
  };

  xdg.configFile."nvim".source = ./config;
}
