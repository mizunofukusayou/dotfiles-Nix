{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # ==========================================
        # 基本設定・UI
        # ==========================================
        # VSCodeの日本語化
        ms-ceintl.vscode-language-pack-ja

        # インデントに色をつける
        oderwat.indent-rainbow

        # ==========================================
        # ユーティリティ・プレビュー
        # ==========================================
        # コードの自動整形
        esbenp.prettier-vscode

        # 実行ボタン
        formulahendry.code-runner

        # gemini-cliにカレントディレクトリを渡す
        # google.gemini-cli-vscode-ide-companion

        # HTMLをvscode上でプレビューする
        ms-vscode.live-server

        # Markdownのプレビューを強化、pdf出力を可能に
        shd101wyy.markdown-preview-enhanced

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

        # ipynbをVSCodeで動かすための拡張機能
        ms-toolsai.jupyter

        # ipynbファイルで、セルの下にグラフを表示するように
        ms-toolsai.jupyter-renderers

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
      ];

      userSettings = {
        "files" = {
          # 一定時間（デフォルト1秒）後にファイルを自動保存する
          "autoSave" = "afterDelay";
          # 新規ファイルのデフォルト言語をMarkdownに設定
          "defaultLanguage" = "markdown";
        };

        # Code Runner: 実行結果を出力タブではなく、ターミナルに表示する
        "code-runner.runInTerminal" = true;

        "explorer" = {
          # ファイル削除時の確認ダイアログを非表示にする
          "confirmDelete" = false;
          # ファイルのドラッグ＆ドロップ移動時の確認を非表示にする
          "confirmDragAndDrop" = false;
        };

        # ターミナルに複数行を貼り付ける際の警告を無効にする
        "terminal.integrated.enableMultiLinePasteWarning" = "never";

        # GitHub Copilot: 有効化/無効化
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = false;
          "scminput" = false;
        };

        "git" = {
          # 同期（push/pull）時の確認をスキップ
          "confirmSync" = false;
          # 定期的にリモートの変更を自動でチェックする
          "autofetch" = true;
          # ステージング済みのファイルがない場合、全変更をコミットする
          "enableSmartCommit" = true;
        };

        # 差分表示（Diff）で、行末などの空白の違いを無視する
        "diffEditor.ignoreTrimWhitespace" = true;

        # Markdown Preview Enhanced: プレビューのテーマ設定
        "markdown-preview-enhanced" = {
          "previewTheme" = "atom-dark.css";
          "codeBlockTheme" = "auto.css";
        };

        # Go: エラーチェック用のツール群の自動アップデートを有効化
        "go.toolsManagement.autoUpdate" = true;

        # GitHub Copilot: 次の編集候補（Next Edit Suggestions）を有効化
        "github.copilot.nextEditSuggestions.enabled" = true;

        "editor" = {
          # エディタのフォントサイズ
          "fontSize" = 18;
          # エディタのタブ幅を4スペースに設定
          "tabSize" = 4;
          # 保存時にインポートを自動で整理する設定
          "codeActionsOnSave"."source.organizeImports" = "always";
          # Tabキーでタブ文字の代わりにスペースを入力
          "insertSpaces" = true;
          # 保存時に自動でコードを整える設定
          "formatOnSave" = true;
          # Prettierをフォーマッターに使うよう指定
          "defaultFormatter" = "esbenp.prettier-vscode";
        };

        # インデントをスペース4つに
        "prettier.tabWidth" = 4;

        # C/C++ファイルのデフォルトフォーマッタを設定
        "[c]"."editor.defaultFormatter" = "ms-vscode.cpptools";

        "[nix]" = {
          # Nixファイルのデフォルトフォーマッタを設定
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          # インデントを2つに
          "editor.tabSize" = 2;
        };

        # jnoortheen.nix-ideの設定
        "nix" = {
          # フォーマッタ
          "formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";
          # エラーチェック
          "serverPath" = "${pkgs.nixd}/bin/nixd";
        };

        # 情報提供の無効化
        "telemetry.telemetryLevel" = "off";

        # VSCodeからのシステムの変更を無効化
        "update.mode" = "none";
      };
    };
  };
}
