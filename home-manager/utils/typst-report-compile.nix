{ pkgs, ... }:
{
  home.shellAliases = {
    repo = "typst-report-compile";
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "typst-report-compile";
      runtimeInputs = [
        pkgs.typst
        pkgs.coreutils
      ];
      text = ''
        if [[ $# -eq 0 ]]; then
          echo "使い方: $(basename "$0") <file.typ>" >&2
          exit 1
        fi

        file="$1"

        base=$(basename "$file")
        base="''${base%.*}"

        title_prefix=$(basename "$(pwd)")

        if [[ "$base" =~ ^[0-9]+$ ]]; then
          n=$((10#$base))
          name="第''${n}回レポート"
        else
          name="$base"
        fi

        output_dir="$HOME/univ/tmp"
        mkdir -p "''$output_dir"
        output_file="''${output_dir}/''${title_prefix}_''${name}.pdf"

        typst compile --input "title=$name" --input "title-prefix=$title_prefix" --input "header-title=$title_prefix" "$file" "$output_file"
      '';
    })
  ];
}
