{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false; # 拡張機能のインストール先をNixストア内にする(GUIから拡張機能をインストール不可に)

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # ==========================================
        # 基本設定・UI
        # ==========================================
        ms-ceintl.vscode-language-pack-ja # VSCodeの日本語化
        oderwat.indent-rainbow # インデントに色をつける

        # ==========================================
        # ユーティリティ・プレビュー
        # ==========================================
        esbenp.prettier-vscode # コードの自動整形
        # google.gemini-cli-vscode-ide-companion # gemini-cliにカレントディレクトリを渡す
        shd101wyy.markdown-preview-enhanced # Markdownのプレビューを強化、pdf出力を可能に

        # ==========================================
        # 言語サポート: C/C++
        # ==========================================
        # c/c++
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.cpptools-extension-pack

        vadimcn.vscode-lldb # MacOSでcppdbgを使用するとlldb-miniがメモリリークを起こすため、lldbを使用する

        # ==========================================
        # 言語サポート: Python & Jupyter
        # ==========================================
        # python
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        ms-python.vscode-python-envs

        ms-toolsai.jupyter # ipynbをVSCodeで動かすための拡張機能
        ms-toolsai.jupyter-renderers # ipynbファイルで、セルの下にグラフを表示するように

        # ==========================================
        # 言語サポート: Go
        # ==========================================
        # Go言語
        golang.go

        # ==========================================
        # 言語サポート: Nix
        # ==========================================
        # Nix言語
        jnoortheen.nix-ide

        # ==========================================
        # 言語サポート: YAML
        # ==========================================
        # YAML
        redhat.vscode-yaml
      ];

      userSettings = {
        "files" = {
          "autoSave" = "afterDelay"; # 一定時間（デフォルト1秒）後にファイルを自動保存する
          "defaultLanguage" = "markdown"; # 新規ファイルのデフォルト言語をMarkdownに設定
        };
        
        "explorer" = {
          "confirmDelete" = false; # ファイル削除時の確認ダイアログを非表示にする
          "confirmDragAndDrop" = false; # ファイルのドラッグ＆ドロップ移動時の確認を非表示にする
        };

        "terminal.integrated.enableMultiLinePasteWarning" = "never"; # ターミナルに複数行を貼り付ける際の警告を無効にする

        # GitHub Copilot: 有効化/無効化
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = false;
          "scminput" = false;
          "markdown" = true;
        };

        "git" = {
          "confirmSync" = false; # 同期（push/pull）時の確認をスキップ
          "autofetch" = true; # 定期的にリモートの変更を自動でチェックする
          "enableSmartCommit" = true; # ステージング済みのファイルがない場合、全変更をコミットする
        };

        "diffEditor.ignoreTrimWhitespace" = true; # 差分表示（Diff）で、行末などの空白の違いを無視する

        # Markdown Preview Enhanced: プレビューのテーマ設定
        "markdown-preview-enhanced" = {
          "previewTheme" = "atom-dark.css";
          "codeBlockTheme" = "auto.css";
        };

        "go.toolsManagement.autoUpdate" = true; # Go: エラーチェック用のツール群の自動アップデートを有効化

        "github.copilot.nextEditSuggestions.enabled" = true; # GitHub Copilot: 次の編集候補（Next Edit Suggestions）を有効化

        "editor" = {
          "fontSize" = 18; # エディタのフォントサイズ
          "tabSize" = 4; # エディタのタブ幅を4スペースに設定
          "codeActionsOnSave"."source.organizeImports" = "always"; # 保存時にインポートを自動で整理する設定
          "insertSpaces" = true; # Tabキーでタブ文字の代わりにスペースを入力
          "formatOnSave" = true; # 保存時に自動でコードを整える設定
          "defaultFormatter" = "esbenp.prettier-vscode"; # Prettierをフォーマッターに使うよう指定
        };

        "prettier.tabWidth" = 4; # インデントをスペース4つに

        "[c]"."editor.defaultFormatter" = "ms-vscode.cpptools"; # C/C++ファイルのデフォルトフォーマッタを設定

        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide"; # Nixファイルのデフォルトフォーマッタを設定
          "editor.tabSize" = 2; # インデントを2つに
        };

        # jnoortheen.nix-ideの設定
        "nix" = {
          "formatterPath" = "${pkgs.nixfmt}/bin/nixfmt"; # フォーマッタ
          "serverPath" = "${pkgs.nixd}/bin/nixd"; # エラーチェック
        };

        "[yaml]" = {
          "editor.tabSize" = 2; # YAMLファイルのインデントをスペース2つに
          "prettier.tabWidth" = 2; # YAMLファイルのインデントをスペース2つに
        };

        # redhat.vscode-yamlの設定
        "yaml.format.enable" = false; # redhat.vscode-yamlのフォーマットを無効化
        "redhat.telemetry.enabled" = false; # redhat.vscode-yamlの情報提供の無効化

        "telemetry.telemetryLevel" = "off"; # 情報提供の無効化

        "update.mode" = "none"; # VSCodeからのシステムの変更を無効化
      };
    };
  };
}
