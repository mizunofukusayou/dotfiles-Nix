{ config, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${config.myEnv.name} = ../home-manager/home.nix;
}
