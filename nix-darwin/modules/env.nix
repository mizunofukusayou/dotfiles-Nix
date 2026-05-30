{ lib, config, ... }:
let
  userName = "mizunofukusayou";
in
{
  options.myEnv = {
    name = lib.mkOption {
      type = lib.types.str;
      default = userName;
    };
  };

  config = {
    users.users.${userName}.home = "/Users/${userName}";
  };
}
