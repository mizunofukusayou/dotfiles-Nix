{ pkgs, ... }:
let
  # latex2sympy2 (1.9.1) は antlr4-python3-runtime==4.7.2 に固定で依存している。
  # nixpkgs 同梱の antlr4-python3-runtime はもっと新しいバージョン(生成パーサーの
  # シリアライズ形式が違う)なので、互換性のため 4.7.2 を自前でビルドする。
  antlr4-python3-runtime-472 = pkgs.python3Packages.buildPythonPackage rec {
    pname = "antlr4-python3-runtime";
    version = "4.7.2";
    format = "setuptools";
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "168cdcec8fb9152e84a87ca6fd261b3d54c8f6358f42ab3b813b14a7193bb50b";
    };
    # `typing.io` は Python 3.13 で削除された。TextIO は typing 本体に
    # 定義されているため、素直に typing からインポートするよう修正する。
    postPatch = ''
      substituteInPlace src/antlr4/Lexer.py \
        --replace-fail "from typing.io import TextIO" "from typing import TextIO"
      substituteInPlace src/antlr4/Parser.py \
        --replace-fail "from typing.io import TextIO" "from typing import TextIO"
    '';
    doCheck = false;
  };

  # latex2sympy2 は nixpkgs に存在せず、PyPI 上には wheel しか配布されていないため
  # wheel を直接取得してパッケージ化する。
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

  pythonEnv = pkgs.python3.withPackages (ps: [
    latex2sympy2
    ps.sympy
  ]);

  latexToSympyScript = ./latex-to-sympy.py;
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "latex-to-sympy";

      runtimeInputs = [ pythonEnv ];

      text = ''
        if [ "$#" -gt 0 ]; then
            printf "%s\n" "$1"
        else
            cat
        fi | python3 ${latexToSympyScript}
      '';
    })
  ];
}
