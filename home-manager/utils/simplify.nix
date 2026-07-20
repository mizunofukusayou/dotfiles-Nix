{ pkgs, ... }:
let
  antlr4-python3-runtime-472 = pkgs.python3Packages.buildPythonPackage rec {
    pname = "antlr4-python3-runtime";
    version = "4.7.2";
    format = "setuptools";
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      hash = "sha256-Fozc7I+5FS6EqHym/SYbPVTI9jWPQqs7gTsUpxk7tQs=";
    };
    postPatch = ''
      substituteInPlace src/antlr4/Lexer.py \
        --replace-fail "from typing.io import TextIO" "from typing import TextIO"
      substituteInPlace src/antlr4/Parser.py \
        --replace-fail "from typing.io import TextIO" "from typing import TextIO"
    '';
    doCheck = false;
  };

  latex2sympy2 = pkgs.python3Packages.buildPythonPackage rec {
    pname = "latex2sympy2";
    version = "1.9.1";
    format = "wheel";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/0c/9e/4520682ab29a9219f1845643fdc75f1453bebf4b602c6e4421579de1f05d/latex2sympy2-1.9.1-py3-none-any.whl";
      hash = "sha256-RPJNJj0jUWSpEXMWejDUSfQ2Dj8KWSOc5rhDxQpBxgE=";
    };
    propagatedBuildInputs = [
      pkgs.python3Packages.sympy
      antlr4-python3-runtime-472
    ];
    doCheck = false;
  };

  pythonEnv = pkgs.python3.withPackages (ps: [
    latex2sympy2
    ps.sympy
    ps.matplotlib
  ]);

  latexToSympyScript = ./simplify.py;
in
{
  home.shellAliases = {
    "sim" = "simplify";
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "simplify";

      runtimeInputs = [
        pythonEnv
        pkgs.wezterm
        pkgs.coreutils
      ];

      text = ''
        if [ "$#" -gt 0 ]; then
            INPUT="$1"
        else
            INPUT=$(cat)
        fi

        TMP_TXT=$(mktemp)
        trap 'rm -f "$TMP_TXT"' EXIT

        set -o pipefail
        if ! printf "%s\n" "$INPUT" | SIMPLIFY_LATEX_FD=3 python3 ${latexToSympyScript} 3> "$TMP_TXT" | wezterm imgcat; then
            echo "Error: failed to simplify LaTeX expression." >&2
            exit 1
        fi

        LATEX_EXPR=$(cat "$TMP_TXT")
        printf "%s\n" "$LATEX_EXPR"

        # 3. コピーの確認
        while :; do
            printf "Copy LaTeX expression to clipboard? (y/n): "
            read -r -n 1 CONFIRM < /dev/tty
            echo ""

            case "$CONFIRM" in
                [yY])
                    # 注意: Linux環境等で利用する場合は`pbcopy`の差し替えが必要です。
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
