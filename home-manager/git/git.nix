{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "mizunofukusayou";
        email = "145898250+mizunofukusayou@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };
}
