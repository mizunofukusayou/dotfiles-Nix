{ userName, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${userName} = ../home-manager/home.nix;
    extraSpecialArgs = { inherit userName; };
  };
  users.users.${userName}.home = "/Users/${userName}";
}
