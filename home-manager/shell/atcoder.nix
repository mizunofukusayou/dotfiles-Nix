{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "atcoder";

      text = ''
        code ~/dev/AtCoder
        open -a Arc
        open -a clock.app
      '';
    })
  ];
}
