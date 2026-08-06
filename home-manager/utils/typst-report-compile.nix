{
  pkgs,
  config,
  lib,
  ...
}:
let
  output_dir = "${config.home.homeDirectory}/univ/typst-output";
in
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
        export TYPST_PACKAGE_PATH="${config.xdg.dataHome}/typst/packages"
        export TYPST_PACKAGE_CACHE_PATH="${config.xdg.cacheHome}/typst/packages"
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

        output_dir=${output_dir}
        mkdir -p "''$output_dir"
        output_file="''${output_dir}/''${title_prefix}_''${name}.pdf"

        typst compile --input "title=$name" --input "title-prefix=$title_prefix" --input "header-title=$title_prefix" "$file" "$output_file"
      '';
    })
  ];

  # 3:00に`output_dir`にあるファイルを削除する
  launchd.agents.cleanup-typst-output = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.fd}/bin/fd"
        "--max-depth"
        "1"
        "--hidden"
        "--no-ignore"
        "."
        output_dir
        "-X"
        "rm"
        "-rf"
      ];
      StartCalendarInterval = [
        {
          Hour = 3;
          Minute = 0;
        }
      ];
    };
  };

  systemd.user.services.cleanup-typst-output = lib.mkIf pkgs.stdenv.isLinux {
    Unit.Description = "Cleanup typst output directory contents";
    Service.ExecStart = "${pkgs.fd}/bin/fd --max-depth 1 --hidden --no-ignore .${output_dir} -X rm -rf";
  };

  systemd.user.timers.cleanup-typst-output = lib.mkIf pkgs.stdenv.isLinux {
    Unit.Description = "Clean typst output daily at 3am";
    Timer = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
