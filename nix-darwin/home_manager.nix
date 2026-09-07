{ userName, self, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${userName} = ../home-manager/home.nix;
    extraSpecialArgs = {
      inherit userName;
      inherit self;
    };
  };
  users.users.${userName}.home = "/Users/${userName}";
}
