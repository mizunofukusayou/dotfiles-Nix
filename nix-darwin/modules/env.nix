{ lib, config, ... }:
{
  options.myEnv = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "mizunofukusayou";
    };
  };

  config = {
    users.users.${config.myEnv.name}.home = "/Users/${config.myEnv.name}";
  };
}
