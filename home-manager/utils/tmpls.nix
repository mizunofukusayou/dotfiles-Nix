{ pkgs, self, ... }:
{
  home.shellAliases = {
    "tm" = "tmpls";
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "tmpls";

      runtimeInputs = with pkgs; [
        fzf
        fd
        coreutils
      ];

      text = ''
        template_dir="${self.outPath}/home-manager/utils/tmpls"

        # fzf のキャンセル時に set -e で異常終了しないよう || true を付与
        selected=''$(fd -t f --base-directory "''${template_dir}" | fzf || true)

        if [ -n "''${selected}" ]; then
          cp --no-preserve=mode "''${template_dir}/''${selected}" .
        fi
      '';
    })
  ];
}
