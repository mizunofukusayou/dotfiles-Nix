{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.my.allowUnfree = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "各モジュールから許可したい不自由パッケージのリスト";
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = (
      pkg: builtins.elem (pkgs.lib.getName pkg) config.my.allowUnfree
    );
  };
}
