# default.nix または home-manager の設定ファイル
{ pkgs, ... }:
let
  # antlr4-python3-runtime-472 の定義はそのまま維持
  antlr4-python3-runtime-472 = pkgs.python3Packages.buildPythonPackage rec {
    pname = "antlr4-python3-runtime";
    version = "4.7.2";
    format = "setuptools";
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "168cdcec8fb9152e84a87ca6fd261b3d54c8f6358f42ab3b813b14a7193bb50b";
    };
    postPatch = ''
      substituteInPlace src/antlr4/Lexer.py \
        --replace-fail "from typing.io import TextIO" "from typing import TextIO"
      substituteInPlace src/antlr4/Parser.py \
        --replace-fail "from typing.io import TextIO" "from typing import TextIO"
    '';
    doCheck = false;
  };

  # latex2sympy2 の定義はそのまま維持
  latex2sympy2 = pkgs.python3Packages.buildPythonPackage rec {
    pname = "latex2sympy2";
    version = "1.9.1";
    format = "wheel";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/0c/9e/4520682ab29a9219f1845643fdc75f1453bebf4b602c6e4421579de1f05d/latex2sympy2-1.9.1-py3-none-any.whl";
      sha256 = "44f24d263d235164a91173167a30d449f4360e3f0a59239ce6b843c50a41c601";
    };
    propagatedBuildInputs = [
      pkgs.python3Packages.sympy
      antlr4-python3-runtime-472
    ];
    doCheck = false;
  };

  # 【修正】ps.matplotlib を追加
  pythonEnv = pkgs.python3.withPackages (ps: [
    latex2sympy2
    ps.sympy
    ps.matplotlib
  ]);

  latexToSympyScript = ./latex-to-sympy.py;
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "latex-to-sympy";

      runtimeInputs = [
        pythonEnv
        pkgs.wezterm
        pkgs.gnused # バイナリを壊さず安全に切り出すために gnused を追加
      ];

      text = ''
        if [ "$#" -gt 0 ]; then
            INPUT="$1"
        else
            INPUT=$(cat)
        fi

        TMP_OUT=$(mktemp)
        trap 'rm -f "$TMP_OUT"' EXIT

        printf "%s\n" "$INPUT" | python3 ${latexToSympyScript} > "$TMP_OUT"

        # 1. デリミタの直前まで（数式テキスト）を抽出して表示・格納
        LATEX_EXPR=$(sed '/---PNG_START---/,$d' "$TMP_OUT")
        printf "%s\n" "$LATEX_EXPR"

        # 2. デリミタの直後から（PNGバイナリ）を imgcat に流し込む
        sed '1,/---PNG_START---/d' "$TMP_OUT" | wezterm imgcat

        # 3. コピーの確認
        while :; do
            printf "Copy LaTeX expression to clipboard? (y/n): "
            read -r CONFIRM < /dev/tty

            case "$CONFIRM" in
                [yY])
                    printf "%s" "$LATEX_EXPR" | pbcopy
                    echo "Copied to clipboard!"
                    break
                    ;;
                [nN])
                    echo "Canceled."
                    break
                    ;;
                *)
                    echo "Invalid input. Please enter 'y' or 'n'."
                    ;;
            esac
        done
      '';
    })
  ];
}
